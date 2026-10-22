
/tmp/gpui-style-startup-current-target/release/examples/literal_startup:     file format elf64-x86-64


Disassembly of section .text:

00000000004ec430 <literal_startup::literal_builder_probe>:
  4ec430:	41 57                	push   %r15
  4ec432:	41 56                	push   %r14
  4ec434:	41 54                	push   %r12
  4ec436:	53                   	push   %rbx
  4ec437:	48 81 ec f8 01 00 00 	sub    $0x1f8,%rsp
  4ec43e:	49 89 d6             	mov    %rdx,%r14
  4ec441:	48 89 fb             	mov    %rdi,%rbx
  4ec444:	0f 10 05 25 c0 b5 ff 	movups -0x4a3fdb(%rip),%xmm0        # 48470 <anon.84f3eb709a5e1c644c293c71a31fec4f.18.llvm.9023340620128679272>
  4ec44b:	0f 11 44 24 10       	movups %xmm0,0x10(%rsp)
  4ec450:	0f 10 0d 29 c0 b5 ff 	movups -0x4a3fd7(%rip),%xmm1        # 48480 <anon.84f3eb709a5e1c644c293c71a31fec4f.18.llvm.9023340620128679272+0x10>
  4ec457:	0f 11 4c 24 20       	movups %xmm1,0x20(%rsp)
  4ec45c:	0f 10 15 2d c0 b5 ff 	movups -0x4a3fd3(%rip),%xmm2        # 48490 <anon.84f3eb709a5e1c644c293c71a31fec4f.18.llvm.9023340620128679272+0x20>
  4ec463:	0f 11 54 24 30       	movups %xmm2,0x30(%rsp)
  4ec468:	0f 10 1d 31 c0 b5 ff 	movups -0x4a3fcf(%rip),%xmm3        # 484a0 <anon.84f3eb709a5e1c644c293c71a31fec4f.18.llvm.9023340620128679272+0x30>
  4ec46f:	0f 11 5c 24 40       	movups %xmm3,0x40(%rsp)
  4ec474:	0f 10 25 35 c0 b5 ff 	movups -0x4a3fcb(%rip),%xmm4        # 484b0 <anon.84f3eb709a5e1c644c293c71a31fec4f.18.llvm.9023340620128679272+0x40>
  4ec47b:	0f 11 64 24 50       	movups %xmm4,0x50(%rsp)
  4ec480:	48 b8 00 00 00 00 01 	movabs $0x3000100000000,%rax
  4ec487:	00 03 00 
  4ec48a:	48 89 44 24 60       	mov    %rax,0x60(%rsp)
  4ec48f:	0f 57 ed             	xorps  %xmm5,%xmm5
  4ec492:	0f 11 ac 24 88 00 00 	movups %xmm5,0x88(%rsp)
  4ec499:	00 
  4ec49a:	48 c7 84 24 98 00 00 	movq   $0x0,0x98(%rsp)
  4ec4a1:	00 00 00 00 00 
  4ec4a6:	48 c7 84 24 a0 00 00 	movq   $0x8,0xa0(%rsp)
  4ec4ad:	00 08 00 00 00 
  4ec4b2:	48 c7 84 24 a8 00 00 	movq   $0x0,0xa8(%rsp)
  4ec4b9:	00 00 00 00 00 
  4ec4be:	48 c7 84 24 b0 00 00 	movq   $0xffffffffffffffff,0xb0(%rsp)
  4ec4c5:	00 ff ff ff ff 
  4ec4ca:	0f 10 2c 24          	movups (%rsp),%xmm5
  4ec4ce:	0f 11 ac 24 b8 00 00 	movups %xmm5,0xb8(%rsp)
  4ec4d5:	00 
  4ec4d6:	0f 11 84 24 c8 00 00 	movups %xmm0,0xc8(%rsp)
  4ec4dd:	00 
  4ec4de:	0f 11 8c 24 d8 00 00 	movups %xmm1,0xd8(%rsp)
  4ec4e5:	00 
  4ec4e6:	0f 11 94 24 e8 00 00 	movups %xmm2,0xe8(%rsp)
  4ec4ed:	00 
  4ec4ee:	0f 11 9c 24 f8 00 00 	movups %xmm3,0xf8(%rsp)
  4ec4f5:	00 
  4ec4f6:	0f 11 a4 24 08 01 00 	movups %xmm4,0x108(%rsp)
  4ec4fd:	00 
  4ec4fe:	48 89 84 24 18 01 00 	mov    %rax,0x118(%rsp)
  4ec505:	00 
  4ec506:	48 c7 84 24 20 01 00 	movq   $0x0,0x120(%rsp)
  4ec50d:	00 00 00 00 00 
  4ec512:	0f 10 84 24 80 00 00 	movups 0x80(%rsp),%xmm0
  4ec519:	00 
  4ec51a:	0f 11 84 24 28 01 00 	movups %xmm0,0x128(%rsp)
  4ec521:	00 
  4ec522:	48 8b 84 24 90 00 00 	mov    0x90(%rsp),%rax
  4ec529:	00 
  4ec52a:	48 89 84 24 38 01 00 	mov    %rax,0x138(%rsp)
  4ec531:	00 
  4ec532:	c6 84 24 40 01 00 00 	movb   $0x0,0x140(%rsp)
  4ec539:	00 
  4ec53a:	89 f0                	mov    %esi,%eax
  4ec53c:	0f 57 c0             	xorps  %xmm0,%xmm0
  4ec53f:	f2 48 0f 2a c0       	cvtsi2sd %rax,%xmm0
  4ec544:	48 c7 44 24 70 00 00 	movq   $0x0,0x70(%rsp)
  4ec54b:	00 00 
  4ec54d:	f2 0f 11 44 24 78    	movsd  %xmm0,0x78(%rsp)
  4ec553:	4c 8d bc 24 48 01 00 	lea    0x148(%rsp),%r15
  4ec55a:	00 
  4ec55b:	48 8d b4 24 98 00 00 	lea    0x98(%rsp),%rsi
  4ec562:	00 
  4ec563:	48 8d 4c 24 70       	lea    0x70(%rsp),%rcx
  4ec568:	4c 89 ff             	mov    %r15,%rdi
  4ec56b:	ba 01 00 00 00       	mov    $0x1,%edx
  4ec570:	e8 ab d4 00 00       	call   4f9a20 <<gpui::element::El>::property_operand::<f64>>
  4ec575:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  4ec57c:	00 
  4ec57d:	48 b8 00 00 00 00 00 	movabs $0x4034000000000000,%rax
  4ec584:	00 34 40 
  4ec587:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  4ec58c:	4c 8d a4 24 98 00 00 	lea    0x98(%rsp),%r12
  4ec593:	00 
  4ec594:	48 89 e1             	mov    %rsp,%rcx
  4ec597:	4c 89 e7             	mov    %r12,%rdi
  4ec59a:	4c 89 fe             	mov    %r15,%rsi
  4ec59d:	ba 02 00 00 00       	mov    $0x2,%edx
  4ec5a2:	e8 79 d4 00 00       	call   4f9a20 <<gpui::element::El>::property_operand::<f64>>
  4ec5a7:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  4ec5ae:	00 
  4ec5af:	48 b8 00 00 00 00 00 	movabs $0x4020000000000000,%rax
  4ec5b6:	00 20 40 
  4ec5b9:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  4ec5be:	4c 8d bc 24 48 01 00 	lea    0x148(%rsp),%r15
  4ec5c5:	00 
  4ec5c6:	48 89 e1             	mov    %rsp,%rcx
  4ec5c9:	4c 89 ff             	mov    %r15,%rdi
  4ec5cc:	4c 89 e6             	mov    %r12,%rsi
  4ec5cf:	ba 03 00 00 00       	mov    $0x3,%edx
  4ec5d4:	e8 47 d4 00 00       	call   4f9a20 <<gpui::element::El>::property_operand::<f64>>
  4ec5d9:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  4ec5e0:	00 
  4ec5e1:	48 b8 00 00 00 00 00 	movabs $0x4010000000000000,%rax
  4ec5e8:	00 10 40 
  4ec5eb:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  4ec5f0:	4c 8d a4 24 98 00 00 	lea    0x98(%rsp),%r12
  4ec5f7:	00 
  4ec5f8:	48 89 e1             	mov    %rsp,%rcx
  4ec5fb:	4c 89 e7             	mov    %r12,%rdi
  4ec5fe:	4c 89 fe             	mov    %r15,%rsi
  4ec601:	ba 04 00 00 00       	mov    $0x4,%edx
  4ec606:	e8 15 d4 00 00       	call   4f9a20 <<gpui::element::El>::property_operand::<f64>>
  4ec60b:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  4ec612:	00 
  4ec613:	48 b8 00 00 00 00 00 	movabs $0x4030000000000000,%rax
  4ec61a:	00 30 40 
  4ec61d:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  4ec622:	4c 8d bc 24 48 01 00 	lea    0x148(%rsp),%r15
  4ec629:	00 
  4ec62a:	48 89 e1             	mov    %rsp,%rcx
  4ec62d:	4c 89 ff             	mov    %r15,%rdi
  4ec630:	4c 89 e6             	mov    %r12,%rsi
  4ec633:	ba 05 00 00 00       	mov    $0x5,%edx
  4ec638:	e8 e3 d3 00 00       	call   4f9a20 <<gpui::element::El>::property_operand::<f64>>
  4ec63d:	c7 04 24 00 00 00 00 	movl   $0x0,(%rsp)
  4ec644:	41 0f 10 06          	movups (%r14),%xmm0
  4ec648:	0f 11 44 24 04       	movups %xmm0,0x4(%rsp)
  4ec64d:	4c 8d a4 24 98 00 00 	lea    0x98(%rsp),%r12
  4ec654:	00 
  4ec655:	48 89 e1             	mov    %rsp,%rcx
  4ec658:	4c 89 e7             	mov    %r12,%rdi
  4ec65b:	4c 89 fe             	mov    %r15,%rsi
  4ec65e:	ba 06 00 00 00       	mov    $0x6,%edx
  4ec663:	e8 f8 cf 00 00       	call   4f9660 <<gpui::element::El>::property_operand::<gpui_canvas::color::Color>>
  4ec668:	c7 04 24 00 00 00 00 	movl   $0x0,(%rsp)
  4ec66f:	41 0f 10 06          	movups (%r14),%xmm0
  4ec673:	0f 11 44 24 04       	movups %xmm0,0x4(%rsp)
  4ec678:	4c 8d b4 24 48 01 00 	lea    0x148(%rsp),%r14
  4ec67f:	00 
  4ec680:	48 89 e1             	mov    %rsp,%rcx
  4ec683:	4c 89 f7             	mov    %r14,%rdi
  4ec686:	4c 89 e6             	mov    %r12,%rsi
  4ec689:	ba 07 00 00 00       	mov    $0x7,%edx
  4ec68e:	e8 cd cf 00 00       	call   4f9660 <<gpui::element::El>::property_operand::<gpui_canvas::color::Color>>
  4ec693:	0f 28 05 86 b6 b5 ff 	movaps -0x4a497a(%rip),%xmm0        # 47d20 <anon.5f884de6e78125e25881320d811d32df.391.llvm.17146438997930651657+0x12b0>
  4ec69a:	0f 29 04 24          	movaps %xmm0,(%rsp)
  4ec69e:	f2 0f 10 05 ea ac b5 	movsd  -0x4a5316(%rip),%xmm0        # 47390 <anon.5f884de6e78125e25881320d811d32df.391.llvm.17146438997930651657+0x920>
  4ec6a5:	ff 
  4ec6a6:	f2 0f 11 44 24 10    	movsd  %xmm0,0x10(%rsp)
  4ec6ac:	4c 8d bc 24 98 00 00 	lea    0x98(%rsp),%r15
  4ec6b3:	00 
  4ec6b4:	48 89 e2             	mov    %rsp,%rdx
  4ec6b7:	4c 89 ff             	mov    %r15,%rdi
  4ec6ba:	4c 89 f6             	mov    %r14,%rsi
  4ec6bd:	e8 de e2 00 00       	call   4fa9a0 <<gpui::element::El>::transform::<gpui_reactivity_core::geometry::Affine>>
  4ec6c2:	c7 84 24 48 01 00 00 	movl   $0x0,0x148(%rsp)
  4ec6c9:	00 00 00 00 
  4ec6cd:	c7 84 24 50 01 00 00 	movl   $0x20000,0x150(%rsp)
  4ec6d4:	00 00 02 00 
  4ec6d8:	48 8d b4 24 48 01 00 	lea    0x148(%rsp),%rsi
  4ec6df:	00 
  4ec6e0:	48 89 df             	mov    %rbx,%rdi
  4ec6e3:	4c 89 fa             	mov    %r15,%rdx
  4ec6e6:	e8 75 76 01 00       	call   503d60 <<gpui::style::Flex as gpui::style::FlexRecipe>::apply_to>
  4ec6eb:	48 89 d8             	mov    %rbx,%rax
  4ec6ee:	48 81 c4 f8 01 00 00 	add    $0x1f8,%rsp
  4ec6f5:	5b                   	pop    %rbx
  4ec6f6:	41 5c                	pop    %r12
  4ec6f8:	41 5e                	pop    %r14
  4ec6fa:	41 5f                	pop    %r15
  4ec6fc:	c3                   	ret
