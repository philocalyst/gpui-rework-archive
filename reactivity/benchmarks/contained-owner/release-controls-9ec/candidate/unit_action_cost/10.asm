
/tmp/gpui-contained-owner-spike-target/release/deps/unit_action_cost-bcf457ce7db1ee75:     file format elf64-x86-64


Disassembly of section .text:

000000000070c2c0 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_input>:
  70c2c0:	41 57                	push   %r15
  70c2c2:	41 56                	push   %r14
  70c2c4:	41 55                	push   %r13
  70c2c6:	41 54                	push   %r12
  70c2c8:	53                   	push   %rbx
  70c2c9:	48 83 ec 40          	sub    $0x40,%rsp
  70c2cd:	48 89 fb             	mov    %rdi,%rbx
  70c2d0:	80 be 22 07 00 00 00 	cmpb   $0x0,0x722(%rsi)
  70c2d7:	74 0c                	je     70c2e5 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_input+0x25>
  70c2d9:	48 c7 03 0e 00 00 00 	movq   $0xe,(%rbx)
  70c2e0:	e9 8c 01 00 00       	jmp    70c471 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_input+0x1b1>
  70c2e5:	4d 89 c7             	mov    %r8,%r15
  70c2e8:	49 89 f6             	mov    %rsi,%r14
  70c2eb:	48 8d 7c 24 08       	lea    0x8(%rsp),%rdi
  70c2f0:	e8 eb e4 ff ff       	call   70a7e0 <<gpui::runtime::Runtime<unit_action_cost::Model>>::input_index>
  70c2f5:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  70c2fa:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  70c2ff:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  70c303:	0f 85 e2 00 00 00    	jne    70c3eb <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_input+0x12b>
  70c309:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  70c310:	49 39 f4             	cmp    %rsi,%r12
  70c313:	0f 83 89 01 00 00    	jae    70c4a2 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_input+0x1e2>
  70c319:	4b 8d 04 a4          	lea    (%r12,%r12,4),%rax
  70c31d:	49 8b 8e 98 02 00 00 	mov    0x298(%r14),%rcx
  70c324:	8b 7c c1 20          	mov    0x20(%rcx,%rax,8),%edi
  70c328:	89 f8                	mov    %edi,%eax
  70c32a:	83 e0 07             	and    $0x7,%eax
  70c32d:	83 f8 06             	cmp    $0x6,%eax
  70c330:	0f 84 49 01 00 00    	je     70c47f <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_input+0x1bf>
  70c336:	c1 ef 03             	shr    $0x3,%edi
  70c339:	0f 84 40 01 00 00    	je     70c47f <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_input+0x1bf>
  70c33f:	49 8b b6 b8 02 00 00 	mov    0x2b8(%r14),%rsi
  70c346:	ff cf                	dec    %edi
  70c348:	48 39 fe             	cmp    %rdi,%rsi
  70c34b:	0f 86 61 01 00 00    	jbe    70c4b2 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_input+0x1f2>
  70c351:	49 8b 86 b0 02 00 00 	mov    0x2b0(%r14),%rax
  70c358:	48 8d 0c bf          	lea    (%rdi,%rdi,4),%rcx
  70c35c:	48 c1 e1 04          	shl    $0x4,%rcx
  70c360:	48 83 3c 08 fe       	cmpq   $0xfffffffffffffffe,(%rax,%rcx,1)
  70c365:	0f 84 21 01 00 00    	je     70c48c <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_input+0x1cc>
  70c36b:	48 01 c8             	add    %rcx,%rax
  70c36e:	48 8b 78 40          	mov    0x40(%rax),%rdi
  70c372:	48 8b 37             	mov    (%rdi),%rsi
  70c375:	48 d1 ee             	shr    $1,%rsi
  70c378:	48 83 c7 10          	add    $0x10,%rdi
  70c37c:	4c 89 fa             	mov    %r15,%rdx
  70c37f:	ff 15 4b 5f 3f 00    	call   *0x3f5f4b(%rip)        # b022d0 <_DYNAMIC+0x4b8>
  70c385:	84 c0                	test   %al,%al
  70c387:	0f 84 82 00 00 00    	je     70c40f <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_input+0x14f>
  70c38d:	4d 8b ae 60 06 00 00 	mov    0x660(%r14),%r13
  70c394:	49 ff c5             	inc    %r13
  70c397:	0f 84 fc 00 00 00    	je     70c499 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_input+0x1d9>
  70c39d:	49 c7 86 08 07 00 00 	movq   $0x0,0x708(%r14)
  70c3a4:	00 00 00 00 
  70c3a8:	4c 89 f7             	mov    %r14,%rdi
  70c3ab:	4c 89 e6             	mov    %r12,%rsi
  70c3ae:	4c 89 fa             	mov    %r15,%rdx
  70c3b1:	e8 4a e5 ff ff       	call   70a900 <<gpui::runtime::Runtime<unit_action_cost::Model>>::set_selection>
  70c3b6:	84 c0                	test   %al,%al
  70c3b8:	74 5e                	je     70c418 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_input+0x158>
  70c3ba:	4d 89 ae 60 06 00 00 	mov    %r13,0x660(%r14)
  70c3c1:	49 ff 86 b0 06 00 00 	incq   0x6b0(%r14)
  70c3c8:	49 c7 86 08 07 00 00 	movq   $0x1,0x708(%r14)
  70c3cf:	01 00 00 00 
  70c3d3:	48 89 df             	mov    %rbx,%rdi
  70c3d6:	4c 89 f6             	mov    %r14,%rsi
  70c3d9:	48 83 c4 40          	add    $0x40,%rsp
  70c3dd:	5b                   	pop    %rbx
  70c3de:	41 5c                	pop    %r12
  70c3e0:	41 5d                	pop    %r13
  70c3e2:	41 5e                	pop    %r14
  70c3e4:	41 5f                	pop    %r15
  70c3e6:	e9 75 22 01 00       	jmp    71e660 <<gpui::runtime::Runtime<unit_action_cost::Model>>::present>
  70c3eb:	48 8b 4c 24 38       	mov    0x38(%rsp),%rcx
  70c3f0:	48 89 4b 30          	mov    %rcx,0x30(%rbx)
  70c3f4:	0f 10 44 24 18       	movups 0x18(%rsp),%xmm0
  70c3f9:	0f 10 4c 24 28       	movups 0x28(%rsp),%xmm1
  70c3fe:	0f 11 4b 20          	movups %xmm1,0x20(%rbx)
  70c402:	0f 11 43 10          	movups %xmm0,0x10(%rbx)
  70c406:	48 89 03             	mov    %rax,(%rbx)
  70c409:	4c 89 63 08          	mov    %r12,0x8(%rbx)
  70c40d:	eb 62                	jmp    70c471 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_input+0x1b1>
  70c40f:	48 c7 03 18 00 00 00 	movq   $0x18,(%rbx)
  70c416:	eb 59                	jmp    70c471 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_input+0x1b1>
  70c418:	41 0f 10 86 60 06 00 	movups 0x660(%r14),%xmm0
  70c41f:	00 
  70c420:	41 0f b6 86 20 07 00 	movzbl 0x720(%r14),%eax
  70c427:	00 
  70c428:	49 83 be 80 06 00 00 	cmpq   $0x0,0x680(%r14)
  70c42f:	00 
  70c430:	74 1c                	je     70c44e <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_input+0x18e>
  70c432:	84 c0                	test   %al,%al
  70c434:	74 0a                	je     70c440 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_input+0x180>
  70c436:	49 83 be 88 05 00 00 	cmpq   $0xffffffffffffffff,0x588(%r14)
  70c43d:	ff 
  70c43e:	74 0e                	je     70c44e <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_input+0x18e>
  70c440:	49 8b 96 90 06 00 00 	mov    0x690(%r14),%rdx
  70c447:	b9 01 00 00 00       	mov    $0x1,%ecx
  70c44c:	eb 02                	jmp    70c450 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_input+0x190>
  70c44e:	31 c9                	xor    %ecx,%ecx
  70c450:	49 8b b6 08 07 00 00 	mov    0x708(%r14),%rsi
  70c457:	48 89 4b 08          	mov    %rcx,0x8(%rbx)
  70c45b:	48 89 53 10          	mov    %rdx,0x10(%rbx)
  70c45f:	0f 11 43 18          	movups %xmm0,0x18(%rbx)
  70c463:	48 89 73 28          	mov    %rsi,0x28(%rbx)
  70c467:	88 43 30             	mov    %al,0x30(%rbx)
  70c46a:	48 c7 03 fe ff ff ff 	movq   $0xfffffffffffffffe,(%rbx)
  70c471:	48 83 c4 40          	add    $0x40,%rsp
  70c475:	5b                   	pop    %rbx
  70c476:	41 5c                	pop    %r12
  70c478:	41 5d                	pop    %r13
  70c47a:	41 5e                	pop    %r14
  70c47c:	41 5f                	pop    %r15
  70c47e:	c3                   	ret
  70c47f:	48 8d 3d 4a 7c 3c 00 	lea    0x3c7c4a(%rip),%rdi        # ad40d0 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0x858>
  70c486:	ff 15 14 5c 3f 00    	call   *0x3f5c14(%rip)        # b020a0 <_DYNAMIC+0x288>
  70c48c:	48 8d 3d 55 76 3c 00 	lea    0x3c7655(%rip),%rdi        # ad3ae8 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0x270>
  70c493:	ff 15 07 5c 3f 00    	call   *0x3f5c07(%rip)        # b020a0 <_DYNAMIC+0x288>
  70c499:	48 c7 03 1f 00 00 00 	movq   $0x1f,(%rbx)
  70c4a0:	eb cf                	jmp    70c471 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_input+0x1b1>
  70c4a2:	48 8d 15 0f 7c 3c 00 	lea    0x3c7c0f(%rip),%rdx        # ad40b8 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0x840>
  70c4a9:	4c 89 e7             	mov    %r12,%rdi
  70c4ac:	ff 15 de 5c 3f 00    	call   *0x3f5cde(%rip)        # b02190 <_DYNAMIC+0x378>
  70c4b2:	48 8d 15 17 76 3c 00 	lea    0x3c7617(%rip),%rdx        # ad3ad0 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0x258>
  70c4b9:	ff 15 d1 5c 3f 00    	call   *0x3f5cd1(%rip)        # b02190 <_DYNAMIC+0x378>
