
/tmp/gpui-contained-property-exchange-target/release/deps/unit_action_cost-bcf457ce7db1ee75:     file format elf64-x86-64


Disassembly of section .text:

00000000007080b0 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing>:
  7080b0:	55                   	push   %rbp
  7080b1:	41 57                	push   %r15
  7080b3:	41 56                	push   %r14
  7080b5:	41 55                	push   %r13
  7080b7:	41 54                	push   %r12
  7080b9:	53                   	push   %rbx
  7080ba:	48 81 ec c8 03 00 00 	sub    $0x3c8,%rsp
  7080c1:	4d 89 c4             	mov    %r8,%r12
  7080c4:	49 89 cf             	mov    %rcx,%r15
  7080c7:	49 89 f6             	mov    %rsi,%r14
  7080ca:	48 89 fb             	mov    %rdi,%rbx
  7080cd:	41 83 38 02          	cmpl   $0x2,(%r8)
  7080d1:	75 08                	jne    7080db <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x2b>
  7080d3:	41 c6 86 1f 07 00 00 	movb   $0x1,0x71f(%r14)
  7080da:	01 
  7080db:	4d 85 ff             	test   %r15,%r15
  7080de:	0f 84 94 01 00 00    	je     708278 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1c8>
  7080e4:	41 80 be 1e 07 00 00 	cmpb   $0x1,0x71e(%r14)
  7080eb:	01 
  7080ec:	0f 85 86 01 00 00    	jne    708278 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1c8>
  7080f2:	49 8b 86 28 02 00 00 	mov    0x228(%r14),%rax
  7080f9:	49 8d 8e 30 02 00 00 	lea    0x230(%r14),%rcx
  708100:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  708104:	48 8d 74 24 78       	lea    0x78(%rsp),%rsi
  708109:	48 0f 44 ce          	cmove  %rsi,%rcx
  70810d:	f3 0f 6f 01          	movdqu (%rcx),%xmm0
  708111:	66 0f 7f 84 24 60 01 	movdqa %xmm0,0x160(%rsp)
  708118:	00 00 
  70811a:	74 45                	je     708161 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0xb1>
  70811c:	66 0f 6f 84 24 60 01 	movdqa 0x160(%rsp),%xmm0
  708123:	00 00 
  708125:	f3 0f 7f 84 24 c8 01 	movdqu %xmm0,0x1c8(%rsp)
  70812c:	00 00 
  70812e:	0f b6 8c 24 c8 01 00 	movzbl 0x1c8(%rsp),%ecx
  708135:	00 
  708136:	48 8b 94 24 c9 01 00 	mov    0x1c9(%rsp),%rdx
  70813d:	00 
  70813e:	48 8b b4 24 d0 01 00 	mov    0x1d0(%rsp),%rsi
  708145:	00 
  708146:	48 89 73 18          	mov    %rsi,0x18(%rbx)
  70814a:	48 89 53 11          	mov    %rdx,0x11(%rbx)
  70814e:	48 c7 03 20 00 00 00 	movq   $0x20,(%rbx)
  708155:	48 89 43 08          	mov    %rax,0x8(%rbx)
  708159:	88 4b 10             	mov    %cl,0x10(%rbx)
  70815c:	e9 5e 03 00 00       	jmp    7084bf <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x40f>
  708161:	4c 89 64 24 10       	mov    %r12,0x10(%rsp)
  708166:	41 83 ff 01          	cmp    $0x1,%r15d
  70816a:	0f 85 80 00 00 00    	jne    7081f0 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x140>
  708170:	48 89 d5             	mov    %rdx,%rbp
  708173:	49 8b 8e 48 02 00 00 	mov    0x248(%r14),%rcx
  70817a:	4d 8b a6 50 02 00 00 	mov    0x250(%r14),%r12
  708181:	49 c1 e4 04          	shl    $0x4,%r12
  708185:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
  70818c:	00 00 00 00 
  708190:	4d 85 e4             	test   %r12,%r12
  708193:	0f 84 7a 03 00 00    	je     708513 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x463>
  708199:	4c 8d 69 10          	lea    0x10(%rcx),%r13
  70819d:	48 8b 39             	mov    (%rcx),%rdi
  7081a0:	48 8b 41 08          	mov    0x8(%rcx),%rax
  7081a4:	ff 50 18             	call   *0x18(%rax)
  7081a7:	49 83 c4 f0          	add    $0xfffffffffffffff0,%r12
  7081ab:	4c 89 e9             	mov    %r13,%rcx
  7081ae:	4c 39 f8             	cmp    %r15,%rax
  7081b1:	75 dd                	jne    708190 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0xe0>
  7081b3:	49 8b 8e 60 02 00 00 	mov    0x260(%r14),%rcx
  7081ba:	49 8b 86 68 02 00 00 	mov    0x268(%r14),%rax
  7081c1:	48 c1 e0 03          	shl    $0x3,%rax
  7081c5:	31 f6                	xor    %esi,%esi
  7081c7:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  7081cc:	0f 1f 40 00          	nopl   0x0(%rax)
  7081d0:	48 89 f2             	mov    %rsi,%rdx
  7081d3:	48 39 f0             	cmp    %rsi,%rax
  7081d6:	74 0a                	je     7081e2 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x132>
  7081d8:	48 8d 72 08          	lea    0x8(%rdx),%rsi
  7081dc:	4c 39 3c 11          	cmp    %r15,(%rcx,%rdx,1)
  7081e0:	75 ee                	jne    7081d0 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x120>
  7081e2:	48 39 d0             	cmp    %rdx,%rax
  7081e5:	0f 95 c1             	setne  %cl
  7081e8:	48 89 ea             	mov    %rbp,%rdx
  7081eb:	e9 7f 00 00 00       	jmp    70826f <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1bf>
  7081f0:	48 89 94 24 58 01 00 	mov    %rdx,0x158(%rsp)
  7081f7:	00 
  7081f8:	4d 8b a6 78 02 00 00 	mov    0x278(%r14),%r12
  7081ff:	4d 8b ae 80 02 00 00 	mov    0x280(%r14),%r13
  708206:	49 c1 e5 04          	shl    $0x4,%r13
  70820a:	31 ed                	xor    %ebp,%ebp
  70820c:	0f 1f 40 00          	nopl   0x0(%rax)
  708210:	49 39 ed             	cmp    %rbp,%r13
  708213:	0f 84 0e 03 00 00    	je     708527 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x477>
  708219:	49 8b 3c 2c          	mov    (%r12,%rbp,1),%rdi
  70821d:	49 8b 44 2c 08       	mov    0x8(%r12,%rbp,1),%rax
  708222:	4c 89 fe             	mov    %r15,%rsi
  708225:	ff 50 30             	call   *0x30(%rax)
  708228:	48 83 c5 10          	add    $0x10,%rbp
  70822c:	84 c0                	test   %al,%al
  70822e:	74 e0                	je     708210 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x160>
  708230:	49 8b 74 2c f0       	mov    -0x10(%r12,%rbp,1),%rsi
  708235:	49 8b 44 2c f8       	mov    -0x8(%r12,%rbp,1),%rax
  70823a:	48 8d bc 24 c0 01 00 	lea    0x1c0(%rsp),%rdi
  708241:	00 
  708242:	4c 89 fa             	mov    %r15,%rdx
  708245:	ff 50 60             	call   *0x60(%rax)
  708248:	48 8b 84 24 c0 01 00 	mov    0x1c0(%rsp),%rax
  70824f:	00 
  708250:	0f b6 8c 24 c8 01 00 	movzbl 0x1c8(%rsp),%ecx
  708257:	00 
  708258:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  70825c:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  708261:	48 8b 94 24 58 01 00 	mov    0x158(%rsp),%rdx
  708268:	00 
  708269:	0f 85 c7 fe ff ff    	jne    708136 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x86>
  70826f:	f6 c1 01             	test   $0x1,%cl
  708272:	0f 84 f4 02 00 00    	je     70856c <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x4bc>
  708278:	49 ff 86 00 07 00 00 	incq   0x700(%r14)
  70827f:	48 8d 7c 24 70       	lea    0x70(%rsp),%rdi
  708284:	4c 89 f6             	mov    %r14,%rsi
  708287:	31 c9                	xor    %ecx,%ecx
  708289:	e8 62 ee ff ff       	call   7070f0 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::describe_with>
  70828e:	83 7c 24 70 fe       	cmpl   $0xfffffffe,0x70(%rsp)
  708293:	75 16                	jne    7082ab <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1fb>
  708295:	c6 84 24 28 02 00 00 	movb   $0x0,0x228(%rsp)
  70829c:	00 
  70829d:	48 c7 84 24 20 02 00 	movq   $0xfffffffffffffffe,0x220(%rsp)
  7082a4:	00 fe ff ff ff 
  7082a9:	eb 41                	jmp    7082ec <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x23c>
  7082ab:	48 8b 84 24 a0 00 00 	mov    0xa0(%rsp),%rax
  7082b2:	00 
  7082b3:	48 89 84 24 50 02 00 	mov    %rax,0x250(%rsp)
  7082ba:	00 
  7082bb:	f3 0f 6f 44 24 70    	movdqu 0x70(%rsp),%xmm0
  7082c1:	f3 0f 6f 8c 24 80 00 	movdqu 0x80(%rsp),%xmm1
  7082c8:	00 00 
  7082ca:	0f 10 94 24 90 00 00 	movups 0x90(%rsp),%xmm2
  7082d1:	00 
  7082d2:	0f 29 94 24 40 02 00 	movaps %xmm2,0x240(%rsp)
  7082d9:	00 
  7082da:	66 0f 7f 8c 24 30 02 	movdqa %xmm1,0x230(%rsp)
  7082e1:	00 00 
  7082e3:	66 0f 7f 84 24 20 02 	movdqa %xmm0,0x220(%rsp)
  7082ea:	00 00 
  7082ec:	40 b5 01             	mov    $0x1,%bpl
  7082ef:	45 31 ff             	xor    %r15d,%r15d
  7082f2:	48 83 bc 24 20 02 00 	cmpq   $0xfffffffffffffffe,0x220(%rsp)
  7082f9:	00 fe 
  7082fb:	0f 85 ba 00 00 00    	jne    7083bb <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x30b>
  708301:	48 8d bc 24 f0 00 00 	lea    0xf0(%rsp),%rdi
  708308:	00 
  708309:	4c 89 f6             	mov    %r14,%rsi
  70830c:	4c 89 e2             	mov    %r12,%rdx
  70830f:	e8 8c 29 00 00       	call   70aca0 <<gpui::runtime::Runtime<unit_action_cost::Model>>::reconcile_editing>
  708314:	48 8b 84 24 f0 00 00 	mov    0xf0(%rsp),%rax
  70831b:	00 
  70831c:	44 0f b6 a4 24 f8 00 	movzbl 0xf8(%rsp),%r12d
  708323:	00 00 
  708325:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  708329:	0f 85 61 01 00 00    	jne    708490 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x3e0>
  70832f:	48 8d 35 82 e7 95 ff 	lea    -0x6a187e(%rip),%rsi        # 66ab8 <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x2f8>
  708336:	48 8d bc 24 20 02 00 	lea    0x220(%rsp),%rdi
  70833d:	00 
  70833e:	e8 bd 7f 01 00       	call   720300 <<core::result::Result<gpui::runtime::paint::PatchOutcome, gpui::runtime::Error> as core::cmp::PartialEq>::eq>
  708343:	84 c0                	test   %al,%al
  708345:	74 26                	je     70836d <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x2bd>
  708347:	49 8b 86 10 06 00 00 	mov    0x610(%r14),%rax
  70834e:	48 85 c0             	test   %rax,%rax
  708351:	0f 84 7a 01 00 00    	je     7084d1 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x421>
  708357:	48 83 b8 d8 00 00 00 	cmpq   $0x0,0xd8(%rax)
  70835e:	00 
  70835f:	0f 95 c0             	setne  %al
  708362:	44 08 e0             	or     %r12b,%al
  708365:	a8 01                	test   $0x1,%al
  708367:	0f 84 6e 01 00 00    	je     7084db <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x42b>
  70836d:	48 8d 35 7c e7 95 ff 	lea    -0x6a1884(%rip),%rsi        # 66af0 <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x330>
  708374:	48 8d bc 24 20 02 00 	lea    0x220(%rsp),%rdi
  70837b:	00 
  70837c:	e8 7f 7f 01 00       	call   720300 <<core::result::Result<gpui::runtime::paint::PatchOutcome, gpui::runtime::Error> as core::cmp::PartialEq>::eq>
  708381:	84 c0                	test   %al,%al
  708383:	74 26                	je     7083ab <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x2fb>
  708385:	49 8b 86 10 06 00 00 	mov    0x610(%r14),%rax
  70838c:	48 85 c0             	test   %rax,%rax
  70838f:	0f 84 a7 01 00 00    	je     70853c <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x48c>
  708395:	48 83 b8 d8 00 00 00 	cmpq   $0x0,0xd8(%rax)
  70839c:	00 
  70839d:	0f 95 c0             	setne  %al
  7083a0:	44 08 e0             	or     %r12b,%al
  7083a3:	a8 01                	test   $0x1,%al
  7083a5:	0f 84 9b 01 00 00    	je     708546 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x496>
  7083ab:	48 89 df             	mov    %rbx,%rdi
  7083ae:	4c 89 f6             	mov    %r14,%rsi
  7083b1:	e8 ca 61 01 00       	call   71e580 <<gpui::runtime::Runtime<unit_action_cost::Model>>::present>
  7083b6:	e9 04 01 00 00       	jmp    7084bf <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x40f>
  7083bb:	48 8b 84 24 50 02 00 	mov    0x250(%rsp),%rax
  7083c2:	00 
  7083c3:	48 89 84 24 20 01 00 	mov    %rax,0x120(%rsp)
  7083ca:	00 
  7083cb:	0f 28 84 24 20 02 00 	movaps 0x220(%rsp),%xmm0
  7083d2:	00 
  7083d3:	0f 28 8c 24 30 02 00 	movaps 0x230(%rsp),%xmm1
  7083da:	00 
  7083db:	0f 28 94 24 40 02 00 	movaps 0x240(%rsp),%xmm2
  7083e2:	00 
  7083e3:	0f 29 94 24 10 01 00 	movaps %xmm2,0x110(%rsp)
  7083ea:	00 
  7083eb:	0f 29 8c 24 00 01 00 	movaps %xmm1,0x100(%rsp)
  7083f2:	00 
  7083f3:	0f 29 84 24 f0 00 00 	movaps %xmm0,0xf0(%rsp)
  7083fa:	00 
  7083fb:	49 8b 86 10 06 00 00 	mov    0x610(%r14),%rax
  708402:	48 85 c0             	test   %rax,%rax
  708405:	74 41                	je     708448 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x398>
  708407:	48 8b 80 e0 00 00 00 	mov    0xe0(%rax),%rax
  70840e:	48 85 c0             	test   %rax,%rax
  708411:	74 35                	je     708448 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x398>
  708413:	48 8b 78 10          	mov    0x10(%rax),%rdi
  708417:	0f b6 48 24          	movzbl 0x24(%rax),%ecx
  70841b:	c6 40 24 02          	movb   $0x2,0x24(%rax)
  70841f:	80 f9 02             	cmp    $0x2,%cl
  708422:	74 24                	je     708448 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x398>
  708424:	f6 07 01             	testb  $0x1,(%rdi)
  708427:	75 17                	jne    708440 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x390>
  708429:	48 8b 47 08          	mov    0x8(%rdi),%rax
  70842d:	a8 01                	test   $0x1,%al
  70842f:	75 0f                	jne    708440 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x390>
  708431:	48 8d 47 08          	lea    0x8(%rdi),%rax
  708435:	f0 48 83 28 02       	lock subq $0x2,(%rax)
  70843a:	0f 84 31 19 00 00    	je     709d71 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1cc1>
  708440:	41 c6 86 1f 07 00 00 	movb   $0x1,0x71f(%r14)
  708447:	01 
  708448:	41 c6 86 1e 07 00 00 	movb   $0x0,0x71e(%r14)
  70844f:	00 
  708450:	49 c7 86 e8 05 00 00 	movq   $0x0,0x5e8(%r14)
  708457:	00 00 00 00 
  70845b:	48 8b 84 24 20 01 00 	mov    0x120(%rsp),%rax
  708462:	00 
  708463:	48 89 43 30          	mov    %rax,0x30(%rbx)
  708467:	66 0f 6f 84 24 f0 00 	movdqa 0xf0(%rsp),%xmm0
  70846e:	00 00 
  708470:	66 0f 6f 8c 24 00 01 	movdqa 0x100(%rsp),%xmm1
  708477:	00 00 
  708479:	0f 28 94 24 10 01 00 	movaps 0x110(%rsp),%xmm2
  708480:	00 
  708481:	0f 11 53 20          	movups %xmm2,0x20(%rbx)
  708485:	f3 0f 7f 4b 10       	movdqu %xmm1,0x10(%rbx)
  70848a:	f3 0f 7f 03          	movdqu %xmm0,(%rbx)
  70848e:	eb 2f                	jmp    7084bf <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x40f>
  708490:	f3 0f 6f 84 24 f9 00 	movdqu 0xf9(%rsp),%xmm0
  708497:	00 00 
  708499:	f3 0f 6f 8c 24 09 01 	movdqu 0x109(%rsp),%xmm1
  7084a0:	00 00 
  7084a2:	0f 10 94 24 18 01 00 	movups 0x118(%rsp),%xmm2
  7084a9:	00 
  7084aa:	0f 11 53 28          	movups %xmm2,0x28(%rbx)
  7084ae:	f3 0f 7f 4b 19       	movdqu %xmm1,0x19(%rbx)
  7084b3:	f3 0f 7f 43 09       	movdqu %xmm0,0x9(%rbx)
  7084b8:	48 89 03             	mov    %rax,(%rbx)
  7084bb:	44 88 63 08          	mov    %r12b,0x8(%rbx)
  7084bf:	48 81 c4 c8 03 00 00 	add    $0x3c8,%rsp
  7084c6:	5b                   	pop    %rbx
  7084c7:	41 5c                	pop    %r12
  7084c9:	41 5d                	pop    %r13
  7084cb:	41 5e                	pop    %r14
  7084cd:	41 5f                	pop    %r15
  7084cf:	5d                   	pop    %rbp
  7084d0:	c3                   	ret
  7084d1:	41 80 fc 01          	cmp    $0x1,%r12b
  7084d5:	0f 84 92 fe ff ff    	je     70836d <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x2bd>
  7084db:	f3 41 0f 6f 86 60 06 	movdqu 0x660(%r14),%xmm0
  7084e2:	00 00 
  7084e4:	41 0f b6 86 20 07 00 	movzbl 0x720(%r14),%eax
  7084eb:	00 
  7084ec:	49 83 be 80 06 00 00 	cmpq   $0x0,0x680(%r14)
  7084f3:	00 
  7084f4:	74 16                	je     70850c <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x45c>
  7084f6:	84 c0                	test   %al,%al
  7084f8:	0f 84 c7 00 00 00    	je     7085c5 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x515>
  7084fe:	49 83 be 88 05 00 00 	cmpq   $0xffffffffffffffff,0x588(%r14)
  708505:	ff 
  708506:	0f 85 b9 00 00 00    	jne    7085c5 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x515>
  70850c:	31 c9                	xor    %ecx,%ecx
  70850e:	e9 be 00 00 00       	jmp    7085d1 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x521>
  708513:	4c 89 bc 24 c8 01 00 	mov    %r15,0x1c8(%rsp)
  70851a:	00 
  70851b:	b8 0b 00 00 00       	mov    $0xb,%eax
  708520:	b1 01                	mov    $0x1,%cl
  708522:	e9 0f fc ff ff       	jmp    708136 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x86>
  708527:	4c 89 bc 24 c8 01 00 	mov    %r15,0x1c8(%rsp)
  70852e:	00 
  70852f:	b8 0b 00 00 00       	mov    $0xb,%eax
  708534:	44 89 f9             	mov    %r15d,%ecx
  708537:	e9 fa fb ff ff       	jmp    708136 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x86>
  70853c:	41 80 fc 01          	cmp    $0x1,%r12b
  708540:	0f 84 65 fe ff ff    	je     7083ab <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x2fb>
  708546:	40 84 ed             	test   %bpl,%bpl
  708549:	0f 85 15 18 00 00    	jne    709d64 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1cb4>
  70854f:	48 8d 7b 08          	lea    0x8(%rbx),%rdi
  708553:	4c 89 f6             	mov    %r14,%rsi
  708556:	31 d2                	xor    %edx,%edx
  708558:	4c 89 f9             	mov    %r15,%rcx
  70855b:	e8 30 32 00 00       	call   70b790 <<gpui::runtime::Runtime<unit_action_cost::Model>>::publish_metadata>
  708560:	48 c7 03 fe ff ff ff 	movq   $0xfffffffffffffffe,(%rbx)
  708567:	e9 53 ff ff ff       	jmp    7084bf <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x40f>
  70856c:	4c 89 bc 24 68 03 00 	mov    %r15,0x368(%rsp)
  708573:	00 
  708574:	49 ff 86 f8 06 00 00 	incq   0x6f8(%r14)
  70857b:	49 8b 86 18 06 00 00 	mov    0x618(%r14),%rax
  708582:	48 85 c0             	test   %rax,%rax
  708585:	48 89 94 24 58 01 00 	mov    %rdx,0x158(%rsp)
  70858c:	00 
  70858d:	0f 84 90 02 00 00    	je     708823 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x773>
  708593:	49 8b 8e 20 06 00 00 	mov    0x620(%r14),%rcx
  70859a:	48 85 c9             	test   %rcx,%rcx
  70859d:	0f 84 9c 00 00 00    	je     70863f <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x58f>
  7085a3:	48 89 ca             	mov    %rcx,%rdx
  7085a6:	48 83 e2 07          	and    $0x7,%rdx
  7085aa:	74 4c                	je     7085f8 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x548>
  7085ac:	31 f6                	xor    %esi,%esi
  7085ae:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  7085b5:	48 ff c6             	inc    %rsi
  7085b8:	48 39 f2             	cmp    %rsi,%rdx
  7085bb:	75 f1                	jne    7085ae <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x4fe>
  7085bd:	48 89 ca             	mov    %rcx,%rdx
  7085c0:	48 29 f2             	sub    %rsi,%rdx
  7085c3:	eb 36                	jmp    7085fb <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x54b>
  7085c5:	49 8b 96 90 06 00 00 	mov    0x690(%r14),%rdx
  7085cc:	b9 01 00 00 00       	mov    $0x1,%ecx
  7085d1:	49 8b b6 08 07 00 00 	mov    0x708(%r14),%rsi
  7085d8:	48 89 4b 08          	mov    %rcx,0x8(%rbx)
  7085dc:	48 89 53 10          	mov    %rdx,0x10(%rbx)
  7085e0:	f3 0f 7f 43 18       	movdqu %xmm0,0x18(%rbx)
  7085e5:	48 89 73 28          	mov    %rsi,0x28(%rbx)
  7085e9:	88 43 30             	mov    %al,0x30(%rbx)
  7085ec:	48 c7 03 fe ff ff ff 	movq   $0xfffffffffffffffe,(%rbx)
  7085f3:	e9 c7 fe ff ff       	jmp    7084bf <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x40f>
  7085f8:	48 89 ca             	mov    %rcx,%rdx
  7085fb:	48 83 f9 08          	cmp    $0x8,%rcx
  7085ff:	72 3e                	jb     70863f <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x58f>
  708601:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  708608:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  70860f:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  708616:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  70861d:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  708624:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  70862b:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  708632:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  708639:	48 83 c2 f8          	add    $0xfffffffffffffff8,%rdx
  70863d:	75 c2                	jne    708601 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x551>
  70863f:	66 83 b8 8a 05 00 00 	cmpw   $0x0,0x58a(%rax)
  708646:	00 
  708647:	0f 84 d6 01 00 00    	je     708823 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x773>
  70864d:	80 38 00             	cmpb   $0x0,(%rax)
  708650:	0f 85 cd 01 00 00    	jne    708823 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x773>
  708656:	49 8d be c8 05 00 00 	lea    0x5c8(%r14),%rdi
  70865d:	48 8d b4 24 68 03 00 	lea    0x368(%rsp),%rsi
  708664:	00 
  708665:	e8 66 84 01 00       	call   720ad0 <<alloc::collections::btree::map::BTreeMap<gpui::source::FieldId, gpui::runtime::Fanout>>::get::<gpui::source::FieldId>>
  70866a:	48 85 c0             	test   %rax,%rax
  70866d:	0f 84 b0 01 00 00    	je     708823 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x773>
  708673:	48 8b 48 10          	mov    0x10(%rax),%rcx
  708677:	48 c1 e1 02          	shl    $0x2,%rcx
  70867b:	48 83 38 ff          	cmpq   $0xffffffffffffffff,(%rax)
  70867f:	ba 04 00 00 00       	mov    $0x4,%edx
  708684:	48 0f 45 50 08       	cmovne 0x8(%rax),%rdx
  708689:	48 89 54 24 08       	mov    %rdx,0x8(%rsp)
  70868e:	b8 00 00 00 00       	mov    $0x0,%eax
  708693:	48 0f 45 c1          	cmovne %rcx,%rax
  708697:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
  70869c:	48 85 c0             	test   %rax,%rax
  70869f:	0f 84 7e 01 00 00    	je     708823 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x773>
  7086a5:	45 31 ed             	xor    %r13d,%r13d
  7086a8:	48 8b 05 51 9a 3f 00 	mov    0x3f9a51(%rip),%rax        # b02100 <_DYNAMIC+0x3b8>
  7086af:	48 83 c0 20          	add    $0x20,%rax
  7086b3:	48 89 44 24 40       	mov    %rax,0x40(%rsp)
  7086b8:	48 8b 05 49 9a 3f 00 	mov    0x3f9a49(%rip),%rax        # b02108 <_DYNAMIC+0x3c0>
  7086bf:	48 83 c0 20          	add    $0x20,%rax
  7086c3:	48 89 44 24 28       	mov    %rax,0x28(%rsp)
  7086c8:	48 8b 05 41 9a 3f 00 	mov    0x3f9a41(%rip),%rax        # b02110 <_DYNAMIC+0x3c8>
  7086cf:	48 83 c0 20          	add    $0x20,%rax
  7086d3:	48 89 44 24 48       	mov    %rax,0x48(%rsp)
  7086d8:	48 8b 05 39 9a 3f 00 	mov    0x3f9a39(%rip),%rax        # b02118 <_DYNAMIC+0x3d0>
  7086df:	48 83 c0 20          	add    $0x20,%rax
  7086e3:	48 89 44 24 38       	mov    %rax,0x38(%rsp)
  7086e8:	48 8b 05 31 9a 3f 00 	mov    0x3f9a31(%rip),%rax        # b02120 <_DYNAMIC+0x3d8>
  7086ef:	48 83 c0 20          	add    $0x20,%rax
  7086f3:	48 89 44 24 60       	mov    %rax,0x60(%rsp)
  7086f8:	48 8b 05 29 9a 3f 00 	mov    0x3f9a29(%rip),%rax        # b02128 <_DYNAMIC+0x3e0>
  7086ff:	48 83 c0 20          	add    $0x20,%rax
  708703:	48 89 84 24 d0 00 00 	mov    %rax,0xd0(%rsp)
  70870a:	00 
  70870b:	48 8b 05 1e 9a 3f 00 	mov    0x3f9a1e(%rip),%rax        # b02130 <_DYNAMIC+0x3e8>
  708712:	48 83 c0 20          	add    $0x20,%rax
  708716:	48 89 84 24 c8 00 00 	mov    %rax,0xc8(%rsp)
  70871d:	00 
  70871e:	48 8b 05 13 9a 3f 00 	mov    0x3f9a13(%rip),%rax        # b02138 <_DYNAMIC+0x3f0>
  708725:	48 83 c0 20          	add    $0x20,%rax
  708729:	48 89 44 24 20       	mov    %rax,0x20(%rsp)
  70872e:	48 8b 05 0b 9a 3f 00 	mov    0x3f9a0b(%rip),%rax        # b02140 <_DYNAMIC+0x3f8>
  708735:	48 83 c0 20          	add    $0x20,%rax
  708739:	48 89 84 24 50 01 00 	mov    %rax,0x150(%rsp)
  708740:	00 
  708741:	48 8b 05 00 9a 3f 00 	mov    0x3f9a00(%rip),%rax        # b02148 <_DYNAMIC+0x400>
  708748:	48 83 c0 20          	add    $0x20,%rax
  70874c:	48 89 44 24 30       	mov    %rax,0x30(%rsp)
  708751:	48 8b 05 f8 99 3f 00 	mov    0x3f99f8(%rip),%rax        # b02150 <_DYNAMIC+0x408>
  708758:	48 83 c0 20          	add    $0x20,%rax
  70875c:	48 89 84 24 48 01 00 	mov    %rax,0x148(%rsp)
  708763:	00 
  708764:	48 8b 05 ed 99 3f 00 	mov    0x3f99ed(%rip),%rax        # b02158 <_DYNAMIC+0x410>
  70876b:	48 83 c0 20          	add    $0x20,%rax
  70876f:	48 89 44 24 58       	mov    %rax,0x58(%rsp)
  708774:	48 8b 05 e5 99 3f 00 	mov    0x3f99e5(%rip),%rax        # b02160 <_DYNAMIC+0x418>
  70877b:	48 83 c0 20          	add    $0x20,%rax
  70877f:	48 89 44 24 50       	mov    %rax,0x50(%rsp)
  708784:	48 8d 2d 05 db 95 ff 	lea    -0x6a24fb(%rip),%rbp        # 66290 <anon.079f5e587c394fcac2765eb4d0cf0bc2.397.llvm.6319143315422321905+0x1450>
  70878b:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  708790:	42 8b 3c 28          	mov    (%rax,%r13,1),%edi
  708794:	ff 15 ce 99 3f 00    	call   *0x3f99ce(%rip)        # b02168 <_DYNAMIC+0x420>
  70879a:	0f b7 c0             	movzwl %ax,%eax
  70879d:	48 63 4c 85 00       	movslq 0x0(%rbp,%rax,4),%rcx
  7087a2:	48 01 e9             	add    %rbp,%rcx
  7087a5:	48 8b 44 24 40       	mov    0x40(%rsp),%rax
  7087aa:	ff e1                	jmp    *%rcx
  7087ac:	48 8b 44 24 28       	mov    0x28(%rsp),%rax
  7087b1:	eb 57                	jmp    70880a <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x75a>
  7087b3:	48 8b 84 24 48 01 00 	mov    0x148(%rsp),%rax
  7087ba:	00 
  7087bb:	eb 4d                	jmp    70880a <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x75a>
  7087bd:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
  7087c2:	eb 46                	jmp    70880a <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x75a>
  7087c4:	48 8b 44 24 58       	mov    0x58(%rsp),%rax
  7087c9:	eb 3f                	jmp    70880a <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x75a>
  7087cb:	48 8b 84 24 50 01 00 	mov    0x150(%rsp),%rax
  7087d2:	00 
  7087d3:	eb 35                	jmp    70880a <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x75a>
  7087d5:	48 8b 44 24 48       	mov    0x48(%rsp),%rax
  7087da:	eb 2e                	jmp    70880a <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x75a>
  7087dc:	48 8b 84 24 c8 00 00 	mov    0xc8(%rsp),%rax
  7087e3:	00 
  7087e4:	eb 24                	jmp    70880a <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x75a>
  7087e6:	48 8b 44 24 60       	mov    0x60(%rsp),%rax
  7087eb:	eb 1d                	jmp    70880a <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x75a>
  7087ed:	48 8b 44 24 50       	mov    0x50(%rsp),%rax
  7087f2:	eb 16                	jmp    70880a <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x75a>
  7087f4:	48 8b 84 24 d0 00 00 	mov    0xd0(%rsp),%rax
  7087fb:	00 
  7087fc:	eb 0c                	jmp    70880a <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x75a>
  7087fe:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
  708803:	eb 05                	jmp    70880a <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x75a>
  708805:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  70880a:	80 78 13 00          	cmpb   $0x0,0x13(%rax)
  70880e:	0f 85 03 11 00 00    	jne    709917 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1867>
  708814:	49 83 c5 04          	add    $0x4,%r13
  708818:	4c 39 6c 24 18       	cmp    %r13,0x18(%rsp)
  70881d:	0f 85 68 ff ff ff    	jne    70878b <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x6db>
  708823:	48 c7 44 24 40 00 00 	movq   $0x0,0x40(%rsp)
  70882a:	00 00 
  70882c:	49 8b ae c8 05 00 00 	mov    0x5c8(%r14),%rbp
  708833:	48 85 ed             	test   %rbp,%rbp
  708836:	0f 84 f2 10 00 00    	je     70992e <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x187e>
  70883c:	49 8d 96 10 07 00 00 	lea    0x710(%r14),%rdx
  708843:	49 8d b6 28 02 00 00 	lea    0x228(%r14),%rsi
  70884a:	49 8b 86 d0 05 00 00 	mov    0x5d0(%r14),%rax
  708851:	48 89 c7             	mov    %rax,%rdi
  708854:	48 89 e9             	mov    %rbp,%rcx
  708857:	44 0f b7 91 c2 01 00 	movzwl 0x1c2(%rcx),%r10d
  70885e:	00 
  70885f:	45 89 d3             	mov    %r10d,%r11d
  708862:	41 c1 e3 05          	shl    $0x5,%r11d
  708866:	49 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%r8
  70886d:	45 31 c9             	xor    %r9d,%r9d
  708870:	4d 39 cb             	cmp    %r9,%r11
  708873:	74 28                	je     70889d <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x7ed>
  708875:	4e 3b bc c1 70 01 00 	cmp    0x170(%rcx,%r8,8),%r15
  70887c:	00 
  70887d:	41 0f 97 c4          	seta   %r12b
  708881:	41 80 dc 00          	sbb    $0x0,%r12b
  708885:	49 83 c1 20          	add    $0x20,%r9
  708889:	49 ff c0             	inc    %r8
  70888c:	41 80 fc 01          	cmp    $0x1,%r12b
  708890:	74 de                	je     708870 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x7c0>
  708892:	45 0f b6 d4          	movzbl %r12b,%r10d
  708896:	45 85 d2             	test   %r10d,%r10d
  708899:	75 05                	jne    7088a0 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x7f0>
  70889b:	eb 1c                	jmp    7088b9 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x809>
  70889d:	4d 89 d0             	mov    %r10,%r8
  7088a0:	48 83 ef 01          	sub    $0x1,%rdi
  7088a4:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  7088a9:	0f 82 92 00 00 00    	jb     708941 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x891>
  7088af:	4a 8b 8c c1 c8 01 00 	mov    0x1c8(%rcx,%r8,8),%rcx
  7088b6:	00 
  7088b7:	eb 9e                	jmp    708857 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x7a7>
  7088b9:	4a 83 7c 09 e0 ff    	cmpq   $0xffffffffffffffff,-0x20(%rcx,%r9,1)
  7088bf:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  7088c4:	75 7b                	jne    708941 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x891>
  7088c6:	42 8b 6c 09 e8       	mov    -0x18(%rcx,%r9,1),%ebp
  7088cb:	49 ff 86 b8 06 00 00 	incq   0x6b8(%r14)
  7088d2:	c7 04 24 01 00 00 00 	movl   $0x1,(%rsp)
  7088d9:	4c 8d 05 c8 bc 3c 00 	lea    0x3cbcc8(%rip),%r8        # ad45a8 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0xdc0>
  7088e0:	48 8d 7c 24 70       	lea    0x70(%rsp),%rdi
  7088e5:	4c 89 f9             	mov    %r15,%rcx
  7088e8:	45 31 c9             	xor    %r9d,%r9d
  7088eb:	e8 90 a3 03 00       	call   742c80 <<gpui::source::Sources<unit_action_cost::Model>>::freeze>
  7088f0:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  7088f5:	48 8b 4c 24 78       	mov    0x78(%rsp),%rcx
  7088fa:	4c 8b ac 24 88 00 00 	mov    0x88(%rsp),%r13
  708901:	00 
  708902:	48 83 f8 fd          	cmp    $0xfffffffffffffffd,%rax
  708906:	0f 85 e6 00 00 00    	jne    7089f2 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x942>
  70890c:	4c 8b 84 24 80 00 00 	mov    0x80(%rsp),%r8
  708913:	00 
  708914:	48 89 cd             	mov    %rcx,%rbp
  708917:	48 c1 ed 08          	shr    $0x8,%rbp
  70891b:	b8 20 00 00 00       	mov    $0x20,%eax
  708920:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  708925:	89 cf                	mov    %ecx,%edi
  708927:	e9 bb 12 00 00       	jmp    709be7 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1b37>
  70892c:	48 89 f9             	mov    %rdi,%rcx
  70892f:	48 83 e8 01          	sub    $0x1,%rax
  708933:	0f 82 f5 0f 00 00    	jb     70992e <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x187e>
  708939:	48 8b ac cd c8 01 00 	mov    0x1c8(%rbp,%rcx,8),%rbp
  708940:	00 
  708941:	0f b7 bd c2 01 00 00 	movzwl 0x1c2(%rbp),%edi
  708948:	41 89 f8             	mov    %edi,%r8d
  70894b:	41 c1 e0 05          	shl    $0x5,%r8d
  70894f:	48 c7 c1 ff ff ff ff 	mov    $0xffffffffffffffff,%rcx
  708956:	45 31 ed             	xor    %r13d,%r13d
  708959:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  708960:	4d 39 e8             	cmp    %r13,%r8
  708963:	74 c7                	je     70892c <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x87c>
  708965:	4c 3b bc cd 70 01 00 	cmp    0x170(%rbp,%rcx,8),%r15
  70896c:	00 
  70896d:	41 0f 97 c1          	seta   %r9b
  708971:	41 80 d9 00          	sbb    $0x0,%r9b
  708975:	49 83 c5 20          	add    $0x20,%r13
  708979:	48 ff c1             	inc    %rcx
  70897c:	41 80 f9 01          	cmp    $0x1,%r9b
  708980:	74 de                	je     708960 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x8b0>
  708982:	41 0f b6 f9          	movzbl %r9b,%edi
  708986:	85 ff                	test   %edi,%edi
  708988:	75 a5                	jne    70892f <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x87f>
  70898a:	4a 8b 4c 2d e0       	mov    -0x20(%rbp,%r13,1),%rcx
  70898f:	48 83 f9 ff          	cmp    $0xffffffffffffffff,%rcx
  708993:	48 89 4c 24 08       	mov    %rcx,0x8(%rsp)
  708998:	74 41                	je     7089db <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x92b>
  70899a:	4a 8b 44 2d f0       	mov    -0x10(%rbp,%r13,1),%rax
  70899f:	48 85 c0             	test   %rax,%rax
  7089a2:	0f 84 46 01 00 00    	je     708aee <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0xa3e>
  7089a8:	4a 8b 4c 2d e8       	mov    -0x18(%rbp,%r13,1),%rcx
  7089ad:	48 ff c8             	dec    %rax
  7089b0:	48 bf ff ff ff ff ff 	movabs $0x3fffffffffffffff,%rdi
  7089b7:	ff ff 3f 
  7089ba:	48 21 c7             	and    %rax,%rdi
  7089bd:	4c 8d 4f 01          	lea    0x1(%rdi),%r9
  7089c1:	45 89 c8             	mov    %r9d,%r8d
  7089c4:	41 83 e0 03          	and    $0x3,%r8d
  7089c8:	48 83 ff 03          	cmp    $0x3,%rdi
  7089cc:	0f 83 25 01 00 00    	jae    708af7 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0xa47>
  7089d2:	31 c0                	xor    %eax,%eax
  7089d4:	31 ff                	xor    %edi,%edi
  7089d6:	e9 b0 01 00 00       	jmp    708b8b <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0xadb>
  7089db:	49 ff 86 b8 06 00 00 	incq   0x6b8(%r14)
  7089e2:	4c 8d 05 bf bb 3c 00 	lea    0x3cbbbf(%rip),%r8        # ad45a8 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0xdc0>
  7089e9:	31 c0                	xor    %eax,%eax
  7089eb:	31 ff                	xor    %edi,%edi
  7089ed:	e9 d4 01 00 00       	jmp    708bc6 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0xb16>
  7089f2:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
  7089f7:	48 89 4c 24 28       	mov    %rcx,0x28(%rsp)
  7089fc:	48 8b 84 24 a0 00 00 	mov    0xa0(%rsp),%rax
  708a03:	00 
  708a04:	48 89 84 24 d0 02 00 	mov    %rax,0x2d0(%rsp)
  708a0b:	00 
  708a0c:	0f 10 84 24 90 00 00 	movups 0x90(%rsp),%xmm0
  708a13:	00 
  708a14:	0f 29 84 24 c0 02 00 	movaps %xmm0,0x2c0(%rsp)
  708a1b:	00 
  708a1c:	41 83 fd 02          	cmp    $0x2,%r13d
  708a20:	0f 84 bc 13 00 00    	je     709de2 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1d32>
  708a26:	4c 89 6c 24 70       	mov    %r13,0x70(%rsp)
  708a2b:	0f 28 84 24 c0 02 00 	movaps 0x2c0(%rsp),%xmm0
  708a32:	00 
  708a33:	0f 11 44 24 78       	movups %xmm0,0x78(%rsp)
  708a38:	48 8b 84 24 d0 02 00 	mov    0x2d0(%rsp),%rax
  708a3f:	00 
  708a40:	48 89 84 24 88 00 00 	mov    %rax,0x88(%rsp)
  708a47:	00 
  708a48:	48 8d bc 24 60 01 00 	lea    0x160(%rsp),%rdi
  708a4f:	00 
  708a50:	48 8d 74 24 70       	lea    0x70(%rsp),%rsi
  708a55:	ba 06 00 00 00       	mov    $0x6,%edx
  708a5a:	ff 15 10 97 3f 00    	call   *0x3f9710(%rip)        # b02170 <_DYNAMIC+0x428>
  708a60:	0f b6 94 24 60 01 00 	movzbl 0x160(%rsp),%edx
  708a67:	00 
  708a68:	80 fa ff             	cmp    $0xff,%dl
  708a6b:	0f 84 79 0e 00 00    	je     7098ea <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x183a>
  708a71:	8b 8c 24 63 01 00 00 	mov    0x163(%rsp),%ecx
  708a78:	0f b6 84 24 67 01 00 	movzbl 0x167(%rsp),%eax
  708a7f:	00 
  708a80:	0f 10 84 24 68 01 00 	movups 0x168(%rsp),%xmm0
  708a87:	00 
  708a88:	0f 29 84 24 90 03 00 	movaps %xmm0,0x390(%rsp)
  708a8f:	00 
  708a90:	8b b4 24 78 01 00 00 	mov    0x178(%rsp),%esi
  708a97:	89 b4 24 a0 03 00 00 	mov    %esi,0x3a0(%rsp)
  708a9e:	80 fa 02             	cmp    $0x2,%dl
  708aa1:	0f 85 35 0f 00 00    	jne    7099dc <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x192c>
  708aa7:	89 ea                	mov    %ebp,%edx
  708aa9:	48 c1 e0 20          	shl    $0x20,%rax
  708aad:	48 09 c8             	or     %rcx,%rax
  708ab0:	48 c1 e8 08          	shr    $0x8,%rax
  708ab4:	89 84 24 60 02 00 00 	mov    %eax,0x260(%rsp)
  708abb:	8b 84 24 98 03 00 00 	mov    0x398(%rsp),%eax
  708ac2:	89 84 24 6c 02 00 00 	mov    %eax,0x26c(%rsp)
  708ac9:	48 8b 84 24 90 03 00 	mov    0x390(%rsp),%rax
  708ad0:	00 
  708ad1:	48 89 84 24 64 02 00 	mov    %rax,0x264(%rsp)
  708ad8:	00 
  708ad9:	41 80 be 1f 07 00 00 	cmpb   $0x0,0x71f(%r14)
  708ae0:	00 
  708ae1:	0f 84 0c 0f 00 00    	je     7099f3 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1943>
  708ae7:	31 ed                	xor    %ebp,%ebp
  708ae9:	e9 24 0f 00 00       	jmp    709a12 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1962>
  708aee:	31 ff                	xor    %edi,%edi
  708af0:	31 c0                	xor    %eax,%eax
  708af2:	e9 b5 00 00 00       	jmp    708bac <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0xafc>
  708af7:	4c 89 44 24 18       	mov    %r8,0x18(%rsp)
  708afc:	48 b8 00 00 00 00 00 	movabs $0x8000000000000000,%rax
  708b03:	00 00 80 
  708b06:	48 83 c0 fc          	add    $0xfffffffffffffffc,%rax
  708b0a:	49 21 c1             	and    %rax,%r9
  708b0d:	31 c0                	xor    %eax,%eax
  708b0f:	31 ff                	xor    %edi,%edi
  708b11:	44 8b 11             	mov    (%rcx),%r10d
  708b14:	44 8b 41 04          	mov    0x4(%rcx),%r8d
  708b18:	45 89 d4             	mov    %r10d,%r12d
  708b1b:	41 f7 d4             	not    %r12d
  708b1e:	41 f6 c4 03          	test   $0x3,%r12b
  708b22:	41 0f 94 c4          	sete   %r12b
  708b26:	45 89 c3             	mov    %r8d,%r11d
  708b29:	41 f7 d3             	not    %r11d
  708b2c:	41 f6 c3 03          	test   $0x3,%r11b
  708b30:	41 0f 94 c3          	sete   %r11b
  708b34:	45 08 e3             	or     %r12b,%r11b
  708b37:	8b 51 08             	mov    0x8(%rcx),%edx
  708b3a:	41 89 d4             	mov    %edx,%r12d
  708b3d:	41 f7 d4             	not    %r12d
  708b40:	41 f6 c4 03          	test   $0x3,%r12b
  708b44:	41 0f 94 c4          	sete   %r12b
  708b48:	8b 71 0c             	mov    0xc(%rcx),%esi
  708b4b:	48 83 c1 10          	add    $0x10,%rcx
  708b4f:	21 f2                	and    %esi,%edx
  708b51:	f7 d6                	not    %esi
  708b53:	40 f6 c6 03          	test   $0x3,%sil
  708b57:	40 0f 94 c6          	sete   %sil
  708b5b:	44 08 e6             	or     %r12b,%sil
  708b5e:	44 08 de             	or     %r11b,%sil
  708b61:	40 08 f7             	or     %sil,%dil
  708b64:	45 21 c2             	and    %r8d,%r10d
  708b67:	41 21 d2             	and    %edx,%r10d
  708b6a:	41 f7 d2             	not    %r10d
  708b6d:	41 f6 c2 03          	test   $0x3,%r10b
  708b71:	0f 95 c2             	setne  %dl
  708b74:	08 d0                	or     %dl,%al
  708b76:	49 83 c1 fc          	add    $0xfffffffffffffffc,%r9
  708b7a:	75 95                	jne    708b11 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0xa61>
  708b7c:	4c 8b 44 24 18       	mov    0x18(%rsp),%r8
  708b81:	4d 85 c0             	test   %r8,%r8
  708b84:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  708b89:	74 21                	je     708bac <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0xafc>
  708b8b:	45 31 c9             	xor    %r9d,%r9d
  708b8e:	42 8b 14 89          	mov    (%rcx,%r9,4),%edx
  708b92:	83 e2 03             	and    $0x3,%edx
  708b95:	83 fa 03             	cmp    $0x3,%edx
  708b98:	0f 95 c2             	setne  %dl
  708b9b:	40 0f 94 c6          	sete   %sil
  708b9f:	40 08 f7             	or     %sil,%dil
  708ba2:	08 d0                	or     %dl,%al
  708ba4:	49 ff c1             	inc    %r9
  708ba7:	4d 39 c8             	cmp    %r9,%r8
  708baa:	75 e2                	jne    708b8e <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0xade>
  708bac:	49 ff 86 b8 06 00 00 	incq   0x6b8(%r14)
  708bb3:	4e 8b 44 2d f8       	mov    -0x8(%rbp,%r13,1),%r8
  708bb8:	49 8d 96 10 07 00 00 	lea    0x710(%r14),%rdx
  708bbf:	49 8d b6 28 02 00 00 	lea    0x228(%r14),%rsi
  708bc6:	40 0f b6 cf          	movzbl %dil,%ecx
  708bca:	83 e1 01             	and    $0x1,%ecx
  708bcd:	89 0c 24             	mov    %ecx,(%rsp)
  708bd0:	44 0f b6 c8          	movzbl %al,%r9d
  708bd4:	41 83 e1 01          	and    $0x1,%r9d
  708bd8:	48 8d 7c 24 70       	lea    0x70(%rsp),%rdi
  708bdd:	4c 89 f9             	mov    %r15,%rcx
  708be0:	e8 9b a0 03 00       	call   742c80 <<gpui::source::Sources<unit_action_cost::Model>>::freeze>
  708be5:	48 8b 4c 24 70       	mov    0x70(%rsp),%rcx
  708bea:	48 8b 44 24 78       	mov    0x78(%rsp),%rax
  708bef:	4c 8b 84 24 80 00 00 	mov    0x80(%rsp),%r8
  708bf6:	00 
  708bf7:	48 8b 94 24 88 00 00 	mov    0x88(%rsp),%rdx
  708bfe:	00 
  708bff:	48 89 54 24 18       	mov    %rdx,0x18(%rsp)
  708c04:	48 89 4c 24 60       	mov    %rcx,0x60(%rsp)
  708c09:	48 83 f9 fd          	cmp    $0xfffffffffffffffd,%rcx
  708c0d:	75 1d                	jne    708c2c <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0xb7c>
  708c0f:	48 89 c5             	mov    %rax,%rbp
  708c12:	48 c1 ed 08          	shr    $0x8,%rbp
  708c16:	b9 20 00 00 00       	mov    $0x20,%ecx
  708c1b:	48 89 4c 24 08       	mov    %rcx,0x8(%rsp)
  708c20:	89 c7                	mov    %eax,%edi
  708c22:	4c 8b 6c 24 18       	mov    0x18(%rsp),%r13
  708c27:	e9 bb 0f 00 00       	jmp    709be7 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1b37>
  708c2c:	48 89 44 24 50       	mov    %rax,0x50(%rsp)
  708c31:	48 8b 84 24 a0 00 00 	mov    0xa0(%rsp),%rax
  708c38:	00 
  708c39:	48 89 84 24 50 03 00 	mov    %rax,0x350(%rsp)
  708c40:	00 
  708c41:	f3 0f 6f 84 24 90 00 	movdqu 0x90(%rsp),%xmm0
  708c48:	00 00 
  708c4a:	66 0f 7f 84 24 40 03 	movdqa %xmm0,0x340(%rsp)
  708c51:	00 00 
  708c53:	48 83 7c 24 08 ff    	cmpq   $0xffffffffffffffff,0x8(%rsp)
  708c59:	0f 84 69 0c 00 00    	je     7098c8 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1818>
  708c5f:	4a 8b 44 2d f0       	mov    -0x10(%rbp,%r13,1),%rax
  708c64:	48 85 c0             	test   %rax,%rax
  708c67:	0f 84 5b 0c 00 00    	je     7098c8 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1818>
  708c6d:	4c 89 44 24 30       	mov    %r8,0x30(%rsp)
  708c72:	4a 8b 4c 2d e8       	mov    -0x18(%rbp,%r13,1),%rcx
  708c77:	48 89 4c 24 08       	mov    %rcx,0x8(%rsp)
  708c7c:	48 c1 e0 02          	shl    $0x2,%rax
  708c80:	48 89 44 24 28       	mov    %rax,0x28(%rsp)
  708c85:	8b 44 24 18          	mov    0x18(%rsp),%eax
  708c89:	48 89 84 24 60 03 00 	mov    %rax,0x360(%rsp)
  708c90:	00 
  708c91:	45 31 e4             	xor    %r12d,%r12d
  708c94:	48 83 f8 02          	cmp    $0x2,%rax
  708c98:	0f 85 72 0b 00 00    	jne    709810 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1760>
  708c9e:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  708ca3:	42 8b 3c 20          	mov    (%rax,%r12,1),%edi
  708ca7:	ff 15 bb 94 3f 00    	call   *0x3f94bb(%rip)        # b02168 <_DYNAMIC+0x420>
  708cad:	66 85 c0             	test   %ax,%ax
  708cb0:	0f 85 ba 12 00 00    	jne    709f70 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1ec0>
  708cb6:	49 83 c4 04          	add    $0x4,%r12
  708cba:	4c 39 64 24 28       	cmp    %r12,0x28(%rsp)
  708cbf:	75 dd                	jne    708c9e <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0xbee>
  708cc1:	4a 8b 44 2d f0       	mov    -0x10(%rbp,%r13,1),%rax
  708cc6:	48 85 c0             	test   %rax,%rax
  708cc9:	0f 84 dd 0d 00 00    	je     709aac <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x19fc>
  708ccf:	4a 8b 4c 2d e8       	mov    -0x18(%rbp,%r13,1),%rcx
  708cd4:	48 89 8c 24 48 01 00 	mov    %rcx,0x148(%rsp)
  708cdb:	00 
  708cdc:	48 c1 e0 02          	shl    $0x2,%rax
  708ce0:	f3 0f 7e 44 24 30    	movq   0x30(%rsp),%xmm0
  708ce6:	66 0f 6f 0d 32 cb 95 	movdqa -0x6a34ce(%rip),%xmm1        # 65820 <anon.079f5e587c394fcac2765eb4d0cf0bc2.397.llvm.6319143315422321905+0x9e0>
  708ced:	ff 
  708cee:	66 0f 6c c8          	punpcklqdq %xmm0,%xmm1
  708cf2:	66 0f 7f 8c 24 b0 03 	movdqa %xmm1,0x3b0(%rsp)
  708cf9:	00 00 
  708cfb:	48 c7 84 24 d0 00 00 	movq   $0x0,0xd0(%rsp)
  708d02:	00 00 00 00 00 
  708d07:	48 8d 0d da b8 3c 00 	lea    0x3cb8da(%rip),%rcx        # ad45e8 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0xe00>
  708d0e:	48 89 4c 24 68       	mov    %rcx,0x68(%rsp)
  708d13:	48 b9 00 00 00 00 00 	movabs $0x8000000000000000,%rcx
  708d1a:	00 00 80 
  708d1d:	48 ff c1             	inc    %rcx
  708d20:	48 89 8c 24 38 01 00 	mov    %rcx,0x138(%rsp)
  708d27:	00 
  708d28:	48 8d 0d b5 08 96 ff 	lea    -0x69f74b(%rip),%rcx        # 695e4 <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x2e24>
  708d2f:	48 89 8c 24 30 01 00 	mov    %rcx,0x130(%rsp)
  708d36:	00 
  708d37:	48 8d 0d 3a b9 3c 00 	lea    0x3cb93a(%rip),%rcx        # ad4678 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0xe90>
  708d3e:	48 89 8c 24 28 01 00 	mov    %rcx,0x128(%rsp)
  708d45:	00 
  708d46:	48 8d 0d b3 b8 3c 00 	lea    0x3cb8b3(%rip),%rcx        # ad4600 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0xe18>
  708d4d:	48 89 8c 24 d8 00 00 	mov    %rcx,0xd8(%rsp)
  708d54:	00 
  708d55:	48 8d 0d 5f 08 96 ff 	lea    -0x69f7a1(%rip),%rcx        # 695bb <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x2dfb>
  708d5c:	48 89 8c 24 e0 00 00 	mov    %rcx,0xe0(%rsp)
  708d63:	00 
  708d64:	48 8d 0d 1d ad 3c 00 	lea    0x3cad1d(%rip),%rcx        # ad3a88 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0x2a0>
  708d6b:	48 89 8c 24 b8 01 00 	mov    %rcx,0x1b8(%rsp)
  708d72:	00 
  708d73:	31 c9                	xor    %ecx,%ecx
  708d75:	48 c7 84 24 40 01 00 	movq   $0x0,0x140(%rsp)
  708d7c:	00 00 00 00 00 
  708d81:	48 c7 84 24 e8 00 00 	movq   $0x0,0xe8(%rsp)
  708d88:	00 00 00 00 00 
  708d8d:	48 c7 44 24 20 00 00 	movq   $0x0,0x20(%rsp)
  708d94:	00 00 
  708d96:	48 89 44 24 58       	mov    %rax,0x58(%rsp)
  708d9b:	48 8b 84 24 48 01 00 	mov    0x148(%rsp),%rax
  708da2:	00 
  708da3:	48 89 4c 24 38       	mov    %rcx,0x38(%rsp)
  708da8:	8b 2c 08             	mov    (%rax,%rcx,1),%ebp
  708dab:	49 ff 86 c0 06 00 00 	incq   0x6c0(%r14)
  708db2:	89 e8                	mov    %ebp,%eax
  708db4:	c1 e8 0f             	shr    $0xf,%eax
  708db7:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  708dbe:	48 39 c6             	cmp    %rax,%rsi
  708dc1:	48 89 44 24 28       	mov    %rax,0x28(%rsp)
  708dc6:	0f 86 7c 11 00 00    	jbe    709f48 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1e98>
  708dcc:	4d 8b a6 98 02 00 00 	mov    0x298(%r14),%r12
  708dd3:	4c 8d 2c 80          	lea    (%rax,%rax,4),%r13
  708dd7:	4b 8b 04 ec          	mov    (%r12,%r13,8),%rax
  708ddb:	48 89 44 24 48       	mov    %rax,0x48(%rsp)
  708de0:	89 ef                	mov    %ebp,%edi
  708de2:	ff 15 80 93 3f 00    	call   *0x3f9380(%rip)        # b02168 <_DYNAMIC+0x420>
  708de8:	89 44 24 08          	mov    %eax,0x8(%rsp)
  708dec:	4b 8d 04 ec          	lea    (%r12,%r13,8),%rax
  708df0:	48 89 84 24 c8 00 00 	mov    %rax,0xc8(%rsp)
  708df7:	00 
  708df8:	8b 54 24 08          	mov    0x8(%rsp),%edx
  708dfc:	66 85 d2             	test   %dx,%dx
  708dff:	0f 84 31 01 00 00    	je     708f36 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0xe86>
  708e05:	83 bc 24 60 03 00 00 	cmpl   $0x2,0x360(%rsp)
  708e0c:	02 
  708e0d:	0f 84 6d 0f 00 00    	je     709d80 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1cd0>
  708e13:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
  708e18:	48 89 44 24 70       	mov    %rax,0x70(%rsp)
  708e1d:	48 8b 84 24 50 03 00 	mov    0x350(%rsp),%rax
  708e24:	00 
  708e25:	48 8d 4c 24 78       	lea    0x78(%rsp),%rcx
  708e2a:	48 89 41 10          	mov    %rax,0x10(%rcx)
  708e2e:	66 0f 6f 84 24 40 03 	movdqa 0x340(%rsp),%xmm0
  708e35:	00 00 
  708e37:	f3 0f 7f 01          	movdqu %xmm0,(%rcx)
  708e3b:	48 8d bc 24 60 01 00 	lea    0x160(%rsp),%rdi
  708e42:	00 
  708e43:	48 8d 74 24 70       	lea    0x70(%rsp),%rsi
  708e48:	ff 15 22 93 3f 00    	call   *0x3f9322(%rip)        # b02170 <_DYNAMIC+0x428>
  708e4e:	0f b6 84 24 60 01 00 	movzbl 0x160(%rsp),%eax
  708e55:	00 
  708e56:	3c ff                	cmp    $0xff,%al
  708e58:	0f 84 10 0d 00 00    	je     709b6e <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1abe>
  708e5e:	0f b7 8c 24 61 01 00 	movzwl 0x161(%rsp),%ecx
  708e65:	00 
  708e66:	8b 94 24 63 01 00 00 	mov    0x163(%rsp),%edx
  708e6d:	0f b6 b4 24 67 01 00 	movzbl 0x167(%rsp),%esi
  708e74:	00 
  708e75:	4c 8d 84 24 68 01 00 	lea    0x168(%rsp),%r8
  708e7c:	00 
  708e7d:	41 8b 78 10          	mov    0x10(%r8),%edi
  708e81:	4c 8d 8c 24 7c 03 00 	lea    0x37c(%rsp),%r9
  708e88:	00 
  708e89:	41 89 79 10          	mov    %edi,0x10(%r9)
  708e8d:	f3 41 0f 6f 00       	movdqu (%r8),%xmm0
  708e92:	f3 41 0f 7f 01       	movdqu %xmm0,(%r9)
  708e97:	88 84 24 74 03 00 00 	mov    %al,0x374(%rsp)
  708e9e:	66 89 8c 24 75 03 00 	mov    %cx,0x375(%rsp)
  708ea5:	00 
  708ea6:	40 88 b4 24 7b 03 00 	mov    %sil,0x37b(%rsp)
  708ead:	00 
  708eae:	89 94 24 77 03 00 00 	mov    %edx,0x377(%rsp)
  708eb5:	8b 4c 24 08          	mov    0x8(%rsp),%ecx
  708eb9:	44 0f b7 e9          	movzwl %cx,%r13d
  708ebd:	48 8d 05 bc ba 3c 00 	lea    0x3cbabc(%rip),%rax        # ad4980 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0x1198>
  708ec4:	4a 8b 44 e8 f8       	mov    -0x8(%rax,%r13,8),%rax
  708ec9:	80 78 12 00          	cmpb   $0x0,0x12(%rax)
  708ecd:	0f 84 c7 00 00 00    	je     708f9a <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0xeea>
  708ed3:	48 8d 7c 24 70       	lea    0x70(%rsp),%rdi
  708ed8:	49 8d b6 10 06 00 00 	lea    0x610(%r14),%rsi
  708edf:	48 8b 54 24 48       	mov    0x48(%rsp),%rdx
  708ee4:	4c 8d 84 24 74 03 00 	lea    0x374(%rsp),%r8
  708eeb:	00 
  708eec:	ff 15 86 92 3f 00    	call   *0x3f9286(%rip)        # b02178 <_DYNAMIC+0x430>
  708ef2:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  708ef7:	0f b6 7c 24 78       	movzbl 0x78(%rsp),%edi
  708efc:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  708f00:	0f 85 ab 0d 00 00    	jne    709cb1 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1c01>
  708f06:	40 80 ff 01          	cmp    $0x1,%dil
  708f0a:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  708f0f:	48 8b 4c 24 38       	mov    0x38(%rsp),%rcx
  708f14:	4c 8b 6c 24 28       	mov    0x28(%rsp),%r13
  708f19:	0f 85 9e 08 00 00    	jne    7097bd <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x170d>
  708f1f:	41 c6 86 1f 07 00 00 	movb   $0x1,0x71f(%r14)
  708f26:	01 
  708f27:	b0 01                	mov    $0x1,%al
  708f29:	48 89 84 24 e8 00 00 	mov    %rax,0xe8(%rsp)
  708f30:	00 
  708f31:	e9 4e 08 00 00       	jmp    709784 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x16d4>
  708f36:	48 83 7c 24 60 fe    	cmpq   $0xfffffffffffffffe,0x60(%rsp)
  708f3c:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  708f41:	0f 84 59 0e 00 00    	je     709da0 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1cf0>
  708f47:	83 e5 03             	and    $0x3,%ebp
  708f4a:	8d 45 ff             	lea    -0x1(%rbp),%eax
  708f4d:	83 f8 02             	cmp    $0x2,%eax
  708f50:	0f 83 8a 00 00 00    	jae    708fe0 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0xf30>
  708f56:	49 8d 86 10 06 00 00 	lea    0x610(%r14),%rax
  708f5d:	48 8b 38             	mov    (%rax),%rdi
  708f60:	41 bc 2b 00 00 00    	mov    $0x2b,%r12d
  708f66:	48 85 ff             	test   %rdi,%rdi
  708f69:	0f 84 19 0e 00 00    	je     709d88 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1cd8>
  708f6f:	48 8b 74 24 48       	mov    0x48(%rsp),%rsi
  708f74:	ff 15 06 92 3f 00    	call   *0x3f9206(%rip)        # b02180 <_DYNAMIC+0x438>
  708f7a:	48 85 c0             	test   %rax,%rax
  708f7d:	0f 84 05 0e 00 00    	je     709d88 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1cd8>
  708f83:	83 fd 01             	cmp    $0x1,%ebp
  708f86:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  708f8b:	0f 85 a6 00 00 00    	jne    709037 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0xf87>
  708f91:	48 8b 78 08          	mov    0x8(%rax),%rdi
  708f95:	e9 a1 00 00 00       	jmp    70903b <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0xf8b>
  708f9a:	49 8d 86 00 02 00 00 	lea    0x200(%r14),%rax
  708fa1:	48 8b 00             	mov    (%rax),%rax
  708fa4:	48 8d 15 1d d3 95 ff 	lea    -0x6a2ce3(%rip),%rdx        # 662c8 <anon.079f5e587c394fcac2765eb4d0cf0bc2.397.llvm.6319143315422321905+0x1488>
  708fab:	48 63 0c 82          	movslq (%rdx,%rax,4),%rcx
  708faf:	48 01 d1             	add    %rdx,%rcx
  708fb2:	48 8d 05 0b da 95 ff 	lea    -0x6a25f5(%rip),%rax        # 669c4 <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x204>
  708fb9:	ff e1                	jmp    *%rcx
  708fbb:	49 8b b6 18 02 00 00 	mov    0x218(%r14),%rsi
  708fc2:	48 8b 44 24 28       	mov    0x28(%rsp),%rax
  708fc7:	48 39 c6             	cmp    %rax,%rsi
  708fca:	0f 86 3a 0f 00 00    	jbe    709f0a <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1e5a>
  708fd0:	48 6b c0 58          	imul   $0x58,%rax,%rax
  708fd4:	49 03 86 10 02 00 00 	add    0x210(%r14),%rax
  708fdb:	e9 4e 03 00 00       	jmp    70932e <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x127e>
  708fe0:	85 ed                	test   %ebp,%ebp
  708fe2:	0f 85 18 0e 00 00    	jne    709e00 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1d50>
  708fe8:	48 8b 84 24 c8 00 00 	mov    0xc8(%rsp),%rax
  708fef:	00 
  708ff0:	8b 40 20             	mov    0x20(%rax),%eax
  708ff3:	89 c1                	mov    %eax,%ecx
  708ff5:	83 e1 07             	and    $0x7,%ecx
  708ff8:	83 f9 06             	cmp    $0x6,%ecx
  708ffb:	74 74                	je     709071 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0xfc1>
  708ffd:	c1 e8 03             	shr    $0x3,%eax
  709000:	74 6f                	je     709071 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0xfc1>
  709002:	49 8b b6 b8 02 00 00 	mov    0x2b8(%r14),%rsi
  709009:	ff c8                	dec    %eax
  70900b:	48 39 c6             	cmp    %rax,%rsi
  70900e:	0f 86 23 0f 00 00    	jbe    709f37 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1e87>
  709014:	49 8b 8e b0 02 00 00 	mov    0x2b0(%r14),%rcx
  70901b:	48 8d 04 80          	lea    (%rax,%rax,4),%rax
  70901f:	48 c1 e0 04          	shl    $0x4,%rax
  709023:	48 83 3c 01 fe       	cmpq   $0xfffffffffffffffe,(%rcx,%rax,1)
  709028:	0f 84 59 0e 00 00    	je     709e87 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1dd7>
  70902e:	48 01 c1             	add    %rax,%rcx
  709031:	48 8b 79 40          	mov    0x40(%rcx),%rdi
  709035:	eb 13                	jmp    70904a <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0xf9a>
  709037:	48 8b 78 10          	mov    0x10(%rax),%rdi
  70903b:	b0 01                	mov    $0x1,%al
  70903d:	48 89 84 24 40 01 00 	mov    %rax,0x140(%rsp)
  709044:	00 
  709045:	48 85 ff             	test   %rdi,%rdi
  709048:	74 27                	je     709071 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0xfc1>
  70904a:	48 8b 07             	mov    (%rdi),%rax
  70904d:	48 d1 e8             	shr    $1,%rax
  709050:	48 8b 54 24 30       	mov    0x30(%rsp),%rdx
  709055:	48 39 d0             	cmp    %rdx,%rax
  709058:	75 17                	jne    709071 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0xfc1>
  70905a:	48 83 c7 10          	add    $0x10,%rdi
  70905e:	48 8b 74 24 50       	mov    0x50(%rsp),%rsi
  709063:	ff 15 1f 91 3f 00    	call   *0x3f911f(%rip)        # b02188 <bcmp@GLIBC_2.2.5>
  709069:	85 c0                	test   %eax,%eax
  70906b:	0f 84 3a 06 00 00    	je     7096ab <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x15fb>
  709071:	4c 8b 64 24 20       	mov    0x20(%rsp),%r12
  709076:	4d 85 e4             	test   %r12,%r12
  709079:	75 6d                	jne    7090e8 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1038>
  70907b:	4c 8d 25 ce cf 95 ff 	lea    -0x6a3032(%rip),%r12        # 66050 <anon.079f5e587c394fcac2765eb4d0cf0bc2.397.llvm.6319143315422321905+0x1210>
  709082:	48 8b 74 24 30       	mov    0x30(%rsp),%rsi
  709087:	48 85 f6             	test   %rsi,%rsi
  70908a:	74 41                	je     7090cd <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x101d>
  70908c:	48 c7 44 24 20 00 00 	movq   $0x0,0x20(%rsp)
  709093:	00 00 
  709095:	48 8d 7c 24 70       	lea    0x70(%rsp),%rdi
  70909a:	31 d2                	xor    %edx,%edx
  70909c:	31 c9                	xor    %ecx,%ecx
  70909e:	ff 15 ec 90 3f 00    	call   *0x3f90ec(%rip)        # b02190 <_DYNAMIC+0x448>
  7090a4:	48 8b 7c 24 70       	mov    0x70(%rsp),%rdi
  7090a9:	48 83 ff ff          	cmp    $0xffffffffffffffff,%rdi
  7090ad:	0f 85 6e 0e 00 00    	jne    709f21 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1e71>
  7090b3:	4c 8b 64 24 78       	mov    0x78(%rsp),%r12
  7090b8:	49 8d 7c 24 10       	lea    0x10(%r12),%rdi
  7090bd:	48 8b 74 24 50       	mov    0x50(%rsp),%rsi
  7090c2:	48 8b 54 24 30       	mov    0x30(%rsp),%rdx
  7090c7:	ff 15 eb 8e 3f 00    	call   *0x3f8eeb(%rip)        # b01fb8 <memcpy@GLIBC_2.14>
  7090cd:	f3 41 0f 6f 86 c8 06 	movdqu 0x6c8(%r14),%xmm0
  7090d4:	00 00 
  7090d6:	66 0f d4 84 24 b0 03 	paddq  0x3b0(%rsp),%xmm0
  7090dd:	00 00 
  7090df:	f3 41 0f 7f 86 c8 06 	movdqu %xmm0,0x6c8(%r14)
  7090e6:	00 00 
  7090e8:	85 ed                	test   %ebp,%ebp
  7090ea:	4c 89 64 24 20       	mov    %r12,0x20(%rsp)
  7090ef:	0f 84 b1 00 00 00    	je     7091a6 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x10f6>
  7090f5:	49 8d 86 10 06 00 00 	lea    0x610(%r14),%rax
  7090fc:	48 8b 38             	mov    (%rax),%rdi
  7090ff:	41 bd 2b 00 00 00    	mov    $0x2b,%r13d
  709105:	48 85 ff             	test   %rdi,%rdi
  709108:	0f 84 2e 0d 00 00    	je     709e3c <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1d8c>
  70910e:	48 8b 74 24 48       	mov    0x48(%rsp),%rsi
  709113:	ff 15 7f 90 3f 00    	call   *0x3f907f(%rip)        # b02198 <_DYNAMIC+0x450>
  709119:	48 85 c0             	test   %rax,%rax
  70911c:	0f 84 1a 0d 00 00    	je     709e3c <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1d8c>
  709122:	83 fd 01             	cmp    $0x1,%ebp
  709125:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  70912a:	4c 8b 6c 24 28       	mov    0x28(%rsp),%r13
  70912f:	0f 85 4d 01 00 00    	jne    709282 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x11d2>
  709135:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
  70913a:	48 85 c9             	test   %rcx,%rcx
  70913d:	74 2c                	je     70916b <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x10bb>
  70913f:	f6 01 01             	testb  $0x1,(%rcx)
  709142:	75 27                	jne    70916b <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x10bb>
  709144:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  709148:	f6 c2 01             	test   $0x1,%dl
  70914b:	75 1e                	jne    70916b <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x10bb>
  70914d:	ba 02 00 00 00       	mov    $0x2,%edx
  709152:	f0 48 0f c1 51 08    	lock xadd %rdx,0x8(%rcx)
  709158:	48 23 94 24 38 01 00 	and    0x138(%rsp),%rdx
  70915f:	00 
  709160:	48 f7 da             	neg    %rdx
  709163:	71 06                	jno    70916b <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x10bb>
  709165:	f0 48 83 49 08 01    	lock orq $0x1,0x8(%rcx)
  70916b:	48 89 c5             	mov    %rax,%rbp
  70916e:	48 8b 78 08          	mov    0x8(%rax),%rdi
  709172:	48 85 ff             	test   %rdi,%rdi
  709175:	74 1c                	je     709193 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x10e3>
  709177:	f6 07 01             	testb  $0x1,(%rdi)
  70917a:	75 17                	jne    709193 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x10e3>
  70917c:	48 8b 47 08          	mov    0x8(%rdi),%rax
  709180:	a8 01                	test   $0x1,%al
  709182:	75 0f                	jne    709193 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x10e3>
  709184:	48 8d 47 08          	lea    0x8(%rdi),%rax
  709188:	f0 48 83 28 02       	lock subq $0x2,(%rax)
  70918d:	0f 84 50 06 00 00    	je     7097e3 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1733>
  709193:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  709198:	48 89 45 08          	mov    %rax,0x8(%rbp)
  70919c:	48 8b 4c 24 38       	mov    0x38(%rsp),%rcx
  7091a1:	e9 de 05 00 00       	jmp    709784 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x16d4>
  7091a6:	48 8b 84 24 c8 00 00 	mov    0xc8(%rsp),%rax
  7091ad:	00 
  7091ae:	8b 78 20             	mov    0x20(%rax),%edi
  7091b1:	89 f8                	mov    %edi,%eax
  7091b3:	83 e0 07             	and    $0x7,%eax
  7091b6:	41 bd 16 00 00 00    	mov    $0x16,%r13d
  7091bc:	83 f8 06             	cmp    $0x6,%eax
  7091bf:	0f 84 59 0c 00 00    	je     709e1e <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1d6e>
  7091c5:	c1 ef 03             	shr    $0x3,%edi
  7091c8:	0f 84 50 0c 00 00    	je     709e1e <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1d6e>
  7091ce:	49 8b b6 b8 02 00 00 	mov    0x2b8(%r14),%rsi
  7091d5:	ff cf                	dec    %edi
  7091d7:	48 39 fe             	cmp    %rdi,%rsi
  7091da:	0f 86 01 0d 00 00    	jbe    709ee1 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1e31>
  7091e0:	49 8b ae b0 02 00 00 	mov    0x2b0(%r14),%rbp
  7091e7:	48 8d 04 bf          	lea    (%rdi,%rdi,4),%rax
  7091eb:	48 c1 e0 04          	shl    $0x4,%rax
  7091ef:	48 83 7c 05 00 fe    	cmpq   $0xfffffffffffffffe,0x0(%rbp,%rax,1)
  7091f5:	0f 84 5f 0c 00 00    	je     709e5a <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1daa>
  7091fb:	4d 85 e4             	test   %r12,%r12
  7091fe:	0f 84 68 0c 00 00    	je     709e6c <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1dbc>
  709204:	41 f6 04 24 01       	testb  $0x1,(%r12)
  709209:	75 2a                	jne    709235 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1185>
  70920b:	49 8b 4c 24 08       	mov    0x8(%r12),%rcx
  709210:	f6 c1 01             	test   $0x1,%cl
  709213:	75 20                	jne    709235 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1185>
  709215:	b9 02 00 00 00       	mov    $0x2,%ecx
  70921a:	f0 49 0f c1 4c 24 08 	lock xadd %rcx,0x8(%r12)
  709221:	48 23 8c 24 38 01 00 	and    0x138(%rsp),%rcx
  709228:	00 
  709229:	48 f7 d9             	neg    %rcx
  70922c:	71 07                	jno    709235 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1185>
  70922e:	f0 49 83 4c 24 08 01 	lock orq $0x1,0x8(%r12)
  709235:	48 01 c5             	add    %rax,%rbp
  709238:	48 8b 7d 40          	mov    0x40(%rbp),%rdi
  70923c:	f6 07 01             	testb  $0x1,(%rdi)
  70923f:	75 17                	jne    709258 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x11a8>
  709241:	48 8b 47 08          	mov    0x8(%rdi),%rax
  709245:	a8 01                	test   $0x1,%al
  709247:	75 0f                	jne    709258 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x11a8>
  709249:	48 8d 47 08          	lea    0x8(%rdi),%rax
  70924d:	f0 48 83 28 02       	lock subq $0x2,(%rax)
  709252:	0f 84 7c 05 00 00    	je     7097d4 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1724>
  709258:	4c 89 65 40          	mov    %r12,0x40(%rbp)
  70925c:	48 89 ef             	mov    %rbp,%rdi
  70925f:	e8 8c 85 ff ff       	call   7017f0 <core::ptr::drop_glue::<core::option::Option<gpui::runtime::Shaped>>>
  709264:	48 c7 45 00 ff ff ff 	movq   $0xffffffffffffffff,0x0(%rbp)
  70926b:	ff 
  70926c:	49 8d be 48 06 00 00 	lea    0x648(%r14),%rdi
  709273:	48 8b 74 24 48       	mov    0x48(%rsp),%rsi
  709278:	e8 d3 86 01 00       	call   721950 <<alloc::collections::btree::map::BTreeMap<u64, alloc::collections::btree::set_val::SetValZST>>::insert>
  70927d:	e9 e1 04 00 00       	jmp    709763 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x16b3>
  709282:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
  709287:	48 85 c9             	test   %rcx,%rcx
  70928a:	74 2c                	je     7092b8 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1208>
  70928c:	f6 01 01             	testb  $0x1,(%rcx)
  70928f:	75 27                	jne    7092b8 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1208>
  709291:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  709295:	f6 c2 01             	test   $0x1,%dl
  709298:	75 1e                	jne    7092b8 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1208>
  70929a:	ba 02 00 00 00       	mov    $0x2,%edx
  70929f:	f0 48 0f c1 51 08    	lock xadd %rdx,0x8(%rcx)
  7092a5:	48 23 94 24 38 01 00 	and    0x138(%rsp),%rdx
  7092ac:	00 
  7092ad:	48 f7 da             	neg    %rdx
  7092b0:	71 06                	jno    7092b8 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1208>
  7092b2:	f0 48 83 49 08 01    	lock orq $0x1,0x8(%rcx)
  7092b8:	48 89 c5             	mov    %rax,%rbp
  7092bb:	48 8b 78 10          	mov    0x10(%rax),%rdi
  7092bf:	48 85 ff             	test   %rdi,%rdi
  7092c2:	74 1c                	je     7092e0 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1230>
  7092c4:	f6 07 01             	testb  $0x1,(%rdi)
  7092c7:	75 17                	jne    7092e0 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1230>
  7092c9:	48 8b 47 08          	mov    0x8(%rdi),%rax
  7092cd:	a8 01                	test   $0x1,%al
  7092cf:	75 0f                	jne    7092e0 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1230>
  7092d1:	48 8d 47 08          	lea    0x8(%rdi),%rax
  7092d5:	f0 48 83 28 02       	lock subq $0x2,(%rax)
  7092da:	0f 84 12 05 00 00    	je     7097f2 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1742>
  7092e0:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  7092e5:	48 89 45 10          	mov    %rax,0x10(%rbp)
  7092e9:	48 8b 4c 24 38       	mov    0x38(%rsp),%rcx
  7092ee:	e9 91 04 00 00       	jmp    709784 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x16d4>
  7092f3:	49 8b b6 20 02 00 00 	mov    0x220(%r14),%rsi
  7092fa:	48 8b 4c 24 28       	mov    0x28(%rsp),%rcx
  7092ff:	48 39 ce             	cmp    %rcx,%rsi
  709302:	0f 86 eb 0b 00 00    	jbe    709ef3 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1e43>
  709308:	49 8b b6 10 02 00 00 	mov    0x210(%r14),%rsi
  70930f:	49 8b 86 18 02 00 00 	mov    0x218(%r14),%rax
  709316:	0f b6 04 08          	movzbl (%rax,%rcx,1),%eax
  70931a:	48 39 c6             	cmp    %rax,%rsi
  70931d:	0f 86 d9 0b 00 00    	jbe    709efc <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1e4c>
  709323:	48 6b c0 58          	imul   $0x58,%rax,%rax
  709327:	49 03 86 08 02 00 00 	add    0x208(%r14),%rax
  70932e:	48 8b 48 50          	mov    0x50(%rax),%rcx
  709332:	48 89 8c 24 b0 02 00 	mov    %rcx,0x2b0(%rsp)
  709339:	00 
  70933a:	0f 10 40 40          	movups 0x40(%rax),%xmm0
  70933e:	0f 29 84 24 a0 02 00 	movaps %xmm0,0x2a0(%rsp)
  709345:	00 
  709346:	f3 0f 6f 00          	movdqu (%rax),%xmm0
  70934a:	f3 0f 6f 48 10       	movdqu 0x10(%rax),%xmm1
  70934f:	0f 10 50 20          	movups 0x20(%rax),%xmm2
  709353:	0f 10 58 30          	movups 0x30(%rax),%xmm3
  709357:	0f 29 9c 24 90 02 00 	movaps %xmm3,0x290(%rsp)
  70935e:	00 
  70935f:	0f 29 94 24 80 02 00 	movaps %xmm2,0x280(%rsp)
  709366:	00 
  709367:	66 0f 7f 8c 24 70 02 	movdqa %xmm1,0x270(%rsp)
  70936e:	00 00 
  709370:	66 0f 7f 84 24 60 02 	movdqa %xmm0,0x260(%rsp)
  709377:	00 00 
  709379:	eb 1a                	jmp    709395 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x12e5>
  70937b:	49 8b b6 08 02 00 00 	mov    0x208(%r14),%rsi
  709382:	48 8d bc 24 60 02 00 	lea    0x260(%rsp),%rdi
  709389:	00 
  70938a:	48 8b 54 24 28       	mov    0x28(%rsp),%rdx
  70938f:	ff 15 0b 8d 3f 00    	call   *0x3f8d0b(%rip)        # b020a0 <_DYNAMIC+0x358>
  709395:	48 8b 84 24 b0 02 00 	mov    0x2b0(%rsp),%rax
  70939c:	00 
  70939d:	48 89 84 24 c0 00 00 	mov    %rax,0xc0(%rsp)
  7093a4:	00 
  7093a5:	0f 28 84 24 a0 02 00 	movaps 0x2a0(%rsp),%xmm0
  7093ac:	00 
  7093ad:	0f 29 84 24 b0 00 00 	movaps %xmm0,0xb0(%rsp)
  7093b4:	00 
  7093b5:	66 0f 6f 84 24 60 02 	movdqa 0x260(%rsp),%xmm0
  7093bc:	00 00 
  7093be:	66 0f 6f 8c 24 70 02 	movdqa 0x270(%rsp),%xmm1
  7093c5:	00 00 
  7093c7:	0f 28 94 24 80 02 00 	movaps 0x280(%rsp),%xmm2
  7093ce:	00 
  7093cf:	0f 28 9c 24 90 02 00 	movaps 0x290(%rsp),%xmm3
  7093d6:	00 
  7093d7:	0f 29 9c 24 a0 00 00 	movaps %xmm3,0xa0(%rsp)
  7093de:	00 
  7093df:	0f 29 94 24 90 00 00 	movaps %xmm2,0x90(%rsp)
  7093e6:	00 
  7093e7:	66 0f 7f 8c 24 80 00 	movdqa %xmm1,0x80(%rsp)
  7093ee:	00 00 
  7093f0:	66 0f 7f 44 24 70    	movdqa %xmm0,0x70(%rsp)
  7093f6:	48 8d bc 24 60 01 00 	lea    0x160(%rsp),%rdi
  7093fd:	00 
  7093fe:	49 8d b6 f8 05 00 00 	lea    0x5f8(%r14),%rsi
  709405:	48 8b 54 24 48       	mov    0x48(%rsp),%rdx
  70940a:	48 8d 4c 24 70       	lea    0x70(%rsp),%rcx
  70940f:	44 8b 44 24 08       	mov    0x8(%rsp),%r8d
  709414:	4c 8d 8c 24 74 03 00 	lea    0x374(%rsp),%r9
  70941b:	00 
  70941c:	e8 bf 80 02 00       	call   7314e0 <<gpui::property::Overrides>::update_base>
  709421:	8b 84 24 60 01 00 00 	mov    0x160(%rsp),%eax
  709428:	8b 8c 24 65 01 00 00 	mov    0x165(%rsp),%ecx
  70942f:	0f b6 ac 24 69 01 00 	movzbl 0x169(%rsp),%ebp
  709436:	00 
  709437:	48 c1 e5 20          	shl    $0x20,%rbp
  70943b:	48 09 cd             	or     %rcx,%rbp
  70943e:	0f b6 bc 24 64 01 00 	movzbl 0x164(%rsp),%edi
  709445:	00 
  709446:	83 f8 02             	cmp    $0x2,%eax
  709449:	0f 84 ba 08 00 00    	je     709d09 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1c59>
  70944f:	48 8d 8c 24 68 01 00 	lea    0x168(%rsp),%rcx
  709456:	00 
  709457:	0f 10 41 40          	movups 0x40(%rcx),%xmm0
  70945b:	48 8d 94 24 ca 01 00 	lea    0x1ca(%rsp),%rdx
  709462:	00 
  709463:	0f 11 42 3e          	movups %xmm0,0x3e(%rdx)
  709467:	0f 10 41 02          	movups 0x2(%rcx),%xmm0
  70946b:	0f 10 49 12          	movups 0x12(%rcx),%xmm1
  70946f:	0f 10 51 22          	movups 0x22(%rcx),%xmm2
  709473:	0f 10 59 32          	movups 0x32(%rcx),%xmm3
  709477:	0f 11 5a 30          	movups %xmm3,0x30(%rdx)
  70947b:	0f 11 52 20          	movups %xmm2,0x20(%rdx)
  70947f:	0f 11 4a 10          	movups %xmm1,0x10(%rdx)
  709483:	0f 11 02             	movups %xmm0,(%rdx)
  709486:	89 84 24 c0 01 00 00 	mov    %eax,0x1c0(%rsp)
  70948d:	40 88 bc 24 c4 01 00 	mov    %dil,0x1c4(%rsp)
  709494:	00 
  709495:	48 89 e8             	mov    %rbp,%rax
  709498:	48 c1 e8 20          	shr    $0x20,%rax
  70949c:	88 84 24 c9 01 00 00 	mov    %al,0x1c9(%rsp)
  7094a3:	89 ac 24 c5 01 00 00 	mov    %ebp,0x1c5(%rsp)
  7094aa:	f3 0f 6f 84 24 d0 01 	movdqu 0x1d0(%rsp),%xmm0
  7094b1:	00 00 
  7094b3:	f3 0f 6f 8c 24 e0 01 	movdqu 0x1e0(%rsp),%xmm1
  7094ba:	00 00 
  7094bc:	0f 10 94 24 f0 01 00 	movups 0x1f0(%rsp),%xmm2
  7094c3:	00 
  7094c4:	0f 10 9c 24 00 02 00 	movups 0x200(%rsp),%xmm3
  7094cb:	00 
  7094cc:	66 0f 7f 84 24 d0 02 	movdqa %xmm0,0x2d0(%rsp)
  7094d3:	00 00 
  7094d5:	66 0f 7f 8c 24 e0 02 	movdqa %xmm1,0x2e0(%rsp)
  7094dc:	00 00 
  7094de:	0f 29 94 24 f0 02 00 	movaps %xmm2,0x2f0(%rsp)
  7094e5:	00 
  7094e6:	0f 29 9c 24 00 03 00 	movaps %xmm3,0x300(%rsp)
  7094ed:	00 
  7094ee:	48 8b 84 24 10 02 00 	mov    0x210(%rsp),%rax
  7094f5:	00 
  7094f6:	48 89 84 24 10 03 00 	mov    %rax,0x310(%rsp)
  7094fd:	00 
  7094fe:	8b 84 24 c0 01 00 00 	mov    0x1c0(%rsp),%eax
  709505:	89 84 24 c0 02 00 00 	mov    %eax,0x2c0(%rsp)
  70950c:	0f b6 84 24 c4 01 00 	movzbl 0x1c4(%rsp),%eax
  709513:	00 
  709514:	88 84 24 c4 02 00 00 	mov    %al,0x2c4(%rsp)
  70951b:	8b 84 24 c5 01 00 00 	mov    0x1c5(%rsp),%eax
  709522:	89 84 24 c5 02 00 00 	mov    %eax,0x2c5(%rsp)
  709529:	0f b6 84 24 c9 01 00 	movzbl 0x1c9(%rsp),%eax
  709530:	00 
  709531:	88 84 24 c9 02 00 00 	mov    %al,0x2c9(%rsp)
  709538:	8b 84 24 ca 01 00 00 	mov    0x1ca(%rsp),%eax
  70953f:	89 84 24 ca 02 00 00 	mov    %eax,0x2ca(%rsp)
  709546:	0f b7 84 24 ce 01 00 	movzwl 0x1ce(%rsp),%eax
  70954d:	00 
  70954e:	66 89 84 24 ce 02 00 	mov    %ax,0x2ce(%rsp)
  709555:	00 
  709556:	0f b6 84 24 c0 02 00 	movzbl 0x2c0(%rsp),%eax
  70955d:	00 
  70955e:	83 bc 24 60 02 00 00 	cmpl   $0x1,0x260(%rsp)
  709565:	01 
  709566:	75 1a                	jne    709582 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x14d2>
  709568:	8b 8c 24 c4 02 00 00 	mov    0x2c4(%rsp),%ecx
  70956f:	39 8c 24 64 02 00 00 	cmp    %ecx,0x264(%rsp)
  709576:	0f 94 c1             	sete   %cl
  709579:	84 c8                	test   %cl,%al
  70957b:	75 0d                	jne    70958a <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x14da>
  70957d:	e9 38 01 00 00       	jmp    7096ba <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x160a>
  709582:	a8 01                	test   $0x1,%al
  709584:	0f 85 30 01 00 00    	jne    7096ba <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x160a>
  70958a:	0f b6 84 24 c8 02 00 	movzbl 0x2c8(%rsp),%eax
  709591:	00 
  709592:	83 bc 24 68 02 00 00 	cmpl   $0x1,0x268(%rsp)
  709599:	01 
  70959a:	75 1b                	jne    7095b7 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1507>
  70959c:	8b 8c 24 cc 02 00 00 	mov    0x2cc(%rsp),%ecx
  7095a3:	39 8c 24 6c 02 00 00 	cmp    %ecx,0x26c(%rsp)
  7095aa:	0f 94 c1             	sete   %cl
  7095ad:	84 c8                	test   %cl,%al
  7095af:	0f 84 05 01 00 00    	je     7096ba <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x160a>
  7095b5:	eb 08                	jmp    7095bf <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x150f>
  7095b7:	a8 01                	test   $0x1,%al
  7095b9:	0f 85 fb 00 00 00    	jne    7096ba <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x160a>
  7095bf:	8b 84 24 70 02 00 00 	mov    0x270(%rsp),%eax
  7095c6:	3b 84 24 d0 02 00 00 	cmp    0x2d0(%rsp),%eax
  7095cd:	0f 85 e7 00 00 00    	jne    7096ba <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x160a>
  7095d3:	8b 84 24 74 02 00 00 	mov    0x274(%rsp),%eax
  7095da:	3b 84 24 d4 02 00 00 	cmp    0x2d4(%rsp),%eax
  7095e1:	0f 85 d3 00 00 00    	jne    7096ba <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x160a>
  7095e7:	8b 84 24 78 02 00 00 	mov    0x278(%rsp),%eax
  7095ee:	3b 84 24 d8 02 00 00 	cmp    0x2d8(%rsp),%eax
  7095f5:	0f 85 bf 00 00 00    	jne    7096ba <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x160a>
  7095fb:	0f b6 84 24 b4 02 00 	movzbl 0x2b4(%rsp),%eax
  709602:	00 
  709603:	3a 84 24 14 03 00 00 	cmp    0x314(%rsp),%al
  70960a:	0f 85 aa 00 00 00    	jne    7096ba <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x160a>
  709610:	0f b6 84 24 b6 02 00 	movzbl 0x2b6(%rsp),%eax
  709617:	00 
  709618:	3a 84 24 16 03 00 00 	cmp    0x316(%rsp),%al
  70961f:	0f 85 95 00 00 00    	jne    7096ba <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x160a>
  709625:	0f b6 84 24 b7 02 00 	movzbl 0x2b7(%rsp),%eax
  70962c:	00 
  70962d:	3a 84 24 17 03 00 00 	cmp    0x317(%rsp),%al
  709634:	0f 85 80 00 00 00    	jne    7096ba <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x160a>
  70963a:	0f b6 84 24 b5 02 00 	movzbl 0x2b5(%rsp),%eax
  709641:	00 
  709642:	3a 84 24 15 03 00 00 	cmp    0x315(%rsp),%al
  709649:	75 6f                	jne    7096ba <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x160a>
  70964b:	48 8d bc 24 9c 02 00 	lea    0x29c(%rsp),%rdi
  709652:	00 
  709653:	48 8d b4 24 fc 02 00 	lea    0x2fc(%rsp),%rsi
  70965a:	00 
  70965b:	e8 90 67 01 00       	call   71fdf0 <<gpui_reactivity_core::geometry::Affine as gpui::property::ExactValue>::same>
  709660:	84 c0                	test   %al,%al
  709662:	74 56                	je     7096ba <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x160a>
  709664:	f3 0f 6f 84 24 7c 02 	movdqu 0x27c(%rsp),%xmm0
  70966b:	00 00 
  70966d:	f3 0f 6f 8c 24 dc 02 	movdqu 0x2dc(%rsp),%xmm1
  709674:	00 00 
  709676:	66 0f 74 c8          	pcmpeqb %xmm0,%xmm1
  70967a:	66 0f d7 c1          	pmovmskb %xmm1,%eax
  70967e:	3d ff ff 00 00       	cmp    $0xffff,%eax
  709683:	75 35                	jne    7096ba <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x160a>
  709685:	f3 0f 6f 84 24 8c 02 	movdqu 0x28c(%rsp),%xmm0
  70968c:	00 00 
  70968e:	f3 0f 6f 8c 24 ec 02 	movdqu 0x2ec(%rsp),%xmm1
  709695:	00 00 
  709697:	66 0f 74 c8          	pcmpeqb %xmm0,%xmm1
  70969b:	66 0f d7 c1          	pmovmskb %xmm1,%eax
  70969f:	3d ff ff 00 00       	cmp    $0xffff,%eax
  7096a4:	75 14                	jne    7096ba <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x160a>
  7096a6:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  7096ab:	48 8b 44 24 58       	mov    0x58(%rsp),%rax
  7096b0:	48 8b 4c 24 38       	mov    0x38(%rsp),%rcx
  7096b5:	e9 08 01 00 00       	jmp    7097c2 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1712>
  7096ba:	48 8d 05 bf b2 3c 00 	lea    0x3cb2bf(%rip),%rax        # ad4980 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0x1198>
  7096c1:	4a 8b 44 e8 f8       	mov    -0x8(%rax,%r13,8),%rax
  7096c6:	80 78 13 02          	cmpb   $0x2,0x13(%rax)
  7096ca:	75 11                	jne    7096dd <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x162d>
  7096cc:	49 8d be 48 06 00 00 	lea    0x648(%r14),%rdi
  7096d3:	48 8b 74 24 48       	mov    0x48(%rsp),%rsi
  7096d8:	e8 73 82 01 00       	call   721950 <<alloc::collections::btree::map::BTreeMap<u64, alloc::collections::btree::set_val::SetValZST>>::insert>
  7096dd:	66 83 7c 24 08 05    	cmpw   $0x5,0x8(%rsp)
  7096e3:	4c 8b 64 24 28       	mov    0x28(%rsp),%r12
  7096e8:	75 5a                	jne    709744 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1694>
  7096ea:	48 8b 84 24 c8 00 00 	mov    0xc8(%rsp),%rax
  7096f1:	00 
  7096f2:	8b 40 20             	mov    0x20(%rax),%eax
  7096f5:	89 c1                	mov    %eax,%ecx
  7096f7:	83 e1 07             	and    $0x7,%ecx
  7096fa:	83 f9 06             	cmp    $0x6,%ecx
  7096fd:	74 45                	je     709744 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1694>
  7096ff:	c1 e8 03             	shr    $0x3,%eax
  709702:	74 40                	je     709744 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1694>
  709704:	49 8b b6 b8 02 00 00 	mov    0x2b8(%r14),%rsi
  70970b:	ff c8                	dec    %eax
  70970d:	48 39 c6             	cmp    %rax,%rsi
  709710:	0f 86 fd 07 00 00    	jbe    709f13 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1e63>
  709716:	49 8b ae b0 02 00 00 	mov    0x2b0(%r14),%rbp
  70971d:	48 8d 04 80          	lea    (%rax,%rax,4),%rax
  709721:	48 c1 e0 04          	shl    $0x4,%rax
  709725:	48 83 7c 05 00 fe    	cmpq   $0xfffffffffffffffe,0x0(%rbp,%rax,1)
  70972b:	0f 84 65 07 00 00    	je     709e96 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1de6>
  709731:	48 01 c5             	add    %rax,%rbp
  709734:	48 89 ef             	mov    %rbp,%rdi
  709737:	e8 b4 80 ff ff       	call   7017f0 <core::ptr::drop_glue::<core::option::Option<gpui::runtime::Shaped>>>
  70973c:	48 c7 45 00 ff ff ff 	movq   $0xffffffffffffffff,0x0(%rbp)
  709743:	ff 
  709744:	49 8b 8e a0 02 00 00 	mov    0x2a0(%r14),%rcx
  70974b:	49 8d be 00 02 00 00 	lea    0x200(%r14),%rdi
  709752:	4c 89 e6             	mov    %r12,%rsi
  709755:	48 8d 94 24 c0 01 00 	lea    0x1c0(%rsp),%rdx
  70975c:	00 
  70975d:	ff 15 3d 8a 3f 00    	call   *0x3f8a3d(%rip)        # b021a0 <_DYNAMIC+0x458>
  709763:	41 c6 86 1f 07 00 00 	movb   $0x1,0x71f(%r14)
  70976a:	01 
  70976b:	b0 01                	mov    $0x1,%al
  70976d:	48 89 84 24 e8 00 00 	mov    %rax,0xe8(%rsp)
  709774:	00 
  709775:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  70977a:	48 8b 4c 24 38       	mov    0x38(%rsp),%rcx
  70977f:	4c 8b 6c 24 28       	mov    0x28(%rsp),%r13
  709784:	4c 39 ac 24 50 01 00 	cmp    %r13,0x150(%rsp)
  70978b:	00 
  70978c:	0f 94 c0             	sete   %al
  70978f:	84 84 24 d0 00 00 00 	test   %al,0xd0(%rsp)
  709796:	74 0c                	je     7097a4 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x16f4>
  709798:	b0 01                	mov    $0x1,%al
  70979a:	48 89 84 24 d0 00 00 	mov    %rax,0xd0(%rsp)
  7097a1:	00 
  7097a2:	eb 19                	jmp    7097bd <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x170d>
  7097a4:	49 ff 86 08 07 00 00 	incq   0x708(%r14)
  7097ab:	b0 01                	mov    $0x1,%al
  7097ad:	48 89 84 24 d0 00 00 	mov    %rax,0xd0(%rsp)
  7097b4:	00 
  7097b5:	4c 89 ac 24 50 01 00 	mov    %r13,0x150(%rsp)
  7097bc:	00 
  7097bd:	48 8b 44 24 58       	mov    0x58(%rsp),%rax
  7097c2:	48 83 c1 04          	add    $0x4,%rcx
  7097c6:	48 39 c8             	cmp    %rcx,%rax
  7097c9:	0f 85 cc f5 ff ff    	jne    708d9b <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0xceb>
  7097cf:	e9 ee 02 00 00       	jmp    709ac2 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1a12>
  7097d4:	48 8b 47 08          	mov    0x8(%rdi),%rax
  7097d8:	ff 15 12 88 3f 00    	call   *0x3f8812(%rip)        # b01ff0 <_DYNAMIC+0x2a8>
  7097de:	e9 75 fa ff ff       	jmp    709258 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x11a8>
  7097e3:	48 8b 47 08          	mov    0x8(%rdi),%rax
  7097e7:	ff 15 03 88 3f 00    	call   *0x3f8803(%rip)        # b01ff0 <_DYNAMIC+0x2a8>
  7097ed:	e9 a1 f9 ff ff       	jmp    709193 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x10e3>
  7097f2:	48 8b 47 08          	mov    0x8(%rdi),%rax
  7097f6:	ff 15 f4 87 3f 00    	call   *0x3f87f4(%rip)        # b01ff0 <_DYNAMIC+0x2a8>
  7097fc:	e9 df fa ff ff       	jmp    7092e0 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1230>
  709801:	49 83 c4 04          	add    $0x4,%r12
  709805:	4c 39 64 24 28       	cmp    %r12,0x28(%rsp)
  70980a:	0f 84 b1 f4 ff ff    	je     708cc1 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0xc11>
  709810:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  709815:	42 8b 3c 20          	mov    (%rax,%r12,1),%edi
  709819:	ff 15 49 89 3f 00    	call   *0x3f8949(%rip)        # b02168 <_DYNAMIC+0x420>
  70981f:	66 85 c0             	test   %ax,%ax
  709822:	74 dd                	je     709801 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1751>
  709824:	48 8b 4c 24 18       	mov    0x18(%rsp),%rcx
  709829:	48 89 4c 24 70       	mov    %rcx,0x70(%rsp)
  70982e:	48 8b 8c 24 50 03 00 	mov    0x350(%rsp),%rcx
  709835:	00 
  709836:	48 8d 54 24 78       	lea    0x78(%rsp),%rdx
  70983b:	48 89 4a 10          	mov    %rcx,0x10(%rdx)
  70983f:	66 0f 6f 84 24 40 03 	movdqa 0x340(%rsp),%xmm0
  709846:	00 00 
  709848:	f3 0f 7f 02          	movdqu %xmm0,(%rdx)
  70984c:	48 8d bc 24 60 01 00 	lea    0x160(%rsp),%rdi
  709853:	00 
  709854:	48 8d 74 24 70       	lea    0x70(%rsp),%rsi
  709859:	89 c2                	mov    %eax,%edx
  70985b:	ff 15 0f 89 3f 00    	call   *0x3f890f(%rip)        # b02170 <_DYNAMIC+0x428>
  709861:	80 bc 24 60 01 00 00 	cmpb   $0xff,0x160(%rsp)
  709868:	ff 
  709869:	75 96                	jne    709801 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1751>
  70986b:	0f b6 bc 24 62 01 00 	movzbl 0x162(%rsp),%edi
  709872:	00 
  709873:	8b 84 24 63 01 00 00 	mov    0x163(%rsp),%eax
  70987a:	0f b6 ac 24 67 01 00 	movzbl 0x167(%rsp),%ebp
  709881:	00 
  709882:	48 c1 e5 20          	shl    $0x20,%rbp
  709886:	48 09 c5             	or     %rax,%rbp
  709889:	b8 24 00 00 00       	mov    $0x24,%eax
  70988e:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  709893:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  709898:	48 8b 74 24 60       	mov    0x60(%rsp),%rsi
  70989d:	48 85 f6             	test   %rsi,%rsi
  7098a0:	0f 8e 12 02 00 00    	jle    709ab8 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1a08>
  7098a6:	ba 01 00 00 00       	mov    $0x1,%edx
  7098ab:	89 7c 24 18          	mov    %edi,0x18(%rsp)
  7098af:	48 8b 7c 24 50       	mov    0x50(%rsp),%rdi
  7098b4:	ff 15 d6 86 3f 00    	call   *0x3f86d6(%rip)        # b01f90 <_DYNAMIC+0x248>
  7098ba:	8b 7c 24 18          	mov    0x18(%rsp),%edi
  7098be:	4c 8b 44 24 30       	mov    0x30(%rsp),%r8
  7098c3:	e9 1f 03 00 00       	jmp    709be7 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1b37>
  7098c8:	31 ff                	xor    %edi,%edi
  7098ca:	48 8b 74 24 60       	mov    0x60(%rsp),%rsi
  7098cf:	48 85 f6             	test   %rsi,%rsi
  7098d2:	7e 5c                	jle    709930 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1880>
  7098d4:	ba 01 00 00 00       	mov    $0x1,%edx
  7098d9:	89 fd                	mov    %edi,%ebp
  7098db:	48 8b 7c 24 50       	mov    0x50(%rsp),%rdi
  7098e0:	ff 15 aa 86 3f 00    	call   *0x3f86aa(%rip)        # b01f90 <_DYNAMIC+0x248>
  7098e6:	89 ef                	mov    %ebp,%edi
  7098e8:	eb 46                	jmp    709930 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1880>
  7098ea:	0f b6 bc 24 62 01 00 	movzbl 0x162(%rsp),%edi
  7098f1:	00 
  7098f2:	8b 84 24 63 01 00 00 	mov    0x163(%rsp),%eax
  7098f9:	0f b6 ac 24 67 01 00 	movzbl 0x167(%rsp),%ebp
  709900:	00 
  709901:	48 c1 e5 20          	shl    $0x20,%rbp
  709905:	48 09 c5             	or     %rax,%rbp
  709908:	b8 24 00 00 00       	mov    $0x24,%eax
  70990d:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  709912:	e9 99 02 00 00       	jmp    709bb0 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1b00>
  709917:	b0 01                	mov    $0x1,%al
  709919:	48 89 44 24 40       	mov    %rax,0x40(%rsp)
  70991e:	49 8b ae c8 05 00 00 	mov    0x5c8(%r14),%rbp
  709925:	48 85 ed             	test   %rbp,%rbp
  709928:	0f 85 0e ef ff ff    	jne    70883c <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x78c>
  70992e:	31 ff                	xor    %edi,%edi
  709930:	80 7c 24 40 00       	cmpb   $0x0,0x40(%rsp)
  709935:	74 3c                	je     709973 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x18c3>
  709937:	41 80 be 1f 07 00 00 	cmpb   $0x1,0x71f(%r14)
  70993e:	01 
  70993f:	75 32                	jne    709973 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x18c3>
  709941:	48 8d 7c 24 70       	lea    0x70(%rsp),%rdi
  709946:	4c 89 f6             	mov    %r14,%rsi
  709949:	48 8b 94 24 58 01 00 	mov    0x158(%rsp),%rdx
  709950:	00 
  709951:	31 c9                	xor    %ecx,%ecx
  709953:	e8 98 d7 ff ff       	call   7070f0 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::describe_with>
  709958:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  70995d:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  709961:	75 1e                	jne    709981 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x18d1>
  709963:	48 c7 44 24 08 fe ff 	movq   $0xfffffffffffffffe,0x8(%rsp)
  70996a:	ff ff 
  70996c:	31 ff                	xor    %edi,%edi
  70996e:	e9 94 02 00 00       	jmp    709c07 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1b57>
  709973:	48 c7 44 24 08 fe ff 	movq   $0xfffffffffffffffe,0x8(%rsp)
  70997a:	ff ff 
  70997c:	e9 86 02 00 00       	jmp    709c07 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1b57>
  709981:	0f b6 7c 24 78       	movzbl 0x78(%rsp),%edi
  709986:	0f b6 4c 24 7f       	movzbl 0x7f(%rsp),%ecx
  70998b:	c1 e1 10             	shl    $0x10,%ecx
  70998e:	0f b7 54 24 7d       	movzwl 0x7d(%rsp),%edx
  709993:	09 ca                	or     %ecx,%edx
  709995:	48 c1 e2 20          	shl    $0x20,%rdx
  709999:	8b 6c 24 79          	mov    0x79(%rsp),%ebp
  70999d:	48 09 d5             	or     %rdx,%rbp
  7099a0:	4c 8b 84 24 80 00 00 	mov    0x80(%rsp),%r8
  7099a7:	00 
  7099a8:	4c 8b ac 24 88 00 00 	mov    0x88(%rsp),%r13
  7099af:	00 
  7099b0:	f3 0f 6f 84 24 90 00 	movdqu 0x90(%rsp),%xmm0
  7099b7:	00 00 
  7099b9:	66 0f 7f 84 24 c0 01 	movdqa %xmm0,0x1c0(%rsp)
  7099c0:	00 00 
  7099c2:	48 8b 8c 24 a0 00 00 	mov    0xa0(%rsp),%rcx
  7099c9:	00 
  7099ca:	48 89 8c 24 d0 01 00 	mov    %rcx,0x1d0(%rsp)
  7099d1:	00 
  7099d2:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  7099d7:	e9 2b 02 00 00       	jmp    709c07 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1b57>
  7099dc:	b8 20 00 00 00       	mov    $0x20,%eax
  7099e1:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  7099e6:	40 b7 0c             	mov    $0xc,%dil
  7099e9:	31 ed                	xor    %ebp,%ebp
  7099eb:	4d 89 f8             	mov    %r15,%r8
  7099ee:	e9 bd 01 00 00       	jmp    709bb0 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1b00>
  7099f3:	49 8b 86 90 06 00 00 	mov    0x690(%r14),%rax
  7099fa:	48 8d 48 01          	lea    0x1(%rax),%rcx
  7099fe:	49 3b 8e 60 06 00 00 	cmp    0x660(%r14),%rcx
  709a05:	40 0f 94 c5          	sete   %bpl
  709a09:	48 ff c0             	inc    %rax
  709a0c:	0f 84 d5 f0 ff ff    	je     708ae7 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0xa37>
  709a12:	49 8d b6 00 02 00 00 	lea    0x200(%r14),%rsi
  709a19:	48 8d bc 24 60 01 00 	lea    0x160(%rsp),%rdi
  709a20:	00 
  709a21:	48 8d 8c 24 60 02 00 	lea    0x260(%rsp),%rcx
  709a28:	00 
  709a29:	ff 15 79 87 3f 00    	call   *0x3f8779(%rip)        # b021a8 <_DYNAMIC+0x460>
  709a2f:	80 bc 24 60 01 00 00 	cmpb   $0x0,0x160(%rsp)
  709a36:	00 
  709a37:	74 21                	je     709a5a <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x19aa>
  709a39:	8b 94 24 84 01 00 00 	mov    0x184(%rsp),%edx
  709a40:	49 89 96 08 07 00 00 	mov    %rdx,0x708(%r14)
  709a47:	40 84 ed             	test   %bpl,%bpl
  709a4a:	0f 84 48 01 00 00    	je     709b98 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1ae8>
  709a50:	48 8d 94 24 64 01 00 	lea    0x164(%rsp),%rdx
  709a57:	00 
  709a58:	eb 16                	jmp    709a70 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x19c0>
  709a5a:	49 c7 86 08 07 00 00 	movq   $0x0,0x708(%r14)
  709a61:	00 00 00 00 
  709a65:	31 d2                	xor    %edx,%edx
  709a67:	40 84 ed             	test   %bpl,%bpl
  709a6a:	0f 84 28 01 00 00    	je     709b98 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1ae8>
  709a70:	48 8d 7c 24 70       	lea    0x70(%rsp),%rdi
  709a75:	4c 89 f6             	mov    %r14,%rsi
  709a78:	e8 f3 07 00 00       	call   70a270 <<gpui::runtime::Runtime<unit_action_cost::Model>>::finish_color_slot>
  709a7d:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  709a82:	0f b6 7c 24 78       	movzbl 0x78(%rsp),%edi
  709a87:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  709a8b:	0f 85 8c 00 00 00    	jne    709b1d <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1a6d>
  709a91:	40 f6 c7 01          	test   $0x1,%dil
  709a95:	0f 84 f6 00 00 00    	je     709b91 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1ae1>
  709a9b:	48 c7 44 24 08 fe ff 	movq   $0xfffffffffffffffe,0x8(%rsp)
  709aa2:	ff ff 
  709aa4:	40 b7 02             	mov    $0x2,%dil
  709aa7:	e9 04 01 00 00       	jmp    709bb0 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1b00>
  709aac:	31 ff                	xor    %edi,%edi
  709aae:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  709ab3:	e9 12 fe ff ff       	jmp    7098ca <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x181a>
  709ab8:	4c 8b 44 24 30       	mov    0x30(%rsp),%r8
  709abd:	e9 25 01 00 00       	jmp    709be7 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1b37>
  709ac2:	48 8b 84 24 e8 00 00 	mov    0xe8(%rsp),%rax
  709ac9:	00 
  709aca:	34 01                	xor    $0x1,%al
  709acc:	0f b6 c0             	movzbl %al,%eax
  709acf:	31 ff                	xor    %edi,%edi
  709ad1:	f6 84 24 40 01 00 00 	testb  $0x1,0x140(%rsp)
  709ad8:	01 
  709ad9:	0f 45 f8             	cmovne %eax,%edi
  709adc:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  709ae1:	48 85 c0             	test   %rax,%rax
  709ae4:	0f 84 e0 fd ff ff    	je     7098ca <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x181a>
  709aea:	f6 00 01             	testb  $0x1,(%rax)
  709aed:	0f 85 d7 fd ff ff    	jne    7098ca <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x181a>
  709af3:	89 fd                	mov    %edi,%ebp
  709af5:	48 8b 40 08          	mov    0x8(%rax),%rax
  709af9:	a8 01                	test   $0x1,%al
  709afb:	75 14                	jne    709b11 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1a61>
  709afd:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  709b02:	48 83 c0 08          	add    $0x8,%rax
  709b06:	f0 48 83 28 02       	lock subq $0x2,(%rax)
  709b0b:	0f 84 b5 03 00 00    	je     709ec6 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1e16>
  709b11:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  709b16:	89 ef                	mov    %ebp,%edi
  709b18:	e9 ad fd ff ff       	jmp    7098ca <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x181a>
  709b1d:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  709b22:	0f b6 44 24 7f       	movzbl 0x7f(%rsp),%eax
  709b27:	c1 e0 10             	shl    $0x10,%eax
  709b2a:	0f b7 4c 24 7d       	movzwl 0x7d(%rsp),%ecx
  709b2f:	09 c1                	or     %eax,%ecx
  709b31:	48 c1 e1 20          	shl    $0x20,%rcx
  709b35:	8b 6c 24 79          	mov    0x79(%rsp),%ebp
  709b39:	48 09 cd             	or     %rcx,%rbp
  709b3c:	4c 8b 84 24 80 00 00 	mov    0x80(%rsp),%r8
  709b43:	00 
  709b44:	4c 8b ac 24 88 00 00 	mov    0x88(%rsp),%r13
  709b4b:	00 
  709b4c:	0f 10 84 24 90 00 00 	movups 0x90(%rsp),%xmm0
  709b53:	00 
  709b54:	0f 29 84 24 20 03 00 	movaps %xmm0,0x320(%rsp)
  709b5b:	00 
  709b5c:	48 8b 84 24 a0 00 00 	mov    0xa0(%rsp),%rax
  709b63:	00 
  709b64:	48 89 84 24 30 03 00 	mov    %rax,0x330(%rsp)
  709b6b:	00 
  709b6c:	eb 42                	jmp    709bb0 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1b00>
  709b6e:	0f b6 bc 24 62 01 00 	movzbl 0x162(%rsp),%edi
  709b75:	00 
  709b76:	8b 84 24 63 01 00 00 	mov    0x163(%rsp),%eax
  709b7d:	0f b6 ac 24 67 01 00 	movzbl 0x167(%rsp),%ebp
  709b84:	00 
  709b85:	48 c1 e5 20          	shl    $0x20,%rbp
  709b89:	48 09 c5             	or     %rax,%rbp
  709b8c:	e9 85 01 00 00       	jmp    709d16 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1c66>
  709b91:	49 8b 96 08 07 00 00 	mov    0x708(%r14),%rdx
  709b98:	48 85 d2             	test   %rdx,%rdx
  709b9b:	0f 95 c0             	setne  %al
  709b9e:	41 08 86 1f 07 00 00 	or     %al,0x71f(%r14)
  709ba5:	48 c7 44 24 08 fe ff 	movq   $0xfffffffffffffffe,0x8(%rsp)
  709bac:	ff ff 
  709bae:	31 ff                	xor    %edi,%edi
  709bb0:	48 8b 74 24 18       	mov    0x18(%rsp),%rsi
  709bb5:	48 85 f6             	test   %rsi,%rsi
  709bb8:	7e 22                	jle    709bdc <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1b2c>
  709bba:	ba 01 00 00 00       	mov    $0x1,%edx
  709bbf:	4c 89 44 24 30       	mov    %r8,0x30(%rsp)
  709bc4:	89 7c 24 18          	mov    %edi,0x18(%rsp)
  709bc8:	48 8b 7c 24 28       	mov    0x28(%rsp),%rdi
  709bcd:	ff 15 bd 83 3f 00    	call   *0x3f83bd(%rip)        # b01f90 <_DYNAMIC+0x248>
  709bd3:	8b 7c 24 18          	mov    0x18(%rsp),%edi
  709bd7:	4c 8b 44 24 30       	mov    0x30(%rsp),%r8
  709bdc:	83 7c 24 08 fe       	cmpl   $0xfffffffe,0x8(%rsp)
  709be1:	0f 84 49 fd ff ff    	je     709930 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1880>
  709be7:	48 8b 84 24 30 03 00 	mov    0x330(%rsp),%rax
  709bee:	00 
  709bef:	48 89 84 24 d0 01 00 	mov    %rax,0x1d0(%rsp)
  709bf6:	00 
  709bf7:	0f 28 84 24 20 03 00 	movaps 0x320(%rsp),%xmm0
  709bfe:	00 
  709bff:	0f 29 84 24 c0 01 00 	movaps %xmm0,0x1c0(%rsp)
  709c06:	00 
  709c07:	40 0f b6 c7          	movzbl %dil,%eax
  709c0b:	48 c1 e5 08          	shl    $0x8,%rbp
  709c0f:	48 09 c5             	or     %rax,%rbp
  709c12:	48 8b 84 24 d0 01 00 	mov    0x1d0(%rsp),%rax
  709c19:	00 
  709c1a:	48 89 84 24 20 01 00 	mov    %rax,0x120(%rsp)
  709c21:	00 
  709c22:	66 0f 6f 84 24 c0 01 	movdqa 0x1c0(%rsp),%xmm0
  709c29:	00 00 
  709c2b:	f3 0f 7f 84 24 10 01 	movdqu %xmm0,0x110(%rsp)
  709c32:	00 00 
  709c34:	48 8b 4c 24 08       	mov    0x8(%rsp),%rcx
  709c39:	48 89 8c 24 f0 00 00 	mov    %rcx,0xf0(%rsp)
  709c40:	00 
  709c41:	48 89 ac 24 f8 00 00 	mov    %rbp,0xf8(%rsp)
  709c48:	00 
  709c49:	4c 89 84 24 00 01 00 	mov    %r8,0x100(%rsp)
  709c50:	00 
  709c51:	4c 89 ac 24 08 01 00 	mov    %r13,0x108(%rsp)
  709c58:	00 
  709c59:	66 0f 7f 84 24 40 02 	movdqa %xmm0,0x240(%rsp)
  709c60:	00 00 
  709c62:	48 89 84 24 50 02 00 	mov    %rax,0x250(%rsp)
  709c69:	00 
  709c6a:	48 8b 84 24 00 01 00 	mov    0x100(%rsp),%rax
  709c71:	00 
  709c72:	48 89 84 24 30 02 00 	mov    %rax,0x230(%rsp)
  709c79:	00 
  709c7a:	48 8b 84 24 08 01 00 	mov    0x108(%rsp),%rax
  709c81:	00 
  709c82:	48 89 84 24 38 02 00 	mov    %rax,0x238(%rsp)
  709c89:	00 
  709c8a:	48 8b 84 24 f0 00 00 	mov    0xf0(%rsp),%rax
  709c91:	00 
  709c92:	48 89 84 24 20 02 00 	mov    %rax,0x220(%rsp)
  709c99:	00 
  709c9a:	48 8b 84 24 f8 00 00 	mov    0xf8(%rsp),%rax
  709ca1:	00 
  709ca2:	48 89 84 24 28 02 00 	mov    %rax,0x228(%rsp)
  709ca9:	00 
  709caa:	31 ed                	xor    %ebp,%ebp
  709cac:	e9 41 e6 ff ff       	jmp    7082f2 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x242>
  709cb1:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  709cb6:	0f b6 44 24 7f       	movzbl 0x7f(%rsp),%eax
  709cbb:	c1 e0 10             	shl    $0x10,%eax
  709cbe:	0f b7 4c 24 7d       	movzwl 0x7d(%rsp),%ecx
  709cc3:	09 c1                	or     %eax,%ecx
  709cc5:	48 c1 e1 20          	shl    $0x20,%rcx
  709cc9:	8b 6c 24 79          	mov    0x79(%rsp),%ebp
  709ccd:	48 09 cd             	or     %rcx,%rbp
  709cd0:	48 8b 84 24 80 00 00 	mov    0x80(%rsp),%rax
  709cd7:	00 
  709cd8:	48 89 44 24 30       	mov    %rax,0x30(%rsp)
  709cdd:	4c 8b ac 24 88 00 00 	mov    0x88(%rsp),%r13
  709ce4:	00 
  709ce5:	f3 0f 6f 84 24 90 00 	movdqu 0x90(%rsp),%xmm0
  709cec:	00 00 
  709cee:	66 0f 7f 84 24 20 03 	movdqa %xmm0,0x320(%rsp)
  709cf5:	00 00 
  709cf7:	48 8b 84 24 a0 00 00 	mov    0xa0(%rsp),%rax
  709cfe:	00 
  709cff:	48 89 84 24 30 03 00 	mov    %rax,0x330(%rsp)
  709d06:	00 
  709d07:	eb 17                	jmp    709d20 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1c70>
  709d09:	48 b8 ff ff ff ff ff 	movabs $0xffffffffff,%rax
  709d10:	00 00 00 
  709d13:	48 21 c5             	and    %rax,%rbp
  709d16:	b8 24 00 00 00       	mov    $0x24,%eax
  709d1b:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  709d20:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
  709d25:	48 85 c9             	test   %rcx,%rcx
  709d28:	0f 84 65 fb ff ff    	je     709893 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x17e3>
  709d2e:	f6 01 01             	testb  $0x1,(%rcx)
  709d31:	0f 85 5c fb ff ff    	jne    709893 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x17e3>
  709d37:	48 8b 41 08          	mov    0x8(%rcx),%rax
  709d3b:	a8 01                	test   $0x1,%al
  709d3d:	0f 85 50 fb ff ff    	jne    709893 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x17e3>
  709d43:	89 7c 24 18          	mov    %edi,0x18(%rsp)
  709d47:	48 8d 41 08          	lea    0x8(%rcx),%rax
  709d4b:	f0 48 83 28 02       	lock subq $0x2,(%rax)
  709d50:	0f 84 53 01 00 00    	je     709ea9 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1df9>
  709d56:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  709d5b:	8b 7c 24 18          	mov    0x18(%rsp),%edi
  709d5f:	e9 34 fb ff ff       	jmp    709898 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x17e8>
  709d64:	48 8d 3d 5d a0 3c 00 	lea    0x3ca05d(%rip),%rdi        # ad3dc8 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0x5e0>
  709d6b:	ff 15 5f 82 3f 00    	call   *0x3f825f(%rip)        # b01fd0 <_DYNAMIC+0x288>
  709d71:	48 8b 47 08          	mov    0x8(%rdi),%rax
  709d75:	ff 15 75 82 3f 00    	call   *0x3f8275(%rip)        # b01ff0 <_DYNAMIC+0x2a8>
  709d7b:	e9 c0 e6 ff ff       	jmp    708440 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x390>
  709d80:	41 bc 15 00 00 00    	mov    $0x15,%r12d
  709d86:	eb 3c                	jmp    709dc4 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1d14>
  709d88:	48 8d 05 55 f8 95 ff 	lea    -0x6a07ab(%rip),%rax        # 695e4 <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x2e24>
  709d8f:	48 89 84 24 e0 00 00 	mov    %rax,0xe0(%rsp)
  709d96:	00 
  709d97:	48 8d 05 92 a8 3c 00 	lea    0x3ca892(%rip),%rax        # ad4630 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0xe48>
  709d9e:	eb 1c                	jmp    709dbc <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1d0c>
  709da0:	41 bc 14 00 00 00    	mov    $0x14,%r12d
  709da6:	48 8d 05 23 f8 95 ff 	lea    -0x6a07dd(%rip),%rax        # 695d0 <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x2e10>
  709dad:	48 89 84 24 e0 00 00 	mov    %rax,0xe0(%rsp)
  709db4:	00 
  709db5:	48 8d 05 5c a8 3c 00 	lea    0x3ca85c(%rip),%rax        # ad4618 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0xe30>
  709dbc:	48 89 84 24 d8 00 00 	mov    %rax,0xd8(%rsp)
  709dc3:	00 
  709dc4:	48 8b bc 24 e0 00 00 	mov    0xe0(%rsp),%rdi
  709dcb:	00 
  709dcc:	4c 89 e6             	mov    %r12,%rsi
  709dcf:	48 8b 94 24 d8 00 00 	mov    0xd8(%rsp),%rdx
  709dd6:	00 
  709dd7:	ff 15 d3 82 3f 00    	call   *0x3f82d3(%rip)        # b020b0 <_DYNAMIC+0x368>
  709ddd:	e9 a7 01 00 00       	jmp    709f89 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1ed9>
  709de2:	48 8d 3d bf f7 95 ff 	lea    -0x6a0841(%rip),%rdi        # 695a8 <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x2de8>
  709de9:	48 8d 15 c8 a7 3c 00 	lea    0x3ca7c8(%rip),%rdx        # ad45b8 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0xdd0>
  709df0:	be 13 00 00 00       	mov    $0x13,%esi
  709df5:	ff 15 b5 82 3f 00    	call   *0x3f82b5(%rip)        # b020b0 <_DYNAMIC+0x368>
  709dfb:	e9 89 01 00 00       	jmp    709f89 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1ed9>
  709e00:	48 8d 3d 1e f8 95 ff 	lea    -0x6a07e2(%rip),%rdi        # 69625 <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x2e65>
  709e07:	48 8d 15 82 a8 3c 00 	lea    0x3ca882(%rip),%rdx        # ad4690 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0xea8>
  709e0e:	be 93 00 00 00       	mov    $0x93,%esi
  709e13:	ff 15 cf 81 3f 00    	call   *0x3f81cf(%rip)        # b01fe8 <_DYNAMIC+0x2a0>
  709e19:	e9 6b 01 00 00       	jmp    709f89 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1ed9>
  709e1e:	48 8d 05 ea f7 95 ff 	lea    -0x6a0816(%rip),%rax        # 6960f <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x2e4f>
  709e25:	48 89 84 24 30 01 00 	mov    %rax,0x130(%rsp)
  709e2c:	00 
  709e2d:	48 8d 05 14 a8 3c 00 	lea    0x3ca814(%rip),%rax        # ad4648 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0xe60>
  709e34:	48 89 84 24 28 01 00 	mov    %rax,0x128(%rsp)
  709e3b:	00 
  709e3c:	48 8b bc 24 30 01 00 	mov    0x130(%rsp),%rdi
  709e43:	00 
  709e44:	4c 89 ee             	mov    %r13,%rsi
  709e47:	48 8b 94 24 28 01 00 	mov    0x128(%rsp),%rdx
  709e4e:	00 
  709e4f:	ff 15 5b 82 3f 00    	call   *0x3f825b(%rip)        # b020b0 <_DYNAMIC+0x368>
  709e55:	e9 2f 01 00 00       	jmp    709f89 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1ed9>
  709e5a:	48 8d 3d 27 9c 3c 00 	lea    0x3c9c27(%rip),%rdi        # ad3a88 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0x2a0>
  709e61:	ff 15 69 81 3f 00    	call   *0x3f8169(%rip)        # b01fd0 <_DYNAMIC+0x288>
  709e67:	e9 1d 01 00 00       	jmp    709f89 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1ed9>
  709e6c:	48 c7 44 24 20 00 00 	movq   $0x0,0x20(%rsp)
  709e73:	00 00 
  709e75:	48 8d 3d e4 a7 3c 00 	lea    0x3ca7e4(%rip),%rdi        # ad4660 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0xe78>
  709e7c:	ff 15 4e 81 3f 00    	call   *0x3f814e(%rip)        # b01fd0 <_DYNAMIC+0x288>
  709e82:	e9 02 01 00 00       	jmp    709f89 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1ed9>
  709e87:	48 8d 05 ca 9b 3c 00 	lea    0x3c9bca(%rip),%rax        # ad3a58 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0x270>
  709e8e:	48 89 84 24 b8 01 00 	mov    %rax,0x1b8(%rsp)
  709e95:	00 
  709e96:	48 8b bc 24 b8 01 00 	mov    0x1b8(%rsp),%rdi
  709e9d:	00 
  709e9e:	ff 15 2c 81 3f 00    	call   *0x3f812c(%rip)        # b01fd0 <_DYNAMIC+0x288>
  709ea4:	e9 e0 00 00 00       	jmp    709f89 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1ed9>
  709ea9:	48 8b 7c 24 20       	mov    0x20(%rsp),%rdi
  709eae:	48 8b 47 08          	mov    0x8(%rdi),%rax
  709eb2:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  709eb7:	ff 15 33 81 3f 00    	call   *0x3f8133(%rip)        # b01ff0 <_DYNAMIC+0x2a8>
  709ebd:	8b 7c 24 18          	mov    0x18(%rsp),%edi
  709ec1:	e9 d2 f9 ff ff       	jmp    709898 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x17e8>
  709ec6:	48 8b 7c 24 20       	mov    0x20(%rsp),%rdi
  709ecb:	48 8b 47 08          	mov    0x8(%rdi),%rax
  709ecf:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  709ed4:	ff 15 16 81 3f 00    	call   *0x3f8116(%rip)        # b01ff0 <_DYNAMIC+0x2a8>
  709eda:	89 ef                	mov    %ebp,%edi
  709edc:	e9 e9 f9 ff ff       	jmp    7098ca <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x181a>
  709ee1:	48 8d 15 88 9b 3c 00 	lea    0x3c9b88(%rip),%rdx        # ad3a70 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0x288>
  709ee8:	ff 15 d2 81 3f 00    	call   *0x3f81d2(%rip)        # b020c0 <_DYNAMIC+0x378>
  709eee:	e9 96 00 00 00       	jmp    709f89 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1ed9>
  709ef3:	48 8d 05 16 9f 3c 00 	lea    0x3c9f16(%rip),%rax        # ad3e10 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0x628>
  709efa:	eb 47                	jmp    709f43 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1e93>
  709efc:	48 89 44 24 28       	mov    %rax,0x28(%rsp)
  709f01:	48 8d 05 20 9f 3c 00 	lea    0x3c9f20(%rip),%rax        # ad3e28 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0x640>
  709f08:	eb 39                	jmp    709f43 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1e93>
  709f0a:	48 8d 05 e7 9e 3c 00 	lea    0x3c9ee7(%rip),%rax        # ad3df8 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0x610>
  709f11:	eb 30                	jmp    709f43 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1e93>
  709f13:	48 89 44 24 28       	mov    %rax,0x28(%rsp)
  709f18:	48 8d 05 51 9b 3c 00 	lea    0x3c9b51(%rip),%rax        # ad3a70 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0x288>
  709f1f:	eb 22                	jmp    709f43 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1e93>
  709f21:	48 85 ff             	test   %rdi,%rdi
  709f24:	75 34                	jne    709f5a <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1eaa>
  709f26:	48 c7 44 24 20 00 00 	movq   $0x0,0x20(%rsp)
  709f2d:	00 00 
  709f2f:	ff 15 7b 82 3f 00    	call   *0x3f827b(%rip)        # b021b0 <_DYNAMIC+0x468>
  709f35:	eb 52                	jmp    709f89 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1ed9>
  709f37:	48 89 44 24 28       	mov    %rax,0x28(%rsp)
  709f3c:	48 8d 05 fd 9a 3c 00 	lea    0x3c9afd(%rip),%rax        # ad3a40 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0x258>
  709f43:	48 89 44 24 68       	mov    %rax,0x68(%rsp)
  709f48:	48 8b 7c 24 28       	mov    0x28(%rsp),%rdi
  709f4d:	48 8b 54 24 68       	mov    0x68(%rsp),%rdx
  709f52:	ff 15 68 81 3f 00    	call   *0x3f8168(%rip)        # b020c0 <_DYNAMIC+0x378>
  709f58:	eb 2f                	jmp    709f89 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1ed9>
  709f5a:	48 8b 74 24 78       	mov    0x78(%rsp),%rsi
  709f5f:	48 c7 44 24 20 00 00 	movq   $0x0,0x20(%rsp)
  709f66:	00 00 
  709f68:	ff 15 52 80 3f 00    	call   *0x3f8052(%rip)        # b01fc0 <_DYNAMIC+0x278>
  709f6e:	eb 19                	jmp    709f89 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1ed9>
  709f70:	48 8d 3d 44 f6 95 ff 	lea    -0x6a09bc(%rip),%rdi        # 695bb <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x2dfb>
  709f77:	48 8d 15 52 a6 3c 00 	lea    0x3ca652(%rip),%rdx        # ad45d0 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0xde8>
  709f7e:	be 15 00 00 00       	mov    $0x15,%esi
  709f83:	ff 15 27 81 3f 00    	call   *0x3f8127(%rip)        # b020b0 <_DYNAMIC+0x368>
  709f89:	0f 0b                	ud2
  709f8b:	49 89 c5             	mov    %rax,%r13
  709f8e:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  709f93:	48 89 45 10          	mov    %rax,0x10(%rbp)
  709f97:	eb 6d                	jmp    70a006 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1f56>
  709f99:	49 89 c5             	mov    %rax,%r13
  709f9c:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  709fa1:	48 89 45 08          	mov    %rax,0x8(%rbp)
  709fa5:	eb 5f                	jmp    70a006 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1f56>
  709fa7:	49 89 c5             	mov    %rax,%r13
  709faa:	4c 89 65 40          	mov    %r12,0x40(%rbp)
  709fae:	eb 56                	jmp    70a006 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1f56>
  709fb0:	48 89 c3             	mov    %rax,%rbx
  709fb3:	48 8d bc 24 f0 00 00 	lea    0xf0(%rsp),%rdi
  709fba:	00 
  709fbb:	e8 10 a7 ff ff       	call   7046d0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  709fc0:	48 89 df             	mov    %rbx,%rdi
  709fc3:	e8 e8 83 3c 00       	call   ad23b0 <_Unwind_Resume@plt>
  709fc8:	eb 18                	jmp    709fe2 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1f32>
  709fca:	eb 16                	jmp    709fe2 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1f32>
  709fcc:	eb 00                	jmp    709fce <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1f1e>
  709fce:	49 89 c5             	mov    %rax,%r13
  709fd1:	48 c7 45 00 ff ff ff 	movq   $0xffffffffffffffff,0x0(%rbp)
  709fd8:	ff 
  709fd9:	eb 2b                	jmp    70a006 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1f56>
  709fdb:	49 89 c5             	mov    %rax,%r13
  709fde:	eb 4d                	jmp    70a02d <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1f7d>
  709fe0:	eb 21                	jmp    70a003 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1f53>
  709fe2:	49 89 c5             	mov    %rax,%r13
  709fe5:	eb 29                	jmp    70a010 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1f60>
  709fe7:	49 89 c5             	mov    %rax,%r13
  709fea:	48 83 7c 24 18 00    	cmpq   $0x0,0x18(%rsp)
  709ff0:	7e 3b                	jle    70a02d <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1f7d>
  709ff2:	ba 01 00 00 00       	mov    $0x1,%edx
  709ff7:	48 8b 7c 24 28       	mov    0x28(%rsp),%rdi
  709ffc:	48 8b 74 24 18       	mov    0x18(%rsp),%rsi
  70a001:	eb 24                	jmp    70a027 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1f77>
  70a003:	49 89 c5             	mov    %rax,%r13
  70a006:	48 8b 7c 24 20       	mov    0x20(%rsp),%rdi
  70a00b:	e8 50 77 ff ff       	call   701760 <core::ptr::drop_glue::<core::option::Option<gpui::shared_text::SharedText>>>
  70a010:	48 83 7c 24 60 00    	cmpq   $0x0,0x60(%rsp)
  70a016:	7e 15                	jle    70a02d <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1f7d>
  70a018:	ba 01 00 00 00       	mov    $0x1,%edx
  70a01d:	48 8b 7c 24 50       	mov    0x50(%rsp),%rdi
  70a022:	48 8b 74 24 60       	mov    0x60(%rsp),%rsi
  70a027:	ff 15 63 7f 3f 00    	call   *0x3f7f63(%rip)        # b01f90 <_DYNAMIC+0x248>
  70a02d:	4c 89 ef             	mov    %r13,%rdi
  70a030:	ff 15 9a 80 3f 00    	call   *0x3f809a(%rip)        # b020d0 <_DYNAMIC+0x388>
  70a036:	49 89 c5             	mov    %rax,%r13
  70a039:	48 89 d5             	mov    %rdx,%rbp
  70a03c:	48 89 84 24 f8 00 00 	mov    %rax,0xf8(%rsp)
  70a043:	00 
  70a044:	48 89 94 24 00 01 00 	mov    %rdx,0x100(%rsp)
  70a04b:	00 
  70a04c:	48 c7 84 24 f0 00 00 	movq   $0xfffffffffffffffd,0xf0(%rsp)
  70a053:	00 fd ff ff ff 
  70a058:	4c 89 f7             	mov    %r14,%rdi
  70a05b:	e8 40 43 01 00       	call   71e3a0 <<gpui::runtime::Runtime<unit_action_cost::Model>>::poison>
  70a060:	48 c7 84 24 20 02 00 	movq   $0xf,0x220(%rsp)
  70a067:	00 0f 00 00 00 
  70a06c:	48 8b 45 00          	mov    0x0(%rbp),%rax
  70a070:	48 85 c0             	test   %rax,%rax
  70a073:	74 05                	je     70a07a <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1fca>
  70a075:	4c 89 ef             	mov    %r13,%rdi
  70a078:	ff d0                	call   *%rax
  70a07a:	48 8b 75 08          	mov    0x8(%rbp),%rsi
  70a07e:	48 85 f6             	test   %rsi,%rsi
  70a081:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  70a086:	74 0d                	je     70a095 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x1fe5>
  70a088:	48 8b 55 10          	mov    0x10(%rbp),%rdx
  70a08c:	4c 89 ef             	mov    %r13,%rdi
  70a08f:	ff 15 fb 7e 3f 00    	call   *0x3f7efb(%rip)        # b01f90 <_DYNAMIC+0x248>
  70a095:	31 ed                	xor    %ebp,%ebp
  70a097:	e9 56 e2 ff ff       	jmp    7082f2 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x242>
  70a09c:	48 89 c3             	mov    %rax,%rbx
  70a09f:	48 8b 75 08          	mov    0x8(%rbp),%rsi
  70a0a3:	48 85 f6             	test   %rsi,%rsi
  70a0a6:	74 2b                	je     70a0d3 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing+0x2023>
  70a0a8:	48 8b 55 10          	mov    0x10(%rbp),%rdx
  70a0ac:	4c 89 ef             	mov    %r13,%rdi
  70a0af:	ff 15 db 7e 3f 00    	call   *0x3f7edb(%rip)        # b01f90 <_DYNAMIC+0x248>
  70a0b5:	48 89 df             	mov    %rbx,%rdi
  70a0b8:	e8 f3 82 3c 00       	call   ad23b0 <_Unwind_Resume@plt>
  70a0bd:	ff 15 1d 7f 3f 00    	call   *0x3f7f1d(%rip)        # b01fe0 <_DYNAMIC+0x298>
  70a0c3:	48 89 c3             	mov    %rax,%rbx
  70a0c6:	48 8d bc 24 f0 00 00 	lea    0xf0(%rsp),%rdi
  70a0cd:	00 
  70a0ce:	e8 5d 7b ff ff       	call   701c30 <core::ptr::drop_glue::<core::result::Result<core::result::Result<gpui::runtime::paint::PatchOutcome, gpui::runtime::Error>, alloc::boxed::Box<dyn core::any::Any + core::marker::Send>>>>
  70a0d3:	48 89 df             	mov    %rbx,%rdi
  70a0d6:	e8 d5 82 3c 00       	call   ad23b0 <_Unwind_Resume@plt>
  70a0db:	ff 15 ff 7e 3f 00    	call   *0x3f7eff(%rip)        # b01fe0 <_DYNAMIC+0x298>
  70a0e1:	ff 15 f1 7f 3f 00    	call   *0x3f7ff1(%rip)        # b020d8 <_DYNAMIC+0x390>
