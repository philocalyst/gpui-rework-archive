
/tmp/gpui-contained-owner-unit-baseline-target/release/deps/unit_action_cost-bcf457ce7db1ee75:     file format elf64-x86-64


Disassembly of section .text:

000000000070f220 <<gpui::runtime::Win<unit_action_cost::Model>>::click>:
  70f220:	55                   	push   %rbp
  70f221:	41 57                	push   %r15
  70f223:	41 56                	push   %r14
  70f225:	41 55                	push   %r13
  70f227:	41 54                	push   %r12
  70f229:	53                   	push   %rbx
  70f22a:	48 81 ec b8 00 00 00 	sub    $0xb8,%rsp
  70f231:	48 8b 1e             	mov    (%rsi),%rbx
  70f234:	48 85 db             	test   %rbx,%rbx
  70f237:	74 15                	je     70f24e <<gpui::runtime::Win<unit_action_cost::Model>>::click+0x2e>
  70f239:	80 bb 22 07 00 00 01 	cmpb   $0x1,0x722(%rbx)
  70f240:	75 20                	jne    70f262 <<gpui::runtime::Win<unit_action_cost::Model>>::click+0x42>
  70f242:	48 c7 07 0e 00 00 00 	movq   $0xe,(%rdi)
  70f249:	e9 03 03 00 00       	jmp    70f551 <<gpui::runtime::Win<unit_action_cost::Model>>::click+0x331>
  70f24e:	48 c7 07 0d 00 00 00 	movq   $0xd,(%rdi)
  70f255:	48 c7 47 08 00 00 00 	movq   $0x0,0x8(%rdi)
  70f25c:	00 
  70f25d:	e9 ef 02 00 00       	jmp    70f551 <<gpui::runtime::Win<unit_action_cost::Model>>::click+0x331>
  70f262:	48 3b 93 b0 05 00 00 	cmp    0x5b0(%rbx),%rdx
  70f269:	0f 85 7e 02 00 00    	jne    70f4ed <<gpui::runtime::Win<unit_action_cost::Model>>::click+0x2cd>
  70f26f:	49 89 f4             	mov    %rsi,%r12
  70f272:	49 89 d6             	mov    %rdx,%r14
  70f275:	48 89 fd             	mov    %rdi,%rbp
  70f278:	48 8d 7c 24 08       	lea    0x8(%rsp),%rdi
  70f27d:	48 89 de             	mov    %rbx,%rsi
  70f280:	49 89 cf             	mov    %rcx,%r15
  70f283:	48 89 ca             	mov    %rcx,%rdx
  70f286:	e8 f5 df 00 00       	call   71d280 <<gpui::runtime::Runtime<unit_action_cost::Model>>::resolve_identity>
  70f28b:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  70f290:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  70f294:	0f 85 5a 02 00 00    	jne    70f4f4 <<gpui::runtime::Win<unit_action_cost::Model>>::click+0x2d4>
  70f29a:	80 bb 1e 07 00 00 01 	cmpb   $0x1,0x71e(%rbx)
  70f2a1:	48 89 ef             	mov    %rbp,%rdi
  70f2a4:	0f 85 a0 02 00 00    	jne    70f54a <<gpui::runtime::Win<unit_action_cost::Model>>::click+0x32a>
  70f2aa:	80 bb 1f 07 00 00 00 	cmpb   $0x0,0x71f(%rbx)
  70f2b1:	0f 85 93 02 00 00    	jne    70f54a <<gpui::runtime::Win<unit_action_cost::Model>>::click+0x32a>
  70f2b7:	80 bb 20 07 00 00 00 	cmpb   $0x0,0x720(%rbx)
  70f2be:	0f 84 86 02 00 00    	je     70f54a <<gpui::runtime::Win<unit_action_cost::Model>>::click+0x32a>
  70f2c4:	48 83 bb 88 05 00 00 	cmpq   $0xffffffffffffffff,0x588(%rbx)
  70f2cb:	ff 
  70f2cc:	0f 85 78 02 00 00    	jne    70f54a <<gpui::runtime::Win<unit_action_cost::Model>>::click+0x32a>
  70f2d2:	48 8b 83 60 06 00 00 	mov    0x660(%rbx),%rax
  70f2d9:	48 3b 83 68 06 00 00 	cmp    0x668(%rbx),%rax
  70f2e0:	0f 85 64 02 00 00    	jne    70f54a <<gpui::runtime::Win<unit_action_cost::Model>>::click+0x32a>
  70f2e6:	48 8b 83 78 06 00 00 	mov    0x678(%rbx),%rax
  70f2ed:	48 3b 83 70 06 00 00 	cmp    0x670(%rbx),%rax
  70f2f4:	0f 85 50 02 00 00    	jne    70f54a <<gpui::runtime::Win<unit_action_cost::Model>>::click+0x32a>
  70f2fa:	f3 0f 10 83 14 07 00 	movss  0x714(%rbx),%xmm0
  70f301:	00 
  70f302:	0f 2e 83 18 07 00 00 	ucomiss 0x718(%rbx),%xmm0
  70f309:	0f 85 3b 02 00 00    	jne    70f54a <<gpui::runtime::Win<unit_action_cost::Model>>::click+0x32a>
  70f30f:	0f 8a 35 02 00 00    	jp     70f54a <<gpui::runtime::Win<unit_action_cost::Model>>::click+0x32a>
  70f315:	4c 89 e0             	mov    %r12,%rax
  70f318:	48 83 c0 08          	add    $0x8,%rax
  70f31c:	4c 8b ab 78 05 00 00 	mov    0x578(%rbx),%r13
  70f323:	48 8b 8b 80 05 00 00 	mov    0x580(%rbx),%rcx
  70f32a:	48 c1 e1 04          	shl    $0x4,%rcx
  70f32e:	48 8d 0c 89          	lea    (%rcx,%rcx,4),%rcx
  70f332:	45 31 e4             	xor    %r12d,%r12d
  70f335:	4c 89 ee             	mov    %r13,%rsi
  70f338:	4c 89 fa             	mov    %r15,%rdx
  70f33b:	4c 39 e1             	cmp    %r12,%rcx
  70f33e:	0f 84 22 02 00 00    	je     70f566 <<gpui::runtime::Win<unit_action_cost::Model>>::click+0x346>
  70f344:	49 83 c4 50          	add    $0x50,%r12
  70f348:	48 39 56 20          	cmp    %rdx,0x20(%rsi)
  70f34c:	48 8d 76 50          	lea    0x50(%rsi),%rsi
  70f350:	75 e9                	jne    70f33b <<gpui::runtime::Win<unit_action_cost::Model>>::click+0x11b>
  70f352:	48 89 44 24 58       	mov    %rax,0x58(%rsp)
  70f357:	48 c7 44 24 08 11 00 	movq   $0x11,0x8(%rsp)
  70f35e:	00 00 
  70f360:	48 8d 7c 24 08       	lea    0x8(%rsp),%rdi
  70f365:	e8 06 50 ff ff       	call   704370 <core::ptr::drop_glue::<gpui::runtime::Error>>
  70f36a:	f3 43 0f 10 44 25 e0 	movss  -0x20(%r13,%r12,1),%xmm0
  70f371:	0f 2e c0             	ucomiss %xmm0,%xmm0
  70f374:	7a 62                	jp     70f3d8 <<gpui::runtime::Win<unit_action_cost::Model>>::click+0x1b8>
  70f376:	43 8b 44 25 f4       	mov    -0xc(%r13,%r12,1),%eax
  70f37b:	89 44 24 1c          	mov    %eax,0x1c(%rsp)
  70f37f:	43 0f 10 4c 25 e4    	movups -0x1c(%r13,%r12,1),%xmm1
  70f385:	0f 11 4c 24 0c       	movups %xmm1,0xc(%rsp)
  70f38a:	f3 0f 11 44 24 08    	movss  %xmm0,0x8(%rsp)
  70f390:	f3 43 0f 10 44 25 b8 	movss  -0x48(%r13,%r12,1),%xmm0
  70f397:	f3 43 0f 10 4c 25 bc 	movss  -0x44(%r13,%r12,1),%xmm1
  70f39e:	48 8d 7c 24 64       	lea    0x64(%rsp),%rdi
  70f3a3:	48 8d 74 24 08       	lea    0x8(%rsp),%rsi
  70f3a8:	e8 d3 72 ff ff       	call   706680 <<gpui::runtime::Win<unit_action_cost::Model>>::click::{closure#1}>
  70f3ad:	83 7c 24 64 01       	cmpl   $0x1,0x64(%rsp)
  70f3b2:	75 24                	jne    70f3d8 <<gpui::runtime::Win<unit_action_cost::Model>>::click+0x1b8>
  70f3b4:	f2 0f 10 44 24 68    	movsd  0x68(%rsp),%xmm0
  70f3ba:	0f 28 c8             	movaps %xmm0,%xmm1
  70f3bd:	0f c6 c8 55          	shufps $0x55,%xmm0,%xmm1
  70f3c1:	4b 8d 3c 2c          	lea    (%r12,%r13,1),%rdi
  70f3c5:	48 83 c7 c0          	add    $0xffffffffffffffc0,%rdi
  70f3c9:	0f 29 44 24 40       	movaps %xmm0,0x40(%rsp)
  70f3ce:	ff 15 5c 22 3f 00    	call   *0x3f225c(%rip)        # b01630 <_DYNAMIC+0x540>
  70f3d4:	84 c0                	test   %al,%al
  70f3d6:	75 40                	jne    70f418 <<gpui::runtime::Win<unit_action_cost::Model>>::click+0x1f8>
  70f3d8:	f3 43 0f 10 44 25 c8 	movss  -0x38(%r13,%r12,1),%xmm0
  70f3df:	0f 57 d2             	xorps  %xmm2,%xmm2
  70f3e2:	0f 2e c2             	ucomiss %xmm2,%xmm0
  70f3e5:	75 06                	jne    70f3ed <<gpui::runtime::Win<unit_action_cost::Model>>::click+0x1cd>
  70f3e7:	0f 8b 82 01 00 00    	jnp    70f56f <<gpui::runtime::Win<unit_action_cost::Model>>::click+0x34f>
  70f3ed:	f3 43 0f 10 4c 25 cc 	movss  -0x34(%r13,%r12,1),%xmm1
  70f3f4:	0f 2e ca             	ucomiss %xmm2,%xmm1
  70f3f7:	75 06                	jne    70f3ff <<gpui::runtime::Win<unit_action_cost::Model>>::click+0x1df>
  70f3f9:	0f 8b 70 01 00 00    	jnp    70f56f <<gpui::runtime::Win<unit_action_cost::Model>>::click+0x34f>
  70f3ff:	0f 14 c1             	unpcklps %xmm1,%xmm0
  70f402:	0f 59 05 17 6a 95 ff 	mulps  -0x6a95e9(%rip),%xmm0        # 65e20 <anon.079f5e587c394fcac2765eb4d0cf0bc2.397.llvm.6319143315422321905+0x1110>
  70f409:	f2 43 0f 10 4c 25 c0 	movsd  -0x40(%r13,%r12,1),%xmm1
  70f410:	0f 58 c8             	addps  %xmm0,%xmm1
  70f413:	0f 29 4c 24 40       	movaps %xmm1,0x40(%rsp)
  70f418:	48 c7 44 24 08 19 00 	movq   $0x19,0x8(%rsp)
  70f41f:	00 00 
  70f421:	48 8d 7c 24 08       	lea    0x8(%rsp),%rdi
  70f426:	e8 45 4f ff ff       	call   704370 <core::ptr::drop_glue::<gpui::runtime::Error>>
  70f42b:	0f 28 44 24 40       	movaps 0x40(%rsp),%xmm0
  70f430:	0f 28 c8             	movaps %xmm0,%xmm1
  70f433:	0f c6 c8 55          	shufps $0x55,%xmm0,%xmm1
  70f437:	48 89 df             	mov    %rbx,%rdi
  70f43a:	0f 29 8c 24 a0 00 00 	movaps %xmm1,0xa0(%rsp)
  70f441:	00 
  70f442:	e8 f9 e0 00 00       	call   71d540 <<gpui::runtime::Runtime<unit_action_cost::Model>>::hit>
  70f447:	48 c7 44 24 08 19 00 	movq   $0x19,0x8(%rsp)
  70f44e:	00 00 
  70f450:	a8 01                	test   $0x1,%al
  70f452:	0f 84 17 01 00 00    	je     70f56f <<gpui::runtime::Win<unit_action_cost::Model>>::click+0x34f>
  70f458:	49 89 d5             	mov    %rdx,%r13
  70f45b:	48 8d 7c 24 08       	lea    0x8(%rsp),%rdi
  70f460:	e8 0b 4f ff ff       	call   704370 <core::ptr::drop_glue::<gpui::runtime::Error>>
  70f465:	4d 39 fd             	cmp    %r15,%r13
  70f468:	0f 85 01 01 00 00    	jne    70f56f <<gpui::runtime::Win<unit_action_cost::Model>>::click+0x34f>
  70f46e:	4c 3b b3 b0 05 00 00 	cmp    0x5b0(%rbx),%r14
  70f475:	0f 85 01 01 00 00    	jne    70f57c <<gpui::runtime::Win<unit_action_cost::Model>>::click+0x35c>
  70f47b:	4c 89 fa             	mov    %r15,%rdx
  70f47e:	48 8d 7c 24 08       	lea    0x8(%rsp),%rdi
  70f483:	48 89 de             	mov    %rbx,%rsi
  70f486:	e8 f5 dd 00 00       	call   71d280 <<gpui::runtime::Runtime<unit_action_cost::Model>>::resolve_identity>
  70f48b:	48 8b 4c 24 08       	mov    0x8(%rsp),%rcx
  70f490:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  70f495:	48 83 f9 fe          	cmp    $0xfffffffffffffffe,%rcx
  70f499:	0f 85 e2 00 00 00    	jne    70f581 <<gpui::runtime::Win<unit_action_cost::Model>>::click+0x361>
  70f49f:	48 8b b3 a0 02 00 00 	mov    0x2a0(%rbx),%rsi
  70f4a6:	48 39 f0             	cmp    %rsi,%rax
  70f4a9:	0f 83 88 01 00 00    	jae    70f637 <<gpui::runtime::Win<unit_action_cost::Model>>::click+0x417>
  70f4af:	48 8b 8b 98 02 00 00 	mov    0x298(%rbx),%rcx
  70f4b6:	48 8d 04 80          	lea    (%rax,%rax,4),%rax
  70f4ba:	8b 44 c1 20          	mov    0x20(%rcx,%rax,8),%eax
  70f4be:	83 e0 07             	and    $0x7,%eax
  70f4c1:	83 f8 02             	cmp    $0x2,%eax
  70f4c4:	0f 85 df 00 00 00    	jne    70f5a9 <<gpui::runtime::Win<unit_action_cost::Model>>::click+0x389>
  70f4ca:	48 89 ef             	mov    %rbp,%rdi
  70f4cd:	48 89 de             	mov    %rbx,%rsi
  70f4d0:	4c 89 f2             	mov    %r14,%rdx
  70f4d3:	4c 89 f9             	mov    %r15,%rcx
  70f4d6:	0f 28 44 24 40       	movaps 0x40(%rsp),%xmm0
  70f4db:	0f 28 8c 24 a0 00 00 	movaps 0xa0(%rsp),%xmm1
  70f4e2:	00 
  70f4e3:	e8 68 c4 ff ff       	call   70b950 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_pointer>
  70f4e8:	e9 05 01 00 00       	jmp    70f5f2 <<gpui::runtime::Win<unit_action_cost::Model>>::click+0x3d2>
  70f4ed:	b8 11 00 00 00       	mov    $0x11,%eax
  70f4f2:	eb 2c                	jmp    70f520 <<gpui::runtime::Win<unit_action_cost::Model>>::click+0x300>
  70f4f4:	48 8b 4c 24 10       	mov    0x10(%rsp),%rcx
  70f4f9:	0f 10 44 24 18       	movups 0x18(%rsp),%xmm0
  70f4fe:	0f 29 44 24 70       	movaps %xmm0,0x70(%rsp)
  70f503:	0f 10 44 24 28       	movups 0x28(%rsp),%xmm0
  70f508:	0f 29 84 24 80 00 00 	movaps %xmm0,0x80(%rsp)
  70f50f:	00 
  70f510:	48 8b 54 24 38       	mov    0x38(%rsp),%rdx
  70f515:	48 89 94 24 90 00 00 	mov    %rdx,0x90(%rsp)
  70f51c:	00 
  70f51d:	48 89 ef             	mov    %rbp,%rdi
  70f520:	48 89 07             	mov    %rax,(%rdi)
  70f523:	48 89 4f 08          	mov    %rcx,0x8(%rdi)
  70f527:	0f 28 44 24 70       	movaps 0x70(%rsp),%xmm0
  70f52c:	0f 28 8c 24 80 00 00 	movaps 0x80(%rsp),%xmm1
  70f533:	00 
  70f534:	0f 11 47 10          	movups %xmm0,0x10(%rdi)
  70f538:	0f 11 4f 20          	movups %xmm1,0x20(%rdi)
  70f53c:	48 8b 84 24 90 00 00 	mov    0x90(%rsp),%rax
  70f543:	00 
  70f544:	48 89 47 30          	mov    %rax,0x30(%rdi)
  70f548:	eb 07                	jmp    70f551 <<gpui::runtime::Win<unit_action_cost::Model>>::click+0x331>
  70f54a:	48 c7 07 12 00 00 00 	movq   $0x12,(%rdi)
  70f551:	48 89 f8             	mov    %rdi,%rax
  70f554:	48 81 c4 b8 00 00 00 	add    $0xb8,%rsp
  70f55b:	5b                   	pop    %rbx
  70f55c:	41 5c                	pop    %r12
  70f55e:	41 5d                	pop    %r13
  70f560:	41 5e                	pop    %r14
  70f562:	41 5f                	pop    %r15
  70f564:	5d                   	pop    %rbp
  70f565:	c3                   	ret
  70f566:	48 c7 07 11 00 00 00 	movq   $0x11,(%rdi)
  70f56d:	eb e2                	jmp    70f551 <<gpui::runtime::Win<unit_action_cost::Model>>::click+0x331>
  70f56f:	48 c7 45 00 19 00 00 	movq   $0x19,0x0(%rbp)
  70f576:	00 
  70f577:	48 89 e8             	mov    %rbp,%rax
  70f57a:	eb d8                	jmp    70f554 <<gpui::runtime::Win<unit_action_cost::Model>>::click+0x334>
  70f57c:	b9 11 00 00 00       	mov    $0x11,%ecx
  70f581:	48 8b 54 24 38       	mov    0x38(%rsp),%rdx
  70f586:	48 89 55 30          	mov    %rdx,0x30(%rbp)
  70f58a:	0f 10 44 24 18       	movups 0x18(%rsp),%xmm0
  70f58f:	0f 10 4c 24 28       	movups 0x28(%rsp),%xmm1
  70f594:	0f 11 4d 20          	movups %xmm1,0x20(%rbp)
  70f598:	0f 11 45 10          	movups %xmm0,0x10(%rbp)
  70f59c:	48 89 4d 00          	mov    %rcx,0x0(%rbp)
  70f5a0:	48 89 45 08          	mov    %rax,0x8(%rbp)
  70f5a4:	48 89 e8             	mov    %rbp,%rax
  70f5a7:	eb ab                	jmp    70f554 <<gpui::runtime::Win<unit_action_cost::Model>>::click+0x334>
  70f5a9:	4c 8b ab e8 05 00 00 	mov    0x5e8(%rbx),%r13
  70f5b0:	4c 8b a3 f0 05 00 00 	mov    0x5f0(%rbx),%r12
  70f5b7:	48 8d 7c 24 08       	lea    0x8(%rsp),%rdi
  70f5bc:	48 89 de             	mov    %rbx,%rsi
  70f5bf:	4c 89 f2             	mov    %r14,%rdx
  70f5c2:	4c 89 f9             	mov    %r15,%rcx
  70f5c5:	e8 56 a4 ff ff       	call   709a20 <<gpui::runtime::Runtime<unit_action_cost::Model>>::focus>
  70f5ca:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  70f5cf:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  70f5d3:	75 25                	jne    70f5fa <<gpui::runtime::Win<unit_action_cost::Model>>::click+0x3da>
  70f5d5:	4c 89 24 24          	mov    %r12,(%rsp)
  70f5d9:	48 89 ef             	mov    %rbp,%rdi
  70f5dc:	48 89 de             	mov    %rbx,%rsi
  70f5df:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  70f5e4:	4c 89 f1             	mov    %r14,%rcx
  70f5e7:	4d 89 f8             	mov    %r15,%r8
  70f5ea:	4d 89 e9             	mov    %r13,%r9
  70f5ed:	e8 4e 79 ff ff       	call   706f40 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_focused>
  70f5f2:	48 89 e8             	mov    %rbp,%rax
  70f5f5:	e9 5a ff ff ff       	jmp    70f554 <<gpui::runtime::Win<unit_action_cost::Model>>::click+0x334>
  70f5fa:	48 8b 4c 24 30       	mov    0x30(%rsp),%rcx
  70f5ff:	0f b6 54 24 38       	movzbl 0x38(%rsp),%edx
  70f604:	8b 74 24 3c          	mov    0x3c(%rsp),%esi
  70f608:	89 75 34             	mov    %esi,0x34(%rbp)
  70f60b:	8b 74 24 39          	mov    0x39(%rsp),%esi
  70f60f:	89 75 31             	mov    %esi,0x31(%rbp)
  70f612:	0f 10 44 24 10       	movups 0x10(%rsp),%xmm0
  70f617:	0f 10 4c 24 20       	movups 0x20(%rsp),%xmm1
  70f61c:	48 89 45 00          	mov    %rax,0x0(%rbp)
  70f620:	0f 11 45 08          	movups %xmm0,0x8(%rbp)
  70f624:	0f 11 4d 18          	movups %xmm1,0x18(%rbp)
  70f628:	48 89 4d 28          	mov    %rcx,0x28(%rbp)
  70f62c:	88 55 30             	mov    %dl,0x30(%rbp)
  70f62f:	48 89 e8             	mov    %rbp,%rax
  70f632:	e9 1d ff ff ff       	jmp    70f554 <<gpui::runtime::Win<unit_action_cost::Model>>::click+0x334>
  70f637:	48 8d 15 fa 3f 3c 00 	lea    0x3c3ffa(%rip),%rdx        # ad3638 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.15092672030101349239+0xa20>
  70f63e:	48 89 c7             	mov    %rax,%rdi
  70f641:	ff 15 21 1e 3f 00    	call   *0x3f1e21(%rip)        # b01468 <_DYNAMIC+0x378>
