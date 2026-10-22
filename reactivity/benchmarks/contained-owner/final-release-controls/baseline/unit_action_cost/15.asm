
/tmp/gpui-contained-owner-unit-baseline-target/release/deps/unit_action_cost-bcf457ce7db1ee75:     file format elf64-x86-64


Disassembly of section .text:

000000000071e160 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::set_property_value_at>:
  71e160:	55                   	push   %rbp
  71e161:	41 57                	push   %r15
  71e163:	41 56                	push   %r14
  71e165:	41 55                	push   %r13
  71e167:	41 54                	push   %r12
  71e169:	53                   	push   %rbx
  71e16a:	48 81 ec 08 02 00 00 	sub    $0x208,%rsp
  71e171:	45 89 cf             	mov    %r9d,%r15d
  71e174:	4c 89 84 24 a8 01 00 	mov    %r8,0x1a8(%rsp)
  71e17b:	00 
  71e17c:	49 89 cd             	mov    %rcx,%r13
  71e17f:	48 89 94 24 a0 01 00 	mov    %rdx,0x1a0(%rsp)
  71e186:	00 
  71e187:	49 89 f6             	mov    %rsi,%r14
  71e18a:	48 89 fb             	mov    %rdi,%rbx
  71e18d:	4c 8b a4 24 40 02 00 	mov    0x240(%rsp),%r12
  71e194:	00 
  71e195:	41 0f b6 2c 24       	movzbl (%r12),%ebp
  71e19a:	40 80 fd ff          	cmp    $0xff,%bpl
  71e19e:	74 1d                	je     71e1bd <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::set_property_value_at+0x5d>
  71e1a0:	44 89 ff             	mov    %r15d,%edi
  71e1a3:	4c 89 e6             	mov    %r12,%rsi
  71e1a6:	ff 15 54 34 3e 00    	call   *0x3e3454(%rip)        # b01600 <_DYNAMIC+0x510>
  71e1ac:	66 85 c0             	test   %ax,%ax
  71e1af:	74 0c                	je     71e1bd <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::set_property_value_at+0x5d>
  71e1b1:	48 89 c1             	mov    %rax,%rcx
  71e1b4:	48 c1 e9 10          	shr    $0x10,%rcx
  71e1b8:	e9 24 06 00 00       	jmp    71e7e1 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::set_property_value_at+0x681>
  71e1bd:	41 0f b7 c7          	movzwl %r15w,%eax
  71e1c1:	48 8d 0d a0 5b 3b 00 	lea    0x3b5ba0(%rip),%rcx        # ad3d68 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.15092672030101349239+0x1150>
  71e1c8:	48 89 84 24 98 01 00 	mov    %rax,0x198(%rsp)
  71e1cf:	00 
  71e1d0:	48 8b 44 c1 f8       	mov    -0x8(%rcx,%rax,8),%rax
  71e1d5:	80 78 12 00          	cmpb   $0x0,0x12(%rax)
  71e1d9:	74 6d                	je     71e248 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::set_property_value_at+0xe8>
  71e1db:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  71e1e2:	49 39 f5             	cmp    %rsi,%r13
  71e1e5:	0f 83 04 0d 00 00    	jae    71eeef <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::set_property_value_at+0xd8f>
  71e1eb:	49 8b 86 98 02 00 00 	mov    0x298(%r14),%rax
  71e1f2:	4a 8d 0c ad 00 00 00 	lea    0x0(,%r13,4),%rcx
  71e1f9:	00 
  71e1fa:	4c 01 e9             	add    %r13,%rcx
  71e1fd:	4c 8b 2c c8          	mov    (%rax,%rcx,8),%r13
  71e201:	49 8b ae 10 06 00 00 	mov    0x610(%r14),%rbp
  71e208:	48 85 ed             	test   %rbp,%rbp
  71e20b:	0f 84 c9 00 00 00    	je     71e2da <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::set_property_value_at+0x17a>
  71e211:	48 8b bd 00 01 00 00 	mov    0x100(%rbp),%rdi
  71e218:	48 85 ff             	test   %rdi,%rdi
  71e21b:	0f 84 82 05 00 00    	je     71e7a3 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::set_property_value_at+0x643>
  71e221:	4c 89 ee             	mov    %r13,%rsi
  71e224:	ff 15 8e 34 3e 00    	call   *0x3e348e(%rip)        # b016b8 <_DYNAMIC+0x5c8>
  71e22a:	49 8b ae 10 06 00 00 	mov    0x610(%r14),%rbp
  71e231:	f3 0f 11 84 24 e8 00 	movss  %xmm0,0xe8(%rsp)
  71e238:	00 00 
  71e23a:	48 85 ed             	test   %rbp,%rbp
  71e23d:	0f 85 56 01 00 00    	jne    71e399 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::set_property_value_at+0x239>
  71e243:	e9 a0 00 00 00       	jmp    71e2e8 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::set_property_value_at+0x188>
  71e248:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  71e24f:	49 39 f5             	cmp    %rsi,%r13
  71e252:	0f 83 a7 0c 00 00    	jae    71eeff <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::set_property_value_at+0xd9f>
  71e258:	49 8b 86 98 02 00 00 	mov    0x298(%r14),%rax
  71e25f:	4a 8d 0c ad 00 00 00 	lea    0x0(,%r13,4),%rcx
  71e266:	00 
  71e267:	4c 01 e9             	add    %r13,%rcx
  71e26a:	48 8b 04 c8          	mov    (%rax,%rcx,8),%rax
  71e26e:	48 89 44 24 70       	mov    %rax,0x70(%rsp)
  71e273:	49 8b 86 00 02 00 00 	mov    0x200(%r14),%rax
  71e27a:	48 8d 0d ab 84 94 ff 	lea    -0x6b7b55(%rip),%rcx        # 6672c <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x9c>
  71e281:	48 63 04 81          	movslq (%rcx,%rax,4),%rax
  71e285:	48 01 c8             	add    %rcx,%rax
  71e288:	ff e0                	jmp    *%rax
  71e28a:	0f 10 05 43 86 94 ff 	movups -0x6b79bd(%rip),%xmm0        # 668d4 <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x244>
  71e291:	0f 29 44 24 50       	movaps %xmm0,0x50(%rsp)
  71e296:	0f 10 05 27 86 94 ff 	movups -0x6b79d9(%rip),%xmm0        # 668c4 <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x234>
  71e29d:	0f 29 44 24 40       	movaps %xmm0,0x40(%rsp)
  71e2a2:	0f 10 05 0b 86 94 ff 	movups -0x6b79f5(%rip),%xmm0        # 668b4 <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x224>
  71e2a9:	0f 29 44 24 30       	movaps %xmm0,0x30(%rsp)
  71e2ae:	0f 10 05 ef 85 94 ff 	movups -0x6b7a11(%rip),%xmm0        # 668a4 <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x214>
  71e2b5:	0f 29 44 24 20       	movaps %xmm0,0x20(%rsp)
  71e2ba:	0f 10 05 d3 85 94 ff 	movups -0x6b7a2d(%rip),%xmm0        # 66894 <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x204>
  71e2c1:	0f 29 44 24 10       	movaps %xmm0,0x10(%rsp)
  71e2c6:	48 b8 00 00 00 00 01 	movabs $0x3000100000000,%rax
  71e2cd:	00 03 00 
  71e2d0:	48 89 44 24 60       	mov    %rax,0x60(%rsp)
  71e2d5:	e9 ed 01 00 00       	jmp    71e4c7 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::set_property_value_at+0x367>
  71e2da:	c7 84 24 e8 00 00 00 	movl   $0x0,0xe8(%rsp)
  71e2e1:	00 00 00 00 
  71e2e5:	0f 57 c0             	xorps  %xmm0,%xmm0
  71e2e8:	f3 0f 11 44 24 70    	movss  %xmm0,0x70(%rsp)
  71e2ee:	ff 15 5c 30 3e 00    	call   *0x3e305c(%rip)        # b01350 <_DYNAMIC+0x260>
  71e2f4:	bf 08 01 00 00       	mov    $0x108,%edi
  71e2f9:	be 08 00 00 00       	mov    $0x8,%esi
  71e2fe:	ff 15 2c 30 3e 00    	call   *0x3e302c(%rip)        # b01330 <_DYNAMIC+0x240>
  71e304:	48 85 c0             	test   %rax,%rax
  71e307:	0f 84 b5 0b 00 00    	je     71eec2 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::set_property_value_at+0xd62>
  71e30d:	48 89 c5             	mov    %rax,%rbp
  71e310:	0f 57 c0             	xorps  %xmm0,%xmm0
  71e313:	0f 11 80 d8 00 00 00 	movups %xmm0,0xd8(%rax)
  71e31a:	0f 11 40 28          	movups %xmm0,0x28(%rax)
  71e31e:	0f 11 40 40          	movups %xmm0,0x40(%rax)
  71e322:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
  71e329:	48 c7 40 18 00 00 00 	movq   $0x0,0x18(%rax)
  71e330:	00 
  71e331:	48 c7 40 20 08 00 00 	movq   $0x8,0x20(%rax)
  71e338:	00 
  71e339:	48 c7 40 38 08 00 00 	movq   $0x8,0x38(%rax)
  71e340:	00 
  71e341:	48 c7 40 50 08 00 00 	movq   $0x8,0x50(%rax)
  71e348:	00 
  71e349:	48 c7 40 58 00 00 00 	movq   $0x0,0x58(%rax)
  71e350:	00 
  71e351:	48 c7 40 60 ff ff ff 	movq   $0xffffffffffffffff,0x60(%rax)
  71e358:	ff 
  71e359:	48 c7 80 c0 00 00 00 	movq   $0x0,0xc0(%rax)
  71e360:	00 00 00 00 
  71e364:	48 c7 80 c8 00 00 00 	movq   $0x8,0xc8(%rax)
  71e36b:	08 00 00 00 
  71e36f:	48 c7 80 d0 00 00 00 	movq   $0x0,0xd0(%rax)
  71e376:	00 00 00 00 
  71e37a:	48 c7 80 e8 00 00 00 	movq   $0x0,0xe8(%rax)
  71e381:	00 00 00 00 
  71e385:	0f 11 80 f8 00 00 00 	movups %xmm0,0xf8(%rax)
  71e38c:	49 89 86 10 06 00 00 	mov    %rax,0x610(%r14)
  71e393:	f3 0f 10 44 24 70    	movss  0x70(%rsp),%xmm0
  71e399:	48 8b bd 00 01 00 00 	mov    0x100(%rbp),%rdi
  71e3a0:	48 85 ff             	test   %rdi,%rdi
  71e3a3:	0f 85 18 04 00 00    	jne    71e7c1 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::set_property_value_at+0x661>
  71e3a9:	f3 0f 11 44 24 70    	movss  %xmm0,0x70(%rsp)
  71e3af:	ff 15 9b 2f 3e 00    	call   *0x3e2f9b(%rip)        # b01350 <_DYNAMIC+0x260>
  71e3b5:	bf 60 00 00 00       	mov    $0x60,%edi
  71e3ba:	be 08 00 00 00       	mov    $0x8,%esi
  71e3bf:	ff 15 6b 2f 3e 00    	call   *0x3e2f6b(%rip)        # b01330 <_DYNAMIC+0x240>
  71e3c5:	48 85 c0             	test   %rax,%rax
  71e3c8:	0f 84 04 0b 00 00    	je     71eed2 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::set_property_value_at+0xd72>
  71e3ce:	48 89 c7             	mov    %rax,%rdi
  71e3d1:	0f 57 c0             	xorps  %xmm0,%xmm0
  71e3d4:	0f 11 40 10          	movups %xmm0,0x10(%rax)
  71e3d8:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
  71e3df:	48 c7 40 08 08 00 00 	movq   $0x8,0x8(%rax)
  71e3e6:	00 
  71e3e7:	48 c7 40 20 08 00 00 	movq   $0x8,0x20(%rax)
  71e3ee:	00 
  71e3ef:	48 c7 40 28 00 00 00 	movq   $0x0,0x28(%rax)
  71e3f6:	00 
  71e3f7:	48 c7 40 30 ff ff ff 	movq   $0xffffffffffffffff,0x30(%rax)
  71e3fe:	ff 
  71e3ff:	48 c7 40 48 00 00 00 	movq   $0x0,0x48(%rax)
  71e406:	00 
  71e407:	48 c7 40 58 00 00 00 	movq   $0x0,0x58(%rax)
  71e40e:	00 
  71e40f:	48 89 85 00 01 00 00 	mov    %rax,0x100(%rbp)
  71e416:	f3 0f 10 44 24 70    	movss  0x70(%rsp),%xmm0
  71e41c:	e9 a0 03 00 00       	jmp    71e7c1 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::set_property_value_at+0x661>
  71e421:	49 8b b6 20 02 00 00 	mov    0x220(%r14),%rsi
  71e428:	49 39 f5             	cmp    %rsi,%r13
  71e42b:	0f 83 de 0a 00 00    	jae    71ef0f <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::set_property_value_at+0xdaf>
  71e431:	49 8b b6 10 02 00 00 	mov    0x210(%r14),%rsi
  71e438:	49 8b 86 18 02 00 00 	mov    0x218(%r14),%rax
  71e43f:	42 0f b6 3c 28       	movzbl (%rax,%r13,1),%edi
  71e444:	48 39 fe             	cmp    %rdi,%rsi
  71e447:	0f 86 e2 0a 00 00    	jbe    71ef2f <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::set_property_value_at+0xdcf>
  71e44d:	49 8b 86 08 02 00 00 	mov    0x208(%r14),%rax
  71e454:	48 6b cf 58          	imul   $0x58,%rdi,%rcx
  71e458:	eb 32                	jmp    71e48c <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::set_property_value_at+0x32c>
  71e45a:	49 8b b6 08 02 00 00 	mov    0x208(%r14),%rsi
  71e461:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  71e466:	4c 89 ea             	mov    %r13,%rdx
  71e469:	ff 15 d9 2f 3e 00    	call   *0x3e2fd9(%rip)        # b01448 <_DYNAMIC+0x358>
  71e46f:	eb 56                	jmp    71e4c7 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::set_property_value_at+0x367>
  71e471:	49 8b b6 18 02 00 00 	mov    0x218(%r14),%rsi
  71e478:	49 39 f5             	cmp    %rsi,%r13
  71e47b:	0f 83 9e 0a 00 00    	jae    71ef1f <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::set_property_value_at+0xdbf>
  71e481:	49 8b 86 10 02 00 00 	mov    0x210(%r14),%rax
  71e488:	49 6b cd 58          	imul   $0x58,%r13,%rcx
  71e48c:	48 8b 54 08 50       	mov    0x50(%rax,%rcx,1),%rdx
  71e491:	48 89 54 24 60       	mov    %rdx,0x60(%rsp)
  71e496:	0f 10 44 08 40       	movups 0x40(%rax,%rcx,1),%xmm0
  71e49b:	0f 29 44 24 50       	movaps %xmm0,0x50(%rsp)
  71e4a0:	0f 10 04 08          	movups (%rax,%rcx,1),%xmm0
  71e4a4:	0f 10 4c 08 10       	movups 0x10(%rax,%rcx,1),%xmm1
  71e4a9:	0f 10 54 08 20       	movups 0x20(%rax,%rcx,1),%xmm2
  71e4ae:	0f 10 5c 08 30       	movups 0x30(%rax,%rcx,1),%xmm3
  71e4b3:	0f 29 5c 24 40       	movaps %xmm3,0x40(%rsp)
  71e4b8:	0f 29 54 24 30       	movaps %xmm2,0x30(%rsp)
  71e4bd:	0f 29 4c 24 20       	movaps %xmm1,0x20(%rsp)
  71e4c2:	0f 29 44 24 10       	movaps %xmm0,0x10(%rsp)
  71e4c7:	49 8d b6 00 02 00 00 	lea    0x200(%r14),%rsi
  71e4ce:	48 8d bc 24 40 01 00 	lea    0x140(%rsp),%rdi
  71e4d5:	00 
  71e4d6:	4c 89 ea             	mov    %r13,%rdx
  71e4d9:	ff 15 39 33 3e 00    	call   *0x3e3339(%rip)        # b01818 <_DYNAMIC+0x728>
  71e4df:	80 bc 24 40 01 00 00 	cmpb   $0x0,0x140(%rsp)
  71e4e6:	00 
  71e4e7:	74 1a                	je     71e503 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::set_property_value_at+0x3a3>
  71e4e9:	48 8d 94 24 44 01 00 	lea    0x144(%rsp),%rdx
  71e4f0:	00 
  71e4f1:	49 8d be f8 05 00 00 	lea    0x5f8(%r14),%rdi
  71e4f8:	48 8b 74 24 70       	mov    0x70(%rsp),%rsi
  71e4fd:	ff 15 1d 33 3e 00    	call   *0x3e331d(%rip)        # b01820 <_DYNAMIC+0x730>
  71e503:	49 8d b6 f8 05 00 00 	lea    0x5f8(%r14),%rsi
  71e50a:	48 8b 44 24 60       	mov    0x60(%rsp),%rax
  71e50f:	48 89 84 24 90 01 00 	mov    %rax,0x190(%rsp)
  71e516:	00 
  71e517:	0f 28 44 24 50       	movaps 0x50(%rsp),%xmm0
  71e51c:	0f 29 84 24 80 01 00 	movaps %xmm0,0x180(%rsp)
  71e523:	00 
  71e524:	0f 28 44 24 10       	movaps 0x10(%rsp),%xmm0
  71e529:	0f 28 4c 24 20       	movaps 0x20(%rsp),%xmm1
  71e52e:	0f 28 54 24 30       	movaps 0x30(%rsp),%xmm2
  71e533:	0f 28 5c 24 40       	movaps 0x40(%rsp),%xmm3
  71e538:	0f 29 9c 24 70 01 00 	movaps %xmm3,0x170(%rsp)
  71e53f:	00 
  71e540:	0f 29 94 24 60 01 00 	movaps %xmm2,0x160(%rsp)
  71e547:	00 
  71e548:	0f 29 8c 24 50 01 00 	movaps %xmm1,0x150(%rsp)
  71e54f:	00 
  71e550:	0f 29 84 24 40 01 00 	movaps %xmm0,0x140(%rsp)
  71e557:	00 
  71e558:	48 8d bc 24 b0 01 00 	lea    0x1b0(%rsp),%rdi
  71e55f:	00 
  71e560:	48 8d 8c 24 40 01 00 	lea    0x140(%rsp),%rcx
  71e567:	00 
  71e568:	48 8b 54 24 70       	mov    0x70(%rsp),%rdx
  71e56d:	45 89 f8             	mov    %r15d,%r8d
  71e570:	4d 89 e1             	mov    %r12,%r9
  71e573:	e8 18 28 01 00       	call   730d90 <<gpui::property::Overrides>::set_value>
  71e578:	44 8b a4 24 b0 01 00 	mov    0x1b0(%rsp),%r12d
  71e57f:	00 
  71e580:	41 83 fc 02          	cmp    $0x2,%r12d
  71e584:	75 2b                	jne    71e5b1 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::set_property_value_at+0x451>
  71e586:	0f b7 84 24 b8 01 00 	movzwl 0x1b8(%rsp),%eax
  71e58d:	00 
  71e58e:	66 89 44 24 6c       	mov    %ax,0x6c(%rsp)
  71e593:	8b 8c 24 b4 01 00 00 	mov    0x1b4(%rsp),%ecx
  71e59a:	89 4c 24 68          	mov    %ecx,0x68(%rsp)
  71e59e:	66 89 43 0c          	mov    %ax,0xc(%rbx)
  71e5a2:	89 4b 08             	mov    %ecx,0x8(%rbx)
  71e5a5:	48 c7 03 24 00 00 00 	movq   $0x24,(%rbx)
  71e5ac:	e9 ff 07 00 00       	jmp    71edb0 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::set_property_value_at+0xc50>
  71e5b1:	45 31 c0             	xor    %r8d,%r8d
  71e5b4:	40 80 fd ff          	cmp    $0xff,%bpl
  71e5b8:	41 0f 95 c0          	setne  %r8b
  71e5bc:	0f b7 84 24 b8 01 00 	movzwl 0x1b8(%rsp),%eax
  71e5c3:	00 
  71e5c4:	66 89 44 24 6c       	mov    %ax,0x6c(%rsp)
  71e5c9:	8b 8c 24 b4 01 00 00 	mov    0x1b4(%rsp),%ecx
  71e5d0:	89 4c 24 68          	mov    %ecx,0x68(%rsp)
  71e5d4:	0f 10 84 24 ba 01 00 	movups 0x1ba(%rsp),%xmm0
  71e5db:	00 
  71e5dc:	0f 11 84 24 f2 00 00 	movups %xmm0,0xf2(%rsp)
  71e5e3:	00 
  71e5e4:	0f 10 84 24 ca 01 00 	movups 0x1ca(%rsp),%xmm0
  71e5eb:	00 
  71e5ec:	0f 11 84 24 02 01 00 	movups %xmm0,0x102(%rsp)
  71e5f3:	00 
  71e5f4:	0f 10 84 24 da 01 00 	movups 0x1da(%rsp),%xmm0
  71e5fb:	00 
  71e5fc:	0f 11 84 24 12 01 00 	movups %xmm0,0x112(%rsp)
  71e603:	00 
  71e604:	0f 10 84 24 ea 01 00 	movups 0x1ea(%rsp),%xmm0
  71e60b:	00 
  71e60c:	0f 11 84 24 22 01 00 	movups %xmm0,0x122(%rsp)
  71e613:	00 
  71e614:	0f 10 84 24 f8 01 00 	movups 0x1f8(%rsp),%xmm0
  71e61b:	00 
  71e61c:	0f 11 84 24 30 01 00 	movups %xmm0,0x130(%rsp)
  71e623:	00 
  71e624:	44 89 a4 24 e8 00 00 	mov    %r12d,0xe8(%rsp)
  71e62b:	00 
  71e62c:	66 89 84 24 f0 00 00 	mov    %ax,0xf0(%rsp)
  71e633:	00 
  71e634:	89 8c 24 ec 00 00 00 	mov    %ecx,0xec(%rsp)
  71e63b:	0f 10 84 24 28 01 00 	movups 0x128(%rsp),%xmm0
  71e642:	00 
  71e643:	0f 29 84 24 d0 00 00 	movaps %xmm0,0xd0(%rsp)
  71e64a:	00 
  71e64b:	0f 10 84 24 18 01 00 	movups 0x118(%rsp),%xmm0
  71e652:	00 
  71e653:	0f 29 84 24 c0 00 00 	movaps %xmm0,0xc0(%rsp)
  71e65a:	00 
  71e65b:	0f 10 84 24 08 01 00 	movups 0x108(%rsp),%xmm0
  71e662:	00 
  71e663:	0f 29 84 24 b0 00 00 	movaps %xmm0,0xb0(%rsp)
  71e66a:	00 
  71e66b:	0f 10 84 24 f8 00 00 	movups 0xf8(%rsp),%xmm0
  71e672:	00 
  71e673:	0f 29 84 24 a0 00 00 	movaps %xmm0,0xa0(%rsp)
  71e67a:	00 
  71e67b:	0f 10 84 24 e8 00 00 	movups 0xe8(%rsp),%xmm0
  71e682:	00 
  71e683:	0f 29 84 24 90 00 00 	movaps %xmm0,0x90(%rsp)
  71e68a:	00 
  71e68b:	48 8b 84 24 38 01 00 	mov    0x138(%rsp),%rax
  71e692:	00 
  71e693:	48 89 84 24 e0 00 00 	mov    %rax,0xe0(%rsp)
  71e69a:	00 
  71e69b:	4d 8b 8e a0 02 00 00 	mov    0x2a0(%r14),%r9
  71e6a2:	0f 29 84 24 40 01 00 	movaps %xmm0,0x140(%rsp)
  71e6a9:	00 
  71e6aa:	48 8b 84 24 38 01 00 	mov    0x138(%rsp),%rax
  71e6b1:	00 
  71e6b2:	48 89 84 24 90 01 00 	mov    %rax,0x190(%rsp)
  71e6b9:	00 
  71e6ba:	f3 0f 6f 84 24 f8 00 	movdqu 0xf8(%rsp),%xmm0
  71e6c1:	00 00 
  71e6c3:	f3 0f 6f 8c 24 08 01 	movdqu 0x108(%rsp),%xmm1
  71e6ca:	00 00 
  71e6cc:	0f 10 94 24 18 01 00 	movups 0x118(%rsp),%xmm2
  71e6d3:	00 
  71e6d4:	0f 10 9c 24 28 01 00 	movups 0x128(%rsp),%xmm3
  71e6db:	00 
  71e6dc:	0f 29 9c 24 80 01 00 	movaps %xmm3,0x180(%rsp)
  71e6e3:	00 
  71e6e4:	0f 29 94 24 70 01 00 	movaps %xmm2,0x170(%rsp)
  71e6eb:	00 
  71e6ec:	66 0f 7f 8c 24 60 01 	movdqa %xmm1,0x160(%rsp)
  71e6f3:	00 00 
  71e6f5:	66 0f 7f 84 24 50 01 	movdqa %xmm0,0x150(%rsp)
  71e6fc:	00 00 
  71e6fe:	48 8d 8c 24 40 01 00 	lea    0x140(%rsp),%rcx
  71e705:	00 
  71e706:	49 8d be 00 02 00 00 	lea    0x200(%r14),%rdi
  71e70d:	4c 89 ee             	mov    %r13,%rsi
  71e710:	44 89 fa             	mov    %r15d,%edx
  71e713:	ff 15 0f 31 3e 00    	call   *0x3e310f(%rip)        # b01828 <_DYNAMIC+0x738>
  71e719:	41 08 86 1f 07 00 00 	or     %al,0x71f(%r14)
  71e720:	44 8b 7c 24 10       	mov    0x10(%rsp),%r15d
  71e725:	0f b6 ac 24 90 00 00 	movzbl 0x90(%rsp),%ebp
  71e72c:	00 
  71e72d:	41 83 ff 01          	cmp    $0x1,%r15d
  71e731:	75 25                	jne    71e758 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::set_property_value_at+0x5f8>
  71e733:	8b 84 24 94 00 00 00 	mov    0x94(%rsp),%eax
  71e73a:	8b 4c 24 14          	mov    0x14(%rsp),%ecx
  71e73e:	39 c1                	cmp    %eax,%ecx
  71e740:	0f 94 c2             	sete   %dl
  71e743:	40 84 d5             	test   %dl,%bpl
  71e746:	75 26                	jne    71e76e <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::set_property_value_at+0x60e>
  71e748:	49 c7 86 08 07 00 00 	movq   $0x1,0x708(%r14)
  71e74f:	01 00 00 00 
  71e753:	e9 03 03 00 00       	jmp    71ea5b <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::set_property_value_at+0x8fb>
  71e758:	40 f6 c5 01          	test   $0x1,%bpl
  71e75c:	74 10                	je     71e76e <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::set_property_value_at+0x60e>
  71e75e:	49 c7 86 08 07 00 00 	movq   $0x1,0x708(%r14)
  71e765:	01 00 00 00 
  71e769:	e9 01 04 00 00       	jmp    71eb6f <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::set_property_value_at+0xa0f>
  71e76e:	8b 54 24 18          	mov    0x18(%rsp),%edx
  71e772:	0f b6 8c 24 98 00 00 	movzbl 0x98(%rsp),%ecx
  71e779:	00 
  71e77a:	83 fa 01             	cmp    $0x1,%edx
  71e77d:	0f 85 b2 01 00 00    	jne    71e935 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::set_property_value_at+0x7d5>
  71e783:	8b 84 24 9c 00 00 00 	mov    0x9c(%rsp),%eax
  71e78a:	39 44 24 1c          	cmp    %eax,0x1c(%rsp)
  71e78e:	0f 94 c0             	sete   %al
  71e791:	be 01 00 00 00       	mov    $0x1,%esi
  71e796:	84 c1                	test   %al,%cl
  71e798:	0f 85 a5 01 00 00    	jne    71e943 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::set_property_value_at+0x7e3>
  71e79e:	e9 a0 02 00 00       	jmp    71ea43 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::set_property_value_at+0x8e3>
  71e7a3:	c7 84 24 e8 00 00 00 	movl   $0x0,0xe8(%rsp)
  71e7aa:	00 00 00 00 
  71e7ae:	0f 57 c0             	xorps  %xmm0,%xmm0
  71e7b1:	48 8b bd 00 01 00 00 	mov    0x100(%rbp),%rdi
  71e7b8:	48 85 ff             	test   %rdi,%rdi
  71e7bb:	0f 84 e8 fb ff ff    	je     71e3a9 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::set_property_value_at+0x249>
  71e7c1:	48 83 c7 48          	add    $0x48,%rdi
  71e7c5:	4c 89 ee             	mov    %r13,%rsi
  71e7c8:	44 89 fa             	mov    %r15d,%edx
  71e7cb:	4c 89 e1             	mov    %r12,%rcx
  71e7ce:	e8 3d 1d 01 00       	call   730510 <<gpui::property::Overrides<gpui::property::GeometryStyle>>::set_value>
  71e7d3:	48 89 c1             	mov    %rax,%rcx
  71e7d6:	48 c1 e9 20          	shr    $0x20,%rcx
  71e7da:	a8 01                	test   $0x1,%al
  71e7dc:	74 16                	je     71e7f4 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::set_property_value_at+0x694>
  71e7de:	c1 e8 10             	shr    $0x10,%eax
  71e7e1:	48 c7 03 24 00 00 00 	movq   $0x24,(%rbx)
  71e7e8:	66 89 43 08          	mov    %ax,0x8(%rbx)
  71e7ec:	89 4b 0a             	mov    %ecx,0xa(%rbx)
  71e7ef:	e9 bc 05 00 00       	jmp    71edb0 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::set_property_value_at+0xc50>
  71e7f4:	66 0f 6e c1          	movd   %ecx,%xmm0
  71e7f8:	89 8c 24 40 01 00 00 	mov    %ecx,0x140(%rsp)
  71e7ff:	48 8b bd 00 01 00 00 	mov    0x100(%rbp),%rdi
  71e806:	4c 89 ee             	mov    %r13,%rsi
  71e809:	ff 15 21 30 3e 00    	call   *0x3e3021(%rip)        # b01830 <_DYNAMIC+0x740>
  71e80f:	48 8b 85 00 01 00 00 	mov    0x100(%rbp),%rax
  71e816:	48 83 78 10 00       	cmpq   $0x0,0x10(%rax)
  71e81b:	75 3a                	jne    71e857 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::set_property_value_at+0x6f7>
  71e81d:	48 83 78 58 00       	cmpq   $0x0,0x58(%rax)
  71e822:	75 33                	jne    71e857 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::set_property_value_at+0x6f7>
  71e824:	48 83 78 28 00       	cmpq   $0x0,0x28(%rax)
  71e829:	75 2c                	jne    71e857 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::set_property_value_at+0x6f7>
  71e82b:	48 83 78 30 ff       	cmpq   $0xffffffffffffffff,0x30(%rax)
  71e830:	75 25                	jne    71e857 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::set_property_value_at+0x6f7>
  71e832:	49 8b 86 10 06 00 00 	mov    0x610(%r14),%rax
  71e839:	48 8b b8 00 01 00 00 	mov    0x100(%rax),%rdi
  71e840:	e8 1b 29 fe ff       	call   701160 <core::ptr::drop_glue::<core::option::Option<alloc::boxed::Box<gpui::runtime::geometry::Geometry>>>>
  71e845:	49 8b 86 10 06 00 00 	mov    0x610(%r14),%rax
  71e84c:	48 c7 80 00 01 00 00 	movq   $0x0,0x100(%rax)
  71e853:	00 00 00 00 
  71e857:	48 8b 05 9a 2c 3e 00 	mov    0x3e2c9a(%rip),%rax        # b014f8 <_DYNAMIC+0x408>
  71e85e:	48 8d bc 24 e8 00 00 	lea    0xe8(%rsp),%rdi
  71e865:	00 
  71e866:	48 8d b4 24 40 01 00 	lea    0x140(%rsp),%rsi
  71e86d:	00 
  71e86e:	ff 50 18             	call   *0x18(%rax)
  71e871:	34 01                	xor    $0x1,%al
  71e873:	0f b6 c0             	movzbl %al,%eax
  71e876:	49 89 86 08 07 00 00 	mov    %rax,0x708(%r14)
  71e87d:	41 08 86 1f 07 00 00 	or     %al,0x71f(%r14)
  71e884:	4d 8b be 10 06 00 00 	mov    0x610(%r14),%r15
  71e88b:	4d 85 ff             	test   %r15,%r15
  71e88e:	0f 84 e1 04 00 00    	je     71ed75 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::set_property_value_at+0xc15>
  71e894:	49 83 bf d8 00 00 00 	cmpq   $0x0,0xd8(%r15)
  71e89b:	00 
  71e89c:	0f 85 d3 04 00 00    	jne    71ed75 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::set_property_value_at+0xc15>
  71e8a2:	49 83 bf e0 00 00 00 	cmpq   $0x0,0xe0(%r15)
  71e8a9:	00 
  71e8aa:	0f 85 c5 04 00 00    	jne    71ed75 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::set_property_value_at+0xc15>
  71e8b0:	49 83 bf 00 01 00 00 	cmpq   $0x0,0x100(%r15)
  71e8b7:	00 
  71e8b8:	0f 85 b7 04 00 00    	jne    71ed75 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::set_property_value_at+0xc15>
  71e8be:	49 83 bf d0 00 00 00 	cmpq   $0x0,0xd0(%r15)
  71e8c5:	00 
  71e8c6:	0f 85 a9 04 00 00    	jne    71ed75 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::set_property_value_at+0xc15>
  71e8cc:	49 83 bf f8 00 00 00 	cmpq   $0x0,0xf8(%r15)
  71e8d3:	00 
  71e8d4:	0f 85 9b 04 00 00    	jne    71ed75 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::set_property_value_at+0xc15>
  71e8da:	49 8b 47 60          	mov    0x60(%r15),%rax
  71e8de:	83 f8 ff             	cmp    $0xffffffff,%eax
  71e8e1:	0f 85 8e 04 00 00    	jne    71ed75 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::set_property_value_at+0xc15>
  71e8e7:	49 83 7f 28 00       	cmpq   $0x0,0x28(%r15)
  71e8ec:	0f 85 83 04 00 00    	jne    71ed75 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::set_property_value_at+0xc15>
  71e8f2:	49 8b 07             	mov    (%r15),%rax
  71e8f5:	49 0b 47 40          	or     0x40(%r15),%rax
  71e8f9:	0f 85 76 04 00 00    	jne    71ed75 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::set_property_value_at+0xc15>
  71e8ff:	49 83 7f 58 00       	cmpq   $0x0,0x58(%r15)
  71e904:	0f 85 6b 04 00 00    	jne    71ed75 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::set_property_value_at+0xc15>
  71e90a:	4c 89 ff             	mov    %r15,%rdi
  71e90d:	e8 ce 6d fe ff       	call   7056e0 <core::ptr::drop_glue::<gpui::runtime::metadata::Metadata>>
  71e912:	be 08 01 00 00       	mov    $0x108,%esi
  71e917:	ba 08 00 00 00       	mov    $0x8,%edx
  71e91c:	4c 89 ff             	mov    %r15,%rdi
  71e91f:	ff 15 13 2a 3e 00    	call   *0x3e2a13(%rip)        # b01338 <_DYNAMIC+0x248>
  71e925:	49 c7 86 10 06 00 00 	movq   $0x0,0x610(%r14)
  71e92c:	00 00 00 00 
  71e930:	e9 40 04 00 00       	jmp    71ed75 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::set_property_value_at+0xc15>
  71e935:	be 01 00 00 00       	mov    $0x1,%esi
  71e93a:	f6 c1 01             	test   $0x1,%cl
  71e93d:	0f 85 00 01 00 00    	jne    71ea43 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::set_property_value_at+0x8e3>
  71e943:	8b 44 24 20          	mov    0x20(%rsp),%eax
  71e947:	3b 84 24 a0 00 00 00 	cmp    0xa0(%rsp),%eax
  71e94e:	0f 85 ef 00 00 00    	jne    71ea43 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::set_property_value_at+0x8e3>
  71e954:	8b 44 24 24          	mov    0x24(%rsp),%eax
  71e958:	3b 84 24 a4 00 00 00 	cmp    0xa4(%rsp),%eax
  71e95f:	0f 85 de 00 00 00    	jne    71ea43 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::set_property_value_at+0x8e3>
  71e965:	8b 44 24 28          	mov    0x28(%rsp),%eax
  71e969:	3b 84 24 a8 00 00 00 	cmp    0xa8(%rsp),%eax
  71e970:	0f 85 cd 00 00 00    	jne    71ea43 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::set_property_value_at+0x8e3>
  71e976:	0f b6 44 24 64       	movzbl 0x64(%rsp),%eax
  71e97b:	3a 84 24 e4 00 00 00 	cmp    0xe4(%rsp),%al
  71e982:	0f 85 bb 00 00 00    	jne    71ea43 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::set_property_value_at+0x8e3>
  71e988:	0f b6 44 24 66       	movzbl 0x66(%rsp),%eax
  71e98d:	3a 84 24 e6 00 00 00 	cmp    0xe6(%rsp),%al
  71e994:	0f 85 a9 00 00 00    	jne    71ea43 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::set_property_value_at+0x8e3>
  71e99a:	0f b6 44 24 67       	movzbl 0x67(%rsp),%eax
  71e99f:	3a 84 24 e7 00 00 00 	cmp    0xe7(%rsp),%al
  71e9a6:	0f 85 97 00 00 00    	jne    71ea43 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::set_property_value_at+0x8e3>
  71e9ac:	0f b6 44 24 65       	movzbl 0x65(%rsp),%eax
  71e9b1:	3a 84 24 e5 00 00 00 	cmp    0xe5(%rsp),%al
  71e9b8:	0f 85 85 00 00 00    	jne    71ea43 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::set_property_value_at+0x8e3>
  71e9be:	89 54 24 0c          	mov    %edx,0xc(%rsp)
  71e9c2:	88 8c 24 80 00 00 00 	mov    %cl,0x80(%rsp)
  71e9c9:	48 8d 7c 24 4c       	lea    0x4c(%rsp),%rdi
  71e9ce:	48 8d b4 24 cc 00 00 	lea    0xcc(%rsp),%rsi
  71e9d5:	00 
  71e9d6:	e8 55 09 00 00       	call   71f330 <<gpui_reactivity_core::geometry::Affine as gpui::property::ExactValue>::same>
  71e9db:	84 c0                	test   %al,%al
  71e9dd:	74 53                	je     71ea32 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::set_property_value_at+0x8d2>
  71e9df:	f3 0f 6f 44 24 2c    	movdqu 0x2c(%rsp),%xmm0
  71e9e5:	f3 0f 6f 8c 24 ac 00 	movdqu 0xac(%rsp),%xmm1
  71e9ec:	00 00 
  71e9ee:	66 0f 74 c8          	pcmpeqb %xmm0,%xmm1
  71e9f2:	66 0f d7 c1          	pmovmskb %xmm1,%eax
  71e9f6:	3d ff ff 00 00       	cmp    $0xffff,%eax
  71e9fb:	0f b6 8c 24 80 00 00 	movzbl 0x80(%rsp),%ecx
  71ea02:	00 
  71ea03:	8b 54 24 0c          	mov    0xc(%rsp),%edx
  71ea07:	be 01 00 00 00       	mov    $0x1,%esi
  71ea0c:	75 35                	jne    71ea43 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::set_property_value_at+0x8e3>
  71ea0e:	f3 0f 6f 44 24 3c    	movdqu 0x3c(%rsp),%xmm0
  71ea14:	f3 0f 6f 8c 24 bc 00 	movdqu 0xbc(%rsp),%xmm1
  71ea1b:	00 00 
  71ea1d:	66 0f 74 c8          	pcmpeqb %xmm0,%xmm1
  71ea21:	66 0f d7 c1          	pmovmskb %xmm1,%eax
  71ea25:	31 f6                	xor    %esi,%esi
  71ea27:	3d ff ff 00 00       	cmp    $0xffff,%eax
  71ea2c:	40 0f 95 c6          	setne  %sil
  71ea30:	eb 11                	jmp    71ea43 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::set_property_value_at+0x8e3>
  71ea32:	0f b6 8c 24 80 00 00 	movzbl 0x80(%rsp),%ecx
  71ea39:	00 
  71ea3a:	8b 54 24 0c          	mov    0xc(%rsp),%edx
  71ea3e:	be 01 00 00 00       	mov    $0x1,%esi
  71ea43:	49 89 b6 08 07 00 00 	mov    %rsi,0x708(%r14)
  71ea4a:	41 f6 c7 01          	test   $0x1,%r15b
  71ea4e:	74 2b                	je     71ea7b <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::set_property_value_at+0x91b>
  71ea50:	8b 84 24 94 00 00 00 	mov    0x94(%rsp),%eax
  71ea57:	8b 4c 24 14          	mov    0x14(%rsp),%ecx
  71ea5b:	39 c1                	cmp    %eax,%ecx
  71ea5d:	0f 94 c0             	sete   %al
  71ea60:	40 20 c5             	and    %al,%bpl
  71ea63:	40 80 fd 01          	cmp    $0x1,%bpl
  71ea67:	0f 85 02 01 00 00    	jne    71eb6f <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::set_property_value_at+0xa0f>
  71ea6d:	8b 54 24 18          	mov    0x18(%rsp),%edx
  71ea71:	0f b6 8c 24 98 00 00 	movzbl 0x98(%rsp),%ecx
  71ea78:	00 
  71ea79:	eb 0a                	jmp    71ea85 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::set_property_value_at+0x925>
  71ea7b:	40 f6 c5 01          	test   $0x1,%bpl
  71ea7f:	0f 85 ea 00 00 00    	jne    71eb6f <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::set_property_value_at+0xa0f>
  71ea85:	83 fa 01             	cmp    $0x1,%edx
  71ea88:	75 17                	jne    71eaa1 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::set_property_value_at+0x941>
  71ea8a:	8b 84 24 9c 00 00 00 	mov    0x9c(%rsp),%eax
  71ea91:	39 44 24 1c          	cmp    %eax,0x1c(%rsp)
  71ea95:	0f 94 c0             	sete   %al
  71ea98:	84 c1                	test   %al,%cl
  71ea9a:	75 0e                	jne    71eaaa <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::set_property_value_at+0x94a>
  71ea9c:	e9 ce 00 00 00       	jmp    71eb6f <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::set_property_value_at+0xa0f>
  71eaa1:	f6 c1 01             	test   $0x1,%cl
  71eaa4:	0f 85 c5 00 00 00    	jne    71eb6f <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::set_property_value_at+0xa0f>
  71eaaa:	8b 44 24 20          	mov    0x20(%rsp),%eax
  71eaae:	3b 84 24 a0 00 00 00 	cmp    0xa0(%rsp),%eax
  71eab5:	0f 85 b4 00 00 00    	jne    71eb6f <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::set_property_value_at+0xa0f>
  71eabb:	8b 44 24 24          	mov    0x24(%rsp),%eax
  71eabf:	3b 84 24 a4 00 00 00 	cmp    0xa4(%rsp),%eax
  71eac6:	0f 85 a3 00 00 00    	jne    71eb6f <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::set_property_value_at+0xa0f>
  71eacc:	8b 44 24 28          	mov    0x28(%rsp),%eax
  71ead0:	3b 84 24 a8 00 00 00 	cmp    0xa8(%rsp),%eax
  71ead7:	0f 85 92 00 00 00    	jne    71eb6f <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::set_property_value_at+0xa0f>
  71eadd:	0f b6 44 24 64       	movzbl 0x64(%rsp),%eax
  71eae2:	3a 84 24 e4 00 00 00 	cmp    0xe4(%rsp),%al
  71eae9:	0f 85 80 00 00 00    	jne    71eb6f <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::set_property_value_at+0xa0f>
  71eaef:	0f b6 44 24 66       	movzbl 0x66(%rsp),%eax
  71eaf4:	3a 84 24 e6 00 00 00 	cmp    0xe6(%rsp),%al
  71eafb:	75 72                	jne    71eb6f <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::set_property_value_at+0xa0f>
  71eafd:	0f b6 44 24 67       	movzbl 0x67(%rsp),%eax
  71eb02:	3a 84 24 e7 00 00 00 	cmp    0xe7(%rsp),%al
  71eb09:	75 64                	jne    71eb6f <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::set_property_value_at+0xa0f>
  71eb0b:	0f b6 44 24 65       	movzbl 0x65(%rsp),%eax
  71eb10:	3a 84 24 e5 00 00 00 	cmp    0xe5(%rsp),%al
  71eb17:	75 56                	jne    71eb6f <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::set_property_value_at+0xa0f>
  71eb19:	48 8d 7c 24 4c       	lea    0x4c(%rsp),%rdi
  71eb1e:	48 8d b4 24 cc 00 00 	lea    0xcc(%rsp),%rsi
  71eb25:	00 
  71eb26:	e8 05 08 00 00       	call   71f330 <<gpui_reactivity_core::geometry::Affine as gpui::property::ExactValue>::same>
  71eb2b:	84 c0                	test   %al,%al
  71eb2d:	74 40                	je     71eb6f <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::set_property_value_at+0xa0f>
  71eb2f:	f3 0f 6f 44 24 2c    	movdqu 0x2c(%rsp),%xmm0
  71eb35:	f3 0f 6f 8c 24 ac 00 	movdqu 0xac(%rsp),%xmm1
  71eb3c:	00 00 
  71eb3e:	66 0f 74 c8          	pcmpeqb %xmm0,%xmm1
  71eb42:	66 0f d7 c1          	pmovmskb %xmm1,%eax
  71eb46:	3d ff ff 00 00       	cmp    $0xffff,%eax
  71eb4b:	75 22                	jne    71eb6f <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::set_property_value_at+0xa0f>
  71eb4d:	f3 0f 6f 44 24 3c    	movdqu 0x3c(%rsp),%xmm0
  71eb53:	f3 0f 6f 8c 24 bc 00 	movdqu 0xbc(%rsp),%xmm1
  71eb5a:	00 00 
  71eb5c:	66 0f 74 c8          	pcmpeqb %xmm0,%xmm1
  71eb60:	66 0f d7 c1          	pmovmskb %xmm1,%eax
  71eb64:	3d ff ff 00 00       	cmp    $0xffff,%eax
  71eb69:	0f 84 06 02 00 00    	je     71ed75 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::set_property_value_at+0xc15>
  71eb6f:	45 89 e0             	mov    %r12d,%r8d
  71eb72:	8b 6c 24 18          	mov    0x18(%rsp),%ebp
  71eb76:	0f b6 7c 24 64       	movzbl 0x64(%rsp),%edi
  71eb7b:	44 0f b6 64 24 65    	movzbl 0x65(%rsp),%r12d
  71eb81:	0f b6 4c 24 66       	movzbl 0x66(%rsp),%ecx
  71eb86:	0f b6 44 24 67       	movzbl 0x67(%rsp),%eax
  71eb8b:	88 84 24 80 00 00 00 	mov    %al,0x80(%rsp)
  71eb92:	8b b4 24 f0 00 00 00 	mov    0xf0(%rsp),%esi
  71eb99:	0f 10 5c 24 1c       	movups 0x1c(%rsp),%xmm3
  71eb9e:	f3 0f 10 44 24 20    	movss  0x20(%rsp),%xmm0
  71eba4:	0f 10 a4 24 f4 00 00 	movups 0xf4(%rsp),%xmm4
  71ebab:	00 
  71ebac:	f3 0f 10 8c 24 f8 00 	movss  0xf8(%rsp),%xmm1
  71ebb3:	00 00 
  71ebb5:	44 0f b6 9c 24 3c 01 	movzbl 0x13c(%rsp),%r11d
  71ebbc:	00 00 
  71ebbe:	44 0f b6 8c 24 3d 01 	movzbl 0x13d(%rsp),%r9d
  71ebc5:	00 00 
  71ebc7:	0f b6 84 24 3e 01 00 	movzbl 0x13e(%rsp),%eax
  71ebce:	00 
  71ebcf:	44 0f b6 94 24 3f 01 	movzbl 0x13f(%rsp),%r10d
  71ebd6:	00 00 
  71ebd8:	41 f6 c7 01          	test   $0x1,%r15b
  71ebdc:	74 22                	je     71ec00 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::set_property_value_at+0xaa0>
  71ebde:	f3 0f 10 54 24 14    	movss  0x14(%rsp),%xmm2
  71ebe4:	0f 2e 94 24 ec 00 00 	ucomiss 0xec(%rsp),%xmm2
  71ebeb:	00 
  71ebec:	41 0f 9b c7          	setnp  %r15b
  71ebf0:	0f 94 c2             	sete   %dl
  71ebf3:	44 20 fa             	and    %r15b,%dl
  71ebf6:	41 84 d0             	test   %dl,%r8b
  71ebf9:	75 0f                	jne    71ec0a <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::set_property_value_at+0xaaa>
  71ebfb:	e9 a3 00 00 00       	jmp    71eca3 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::set_property_value_at+0xb43>
  71ec00:	41 f6 c0 01          	test   $0x1,%r8b
  71ec04:	0f 85 99 00 00 00    	jne    71eca3 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::set_property_value_at+0xb43>
  71ec0a:	83 fd 01             	cmp    $0x1,%ebp
  71ec0d:	75 3c                	jne    71ec4b <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::set_property_value_at+0xaeb>
  71ec0f:	44 30 df             	xor    %r11b,%dil
  71ec12:	30 c1                	xor    %al,%cl
  71ec14:	0f b6 84 24 80 00 00 	movzbl 0x80(%rsp),%eax
  71ec1b:	00 
  71ec1c:	44 30 d0             	xor    %r10b,%al
  71ec1f:	45 38 cc             	cmp    %r9b,%r12b
  71ec22:	0f 94 c2             	sete   %dl
  71ec25:	0f 28 c3             	movaps %xmm3,%xmm0
  71ec28:	0f c2 c4 00          	cmpeqps %xmm4,%xmm0
  71ec2c:	44 0f 50 c0          	movmskps %xmm0,%r8d
  71ec30:	41 80 f0 0f          	xor    $0xf,%r8b
  71ec34:	40 08 f9             	or     %dil,%cl
  71ec37:	44 08 c1             	or     %r8b,%cl
  71ec3a:	08 c1                	or     %al,%cl
  71ec3c:	0f 94 c0             	sete   %al
  71ec3f:	40 20 f0             	and    %sil,%al
  71ec42:	84 d0                	test   %dl,%al
  71ec44:	74 5d                	je     71eca3 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::set_property_value_at+0xb43>
  71ec46:	e9 83 00 00 00       	jmp    71ecce <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::set_property_value_at+0xb6e>
  71ec4b:	0f 2e c1             	ucomiss %xmm1,%xmm0
  71ec4e:	0f 9b c2             	setnp  %dl
  71ec51:	40 0f 94 c5          	sete   %bpl
  71ec55:	40 20 d5             	and    %dl,%bpl
  71ec58:	40 f6 d6             	not    %sil
  71ec5b:	40 20 ee             	and    %bpl,%sil
  71ec5e:	0f 28 c3             	movaps %xmm3,%xmm0
  71ec61:	0f c2 c4 00          	cmpeqps %xmm4,%xmm0
  71ec65:	0f 50 d0             	movmskps %xmm0,%edx
  71ec68:	89 d5                	mov    %edx,%ebp
  71ec6a:	40 c0 ed 03          	shr    $0x3,%bpl
  71ec6e:	c0 ea 02             	shr    $0x2,%dl
  71ec71:	40 20 f2             	and    %sil,%dl
  71ec74:	44 38 df             	cmp    %r11b,%dil
  71ec77:	40 0f 94 c6          	sete   %sil
  71ec7b:	40 20 ee             	and    %bpl,%sil
  71ec7e:	40 20 d6             	and    %dl,%sil
  71ec81:	38 c1                	cmp    %al,%cl
  71ec83:	0f 94 c1             	sete   %cl
  71ec86:	44 38 94 24 80 00 00 	cmp    %r10b,0x80(%rsp)
  71ec8d:	00 
  71ec8e:	0f 94 c0             	sete   %al
  71ec91:	20 c8                	and    %cl,%al
  71ec93:	45 38 cc             	cmp    %r9b,%r12b
  71ec96:	0f 94 c1             	sete   %cl
  71ec99:	20 c1                	and    %al,%cl
  71ec9b:	40 20 f1             	and    %sil,%cl
  71ec9e:	80 f9 01             	cmp    $0x1,%cl
  71eca1:	74 2b                	je     71ecce <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::set_property_value_at+0xb6e>
  71eca3:	49 8d be 48 06 00 00 	lea    0x648(%r14),%rdi
  71ecaa:	48 8b 74 24 70       	mov    0x70(%rsp),%rsi
  71ecaf:	0f 29 5c 24 70       	movaps %xmm3,0x70(%rsp)
  71ecb4:	0f 29 a4 24 80 00 00 	movaps %xmm4,0x80(%rsp)
  71ecbb:	00 
  71ecbc:	e8 cf 21 00 00       	call   720e90 <<alloc::collections::btree::map::BTreeMap<u64, alloc::collections::btree::set_val::SetValZST>>::insert>
  71ecc1:	0f 28 a4 24 80 00 00 	movaps 0x80(%rsp),%xmm4
  71ecc8:	00 
  71ecc9:	0f 28 5c 24 70       	movaps 0x70(%rsp),%xmm3
  71ecce:	0f c2 dc 04          	cmpneqps %xmm4,%xmm3
  71ecd2:	66 0f c5 c3 06       	pextrw $0x6,%xmm3,%eax
  71ecd7:	49 8b 8e a0 02 00 00 	mov    0x2a0(%r14),%rcx
  71ecde:	a8 01                	test   $0x1,%al
  71ece0:	74 73                	je     71ed55 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::set_property_value_at+0xbf5>
  71ece2:	49 39 cd             	cmp    %rcx,%r13
  71ece5:	0f 83 51 02 00 00    	jae    71ef3c <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::set_property_value_at+0xddc>
  71eceb:	49 8b 86 98 02 00 00 	mov    0x298(%r14),%rax
  71ecf2:	4a 8d 14 ad 00 00 00 	lea    0x0(,%r13,4),%rdx
  71ecf9:	00 
  71ecfa:	4c 01 ea             	add    %r13,%rdx
  71ecfd:	8b 7c d0 20          	mov    0x20(%rax,%rdx,8),%edi
  71ed01:	89 f8                	mov    %edi,%eax
  71ed03:	83 e0 07             	and    $0x7,%eax
  71ed06:	83 f8 06             	cmp    $0x6,%eax
  71ed09:	74 4a                	je     71ed55 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::set_property_value_at+0xbf5>
  71ed0b:	c1 ef 03             	shr    $0x3,%edi
  71ed0e:	74 45                	je     71ed55 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::set_property_value_at+0xbf5>
  71ed10:	49 8b b6 b8 02 00 00 	mov    0x2b8(%r14),%rsi
  71ed17:	ff cf                	dec    %edi
  71ed19:	48 39 fe             	cmp    %rdi,%rsi
  71ed1c:	0f 86 2d 02 00 00    	jbe    71ef4f <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::set_property_value_at+0xdef>
  71ed22:	4d 8b be b0 02 00 00 	mov    0x2b0(%r14),%r15
  71ed29:	48 8d 04 bf          	lea    (%rdi,%rdi,4),%rax
  71ed2d:	48 c1 e0 04          	shl    $0x4,%rax
  71ed31:	49 83 3c 07 fe       	cmpq   $0xfffffffffffffffe,(%r15,%rax,1)
  71ed36:	0f 84 a6 01 00 00    	je     71eee2 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::set_property_value_at+0xd82>
  71ed3c:	49 01 c7             	add    %rax,%r15
  71ed3f:	4c 89 ff             	mov    %r15,%rdi
  71ed42:	e8 49 27 fe ff       	call   701490 <core::ptr::drop_glue::<core::option::Option<gpui::runtime::Shaped>>>
  71ed47:	49 c7 07 ff ff ff ff 	movq   $0xffffffffffffffff,(%r15)
  71ed4e:	49 8b 8e a0 02 00 00 	mov    0x2a0(%r14),%rcx
  71ed55:	48 8d 94 24 e8 00 00 	lea    0xe8(%rsp),%rdx
  71ed5c:	00 
  71ed5d:	49 8d be 00 02 00 00 	lea    0x200(%r14),%rdi
  71ed64:	4c 89 ee             	mov    %r13,%rsi
  71ed67:	ff 15 cb 27 3e 00    	call   *0x3e27cb(%rip)        # b01538 <_DYNAMIC+0x448>
  71ed6d:	41 c6 86 1f 07 00 00 	movb   $0x1,0x71f(%r14)
  71ed74:	01 
  71ed75:	48 8b 84 24 a8 01 00 	mov    0x1a8(%rsp),%rax
  71ed7c:	00 
  71ed7d:	49 89 86 60 06 00 00 	mov    %rax,0x660(%r14)
  71ed84:	49 ff 86 b0 06 00 00 	incq   0x6b0(%r14)
  71ed8b:	48 8b 84 24 98 01 00 	mov    0x198(%rsp),%rax
  71ed92:	00 
  71ed93:	48 8d 0d ce 4f 3b 00 	lea    0x3b4fce(%rip),%rcx        # ad3d68 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.15092672030101349239+0x1150>
  71ed9a:	48 8b 44 c1 f8       	mov    -0x8(%rcx,%rax,8),%rax
  71ed9f:	80 78 12 00          	cmpb   $0x0,0x12(%rax)
  71eda3:	74 1d                	je     71edc2 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::set_property_value_at+0xc62>
  71eda5:	48 89 df             	mov    %rbx,%rdi
  71eda8:	4c 89 f6             	mov    %r14,%rsi
  71edab:	e8 40 ed ff ff       	call   71daf0 <<gpui::runtime::Runtime<unit_action_cost::Model>>::present>
  71edb0:	48 81 c4 08 02 00 00 	add    $0x208,%rsp
  71edb7:	5b                   	pop    %rbx
  71edb8:	41 5c                	pop    %r12
  71edba:	41 5d                	pop    %r13
  71edbc:	41 5e                	pop    %r14
  71edbe:	41 5f                	pop    %r15
  71edc0:	5d                   	pop    %rbp
  71edc1:	c3                   	ret
  71edc2:	49 8b 86 18 06 00 00 	mov    0x618(%r14),%rax
  71edc9:	48 85 c0             	test   %rax,%rax
  71edcc:	74 d7                	je     71eda5 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::set_property_value_at+0xc45>
  71edce:	49 8b 8e 20 06 00 00 	mov    0x620(%r14),%rcx
  71edd5:	48 85 c9             	test   %rcx,%rcx
  71edd8:	74 74                	je     71ee4e <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::set_property_value_at+0xcee>
  71edda:	48 89 ca             	mov    %rcx,%rdx
  71eddd:	48 83 e2 07          	and    $0x7,%rdx
  71ede1:	74 24                	je     71ee07 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::set_property_value_at+0xca7>
  71ede3:	31 f6                	xor    %esi,%esi
  71ede5:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
  71edec:	00 00 00 00 
  71edf0:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  71edf7:	48 ff c6             	inc    %rsi
  71edfa:	48 39 f2             	cmp    %rsi,%rdx
  71edfd:	75 f1                	jne    71edf0 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::set_property_value_at+0xc90>
  71edff:	48 89 ca             	mov    %rcx,%rdx
  71ee02:	48 29 f2             	sub    %rsi,%rdx
  71ee05:	eb 03                	jmp    71ee0a <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::set_property_value_at+0xcaa>
  71ee07:	48 89 ca             	mov    %rcx,%rdx
  71ee0a:	48 83 f9 08          	cmp    $0x8,%rcx
  71ee0e:	72 3e                	jb     71ee4e <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::set_property_value_at+0xcee>
  71ee10:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  71ee17:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  71ee1e:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  71ee25:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  71ee2c:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  71ee33:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  71ee3a:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  71ee41:	48 8b 80 90 05 00 00 	mov    0x590(%rax),%rax
  71ee48:	48 83 c2 f8          	add    $0xfffffffffffffff8,%rdx
  71ee4c:	75 c2                	jne    71ee10 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::set_property_value_at+0xcb0>
  71ee4e:	66 83 b8 8a 05 00 00 	cmpw   $0x0,0x58a(%rax)
  71ee55:	00 
  71ee56:	0f 84 49 ff ff ff    	je     71eda5 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::set_property_value_at+0xc45>
  71ee5c:	48 83 38 00          	cmpq   $0x0,(%rax)
  71ee60:	0f 85 3f ff ff ff    	jne    71eda5 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::set_property_value_at+0xc45>
  71ee66:	48 8d bc 24 40 01 00 	lea    0x140(%rsp),%rdi
  71ee6d:	00 
  71ee6e:	4c 89 f6             	mov    %r14,%rsi
  71ee71:	48 8b 94 24 a0 01 00 	mov    0x1a0(%rsp),%rdx
  71ee78:	00 
  71ee79:	31 c9                	xor    %ecx,%ecx
  71ee7b:	e8 10 7f fe ff       	call   706d90 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::describe_with>
  71ee80:	83 bc 24 40 01 00 00 	cmpl   $0xfffffffe,0x140(%rsp)
  71ee87:	fe 
  71ee88:	0f 84 17 ff ff ff    	je     71eda5 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::set_property_value_at+0xc45>
  71ee8e:	48 8b 84 24 70 01 00 	mov    0x170(%rsp),%rax
  71ee95:	00 
  71ee96:	48 89 43 30          	mov    %rax,0x30(%rbx)
  71ee9a:	0f 10 84 24 40 01 00 	movups 0x140(%rsp),%xmm0
  71eea1:	00 
  71eea2:	0f 10 8c 24 50 01 00 	movups 0x150(%rsp),%xmm1
  71eea9:	00 
  71eeaa:	0f 10 94 24 60 01 00 	movups 0x160(%rsp),%xmm2
  71eeb1:	00 
  71eeb2:	0f 11 53 20          	movups %xmm2,0x20(%rbx)
  71eeb6:	0f 11 4b 10          	movups %xmm1,0x10(%rbx)
  71eeba:	0f 11 03             	movups %xmm0,(%rbx)
  71eebd:	e9 ee fe ff ff       	jmp    71edb0 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::set_property_value_at+0xc50>
  71eec2:	bf 08 00 00 00       	mov    $0x8,%edi
  71eec7:	be 08 01 00 00       	mov    $0x108,%esi
  71eecc:	ff 15 96 24 3e 00    	call   *0x3e2496(%rip)        # b01368 <_DYNAMIC+0x278>
  71eed2:	bf 08 00 00 00       	mov    $0x8,%edi
  71eed7:	be 60 00 00 00       	mov    $0x60,%esi
  71eedc:	ff 15 86 24 3e 00    	call   *0x3e2486(%rip)        # b01368 <_DYNAMIC+0x278>
  71eee2:	48 8d 3d cf 3f 3b 00 	lea    0x3b3fcf(%rip),%rdi        # ad2eb8 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.15092672030101349239+0x2a0>
  71eee9:	ff 15 89 24 3e 00    	call   *0x3e2489(%rip)        # b01378 <_DYNAMIC+0x288>
  71eeef:	48 8d 15 ea 44 3b 00 	lea    0x3b44ea(%rip),%rdx        # ad33e0 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.15092672030101349239+0x7c8>
  71eef6:	4c 89 ef             	mov    %r13,%rdi
  71eef9:	ff 15 69 25 3e 00    	call   *0x3e2569(%rip)        # b01468 <_DYNAMIC+0x378>
  71eeff:	48 8d 15 8a 4b 3b 00 	lea    0x3b4b8a(%rip),%rdx        # ad3a90 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.15092672030101349239+0xe78>
  71ef06:	4c 89 ef             	mov    %r13,%rdi
  71ef09:	ff 15 59 25 3e 00    	call   *0x3e2559(%rip)        # b01468 <_DYNAMIC+0x378>
  71ef0f:	48 8d 15 e2 42 3b 00 	lea    0x3b42e2(%rip),%rdx        # ad31f8 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.15092672030101349239+0x5e0>
  71ef16:	4c 89 ef             	mov    %r13,%rdi
  71ef19:	ff 15 49 25 3e 00    	call   *0x3e2549(%rip)        # b01468 <_DYNAMIC+0x378>
  71ef1f:	48 8d 15 ba 42 3b 00 	lea    0x3b42ba(%rip),%rdx        # ad31e0 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.15092672030101349239+0x5c8>
  71ef26:	4c 89 ef             	mov    %r13,%rdi
  71ef29:	ff 15 39 25 3e 00    	call   *0x3e2539(%rip)        # b01468 <_DYNAMIC+0x378>
  71ef2f:	48 8d 15 da 42 3b 00 	lea    0x3b42da(%rip),%rdx        # ad3210 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.15092672030101349239+0x5f8>
  71ef36:	ff 15 2c 25 3e 00    	call   *0x3e252c(%rip)        # b01468 <_DYNAMIC+0x378>
  71ef3c:	48 8d 15 65 4b 3b 00 	lea    0x3b4b65(%rip),%rdx        # ad3aa8 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.15092672030101349239+0xe90>
  71ef43:	4c 89 ef             	mov    %r13,%rdi
  71ef46:	48 89 ce             	mov    %rcx,%rsi
  71ef49:	ff 15 19 25 3e 00    	call   *0x3e2519(%rip)        # b01468 <_DYNAMIC+0x378>
  71ef4f:	48 8d 15 4a 3f 3b 00 	lea    0x3b3f4a(%rip),%rdx        # ad2ea0 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.15092672030101349239+0x288>
  71ef56:	ff 15 0c 25 3e 00    	call   *0x3e250c(%rip)        # b01468 <_DYNAMIC+0x378>
  71ef5c:	48 89 c3             	mov    %rax,%rbx
  71ef5f:	be 08 01 00 00       	mov    $0x108,%esi
  71ef64:	ba 08 00 00 00       	mov    $0x8,%edx
  71ef69:	4c 89 ff             	mov    %r15,%rdi
  71ef6c:	ff 15 c6 23 3e 00    	call   *0x3e23c6(%rip)        # b01338 <_DYNAMIC+0x248>
  71ef72:	49 c7 86 10 06 00 00 	movq   $0x0,0x610(%r14)
  71ef79:	00 00 00 00 
  71ef7d:	48 89 df             	mov    %rbx,%rdi
  71ef80:	e8 5b 28 3b 00       	call   ad17e0 <_Unwind_Resume@plt>
  71ef85:	48 89 c3             	mov    %rax,%rbx
  71ef88:	49 8b 86 10 06 00 00 	mov    0x610(%r14),%rax
  71ef8f:	48 c7 80 00 01 00 00 	movq   $0x0,0x100(%rax)
  71ef96:	00 00 00 00 
  71ef9a:	48 89 df             	mov    %rbx,%rdi
  71ef9d:	e8 3e 28 3b 00       	call   ad17e0 <_Unwind_Resume@plt>
  71efa2:	49 c7 07 ff ff ff ff 	movq   $0xffffffffffffffff,(%r15)
  71efa9:	48 89 c7             	mov    %rax,%rdi
  71efac:	e8 2f 28 3b 00       	call   ad17e0 <_Unwind_Resume@plt>
