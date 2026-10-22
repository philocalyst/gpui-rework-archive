
/tmp/gpui-contained-owner-unit-baseline-target/release/deps/unit_action_cost_two-c899ee77dd9a9ab3:     file format elf64-x86-64


Disassembly of section .text:

0000000000704240 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_input>:
  704240:	41 57                	push   %r15
  704242:	41 56                	push   %r14
  704244:	41 55                	push   %r13
  704246:	41 54                	push   %r12
  704248:	53                   	push   %rbx
  704249:	48 83 ec 40          	sub    $0x40,%rsp
  70424d:	48 89 fb             	mov    %rdi,%rbx
  704250:	80 be 22 07 00 00 00 	cmpb   $0x0,0x722(%rsi)
  704257:	74 0c                	je     704265 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_input+0x25>
  704259:	48 c7 03 0e 00 00 00 	movq   $0xe,(%rbx)
  704260:	e9 8c 01 00 00       	jmp    7043f1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_input+0x1b1>
  704265:	4d 89 c7             	mov    %r8,%r15
  704268:	49 89 f6             	mov    %rsi,%r14
  70426b:	48 8d 7c 24 08       	lea    0x8(%rsp),%rdi
  704270:	e8 7b d0 ff ff       	call   7012f0 <<gpui::runtime::Runtime<unit_action_cost_two::Model>>::input_index>
  704275:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  70427a:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  70427f:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  704283:	0f 85 e2 00 00 00    	jne    70436b <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_input+0x12b>
  704289:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  704290:	49 39 f4             	cmp    %rsi,%r12
  704293:	0f 83 89 01 00 00    	jae    704422 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_input+0x1e2>
  704299:	4b 8d 04 a4          	lea    (%r12,%r12,4),%rax
  70429d:	49 8b 8e 98 02 00 00 	mov    0x298(%r14),%rcx
  7042a4:	8b 7c c1 20          	mov    0x20(%rcx,%rax,8),%edi
  7042a8:	89 f8                	mov    %edi,%eax
  7042aa:	83 e0 07             	and    $0x7,%eax
  7042ad:	83 f8 06             	cmp    $0x6,%eax
  7042b0:	0f 84 49 01 00 00    	je     7043ff <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_input+0x1bf>
  7042b6:	c1 ef 03             	shr    $0x3,%edi
  7042b9:	0f 84 40 01 00 00    	je     7043ff <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_input+0x1bf>
  7042bf:	49 8b b6 b8 02 00 00 	mov    0x2b8(%r14),%rsi
  7042c6:	ff cf                	dec    %edi
  7042c8:	48 39 fe             	cmp    %rdi,%rsi
  7042cb:	0f 86 61 01 00 00    	jbe    704432 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_input+0x1f2>
  7042d1:	49 8b 86 b0 02 00 00 	mov    0x2b0(%r14),%rax
  7042d8:	48 8d 0c bf          	lea    (%rdi,%rdi,4),%rcx
  7042dc:	48 c1 e1 04          	shl    $0x4,%rcx
  7042e0:	48 83 3c 08 fe       	cmpq   $0xfffffffffffffffe,(%rax,%rcx,1)
  7042e5:	0f 84 21 01 00 00    	je     70440c <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_input+0x1cc>
  7042eb:	48 01 c8             	add    %rcx,%rax
  7042ee:	48 8b 78 40          	mov    0x40(%rax),%rdi
  7042f2:	48 8b 37             	mov    (%rdi),%rsi
  7042f5:	48 d1 ee             	shr    $1,%rsi
  7042f8:	48 83 c7 10          	add    $0x10,%rdi
  7042fc:	4c 89 fa             	mov    %r15,%rdx
  7042ff:	ff 15 43 3e 42 00    	call   *0x423e43(%rip)        # b28148 <_DYNAMIC+0x490>
  704305:	84 c0                	test   %al,%al
  704307:	0f 84 82 00 00 00    	je     70438f <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_input+0x14f>
  70430d:	4d 8b ae 60 06 00 00 	mov    0x660(%r14),%r13
  704314:	49 ff c5             	inc    %r13
  704317:	0f 84 fc 00 00 00    	je     704419 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_input+0x1d9>
  70431d:	49 c7 86 08 07 00 00 	movq   $0x0,0x708(%r14)
  704324:	00 00 00 00 
  704328:	4c 89 f7             	mov    %r14,%rdi
  70432b:	4c 89 e6             	mov    %r12,%rsi
  70432e:	4c 89 fa             	mov    %r15,%rdx
  704331:	e8 da d0 ff ff       	call   701410 <<gpui::runtime::Runtime<unit_action_cost_two::Model>>::set_selection>
  704336:	84 c0                	test   %al,%al
  704338:	74 5e                	je     704398 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_input+0x158>
  70433a:	4d 89 ae 60 06 00 00 	mov    %r13,0x660(%r14)
  704341:	49 ff 86 b0 06 00 00 	incq   0x6b0(%r14)
  704348:	49 c7 86 08 07 00 00 	movq   $0x1,0x708(%r14)
  70434f:	01 00 00 00 
  704353:	48 89 df             	mov    %rbx,%rdi
  704356:	4c 89 f6             	mov    %r14,%rsi
  704359:	48 83 c4 40          	add    $0x40,%rsp
  70435d:	5b                   	pop    %rbx
  70435e:	41 5c                	pop    %r12
  704360:	41 5d                	pop    %r13
  704362:	41 5e                	pop    %r14
  704364:	41 5f                	pop    %r15
  704366:	e9 55 3e 02 00       	jmp    7281c0 <<gpui::runtime::Runtime<unit_action_cost_two::Model>>::present>
  70436b:	48 8b 4c 24 38       	mov    0x38(%rsp),%rcx
  704370:	48 89 4b 30          	mov    %rcx,0x30(%rbx)
  704374:	0f 10 44 24 18       	movups 0x18(%rsp),%xmm0
  704379:	0f 10 4c 24 28       	movups 0x28(%rsp),%xmm1
  70437e:	0f 11 4b 20          	movups %xmm1,0x20(%rbx)
  704382:	0f 11 43 10          	movups %xmm0,0x10(%rbx)
  704386:	48 89 03             	mov    %rax,(%rbx)
  704389:	4c 89 63 08          	mov    %r12,0x8(%rbx)
  70438d:	eb 62                	jmp    7043f1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_input+0x1b1>
  70438f:	48 c7 03 18 00 00 00 	movq   $0x18,(%rbx)
  704396:	eb 59                	jmp    7043f1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_input+0x1b1>
  704398:	41 0f 10 86 60 06 00 	movups 0x660(%r14),%xmm0
  70439f:	00 
  7043a0:	41 0f b6 86 20 07 00 	movzbl 0x720(%r14),%eax
  7043a7:	00 
  7043a8:	49 83 be 80 06 00 00 	cmpq   $0x0,0x680(%r14)
  7043af:	00 
  7043b0:	74 1c                	je     7043ce <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_input+0x18e>
  7043b2:	84 c0                	test   %al,%al
  7043b4:	74 0a                	je     7043c0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_input+0x180>
  7043b6:	49 83 be 88 05 00 00 	cmpq   $0xffffffffffffffff,0x588(%r14)
  7043bd:	ff 
  7043be:	74 0e                	je     7043ce <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_input+0x18e>
  7043c0:	49 8b 96 90 06 00 00 	mov    0x690(%r14),%rdx
  7043c7:	b9 01 00 00 00       	mov    $0x1,%ecx
  7043cc:	eb 02                	jmp    7043d0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_input+0x190>
  7043ce:	31 c9                	xor    %ecx,%ecx
  7043d0:	49 8b b6 08 07 00 00 	mov    0x708(%r14),%rsi
  7043d7:	48 89 4b 08          	mov    %rcx,0x8(%rbx)
  7043db:	48 89 53 10          	mov    %rdx,0x10(%rbx)
  7043df:	0f 11 43 18          	movups %xmm0,0x18(%rbx)
  7043e3:	48 89 73 28          	mov    %rsi,0x28(%rbx)
  7043e7:	88 43 30             	mov    %al,0x30(%rbx)
  7043ea:	48 c7 03 fe ff ff ff 	movq   $0xfffffffffffffffe,(%rbx)
  7043f1:	48 83 c4 40          	add    $0x40,%rsp
  7043f5:	5b                   	pop    %rbx
  7043f6:	41 5c                	pop    %r12
  7043f8:	41 5d                	pop    %r13
  7043fa:	41 5e                	pop    %r14
  7043fc:	41 5f                	pop    %r15
  7043fe:	c3                   	ret
  7043ff:	48 8d 3d 12 58 3f 00 	lea    0x3f5812(%rip),%rdi        # af9c18 <__frame_dummy_init_array_entry+0x6f0>
  704406:	ff 15 b4 3b 42 00    	call   *0x423bb4(%rip)        # b27fc0 <_DYNAMIC+0x308>
  70440c:	48 8d 3d 65 52 3f 00 	lea    0x3f5265(%rip),%rdi        # af9678 <__frame_dummy_init_array_entry+0x150>
  704413:	ff 15 a7 3b 42 00    	call   *0x423ba7(%rip)        # b27fc0 <_DYNAMIC+0x308>
  704419:	48 c7 03 1f 00 00 00 	movq   $0x1f,(%rbx)
  704420:	eb cf                	jmp    7043f1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::select_input+0x1b1>
  704422:	48 8d 15 d7 57 3f 00 	lea    0x3f57d7(%rip),%rdx        # af9c00 <__frame_dummy_init_array_entry+0x6d8>
  704429:	4c 89 e7             	mov    %r12,%rdi
  70442c:	ff 15 de 3b 42 00    	call   *0x423bde(%rip)        # b28010 <_DYNAMIC+0x358>
  704432:	48 8d 15 27 52 3f 00 	lea    0x3f5227(%rip),%rdx        # af9660 <__frame_dummy_init_array_entry+0x138>
  704439:	ff 15 d1 3b 42 00    	call   *0x423bd1(%rip)        # b28010 <_DYNAMIC+0x358>
