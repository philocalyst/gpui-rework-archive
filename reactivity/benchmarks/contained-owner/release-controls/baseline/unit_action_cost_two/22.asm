
/tmp/gpui-contained-owner-unit-baseline-target/release/deps/unit_action_cost_two-c899ee77dd9a9ab3:     file format elf64-x86-64


Disassembly of section .text:

000000000070a200 <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click>:
  70a200:	55                   	push   %rbp
  70a201:	41 57                	push   %r15
  70a203:	41 56                	push   %r14
  70a205:	41 55                	push   %r13
  70a207:	41 54                	push   %r12
  70a209:	53                   	push   %rbx
  70a20a:	48 81 ec b8 00 00 00 	sub    $0xb8,%rsp
  70a211:	48 8b 1e             	mov    (%rsi),%rbx
  70a214:	48 85 db             	test   %rbx,%rbx
  70a217:	74 15                	je     70a22e <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click+0x2e>
  70a219:	80 bb 22 08 00 00 01 	cmpb   $0x1,0x822(%rbx)
  70a220:	75 20                	jne    70a242 <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click+0x42>
  70a222:	48 c7 07 0e 00 00 00 	movq   $0xe,(%rdi)
  70a229:	e9 03 03 00 00       	jmp    70a531 <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click+0x331>
  70a22e:	48 c7 07 0d 00 00 00 	movq   $0xd,(%rdi)
  70a235:	48 c7 47 08 00 00 00 	movq   $0x0,0x8(%rdi)
  70a23c:	00 
  70a23d:	e9 ef 02 00 00       	jmp    70a531 <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click+0x331>
  70a242:	48 3b 93 b0 05 00 00 	cmp    0x5b0(%rbx),%rdx
  70a249:	0f 85 7e 02 00 00    	jne    70a4cd <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click+0x2cd>
  70a24f:	49 89 f4             	mov    %rsi,%r12
  70a252:	49 89 d6             	mov    %rdx,%r14
  70a255:	48 89 fd             	mov    %rdi,%rbp
  70a258:	48 8d 7c 24 08       	lea    0x8(%rsp),%rdi
  70a25d:	48 89 de             	mov    %rbx,%rsi
  70a260:	49 89 cf             	mov    %rcx,%r15
  70a263:	48 89 ca             	mov    %rcx,%rdx
  70a266:	e8 45 ee 00 00       	call   7190b0 <<gpui::runtime::Runtime<unit_action_cost_two::SecondModel>>::resolve_identity>
  70a26b:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  70a270:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  70a274:	0f 85 5a 02 00 00    	jne    70a4d4 <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click+0x2d4>
  70a27a:	80 bb 1e 08 00 00 01 	cmpb   $0x1,0x81e(%rbx)
  70a281:	48 89 ef             	mov    %rbp,%rdi
  70a284:	0f 85 a0 02 00 00    	jne    70a52a <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click+0x32a>
  70a28a:	80 bb 1f 08 00 00 00 	cmpb   $0x0,0x81f(%rbx)
  70a291:	0f 85 93 02 00 00    	jne    70a52a <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click+0x32a>
  70a297:	80 bb 20 08 00 00 00 	cmpb   $0x0,0x820(%rbx)
  70a29e:	0f 84 86 02 00 00    	je     70a52a <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click+0x32a>
  70a2a4:	48 83 bb 88 05 00 00 	cmpq   $0xffffffffffffffff,0x588(%rbx)
  70a2ab:	ff 
  70a2ac:	0f 85 78 02 00 00    	jne    70a52a <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click+0x32a>
  70a2b2:	48 8b 83 60 06 00 00 	mov    0x660(%rbx),%rax
  70a2b9:	48 3b 83 68 06 00 00 	cmp    0x668(%rbx),%rax
  70a2c0:	0f 85 64 02 00 00    	jne    70a52a <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click+0x32a>
  70a2c6:	48 8b 83 78 06 00 00 	mov    0x678(%rbx),%rax
  70a2cd:	48 3b 83 70 06 00 00 	cmp    0x670(%rbx),%rax
  70a2d4:	0f 85 50 02 00 00    	jne    70a52a <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click+0x32a>
  70a2da:	f3 0f 10 83 14 08 00 	movss  0x814(%rbx),%xmm0
  70a2e1:	00 
  70a2e2:	0f 2e 83 18 08 00 00 	ucomiss 0x818(%rbx),%xmm0
  70a2e9:	0f 85 3b 02 00 00    	jne    70a52a <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click+0x32a>
  70a2ef:	0f 8a 35 02 00 00    	jp     70a52a <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click+0x32a>
  70a2f5:	4c 89 e0             	mov    %r12,%rax
  70a2f8:	48 83 c0 08          	add    $0x8,%rax
  70a2fc:	4c 8b ab 78 05 00 00 	mov    0x578(%rbx),%r13
  70a303:	48 8b 8b 80 05 00 00 	mov    0x580(%rbx),%rcx
  70a30a:	48 c1 e1 04          	shl    $0x4,%rcx
  70a30e:	48 8d 0c 89          	lea    (%rcx,%rcx,4),%rcx
  70a312:	45 31 e4             	xor    %r12d,%r12d
  70a315:	4c 89 ee             	mov    %r13,%rsi
  70a318:	4c 89 fa             	mov    %r15,%rdx
  70a31b:	4c 39 e1             	cmp    %r12,%rcx
  70a31e:	0f 84 22 02 00 00    	je     70a546 <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click+0x346>
  70a324:	49 83 c4 50          	add    $0x50,%r12
  70a328:	48 39 56 20          	cmp    %rdx,0x20(%rsi)
  70a32c:	48 8d 76 50          	lea    0x50(%rsi),%rsi
  70a330:	75 e9                	jne    70a31b <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click+0x11b>
  70a332:	48 89 44 24 58       	mov    %rax,0x58(%rsp)
  70a337:	48 c7 44 24 08 11 00 	movq   $0x11,0x8(%rsp)
  70a33e:	00 00 
  70a340:	48 8d 7c 24 08       	lea    0x8(%rsp),%rdi
  70a345:	e8 36 d7 fe ff       	call   6f7a80 <core::ptr::drop_glue::<gpui::runtime::Error>>
  70a34a:	f3 43 0f 10 44 25 e0 	movss  -0x20(%r13,%r12,1),%xmm0
  70a351:	0f 2e c0             	ucomiss %xmm0,%xmm0
  70a354:	7a 62                	jp     70a3b8 <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click+0x1b8>
  70a356:	43 8b 44 25 f4       	mov    -0xc(%r13,%r12,1),%eax
  70a35b:	89 44 24 1c          	mov    %eax,0x1c(%rsp)
  70a35f:	43 0f 10 4c 25 e4    	movups -0x1c(%r13,%r12,1),%xmm1
  70a365:	0f 11 4c 24 0c       	movups %xmm1,0xc(%rsp)
  70a36a:	f3 0f 11 44 24 08    	movss  %xmm0,0x8(%rsp)
  70a370:	f3 43 0f 10 44 25 b8 	movss  -0x48(%r13,%r12,1),%xmm0
  70a377:	f3 43 0f 10 4c 25 bc 	movss  -0x44(%r13,%r12,1),%xmm1
  70a37e:	48 8d 7c 24 64       	lea    0x64(%rsp),%rdi
  70a383:	48 8d 74 24 08       	lea    0x8(%rsp),%rsi
  70a388:	e8 03 fa fe ff       	call   6f9d90 <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click::{closure#1}>
  70a38d:	83 7c 24 64 01       	cmpl   $0x1,0x64(%rsp)
  70a392:	75 24                	jne    70a3b8 <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click+0x1b8>
  70a394:	f2 0f 10 44 24 68    	movsd  0x68(%rsp),%xmm0
  70a39a:	0f 28 c8             	movaps %xmm0,%xmm1
  70a39d:	0f c6 c8 55          	shufps $0x55,%xmm0,%xmm1
  70a3a1:	4b 8d 3c 2c          	lea    (%r12,%r13,1),%rdi
  70a3a5:	48 83 c7 c0          	add    $0xffffffffffffffc0,%rdi
  70a3a9:	0f 29 44 24 40       	movaps %xmm0,0x40(%rsp)
  70a3ae:	ff 15 34 de 41 00    	call   *0x41de34(%rip)        # b281e8 <_DYNAMIC+0x530>
  70a3b4:	84 c0                	test   %al,%al
  70a3b6:	75 40                	jne    70a3f8 <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click+0x1f8>
  70a3b8:	f3 43 0f 10 44 25 c8 	movss  -0x38(%r13,%r12,1),%xmm0
  70a3bf:	0f 57 d2             	xorps  %xmm2,%xmm2
  70a3c2:	0f 2e c2             	ucomiss %xmm2,%xmm0
  70a3c5:	75 06                	jne    70a3cd <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click+0x1cd>
  70a3c7:	0f 8b 82 01 00 00    	jnp    70a54f <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click+0x34f>
  70a3cd:	f3 43 0f 10 4c 25 cc 	movss  -0x34(%r13,%r12,1),%xmm1
  70a3d4:	0f 2e ca             	ucomiss %xmm2,%xmm1
  70a3d7:	75 06                	jne    70a3df <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click+0x1df>
  70a3d9:	0f 8b 70 01 00 00    	jnp    70a54f <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click+0x34f>
  70a3df:	0f 14 c1             	unpcklps %xmm1,%xmm0
  70a3e2:	0f 59 05 a7 09 95 ff 	mulps  -0x6af659(%rip),%xmm0        # 5ad90 <anon.079f5e587c394fcac2765eb4d0cf0bc2.397.llvm.6319143315422321905+0x1120>
  70a3e9:	f2 43 0f 10 4c 25 c0 	movsd  -0x40(%r13,%r12,1),%xmm1
  70a3f0:	0f 58 c8             	addps  %xmm0,%xmm1
  70a3f3:	0f 29 4c 24 40       	movaps %xmm1,0x40(%rsp)
  70a3f8:	48 c7 44 24 08 19 00 	movq   $0x19,0x8(%rsp)
  70a3ff:	00 00 
  70a401:	48 8d 7c 24 08       	lea    0x8(%rsp),%rdi
  70a406:	e8 75 d6 fe ff       	call   6f7a80 <core::ptr::drop_glue::<gpui::runtime::Error>>
  70a40b:	0f 28 44 24 40       	movaps 0x40(%rsp),%xmm0
  70a410:	0f 28 c8             	movaps %xmm0,%xmm1
  70a413:	0f c6 c8 55          	shufps $0x55,%xmm0,%xmm1
  70a417:	48 89 df             	mov    %rbx,%rdi
  70a41a:	0f 29 8c 24 a0 00 00 	movaps %xmm1,0xa0(%rsp)
  70a421:	00 
  70a422:	e8 49 ef 00 00       	call   719370 <<gpui::runtime::Runtime<unit_action_cost_two::SecondModel>>::hit>
  70a427:	48 c7 44 24 08 19 00 	movq   $0x19,0x8(%rsp)
  70a42e:	00 00 
  70a430:	a8 01                	test   $0x1,%al
  70a432:	0f 84 17 01 00 00    	je     70a54f <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click+0x34f>
  70a438:	49 89 d5             	mov    %rdx,%r13
  70a43b:	48 8d 7c 24 08       	lea    0x8(%rsp),%rdi
  70a440:	e8 3b d6 fe ff       	call   6f7a80 <core::ptr::drop_glue::<gpui::runtime::Error>>
  70a445:	4d 39 fd             	cmp    %r15,%r13
  70a448:	0f 85 01 01 00 00    	jne    70a54f <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click+0x34f>
  70a44e:	4c 3b b3 b0 05 00 00 	cmp    0x5b0(%rbx),%r14
  70a455:	0f 85 01 01 00 00    	jne    70a55c <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click+0x35c>
  70a45b:	4c 89 fa             	mov    %r15,%rdx
  70a45e:	48 8d 7c 24 08       	lea    0x8(%rsp),%rdi
  70a463:	48 89 de             	mov    %rbx,%rsi
  70a466:	e8 45 ec 00 00       	call   7190b0 <<gpui::runtime::Runtime<unit_action_cost_two::SecondModel>>::resolve_identity>
  70a46b:	48 8b 4c 24 08       	mov    0x8(%rsp),%rcx
  70a470:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  70a475:	48 83 f9 fe          	cmp    $0xfffffffffffffffe,%rcx
  70a479:	0f 85 e2 00 00 00    	jne    70a561 <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click+0x361>
  70a47f:	48 8b b3 a0 02 00 00 	mov    0x2a0(%rbx),%rsi
  70a486:	48 39 f0             	cmp    %rsi,%rax
  70a489:	0f 83 88 01 00 00    	jae    70a617 <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click+0x417>
  70a48f:	48 8b 8b 98 02 00 00 	mov    0x298(%rbx),%rcx
  70a496:	48 8d 04 80          	lea    (%rax,%rax,4),%rax
  70a49a:	8b 44 c1 20          	mov    0x20(%rcx,%rax,8),%eax
  70a49e:	83 e0 07             	and    $0x7,%eax
  70a4a1:	83 f8 02             	cmp    $0x2,%eax
  70a4a4:	0f 85 df 00 00 00    	jne    70a589 <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click+0x389>
  70a4aa:	48 89 ef             	mov    %rbp,%rdi
  70a4ad:	48 89 de             	mov    %rbx,%rsi
  70a4b0:	4c 89 f2             	mov    %r14,%rdx
  70a4b3:	4c 89 f9             	mov    %r15,%rcx
  70a4b6:	0f 28 44 24 40       	movaps 0x40(%rsp),%xmm0
  70a4bb:	0f 28 8c 24 a0 00 00 	movaps 0xa0(%rsp),%xmm1
  70a4c2:	00 
  70a4c3:	e8 48 95 ff ff       	call   703a10 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_pointer>
  70a4c8:	e9 05 01 00 00       	jmp    70a5d2 <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click+0x3d2>
  70a4cd:	b8 11 00 00 00       	mov    $0x11,%eax
  70a4d2:	eb 2c                	jmp    70a500 <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click+0x300>
  70a4d4:	48 8b 4c 24 10       	mov    0x10(%rsp),%rcx
  70a4d9:	0f 10 44 24 18       	movups 0x18(%rsp),%xmm0
  70a4de:	0f 29 44 24 70       	movaps %xmm0,0x70(%rsp)
  70a4e3:	0f 10 44 24 28       	movups 0x28(%rsp),%xmm0
  70a4e8:	0f 29 84 24 80 00 00 	movaps %xmm0,0x80(%rsp)
  70a4ef:	00 
  70a4f0:	48 8b 54 24 38       	mov    0x38(%rsp),%rdx
  70a4f5:	48 89 94 24 90 00 00 	mov    %rdx,0x90(%rsp)
  70a4fc:	00 
  70a4fd:	48 89 ef             	mov    %rbp,%rdi
  70a500:	48 89 07             	mov    %rax,(%rdi)
  70a503:	48 89 4f 08          	mov    %rcx,0x8(%rdi)
  70a507:	0f 28 44 24 70       	movaps 0x70(%rsp),%xmm0
  70a50c:	0f 28 8c 24 80 00 00 	movaps 0x80(%rsp),%xmm1
  70a513:	00 
  70a514:	0f 11 47 10          	movups %xmm0,0x10(%rdi)
  70a518:	0f 11 4f 20          	movups %xmm1,0x20(%rdi)
  70a51c:	48 8b 84 24 90 00 00 	mov    0x90(%rsp),%rax
  70a523:	00 
  70a524:	48 89 47 30          	mov    %rax,0x30(%rdi)
  70a528:	eb 07                	jmp    70a531 <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click+0x331>
  70a52a:	48 c7 07 12 00 00 00 	movq   $0x12,(%rdi)
  70a531:	48 89 f8             	mov    %rdi,%rax
  70a534:	48 81 c4 b8 00 00 00 	add    $0xb8,%rsp
  70a53b:	5b                   	pop    %rbx
  70a53c:	41 5c                	pop    %r12
  70a53e:	41 5d                	pop    %r13
  70a540:	41 5e                	pop    %r14
  70a542:	41 5f                	pop    %r15
  70a544:	5d                   	pop    %rbp
  70a545:	c3                   	ret
  70a546:	48 c7 07 11 00 00 00 	movq   $0x11,(%rdi)
  70a54d:	eb e2                	jmp    70a531 <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click+0x331>
  70a54f:	48 c7 45 00 19 00 00 	movq   $0x19,0x0(%rbp)
  70a556:	00 
  70a557:	48 89 e8             	mov    %rbp,%rax
  70a55a:	eb d8                	jmp    70a534 <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click+0x334>
  70a55c:	b9 11 00 00 00       	mov    $0x11,%ecx
  70a561:	48 8b 54 24 38       	mov    0x38(%rsp),%rdx
  70a566:	48 89 55 30          	mov    %rdx,0x30(%rbp)
  70a56a:	0f 10 44 24 18       	movups 0x18(%rsp),%xmm0
  70a56f:	0f 10 4c 24 28       	movups 0x28(%rsp),%xmm1
  70a574:	0f 11 4d 20          	movups %xmm1,0x20(%rbp)
  70a578:	0f 11 45 10          	movups %xmm0,0x10(%rbp)
  70a57c:	48 89 4d 00          	mov    %rcx,0x0(%rbp)
  70a580:	48 89 45 08          	mov    %rax,0x8(%rbp)
  70a584:	48 89 e8             	mov    %rbp,%rax
  70a587:	eb ab                	jmp    70a534 <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click+0x334>
  70a589:	4c 8b ab e8 05 00 00 	mov    0x5e8(%rbx),%r13
  70a590:	4c 8b a3 f0 05 00 00 	mov    0x5f0(%rbx),%r12
  70a597:	48 8d 7c 24 08       	lea    0x8(%rsp),%rdi
  70a59c:	48 89 de             	mov    %rbx,%rsi
  70a59f:	4c 89 f2             	mov    %r14,%rdx
  70a5a2:	4c 89 f9             	mov    %r15,%rcx
  70a5a5:	e8 46 57 ff ff       	call   6ffcf0 <<gpui::runtime::Runtime<unit_action_cost_two::SecondModel>>::focus>
  70a5aa:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  70a5af:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  70a5b3:	75 25                	jne    70a5da <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click+0x3da>
  70a5b5:	4c 89 24 24          	mov    %r12,(%rsp)
  70a5b9:	48 89 ef             	mov    %rbp,%rdi
  70a5bc:	48 89 de             	mov    %rbx,%rsi
  70a5bf:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  70a5c4:	4c 89 f1             	mov    %r14,%rcx
  70a5c7:	4d 89 f8             	mov    %r15,%r8
  70a5ca:	4d 89 e9             	mov    %r13,%r9
  70a5cd:	e8 7e 00 ff ff       	call   6fa650 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::activate_focused>
  70a5d2:	48 89 e8             	mov    %rbp,%rax
  70a5d5:	e9 5a ff ff ff       	jmp    70a534 <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click+0x334>
  70a5da:	48 8b 4c 24 30       	mov    0x30(%rsp),%rcx
  70a5df:	0f b6 54 24 38       	movzbl 0x38(%rsp),%edx
  70a5e4:	8b 74 24 3c          	mov    0x3c(%rsp),%esi
  70a5e8:	89 75 34             	mov    %esi,0x34(%rbp)
  70a5eb:	8b 74 24 39          	mov    0x39(%rsp),%esi
  70a5ef:	89 75 31             	mov    %esi,0x31(%rbp)
  70a5f2:	0f 10 44 24 10       	movups 0x10(%rsp),%xmm0
  70a5f7:	0f 10 4c 24 20       	movups 0x20(%rsp),%xmm1
  70a5fc:	48 89 45 00          	mov    %rax,0x0(%rbp)
  70a600:	0f 11 45 08          	movups %xmm0,0x8(%rbp)
  70a604:	0f 11 4d 18          	movups %xmm1,0x18(%rbp)
  70a608:	48 89 4d 28          	mov    %rcx,0x28(%rbp)
  70a60c:	88 55 30             	mov    %dl,0x30(%rbp)
  70a60f:	48 89 e8             	mov    %rbp,%rax
  70a612:	e9 1d ff ff ff       	jmp    70a534 <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click+0x334>
  70a617:	48 8d 15 0a f8 3e 00 	lea    0x3ef80a(%rip),%rdx        # af9e28 <__frame_dummy_init_array_entry+0x900>
  70a61e:	48 89 c7             	mov    %rax,%rdi
  70a621:	ff 15 e9 d9 41 00    	call   *0x41d9e9(%rip)        # b28010 <_DYNAMIC+0x358>
