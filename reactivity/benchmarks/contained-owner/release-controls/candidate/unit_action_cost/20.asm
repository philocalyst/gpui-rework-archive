
/tmp/gpui-contained-owner-spike-target/release/deps/unit_action_cost-bcf457ce7db1ee75:     file format elf64-x86-64


Disassembly of section .text:

00000000007081c0 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing>:
  7081c0:	55                   	push   %rbp
  7081c1:	41 57                	push   %r15
  7081c3:	41 56                	push   %r14
  7081c5:	41 55                	push   %r13
  7081c7:	41 54                	push   %r12
  7081c9:	53                   	push   %rbx
  7081ca:	48 81 ec c8 03 00 00 	sub    $0x3c8,%rsp
  7081d1:	4d 89 c4             	mov    %r8,%r12
  7081d4:	49 89 cf             	mov    %rcx,%r15
  7081d7:	49 89 f6             	mov    %rsi,%r14
  7081da:	48 89 fb             	mov    %rdi,%rbx
  7081dd:	41 83 38 02          	cmpl   $0x2,(%r8)
  7081e1:	75 08                	jne    7081eb <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x2b>
  7081e3:	41 c6 86 1f 07 00 00 	movb   $0x1,0x71f(%r14)
  7081ea:	01 
  7081eb:	4d 85 ff             	test   %r15,%r15
  7081ee:	0f 84 94 01 00 00    	je     708388 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1c8>
  7081f4:	41 80 be 1e 07 00 00 	cmpb   $0x1,0x71e(%r14)
  7081fb:	01 
  7081fc:	0f 85 86 01 00 00    	jne    708388 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1c8>
  708202:	49 8b 86 28 02 00 00 	mov    0x228(%r14),%rax
  708209:	49 8d 8e 30 02 00 00 	lea    0x230(%r14),%rcx
  708210:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  708214:	48 8d 74 24 78       	lea    0x78(%rsp),%rsi
  708219:	48 0f 44 ce          	cmove  %rsi,%rcx
  70821d:	f3 0f 6f 01          	movdqu (%rcx),%xmm0
  708221:	66 0f 7f 84 24 60 01 	movdqa %xmm0,0x160(%rsp)
  708228:	00 00 
  70822a:	74 45                	je     708271 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0xb1>
  70822c:	66 0f 6f 84 24 60 01 	movdqa 0x160(%rsp),%xmm0
  708233:	00 00 
  708235:	f3 0f 7f 84 24 c8 01 	movdqu %xmm0,0x1c8(%rsp)
  70823c:	00 00 
  70823e:	0f b6 8c 24 c8 01 00 	movzbl 0x1c8(%rsp),%ecx
  708245:	00 
  708246:	48 8b 94 24 c9 01 00 	mov    0x1c9(%rsp),%rdx
  70824d:	00 
  70824e:	48 8b b4 24 d0 01 00 	mov    0x1d0(%rsp),%rsi
  708255:	00 
  708256:	48 89 73 18          	mov    %rsi,0x18(%rbx)
  70825a:	48 89 53 11          	mov    %rdx,0x11(%rbx)
  70825e:	48 c7 03 20 00 00 00 	movq   $0x20,(%rbx)
  708265:	48 89 43 08          	mov    %rax,0x8(%rbx)
  708269:	88 4b 10             	mov    %cl,0x10(%rbx)
  70826c:	e9 5e 03 00 00       	jmp    7085cf <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x40f>
  708271:	4c 89 64 24 10       	mov    %r12,0x10(%rsp)
  708276:	41 83 ff 01          	cmp    $0x1,%r15d
  70827a:	0f 85 80 00 00 00    	jne    708300 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x140>
  708280:	48 89 d5             	mov    %rdx,%rbp
  708283:	49 8b 8e 48 02 00 00 	mov    0x248(%r14),%rcx
  70828a:	4d 8b a6 50 02 00 00 	mov    0x250(%r14),%r12
  708291:	49 c1 e4 04          	shl    $0x4,%r12
  708295:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
  70829c:	00 00 00 00 
  7082a0:	4d 85 e4             	test   %r12,%r12
  7082a3:	0f 84 7a 03 00 00    	je     708623 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x463>
  7082a9:	4c 8d 69 10          	lea    0x10(%rcx),%r13
  7082ad:	48 8b 39             	mov    (%rcx),%rdi
  7082b0:	48 8b 41 08          	mov    0x8(%rcx),%rax
  7082b4:	ff 50 18             	call   *0x18(%rax)
  7082b7:	49 83 c4 f0          	add    $0xfffffffffffffff0,%r12
  7082bb:	4c 89 e9             	mov    %r13,%rcx
  7082be:	4c 39 f8             	cmp    %r15,%rax
  7082c1:	75 dd                	jne    7082a0 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0xe0>
  7082c3:	49 8b 8e 60 02 00 00 	mov    0x260(%r14),%rcx
  7082ca:	49 8b 86 68 02 00 00 	mov    0x268(%r14),%rax
  7082d1:	48 c1 e0 03          	shl    $0x3,%rax
  7082d5:	31 f6                	xor    %esi,%esi
  7082d7:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  7082dc:	0f 1f 40 00          	nopl   0x0(%rax)
  7082e0:	48 89 f2             	mov    %rsi,%rdx
  7082e3:	48 39 f0             	cmp    %rsi,%rax
  7082e6:	74 0a                	je     7082f2 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x132>
  7082e8:	48 8d 72 08          	lea    0x8(%rdx),%rsi
  7082ec:	4c 39 3c 11          	cmp    %r15,(%rcx,%rdx,1)
  7082f0:	75 ee                	jne    7082e0 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x120>
  7082f2:	48 39 d0             	cmp    %rdx,%rax
  7082f5:	0f 95 c1             	setne  %cl
  7082f8:	48 89 ea             	mov    %rbp,%rdx
  7082fb:	e9 7f 00 00 00       	jmp    70837f <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1bf>
  708300:	48 89 94 24 58 01 00 	mov    %rdx,0x158(%rsp)
  708307:	00 
  708308:	4d 8b a6 78 02 00 00 	mov    0x278(%r14),%r12
  70830f:	4d 8b ae 80 02 00 00 	mov    0x280(%r14),%r13
  708316:	49 c1 e5 04          	shl    $0x4,%r13
  70831a:	31 ed                	xor    %ebp,%ebp
  70831c:	0f 1f 40 00          	nopl   0x0(%rax)
  708320:	49 39 ed             	cmp    %rbp,%r13
  708323:	0f 84 0e 03 00 00    	je     708637 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x477>
  708329:	49 8b 3c 2c          	mov    (%r12,%rbp,1),%rdi
  70832d:	49 8b 44 2c 08       	mov    0x8(%r12,%rbp,1),%rax
  708332:	4c 89 fe             	mov    %r15,%rsi
  708335:	ff 50 30             	call   *0x30(%rax)
  708338:	48 83 c5 10          	add    $0x10,%rbp
  70833c:	84 c0                	test   %al,%al
  70833e:	74 e0                	je     708320 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x160>
  708340:	49 8b 74 2c f0       	mov    -0x10(%r12,%rbp,1),%rsi
  708345:	49 8b 44 2c f8       	mov    -0x8(%r12,%rbp,1),%rax
  70834a:	48 8d bc 24 c0 01 00 	lea    0x1c0(%rsp),%rdi
  708351:	00 
  708352:	4c 89 fa             	mov    %r15,%rdx
  708355:	ff 50 60             	call   *0x60(%rax)
  708358:	48 8b 84 24 c0 01 00 	mov    0x1c0(%rsp),%rax
  70835f:	00 
  708360:	0f b6 8c 24 c8 01 00 	movzbl 0x1c8(%rsp),%ecx
  708367:	00 
  708368:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  70836c:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  708371:	48 8b 94 24 58 01 00 	mov    0x158(%rsp),%rdx
  708378:	00 
  708379:	0f 85 c7 fe ff ff    	jne    708246 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x86>
  70837f:	f6 c1 01             	test   $0x1,%cl
  708382:	0f 84 f4 02 00 00    	je     70867c <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x4bc>
  708388:	49 ff 86 00 07 00 00 	incq   0x700(%r14)
  70838f:	48 8d 7c 24 70       	lea    0x70(%rsp),%rdi
  708394:	4c 89 f6             	mov    %r14,%rsi
  708397:	31 c9                	xor    %ecx,%ecx
  708399:	e8 62 ee ff ff       	call   707200 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::describe_with>
  70839e:	83 7c 24 70 fe       	cmpl   $0xfffffffe,0x70(%rsp)
  7083a3:	75 16                	jne    7083bb <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1fb>
  7083a5:	c6 84 24 28 02 00 00 	movb   $0x0,0x228(%rsp)
  7083ac:	00 
  7083ad:	48 c7 84 24 20 02 00 	movq   $0xfffffffffffffffe,0x220(%rsp)
  7083b4:	00 fe ff ff ff 
  7083b9:	eb 41                	jmp    7083fc <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x23c>
  7083bb:	48 8b 84 24 a0 00 00 	mov    0xa0(%rsp),%rax
  7083c2:	00 
  7083c3:	48 89 84 24 50 02 00 	mov    %rax,0x250(%rsp)
  7083ca:	00 
  7083cb:	f3 0f 6f 44 24 70    	movdqu 0x70(%rsp),%xmm0
  7083d1:	f3 0f 6f 8c 24 80 00 	movdqu 0x80(%rsp),%xmm1
  7083d8:	00 00 
  7083da:	0f 10 94 24 90 00 00 	movups 0x90(%rsp),%xmm2
  7083e1:	00 
  7083e2:	0f 29 94 24 40 02 00 	movaps %xmm2,0x240(%rsp)
  7083e9:	00 
  7083ea:	66 0f 7f 8c 24 30 02 	movdqa %xmm1,0x230(%rsp)
  7083f1:	00 00 
  7083f3:	66 0f 7f 84 24 20 02 	movdqa %xmm0,0x220(%rsp)
  7083fa:	00 00 
  7083fc:	40 b5 01             	mov    $0x1,%bpl
  7083ff:	45 31 ff             	xor    %r15d,%r15d
  708402:	48 83 bc 24 20 02 00 	cmpq   $0xfffffffffffffffe,0x220(%rsp)
  708409:	00 fe 
  70840b:	0f 85 ba 00 00 00    	jne    7084cb <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x30b>
  708411:	48 8d bc 24 f0 00 00 	lea    0xf0(%rsp),%rdi
  708418:	00 
  708419:	4c 89 f6             	mov    %r14,%rsi
  70841c:	4c 89 e2             	mov    %r12,%rdx
  70841f:	e8 8c 29 00 00       	call   70adb0 <<gpui::runtime::Runtime<unit_action_cost::Model>>::reconcile_editing>
  708424:	48 8b 84 24 f0 00 00 	mov    0xf0(%rsp),%rax
  70842b:	00 
  70842c:	44 0f b6 a4 24 f8 00 	movzbl 0xf8(%rsp),%r12d
  708433:	00 00 
  708435:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  708439:	0f 85 61 01 00 00    	jne    7085a0 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x3e0>
  70843f:	48 8d 35 d2 e6 95 ff 	lea    -0x6a192e(%rip),%rsi        # 66b18 <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x2f8>
  708446:	48 8d bc 24 20 02 00 	lea    0x220(%rsp),%rdi
  70844d:	00 
  70844e:	e8 bd 7f 01 00       	call   720410 <<core::result::Result<gpui::runtime::paint::PatchOutcome, gpui::runtime::Error> as core::cmp::PartialEq>::eq>
  708453:	84 c0                	test   %al,%al
  708455:	74 26                	je     70847d <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x2bd>
  708457:	49 8b 86 10 06 00 00 	mov    0x610(%r14),%rax
  70845e:	48 85 c0             	test   %rax,%rax
  708461:	0f 84 7a 01 00 00    	je     7085e1 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x421>
  708467:	48 83 b8 d8 00 00 00 	cmpq   $0x0,0xd8(%rax)
  70846e:	00 
  70846f:	0f 95 c0             	setne  %al
  708472:	44 08 e0             	or     %r12b,%al
  708475:	a8 01                	test   $0x1,%al
  708477:	0f 84 6e 01 00 00    	je     7085eb <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x42b>
  70847d:	48 8d 35 cc e6 95 ff 	lea    -0x6a1934(%rip),%rsi        # 66b50 <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x330>
  708484:	48 8d bc 24 20 02 00 	lea    0x220(%rsp),%rdi
  70848b:	00 
  70848c:	e8 7f 7f 01 00       	call   720410 <<core::result::Result<gpui::runtime::paint::PatchOutcome, gpui::runtime::Error> as core::cmp::PartialEq>::eq>
  708491:	84 c0                	test   %al,%al
  708493:	74 26                	je     7084bb <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x2fb>
  708495:	49 8b 86 10 06 00 00 	mov    0x610(%r14),%rax
  70849c:	48 85 c0             	test   %rax,%rax
  70849f:	0f 84 a7 01 00 00    	je     70864c <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x48c>
  7084a5:	48 83 b8 d8 00 00 00 	cmpq   $0x0,0xd8(%rax)
  7084ac:	00 
  7084ad:	0f 95 c0             	setne  %al
  7084b0:	44 08 e0             	or     %r12b,%al
  7084b3:	a8 01                	test   $0x1,%al
  7084b5:	0f 84 9b 01 00 00    	je     708656 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x496>
  7084bb:	48 89 df             	mov    %rbx,%rdi
  7084be:	4c 89 f6             	mov    %r14,%rsi
  7084c1:	e8 ca 61 01 00       	call   71e690 <<gpui::runtime::Runtime<unit_action_cost::Model>>::present>
  7084c6:	e9 04 01 00 00       	jmp    7085cf <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x40f>
  7084cb:	48 8b 84 24 50 02 00 	mov    0x250(%rsp),%rax
  7084d2:	00 
  7084d3:	48 89 84 24 20 01 00 	mov    %rax,0x120(%rsp)
  7084da:	00 
  7084db:	0f 28 84 24 20 02 00 	movaps 0x220(%rsp),%xmm0
  7084e2:	00 
  7084e3:	0f 28 8c 24 30 02 00 	movaps 0x230(%rsp),%xmm1
  7084ea:	00 
  7084eb:	0f 28 94 24 40 02 00 	movaps 0x240(%rsp),%xmm2
  7084f2:	00 
  7084f3:	0f 29 94 24 10 01 00 	movaps %xmm2,0x110(%rsp)
  7084fa:	00 
  7084fb:	0f 29 8c 24 00 01 00 	movaps %xmm1,0x100(%rsp)
  708502:	00 
  708503:	0f 29 84 24 f0 00 00 	movaps %xmm0,0xf0(%rsp)
  70850a:	00 
  70850b:	49 8b 86 10 06 00 00 	mov    0x610(%r14),%rax
  708512:	48 85 c0             	test   %rax,%rax
  708515:	74 41                	je     708558 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x398>
  708517:	48 8b 80 e0 00 00 00 	mov    0xe0(%rax),%rax
  70851e:	48 85 c0             	test   %rax,%rax
  708521:	74 35                	je     708558 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x398>
  708523:	48 8b 78 10          	mov    0x10(%rax),%rdi
  708527:	0f b6 48 24          	movzbl 0x24(%rax),%ecx
  70852b:	c6 40 24 02          	movb   $0x2,0x24(%rax)
  70852f:	80 f9 02             	cmp    $0x2,%cl
  708532:	74 24                	je     708558 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x398>
  708534:	f6 07 01             	testb  $0x1,(%rdi)
  708537:	75 17                	jne    708550 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x390>
  708539:	48 8b 47 08          	mov    0x8(%rdi),%rax
  70853d:	a8 01                	test   $0x1,%al
  70853f:	75 0f                	jne    708550 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x390>
  708541:	48 8d 47 08          	lea    0x8(%rdi),%rax
  708545:	f0 48 83 28 02       	lock subq $0x2,(%rax)
  70854a:	0f 84 31 19 00 00    	je     709e81 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1cc1>
  708550:	41 c6 86 1f 07 00 00 	movb   $0x1,0x71f(%r14)
  708557:	01 
  708558:	41 c6 86 1e 07 00 00 	movb   $0x0,0x71e(%r14)
  70855f:	00 
  708560:	49 c7 86 e8 05 00 00 	movq   $0x0,0x5e8(%r14)
  708567:	00 00 00 00 
  70856b:	48 8b 84 24 20 01 00 	mov    0x120(%rsp),%rax
  708572:	00 
  708573:	48 89 43 30          	mov    %rax,0x30(%rbx)
  708577:	66 0f 6f 84 24 f0 00 	movdqa 0xf0(%rsp),%xmm0
  70857e:	00 00 
  708580:	66 0f 6f 8c 24 00 01 	movdqa 0x100(%rsp),%xmm1
  708587:	00 00 
  708589:	0f 28 94 24 10 01 00 	movaps 0x110(%rsp),%xmm2
  708590:	00 
  708591:	0f 11 53 20          	movups %xmm2,0x20(%rbx)
  708595:	f3 0f 7f 4b 10       	movdqu %xmm1,0x10(%rbx)
  70859a:	f3 0f 7f 03          	movdqu %xmm0,(%rbx)
  70859e:	eb 2f                	jmp    7085cf <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x40f>
  7085a0:	f3 0f 6f 84 24 f9 00 	movdqu 0xf9(%rsp),%xmm0
  7085a7:	00 00 
  7085a9:	f3 0f 6f 8c 24 09 01 	movdqu 0x109(%rsp),%xmm1
  7085b0:	00 00 
  7085b2:	0f 10 94 24 18 01 00 	movups 0x118(%rsp),%xmm2
  7085b9:	00 
  7085ba:	0f 11 53 28          	movups %xmm2,0x28(%rbx)
  7085be:	f3 0f 7f 4b 19       	movdqu %xmm1,0x19(%rbx)
  7085c3:	f3 0f 7f 43 09       	movdqu %xmm0,0x9(%rbx)
  7085c8:	48 89 03             	mov    %rax,(%rbx)
  7085cb:	44 88 63 08          	mov    %r12b,0x8(%rbx)
  7085cf:	48 81 c4 c8 03 00 00 	add    $0x3c8,%rsp
  7085d6:	5b                   	pop    %rbx
  7085d7:	41 5c                	pop    %r12
  7085d9:	41 5d                	pop    %r13
  7085db:	41 5e                	pop    %r14
  7085dd:	41 5f                	pop    %r15
  7085df:	5d                   	pop    %rbp
  7085e0:	c3                   	ret
  7085e1:	41 80 fc 01          	cmp    $0x1,%r12b
  7085e5:	0f 84 92 fe ff ff    	je     70847d <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x2bd>
  7085eb:	f3 41 0f 6f 86 60 06 	movdqu 0x660(%r14),%xmm0
  7085f2:	00 00 
  7085f4:	41 0f b6 86 20 07 00 	movzbl 0x720(%r14),%eax
  7085fb:	00 
  7085fc:	49 83 be 80 06 00 00 	cmpq   $0x0,0x680(%r14)
  708603:	00 
  708604:	74 16                	je     70861c <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x45c>
  708606:	84 c0                	test   %al,%al
  708608:	0f 84 c7 00 00 00    	je     7086d5 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x515>
  70860e:	49 83 be 88 05 00 00 	cmpq   $0xffffffffffffffff,0x588(%r14)
  708615:	ff 
  708616:	0f 85 b9 00 00 00    	jne    7086d5 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x515>
  70861c:	31 c9                	xor    %ecx,%ecx
  70861e:	e9 be 00 00 00       	jmp    7086e1 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x521>
  708623:	4c 89 bc 24 c8 01 00 	mov    %r15,0x1c8(%rsp)
  70862a:	00 
  70862b:	b8 0b 00 00 00       	mov    $0xb,%eax
  708630:	b1 01                	mov    $0x1,%cl
  708632:	e9 0f fc ff ff       	jmp    708246 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x86>
  708637:	4c 89 bc 24 c8 01 00 	mov    %r15,0x1c8(%rsp)
  70863e:	00 
  70863f:	b8 0b 00 00 00       	mov    $0xb,%eax
  708644:	44 89 f9             	mov    %r15d,%ecx
  708647:	e9 fa fb ff ff       	jmp    708246 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x86>
  70864c:	41 80 fc 01          	cmp    $0x1,%r12b
  708650:	0f 84 65 fe ff ff    	je     7084bb <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x2fb>
  708656:	40 84 ed             	test   %bpl,%bpl
  708659:	0f 85 15 18 00 00    	jne    709e74 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1cb4>
  70865f:	48 8d 7b 08          	lea    0x8(%rbx),%rdi
  708663:	4c 89 f6             	mov    %r14,%rsi
  708666:	31 d2                	xor    %edx,%edx
  708668:	4c 89 f9             	mov    %r15,%rcx
  70866b:	e8 30 32 00 00       	call   70b8a0 <<gpui::runtime::Runtime<unit_action_cost::Model>>::publish_metadata>
  708670:	48 c7 03 fe ff ff ff 	movq   $0xfffffffffffffffe,(%rbx)
  708677:	e9 53 ff ff ff       	jmp    7085cf <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x40f>
  70867c:	4c 89 bc 24 68 03 00 	mov    %r15,0x368(%rsp)
  708683:	00 
  708684:	49 ff 86 f8 06 00 00 	incq   0x6f8(%r14)
  70868b:	49 8b 86 18 06 00 00 	mov    0x618(%r14),%rax
  708692:	48 85 c0             	test   %rax,%rax
  708695:	48 89 94 24 58 01 00 	mov    %rdx,0x158(%rsp)
  70869c:	00 
  70869d:	0f 84 90 02 00 00    	je     708933 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x773>
  7086a3:	49 8b 8e 20 06 00 00 	mov    0x620(%r14),%rcx
  7086aa:	48 85 c9             	test   %rcx,%rcx
  7086ad:	0f 84 9c 00 00 00    	je     70874f <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x58f>
  7086b3:	48 89 ca             	mov    %rcx,%rdx
  7086b6:	48 83 e2 07          	and    $0x7,%rdx
  7086ba:	74 4c                	je     708708 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x548>
  7086bc:	31 f6                	xor    %esi,%esi
  7086be:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  7086c5:	48 ff c6             	inc    %rsi
  7086c8:	48 39 f2             	cmp    %rsi,%rdx
  7086cb:	75 f1                	jne    7086be <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x4fe>
  7086cd:	48 89 ca             	mov    %rcx,%rdx
  7086d0:	48 29 f2             	sub    %rsi,%rdx
  7086d3:	eb 36                	jmp    70870b <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x54b>
  7086d5:	49 8b 96 90 06 00 00 	mov    0x690(%r14),%rdx
  7086dc:	b9 01 00 00 00       	mov    $0x1,%ecx
  7086e1:	49 8b b6 08 07 00 00 	mov    0x708(%r14),%rsi
  7086e8:	48 89 4b 08          	mov    %rcx,0x8(%rbx)
  7086ec:	48 89 53 10          	mov    %rdx,0x10(%rbx)
  7086f0:	f3 0f 7f 43 18       	movdqu %xmm0,0x18(%rbx)
  7086f5:	48 89 73 28          	mov    %rsi,0x28(%rbx)
  7086f9:	88 43 30             	mov    %al,0x30(%rbx)
  7086fc:	48 c7 03 fe ff ff ff 	movq   $0xfffffffffffffffe,(%rbx)
  708703:	e9 c7 fe ff ff       	jmp    7085cf <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x40f>
  708708:	48 89 ca             	mov    %rcx,%rdx
  70870b:	48 83 f9 08          	cmp    $0x8,%rcx
  70870f:	72 3e                	jb     70874f <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x58f>
  708711:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  708718:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  70871f:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  708726:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  70872d:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  708734:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  70873b:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  708742:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  708749:	48 83 c2 f8          	add    $0xfffffffffffffff8,%rdx
  70874d:	75 c2                	jne    708711 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x551>
  70874f:	66 83 b8 8a 05 00 00 	cmpw   $0x0,0x58a(%rax)
  708756:	00 
  708757:	0f 84 d6 01 00 00    	je     708933 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x773>
  70875d:	80 38 00             	cmpb   $0x0,(%rax)
  708760:	0f 85 cd 01 00 00    	jne    708933 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x773>
  708766:	49 8d be c8 05 00 00 	lea    0x5c8(%r14),%rdi
  70876d:	48 8d b4 24 68 03 00 	lea    0x368(%rsp),%rsi
  708774:	00 
  708775:	e8 66 84 01 00       	call   720be0 <<alloc::collections::btree::map::BTreeMap<gpui::source::FieldId, gpui::runtime::Fanout>>::get::<gpui::source::FieldId>>
  70877a:	48 85 c0             	test   %rax,%rax
  70877d:	0f 84 b0 01 00 00    	je     708933 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x773>
  708783:	48 8b 48 10          	mov    0x10(%rax),%rcx
  708787:	48 c1 e1 02          	shl    $0x2,%rcx
  70878b:	48 83 38 ff          	cmpq   $0xffffffffffffffff,(%rax)
  70878f:	ba 04 00 00 00       	mov    $0x4,%edx
  708794:	48 0f 45 50 08       	cmovne 0x8(%rax),%rdx
  708799:	48 89 54 24 08       	mov    %rdx,0x8(%rsp)
  70879e:	b8 00 00 00 00       	mov    $0x0,%eax
  7087a3:	48 0f 45 c1          	cmovne %rcx,%rax
  7087a7:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
  7087ac:	48 85 c0             	test   %rax,%rax
  7087af:	0f 84 7e 01 00 00    	je     708933 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x773>
  7087b5:	45 31 ed             	xor    %r13d,%r13d
  7087b8:	48 8b 05 41 9a 3f 00 	mov    0x3f9a41(%rip),%rax        # b02200 <_DYNAMIC+0x3b8>
  7087bf:	48 83 c0 20          	add    $0x20,%rax
  7087c3:	48 89 44 24 40       	mov    %rax,0x40(%rsp)
  7087c8:	48 8b 05 39 9a 3f 00 	mov    0x3f9a39(%rip),%rax        # b02208 <_DYNAMIC+0x3c0>
  7087cf:	48 83 c0 20          	add    $0x20,%rax
  7087d3:	48 89 44 24 28       	mov    %rax,0x28(%rsp)
  7087d8:	48 8b 05 31 9a 3f 00 	mov    0x3f9a31(%rip),%rax        # b02210 <_DYNAMIC+0x3c8>
  7087df:	48 83 c0 20          	add    $0x20,%rax
  7087e3:	48 89 44 24 48       	mov    %rax,0x48(%rsp)
  7087e8:	48 8b 05 29 9a 3f 00 	mov    0x3f9a29(%rip),%rax        # b02218 <_DYNAMIC+0x3d0>
  7087ef:	48 83 c0 20          	add    $0x20,%rax
  7087f3:	48 89 44 24 38       	mov    %rax,0x38(%rsp)
  7087f8:	48 8b 05 21 9a 3f 00 	mov    0x3f9a21(%rip),%rax        # b02220 <_DYNAMIC+0x3d8>
  7087ff:	48 83 c0 20          	add    $0x20,%rax
  708803:	48 89 44 24 60       	mov    %rax,0x60(%rsp)
  708808:	48 8b 05 19 9a 3f 00 	mov    0x3f9a19(%rip),%rax        # b02228 <_DYNAMIC+0x3e0>
  70880f:	48 83 c0 20          	add    $0x20,%rax
  708813:	48 89 84 24 d0 00 00 	mov    %rax,0xd0(%rsp)
  70881a:	00 
  70881b:	48 8b 05 0e 9a 3f 00 	mov    0x3f9a0e(%rip),%rax        # b02230 <_DYNAMIC+0x3e8>
  708822:	48 83 c0 20          	add    $0x20,%rax
  708826:	48 89 84 24 c8 00 00 	mov    %rax,0xc8(%rsp)
  70882d:	00 
  70882e:	48 8b 05 03 9a 3f 00 	mov    0x3f9a03(%rip),%rax        # b02238 <_DYNAMIC+0x3f0>
  708835:	48 83 c0 20          	add    $0x20,%rax
  708839:	48 89 44 24 20       	mov    %rax,0x20(%rsp)
  70883e:	48 8b 05 fb 99 3f 00 	mov    0x3f99fb(%rip),%rax        # b02240 <_DYNAMIC+0x3f8>
  708845:	48 83 c0 20          	add    $0x20,%rax
  708849:	48 89 84 24 50 01 00 	mov    %rax,0x150(%rsp)
  708850:	00 
  708851:	48 8b 05 f0 99 3f 00 	mov    0x3f99f0(%rip),%rax        # b02248 <_DYNAMIC+0x400>
  708858:	48 83 c0 20          	add    $0x20,%rax
  70885c:	48 89 44 24 30       	mov    %rax,0x30(%rsp)
  708861:	48 8b 05 e8 99 3f 00 	mov    0x3f99e8(%rip),%rax        # b02250 <_DYNAMIC+0x408>
  708868:	48 83 c0 20          	add    $0x20,%rax
  70886c:	48 89 84 24 48 01 00 	mov    %rax,0x148(%rsp)
  708873:	00 
  708874:	48 8b 05 dd 99 3f 00 	mov    0x3f99dd(%rip),%rax        # b02258 <_DYNAMIC+0x410>
  70887b:	48 83 c0 20          	add    $0x20,%rax
  70887f:	48 89 44 24 58       	mov    %rax,0x58(%rsp)
  708884:	48 8b 05 d5 99 3f 00 	mov    0x3f99d5(%rip),%rax        # b02260 <_DYNAMIC+0x418>
  70888b:	48 83 c0 20          	add    $0x20,%rax
  70888f:	48 89 44 24 50       	mov    %rax,0x50(%rsp)
  708894:	48 8d 2d 55 da 95 ff 	lea    -0x6a25ab(%rip),%rbp        # 662f0 <anon.079f5e587c394fcac2765eb4d0cf0bc2.397.llvm.6319143315422321905+0x1450>
  70889b:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  7088a0:	42 8b 3c 28          	mov    (%rax,%r13,1),%edi
  7088a4:	ff 15 be 99 3f 00    	call   *0x3f99be(%rip)        # b02268 <_DYNAMIC+0x420>
  7088aa:	0f b7 c0             	movzwl %ax,%eax
  7088ad:	48 63 4c 85 00       	movslq 0x0(%rbp,%rax,4),%rcx
  7088b2:	48 01 e9             	add    %rbp,%rcx
  7088b5:	48 8b 44 24 40       	mov    0x40(%rsp),%rax
  7088ba:	ff e1                	jmp    *%rcx
  7088bc:	48 8b 44 24 28       	mov    0x28(%rsp),%rax
  7088c1:	eb 57                	jmp    70891a <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x75a>
  7088c3:	48 8b 84 24 48 01 00 	mov    0x148(%rsp),%rax
  7088ca:	00 
  7088cb:	eb 4d                	jmp    70891a <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x75a>
  7088cd:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
  7088d2:	eb 46                	jmp    70891a <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x75a>
  7088d4:	48 8b 44 24 58       	mov    0x58(%rsp),%rax
  7088d9:	eb 3f                	jmp    70891a <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x75a>
  7088db:	48 8b 84 24 50 01 00 	mov    0x150(%rsp),%rax
  7088e2:	00 
  7088e3:	eb 35                	jmp    70891a <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x75a>
  7088e5:	48 8b 44 24 48       	mov    0x48(%rsp),%rax
  7088ea:	eb 2e                	jmp    70891a <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x75a>
  7088ec:	48 8b 84 24 c8 00 00 	mov    0xc8(%rsp),%rax
  7088f3:	00 
  7088f4:	eb 24                	jmp    70891a <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x75a>
  7088f6:	48 8b 44 24 60       	mov    0x60(%rsp),%rax
  7088fb:	eb 1d                	jmp    70891a <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x75a>
  7088fd:	48 8b 44 24 50       	mov    0x50(%rsp),%rax
  708902:	eb 16                	jmp    70891a <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x75a>
  708904:	48 8b 84 24 d0 00 00 	mov    0xd0(%rsp),%rax
  70890b:	00 
  70890c:	eb 0c                	jmp    70891a <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x75a>
  70890e:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
  708913:	eb 05                	jmp    70891a <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x75a>
  708915:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  70891a:	80 78 13 00          	cmpb   $0x0,0x13(%rax)
  70891e:	0f 85 03 11 00 00    	jne    709a27 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1867>
  708924:	49 83 c5 04          	add    $0x4,%r13
  708928:	4c 39 6c 24 18       	cmp    %r13,0x18(%rsp)
  70892d:	0f 85 68 ff ff ff    	jne    70889b <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x6db>
  708933:	48 c7 44 24 40 00 00 	movq   $0x0,0x40(%rsp)
  70893a:	00 00 
  70893c:	49 8b ae c8 05 00 00 	mov    0x5c8(%r14),%rbp
  708943:	48 85 ed             	test   %rbp,%rbp
  708946:	0f 84 f2 10 00 00    	je     709a3e <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x187e>
  70894c:	49 8d 96 10 07 00 00 	lea    0x710(%r14),%rdx
  708953:	49 8d b6 28 02 00 00 	lea    0x228(%r14),%rsi
  70895a:	49 8b 86 d0 05 00 00 	mov    0x5d0(%r14),%rax
  708961:	48 89 c7             	mov    %rax,%rdi
  708964:	48 89 e9             	mov    %rbp,%rcx
  708967:	44 0f b7 91 c2 01 00 	movzwl 0x1c2(%rcx),%r10d
  70896e:	00 
  70896f:	45 89 d3             	mov    %r10d,%r11d
  708972:	41 c1 e3 05          	shl    $0x5,%r11d
  708976:	49 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%r8
  70897d:	45 31 c9             	xor    %r9d,%r9d
  708980:	4d 39 cb             	cmp    %r9,%r11
  708983:	74 28                	je     7089ad <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x7ed>
  708985:	4e 3b bc c1 70 01 00 	cmp    0x170(%rcx,%r8,8),%r15
  70898c:	00 
  70898d:	41 0f 97 c4          	seta   %r12b
  708991:	41 80 dc 00          	sbb    $0x0,%r12b
  708995:	49 83 c1 20          	add    $0x20,%r9
  708999:	49 ff c0             	inc    %r8
  70899c:	41 80 fc 01          	cmp    $0x1,%r12b
  7089a0:	74 de                	je     708980 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x7c0>
  7089a2:	45 0f b6 d4          	movzbl %r12b,%r10d
  7089a6:	45 85 d2             	test   %r10d,%r10d
  7089a9:	75 05                	jne    7089b0 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x7f0>
  7089ab:	eb 1c                	jmp    7089c9 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x809>
  7089ad:	4d 89 d0             	mov    %r10,%r8
  7089b0:	48 83 ef 01          	sub    $0x1,%rdi
  7089b4:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  7089b9:	0f 82 92 00 00 00    	jb     708a51 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x891>
  7089bf:	4a 8b 8c c1 c8 01 00 	mov    0x1c8(%rcx,%r8,8),%rcx
  7089c6:	00 
  7089c7:	eb 9e                	jmp    708967 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x7a7>
  7089c9:	4a 83 7c 09 e0 ff    	cmpq   $0xffffffffffffffff,-0x20(%rcx,%r9,1)
  7089cf:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  7089d4:	75 7b                	jne    708a51 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x891>
  7089d6:	42 8b 6c 09 e8       	mov    -0x18(%rcx,%r9,1),%ebp
  7089db:	49 ff 86 b8 06 00 00 	incq   0x6b8(%r14)
  7089e2:	c7 04 24 01 00 00 00 	movl   $0x1,(%rsp)
  7089e9:	4c 8d 05 78 bc 3c 00 	lea    0x3cbc78(%rip),%r8        # ad4668 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0xdc0>
  7089f0:	48 8d 7c 24 70       	lea    0x70(%rsp),%rdi
  7089f5:	4c 89 f9             	mov    %r15,%rcx
  7089f8:	45 31 c9             	xor    %r9d,%r9d
  7089fb:	e8 b0 a3 03 00       	call   742db0 <<gpui::source::Sources<unit_action_cost::Model>>::freeze>
  708a00:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  708a05:	48 8b 4c 24 78       	mov    0x78(%rsp),%rcx
  708a0a:	4c 8b ac 24 88 00 00 	mov    0x88(%rsp),%r13
  708a11:	00 
  708a12:	48 83 f8 fd          	cmp    $0xfffffffffffffffd,%rax
  708a16:	0f 85 e6 00 00 00    	jne    708b02 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x942>
  708a1c:	4c 8b 84 24 80 00 00 	mov    0x80(%rsp),%r8
  708a23:	00 
  708a24:	48 89 cd             	mov    %rcx,%rbp
  708a27:	48 c1 ed 08          	shr    $0x8,%rbp
  708a2b:	b8 20 00 00 00       	mov    $0x20,%eax
  708a30:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  708a35:	89 cf                	mov    %ecx,%edi
  708a37:	e9 bb 12 00 00       	jmp    709cf7 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1b37>
  708a3c:	48 89 f9             	mov    %rdi,%rcx
  708a3f:	48 83 e8 01          	sub    $0x1,%rax
  708a43:	0f 82 f5 0f 00 00    	jb     709a3e <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x187e>
  708a49:	48 8b ac cd c8 01 00 	mov    0x1c8(%rbp,%rcx,8),%rbp
  708a50:	00 
  708a51:	0f b7 bd c2 01 00 00 	movzwl 0x1c2(%rbp),%edi
  708a58:	41 89 f8             	mov    %edi,%r8d
  708a5b:	41 c1 e0 05          	shl    $0x5,%r8d
  708a5f:	48 c7 c1 ff ff ff ff 	mov    $0xffffffffffffffff,%rcx
  708a66:	45 31 ed             	xor    %r13d,%r13d
  708a69:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  708a70:	4d 39 e8             	cmp    %r13,%r8
  708a73:	74 c7                	je     708a3c <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x87c>
  708a75:	4c 3b bc cd 70 01 00 	cmp    0x170(%rbp,%rcx,8),%r15
  708a7c:	00 
  708a7d:	41 0f 97 c1          	seta   %r9b
  708a81:	41 80 d9 00          	sbb    $0x0,%r9b
  708a85:	49 83 c5 20          	add    $0x20,%r13
  708a89:	48 ff c1             	inc    %rcx
  708a8c:	41 80 f9 01          	cmp    $0x1,%r9b
  708a90:	74 de                	je     708a70 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x8b0>
  708a92:	41 0f b6 f9          	movzbl %r9b,%edi
  708a96:	85 ff                	test   %edi,%edi
  708a98:	75 a5                	jne    708a3f <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x87f>
  708a9a:	4a 8b 4c 2d e0       	mov    -0x20(%rbp,%r13,1),%rcx
  708a9f:	48 83 f9 ff          	cmp    $0xffffffffffffffff,%rcx
  708aa3:	48 89 4c 24 08       	mov    %rcx,0x8(%rsp)
  708aa8:	74 41                	je     708aeb <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x92b>
  708aaa:	4a 8b 44 2d f0       	mov    -0x10(%rbp,%r13,1),%rax
  708aaf:	48 85 c0             	test   %rax,%rax
  708ab2:	0f 84 46 01 00 00    	je     708bfe <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0xa3e>
  708ab8:	4a 8b 4c 2d e8       	mov    -0x18(%rbp,%r13,1),%rcx
  708abd:	48 ff c8             	dec    %rax
  708ac0:	48 bf ff ff ff ff ff 	movabs $0x3fffffffffffffff,%rdi
  708ac7:	ff ff 3f 
  708aca:	48 21 c7             	and    %rax,%rdi
  708acd:	4c 8d 4f 01          	lea    0x1(%rdi),%r9
  708ad1:	45 89 c8             	mov    %r9d,%r8d
  708ad4:	41 83 e0 03          	and    $0x3,%r8d
  708ad8:	48 83 ff 03          	cmp    $0x3,%rdi
  708adc:	0f 83 25 01 00 00    	jae    708c07 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0xa47>
  708ae2:	31 c0                	xor    %eax,%eax
  708ae4:	31 ff                	xor    %edi,%edi
  708ae6:	e9 b0 01 00 00       	jmp    708c9b <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0xadb>
  708aeb:	49 ff 86 b8 06 00 00 	incq   0x6b8(%r14)
  708af2:	4c 8d 05 6f bb 3c 00 	lea    0x3cbb6f(%rip),%r8        # ad4668 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0xdc0>
  708af9:	31 c0                	xor    %eax,%eax
  708afb:	31 ff                	xor    %edi,%edi
  708afd:	e9 d4 01 00 00       	jmp    708cd6 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0xb16>
  708b02:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
  708b07:	48 89 4c 24 28       	mov    %rcx,0x28(%rsp)
  708b0c:	48 8b 84 24 a0 00 00 	mov    0xa0(%rsp),%rax
  708b13:	00 
  708b14:	48 89 84 24 d0 02 00 	mov    %rax,0x2d0(%rsp)
  708b1b:	00 
  708b1c:	0f 10 84 24 90 00 00 	movups 0x90(%rsp),%xmm0
  708b23:	00 
  708b24:	0f 29 84 24 c0 02 00 	movaps %xmm0,0x2c0(%rsp)
  708b2b:	00 
  708b2c:	41 83 fd 02          	cmp    $0x2,%r13d
  708b30:	0f 84 bc 13 00 00    	je     709ef2 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1d32>
  708b36:	4c 89 6c 24 70       	mov    %r13,0x70(%rsp)
  708b3b:	0f 28 84 24 c0 02 00 	movaps 0x2c0(%rsp),%xmm0
  708b42:	00 
  708b43:	0f 11 44 24 78       	movups %xmm0,0x78(%rsp)
  708b48:	48 8b 84 24 d0 02 00 	mov    0x2d0(%rsp),%rax
  708b4f:	00 
  708b50:	48 89 84 24 88 00 00 	mov    %rax,0x88(%rsp)
  708b57:	00 
  708b58:	48 8d bc 24 60 01 00 	lea    0x160(%rsp),%rdi
  708b5f:	00 
  708b60:	48 8d 74 24 70       	lea    0x70(%rsp),%rsi
  708b65:	ba 06 00 00 00       	mov    $0x6,%edx
  708b6a:	ff 15 00 97 3f 00    	call   *0x3f9700(%rip)        # b02270 <_DYNAMIC+0x428>
  708b70:	0f b6 94 24 60 01 00 	movzbl 0x160(%rsp),%edx
  708b77:	00 
  708b78:	80 fa ff             	cmp    $0xff,%dl
  708b7b:	0f 84 79 0e 00 00    	je     7099fa <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x183a>
  708b81:	8b 8c 24 63 01 00 00 	mov    0x163(%rsp),%ecx
  708b88:	0f b6 84 24 67 01 00 	movzbl 0x167(%rsp),%eax
  708b8f:	00 
  708b90:	0f 10 84 24 68 01 00 	movups 0x168(%rsp),%xmm0
  708b97:	00 
  708b98:	0f 29 84 24 90 03 00 	movaps %xmm0,0x390(%rsp)
  708b9f:	00 
  708ba0:	8b b4 24 78 01 00 00 	mov    0x178(%rsp),%esi
  708ba7:	89 b4 24 a0 03 00 00 	mov    %esi,0x3a0(%rsp)
  708bae:	80 fa 02             	cmp    $0x2,%dl
  708bb1:	0f 85 35 0f 00 00    	jne    709aec <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x192c>
  708bb7:	89 ea                	mov    %ebp,%edx
  708bb9:	48 c1 e0 20          	shl    $0x20,%rax
  708bbd:	48 09 c8             	or     %rcx,%rax
  708bc0:	48 c1 e8 08          	shr    $0x8,%rax
  708bc4:	89 84 24 60 02 00 00 	mov    %eax,0x260(%rsp)
  708bcb:	8b 84 24 98 03 00 00 	mov    0x398(%rsp),%eax
  708bd2:	89 84 24 6c 02 00 00 	mov    %eax,0x26c(%rsp)
  708bd9:	48 8b 84 24 90 03 00 	mov    0x390(%rsp),%rax
  708be0:	00 
  708be1:	48 89 84 24 64 02 00 	mov    %rax,0x264(%rsp)
  708be8:	00 
  708be9:	41 80 be 1f 07 00 00 	cmpb   $0x0,0x71f(%r14)
  708bf0:	00 
  708bf1:	0f 84 0c 0f 00 00    	je     709b03 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1943>
  708bf7:	31 ed                	xor    %ebp,%ebp
  708bf9:	e9 24 0f 00 00       	jmp    709b22 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1962>
  708bfe:	31 ff                	xor    %edi,%edi
  708c00:	31 c0                	xor    %eax,%eax
  708c02:	e9 b5 00 00 00       	jmp    708cbc <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0xafc>
  708c07:	4c 89 44 24 18       	mov    %r8,0x18(%rsp)
  708c0c:	48 b8 00 00 00 00 00 	movabs $0x8000000000000000,%rax
  708c13:	00 00 80 
  708c16:	48 83 c0 fc          	add    $0xfffffffffffffffc,%rax
  708c1a:	49 21 c1             	and    %rax,%r9
  708c1d:	31 c0                	xor    %eax,%eax
  708c1f:	31 ff                	xor    %edi,%edi
  708c21:	44 8b 11             	mov    (%rcx),%r10d
  708c24:	44 8b 41 04          	mov    0x4(%rcx),%r8d
  708c28:	45 89 d4             	mov    %r10d,%r12d
  708c2b:	41 f7 d4             	not    %r12d
  708c2e:	41 f6 c4 03          	test   $0x3,%r12b
  708c32:	41 0f 94 c4          	sete   %r12b
  708c36:	45 89 c3             	mov    %r8d,%r11d
  708c39:	41 f7 d3             	not    %r11d
  708c3c:	41 f6 c3 03          	test   $0x3,%r11b
  708c40:	41 0f 94 c3          	sete   %r11b
  708c44:	45 08 e3             	or     %r12b,%r11b
  708c47:	8b 51 08             	mov    0x8(%rcx),%edx
  708c4a:	41 89 d4             	mov    %edx,%r12d
  708c4d:	41 f7 d4             	not    %r12d
  708c50:	41 f6 c4 03          	test   $0x3,%r12b
  708c54:	41 0f 94 c4          	sete   %r12b
  708c58:	8b 71 0c             	mov    0xc(%rcx),%esi
  708c5b:	48 83 c1 10          	add    $0x10,%rcx
  708c5f:	21 f2                	and    %esi,%edx
  708c61:	f7 d6                	not    %esi
  708c63:	40 f6 c6 03          	test   $0x3,%sil
  708c67:	40 0f 94 c6          	sete   %sil
  708c6b:	44 08 e6             	or     %r12b,%sil
  708c6e:	44 08 de             	or     %r11b,%sil
  708c71:	40 08 f7             	or     %sil,%dil
  708c74:	45 21 c2             	and    %r8d,%r10d
  708c77:	41 21 d2             	and    %edx,%r10d
  708c7a:	41 f7 d2             	not    %r10d
  708c7d:	41 f6 c2 03          	test   $0x3,%r10b
  708c81:	0f 95 c2             	setne  %dl
  708c84:	08 d0                	or     %dl,%al
  708c86:	49 83 c1 fc          	add    $0xfffffffffffffffc,%r9
  708c8a:	75 95                	jne    708c21 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0xa61>
  708c8c:	4c 8b 44 24 18       	mov    0x18(%rsp),%r8
  708c91:	4d 85 c0             	test   %r8,%r8
  708c94:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  708c99:	74 21                	je     708cbc <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0xafc>
  708c9b:	45 31 c9             	xor    %r9d,%r9d
  708c9e:	42 8b 14 89          	mov    (%rcx,%r9,4),%edx
  708ca2:	83 e2 03             	and    $0x3,%edx
  708ca5:	83 fa 03             	cmp    $0x3,%edx
  708ca8:	0f 95 c2             	setne  %dl
  708cab:	40 0f 94 c6          	sete   %sil
  708caf:	40 08 f7             	or     %sil,%dil
  708cb2:	08 d0                	or     %dl,%al
  708cb4:	49 ff c1             	inc    %r9
  708cb7:	4d 39 c8             	cmp    %r9,%r8
  708cba:	75 e2                	jne    708c9e <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0xade>
  708cbc:	49 ff 86 b8 06 00 00 	incq   0x6b8(%r14)
  708cc3:	4e 8b 44 2d f8       	mov    -0x8(%rbp,%r13,1),%r8
  708cc8:	49 8d 96 10 07 00 00 	lea    0x710(%r14),%rdx
  708ccf:	49 8d b6 28 02 00 00 	lea    0x228(%r14),%rsi
  708cd6:	40 0f b6 cf          	movzbl %dil,%ecx
  708cda:	83 e1 01             	and    $0x1,%ecx
  708cdd:	89 0c 24             	mov    %ecx,(%rsp)
  708ce0:	44 0f b6 c8          	movzbl %al,%r9d
  708ce4:	41 83 e1 01          	and    $0x1,%r9d
  708ce8:	48 8d 7c 24 70       	lea    0x70(%rsp),%rdi
  708ced:	4c 89 f9             	mov    %r15,%rcx
  708cf0:	e8 bb a0 03 00       	call   742db0 <<gpui::source::Sources<unit_action_cost::Model>>::freeze>
  708cf5:	48 8b 4c 24 70       	mov    0x70(%rsp),%rcx
  708cfa:	48 8b 44 24 78       	mov    0x78(%rsp),%rax
  708cff:	4c 8b 84 24 80 00 00 	mov    0x80(%rsp),%r8
  708d06:	00 
  708d07:	48 8b 94 24 88 00 00 	mov    0x88(%rsp),%rdx
  708d0e:	00 
  708d0f:	48 89 54 24 18       	mov    %rdx,0x18(%rsp)
  708d14:	48 89 4c 24 60       	mov    %rcx,0x60(%rsp)
  708d19:	48 83 f9 fd          	cmp    $0xfffffffffffffffd,%rcx
  708d1d:	75 1d                	jne    708d3c <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0xb7c>
  708d1f:	48 89 c5             	mov    %rax,%rbp
  708d22:	48 c1 ed 08          	shr    $0x8,%rbp
  708d26:	b9 20 00 00 00       	mov    $0x20,%ecx
  708d2b:	48 89 4c 24 08       	mov    %rcx,0x8(%rsp)
  708d30:	89 c7                	mov    %eax,%edi
  708d32:	4c 8b 6c 24 18       	mov    0x18(%rsp),%r13
  708d37:	e9 bb 0f 00 00       	jmp    709cf7 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1b37>
  708d3c:	48 89 44 24 50       	mov    %rax,0x50(%rsp)
  708d41:	48 8b 84 24 a0 00 00 	mov    0xa0(%rsp),%rax
  708d48:	00 
  708d49:	48 89 84 24 50 03 00 	mov    %rax,0x350(%rsp)
  708d50:	00 
  708d51:	f3 0f 6f 84 24 90 00 	movdqu 0x90(%rsp),%xmm0
  708d58:	00 00 
  708d5a:	66 0f 7f 84 24 40 03 	movdqa %xmm0,0x340(%rsp)
  708d61:	00 00 
  708d63:	48 83 7c 24 08 ff    	cmpq   $0xffffffffffffffff,0x8(%rsp)
  708d69:	0f 84 69 0c 00 00    	je     7099d8 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1818>
  708d6f:	4a 8b 44 2d f0       	mov    -0x10(%rbp,%r13,1),%rax
  708d74:	48 85 c0             	test   %rax,%rax
  708d77:	0f 84 5b 0c 00 00    	je     7099d8 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1818>
  708d7d:	4c 89 44 24 30       	mov    %r8,0x30(%rsp)
  708d82:	4a 8b 4c 2d e8       	mov    -0x18(%rbp,%r13,1),%rcx
  708d87:	48 89 4c 24 08       	mov    %rcx,0x8(%rsp)
  708d8c:	48 c1 e0 02          	shl    $0x2,%rax
  708d90:	48 89 44 24 28       	mov    %rax,0x28(%rsp)
  708d95:	8b 44 24 18          	mov    0x18(%rsp),%eax
  708d99:	48 89 84 24 60 03 00 	mov    %rax,0x360(%rsp)
  708da0:	00 
  708da1:	45 31 e4             	xor    %r12d,%r12d
  708da4:	48 83 f8 02          	cmp    $0x2,%rax
  708da8:	0f 85 72 0b 00 00    	jne    709920 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1760>
  708dae:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  708db3:	42 8b 3c 20          	mov    (%rax,%r12,1),%edi
  708db7:	ff 15 ab 94 3f 00    	call   *0x3f94ab(%rip)        # b02268 <_DYNAMIC+0x420>
  708dbd:	66 85 c0             	test   %ax,%ax
  708dc0:	0f 85 ba 12 00 00    	jne    70a080 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1ec0>
  708dc6:	49 83 c4 04          	add    $0x4,%r12
  708dca:	4c 39 64 24 28       	cmp    %r12,0x28(%rsp)
  708dcf:	75 dd                	jne    708dae <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0xbee>
  708dd1:	4a 8b 44 2d f0       	mov    -0x10(%rbp,%r13,1),%rax
  708dd6:	48 85 c0             	test   %rax,%rax
  708dd9:	0f 84 dd 0d 00 00    	je     709bbc <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x19fc>
  708ddf:	4a 8b 4c 2d e8       	mov    -0x18(%rbp,%r13,1),%rcx
  708de4:	48 89 8c 24 48 01 00 	mov    %rcx,0x148(%rsp)
  708deb:	00 
  708dec:	48 c1 e0 02          	shl    $0x2,%rax
  708df0:	f3 0f 7e 44 24 30    	movq   0x30(%rsp),%xmm0
  708df6:	66 0f 6f 0d 82 ca 95 	movdqa -0x6a357e(%rip),%xmm1        # 65880 <anon.079f5e587c394fcac2765eb4d0cf0bc2.397.llvm.6319143315422321905+0x9e0>
  708dfd:	ff 
  708dfe:	66 0f 6c c8          	punpcklqdq %xmm0,%xmm1
  708e02:	66 0f 7f 8c 24 b0 03 	movdqa %xmm1,0x3b0(%rsp)
  708e09:	00 00 
  708e0b:	48 c7 84 24 d0 00 00 	movq   $0x0,0xd0(%rsp)
  708e12:	00 00 00 00 00 
  708e17:	48 8d 0d 8a b8 3c 00 	lea    0x3cb88a(%rip),%rcx        # ad46a8 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0xe00>
  708e1e:	48 89 4c 24 68       	mov    %rcx,0x68(%rsp)
  708e23:	48 b9 00 00 00 00 00 	movabs $0x8000000000000000,%rcx
  708e2a:	00 00 80 
  708e2d:	48 ff c1             	inc    %rcx
  708e30:	48 89 8c 24 38 01 00 	mov    %rcx,0x138(%rsp)
  708e37:	00 
  708e38:	48 8d 0d 05 08 96 ff 	lea    -0x69f7fb(%rip),%rcx        # 69644 <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x2e24>
  708e3f:	48 89 8c 24 30 01 00 	mov    %rcx,0x130(%rsp)
  708e46:	00 
  708e47:	48 8d 0d ea b8 3c 00 	lea    0x3cb8ea(%rip),%rcx        # ad4738 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0xe90>
  708e4e:	48 89 8c 24 28 01 00 	mov    %rcx,0x128(%rsp)
  708e55:	00 
  708e56:	48 8d 0d 63 b8 3c 00 	lea    0x3cb863(%rip),%rcx        # ad46c0 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0xe18>
  708e5d:	48 89 8c 24 d8 00 00 	mov    %rcx,0xd8(%rsp)
  708e64:	00 
  708e65:	48 8d 0d af 07 96 ff 	lea    -0x69f851(%rip),%rcx        # 6961b <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x2dfb>
  708e6c:	48 89 8c 24 e0 00 00 	mov    %rcx,0xe0(%rsp)
  708e73:	00 
  708e74:	48 8d 0d cd ac 3c 00 	lea    0x3caccd(%rip),%rcx        # ad3b48 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0x2a0>
  708e7b:	48 89 8c 24 b8 01 00 	mov    %rcx,0x1b8(%rsp)
  708e82:	00 
  708e83:	31 c9                	xor    %ecx,%ecx
  708e85:	48 c7 84 24 40 01 00 	movq   $0x0,0x140(%rsp)
  708e8c:	00 00 00 00 00 
  708e91:	48 c7 84 24 e8 00 00 	movq   $0x0,0xe8(%rsp)
  708e98:	00 00 00 00 00 
  708e9d:	48 c7 44 24 20 00 00 	movq   $0x0,0x20(%rsp)
  708ea4:	00 00 
  708ea6:	48 89 44 24 58       	mov    %rax,0x58(%rsp)
  708eab:	48 8b 84 24 48 01 00 	mov    0x148(%rsp),%rax
  708eb2:	00 
  708eb3:	48 89 4c 24 38       	mov    %rcx,0x38(%rsp)
  708eb8:	8b 2c 08             	mov    (%rax,%rcx,1),%ebp
  708ebb:	49 ff 86 c0 06 00 00 	incq   0x6c0(%r14)
  708ec2:	89 e8                	mov    %ebp,%eax
  708ec4:	c1 e8 0f             	shr    $0xf,%eax
  708ec7:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  708ece:	48 39 c6             	cmp    %rax,%rsi
  708ed1:	48 89 44 24 28       	mov    %rax,0x28(%rsp)
  708ed6:	0f 86 7c 11 00 00    	jbe    70a058 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1e98>
  708edc:	4d 8b a6 98 02 00 00 	mov    0x298(%r14),%r12
  708ee3:	4c 8d 2c 80          	lea    (%rax,%rax,4),%r13
  708ee7:	4b 8b 04 ec          	mov    (%r12,%r13,8),%rax
  708eeb:	48 89 44 24 48       	mov    %rax,0x48(%rsp)
  708ef0:	89 ef                	mov    %ebp,%edi
  708ef2:	ff 15 70 93 3f 00    	call   *0x3f9370(%rip)        # b02268 <_DYNAMIC+0x420>
  708ef8:	89 44 24 08          	mov    %eax,0x8(%rsp)
  708efc:	4b 8d 04 ec          	lea    (%r12,%r13,8),%rax
  708f00:	48 89 84 24 c8 00 00 	mov    %rax,0xc8(%rsp)
  708f07:	00 
  708f08:	8b 54 24 08          	mov    0x8(%rsp),%edx
  708f0c:	66 85 d2             	test   %dx,%dx
  708f0f:	0f 84 31 01 00 00    	je     709046 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0xe86>
  708f15:	83 bc 24 60 03 00 00 	cmpl   $0x2,0x360(%rsp)
  708f1c:	02 
  708f1d:	0f 84 6d 0f 00 00    	je     709e90 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1cd0>
  708f23:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
  708f28:	48 89 44 24 70       	mov    %rax,0x70(%rsp)
  708f2d:	48 8b 84 24 50 03 00 	mov    0x350(%rsp),%rax
  708f34:	00 
  708f35:	48 8d 4c 24 78       	lea    0x78(%rsp),%rcx
  708f3a:	48 89 41 10          	mov    %rax,0x10(%rcx)
  708f3e:	66 0f 6f 84 24 40 03 	movdqa 0x340(%rsp),%xmm0
  708f45:	00 00 
  708f47:	f3 0f 7f 01          	movdqu %xmm0,(%rcx)
  708f4b:	48 8d bc 24 60 01 00 	lea    0x160(%rsp),%rdi
  708f52:	00 
  708f53:	48 8d 74 24 70       	lea    0x70(%rsp),%rsi
  708f58:	ff 15 12 93 3f 00    	call   *0x3f9312(%rip)        # b02270 <_DYNAMIC+0x428>
  708f5e:	0f b6 84 24 60 01 00 	movzbl 0x160(%rsp),%eax
  708f65:	00 
  708f66:	3c ff                	cmp    $0xff,%al
  708f68:	0f 84 10 0d 00 00    	je     709c7e <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1abe>
  708f6e:	0f b7 8c 24 61 01 00 	movzwl 0x161(%rsp),%ecx
  708f75:	00 
  708f76:	8b 94 24 63 01 00 00 	mov    0x163(%rsp),%edx
  708f7d:	0f b6 b4 24 67 01 00 	movzbl 0x167(%rsp),%esi
  708f84:	00 
  708f85:	4c 8d 84 24 68 01 00 	lea    0x168(%rsp),%r8
  708f8c:	00 
  708f8d:	41 8b 78 10          	mov    0x10(%r8),%edi
  708f91:	4c 8d 8c 24 7c 03 00 	lea    0x37c(%rsp),%r9
  708f98:	00 
  708f99:	41 89 79 10          	mov    %edi,0x10(%r9)
  708f9d:	f3 41 0f 6f 00       	movdqu (%r8),%xmm0
  708fa2:	f3 41 0f 7f 01       	movdqu %xmm0,(%r9)
  708fa7:	88 84 24 74 03 00 00 	mov    %al,0x374(%rsp)
  708fae:	66 89 8c 24 75 03 00 	mov    %cx,0x375(%rsp)
  708fb5:	00 
  708fb6:	40 88 b4 24 7b 03 00 	mov    %sil,0x37b(%rsp)
  708fbd:	00 
  708fbe:	89 94 24 77 03 00 00 	mov    %edx,0x377(%rsp)
  708fc5:	8b 4c 24 08          	mov    0x8(%rsp),%ecx
  708fc9:	44 0f b7 e9          	movzwl %cx,%r13d
  708fcd:	48 8d 05 6c ba 3c 00 	lea    0x3cba6c(%rip),%rax        # ad4a40 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0x1198>
  708fd4:	4a 8b 44 e8 f8       	mov    -0x8(%rax,%r13,8),%rax
  708fd9:	80 78 12 00          	cmpb   $0x0,0x12(%rax)
  708fdd:	0f 84 c7 00 00 00    	je     7090aa <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0xeea>
  708fe3:	48 8d 7c 24 70       	lea    0x70(%rsp),%rdi
  708fe8:	49 8d b6 10 06 00 00 	lea    0x610(%r14),%rsi
  708fef:	48 8b 54 24 48       	mov    0x48(%rsp),%rdx
  708ff4:	4c 8d 84 24 74 03 00 	lea    0x374(%rsp),%r8
  708ffb:	00 
  708ffc:	ff 15 76 92 3f 00    	call   *0x3f9276(%rip)        # b02278 <_DYNAMIC+0x430>
  709002:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  709007:	0f b6 7c 24 78       	movzbl 0x78(%rsp),%edi
  70900c:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  709010:	0f 85 ab 0d 00 00    	jne    709dc1 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1c01>
  709016:	40 80 ff 01          	cmp    $0x1,%dil
  70901a:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  70901f:	48 8b 4c 24 38       	mov    0x38(%rsp),%rcx
  709024:	4c 8b 6c 24 28       	mov    0x28(%rsp),%r13
  709029:	0f 85 9e 08 00 00    	jne    7098cd <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x170d>
  70902f:	41 c6 86 1f 07 00 00 	movb   $0x1,0x71f(%r14)
  709036:	01 
  709037:	b0 01                	mov    $0x1,%al
  709039:	48 89 84 24 e8 00 00 	mov    %rax,0xe8(%rsp)
  709040:	00 
  709041:	e9 4e 08 00 00       	jmp    709894 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x16d4>
  709046:	48 83 7c 24 60 fe    	cmpq   $0xfffffffffffffffe,0x60(%rsp)
  70904c:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  709051:	0f 84 59 0e 00 00    	je     709eb0 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1cf0>
  709057:	83 e5 03             	and    $0x3,%ebp
  70905a:	8d 45 ff             	lea    -0x1(%rbp),%eax
  70905d:	83 f8 02             	cmp    $0x2,%eax
  709060:	0f 83 8a 00 00 00    	jae    7090f0 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0xf30>
  709066:	49 8d 86 10 06 00 00 	lea    0x610(%r14),%rax
  70906d:	48 8b 38             	mov    (%rax),%rdi
  709070:	41 bc 2b 00 00 00    	mov    $0x2b,%r12d
  709076:	48 85 ff             	test   %rdi,%rdi
  709079:	0f 84 19 0e 00 00    	je     709e98 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1cd8>
  70907f:	48 8b 74 24 48       	mov    0x48(%rsp),%rsi
  709084:	ff 15 f6 91 3f 00    	call   *0x3f91f6(%rip)        # b02280 <_DYNAMIC+0x438>
  70908a:	48 85 c0             	test   %rax,%rax
  70908d:	0f 84 05 0e 00 00    	je     709e98 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1cd8>
  709093:	83 fd 01             	cmp    $0x1,%ebp
  709096:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  70909b:	0f 85 a6 00 00 00    	jne    709147 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0xf87>
  7090a1:	48 8b 78 08          	mov    0x8(%rax),%rdi
  7090a5:	e9 a1 00 00 00       	jmp    70914b <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0xf8b>
  7090aa:	49 8d 86 00 02 00 00 	lea    0x200(%r14),%rax
  7090b1:	48 8b 00             	mov    (%rax),%rax
  7090b4:	48 8d 15 6d d2 95 ff 	lea    -0x6a2d93(%rip),%rdx        # 66328 <anon.079f5e587c394fcac2765eb4d0cf0bc2.397.llvm.6319143315422321905+0x1488>
  7090bb:	48 63 0c 82          	movslq (%rdx,%rax,4),%rcx
  7090bf:	48 01 d1             	add    %rdx,%rcx
  7090c2:	48 8d 05 5b d9 95 ff 	lea    -0x6a26a5(%rip),%rax        # 66a24 <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x204>
  7090c9:	ff e1                	jmp    *%rcx
  7090cb:	49 8b b6 18 02 00 00 	mov    0x218(%r14),%rsi
  7090d2:	48 8b 44 24 28       	mov    0x28(%rsp),%rax
  7090d7:	48 39 c6             	cmp    %rax,%rsi
  7090da:	0f 86 3a 0f 00 00    	jbe    70a01a <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1e5a>
  7090e0:	48 6b c0 58          	imul   $0x58,%rax,%rax
  7090e4:	49 03 86 10 02 00 00 	add    0x210(%r14),%rax
  7090eb:	e9 4e 03 00 00       	jmp    70943e <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x127e>
  7090f0:	85 ed                	test   %ebp,%ebp
  7090f2:	0f 85 18 0e 00 00    	jne    709f10 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1d50>
  7090f8:	48 8b 84 24 c8 00 00 	mov    0xc8(%rsp),%rax
  7090ff:	00 
  709100:	8b 40 20             	mov    0x20(%rax),%eax
  709103:	89 c1                	mov    %eax,%ecx
  709105:	83 e1 07             	and    $0x7,%ecx
  709108:	83 f9 06             	cmp    $0x6,%ecx
  70910b:	74 74                	je     709181 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0xfc1>
  70910d:	c1 e8 03             	shr    $0x3,%eax
  709110:	74 6f                	je     709181 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0xfc1>
  709112:	49 8b b6 b8 02 00 00 	mov    0x2b8(%r14),%rsi
  709119:	ff c8                	dec    %eax
  70911b:	48 39 c6             	cmp    %rax,%rsi
  70911e:	0f 86 23 0f 00 00    	jbe    70a047 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1e87>
  709124:	49 8b 8e b0 02 00 00 	mov    0x2b0(%r14),%rcx
  70912b:	48 8d 04 80          	lea    (%rax,%rax,4),%rax
  70912f:	48 c1 e0 04          	shl    $0x4,%rax
  709133:	48 83 3c 01 fe       	cmpq   $0xfffffffffffffffe,(%rcx,%rax,1)
  709138:	0f 84 59 0e 00 00    	je     709f97 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1dd7>
  70913e:	48 01 c1             	add    %rax,%rcx
  709141:	48 8b 79 40          	mov    0x40(%rcx),%rdi
  709145:	eb 13                	jmp    70915a <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0xf9a>
  709147:	48 8b 78 10          	mov    0x10(%rax),%rdi
  70914b:	b0 01                	mov    $0x1,%al
  70914d:	48 89 84 24 40 01 00 	mov    %rax,0x140(%rsp)
  709154:	00 
  709155:	48 85 ff             	test   %rdi,%rdi
  709158:	74 27                	je     709181 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0xfc1>
  70915a:	48 8b 07             	mov    (%rdi),%rax
  70915d:	48 d1 e8             	shr    $1,%rax
  709160:	48 8b 54 24 30       	mov    0x30(%rsp),%rdx
  709165:	48 39 d0             	cmp    %rdx,%rax
  709168:	75 17                	jne    709181 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0xfc1>
  70916a:	48 83 c7 10          	add    $0x10,%rdi
  70916e:	48 8b 74 24 50       	mov    0x50(%rsp),%rsi
  709173:	ff 15 0f 91 3f 00    	call   *0x3f910f(%rip)        # b02288 <bcmp@GLIBC_2.2.5>
  709179:	85 c0                	test   %eax,%eax
  70917b:	0f 84 3a 06 00 00    	je     7097bb <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x15fb>
  709181:	4c 8b 64 24 20       	mov    0x20(%rsp),%r12
  709186:	4d 85 e4             	test   %r12,%r12
  709189:	75 6d                	jne    7091f8 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1038>
  70918b:	4c 8d 25 1e cf 95 ff 	lea    -0x6a30e2(%rip),%r12        # 660b0 <anon.079f5e587c394fcac2765eb4d0cf0bc2.397.llvm.6319143315422321905+0x1210>
  709192:	48 8b 74 24 30       	mov    0x30(%rsp),%rsi
  709197:	48 85 f6             	test   %rsi,%rsi
  70919a:	74 41                	je     7091dd <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x101d>
  70919c:	48 c7 44 24 20 00 00 	movq   $0x0,0x20(%rsp)
  7091a3:	00 00 
  7091a5:	48 8d 7c 24 70       	lea    0x70(%rsp),%rdi
  7091aa:	31 d2                	xor    %edx,%edx
  7091ac:	31 c9                	xor    %ecx,%ecx
  7091ae:	ff 15 dc 90 3f 00    	call   *0x3f90dc(%rip)        # b02290 <_DYNAMIC+0x448>
  7091b4:	48 8b 7c 24 70       	mov    0x70(%rsp),%rdi
  7091b9:	48 83 ff ff          	cmp    $0xffffffffffffffff,%rdi
  7091bd:	0f 85 6e 0e 00 00    	jne    70a031 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1e71>
  7091c3:	4c 8b 64 24 78       	mov    0x78(%rsp),%r12
  7091c8:	49 8d 7c 24 10       	lea    0x10(%r12),%rdi
  7091cd:	48 8b 74 24 50       	mov    0x50(%rsp),%rsi
  7091d2:	48 8b 54 24 30       	mov    0x30(%rsp),%rdx
  7091d7:	ff 15 db 8e 3f 00    	call   *0x3f8edb(%rip)        # b020b8 <memcpy@GLIBC_2.14>
  7091dd:	f3 41 0f 6f 86 c8 06 	movdqu 0x6c8(%r14),%xmm0
  7091e4:	00 00 
  7091e6:	66 0f d4 84 24 b0 03 	paddq  0x3b0(%rsp),%xmm0
  7091ed:	00 00 
  7091ef:	f3 41 0f 7f 86 c8 06 	movdqu %xmm0,0x6c8(%r14)
  7091f6:	00 00 
  7091f8:	85 ed                	test   %ebp,%ebp
  7091fa:	4c 89 64 24 20       	mov    %r12,0x20(%rsp)
  7091ff:	0f 84 b1 00 00 00    	je     7092b6 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x10f6>
  709205:	49 8d 86 10 06 00 00 	lea    0x610(%r14),%rax
  70920c:	48 8b 38             	mov    (%rax),%rdi
  70920f:	41 bd 2b 00 00 00    	mov    $0x2b,%r13d
  709215:	48 85 ff             	test   %rdi,%rdi
  709218:	0f 84 2e 0d 00 00    	je     709f4c <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1d8c>
  70921e:	48 8b 74 24 48       	mov    0x48(%rsp),%rsi
  709223:	ff 15 6f 90 3f 00    	call   *0x3f906f(%rip)        # b02298 <_DYNAMIC+0x450>
  709229:	48 85 c0             	test   %rax,%rax
  70922c:	0f 84 1a 0d 00 00    	je     709f4c <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1d8c>
  709232:	83 fd 01             	cmp    $0x1,%ebp
  709235:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  70923a:	4c 8b 6c 24 28       	mov    0x28(%rsp),%r13
  70923f:	0f 85 4d 01 00 00    	jne    709392 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x11d2>
  709245:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
  70924a:	48 85 c9             	test   %rcx,%rcx
  70924d:	74 2c                	je     70927b <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x10bb>
  70924f:	f6 01 01             	testb  $0x1,(%rcx)
  709252:	75 27                	jne    70927b <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x10bb>
  709254:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  709258:	f6 c2 01             	test   $0x1,%dl
  70925b:	75 1e                	jne    70927b <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x10bb>
  70925d:	ba 02 00 00 00       	mov    $0x2,%edx
  709262:	f0 48 0f c1 51 08    	lock xadd %rdx,0x8(%rcx)
  709268:	48 23 94 24 38 01 00 	and    0x138(%rsp),%rdx
  70926f:	00 
  709270:	48 f7 da             	neg    %rdx
  709273:	71 06                	jno    70927b <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x10bb>
  709275:	f0 48 83 49 08 01    	lock orq $0x1,0x8(%rcx)
  70927b:	48 89 c5             	mov    %rax,%rbp
  70927e:	48 8b 78 08          	mov    0x8(%rax),%rdi
  709282:	48 85 ff             	test   %rdi,%rdi
  709285:	74 1c                	je     7092a3 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x10e3>
  709287:	f6 07 01             	testb  $0x1,(%rdi)
  70928a:	75 17                	jne    7092a3 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x10e3>
  70928c:	48 8b 47 08          	mov    0x8(%rdi),%rax
  709290:	a8 01                	test   $0x1,%al
  709292:	75 0f                	jne    7092a3 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x10e3>
  709294:	48 8d 47 08          	lea    0x8(%rdi),%rax
  709298:	f0 48 83 28 02       	lock subq $0x2,(%rax)
  70929d:	0f 84 50 06 00 00    	je     7098f3 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1733>
  7092a3:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  7092a8:	48 89 45 08          	mov    %rax,0x8(%rbp)
  7092ac:	48 8b 4c 24 38       	mov    0x38(%rsp),%rcx
  7092b1:	e9 de 05 00 00       	jmp    709894 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x16d4>
  7092b6:	48 8b 84 24 c8 00 00 	mov    0xc8(%rsp),%rax
  7092bd:	00 
  7092be:	8b 78 20             	mov    0x20(%rax),%edi
  7092c1:	89 f8                	mov    %edi,%eax
  7092c3:	83 e0 07             	and    $0x7,%eax
  7092c6:	41 bd 16 00 00 00    	mov    $0x16,%r13d
  7092cc:	83 f8 06             	cmp    $0x6,%eax
  7092cf:	0f 84 59 0c 00 00    	je     709f2e <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1d6e>
  7092d5:	c1 ef 03             	shr    $0x3,%edi
  7092d8:	0f 84 50 0c 00 00    	je     709f2e <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1d6e>
  7092de:	49 8b b6 b8 02 00 00 	mov    0x2b8(%r14),%rsi
  7092e5:	ff cf                	dec    %edi
  7092e7:	48 39 fe             	cmp    %rdi,%rsi
  7092ea:	0f 86 01 0d 00 00    	jbe    709ff1 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1e31>
  7092f0:	49 8b ae b0 02 00 00 	mov    0x2b0(%r14),%rbp
  7092f7:	48 8d 04 bf          	lea    (%rdi,%rdi,4),%rax
  7092fb:	48 c1 e0 04          	shl    $0x4,%rax
  7092ff:	48 83 7c 05 00 fe    	cmpq   $0xfffffffffffffffe,0x0(%rbp,%rax,1)
  709305:	0f 84 5f 0c 00 00    	je     709f6a <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1daa>
  70930b:	4d 85 e4             	test   %r12,%r12
  70930e:	0f 84 68 0c 00 00    	je     709f7c <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1dbc>
  709314:	41 f6 04 24 01       	testb  $0x1,(%r12)
  709319:	75 2a                	jne    709345 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1185>
  70931b:	49 8b 4c 24 08       	mov    0x8(%r12),%rcx
  709320:	f6 c1 01             	test   $0x1,%cl
  709323:	75 20                	jne    709345 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1185>
  709325:	b9 02 00 00 00       	mov    $0x2,%ecx
  70932a:	f0 49 0f c1 4c 24 08 	lock xadd %rcx,0x8(%r12)
  709331:	48 23 8c 24 38 01 00 	and    0x138(%rsp),%rcx
  709338:	00 
  709339:	48 f7 d9             	neg    %rcx
  70933c:	71 07                	jno    709345 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1185>
  70933e:	f0 49 83 4c 24 08 01 	lock orq $0x1,0x8(%r12)
  709345:	48 01 c5             	add    %rax,%rbp
  709348:	48 8b 7d 40          	mov    0x40(%rbp),%rdi
  70934c:	f6 07 01             	testb  $0x1,(%rdi)
  70934f:	75 17                	jne    709368 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x11a8>
  709351:	48 8b 47 08          	mov    0x8(%rdi),%rax
  709355:	a8 01                	test   $0x1,%al
  709357:	75 0f                	jne    709368 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x11a8>
  709359:	48 8d 47 08          	lea    0x8(%rdi),%rax
  70935d:	f0 48 83 28 02       	lock subq $0x2,(%rax)
  709362:	0f 84 7c 05 00 00    	je     7098e4 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1724>
  709368:	4c 89 65 40          	mov    %r12,0x40(%rbp)
  70936c:	48 89 ef             	mov    %rbp,%rdi
  70936f:	e8 8c 85 ff ff       	call   701900 <core::ptr::drop_glue::<core::option::Option<gpui::runtime::Shaped>>>
  709374:	48 c7 45 00 ff ff ff 	movq   $0xffffffffffffffff,0x0(%rbp)
  70937b:	ff 
  70937c:	49 8d be 48 06 00 00 	lea    0x648(%r14),%rdi
  709383:	48 8b 74 24 48       	mov    0x48(%rsp),%rsi
  709388:	e8 d3 86 01 00       	call   721a60 <<alloc::collections::btree::map::BTreeMap<u64, alloc::collections::btree::set_val::SetValZST>>::insert>
  70938d:	e9 e1 04 00 00       	jmp    709873 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x16b3>
  709392:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
  709397:	48 85 c9             	test   %rcx,%rcx
  70939a:	74 2c                	je     7093c8 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1208>
  70939c:	f6 01 01             	testb  $0x1,(%rcx)
  70939f:	75 27                	jne    7093c8 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1208>
  7093a1:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  7093a5:	f6 c2 01             	test   $0x1,%dl
  7093a8:	75 1e                	jne    7093c8 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1208>
  7093aa:	ba 02 00 00 00       	mov    $0x2,%edx
  7093af:	f0 48 0f c1 51 08    	lock xadd %rdx,0x8(%rcx)
  7093b5:	48 23 94 24 38 01 00 	and    0x138(%rsp),%rdx
  7093bc:	00 
  7093bd:	48 f7 da             	neg    %rdx
  7093c0:	71 06                	jno    7093c8 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1208>
  7093c2:	f0 48 83 49 08 01    	lock orq $0x1,0x8(%rcx)
  7093c8:	48 89 c5             	mov    %rax,%rbp
  7093cb:	48 8b 78 10          	mov    0x10(%rax),%rdi
  7093cf:	48 85 ff             	test   %rdi,%rdi
  7093d2:	74 1c                	je     7093f0 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1230>
  7093d4:	f6 07 01             	testb  $0x1,(%rdi)
  7093d7:	75 17                	jne    7093f0 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1230>
  7093d9:	48 8b 47 08          	mov    0x8(%rdi),%rax
  7093dd:	a8 01                	test   $0x1,%al
  7093df:	75 0f                	jne    7093f0 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1230>
  7093e1:	48 8d 47 08          	lea    0x8(%rdi),%rax
  7093e5:	f0 48 83 28 02       	lock subq $0x2,(%rax)
  7093ea:	0f 84 12 05 00 00    	je     709902 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1742>
  7093f0:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  7093f5:	48 89 45 10          	mov    %rax,0x10(%rbp)
  7093f9:	48 8b 4c 24 38       	mov    0x38(%rsp),%rcx
  7093fe:	e9 91 04 00 00       	jmp    709894 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x16d4>
  709403:	49 8b b6 20 02 00 00 	mov    0x220(%r14),%rsi
  70940a:	48 8b 4c 24 28       	mov    0x28(%rsp),%rcx
  70940f:	48 39 ce             	cmp    %rcx,%rsi
  709412:	0f 86 eb 0b 00 00    	jbe    70a003 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1e43>
  709418:	49 8b b6 10 02 00 00 	mov    0x210(%r14),%rsi
  70941f:	49 8b 86 18 02 00 00 	mov    0x218(%r14),%rax
  709426:	0f b6 04 08          	movzbl (%rax,%rcx,1),%eax
  70942a:	48 39 c6             	cmp    %rax,%rsi
  70942d:	0f 86 d9 0b 00 00    	jbe    70a00c <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1e4c>
  709433:	48 6b c0 58          	imul   $0x58,%rax,%rax
  709437:	49 03 86 08 02 00 00 	add    0x208(%r14),%rax
  70943e:	48 8b 48 50          	mov    0x50(%rax),%rcx
  709442:	48 89 8c 24 b0 02 00 	mov    %rcx,0x2b0(%rsp)
  709449:	00 
  70944a:	0f 10 40 40          	movups 0x40(%rax),%xmm0
  70944e:	0f 29 84 24 a0 02 00 	movaps %xmm0,0x2a0(%rsp)
  709455:	00 
  709456:	f3 0f 6f 00          	movdqu (%rax),%xmm0
  70945a:	f3 0f 6f 48 10       	movdqu 0x10(%rax),%xmm1
  70945f:	0f 10 50 20          	movups 0x20(%rax),%xmm2
  709463:	0f 10 58 30          	movups 0x30(%rax),%xmm3
  709467:	0f 29 9c 24 90 02 00 	movaps %xmm3,0x290(%rsp)
  70946e:	00 
  70946f:	0f 29 94 24 80 02 00 	movaps %xmm2,0x280(%rsp)
  709476:	00 
  709477:	66 0f 7f 8c 24 70 02 	movdqa %xmm1,0x270(%rsp)
  70947e:	00 00 
  709480:	66 0f 7f 84 24 60 02 	movdqa %xmm0,0x260(%rsp)
  709487:	00 00 
  709489:	eb 1a                	jmp    7094a5 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x12e5>
  70948b:	49 8b b6 08 02 00 00 	mov    0x208(%r14),%rsi
  709492:	48 8d bc 24 60 02 00 	lea    0x260(%rsp),%rdi
  709499:	00 
  70949a:	48 8b 54 24 28       	mov    0x28(%rsp),%rdx
  70949f:	ff 15 fb 8c 3f 00    	call   *0x3f8cfb(%rip)        # b021a0 <_DYNAMIC+0x358>
  7094a5:	48 8b 84 24 b0 02 00 	mov    0x2b0(%rsp),%rax
  7094ac:	00 
  7094ad:	48 89 84 24 c0 00 00 	mov    %rax,0xc0(%rsp)
  7094b4:	00 
  7094b5:	0f 28 84 24 a0 02 00 	movaps 0x2a0(%rsp),%xmm0
  7094bc:	00 
  7094bd:	0f 29 84 24 b0 00 00 	movaps %xmm0,0xb0(%rsp)
  7094c4:	00 
  7094c5:	66 0f 6f 84 24 60 02 	movdqa 0x260(%rsp),%xmm0
  7094cc:	00 00 
  7094ce:	66 0f 6f 8c 24 70 02 	movdqa 0x270(%rsp),%xmm1
  7094d5:	00 00 
  7094d7:	0f 28 94 24 80 02 00 	movaps 0x280(%rsp),%xmm2
  7094de:	00 
  7094df:	0f 28 9c 24 90 02 00 	movaps 0x290(%rsp),%xmm3
  7094e6:	00 
  7094e7:	0f 29 9c 24 a0 00 00 	movaps %xmm3,0xa0(%rsp)
  7094ee:	00 
  7094ef:	0f 29 94 24 90 00 00 	movaps %xmm2,0x90(%rsp)
  7094f6:	00 
  7094f7:	66 0f 7f 8c 24 80 00 	movdqa %xmm1,0x80(%rsp)
  7094fe:	00 00 
  709500:	66 0f 7f 44 24 70    	movdqa %xmm0,0x70(%rsp)
  709506:	48 8d bc 24 60 01 00 	lea    0x160(%rsp),%rdi
  70950d:	00 
  70950e:	49 8d b6 f8 05 00 00 	lea    0x5f8(%r14),%rsi
  709515:	48 8b 54 24 48       	mov    0x48(%rsp),%rdx
  70951a:	48 8d 4c 24 70       	lea    0x70(%rsp),%rcx
  70951f:	44 8b 44 24 08       	mov    0x8(%rsp),%r8d
  709524:	4c 8d 8c 24 74 03 00 	lea    0x374(%rsp),%r9
  70952b:	00 
  70952c:	e8 df 80 02 00       	call   731610 <<gpui::property::Overrides>::update_base>
  709531:	8b 84 24 60 01 00 00 	mov    0x160(%rsp),%eax
  709538:	8b 8c 24 65 01 00 00 	mov    0x165(%rsp),%ecx
  70953f:	0f b6 ac 24 69 01 00 	movzbl 0x169(%rsp),%ebp
  709546:	00 
  709547:	48 c1 e5 20          	shl    $0x20,%rbp
  70954b:	48 09 cd             	or     %rcx,%rbp
  70954e:	0f b6 bc 24 64 01 00 	movzbl 0x164(%rsp),%edi
  709555:	00 
  709556:	83 f8 02             	cmp    $0x2,%eax
  709559:	0f 84 ba 08 00 00    	je     709e19 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1c59>
  70955f:	48 8d 8c 24 68 01 00 	lea    0x168(%rsp),%rcx
  709566:	00 
  709567:	0f 10 41 40          	movups 0x40(%rcx),%xmm0
  70956b:	48 8d 94 24 ca 01 00 	lea    0x1ca(%rsp),%rdx
  709572:	00 
  709573:	0f 11 42 3e          	movups %xmm0,0x3e(%rdx)
  709577:	0f 10 41 02          	movups 0x2(%rcx),%xmm0
  70957b:	0f 10 49 12          	movups 0x12(%rcx),%xmm1
  70957f:	0f 10 51 22          	movups 0x22(%rcx),%xmm2
  709583:	0f 10 59 32          	movups 0x32(%rcx),%xmm3
  709587:	0f 11 5a 30          	movups %xmm3,0x30(%rdx)
  70958b:	0f 11 52 20          	movups %xmm2,0x20(%rdx)
  70958f:	0f 11 4a 10          	movups %xmm1,0x10(%rdx)
  709593:	0f 11 02             	movups %xmm0,(%rdx)
  709596:	89 84 24 c0 01 00 00 	mov    %eax,0x1c0(%rsp)
  70959d:	40 88 bc 24 c4 01 00 	mov    %dil,0x1c4(%rsp)
  7095a4:	00 
  7095a5:	48 89 e8             	mov    %rbp,%rax
  7095a8:	48 c1 e8 20          	shr    $0x20,%rax
  7095ac:	88 84 24 c9 01 00 00 	mov    %al,0x1c9(%rsp)
  7095b3:	89 ac 24 c5 01 00 00 	mov    %ebp,0x1c5(%rsp)
  7095ba:	f3 0f 6f 84 24 d0 01 	movdqu 0x1d0(%rsp),%xmm0
  7095c1:	00 00 
  7095c3:	f3 0f 6f 8c 24 e0 01 	movdqu 0x1e0(%rsp),%xmm1
  7095ca:	00 00 
  7095cc:	0f 10 94 24 f0 01 00 	movups 0x1f0(%rsp),%xmm2
  7095d3:	00 
  7095d4:	0f 10 9c 24 00 02 00 	movups 0x200(%rsp),%xmm3
  7095db:	00 
  7095dc:	66 0f 7f 84 24 d0 02 	movdqa %xmm0,0x2d0(%rsp)
  7095e3:	00 00 
  7095e5:	66 0f 7f 8c 24 e0 02 	movdqa %xmm1,0x2e0(%rsp)
  7095ec:	00 00 
  7095ee:	0f 29 94 24 f0 02 00 	movaps %xmm2,0x2f0(%rsp)
  7095f5:	00 
  7095f6:	0f 29 9c 24 00 03 00 	movaps %xmm3,0x300(%rsp)
  7095fd:	00 
  7095fe:	48 8b 84 24 10 02 00 	mov    0x210(%rsp),%rax
  709605:	00 
  709606:	48 89 84 24 10 03 00 	mov    %rax,0x310(%rsp)
  70960d:	00 
  70960e:	8b 84 24 c0 01 00 00 	mov    0x1c0(%rsp),%eax
  709615:	89 84 24 c0 02 00 00 	mov    %eax,0x2c0(%rsp)
  70961c:	0f b6 84 24 c4 01 00 	movzbl 0x1c4(%rsp),%eax
  709623:	00 
  709624:	88 84 24 c4 02 00 00 	mov    %al,0x2c4(%rsp)
  70962b:	8b 84 24 c5 01 00 00 	mov    0x1c5(%rsp),%eax
  709632:	89 84 24 c5 02 00 00 	mov    %eax,0x2c5(%rsp)
  709639:	0f b6 84 24 c9 01 00 	movzbl 0x1c9(%rsp),%eax
  709640:	00 
  709641:	88 84 24 c9 02 00 00 	mov    %al,0x2c9(%rsp)
  709648:	8b 84 24 ca 01 00 00 	mov    0x1ca(%rsp),%eax
  70964f:	89 84 24 ca 02 00 00 	mov    %eax,0x2ca(%rsp)
  709656:	0f b7 84 24 ce 01 00 	movzwl 0x1ce(%rsp),%eax
  70965d:	00 
  70965e:	66 89 84 24 ce 02 00 	mov    %ax,0x2ce(%rsp)
  709665:	00 
  709666:	0f b6 84 24 c0 02 00 	movzbl 0x2c0(%rsp),%eax
  70966d:	00 
  70966e:	83 bc 24 60 02 00 00 	cmpl   $0x1,0x260(%rsp)
  709675:	01 
  709676:	75 1a                	jne    709692 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x14d2>
  709678:	8b 8c 24 c4 02 00 00 	mov    0x2c4(%rsp),%ecx
  70967f:	39 8c 24 64 02 00 00 	cmp    %ecx,0x264(%rsp)
  709686:	0f 94 c1             	sete   %cl
  709689:	84 c8                	test   %cl,%al
  70968b:	75 0d                	jne    70969a <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x14da>
  70968d:	e9 38 01 00 00       	jmp    7097ca <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x160a>
  709692:	a8 01                	test   $0x1,%al
  709694:	0f 85 30 01 00 00    	jne    7097ca <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x160a>
  70969a:	0f b6 84 24 c8 02 00 	movzbl 0x2c8(%rsp),%eax
  7096a1:	00 
  7096a2:	83 bc 24 68 02 00 00 	cmpl   $0x1,0x268(%rsp)
  7096a9:	01 
  7096aa:	75 1b                	jne    7096c7 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1507>
  7096ac:	8b 8c 24 cc 02 00 00 	mov    0x2cc(%rsp),%ecx
  7096b3:	39 8c 24 6c 02 00 00 	cmp    %ecx,0x26c(%rsp)
  7096ba:	0f 94 c1             	sete   %cl
  7096bd:	84 c8                	test   %cl,%al
  7096bf:	0f 84 05 01 00 00    	je     7097ca <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x160a>
  7096c5:	eb 08                	jmp    7096cf <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x150f>
  7096c7:	a8 01                	test   $0x1,%al
  7096c9:	0f 85 fb 00 00 00    	jne    7097ca <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x160a>
  7096cf:	8b 84 24 70 02 00 00 	mov    0x270(%rsp),%eax
  7096d6:	3b 84 24 d0 02 00 00 	cmp    0x2d0(%rsp),%eax
  7096dd:	0f 85 e7 00 00 00    	jne    7097ca <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x160a>
  7096e3:	8b 84 24 74 02 00 00 	mov    0x274(%rsp),%eax
  7096ea:	3b 84 24 d4 02 00 00 	cmp    0x2d4(%rsp),%eax
  7096f1:	0f 85 d3 00 00 00    	jne    7097ca <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x160a>
  7096f7:	8b 84 24 78 02 00 00 	mov    0x278(%rsp),%eax
  7096fe:	3b 84 24 d8 02 00 00 	cmp    0x2d8(%rsp),%eax
  709705:	0f 85 bf 00 00 00    	jne    7097ca <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x160a>
  70970b:	0f b6 84 24 b4 02 00 	movzbl 0x2b4(%rsp),%eax
  709712:	00 
  709713:	3a 84 24 14 03 00 00 	cmp    0x314(%rsp),%al
  70971a:	0f 85 aa 00 00 00    	jne    7097ca <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x160a>
  709720:	0f b6 84 24 b6 02 00 	movzbl 0x2b6(%rsp),%eax
  709727:	00 
  709728:	3a 84 24 16 03 00 00 	cmp    0x316(%rsp),%al
  70972f:	0f 85 95 00 00 00    	jne    7097ca <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x160a>
  709735:	0f b6 84 24 b7 02 00 	movzbl 0x2b7(%rsp),%eax
  70973c:	00 
  70973d:	3a 84 24 17 03 00 00 	cmp    0x317(%rsp),%al
  709744:	0f 85 80 00 00 00    	jne    7097ca <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x160a>
  70974a:	0f b6 84 24 b5 02 00 	movzbl 0x2b5(%rsp),%eax
  709751:	00 
  709752:	3a 84 24 15 03 00 00 	cmp    0x315(%rsp),%al
  709759:	75 6f                	jne    7097ca <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x160a>
  70975b:	48 8d bc 24 9c 02 00 	lea    0x29c(%rsp),%rdi
  709762:	00 
  709763:	48 8d b4 24 fc 02 00 	lea    0x2fc(%rsp),%rsi
  70976a:	00 
  70976b:	e8 90 67 01 00       	call   71ff00 <<gpui_reactivity_core::geometry::Affine as gpui::property::ExactValue>::same>
  709770:	84 c0                	test   %al,%al
  709772:	74 56                	je     7097ca <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x160a>
  709774:	f3 0f 6f 84 24 7c 02 	movdqu 0x27c(%rsp),%xmm0
  70977b:	00 00 
  70977d:	f3 0f 6f 8c 24 dc 02 	movdqu 0x2dc(%rsp),%xmm1
  709784:	00 00 
  709786:	66 0f 74 c8          	pcmpeqb %xmm0,%xmm1
  70978a:	66 0f d7 c1          	pmovmskb %xmm1,%eax
  70978e:	3d ff ff 00 00       	cmp    $0xffff,%eax
  709793:	75 35                	jne    7097ca <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x160a>
  709795:	f3 0f 6f 84 24 8c 02 	movdqu 0x28c(%rsp),%xmm0
  70979c:	00 00 
  70979e:	f3 0f 6f 8c 24 ec 02 	movdqu 0x2ec(%rsp),%xmm1
  7097a5:	00 00 
  7097a7:	66 0f 74 c8          	pcmpeqb %xmm0,%xmm1
  7097ab:	66 0f d7 c1          	pmovmskb %xmm1,%eax
  7097af:	3d ff ff 00 00       	cmp    $0xffff,%eax
  7097b4:	75 14                	jne    7097ca <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x160a>
  7097b6:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  7097bb:	48 8b 44 24 58       	mov    0x58(%rsp),%rax
  7097c0:	48 8b 4c 24 38       	mov    0x38(%rsp),%rcx
  7097c5:	e9 08 01 00 00       	jmp    7098d2 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1712>
  7097ca:	48 8d 05 6f b2 3c 00 	lea    0x3cb26f(%rip),%rax        # ad4a40 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0x1198>
  7097d1:	4a 8b 44 e8 f8       	mov    -0x8(%rax,%r13,8),%rax
  7097d6:	80 78 13 02          	cmpb   $0x2,0x13(%rax)
  7097da:	75 11                	jne    7097ed <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x162d>
  7097dc:	49 8d be 48 06 00 00 	lea    0x648(%r14),%rdi
  7097e3:	48 8b 74 24 48       	mov    0x48(%rsp),%rsi
  7097e8:	e8 73 82 01 00       	call   721a60 <<alloc::collections::btree::map::BTreeMap<u64, alloc::collections::btree::set_val::SetValZST>>::insert>
  7097ed:	66 83 7c 24 08 05    	cmpw   $0x5,0x8(%rsp)
  7097f3:	4c 8b 64 24 28       	mov    0x28(%rsp),%r12
  7097f8:	75 5a                	jne    709854 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1694>
  7097fa:	48 8b 84 24 c8 00 00 	mov    0xc8(%rsp),%rax
  709801:	00 
  709802:	8b 40 20             	mov    0x20(%rax),%eax
  709805:	89 c1                	mov    %eax,%ecx
  709807:	83 e1 07             	and    $0x7,%ecx
  70980a:	83 f9 06             	cmp    $0x6,%ecx
  70980d:	74 45                	je     709854 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1694>
  70980f:	c1 e8 03             	shr    $0x3,%eax
  709812:	74 40                	je     709854 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1694>
  709814:	49 8b b6 b8 02 00 00 	mov    0x2b8(%r14),%rsi
  70981b:	ff c8                	dec    %eax
  70981d:	48 39 c6             	cmp    %rax,%rsi
  709820:	0f 86 fd 07 00 00    	jbe    70a023 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1e63>
  709826:	49 8b ae b0 02 00 00 	mov    0x2b0(%r14),%rbp
  70982d:	48 8d 04 80          	lea    (%rax,%rax,4),%rax
  709831:	48 c1 e0 04          	shl    $0x4,%rax
  709835:	48 83 7c 05 00 fe    	cmpq   $0xfffffffffffffffe,0x0(%rbp,%rax,1)
  70983b:	0f 84 65 07 00 00    	je     709fa6 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1de6>
  709841:	48 01 c5             	add    %rax,%rbp
  709844:	48 89 ef             	mov    %rbp,%rdi
  709847:	e8 b4 80 ff ff       	call   701900 <core::ptr::drop_glue::<core::option::Option<gpui::runtime::Shaped>>>
  70984c:	48 c7 45 00 ff ff ff 	movq   $0xffffffffffffffff,0x0(%rbp)
  709853:	ff 
  709854:	49 8b 8e a0 02 00 00 	mov    0x2a0(%r14),%rcx
  70985b:	49 8d be 00 02 00 00 	lea    0x200(%r14),%rdi
  709862:	4c 89 e6             	mov    %r12,%rsi
  709865:	48 8d 94 24 c0 01 00 	lea    0x1c0(%rsp),%rdx
  70986c:	00 
  70986d:	ff 15 2d 8a 3f 00    	call   *0x3f8a2d(%rip)        # b022a0 <_DYNAMIC+0x458>
  709873:	41 c6 86 1f 07 00 00 	movb   $0x1,0x71f(%r14)
  70987a:	01 
  70987b:	b0 01                	mov    $0x1,%al
  70987d:	48 89 84 24 e8 00 00 	mov    %rax,0xe8(%rsp)
  709884:	00 
  709885:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  70988a:	48 8b 4c 24 38       	mov    0x38(%rsp),%rcx
  70988f:	4c 8b 6c 24 28       	mov    0x28(%rsp),%r13
  709894:	4c 39 ac 24 50 01 00 	cmp    %r13,0x150(%rsp)
  70989b:	00 
  70989c:	0f 94 c0             	sete   %al
  70989f:	84 84 24 d0 00 00 00 	test   %al,0xd0(%rsp)
  7098a6:	74 0c                	je     7098b4 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x16f4>
  7098a8:	b0 01                	mov    $0x1,%al
  7098aa:	48 89 84 24 d0 00 00 	mov    %rax,0xd0(%rsp)
  7098b1:	00 
  7098b2:	eb 19                	jmp    7098cd <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x170d>
  7098b4:	49 ff 86 08 07 00 00 	incq   0x708(%r14)
  7098bb:	b0 01                	mov    $0x1,%al
  7098bd:	48 89 84 24 d0 00 00 	mov    %rax,0xd0(%rsp)
  7098c4:	00 
  7098c5:	4c 89 ac 24 50 01 00 	mov    %r13,0x150(%rsp)
  7098cc:	00 
  7098cd:	48 8b 44 24 58       	mov    0x58(%rsp),%rax
  7098d2:	48 83 c1 04          	add    $0x4,%rcx
  7098d6:	48 39 c8             	cmp    %rcx,%rax
  7098d9:	0f 85 cc f5 ff ff    	jne    708eab <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0xceb>
  7098df:	e9 ee 02 00 00       	jmp    709bd2 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1a12>
  7098e4:	48 8b 47 08          	mov    0x8(%rdi),%rax
  7098e8:	ff 15 02 88 3f 00    	call   *0x3f8802(%rip)        # b020f0 <_DYNAMIC+0x2a8>
  7098ee:	e9 75 fa ff ff       	jmp    709368 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x11a8>
  7098f3:	48 8b 47 08          	mov    0x8(%rdi),%rax
  7098f7:	ff 15 f3 87 3f 00    	call   *0x3f87f3(%rip)        # b020f0 <_DYNAMIC+0x2a8>
  7098fd:	e9 a1 f9 ff ff       	jmp    7092a3 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x10e3>
  709902:	48 8b 47 08          	mov    0x8(%rdi),%rax
  709906:	ff 15 e4 87 3f 00    	call   *0x3f87e4(%rip)        # b020f0 <_DYNAMIC+0x2a8>
  70990c:	e9 df fa ff ff       	jmp    7093f0 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1230>
  709911:	49 83 c4 04          	add    $0x4,%r12
  709915:	4c 39 64 24 28       	cmp    %r12,0x28(%rsp)
  70991a:	0f 84 b1 f4 ff ff    	je     708dd1 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0xc11>
  709920:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  709925:	42 8b 3c 20          	mov    (%rax,%r12,1),%edi
  709929:	ff 15 39 89 3f 00    	call   *0x3f8939(%rip)        # b02268 <_DYNAMIC+0x420>
  70992f:	66 85 c0             	test   %ax,%ax
  709932:	74 dd                	je     709911 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1751>
  709934:	48 8b 4c 24 18       	mov    0x18(%rsp),%rcx
  709939:	48 89 4c 24 70       	mov    %rcx,0x70(%rsp)
  70993e:	48 8b 8c 24 50 03 00 	mov    0x350(%rsp),%rcx
  709945:	00 
  709946:	48 8d 54 24 78       	lea    0x78(%rsp),%rdx
  70994b:	48 89 4a 10          	mov    %rcx,0x10(%rdx)
  70994f:	66 0f 6f 84 24 40 03 	movdqa 0x340(%rsp),%xmm0
  709956:	00 00 
  709958:	f3 0f 7f 02          	movdqu %xmm0,(%rdx)
  70995c:	48 8d bc 24 60 01 00 	lea    0x160(%rsp),%rdi
  709963:	00 
  709964:	48 8d 74 24 70       	lea    0x70(%rsp),%rsi
  709969:	89 c2                	mov    %eax,%edx
  70996b:	ff 15 ff 88 3f 00    	call   *0x3f88ff(%rip)        # b02270 <_DYNAMIC+0x428>
  709971:	80 bc 24 60 01 00 00 	cmpb   $0xff,0x160(%rsp)
  709978:	ff 
  709979:	75 96                	jne    709911 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1751>
  70997b:	0f b6 bc 24 62 01 00 	movzbl 0x162(%rsp),%edi
  709982:	00 
  709983:	8b 84 24 63 01 00 00 	mov    0x163(%rsp),%eax
  70998a:	0f b6 ac 24 67 01 00 	movzbl 0x167(%rsp),%ebp
  709991:	00 
  709992:	48 c1 e5 20          	shl    $0x20,%rbp
  709996:	48 09 c5             	or     %rax,%rbp
  709999:	b8 24 00 00 00       	mov    $0x24,%eax
  70999e:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  7099a3:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  7099a8:	48 8b 74 24 60       	mov    0x60(%rsp),%rsi
  7099ad:	48 85 f6             	test   %rsi,%rsi
  7099b0:	0f 8e 12 02 00 00    	jle    709bc8 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1a08>
  7099b6:	ba 01 00 00 00       	mov    $0x1,%edx
  7099bb:	89 7c 24 18          	mov    %edi,0x18(%rsp)
  7099bf:	48 8b 7c 24 50       	mov    0x50(%rsp),%rdi
  7099c4:	ff 15 c6 86 3f 00    	call   *0x3f86c6(%rip)        # b02090 <_DYNAMIC+0x248>
  7099ca:	8b 7c 24 18          	mov    0x18(%rsp),%edi
  7099ce:	4c 8b 44 24 30       	mov    0x30(%rsp),%r8
  7099d3:	e9 1f 03 00 00       	jmp    709cf7 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1b37>
  7099d8:	31 ff                	xor    %edi,%edi
  7099da:	48 8b 74 24 60       	mov    0x60(%rsp),%rsi
  7099df:	48 85 f6             	test   %rsi,%rsi
  7099e2:	7e 5c                	jle    709a40 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1880>
  7099e4:	ba 01 00 00 00       	mov    $0x1,%edx
  7099e9:	89 fd                	mov    %edi,%ebp
  7099eb:	48 8b 7c 24 50       	mov    0x50(%rsp),%rdi
  7099f0:	ff 15 9a 86 3f 00    	call   *0x3f869a(%rip)        # b02090 <_DYNAMIC+0x248>
  7099f6:	89 ef                	mov    %ebp,%edi
  7099f8:	eb 46                	jmp    709a40 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1880>
  7099fa:	0f b6 bc 24 62 01 00 	movzbl 0x162(%rsp),%edi
  709a01:	00 
  709a02:	8b 84 24 63 01 00 00 	mov    0x163(%rsp),%eax
  709a09:	0f b6 ac 24 67 01 00 	movzbl 0x167(%rsp),%ebp
  709a10:	00 
  709a11:	48 c1 e5 20          	shl    $0x20,%rbp
  709a15:	48 09 c5             	or     %rax,%rbp
  709a18:	b8 24 00 00 00       	mov    $0x24,%eax
  709a1d:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  709a22:	e9 99 02 00 00       	jmp    709cc0 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1b00>
  709a27:	b0 01                	mov    $0x1,%al
  709a29:	48 89 44 24 40       	mov    %rax,0x40(%rsp)
  709a2e:	49 8b ae c8 05 00 00 	mov    0x5c8(%r14),%rbp
  709a35:	48 85 ed             	test   %rbp,%rbp
  709a38:	0f 85 0e ef ff ff    	jne    70894c <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x78c>
  709a3e:	31 ff                	xor    %edi,%edi
  709a40:	80 7c 24 40 00       	cmpb   $0x0,0x40(%rsp)
  709a45:	74 3c                	je     709a83 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x18c3>
  709a47:	41 80 be 1f 07 00 00 	cmpb   $0x1,0x71f(%r14)
  709a4e:	01 
  709a4f:	75 32                	jne    709a83 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x18c3>
  709a51:	48 8d 7c 24 70       	lea    0x70(%rsp),%rdi
  709a56:	4c 89 f6             	mov    %r14,%rsi
  709a59:	48 8b 94 24 58 01 00 	mov    0x158(%rsp),%rdx
  709a60:	00 
  709a61:	31 c9                	xor    %ecx,%ecx
  709a63:	e8 98 d7 ff ff       	call   707200 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::describe_with>
  709a68:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  709a6d:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  709a71:	75 1e                	jne    709a91 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x18d1>
  709a73:	48 c7 44 24 08 fe ff 	movq   $0xfffffffffffffffe,0x8(%rsp)
  709a7a:	ff ff 
  709a7c:	31 ff                	xor    %edi,%edi
  709a7e:	e9 94 02 00 00       	jmp    709d17 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1b57>
  709a83:	48 c7 44 24 08 fe ff 	movq   $0xfffffffffffffffe,0x8(%rsp)
  709a8a:	ff ff 
  709a8c:	e9 86 02 00 00       	jmp    709d17 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1b57>
  709a91:	0f b6 7c 24 78       	movzbl 0x78(%rsp),%edi
  709a96:	0f b6 4c 24 7f       	movzbl 0x7f(%rsp),%ecx
  709a9b:	c1 e1 10             	shl    $0x10,%ecx
  709a9e:	0f b7 54 24 7d       	movzwl 0x7d(%rsp),%edx
  709aa3:	09 ca                	or     %ecx,%edx
  709aa5:	48 c1 e2 20          	shl    $0x20,%rdx
  709aa9:	8b 6c 24 79          	mov    0x79(%rsp),%ebp
  709aad:	48 09 d5             	or     %rdx,%rbp
  709ab0:	4c 8b 84 24 80 00 00 	mov    0x80(%rsp),%r8
  709ab7:	00 
  709ab8:	4c 8b ac 24 88 00 00 	mov    0x88(%rsp),%r13
  709abf:	00 
  709ac0:	f3 0f 6f 84 24 90 00 	movdqu 0x90(%rsp),%xmm0
  709ac7:	00 00 
  709ac9:	66 0f 7f 84 24 c0 01 	movdqa %xmm0,0x1c0(%rsp)
  709ad0:	00 00 
  709ad2:	48 8b 8c 24 a0 00 00 	mov    0xa0(%rsp),%rcx
  709ad9:	00 
  709ada:	48 89 8c 24 d0 01 00 	mov    %rcx,0x1d0(%rsp)
  709ae1:	00 
  709ae2:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  709ae7:	e9 2b 02 00 00       	jmp    709d17 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1b57>
  709aec:	b8 20 00 00 00       	mov    $0x20,%eax
  709af1:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  709af6:	40 b7 0c             	mov    $0xc,%dil
  709af9:	31 ed                	xor    %ebp,%ebp
  709afb:	4d 89 f8             	mov    %r15,%r8
  709afe:	e9 bd 01 00 00       	jmp    709cc0 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1b00>
  709b03:	49 8b 86 90 06 00 00 	mov    0x690(%r14),%rax
  709b0a:	48 8d 48 01          	lea    0x1(%rax),%rcx
  709b0e:	49 3b 8e 60 06 00 00 	cmp    0x660(%r14),%rcx
  709b15:	40 0f 94 c5          	sete   %bpl
  709b19:	48 ff c0             	inc    %rax
  709b1c:	0f 84 d5 f0 ff ff    	je     708bf7 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0xa37>
  709b22:	49 8d b6 00 02 00 00 	lea    0x200(%r14),%rsi
  709b29:	48 8d bc 24 60 01 00 	lea    0x160(%rsp),%rdi
  709b30:	00 
  709b31:	48 8d 8c 24 60 02 00 	lea    0x260(%rsp),%rcx
  709b38:	00 
  709b39:	ff 15 69 87 3f 00    	call   *0x3f8769(%rip)        # b022a8 <_DYNAMIC+0x460>
  709b3f:	80 bc 24 60 01 00 00 	cmpb   $0x0,0x160(%rsp)
  709b46:	00 
  709b47:	74 21                	je     709b6a <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x19aa>
  709b49:	8b 94 24 84 01 00 00 	mov    0x184(%rsp),%edx
  709b50:	49 89 96 08 07 00 00 	mov    %rdx,0x708(%r14)
  709b57:	40 84 ed             	test   %bpl,%bpl
  709b5a:	0f 84 48 01 00 00    	je     709ca8 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1ae8>
  709b60:	48 8d 94 24 64 01 00 	lea    0x164(%rsp),%rdx
  709b67:	00 
  709b68:	eb 16                	jmp    709b80 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x19c0>
  709b6a:	49 c7 86 08 07 00 00 	movq   $0x0,0x708(%r14)
  709b71:	00 00 00 00 
  709b75:	31 d2                	xor    %edx,%edx
  709b77:	40 84 ed             	test   %bpl,%bpl
  709b7a:	0f 84 28 01 00 00    	je     709ca8 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1ae8>
  709b80:	48 8d 7c 24 70       	lea    0x70(%rsp),%rdi
  709b85:	4c 89 f6             	mov    %r14,%rsi
  709b88:	e8 f3 07 00 00       	call   70a380 <<gpui::runtime::Runtime<unit_action_cost::Model>>::finish_color_slot>
  709b8d:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  709b92:	0f b6 7c 24 78       	movzbl 0x78(%rsp),%edi
  709b97:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  709b9b:	0f 85 8c 00 00 00    	jne    709c2d <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1a6d>
  709ba1:	40 f6 c7 01          	test   $0x1,%dil
  709ba5:	0f 84 f6 00 00 00    	je     709ca1 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1ae1>
  709bab:	48 c7 44 24 08 fe ff 	movq   $0xfffffffffffffffe,0x8(%rsp)
  709bb2:	ff ff 
  709bb4:	40 b7 02             	mov    $0x2,%dil
  709bb7:	e9 04 01 00 00       	jmp    709cc0 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1b00>
  709bbc:	31 ff                	xor    %edi,%edi
  709bbe:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  709bc3:	e9 12 fe ff ff       	jmp    7099da <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x181a>
  709bc8:	4c 8b 44 24 30       	mov    0x30(%rsp),%r8
  709bcd:	e9 25 01 00 00       	jmp    709cf7 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1b37>
  709bd2:	48 8b 84 24 e8 00 00 	mov    0xe8(%rsp),%rax
  709bd9:	00 
  709bda:	34 01                	xor    $0x1,%al
  709bdc:	0f b6 c0             	movzbl %al,%eax
  709bdf:	31 ff                	xor    %edi,%edi
  709be1:	f6 84 24 40 01 00 00 	testb  $0x1,0x140(%rsp)
  709be8:	01 
  709be9:	0f 45 f8             	cmovne %eax,%edi
  709bec:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  709bf1:	48 85 c0             	test   %rax,%rax
  709bf4:	0f 84 e0 fd ff ff    	je     7099da <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x181a>
  709bfa:	f6 00 01             	testb  $0x1,(%rax)
  709bfd:	0f 85 d7 fd ff ff    	jne    7099da <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x181a>
  709c03:	89 fd                	mov    %edi,%ebp
  709c05:	48 8b 40 08          	mov    0x8(%rax),%rax
  709c09:	a8 01                	test   $0x1,%al
  709c0b:	75 14                	jne    709c21 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1a61>
  709c0d:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  709c12:	48 83 c0 08          	add    $0x8,%rax
  709c16:	f0 48 83 28 02       	lock subq $0x2,(%rax)
  709c1b:	0f 84 b5 03 00 00    	je     709fd6 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1e16>
  709c21:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  709c26:	89 ef                	mov    %ebp,%edi
  709c28:	e9 ad fd ff ff       	jmp    7099da <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x181a>
  709c2d:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  709c32:	0f b6 44 24 7f       	movzbl 0x7f(%rsp),%eax
  709c37:	c1 e0 10             	shl    $0x10,%eax
  709c3a:	0f b7 4c 24 7d       	movzwl 0x7d(%rsp),%ecx
  709c3f:	09 c1                	or     %eax,%ecx
  709c41:	48 c1 e1 20          	shl    $0x20,%rcx
  709c45:	8b 6c 24 79          	mov    0x79(%rsp),%ebp
  709c49:	48 09 cd             	or     %rcx,%rbp
  709c4c:	4c 8b 84 24 80 00 00 	mov    0x80(%rsp),%r8
  709c53:	00 
  709c54:	4c 8b ac 24 88 00 00 	mov    0x88(%rsp),%r13
  709c5b:	00 
  709c5c:	0f 10 84 24 90 00 00 	movups 0x90(%rsp),%xmm0
  709c63:	00 
  709c64:	0f 29 84 24 20 03 00 	movaps %xmm0,0x320(%rsp)
  709c6b:	00 
  709c6c:	48 8b 84 24 a0 00 00 	mov    0xa0(%rsp),%rax
  709c73:	00 
  709c74:	48 89 84 24 30 03 00 	mov    %rax,0x330(%rsp)
  709c7b:	00 
  709c7c:	eb 42                	jmp    709cc0 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1b00>
  709c7e:	0f b6 bc 24 62 01 00 	movzbl 0x162(%rsp),%edi
  709c85:	00 
  709c86:	8b 84 24 63 01 00 00 	mov    0x163(%rsp),%eax
  709c8d:	0f b6 ac 24 67 01 00 	movzbl 0x167(%rsp),%ebp
  709c94:	00 
  709c95:	48 c1 e5 20          	shl    $0x20,%rbp
  709c99:	48 09 c5             	or     %rax,%rbp
  709c9c:	e9 85 01 00 00       	jmp    709e26 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1c66>
  709ca1:	49 8b 96 08 07 00 00 	mov    0x708(%r14),%rdx
  709ca8:	48 85 d2             	test   %rdx,%rdx
  709cab:	0f 95 c0             	setne  %al
  709cae:	41 08 86 1f 07 00 00 	or     %al,0x71f(%r14)
  709cb5:	48 c7 44 24 08 fe ff 	movq   $0xfffffffffffffffe,0x8(%rsp)
  709cbc:	ff ff 
  709cbe:	31 ff                	xor    %edi,%edi
  709cc0:	48 8b 74 24 18       	mov    0x18(%rsp),%rsi
  709cc5:	48 85 f6             	test   %rsi,%rsi
  709cc8:	7e 22                	jle    709cec <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1b2c>
  709cca:	ba 01 00 00 00       	mov    $0x1,%edx
  709ccf:	4c 89 44 24 30       	mov    %r8,0x30(%rsp)
  709cd4:	89 7c 24 18          	mov    %edi,0x18(%rsp)
  709cd8:	48 8b 7c 24 28       	mov    0x28(%rsp),%rdi
  709cdd:	ff 15 ad 83 3f 00    	call   *0x3f83ad(%rip)        # b02090 <_DYNAMIC+0x248>
  709ce3:	8b 7c 24 18          	mov    0x18(%rsp),%edi
  709ce7:	4c 8b 44 24 30       	mov    0x30(%rsp),%r8
  709cec:	83 7c 24 08 fe       	cmpl   $0xfffffffe,0x8(%rsp)
  709cf1:	0f 84 49 fd ff ff    	je     709a40 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1880>
  709cf7:	48 8b 84 24 30 03 00 	mov    0x330(%rsp),%rax
  709cfe:	00 
  709cff:	48 89 84 24 d0 01 00 	mov    %rax,0x1d0(%rsp)
  709d06:	00 
  709d07:	0f 28 84 24 20 03 00 	movaps 0x320(%rsp),%xmm0
  709d0e:	00 
  709d0f:	0f 29 84 24 c0 01 00 	movaps %xmm0,0x1c0(%rsp)
  709d16:	00 
  709d17:	40 0f b6 c7          	movzbl %dil,%eax
  709d1b:	48 c1 e5 08          	shl    $0x8,%rbp
  709d1f:	48 09 c5             	or     %rax,%rbp
  709d22:	48 8b 84 24 d0 01 00 	mov    0x1d0(%rsp),%rax
  709d29:	00 
  709d2a:	48 89 84 24 20 01 00 	mov    %rax,0x120(%rsp)
  709d31:	00 
  709d32:	66 0f 6f 84 24 c0 01 	movdqa 0x1c0(%rsp),%xmm0
  709d39:	00 00 
  709d3b:	f3 0f 7f 84 24 10 01 	movdqu %xmm0,0x110(%rsp)
  709d42:	00 00 
  709d44:	48 8b 4c 24 08       	mov    0x8(%rsp),%rcx
  709d49:	48 89 8c 24 f0 00 00 	mov    %rcx,0xf0(%rsp)
  709d50:	00 
  709d51:	48 89 ac 24 f8 00 00 	mov    %rbp,0xf8(%rsp)
  709d58:	00 
  709d59:	4c 89 84 24 00 01 00 	mov    %r8,0x100(%rsp)
  709d60:	00 
  709d61:	4c 89 ac 24 08 01 00 	mov    %r13,0x108(%rsp)
  709d68:	00 
  709d69:	66 0f 7f 84 24 40 02 	movdqa %xmm0,0x240(%rsp)
  709d70:	00 00 
  709d72:	48 89 84 24 50 02 00 	mov    %rax,0x250(%rsp)
  709d79:	00 
  709d7a:	48 8b 84 24 00 01 00 	mov    0x100(%rsp),%rax
  709d81:	00 
  709d82:	48 89 84 24 30 02 00 	mov    %rax,0x230(%rsp)
  709d89:	00 
  709d8a:	48 8b 84 24 08 01 00 	mov    0x108(%rsp),%rax
  709d91:	00 
  709d92:	48 89 84 24 38 02 00 	mov    %rax,0x238(%rsp)
  709d99:	00 
  709d9a:	48 8b 84 24 f0 00 00 	mov    0xf0(%rsp),%rax
  709da1:	00 
  709da2:	48 89 84 24 20 02 00 	mov    %rax,0x220(%rsp)
  709da9:	00 
  709daa:	48 8b 84 24 f8 00 00 	mov    0xf8(%rsp),%rax
  709db1:	00 
  709db2:	48 89 84 24 28 02 00 	mov    %rax,0x228(%rsp)
  709db9:	00 
  709dba:	31 ed                	xor    %ebp,%ebp
  709dbc:	e9 41 e6 ff ff       	jmp    708402 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x242>
  709dc1:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  709dc6:	0f b6 44 24 7f       	movzbl 0x7f(%rsp),%eax
  709dcb:	c1 e0 10             	shl    $0x10,%eax
  709dce:	0f b7 4c 24 7d       	movzwl 0x7d(%rsp),%ecx
  709dd3:	09 c1                	or     %eax,%ecx
  709dd5:	48 c1 e1 20          	shl    $0x20,%rcx
  709dd9:	8b 6c 24 79          	mov    0x79(%rsp),%ebp
  709ddd:	48 09 cd             	or     %rcx,%rbp
  709de0:	48 8b 84 24 80 00 00 	mov    0x80(%rsp),%rax
  709de7:	00 
  709de8:	48 89 44 24 30       	mov    %rax,0x30(%rsp)
  709ded:	4c 8b ac 24 88 00 00 	mov    0x88(%rsp),%r13
  709df4:	00 
  709df5:	f3 0f 6f 84 24 90 00 	movdqu 0x90(%rsp),%xmm0
  709dfc:	00 00 
  709dfe:	66 0f 7f 84 24 20 03 	movdqa %xmm0,0x320(%rsp)
  709e05:	00 00 
  709e07:	48 8b 84 24 a0 00 00 	mov    0xa0(%rsp),%rax
  709e0e:	00 
  709e0f:	48 89 84 24 30 03 00 	mov    %rax,0x330(%rsp)
  709e16:	00 
  709e17:	eb 17                	jmp    709e30 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1c70>
  709e19:	48 b8 ff ff ff ff ff 	movabs $0xffffffffff,%rax
  709e20:	00 00 00 
  709e23:	48 21 c5             	and    %rax,%rbp
  709e26:	b8 24 00 00 00       	mov    $0x24,%eax
  709e2b:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  709e30:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
  709e35:	48 85 c9             	test   %rcx,%rcx
  709e38:	0f 84 65 fb ff ff    	je     7099a3 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x17e3>
  709e3e:	f6 01 01             	testb  $0x1,(%rcx)
  709e41:	0f 85 5c fb ff ff    	jne    7099a3 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x17e3>
  709e47:	48 8b 41 08          	mov    0x8(%rcx),%rax
  709e4b:	a8 01                	test   $0x1,%al
  709e4d:	0f 85 50 fb ff ff    	jne    7099a3 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x17e3>
  709e53:	89 7c 24 18          	mov    %edi,0x18(%rsp)
  709e57:	48 8d 41 08          	lea    0x8(%rcx),%rax
  709e5b:	f0 48 83 28 02       	lock subq $0x2,(%rax)
  709e60:	0f 84 53 01 00 00    	je     709fb9 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1df9>
  709e66:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  709e6b:	8b 7c 24 18          	mov    0x18(%rsp),%edi
  709e6f:	e9 34 fb ff ff       	jmp    7099a8 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x17e8>
  709e74:	48 8d 3d 0d a0 3c 00 	lea    0x3ca00d(%rip),%rdi        # ad3e88 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0x5e0>
  709e7b:	ff 15 4f 82 3f 00    	call   *0x3f824f(%rip)        # b020d0 <_DYNAMIC+0x288>
  709e81:	48 8b 47 08          	mov    0x8(%rdi),%rax
  709e85:	ff 15 65 82 3f 00    	call   *0x3f8265(%rip)        # b020f0 <_DYNAMIC+0x2a8>
  709e8b:	e9 c0 e6 ff ff       	jmp    708550 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x390>
  709e90:	41 bc 15 00 00 00    	mov    $0x15,%r12d
  709e96:	eb 3c                	jmp    709ed4 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1d14>
  709e98:	48 8d 05 a5 f7 95 ff 	lea    -0x6a085b(%rip),%rax        # 69644 <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x2e24>
  709e9f:	48 89 84 24 e0 00 00 	mov    %rax,0xe0(%rsp)
  709ea6:	00 
  709ea7:	48 8d 05 42 a8 3c 00 	lea    0x3ca842(%rip),%rax        # ad46f0 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0xe48>
  709eae:	eb 1c                	jmp    709ecc <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1d0c>
  709eb0:	41 bc 14 00 00 00    	mov    $0x14,%r12d
  709eb6:	48 8d 05 73 f7 95 ff 	lea    -0x6a088d(%rip),%rax        # 69630 <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x2e10>
  709ebd:	48 89 84 24 e0 00 00 	mov    %rax,0xe0(%rsp)
  709ec4:	00 
  709ec5:	48 8d 05 0c a8 3c 00 	lea    0x3ca80c(%rip),%rax        # ad46d8 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0xe30>
  709ecc:	48 89 84 24 d8 00 00 	mov    %rax,0xd8(%rsp)
  709ed3:	00 
  709ed4:	48 8b bc 24 e0 00 00 	mov    0xe0(%rsp),%rdi
  709edb:	00 
  709edc:	4c 89 e6             	mov    %r12,%rsi
  709edf:	48 8b 94 24 d8 00 00 	mov    0xd8(%rsp),%rdx
  709ee6:	00 
  709ee7:	ff 15 c3 82 3f 00    	call   *0x3f82c3(%rip)        # b021b0 <_DYNAMIC+0x368>
  709eed:	e9 a7 01 00 00       	jmp    70a099 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1ed9>
  709ef2:	48 8d 3d 0f f7 95 ff 	lea    -0x6a08f1(%rip),%rdi        # 69608 <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x2de8>
  709ef9:	48 8d 15 78 a7 3c 00 	lea    0x3ca778(%rip),%rdx        # ad4678 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0xdd0>
  709f00:	be 13 00 00 00       	mov    $0x13,%esi
  709f05:	ff 15 a5 82 3f 00    	call   *0x3f82a5(%rip)        # b021b0 <_DYNAMIC+0x368>
  709f0b:	e9 89 01 00 00       	jmp    70a099 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1ed9>
  709f10:	48 8d 3d 6e f7 95 ff 	lea    -0x6a0892(%rip),%rdi        # 69685 <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x2e65>
  709f17:	48 8d 15 32 a8 3c 00 	lea    0x3ca832(%rip),%rdx        # ad4750 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0xea8>
  709f1e:	be 93 00 00 00       	mov    $0x93,%esi
  709f23:	ff 15 bf 81 3f 00    	call   *0x3f81bf(%rip)        # b020e8 <_DYNAMIC+0x2a0>
  709f29:	e9 6b 01 00 00       	jmp    70a099 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1ed9>
  709f2e:	48 8d 05 3a f7 95 ff 	lea    -0x6a08c6(%rip),%rax        # 6966f <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x2e4f>
  709f35:	48 89 84 24 30 01 00 	mov    %rax,0x130(%rsp)
  709f3c:	00 
  709f3d:	48 8d 05 c4 a7 3c 00 	lea    0x3ca7c4(%rip),%rax        # ad4708 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0xe60>
  709f44:	48 89 84 24 28 01 00 	mov    %rax,0x128(%rsp)
  709f4b:	00 
  709f4c:	48 8b bc 24 30 01 00 	mov    0x130(%rsp),%rdi
  709f53:	00 
  709f54:	4c 89 ee             	mov    %r13,%rsi
  709f57:	48 8b 94 24 28 01 00 	mov    0x128(%rsp),%rdx
  709f5e:	00 
  709f5f:	ff 15 4b 82 3f 00    	call   *0x3f824b(%rip)        # b021b0 <_DYNAMIC+0x368>
  709f65:	e9 2f 01 00 00       	jmp    70a099 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1ed9>
  709f6a:	48 8d 3d d7 9b 3c 00 	lea    0x3c9bd7(%rip),%rdi        # ad3b48 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0x2a0>
  709f71:	ff 15 59 81 3f 00    	call   *0x3f8159(%rip)        # b020d0 <_DYNAMIC+0x288>
  709f77:	e9 1d 01 00 00       	jmp    70a099 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1ed9>
  709f7c:	48 c7 44 24 20 00 00 	movq   $0x0,0x20(%rsp)
  709f83:	00 00 
  709f85:	48 8d 3d 94 a7 3c 00 	lea    0x3ca794(%rip),%rdi        # ad4720 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0xe78>
  709f8c:	ff 15 3e 81 3f 00    	call   *0x3f813e(%rip)        # b020d0 <_DYNAMIC+0x288>
  709f92:	e9 02 01 00 00       	jmp    70a099 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1ed9>
  709f97:	48 8d 05 7a 9b 3c 00 	lea    0x3c9b7a(%rip),%rax        # ad3b18 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0x270>
  709f9e:	48 89 84 24 b8 01 00 	mov    %rax,0x1b8(%rsp)
  709fa5:	00 
  709fa6:	48 8b bc 24 b8 01 00 	mov    0x1b8(%rsp),%rdi
  709fad:	00 
  709fae:	ff 15 1c 81 3f 00    	call   *0x3f811c(%rip)        # b020d0 <_DYNAMIC+0x288>
  709fb4:	e9 e0 00 00 00       	jmp    70a099 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1ed9>
  709fb9:	48 8b 7c 24 20       	mov    0x20(%rsp),%rdi
  709fbe:	48 8b 47 08          	mov    0x8(%rdi),%rax
  709fc2:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  709fc7:	ff 15 23 81 3f 00    	call   *0x3f8123(%rip)        # b020f0 <_DYNAMIC+0x2a8>
  709fcd:	8b 7c 24 18          	mov    0x18(%rsp),%edi
  709fd1:	e9 d2 f9 ff ff       	jmp    7099a8 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x17e8>
  709fd6:	48 8b 7c 24 20       	mov    0x20(%rsp),%rdi
  709fdb:	48 8b 47 08          	mov    0x8(%rdi),%rax
  709fdf:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  709fe4:	ff 15 06 81 3f 00    	call   *0x3f8106(%rip)        # b020f0 <_DYNAMIC+0x2a8>
  709fea:	89 ef                	mov    %ebp,%edi
  709fec:	e9 e9 f9 ff ff       	jmp    7099da <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x181a>
  709ff1:	48 8d 15 38 9b 3c 00 	lea    0x3c9b38(%rip),%rdx        # ad3b30 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0x288>
  709ff8:	ff 15 c2 81 3f 00    	call   *0x3f81c2(%rip)        # b021c0 <_DYNAMIC+0x378>
  709ffe:	e9 96 00 00 00       	jmp    70a099 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1ed9>
  70a003:	48 8d 05 c6 9e 3c 00 	lea    0x3c9ec6(%rip),%rax        # ad3ed0 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0x628>
  70a00a:	eb 47                	jmp    70a053 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1e93>
  70a00c:	48 89 44 24 28       	mov    %rax,0x28(%rsp)
  70a011:	48 8d 05 d0 9e 3c 00 	lea    0x3c9ed0(%rip),%rax        # ad3ee8 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0x640>
  70a018:	eb 39                	jmp    70a053 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1e93>
  70a01a:	48 8d 05 97 9e 3c 00 	lea    0x3c9e97(%rip),%rax        # ad3eb8 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0x610>
  70a021:	eb 30                	jmp    70a053 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1e93>
  70a023:	48 89 44 24 28       	mov    %rax,0x28(%rsp)
  70a028:	48 8d 05 01 9b 3c 00 	lea    0x3c9b01(%rip),%rax        # ad3b30 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0x288>
  70a02f:	eb 22                	jmp    70a053 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1e93>
  70a031:	48 85 ff             	test   %rdi,%rdi
  70a034:	75 34                	jne    70a06a <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1eaa>
  70a036:	48 c7 44 24 20 00 00 	movq   $0x0,0x20(%rsp)
  70a03d:	00 00 
  70a03f:	ff 15 6b 82 3f 00    	call   *0x3f826b(%rip)        # b022b0 <_DYNAMIC+0x468>
  70a045:	eb 52                	jmp    70a099 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1ed9>
  70a047:	48 89 44 24 28       	mov    %rax,0x28(%rsp)
  70a04c:	48 8d 05 ad 9a 3c 00 	lea    0x3c9aad(%rip),%rax        # ad3b00 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0x258>
  70a053:	48 89 44 24 68       	mov    %rax,0x68(%rsp)
  70a058:	48 8b 7c 24 28       	mov    0x28(%rsp),%rdi
  70a05d:	48 8b 54 24 68       	mov    0x68(%rsp),%rdx
  70a062:	ff 15 58 81 3f 00    	call   *0x3f8158(%rip)        # b021c0 <_DYNAMIC+0x378>
  70a068:	eb 2f                	jmp    70a099 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1ed9>
  70a06a:	48 8b 74 24 78       	mov    0x78(%rsp),%rsi
  70a06f:	48 c7 44 24 20 00 00 	movq   $0x0,0x20(%rsp)
  70a076:	00 00 
  70a078:	ff 15 42 80 3f 00    	call   *0x3f8042(%rip)        # b020c0 <_DYNAMIC+0x278>
  70a07e:	eb 19                	jmp    70a099 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1ed9>
  70a080:	48 8d 3d 94 f5 95 ff 	lea    -0x6a0a6c(%rip),%rdi        # 6961b <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x2dfb>
  70a087:	48 8d 15 02 a6 3c 00 	lea    0x3ca602(%rip),%rdx        # ad4690 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0xde8>
  70a08e:	be 15 00 00 00       	mov    $0x15,%esi
  70a093:	ff 15 17 81 3f 00    	call   *0x3f8117(%rip)        # b021b0 <_DYNAMIC+0x368>
  70a099:	0f 0b                	ud2
  70a09b:	49 89 c5             	mov    %rax,%r13
  70a09e:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  70a0a3:	48 89 45 10          	mov    %rax,0x10(%rbp)
  70a0a7:	eb 6d                	jmp    70a116 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1f56>
  70a0a9:	49 89 c5             	mov    %rax,%r13
  70a0ac:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  70a0b1:	48 89 45 08          	mov    %rax,0x8(%rbp)
  70a0b5:	eb 5f                	jmp    70a116 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1f56>
  70a0b7:	49 89 c5             	mov    %rax,%r13
  70a0ba:	4c 89 65 40          	mov    %r12,0x40(%rbp)
  70a0be:	eb 56                	jmp    70a116 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1f56>
  70a0c0:	48 89 c3             	mov    %rax,%rbx
  70a0c3:	48 8d bc 24 f0 00 00 	lea    0xf0(%rsp),%rdi
  70a0ca:	00 
  70a0cb:	e8 10 a7 ff ff       	call   7047e0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  70a0d0:	48 89 df             	mov    %rbx,%rdi
  70a0d3:	e8 98 83 3c 00       	call   ad2470 <_Unwind_Resume@plt>
  70a0d8:	eb 18                	jmp    70a0f2 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1f32>
  70a0da:	eb 16                	jmp    70a0f2 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1f32>
  70a0dc:	eb 00                	jmp    70a0de <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1f1e>
  70a0de:	49 89 c5             	mov    %rax,%r13
  70a0e1:	48 c7 45 00 ff ff ff 	movq   $0xffffffffffffffff,0x0(%rbp)
  70a0e8:	ff 
  70a0e9:	eb 2b                	jmp    70a116 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1f56>
  70a0eb:	49 89 c5             	mov    %rax,%r13
  70a0ee:	eb 4d                	jmp    70a13d <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1f7d>
  70a0f0:	eb 21                	jmp    70a113 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1f53>
  70a0f2:	49 89 c5             	mov    %rax,%r13
  70a0f5:	eb 29                	jmp    70a120 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1f60>
  70a0f7:	49 89 c5             	mov    %rax,%r13
  70a0fa:	48 83 7c 24 18 00    	cmpq   $0x0,0x18(%rsp)
  70a100:	7e 3b                	jle    70a13d <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1f7d>
  70a102:	ba 01 00 00 00       	mov    $0x1,%edx
  70a107:	48 8b 7c 24 28       	mov    0x28(%rsp),%rdi
  70a10c:	48 8b 74 24 18       	mov    0x18(%rsp),%rsi
  70a111:	eb 24                	jmp    70a137 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1f77>
  70a113:	49 89 c5             	mov    %rax,%r13
  70a116:	48 8b 7c 24 20       	mov    0x20(%rsp),%rdi
  70a11b:	e8 50 77 ff ff       	call   701870 <core::ptr::drop_glue::<core::option::Option<gpui::shared_text::SharedText>>>
  70a120:	48 83 7c 24 60 00    	cmpq   $0x0,0x60(%rsp)
  70a126:	7e 15                	jle    70a13d <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1f7d>
  70a128:	ba 01 00 00 00       	mov    $0x1,%edx
  70a12d:	48 8b 7c 24 50       	mov    0x50(%rsp),%rdi
  70a132:	48 8b 74 24 60       	mov    0x60(%rsp),%rsi
  70a137:	ff 15 53 7f 3f 00    	call   *0x3f7f53(%rip)        # b02090 <_DYNAMIC+0x248>
  70a13d:	4c 89 ef             	mov    %r13,%rdi
  70a140:	ff 15 8a 80 3f 00    	call   *0x3f808a(%rip)        # b021d0 <_DYNAMIC+0x388>
  70a146:	49 89 c5             	mov    %rax,%r13
  70a149:	48 89 d5             	mov    %rdx,%rbp
  70a14c:	48 89 84 24 f8 00 00 	mov    %rax,0xf8(%rsp)
  70a153:	00 
  70a154:	48 89 94 24 00 01 00 	mov    %rdx,0x100(%rsp)
  70a15b:	00 
  70a15c:	48 c7 84 24 f0 00 00 	movq   $0xfffffffffffffffd,0xf0(%rsp)
  70a163:	00 fd ff ff ff 
  70a168:	4c 89 f7             	mov    %r14,%rdi
  70a16b:	e8 40 43 01 00       	call   71e4b0 <<gpui::runtime::Runtime<unit_action_cost::Model>>::poison>
  70a170:	48 c7 84 24 20 02 00 	movq   $0xf,0x220(%rsp)
  70a177:	00 0f 00 00 00 
  70a17c:	48 8b 45 00          	mov    0x0(%rbp),%rax
  70a180:	48 85 c0             	test   %rax,%rax
  70a183:	74 05                	je     70a18a <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1fca>
  70a185:	4c 89 ef             	mov    %r13,%rdi
  70a188:	ff d0                	call   *%rax
  70a18a:	48 8b 75 08          	mov    0x8(%rbp),%rsi
  70a18e:	48 85 f6             	test   %rsi,%rsi
  70a191:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  70a196:	74 0d                	je     70a1a5 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1fe5>
  70a198:	48 8b 55 10          	mov    0x10(%rbp),%rdx
  70a19c:	4c 89 ef             	mov    %r13,%rdi
  70a19f:	ff 15 eb 7e 3f 00    	call   *0x3f7eeb(%rip)        # b02090 <_DYNAMIC+0x248>
  70a1a5:	31 ed                	xor    %ebp,%ebp
  70a1a7:	e9 56 e2 ff ff       	jmp    708402 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x242>
  70a1ac:	48 89 c3             	mov    %rax,%rbx
  70a1af:	48 8b 75 08          	mov    0x8(%rbp),%rsi
  70a1b3:	48 85 f6             	test   %rsi,%rsi
  70a1b6:	74 2b                	je     70a1e3 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x2023>
  70a1b8:	48 8b 55 10          	mov    0x10(%rbp),%rdx
  70a1bc:	4c 89 ef             	mov    %r13,%rdi
  70a1bf:	ff 15 cb 7e 3f 00    	call   *0x3f7ecb(%rip)        # b02090 <_DYNAMIC+0x248>
  70a1c5:	48 89 df             	mov    %rbx,%rdi
  70a1c8:	e8 a3 82 3c 00       	call   ad2470 <_Unwind_Resume@plt>
  70a1cd:	ff 15 0d 7f 3f 00    	call   *0x3f7f0d(%rip)        # b020e0 <_DYNAMIC+0x298>
  70a1d3:	48 89 c3             	mov    %rax,%rbx
  70a1d6:	48 8d bc 24 f0 00 00 	lea    0xf0(%rsp),%rdi
  70a1dd:	00 
  70a1de:	e8 5d 7b ff ff       	call   701d40 <core::ptr::drop_glue::<core::result::Result<core::result::Result<gpui::runtime::paint::PatchOutcome, gpui::runtime::Error>, alloc::boxed::Box<dyn core::any::Any + core::marker::Send>>>>
  70a1e3:	48 89 df             	mov    %rbx,%rdi
  70a1e6:	e8 85 82 3c 00       	call   ad2470 <_Unwind_Resume@plt>
  70a1eb:	ff 15 ef 7e 3f 00    	call   *0x3f7eef(%rip)        # b020e0 <_DYNAMIC+0x298>
  70a1f1:	ff 15 e1 7f 3f 00    	call   *0x3f7fe1(%rip)        # b021d8 <_DYNAMIC+0x390>
