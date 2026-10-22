
/tmp/gpui-style-startup-current-target/release/examples/literal_startup:     file format elf64-x86-64


Disassembly of section .text:

00000000004ec180 <literal_startup::literal_recipe_probe>:
  4ec180:	41 57                	push   %r15
  4ec182:	41 56                	push   %r14
  4ec184:	41 54                	push   %r12
  4ec186:	53                   	push   %rbx
  4ec187:	48 81 ec f8 01 00 00 	sub    $0x1f8,%rsp
  4ec18e:	49 89 d6             	mov    %rdx,%r14
  4ec191:	48 89 fb             	mov    %rdi,%rbx
  4ec194:	0f 10 05 d5 c2 b5 ff 	movups -0x4a3d2b(%rip),%xmm0        # 48470 <anon.84f3eb709a5e1c644c293c71a31fec4f.18.llvm.9023340620128679272>
  4ec19b:	0f 11 44 24 10       	movups %xmm0,0x10(%rsp)
  4ec1a0:	0f 10 0d d9 c2 b5 ff 	movups -0x4a3d27(%rip),%xmm1        # 48480 <anon.84f3eb709a5e1c644c293c71a31fec4f.18.llvm.9023340620128679272+0x10>
  4ec1a7:	0f 11 4c 24 20       	movups %xmm1,0x20(%rsp)
  4ec1ac:	0f 10 15 dd c2 b5 ff 	movups -0x4a3d23(%rip),%xmm2        # 48490 <anon.84f3eb709a5e1c644c293c71a31fec4f.18.llvm.9023340620128679272+0x20>
  4ec1b3:	0f 11 54 24 30       	movups %xmm2,0x30(%rsp)
  4ec1b8:	0f 10 1d e1 c2 b5 ff 	movups -0x4a3d1f(%rip),%xmm3        # 484a0 <anon.84f3eb709a5e1c644c293c71a31fec4f.18.llvm.9023340620128679272+0x30>
  4ec1bf:	0f 11 5c 24 40       	movups %xmm3,0x40(%rsp)
  4ec1c4:	0f 10 25 e5 c2 b5 ff 	movups -0x4a3d1b(%rip),%xmm4        # 484b0 <anon.84f3eb709a5e1c644c293c71a31fec4f.18.llvm.9023340620128679272+0x40>
  4ec1cb:	0f 11 64 24 50       	movups %xmm4,0x50(%rsp)
  4ec1d0:	48 b8 00 00 00 00 01 	movabs $0x3000100000000,%rax
  4ec1d7:	00 03 00 
  4ec1da:	48 89 44 24 60       	mov    %rax,0x60(%rsp)
  4ec1df:	0f 57 ed             	xorps  %xmm5,%xmm5
  4ec1e2:	0f 11 ac 24 88 00 00 	movups %xmm5,0x88(%rsp)
  4ec1e9:	00 
  4ec1ea:	48 c7 84 24 98 00 00 	movq   $0x0,0x98(%rsp)
  4ec1f1:	00 00 00 00 00 
  4ec1f6:	48 c7 84 24 a0 00 00 	movq   $0x8,0xa0(%rsp)
  4ec1fd:	00 08 00 00 00 
  4ec202:	48 c7 84 24 a8 00 00 	movq   $0x0,0xa8(%rsp)
  4ec209:	00 00 00 00 00 
  4ec20e:	48 c7 84 24 b0 00 00 	movq   $0xffffffffffffffff,0xb0(%rsp)
  4ec215:	00 ff ff ff ff 
  4ec21a:	0f 10 2c 24          	movups (%rsp),%xmm5
  4ec21e:	0f 11 ac 24 b8 00 00 	movups %xmm5,0xb8(%rsp)
  4ec225:	00 
  4ec226:	0f 11 84 24 c8 00 00 	movups %xmm0,0xc8(%rsp)
  4ec22d:	00 
  4ec22e:	0f 11 8c 24 d8 00 00 	movups %xmm1,0xd8(%rsp)
  4ec235:	00 
  4ec236:	0f 11 94 24 e8 00 00 	movups %xmm2,0xe8(%rsp)
  4ec23d:	00 
  4ec23e:	0f 11 9c 24 f8 00 00 	movups %xmm3,0xf8(%rsp)
  4ec245:	00 
  4ec246:	0f 11 a4 24 08 01 00 	movups %xmm4,0x108(%rsp)
  4ec24d:	00 
  4ec24e:	48 89 84 24 18 01 00 	mov    %rax,0x118(%rsp)
  4ec255:	00 
  4ec256:	48 c7 84 24 20 01 00 	movq   $0x0,0x120(%rsp)
  4ec25d:	00 00 00 00 00 
  4ec262:	0f 10 84 24 80 00 00 	movups 0x80(%rsp),%xmm0
  4ec269:	00 
  4ec26a:	0f 11 84 24 28 01 00 	movups %xmm0,0x128(%rsp)
  4ec271:	00 
  4ec272:	48 8b 84 24 90 00 00 	mov    0x90(%rsp),%rax
  4ec279:	00 
  4ec27a:	48 89 84 24 38 01 00 	mov    %rax,0x138(%rsp)
  4ec281:	00 
  4ec282:	c6 84 24 40 01 00 00 	movb   $0x0,0x140(%rsp)
  4ec289:	00 
  4ec28a:	89 f0                	mov    %esi,%eax
  4ec28c:	0f 57 c0             	xorps  %xmm0,%xmm0
  4ec28f:	f2 48 0f 2a c0       	cvtsi2sd %rax,%xmm0
  4ec294:	48 c7 44 24 70 00 00 	movq   $0x0,0x70(%rsp)
  4ec29b:	00 00 
  4ec29d:	f2 0f 11 44 24 78    	movsd  %xmm0,0x78(%rsp)
  4ec2a3:	4c 8d bc 24 48 01 00 	lea    0x148(%rsp),%r15
  4ec2aa:	00 
  4ec2ab:	48 8d b4 24 98 00 00 	lea    0x98(%rsp),%rsi
  4ec2b2:	00 
  4ec2b3:	48 8d 4c 24 70       	lea    0x70(%rsp),%rcx
  4ec2b8:	4c 89 ff             	mov    %r15,%rdi
  4ec2bb:	ba 01 00 00 00       	mov    $0x1,%edx
  4ec2c0:	e8 5b d7 00 00       	call   4f9a20 <<gpui::element::El>::property_operand::<f64>>
  4ec2c5:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  4ec2cc:	00 
  4ec2cd:	48 b8 00 00 00 00 00 	movabs $0x4034000000000000,%rax
  4ec2d4:	00 34 40 
  4ec2d7:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  4ec2dc:	4c 8d a4 24 98 00 00 	lea    0x98(%rsp),%r12
  4ec2e3:	00 
  4ec2e4:	48 89 e1             	mov    %rsp,%rcx
  4ec2e7:	4c 89 e7             	mov    %r12,%rdi
  4ec2ea:	4c 89 fe             	mov    %r15,%rsi
  4ec2ed:	ba 02 00 00 00       	mov    $0x2,%edx
  4ec2f2:	e8 29 d7 00 00       	call   4f9a20 <<gpui::element::El>::property_operand::<f64>>
  4ec2f7:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  4ec2fe:	00 
  4ec2ff:	48 b8 00 00 00 00 00 	movabs $0x4010000000000000,%rax
  4ec306:	00 10 40 
  4ec309:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  4ec30e:	4c 8d bc 24 48 01 00 	lea    0x148(%rsp),%r15
  4ec315:	00 
  4ec316:	48 89 e1             	mov    %rsp,%rcx
  4ec319:	4c 89 ff             	mov    %r15,%rdi
  4ec31c:	4c 89 e6             	mov    %r12,%rsi
  4ec31f:	ba 04 00 00 00       	mov    $0x4,%edx
  4ec324:	e8 f7 d6 00 00       	call   4f9a20 <<gpui::element::El>::property_operand::<f64>>
  4ec329:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  4ec330:	00 
  4ec331:	48 b8 00 00 00 00 00 	movabs $0x4030000000000000,%rax
  4ec338:	00 30 40 
  4ec33b:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  4ec340:	4c 8d a4 24 98 00 00 	lea    0x98(%rsp),%r12
  4ec347:	00 
  4ec348:	48 89 e1             	mov    %rsp,%rcx
  4ec34b:	4c 89 e7             	mov    %r12,%rdi
  4ec34e:	4c 89 fe             	mov    %r15,%rsi
  4ec351:	ba 05 00 00 00       	mov    $0x5,%edx
  4ec356:	e8 c5 d6 00 00       	call   4f9a20 <<gpui::element::El>::property_operand::<f64>>
  4ec35b:	c7 04 24 00 00 00 00 	movl   $0x0,(%rsp)
  4ec362:	41 0f 10 06          	movups (%r14),%xmm0
  4ec366:	0f 11 44 24 04       	movups %xmm0,0x4(%rsp)
  4ec36b:	4c 8d bc 24 48 01 00 	lea    0x148(%rsp),%r15
  4ec372:	00 
  4ec373:	48 89 e1             	mov    %rsp,%rcx
  4ec376:	4c 89 ff             	mov    %r15,%rdi
  4ec379:	4c 89 e6             	mov    %r12,%rsi
  4ec37c:	ba 06 00 00 00       	mov    $0x6,%edx
  4ec381:	e8 da d2 00 00       	call   4f9660 <<gpui::element::El>::property_operand::<gpui_canvas::color::Color>>
  4ec386:	c7 04 24 00 00 00 00 	movl   $0x0,(%rsp)
  4ec38d:	41 0f 10 06          	movups (%r14),%xmm0
  4ec391:	0f 11 44 24 04       	movups %xmm0,0x4(%rsp)
  4ec396:	4c 8d b4 24 98 00 00 	lea    0x98(%rsp),%r14
  4ec39d:	00 
  4ec39e:	48 89 e1             	mov    %rsp,%rcx
  4ec3a1:	4c 89 f7             	mov    %r14,%rdi
  4ec3a4:	4c 89 fe             	mov    %r15,%rsi
  4ec3a7:	ba 07 00 00 00       	mov    $0x7,%edx
  4ec3ac:	e8 af d2 00 00       	call   4f9660 <<gpui::element::El>::property_operand::<gpui_canvas::color::Color>>
  4ec3b1:	0f 28 05 68 b9 b5 ff 	movaps -0x4a4698(%rip),%xmm0        # 47d20 <anon.5f884de6e78125e25881320d811d32df.391.llvm.17146438997930651657+0x12b0>
  4ec3b8:	0f 29 04 24          	movaps %xmm0,(%rsp)
  4ec3bc:	f2 0f 10 05 cc af b5 	movsd  -0x4a5034(%rip),%xmm0        # 47390 <anon.5f884de6e78125e25881320d811d32df.391.llvm.17146438997930651657+0x920>
  4ec3c3:	ff 
  4ec3c4:	f2 0f 11 44 24 10    	movsd  %xmm0,0x10(%rsp)
  4ec3ca:	4c 8d bc 24 48 01 00 	lea    0x148(%rsp),%r15
  4ec3d1:	00 
  4ec3d2:	48 89 e2             	mov    %rsp,%rdx
  4ec3d5:	4c 89 ff             	mov    %r15,%rdi
  4ec3d8:	4c 89 f6             	mov    %r14,%rsi
  4ec3db:	e8 c0 e5 00 00       	call   4fa9a0 <<gpui::element::El>::transform::<gpui_reactivity_core::geometry::Affine>>
  4ec3e0:	48 b8 01 00 00 00 08 	movabs $0x800000001,%rax
  4ec3e7:	00 00 00 
  4ec3ea:	48 89 84 24 98 00 00 	mov    %rax,0x98(%rsp)
  4ec3f1:	00 
  4ec3f2:	c7 84 24 a0 00 00 00 	movl   $0x20000,0xa0(%rsp)
  4ec3f9:	00 00 02 00 
  4ec3fd:	48 8d b4 24 98 00 00 	lea    0x98(%rsp),%rsi
  4ec404:	00 
  4ec405:	48 89 df             	mov    %rbx,%rdi
  4ec408:	4c 89 fa             	mov    %r15,%rdx
  4ec40b:	e8 f0 77 01 00       	call   503c00 <<gpui::style::Flex<i32> as gpui::style::FlexRecipe>::apply_to>
  4ec410:	48 89 d8             	mov    %rbx,%rax
  4ec413:	48 81 c4 f8 01 00 00 	add    $0x1f8,%rsp
  4ec41a:	5b                   	pop    %rbx
  4ec41b:	41 5c                	pop    %r12
  4ec41d:	41 5e                	pop    %r14
  4ec41f:	41 5f                	pop    %r15
  4ec421:	c3                   	ret
