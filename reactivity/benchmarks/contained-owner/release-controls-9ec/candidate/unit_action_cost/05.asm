
/tmp/gpui-contained-owner-spike-target/release/deps/unit_action_cost-bcf457ce7db1ee75:     file format elf64-x86-64


Disassembly of section .text:

000000000070e330 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::reject_editor>:
  70e330:	48 8b 86 10 06 00 00 	mov    0x610(%rsi),%rax
  70e337:	48 85 c0             	test   %rax,%rax
  70e33a:	0f 84 f4 00 00 00    	je     70e434 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::reject_editor+0x104>
  70e340:	48 8b 80 d8 00 00 00 	mov    0xd8(%rax),%rax
  70e347:	48 85 c0             	test   %rax,%rax
  70e34a:	0f 84 e4 00 00 00    	je     70e434 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::reject_editor+0x104>
  70e350:	89 d1                	mov    %edx,%ecx
  70e352:	c1 e9 08             	shr    $0x8,%ecx
  70e355:	44 0f b6 40 13       	movzbl 0x13(%rax),%r8d
  70e35a:	41 80 f8 ff          	cmp    $0xff,%r8b
  70e35e:	0f 84 8e 00 00 00    	je     70e3f2 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::reject_editor+0xc2>
  70e364:	45 31 c9             	xor    %r9d,%r9d
  70e367:	41 80 f8 06          	cmp    $0x6,%r8b
  70e36b:	41 0f 92 c1          	setb   %r9b
  70e36f:	41 0f 93 c2          	setae  %r10b
  70e373:	41 38 d0             	cmp    %dl,%r8b
  70e376:	41 0f 94 c3          	sete   %r11b
  70e37a:	45 20 d3             	and    %r10b,%r11b
  70e37d:	80 fa 06             	cmp    $0x6,%dl
  70e380:	45 0f b6 d3          	movzbl %r11b,%r10d
  70e384:	45 0f 43 ca          	cmovae %r10d,%r9d
  70e388:	45 84 c9             	test   %r9b,%r9b
  70e38b:	74 65                	je     70e3f2 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::reject_editor+0xc2>
  70e38d:	41 80 f8 05          	cmp    $0x5,%r8b
  70e391:	77 2b                	ja     70e3be <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::reject_editor+0x8e>
  70e393:	41 38 d0             	cmp    %dl,%r8b
  70e396:	75 5a                	jne    70e3f2 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::reject_editor+0xc2>
  70e398:	44 0f b7 c1          	movzwl %cx,%r8d
  70e39c:	80 fa 05             	cmp    $0x5,%dl
  70e39f:	74 0a                	je     70e3ab <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::reject_editor+0x7b>
  70e3a1:	44 0f b6 ca          	movzbl %dl,%r9d
  70e3a5:	41 83 f9 04          	cmp    $0x4,%r9d
  70e3a9:	75 13                	jne    70e3be <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::reject_editor+0x8e>
  70e3ab:	44 38 40 14          	cmp    %r8b,0x14(%rax)
  70e3af:	75 41                	jne    70e3f2 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::reject_editor+0xc2>
  70e3b1:	41 89 d0             	mov    %edx,%r8d
  70e3b4:	41 c1 e8 10          	shr    $0x10,%r8d
  70e3b8:	44 38 40 15          	cmp    %r8b,0x15(%rax)
  70e3bc:	75 34                	jne    70e3f2 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::reject_editor+0xc2>
  70e3be:	0f 10 86 60 06 00 00 	movups 0x660(%rsi),%xmm0
  70e3c5:	0f b6 86 20 07 00 00 	movzbl 0x720(%rsi),%eax
  70e3cc:	48 83 be 80 06 00 00 	cmpq   $0x0,0x680(%rsi)
  70e3d3:	00 
  70e3d4:	74 3a                	je     70e410 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::reject_editor+0xe0>
  70e3d6:	84 c0                	test   %al,%al
  70e3d8:	74 0a                	je     70e3e4 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::reject_editor+0xb4>
  70e3da:	48 83 be 88 05 00 00 	cmpq   $0xffffffffffffffff,0x588(%rsi)
  70e3e1:	ff 
  70e3e2:	74 2c                	je     70e410 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::reject_editor+0xe0>
  70e3e4:	48 8b 96 90 06 00 00 	mov    0x690(%rsi),%rdx
  70e3eb:	b9 01 00 00 00       	mov    $0x1,%ecx
  70e3f0:	eb 20                	jmp    70e412 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::reject_editor+0xe2>
  70e3f2:	88 50 13             	mov    %dl,0x13(%rax)
  70e3f5:	66 89 48 14          	mov    %cx,0x14(%rax)
  70e3f9:	48 c7 86 08 07 00 00 	movq   $0x0,0x708(%rsi)
  70e400:	00 00 00 00 
  70e404:	c6 86 1f 07 00 00 01 	movb   $0x1,0x71f(%rsi)
  70e40b:	e9 50 02 01 00       	jmp    71e660 <<gpui::runtime::Runtime<unit_action_cost::Model>>::present>
  70e410:	31 c9                	xor    %ecx,%ecx
  70e412:	48 8b b6 08 07 00 00 	mov    0x708(%rsi),%rsi
  70e419:	48 89 4f 08          	mov    %rcx,0x8(%rdi)
  70e41d:	48 89 57 10          	mov    %rdx,0x10(%rdi)
  70e421:	0f 11 47 18          	movups %xmm0,0x18(%rdi)
  70e425:	48 89 77 28          	mov    %rsi,0x28(%rdi)
  70e429:	88 47 30             	mov    %al,0x30(%rdi)
  70e42c:	48 c7 07 fe ff ff ff 	movq   $0xfffffffffffffffe,(%rdi)
  70e433:	c3                   	ret
  70e434:	50                   	push   %rax
  70e435:	48 8d 3d 29 b0 95 ff 	lea    -0x6a4fd7(%rip),%rdi        # 69465 <anon.079f5e587c394fcac2765eb4d0cf0bc2.119.llvm.6319143315422321905+0x2c45>
  70e43c:	48 8d 15 05 5d 3c 00 	lea    0x3c5d05(%rip),%rdx        # ad4148 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0x8d0>
  70e443:	be 11 00 00 00       	mov    $0x11,%esi
  70e448:	ff 15 32 3d 3f 00    	call   *0x3f3d32(%rip)        # b02180 <_DYNAMIC+0x368>
