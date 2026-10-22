
/tmp/gpui-contained-owner-unit-baseline-target/release/deps/unit_action_cost_two-c899ee77dd9a9ab3:     file format elf64-x86-64


Disassembly of section .text:

000000000070b050 <<gpui::runtime::Win<unit_action_cost_two::Model>>::click>:
  70b050:	55                   	push   %rbp
  70b051:	41 57                	push   %r15
  70b053:	41 56                	push   %r14
  70b055:	41 55                	push   %r13
  70b057:	41 54                	push   %r12
  70b059:	53                   	push   %rbx
  70b05a:	48 81 ec b8 00 00 00 	sub    $0xb8,%rsp
  70b061:	48 8b 1e             	mov    (%rsi),%rbx
  70b064:	48 85 db             	test   %rbx,%rbx
  70b067:	74 15                	je     70b07e <<gpui::runtime::Win<unit_action_cost_two::Model>>::click+0x2e>
  70b069:	80 bb 22 07 00 00 01 	cmpb   $0x1,0x722(%rbx)
  70b070:	75 20                	jne    70b092 <<gpui::runtime::Win<unit_action_cost_two::Model>>::click+0x42>
  70b072:	48 c7 07 0e 00 00 00 	movq   $0xe,(%rdi)
  70b079:	e9 03 03 00 00       	jmp    70b381 <<gpui::runtime::Win<unit_action_cost_two::Model>>::click+0x331>
  70b07e:	48 c7 07 0d 00 00 00 	movq   $0xd,(%rdi)
  70b085:	48 c7 47 08 00 00 00 	movq   $0x0,0x8(%rdi)
  70b08c:	00 
  70b08d:	e9 ef 02 00 00       	jmp    70b381 <<gpui::runtime::Win<unit_action_cost_two::Model>>::click+0x331>
  70b092:	48 3b 93 b0 05 00 00 	cmp    0x5b0(%rbx),%rdx
  70b099:	0f 85 7e 02 00 00    	jne    70b31d <<gpui::runtime::Win<unit_action_cost_two::Model>>::click+0x2cd>
  70b09f:	49 89 f4             	mov    %rsi,%r12
  70b0a2:	49 89 d6             	mov    %rdx,%r14
  70b0a5:	48 89 fd             	mov    %rdi,%rbp
  70b0a8:	48 8d 7c 24 08       	lea    0x8(%rsp),%rdi
  70b0ad:	48 89 de             	mov    %rbx,%rsi
  70b0b0:	49 89 cf             	mov    %rcx,%r15
  70b0b3:	48 89 ca             	mov    %rcx,%rdx
  70b0b6:	e8 95 c8 01 00       	call   727950 <<gpui::runtime::Runtime<unit_action_cost_two::Model>>::resolve_identity>
  70b0bb:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  70b0c0:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  70b0c4:	0f 85 5a 02 00 00    	jne    70b324 <<gpui::runtime::Win<unit_action_cost_two::Model>>::click+0x2d4>
  70b0ca:	80 bb 1e 07 00 00 01 	cmpb   $0x1,0x71e(%rbx)
  70b0d1:	48 89 ef             	mov    %rbp,%rdi
  70b0d4:	0f 85 a0 02 00 00    	jne    70b37a <<gpui::runtime::Win<unit_action_cost_two::Model>>::click+0x32a>
  70b0da:	80 bb 1f 07 00 00 00 	cmpb   $0x0,0x71f(%rbx)
  70b0e1:	0f 85 93 02 00 00    	jne    70b37a <<gpui::runtime::Win<unit_action_cost_two::Model>>::click+0x32a>
  70b0e7:	80 bb 20 07 00 00 00 	cmpb   $0x0,0x720(%rbx)
  70b0ee:	0f 84 86 02 00 00    	je     70b37a <<gpui::runtime::Win<unit_action_cost_two::Model>>::click+0x32a>
  70b0f4:	48 83 bb 88 05 00 00 	cmpq   $0xffffffffffffffff,0x588(%rbx)
  70b0fb:	ff 
  70b0fc:	0f 85 78 02 00 00    	jne    70b37a <<gpui::runtime::Win<unit_action_cost_two::Model>>::click+0x32a>
  70b102:	48 8b 83 60 06 00 00 	mov    0x660(%rbx),%rax
  70b109:	48 3b 83 68 06 00 00 	cmp    0x668(%rbx),%rax
  70b110:	0f 85 64 02 00 00    	jne    70b37a <<gpui::runtime::Win<unit_action_cost_two::Model>>::click+0x32a>
  70b116:	48 8b 83 78 06 00 00 	mov    0x678(%rbx),%rax
  70b11d:	48 3b 83 70 06 00 00 	cmp    0x670(%rbx),%rax
  70b124:	0f 85 50 02 00 00    	jne    70b37a <<gpui::runtime::Win<unit_action_cost_two::Model>>::click+0x32a>
  70b12a:	f3 0f 10 83 14 07 00 	movss  0x714(%rbx),%xmm0
  70b131:	00 
  70b132:	0f 2e 83 18 07 00 00 	ucomiss 0x718(%rbx),%xmm0
  70b139:	0f 85 3b 02 00 00    	jne    70b37a <<gpui::runtime::Win<unit_action_cost_two::Model>>::click+0x32a>
  70b13f:	0f 8a 35 02 00 00    	jp     70b37a <<gpui::runtime::Win<unit_action_cost_two::Model>>::click+0x32a>
  70b145:	4c 89 e0             	mov    %r12,%rax
  70b148:	48 83 c0 08          	add    $0x8,%rax
  70b14c:	4c 8b ab 78 05 00 00 	mov    0x578(%rbx),%r13
  70b153:	48 8b 8b 80 05 00 00 	mov    0x580(%rbx),%rcx
  70b15a:	48 c1 e1 04          	shl    $0x4,%rcx
  70b15e:	48 8d 0c 89          	lea    (%rcx,%rcx,4),%rcx
  70b162:	45 31 e4             	xor    %r12d,%r12d
  70b165:	4c 89 ee             	mov    %r13,%rsi
  70b168:	4c 89 fa             	mov    %r15,%rdx
  70b16b:	4c 39 e1             	cmp    %r12,%rcx
  70b16e:	0f 84 22 02 00 00    	je     70b396 <<gpui::runtime::Win<unit_action_cost_two::Model>>::click+0x346>
  70b174:	49 83 c4 50          	add    $0x50,%r12
  70b178:	48 39 56 20          	cmp    %rdx,0x20(%rsi)
  70b17c:	48 8d 76 50          	lea    0x50(%rsi),%rsi
  70b180:	75 e9                	jne    70b16b <<gpui::runtime::Win<unit_action_cost_two::Model>>::click+0x11b>
  70b182:	48 89 44 24 58       	mov    %rax,0x58(%rsp)
  70b187:	48 c7 44 24 08 11 00 	movq   $0x11,0x8(%rsp)
  70b18e:	00 00 
  70b190:	48 8d 7c 24 08       	lea    0x8(%rsp),%rdi
  70b195:	e8 e6 c8 fe ff       	call   6f7a80 <core::ptr::drop_glue::<gpui::runtime::Error>>
  70b19a:	f3 43 0f 10 44 25 e0 	movss  -0x20(%r13,%r12,1),%xmm0
  70b1a1:	0f 2e c0             	ucomiss %xmm0,%xmm0
  70b1a4:	7a 62                	jp     70b208 <<gpui::runtime::Win<unit_action_cost_two::Model>>::click+0x1b8>
  70b1a6:	43 8b 44 25 f4       	mov    -0xc(%r13,%r12,1),%eax
  70b1ab:	89 44 24 1c          	mov    %eax,0x1c(%rsp)
  70b1af:	43 0f 10 4c 25 e4    	movups -0x1c(%r13,%r12,1),%xmm1
  70b1b5:	0f 11 4c 24 0c       	movups %xmm1,0xc(%rsp)
  70b1ba:	f3 0f 11 44 24 08    	movss  %xmm0,0x8(%rsp)
  70b1c0:	f3 43 0f 10 44 25 b8 	movss  -0x48(%r13,%r12,1),%xmm0
  70b1c7:	f3 43 0f 10 4c 25 bc 	movss  -0x44(%r13,%r12,1),%xmm1
  70b1ce:	48 8d 7c 24 64       	lea    0x64(%rsp),%rdi
  70b1d3:	48 8d 74 24 08       	lea    0x8(%rsp),%rsi
  70b1d8:	e8 b3 eb fe ff       	call   6f9d90 <<gpui::runtime::Win<unit_action_cost_two::SecondModel>>::click::{closure#1}>
  70b1dd:	83 7c 24 64 01       	cmpl   $0x1,0x64(%rsp)
  70b1e2:	75 24                	jne    70b208 <<gpui::runtime::Win<unit_action_cost_two::Model>>::click+0x1b8>
  70b1e4:	f2 0f 10 44 24 68    	movsd  0x68(%rsp),%xmm0
  70b1ea:	0f 28 c8             	movaps %xmm0,%xmm1
  70b1ed:	0f c6 c8 55          	shufps $0x55,%xmm0,%xmm1
  70b1f1:	4b 8d 3c 2c          	lea    (%r12,%r13,1),%rdi
  70b1f5:	48 83 c7 c0          	add    $0xffffffffffffffc0,%rdi
  70b1f9:	0f 29 44 24 40       	movaps %xmm0,0x40(%rsp)
  70b1fe:	ff 15 e4 cf 41 00    	call   *0x41cfe4(%rip)        # b281e8 <_DYNAMIC+0x530>
  70b204:	84 c0                	test   %al,%al
  70b206:	75 40                	jne    70b248 <<gpui::runtime::Win<unit_action_cost_two::Model>>::click+0x1f8>
  70b208:	f3 43 0f 10 44 25 c8 	movss  -0x38(%r13,%r12,1),%xmm0
  70b20f:	0f 57 d2             	xorps  %xmm2,%xmm2
  70b212:	0f 2e c2             	ucomiss %xmm2,%xmm0
  70b215:	75 06                	jne    70b21d <<gpui::runtime::Win<unit_action_cost_two::Model>>::click+0x1cd>
  70b217:	0f 8b 82 01 00 00    	jnp    70b39f <<gpui::runtime::Win<unit_action_cost_two::Model>>::click+0x34f>
  70b21d:	f3 43 0f 10 4c 25 cc 	movss  -0x34(%r13,%r12,1),%xmm1
  70b224:	0f 2e ca             	ucomiss %xmm2,%xmm1
  70b227:	75 06                	jne    70b22f <<gpui::runtime::Win<unit_action_cost_two::Model>>::click+0x1df>
  70b229:	0f 8b 70 01 00 00    	jnp    70b39f <<gpui::runtime::Win<unit_action_cost_two::Model>>::click+0x34f>
  70b22f:	0f 14 c1             	unpcklps %xmm1,%xmm0
  70b232:	0f 59 05 57 fb 94 ff 	mulps  -0x6b04a9(%rip),%xmm0        # 5ad90 <anon.079f5e587c394fcac2765eb4d0cf0bc2.397.llvm.6319143315422321905+0x1120>
  70b239:	f2 43 0f 10 4c 25 c0 	movsd  -0x40(%r13,%r12,1),%xmm1
  70b240:	0f 58 c8             	addps  %xmm0,%xmm1
  70b243:	0f 29 4c 24 40       	movaps %xmm1,0x40(%rsp)
  70b248:	48 c7 44 24 08 19 00 	movq   $0x19,0x8(%rsp)
  70b24f:	00 00 
  70b251:	48 8d 7c 24 08       	lea    0x8(%rsp),%rdi
  70b256:	e8 25 c8 fe ff       	call   6f7a80 <core::ptr::drop_glue::<gpui::runtime::Error>>
  70b25b:	0f 28 44 24 40       	movaps 0x40(%rsp),%xmm0
  70b260:	0f 28 c8             	movaps %xmm0,%xmm1
  70b263:	0f c6 c8 55          	shufps $0x55,%xmm0,%xmm1
  70b267:	48 89 df             	mov    %rbx,%rdi
  70b26a:	0f 29 8c 24 a0 00 00 	movaps %xmm1,0xa0(%rsp)
  70b271:	00 
  70b272:	e8 99 c9 01 00       	call   727c10 <<gpui::runtime::Runtime<unit_action_cost_two::Model>>::hit>
  70b277:	48 c7 44 24 08 19 00 	movq   $0x19,0x8(%rsp)
  70b27e:	00 00 
  70b280:	a8 01                	test   $0x1,%al
  70b282:	0f 84 17 01 00 00    	je     70b39f <<gpui::runtime::Win<unit_action_cost_two::Model>>::click+0x34f>
  70b288:	49 89 d5             	mov    %rdx,%r13
  70b28b:	48 8d 7c 24 08       	lea    0x8(%rsp),%rdi
  70b290:	e8 eb c7 fe ff       	call   6f7a80 <core::ptr::drop_glue::<gpui::runtime::Error>>
  70b295:	4d 39 fd             	cmp    %r15,%r13
  70b298:	0f 85 01 01 00 00    	jne    70b39f <<gpui::runtime::Win<unit_action_cost_two::Model>>::click+0x34f>
  70b29e:	4c 3b b3 b0 05 00 00 	cmp    0x5b0(%rbx),%r14
  70b2a5:	0f 85 01 01 00 00    	jne    70b3ac <<gpui::runtime::Win<unit_action_cost_two::Model>>::click+0x35c>
  70b2ab:	4c 89 fa             	mov    %r15,%rdx
  70b2ae:	48 8d 7c 24 08       	lea    0x8(%rsp),%rdi
  70b2b3:	48 89 de             	mov    %rbx,%rsi
  70b2b6:	e8 95 c6 01 00       	call   727950 <<gpui::runtime::Runtime<unit_action_cost_two::Model>>::resolve_identity>
  70b2bb:	48 8b 4c 24 08       	mov    0x8(%rsp),%rcx
  70b2c0:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  70b2c5:	48 83 f9 fe          	cmp    $0xfffffffffffffffe,%rcx
  70b2c9:	0f 85 e2 00 00 00    	jne    70b3b1 <<gpui::runtime::Win<unit_action_cost_two::Model>>::click+0x361>
  70b2cf:	48 8b b3 a0 02 00 00 	mov    0x2a0(%rbx),%rsi
  70b2d6:	48 39 f0             	cmp    %rsi,%rax
  70b2d9:	0f 83 88 01 00 00    	jae    70b467 <<gpui::runtime::Win<unit_action_cost_two::Model>>::click+0x417>
  70b2df:	48 8b 8b 98 02 00 00 	mov    0x298(%rbx),%rcx
  70b2e6:	48 8d 04 80          	lea    (%rax,%rax,4),%rax
  70b2ea:	8b 44 c1 20          	mov    0x20(%rcx,%rax,8),%eax
  70b2ee:	83 e0 07             	and    $0x7,%eax
  70b2f1:	83 f8 02             	cmp    $0x2,%eax
  70b2f4:	0f 85 df 00 00 00    	jne    70b3d9 <<gpui::runtime::Win<unit_action_cost_two::Model>>::click+0x389>
  70b2fa:	48 89 ef             	mov    %rbp,%rdi
  70b2fd:	48 89 de             	mov    %rbx,%rsi
  70b300:	4c 89 f2             	mov    %r14,%rdx
  70b303:	4c 89 f9             	mov    %r15,%rcx
  70b306:	0f 28 44 24 40       	movaps 0x40(%rsp),%xmm0
  70b30b:	0f 28 8c 24 a0 00 00 	movaps 0xa0(%rsp),%xmm1
  70b312:	00 
  70b313:	e8 28 91 ff ff       	call   704440 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_pointer>
  70b318:	e9 05 01 00 00       	jmp    70b422 <<gpui::runtime::Win<unit_action_cost_two::Model>>::click+0x3d2>
  70b31d:	b8 11 00 00 00       	mov    $0x11,%eax
  70b322:	eb 2c                	jmp    70b350 <<gpui::runtime::Win<unit_action_cost_two::Model>>::click+0x300>
  70b324:	48 8b 4c 24 10       	mov    0x10(%rsp),%rcx
  70b329:	0f 10 44 24 18       	movups 0x18(%rsp),%xmm0
  70b32e:	0f 29 44 24 70       	movaps %xmm0,0x70(%rsp)
  70b333:	0f 10 44 24 28       	movups 0x28(%rsp),%xmm0
  70b338:	0f 29 84 24 80 00 00 	movaps %xmm0,0x80(%rsp)
  70b33f:	00 
  70b340:	48 8b 54 24 38       	mov    0x38(%rsp),%rdx
  70b345:	48 89 94 24 90 00 00 	mov    %rdx,0x90(%rsp)
  70b34c:	00 
  70b34d:	48 89 ef             	mov    %rbp,%rdi
  70b350:	48 89 07             	mov    %rax,(%rdi)
  70b353:	48 89 4f 08          	mov    %rcx,0x8(%rdi)
  70b357:	0f 28 44 24 70       	movaps 0x70(%rsp),%xmm0
  70b35c:	0f 28 8c 24 80 00 00 	movaps 0x80(%rsp),%xmm1
  70b363:	00 
  70b364:	0f 11 47 10          	movups %xmm0,0x10(%rdi)
  70b368:	0f 11 4f 20          	movups %xmm1,0x20(%rdi)
  70b36c:	48 8b 84 24 90 00 00 	mov    0x90(%rsp),%rax
  70b373:	00 
  70b374:	48 89 47 30          	mov    %rax,0x30(%rdi)
  70b378:	eb 07                	jmp    70b381 <<gpui::runtime::Win<unit_action_cost_two::Model>>::click+0x331>
  70b37a:	48 c7 07 12 00 00 00 	movq   $0x12,(%rdi)
  70b381:	48 89 f8             	mov    %rdi,%rax
  70b384:	48 81 c4 b8 00 00 00 	add    $0xb8,%rsp
  70b38b:	5b                   	pop    %rbx
  70b38c:	41 5c                	pop    %r12
  70b38e:	41 5d                	pop    %r13
  70b390:	41 5e                	pop    %r14
  70b392:	41 5f                	pop    %r15
  70b394:	5d                   	pop    %rbp
  70b395:	c3                   	ret
  70b396:	48 c7 07 11 00 00 00 	movq   $0x11,(%rdi)
  70b39d:	eb e2                	jmp    70b381 <<gpui::runtime::Win<unit_action_cost_two::Model>>::click+0x331>
  70b39f:	48 c7 45 00 19 00 00 	movq   $0x19,0x0(%rbp)
  70b3a6:	00 
  70b3a7:	48 89 e8             	mov    %rbp,%rax
  70b3aa:	eb d8                	jmp    70b384 <<gpui::runtime::Win<unit_action_cost_two::Model>>::click+0x334>
  70b3ac:	b9 11 00 00 00       	mov    $0x11,%ecx
  70b3b1:	48 8b 54 24 38       	mov    0x38(%rsp),%rdx
  70b3b6:	48 89 55 30          	mov    %rdx,0x30(%rbp)
  70b3ba:	0f 10 44 24 18       	movups 0x18(%rsp),%xmm0
  70b3bf:	0f 10 4c 24 28       	movups 0x28(%rsp),%xmm1
  70b3c4:	0f 11 4d 20          	movups %xmm1,0x20(%rbp)
  70b3c8:	0f 11 45 10          	movups %xmm0,0x10(%rbp)
  70b3cc:	48 89 4d 00          	mov    %rcx,0x0(%rbp)
  70b3d0:	48 89 45 08          	mov    %rax,0x8(%rbp)
  70b3d4:	48 89 e8             	mov    %rbp,%rax
  70b3d7:	eb ab                	jmp    70b384 <<gpui::runtime::Win<unit_action_cost_two::Model>>::click+0x334>
  70b3d9:	4c 8b ab e8 05 00 00 	mov    0x5e8(%rbx),%r13
  70b3e0:	4c 8b a3 f0 05 00 00 	mov    0x5f0(%rbx),%r12
  70b3e7:	48 8d 7c 24 08       	lea    0x8(%rsp),%rdi
  70b3ec:	48 89 de             	mov    %rbx,%rsi
  70b3ef:	4c 89 f2             	mov    %r14,%rdx
  70b3f2:	4c 89 f9             	mov    %r15,%rcx
  70b3f5:	e8 16 4b ff ff       	call   6fff10 <<gpui::runtime::Runtime<unit_action_cost_two::Model>>::focus>
  70b3fa:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  70b3ff:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  70b403:	75 25                	jne    70b42a <<gpui::runtime::Win<unit_action_cost_two::Model>>::click+0x3da>
  70b405:	4c 89 24 24          	mov    %r12,(%rsp)
  70b409:	48 89 ef             	mov    %rbp,%rdi
  70b40c:	48 89 de             	mov    %rbx,%rsi
  70b40f:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  70b414:	4c 89 f1             	mov    %r14,%rcx
  70b417:	4d 89 f8             	mov    %r15,%r8
  70b41a:	4d 89 e9             	mov    %r13,%r9
  70b41d:	e8 fe 1a ff ff       	call   6fcf20 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::activate_focused>
  70b422:	48 89 e8             	mov    %rbp,%rax
  70b425:	e9 5a ff ff ff       	jmp    70b384 <<gpui::runtime::Win<unit_action_cost_two::Model>>::click+0x334>
  70b42a:	48 8b 4c 24 30       	mov    0x30(%rsp),%rcx
  70b42f:	0f b6 54 24 38       	movzbl 0x38(%rsp),%edx
  70b434:	8b 74 24 3c          	mov    0x3c(%rsp),%esi
  70b438:	89 75 34             	mov    %esi,0x34(%rbp)
  70b43b:	8b 74 24 39          	mov    0x39(%rsp),%esi
  70b43f:	89 75 31             	mov    %esi,0x31(%rbp)
  70b442:	0f 10 44 24 10       	movups 0x10(%rsp),%xmm0
  70b447:	0f 10 4c 24 20       	movups 0x20(%rsp),%xmm1
  70b44c:	48 89 45 00          	mov    %rax,0x0(%rbp)
  70b450:	0f 11 45 08          	movups %xmm0,0x8(%rbp)
  70b454:	0f 11 4d 18          	movups %xmm1,0x18(%rbp)
  70b458:	48 89 4d 28          	mov    %rcx,0x28(%rbp)
  70b45c:	88 55 30             	mov    %dl,0x30(%rbp)
  70b45f:	48 89 e8             	mov    %rbp,%rax
  70b462:	e9 1d ff ff ff       	jmp    70b384 <<gpui::runtime::Win<unit_action_cost_two::Model>>::click+0x334>
  70b467:	48 8d 15 ba e9 3e 00 	lea    0x3ee9ba(%rip),%rdx        # af9e28 <__frame_dummy_init_array_entry+0x900>
  70b46e:	48 89 c7             	mov    %rax,%rdi
  70b471:	ff 15 99 cb 41 00    	call   *0x41cb99(%rip)        # b28010 <_DYNAMIC+0x358>
