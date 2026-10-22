
/tmp/gpui-contained-property-exchange-target/release/deps/unit_action_cost-bcf457ce7db1ee75:     file format elf64-x86-64


Disassembly of section .text:

000000000070c1e0 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_input>:
  70c1e0:	41 57                	push   %r15
  70c1e2:	41 56                	push   %r14
  70c1e4:	41 55                	push   %r13
  70c1e6:	41 54                	push   %r12
  70c1e8:	53                   	push   %rbx
  70c1e9:	48 83 ec 40          	sub    $0x40,%rsp
  70c1ed:	48 89 fb             	mov    %rdi,%rbx
  70c1f0:	80 be 22 07 00 00 00 	cmpb   $0x0,0x722(%rsi)
  70c1f7:	74 0c                	je     70c205 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_input+0x25>
  70c1f9:	48 c7 03 0e 00 00 00 	movq   $0xe,(%rbx)
  70c200:	e9 8c 01 00 00       	jmp    70c391 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_input+0x1b1>
  70c205:	4d 89 c7             	mov    %r8,%r15
  70c208:	49 89 f6             	mov    %rsi,%r14
  70c20b:	48 8d 7c 24 08       	lea    0x8(%rsp),%rdi
  70c210:	e8 eb e4 ff ff       	call   70a700 <<gpui::runtime::Runtime<unit_action_cost::Model>>::input_index>
  70c215:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  70c21a:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  70c21f:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  70c223:	0f 85 e2 00 00 00    	jne    70c30b <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_input+0x12b>
  70c229:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  70c230:	49 39 f4             	cmp    %rsi,%r12
  70c233:	0f 83 89 01 00 00    	jae    70c3c2 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_input+0x1e2>
  70c239:	4b 8d 04 a4          	lea    (%r12,%r12,4),%rax
  70c23d:	49 8b 8e 98 02 00 00 	mov    0x298(%r14),%rcx
  70c244:	8b 7c c1 20          	mov    0x20(%rcx,%rax,8),%edi
  70c248:	89 f8                	mov    %edi,%eax
  70c24a:	83 e0 07             	and    $0x7,%eax
  70c24d:	83 f8 06             	cmp    $0x6,%eax
  70c250:	0f 84 49 01 00 00    	je     70c39f <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_input+0x1bf>
  70c256:	c1 ef 03             	shr    $0x3,%edi
  70c259:	0f 84 40 01 00 00    	je     70c39f <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_input+0x1bf>
  70c25f:	49 8b b6 b8 02 00 00 	mov    0x2b8(%r14),%rsi
  70c266:	ff cf                	dec    %edi
  70c268:	48 39 fe             	cmp    %rdi,%rsi
  70c26b:	0f 86 61 01 00 00    	jbe    70c3d2 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_input+0x1f2>
  70c271:	49 8b 86 b0 02 00 00 	mov    0x2b0(%r14),%rax
  70c278:	48 8d 0c bf          	lea    (%rdi,%rdi,4),%rcx
  70c27c:	48 c1 e1 04          	shl    $0x4,%rcx
  70c280:	48 83 3c 08 fe       	cmpq   $0xfffffffffffffffe,(%rax,%rcx,1)
  70c285:	0f 84 21 01 00 00    	je     70c3ac <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_input+0x1cc>
  70c28b:	48 01 c8             	add    %rcx,%rax
  70c28e:	48 8b 78 40          	mov    0x40(%rax),%rdi
  70c292:	48 8b 37             	mov    (%rdi),%rsi
  70c295:	48 d1 ee             	shr    $1,%rsi
  70c298:	48 83 c7 10          	add    $0x10,%rdi
  70c29c:	4c 89 fa             	mov    %r15,%rdx
  70c29f:	ff 15 5b 5f 3f 00    	call   *0x3f5f5b(%rip)        # b02200 <_DYNAMIC+0x4b8>
  70c2a5:	84 c0                	test   %al,%al
  70c2a7:	0f 84 82 00 00 00    	je     70c32f <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_input+0x14f>
  70c2ad:	4d 8b ae 60 06 00 00 	mov    0x660(%r14),%r13
  70c2b4:	49 ff c5             	inc    %r13
  70c2b7:	0f 84 fc 00 00 00    	je     70c3b9 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_input+0x1d9>
  70c2bd:	49 c7 86 08 07 00 00 	movq   $0x0,0x708(%r14)
  70c2c4:	00 00 00 00 
  70c2c8:	4c 89 f7             	mov    %r14,%rdi
  70c2cb:	4c 89 e6             	mov    %r12,%rsi
  70c2ce:	4c 89 fa             	mov    %r15,%rdx
  70c2d1:	e8 4a e5 ff ff       	call   70a820 <<gpui::runtime::Runtime<unit_action_cost::Model>>::set_selection>
  70c2d6:	84 c0                	test   %al,%al
  70c2d8:	74 5e                	je     70c338 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_input+0x158>
  70c2da:	4d 89 ae 60 06 00 00 	mov    %r13,0x660(%r14)
  70c2e1:	49 ff 86 b0 06 00 00 	incq   0x6b0(%r14)
  70c2e8:	49 c7 86 08 07 00 00 	movq   $0x1,0x708(%r14)
  70c2ef:	01 00 00 00 
  70c2f3:	48 89 df             	mov    %rbx,%rdi
  70c2f6:	4c 89 f6             	mov    %r14,%rsi
  70c2f9:	48 83 c4 40          	add    $0x40,%rsp
  70c2fd:	5b                   	pop    %rbx
  70c2fe:	41 5c                	pop    %r12
  70c300:	41 5d                	pop    %r13
  70c302:	41 5e                	pop    %r14
  70c304:	41 5f                	pop    %r15
  70c306:	e9 75 22 01 00       	jmp    71e580 <<gpui::runtime::Runtime<unit_action_cost::Model>>::present>
  70c30b:	48 8b 4c 24 38       	mov    0x38(%rsp),%rcx
  70c310:	48 89 4b 30          	mov    %rcx,0x30(%rbx)
  70c314:	0f 10 44 24 18       	movups 0x18(%rsp),%xmm0
  70c319:	0f 10 4c 24 28       	movups 0x28(%rsp),%xmm1
  70c31e:	0f 11 4b 20          	movups %xmm1,0x20(%rbx)
  70c322:	0f 11 43 10          	movups %xmm0,0x10(%rbx)
  70c326:	48 89 03             	mov    %rax,(%rbx)
  70c329:	4c 89 63 08          	mov    %r12,0x8(%rbx)
  70c32d:	eb 62                	jmp    70c391 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_input+0x1b1>
  70c32f:	48 c7 03 18 00 00 00 	movq   $0x18,(%rbx)
  70c336:	eb 59                	jmp    70c391 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_input+0x1b1>
  70c338:	41 0f 10 86 60 06 00 	movups 0x660(%r14),%xmm0
  70c33f:	00 
  70c340:	41 0f b6 86 20 07 00 	movzbl 0x720(%r14),%eax
  70c347:	00 
  70c348:	49 83 be 80 06 00 00 	cmpq   $0x0,0x680(%r14)
  70c34f:	00 
  70c350:	74 1c                	je     70c36e <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_input+0x18e>
  70c352:	84 c0                	test   %al,%al
  70c354:	74 0a                	je     70c360 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_input+0x180>
  70c356:	49 83 be 88 05 00 00 	cmpq   $0xffffffffffffffff,0x588(%r14)
  70c35d:	ff 
  70c35e:	74 0e                	je     70c36e <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_input+0x18e>
  70c360:	49 8b 96 90 06 00 00 	mov    0x690(%r14),%rdx
  70c367:	b9 01 00 00 00       	mov    $0x1,%ecx
  70c36c:	eb 02                	jmp    70c370 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_input+0x190>
  70c36e:	31 c9                	xor    %ecx,%ecx
  70c370:	49 8b b6 08 07 00 00 	mov    0x708(%r14),%rsi
  70c377:	48 89 4b 08          	mov    %rcx,0x8(%rbx)
  70c37b:	48 89 53 10          	mov    %rdx,0x10(%rbx)
  70c37f:	0f 11 43 18          	movups %xmm0,0x18(%rbx)
  70c383:	48 89 73 28          	mov    %rsi,0x28(%rbx)
  70c387:	88 43 30             	mov    %al,0x30(%rbx)
  70c38a:	48 c7 03 fe ff ff ff 	movq   $0xfffffffffffffffe,(%rbx)
  70c391:	48 83 c4 40          	add    $0x40,%rsp
  70c395:	5b                   	pop    %rbx
  70c396:	41 5c                	pop    %r12
  70c398:	41 5d                	pop    %r13
  70c39a:	41 5e                	pop    %r14
  70c39c:	41 5f                	pop    %r15
  70c39e:	c3                   	ret
  70c39f:	48 8d 3d 9a 7c 3c 00 	lea    0x3c7c9a(%rip),%rdi        # ad4040 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0x858>
  70c3a6:	ff 15 24 5c 3f 00    	call   *0x3f5c24(%rip)        # b01fd0 <_DYNAMIC+0x288>
  70c3ac:	48 8d 3d a5 76 3c 00 	lea    0x3c76a5(%rip),%rdi        # ad3a58 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0x270>
  70c3b3:	ff 15 17 5c 3f 00    	call   *0x3f5c17(%rip)        # b01fd0 <_DYNAMIC+0x288>
  70c3b9:	48 c7 03 1f 00 00 00 	movq   $0x1f,(%rbx)
  70c3c0:	eb cf                	jmp    70c391 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_input+0x1b1>
  70c3c2:	48 8d 15 5f 7c 3c 00 	lea    0x3c7c5f(%rip),%rdx        # ad4028 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0x840>
  70c3c9:	4c 89 e7             	mov    %r12,%rdi
  70c3cc:	ff 15 ee 5c 3f 00    	call   *0x3f5cee(%rip)        # b020c0 <_DYNAMIC+0x378>
  70c3d2:	48 8d 15 67 76 3c 00 	lea    0x3c7667(%rip),%rdx        # ad3a40 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0x258>
  70c3d9:	ff 15 e1 5c 3f 00    	call   *0x3f5ce1(%rip)        # b020c0 <_DYNAMIC+0x378>
