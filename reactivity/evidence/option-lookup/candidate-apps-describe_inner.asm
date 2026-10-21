
/tmp/gpui-option-lookup-apps-4ce6cc649f0e16dbafb29422b9fe83c03ae8c259be19afa59f8979a49f4cb322:     file format elf64-x86-64


Disassembly of section .text:

00000000005aa030 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_>:
  5aa030:	55                   	push   %rbp
  5aa031:	41 57                	push   %r15
  5aa033:	41 56                	push   %r14
  5aa035:	41 55                	push   %r13
  5aa037:	41 54                	push   %r12
  5aa039:	53                   	push   %rbx
  5aa03a:	48 81 ec b8 07 00 00 	sub    $0x7b8,%rsp
  5aa041:	4c 89 c3             	mov    %r8,%rbx
  5aa044:	49 89 ce             	mov    %rcx,%r14
  5aa047:	49 89 f4             	mov    %rsi,%r12
  5aa04a:	48 89 bc 24 88 00 00 	mov    %rdi,0x88(%rsp)
  5aa051:	00 
  5aa052:	0f b6 86 5a 09 00 00 	movzbl 0x95a(%rsi),%eax
  5aa059:	88 84 24 98 00 00 00 	mov    %al,0x98(%rsp)
  5aa060:	48 ff 86 e8 08 00 00 	incq   0x8e8(%rsi)
  5aa067:	85 d2                	test   %edx,%edx
  5aa069:	75 08                	jne    5aa073 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x43>
  5aa06b:	49 ff 84 24 e0 08 00 	incq   0x8e0(%r12)
  5aa072:	00 
  5aa073:	48 c7 84 24 d8 06 00 	movq   $0x0,0x6d8(%rsp)
  5aa07a:	00 00 00 00 00 
  5aa07f:	48 c7 84 24 e8 06 00 	movq   $0x0,0x6e8(%rsp)
  5aa086:	00 00 00 00 00 
  5aa08b:	49 8d 8c 24 98 07 00 	lea    0x798(%r12),%rcx
  5aa092:	00 
  5aa093:	49 8b 84 24 98 07 00 	mov    0x798(%r12),%rax
  5aa09a:	00 
  5aa09b:	48 c7 84 24 b8 03 00 	movq   $0x0,0x3b8(%rsp)
  5aa0a2:	00 00 00 00 00 
  5aa0a7:	48 89 84 24 c0 03 00 	mov    %rax,0x3c0(%rsp)
  5aa0ae:	00 
  5aa0af:	48 89 4c 24 20       	mov    %rcx,0x20(%rsp)
  5aa0b4:	48 89 8c 24 b0 03 00 	mov    %rcx,0x3b0(%rsp)
  5aa0bb:	00 
  5aa0bc:	c6 84 24 48 01 00 00 	movb   $0x0,0x148(%rsp)
  5aa0c3:	00 
  5aa0c4:	48 c7 84 24 b8 00 00 	movq   $0xffffffffffffffff,0xb8(%rsp)
  5aa0cb:	00 ff ff ff ff 
  5aa0d0:	48 c7 84 24 a0 00 00 	movq   $0x0,0xa0(%rsp)
  5aa0d7:	00 00 00 00 00 
  5aa0dc:	48 c7 84 24 a8 00 00 	movq   $0x8,0xa8(%rsp)
  5aa0e3:	00 08 00 00 00 
  5aa0e8:	48 c7 84 24 b0 00 00 	movq   $0x0,0xb0(%rsp)
  5aa0ef:	00 00 00 00 00 
  5aa0f4:	0f 10 05 45 5a ad ff 	movups -0x52a5bb(%rip),%xmm0        # 7fb40 <anon.1f6b7bab1fc61e0fcd36456038a862fb.78.llvm.5148459089407822190>
  5aa0fb:	0f 11 84 24 d0 00 00 	movups %xmm0,0xd0(%rsp)
  5aa102:	00 
  5aa103:	0f 10 05 46 5a ad ff 	movups -0x52a5ba(%rip),%xmm0        # 7fb50 <anon.1f6b7bab1fc61e0fcd36456038a862fb.78.llvm.5148459089407822190+0x10>
  5aa10a:	0f 11 84 24 e0 00 00 	movups %xmm0,0xe0(%rsp)
  5aa111:	00 
  5aa112:	0f 10 05 47 5a ad ff 	movups -0x52a5b9(%rip),%xmm0        # 7fb60 <anon.1f6b7bab1fc61e0fcd36456038a862fb.78.llvm.5148459089407822190+0x20>
  5aa119:	0f 11 84 24 f0 00 00 	movups %xmm0,0xf0(%rsp)
  5aa120:	00 
  5aa121:	0f 10 05 48 5a ad ff 	movups -0x52a5b8(%rip),%xmm0        # 7fb70 <anon.1f6b7bab1fc61e0fcd36456038a862fb.78.llvm.5148459089407822190+0x30>
  5aa128:	0f 11 84 24 00 01 00 	movups %xmm0,0x100(%rsp)
  5aa12f:	00 
  5aa130:	0f 10 05 49 5a ad ff 	movups -0x52a5b7(%rip),%xmm0        # 7fb80 <anon.1f6b7bab1fc61e0fcd36456038a862fb.78.llvm.5148459089407822190+0x40>
  5aa137:	0f 11 84 24 10 01 00 	movups %xmm0,0x110(%rsp)
  5aa13e:	00 
  5aa13f:	48 8b 05 4a 5a ad ff 	mov    -0x52a5b6(%rip),%rax        # 7fb90 <anon.1f6b7bab1fc61e0fcd36456038a862fb.78.llvm.5148459089407822190+0x50>
  5aa146:	48 89 84 24 20 01 00 	mov    %rax,0x120(%rsp)
  5aa14d:	00 
  5aa14e:	48 c7 84 24 28 01 00 	movq   $0x0,0x128(%rsp)
  5aa155:	00 00 00 00 00 
  5aa15a:	0f 57 c0             	xorps  %xmm0,%xmm0
  5aa15d:	0f 11 84 24 38 01 00 	movups %xmm0,0x138(%rsp)
  5aa164:	00 
  5aa165:	c6 84 24 24 01 00 00 	movb   $0x1,0x124(%rsp)
  5aa16c:	01 
  5aa16d:	48 8d bc 24 b0 03 00 	lea    0x3b0(%rsp),%rdi
  5aa174:	00 
  5aa175:	48 8d b4 24 a0 00 00 	lea    0xa0(%rsp),%rsi
  5aa17c:	00 
  5aa17d:	e8 ce d2 18 00       	call   737450 <_RNvXsi_NtCs6gaF1xUz9Bf_4gpui7elementINtNtNtNtCs4NRVxsYgnAr_4core4iter8adapters3map3MapINtNtNtBH_3ops5range5RangejENCNvXs0_NtNtB7_7runtime12style_ledgerNtB1W_9AdversaryNtB7_4View4view0EINtB5_8ChildSeqINtNtB5_5shape4IterNtB3e_3OneEE6appendB7_>
  5aa182:	4c 8d bc 24 00 03 00 	lea    0x300(%rsp),%r15
  5aa189:	00 
  5aa18a:	48 8d b4 24 a0 00 00 	lea    0xa0(%rsp),%rsi
  5aa191:	00 
  5aa192:	ba b0 00 00 00       	mov    $0xb0,%edx
  5aa197:	4c 89 ff             	mov    %r15,%rdi
  5aa19a:	ff 15 b0 fc 53 00    	call   *0x53fcb0(%rip)        # ae9e50 <memcpy@GLIBC_2.14>
  5aa1a0:	49 8d 8c 24 f8 07 00 	lea    0x7f8(%r12),%rcx
  5aa1a7:	00 
  5aa1a8:	4c 89 64 24 10       	mov    %r12,0x10(%rsp)
  5aa1ad:	49 8d 94 24 18 08 00 	lea    0x818(%r12),%rdx
  5aa1b4:	00 
  5aa1b5:	48 8d 84 24 d8 06 00 	lea    0x6d8(%rsp),%rax
  5aa1bc:	00 
  5aa1bd:	48 89 84 24 a0 00 00 	mov    %rax,0xa0(%rsp)
  5aa1c4:	00 
  5aa1c5:	48 89 8c 24 98 05 00 	mov    %rcx,0x598(%rsp)
  5aa1cc:	00 
  5aa1cd:	48 89 8c 24 a8 00 00 	mov    %rcx,0xa8(%rsp)
  5aa1d4:	00 
  5aa1d5:	48 89 94 24 a0 05 00 	mov    %rdx,0x5a0(%rsp)
  5aa1dc:	00 
  5aa1dd:	48 89 94 24 b0 00 00 	mov    %rdx,0xb0(%rsp)
  5aa1e4:	00 
  5aa1e5:	4c 89 b4 24 b8 00 00 	mov    %r14,0xb8(%rsp)
  5aa1ec:	00 
  5aa1ed:	4c 8d 05 64 e4 50 00 	lea    0x50e464(%rip),%r8        # ab8658 <__frame_dummy_init_array_entry+0xe8>
  5aa1f4:	48 8d bc 24 90 01 00 	lea    0x190(%rsp),%rdi
  5aa1fb:	00 
  5aa1fc:	4c 8d 8c 24 a0 00 00 	lea    0xa0(%rsp),%r9
  5aa203:	00 
  5aa204:	ba a0 86 01 00       	mov    $0x186a0,%edx
  5aa209:	4c 89 fe             	mov    %r15,%rsi
  5aa20c:	48 89 d9             	mov    %rbx,%rcx
  5aa20f:	e8 7c 96 1f 00       	call   7a3890 <_RINvMs4_NtCs6gaF1xUz9Bf_4gpui7elementNtB6_2El13flatten_listsNCNvMsq_NtB8_7runtimeINtB14_7RuntimeNtNtB14_12style_ledger9AdversaryE14describe_inner0EB8_>
  5aa214:	48 8b 8c 24 90 01 00 	mov    0x190(%rsp),%rcx
  5aa21b:	00 
  5aa21c:	48 8b 94 24 98 01 00 	mov    0x198(%rsp),%rdx
  5aa223:	00 
  5aa224:	4c 8b a4 24 a0 01 00 	mov    0x1a0(%rsp),%r12
  5aa22b:	00 
  5aa22c:	48 83 f9 ff          	cmp    $0xffffffffffffffff,%rcx
  5aa230:	0f 84 31 01 00 00    	je     5aa367 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x337>
  5aa236:	48 8b 84 24 b8 01 00 	mov    0x1b8(%rsp),%rax
  5aa23d:	00 
  5aa23e:	48 89 84 24 00 05 00 	mov    %rax,0x500(%rsp)
  5aa245:	00 
  5aa246:	0f 10 84 24 a8 01 00 	movups 0x1a8(%rsp),%xmm0
  5aa24d:	00 
  5aa24e:	0f 29 84 24 f0 04 00 	movaps %xmm0,0x4f0(%rsp)
  5aa255:	00 
  5aa256:	48 8b 84 24 d0 01 00 	mov    0x1d0(%rsp),%rax
  5aa25d:	00 
  5aa25e:	48 89 84 24 50 04 00 	mov    %rax,0x450(%rsp)
  5aa265:	00 
  5aa266:	0f 10 84 24 c0 01 00 	movups 0x1c0(%rsp),%xmm0
  5aa26d:	00 
  5aa26e:	0f 29 84 24 40 04 00 	movaps %xmm0,0x440(%rsp)
  5aa275:	00 
  5aa276:	48 8b 84 24 d8 01 00 	mov    0x1d8(%rsp),%rax
  5aa27d:	00 
  5aa27e:	48 89 84 24 e8 04 00 	mov    %rax,0x4e8(%rsp)
  5aa285:	00 
  5aa286:	48 8b 84 24 e0 01 00 	mov    0x1e0(%rsp),%rax
  5aa28d:	00 
  5aa28e:	48 89 84 24 e0 04 00 	mov    %rax,0x4e0(%rsp)
  5aa295:	00 
  5aa296:	48 8b 84 24 e8 01 00 	mov    0x1e8(%rsp),%rax
  5aa29d:	00 
  5aa29e:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  5aa2a3:	48 89 4c 24 70       	mov    %rcx,0x70(%rsp)
  5aa2a8:	48 89 8c 24 38 06 00 	mov    %rcx,0x638(%rsp)
  5aa2af:	00 
  5aa2b0:	48 89 54 24 40       	mov    %rdx,0x40(%rsp)
  5aa2b5:	48 89 94 24 40 06 00 	mov    %rdx,0x640(%rsp)
  5aa2bc:	00 
  5aa2bd:	4c 89 a4 24 48 06 00 	mov    %r12,0x648(%rsp)
  5aa2c4:	00 
  5aa2c5:	48 8b 9c 24 f8 04 00 	mov    0x4f8(%rsp),%rbx
  5aa2cc:	00 
  5aa2cd:	4c 69 b4 24 00 05 00 	imul   $0xa8,0x500(%rsp),%r14
  5aa2d4:	00 a8 00 00 00 
  5aa2d9:	49 01 de             	add    %rbx,%r14
  5aa2dc:	40 b5 01             	mov    $0x1,%bpl
  5aa2df:	48 8d bc 24 a8 06 00 	lea    0x6a8(%rsp),%rdi
  5aa2e6:	00 
  5aa2e7:	41 b5 01             	mov    $0x1,%r13b
  5aa2ea:	41 b7 01             	mov    $0x1,%r15b
  5aa2ed:	48 89 de             	mov    %rbx,%rsi
  5aa2f0:	4c 89 f2             	mov    %r14,%rdx
  5aa2f3:	e8 88 0c 17 00       	call   71af80 <_RINvXs1o_NtNtNtCscdodAO9FK5_5alloc11collections5btree3mapINtB7_8BTreeMapjNtNtCs6gaF1xUz9Bf_4gpui4list6ListIdEINtNtNtNtCs4NRVxsYgnAr_4core4iter6traits7collect12FromIteratorTjB19_EE9from_iterINtNtNtB1Q_8adapters3map3MapINtNtNtB1S_5slice4iter4IterNtB1b_9ListDraftENCNvMsq_NtB1d_7runtimeINtB4j_7RuntimeNtNtB4j_12style_ledger9AdversaryE14describe_inners_0EEB1d_>
  5aa2f8:	48 89 9c 24 a0 00 00 	mov    %rbx,0xa0(%rsp)
  5aa2ff:	00 
  5aa300:	4c 89 b4 24 a8 00 00 	mov    %r14,0xa8(%rsp)
  5aa307:	00 
  5aa308:	48 c7 84 24 b0 00 00 	movq   $0x0,0xb0(%rsp)
  5aa30f:	00 00 00 00 00 
  5aa314:	48 c7 84 24 c8 00 00 	movq   $0x0,0xc8(%rsp)
  5aa31b:	00 00 00 00 00 
  5aa320:	b3 01                	mov    $0x1,%bl
  5aa322:	48 8d bc 24 c0 06 00 	lea    0x6c0(%rsp),%rdi
  5aa329:	00 
  5aa32a:	48 8d b4 24 a0 00 00 	lea    0xa0(%rsp),%rsi
  5aa331:	00 
  5aa332:	41 b5 01             	mov    $0x1,%r13b
  5aa335:	41 b7 01             	mov    $0x1,%r15b
  5aa338:	e8 c3 3f 17 00       	call   71e300 <_RINvXs1o_NtNtNtCscdodAO9FK5_5alloc11collections5btree3mapINtB7_8BTreeMapjTNtNtCs6gaF1xUz9Bf_4gpui4list6ListIdRNtB1c_8RowDraftEEINtNtNtNtCs4NRVxsYgnAr_4core4iter6traits7collect12FromIteratorTjB19_EE9from_iterINtNtNtB28_8adapters7flatten7FlatMapINtNtNtB2a_5slice4iter4IterNtB1c_9ListDraftEINtNtB3o_3map3MapIB3U_B1K_ENCNCNvMsq_NtB1e_7runtimeINtB5c_7RuntimeNtNtB5c_12style_ledger9AdversaryE14describe_inners0_00ENCB56_s0_0EEB1e_>
  5aa33d:	49 81 fc a0 86 01 00 	cmp    $0x186a0,%r12
  5aa344:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  5aa349:	4c 8b 7c 24 40       	mov    0x40(%rsp),%r15
  5aa34e:	76 33                	jbe    5aa383 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x353>
  5aa350:	48 8b 84 24 88 00 00 	mov    0x88(%rsp),%rax
  5aa357:	00 
  5aa358:	48 c7 00 1d 00 00 00 	movq   $0x1d,(%rax)
  5aa35f:	41 b5 01             	mov    $0x1,%r13b
  5aa362:	e9 30 51 00 00       	jmp    5af497 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5467>
  5aa367:	48 8b 84 24 88 00 00 	mov    0x88(%rsp),%rax
  5aa36e:	00 
  5aa36f:	48 c7 00 25 00 00 00 	movq   $0x25,(%rax)
  5aa376:	48 89 50 08          	mov    %rdx,0x8(%rax)
  5aa37a:	4c 89 60 10          	mov    %r12,0x10(%rax)
  5aa37e:	e9 c6 52 00 00       	jmp    5af649 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5619>
  5aa383:	48 8b 80 e0 07 00 00 	mov    0x7e0(%rax),%rax
  5aa38a:	4c 01 e0             	add    %r12,%rax
  5aa38d:	0f 82 80 53 00 00    	jb     5af713 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x56e3>
  5aa393:	48 8b 84 24 e8 04 00 	mov    0x4e8(%rsp),%rax
  5aa39a:	00 
  5aa39b:	48 89 84 24 90 01 00 	mov    %rax,0x190(%rsp)
  5aa3a2:	00 
  5aa3a3:	48 8b 84 24 e0 04 00 	mov    0x4e0(%rsp),%rax
  5aa3aa:	00 
  5aa3ab:	48 89 84 24 98 01 00 	mov    %rax,0x198(%rsp)
  5aa3b2:	00 
  5aa3b3:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  5aa3b8:	48 89 84 24 a0 01 00 	mov    %rax,0x1a0(%rsp)
  5aa3bf:	00 
  5aa3c0:	48 8d bc 24 a0 00 00 	lea    0xa0(%rsp),%rdi
  5aa3c7:	00 
  5aa3c8:	48 8d b4 24 90 01 00 	lea    0x190(%rsp),%rsi
  5aa3cf:	00 
  5aa3d0:	e8 7b b3 1d 00       	call   785750 <_RNvNtNtCs6gaF1xUz9Bf_4gpui7runtime5image8describe>
  5aa3d5:	48 8b 84 24 a0 00 00 	mov    0xa0(%rsp),%rax
  5aa3dc:	00 
  5aa3dd:	0f 10 84 24 a8 00 00 	movups 0xa8(%rsp),%xmm0
  5aa3e4:	00 
  5aa3e5:	0f 29 84 24 00 03 00 	movaps %xmm0,0x300(%rsp)
  5aa3ec:	00 
  5aa3ed:	0f 10 84 24 b8 00 00 	movups 0xb8(%rsp),%xmm0
  5aa3f4:	00 
  5aa3f5:	0f 29 84 24 10 03 00 	movaps %xmm0,0x310(%rsp)
  5aa3fc:	00 
  5aa3fd:	0f 10 84 24 c8 00 00 	movups 0xc8(%rsp),%xmm0
  5aa404:	00 
  5aa405:	0f 29 84 24 20 03 00 	movaps %xmm0,0x320(%rsp)
  5aa40c:	00 
  5aa40d:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  5aa411:	0f 85 00 01 00 00    	jne    5aa517 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4e7>
  5aa417:	48 8b 84 24 10 03 00 	mov    0x310(%rsp),%rax
  5aa41e:	00 
  5aa41f:	48 89 84 24 80 04 00 	mov    %rax,0x480(%rsp)
  5aa426:	00 
  5aa427:	0f 28 84 24 00 03 00 	movaps 0x300(%rsp),%xmm0
  5aa42e:	00 
  5aa42f:	0f 29 84 24 70 04 00 	movaps %xmm0,0x470(%rsp)
  5aa436:	00 
  5aa437:	48 8b 84 24 28 03 00 	mov    0x328(%rsp),%rax
  5aa43e:	00 
  5aa43f:	48 89 84 24 30 06 00 	mov    %rax,0x630(%rsp)
  5aa446:	00 
  5aa447:	0f 10 84 24 18 03 00 	movups 0x318(%rsp),%xmm0
  5aa44e:	00 
  5aa44f:	0f 29 84 24 20 06 00 	movaps %xmm0,0x620(%rsp)
  5aa456:	00 
  5aa457:	4a 8d 1c e5 00 00 00 	lea    0x0(,%r12,8),%rbx
  5aa45e:	00 
  5aa45f:	4d 85 e4             	test   %r12,%r12
  5aa462:	0f 84 e8 00 00 00    	je     5aa550 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x520>
  5aa468:	ff 15 82 fa 53 00    	call   *0x53fa82(%rip)        # ae9ef0 <_DYNAMIC+0x340>
  5aa46e:	be 08 00 00 00       	mov    $0x8,%esi
  5aa473:	48 89 df             	mov    %rbx,%rdi
  5aa476:	ff 15 74 f9 53 00    	call   *0x53f974(%rip)        # ae9df0 <_DYNAMIC+0x240>
  5aa47c:	48 85 c0             	test   %rax,%rax
  5aa47f:	0f 84 e5 55 00 00    	je     5afa6a <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5a3a>
  5aa485:	4c 89 a4 24 e8 02 00 	mov    %r12,0x2e8(%rsp)
  5aa48c:	00 
  5aa48d:	48 89 84 24 f0 02 00 	mov    %rax,0x2f0(%rsp)
  5aa494:	00 
  5aa495:	48 c7 84 24 f8 02 00 	movq   $0x0,0x2f8(%rsp)
  5aa49c:	00 00 00 00 00 
  5aa4a1:	ff 15 49 fa 53 00    	call   *0x53fa49(%rip)        # ae9ef0 <_DYNAMIC+0x340>
  5aa4a7:	be 08 00 00 00       	mov    $0x8,%esi
  5aa4ac:	48 89 5c 24 38       	mov    %rbx,0x38(%rsp)
  5aa4b1:	48 89 df             	mov    %rbx,%rdi
  5aa4b4:	ff 15 36 f9 53 00    	call   *0x53f936(%rip)        # ae9df0 <_DYNAMIC+0x240>
  5aa4ba:	48 85 c0             	test   %rax,%rax
  5aa4bd:	0f 84 ba 55 00 00    	je     5afa7d <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5a4d>
  5aa4c3:	4c 89 a4 24 88 02 00 	mov    %r12,0x288(%rsp)
  5aa4ca:	00 
  5aa4cb:	48 89 84 24 90 02 00 	mov    %rax,0x290(%rsp)
  5aa4d2:	00 
  5aa4d3:	48 c7 84 24 98 02 00 	movq   $0x0,0x298(%rsp)
  5aa4da:	00 00 00 00 00 
  5aa4df:	4a 8d 1c a5 00 00 00 	lea    0x0(,%r12,4),%rbx
  5aa4e6:	00 
  5aa4e7:	ff 15 03 fa 53 00    	call   *0x53fa03(%rip)        # ae9ef0 <_DYNAMIC+0x340>
  5aa4ed:	be 04 00 00 00       	mov    $0x4,%esi
  5aa4f2:	48 89 df             	mov    %rbx,%rdi
  5aa4f5:	ff 15 f5 f8 53 00    	call   *0x53f8f5(%rip)        # ae9df0 <_DYNAMIC+0x240>
  5aa4fb:	48 85 c0             	test   %rax,%rax
  5aa4fe:	0f 85 99 00 00 00    	jne    5aa59d <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x56d>
  5aa504:	bf 04 00 00 00       	mov    $0x4,%edi
  5aa509:	48 89 de             	mov    %rbx,%rsi
  5aa50c:	ff 15 e6 f9 53 00    	call   *0x53f9e6(%rip)        # ae9ef8 <_DYNAMIC+0x348>
  5aa512:	e9 b5 56 00 00       	jmp    5afbcc <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5b9c>
  5aa517:	0f 28 84 24 00 03 00 	movaps 0x300(%rsp),%xmm0
  5aa51e:	00 
  5aa51f:	0f 28 8c 24 10 03 00 	movaps 0x310(%rsp),%xmm1
  5aa526:	00 
  5aa527:	66 0f 6f 94 24 20 03 	movdqa 0x320(%rsp),%xmm2
  5aa52e:	00 00 
  5aa530:	48 8b 8c 24 88 00 00 	mov    0x88(%rsp),%rcx
  5aa537:	00 
  5aa538:	f3 0f 7f 51 28       	movdqu %xmm2,0x28(%rcx)
  5aa53d:	0f 11 49 18          	movups %xmm1,0x18(%rcx)
  5aa541:	0f 11 41 08          	movups %xmm0,0x8(%rcx)
  5aa545:	48 89 01             	mov    %rax,(%rcx)
  5aa548:	45 31 ed             	xor    %r13d,%r13d
  5aa54b:	e9 47 4f 00 00       	jmp    5af497 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5467>
  5aa550:	48 c7 84 24 e8 02 00 	movq   $0x0,0x2e8(%rsp)
  5aa557:	00 00 00 00 00 
  5aa55c:	48 c7 84 24 f0 02 00 	movq   $0x8,0x2f0(%rsp)
  5aa563:	00 08 00 00 00 
  5aa568:	48 c7 84 24 f8 02 00 	movq   $0x0,0x2f8(%rsp)
  5aa56f:	00 00 00 00 00 
  5aa574:	48 c7 84 24 88 02 00 	movq   $0x0,0x288(%rsp)
  5aa57b:	00 00 00 00 00 
  5aa580:	48 c7 84 24 90 02 00 	movq   $0x8,0x290(%rsp)
  5aa587:	00 08 00 00 00 
  5aa58c:	48 c7 84 24 98 02 00 	movq   $0x0,0x298(%rsp)
  5aa593:	00 00 00 00 00 
  5aa598:	b8 04 00 00 00       	mov    $0x4,%eax
  5aa59d:	4c 89 a4 24 a0 02 00 	mov    %r12,0x2a0(%rsp)
  5aa5a4:	00 
  5aa5a5:	48 89 84 24 a8 02 00 	mov    %rax,0x2a8(%rsp)
  5aa5ac:	00 
  5aa5ad:	48 c7 84 24 b0 02 00 	movq   $0x0,0x2b0(%rsp)
  5aa5b4:	00 00 00 00 00 
  5aa5b9:	4a 8d 1c e5 08 00 00 	lea    0x8(,%r12,8),%rbx
  5aa5c0:	00 
  5aa5c1:	ff 15 29 f9 53 00    	call   *0x53f929(%rip)        # ae9ef0 <_DYNAMIC+0x340>
  5aa5c7:	be 08 00 00 00       	mov    $0x8,%esi
  5aa5cc:	48 89 9c 24 c8 04 00 	mov    %rbx,0x4c8(%rsp)
  5aa5d3:	00 
  5aa5d4:	48 89 df             	mov    %rbx,%rdi
  5aa5d7:	ff 15 2b f8 53 00    	call   *0x53f82b(%rip)        # ae9e08 <_DYNAMIC+0x258>
  5aa5dd:	48 89 84 24 e0 02 00 	mov    %rax,0x2e0(%rsp)
  5aa5e4:	00 
  5aa5e5:	48 85 c0             	test   %rax,%rax
  5aa5e8:	0f 84 f9 53 00 00    	je     5af9e7 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x59b7>
  5aa5ee:	49 8d 44 24 01       	lea    0x1(%r12),%rax
  5aa5f3:	48 89 84 24 88 05 00 	mov    %rax,0x588(%rsp)
  5aa5fa:	00 
  5aa5fb:	49 69 c4 98 00 00 00 	imul   $0x98,%r12,%rax
  5aa602:	48 89 84 24 10 02 00 	mov    %rax,0x210(%rsp)
  5aa609:	00 
  5aa60a:	48 c7 84 24 30 02 00 	movq   $0x0,0x230(%rsp)
  5aa611:	00 00 00 00 00 
  5aa616:	48 c7 84 24 40 02 00 	movq   $0x0,0x240(%rsp)
  5aa61d:	00 00 00 00 00 
  5aa622:	4d 85 e4             	test   %r12,%r12
  5aa625:	0f 84 de 04 00 00    	je     5aab09 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0xad9>
  5aa62b:	48 8b 84 24 10 02 00 	mov    0x210(%rsp),%rax
  5aa632:	00 
  5aa633:	4c 01 f8             	add    %r15,%rax
  5aa636:	48 89 44 24 60       	mov    %rax,0x60(%rsp)
  5aa63b:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  5aa640:	48 05 50 02 00 00    	add    $0x250,%rax
  5aa646:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  5aa64b:	48 c7 84 24 80 00 00 	movq   $0x0,0x80(%rsp)
  5aa652:	00 00 00 00 00 
  5aa657:	48 8d 05 0a e3 50 00 	lea    0x50e30a(%rip),%rax        # ab8968 <anon.c906c25ea787c8c2757c1f36aabcd0ba.27.llvm.18178969024155037896+0x1c8>
  5aa65e:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
  5aa663:	41 0f b6 6f 18       	movzbl 0x18(%r15),%ebp
  5aa668:	4c 89 7c 24 40       	mov    %r15,0x40(%rsp)
  5aa66d:	41 8b 5f 1c          	mov    0x1c(%r15),%ebx
  5aa671:	48 8d 43 01          	lea    0x1(%rbx),%rax
  5aa675:	40 84 ed             	test   %bpl,%bpl
  5aa678:	b9 00 00 00 00       	mov    $0x0,%ecx
  5aa67d:	48 0f 45 c8          	cmovne %rax,%rcx
  5aa681:	4c 39 e1             	cmp    %r12,%rcx
  5aa684:	0f 87 31 53 00 00    	ja     5af9bb <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x598b>
  5aa68a:	48 8b 84 24 e0 02 00 	mov    0x2e0(%rsp),%rax
  5aa691:	00 
  5aa692:	48 ff 04 c8          	incq   (%rax,%rcx,8)
  5aa696:	48 8b 84 24 f0 02 00 	mov    0x2f0(%rsp),%rax
  5aa69d:	00 
  5aa69e:	4c 8b bc 24 f8 02 00 	mov    0x2f8(%rsp),%r15
  5aa6a5:	00 
  5aa6a6:	40 84 ed             	test   %bpl,%bpl
  5aa6a9:	74 29                	je     5aa6d4 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x6a4>
  5aa6ab:	49 39 df             	cmp    %rbx,%r15
  5aa6ae:	0f 86 ea 53 00 00    	jbe    5afa9e <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5a6e>
  5aa6b4:	4c 8b 2c d8          	mov    (%rax,%rbx,8),%r13
  5aa6b8:	49 ff c5             	inc    %r13
  5aa6bb:	49 81 fd 80 00 00 00 	cmp    $0x80,%r13
  5aa6c2:	0f 87 ac 4b 00 00    	ja     5af274 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5244>
  5aa6c8:	4c 3b bc 24 e8 02 00 	cmp    0x2e8(%rsp),%r15
  5aa6cf:	00 
  5aa6d0:	74 0f                	je     5aa6e1 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x6b1>
  5aa6d2:	eb 23                	jmp    5aa6f7 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x6c7>
  5aa6d4:	45 31 ed             	xor    %r13d,%r13d
  5aa6d7:	4c 3b bc 24 e8 02 00 	cmp    0x2e8(%rsp),%r15
  5aa6de:	00 
  5aa6df:	75 16                	jne    5aa6f7 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x6c7>
  5aa6e1:	48 8d bc 24 e8 02 00 	lea    0x2e8(%rsp),%rdi
  5aa6e8:	00 
  5aa6e9:	ff 15 09 f9 53 00    	call   *0x53f909(%rip)        # ae9ff8 <_DYNAMIC+0x448>
  5aa6ef:	48 8b 84 24 f0 02 00 	mov    0x2f0(%rsp),%rax
  5aa6f6:	00 
  5aa6f7:	4e 89 2c f8          	mov    %r13,(%rax,%r15,8)
  5aa6fb:	49 ff c7             	inc    %r15
  5aa6fe:	4c 89 bc 24 f8 02 00 	mov    %r15,0x2f8(%rsp)
  5aa705:	00 
  5aa706:	45 31 ff             	xor    %r15d,%r15d
  5aa709:	40 84 ed             	test   %bpl,%bpl
  5aa70c:	74 1d                	je     5aa72b <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x6fb>
  5aa70e:	4c 8b bc 24 b0 02 00 	mov    0x2b0(%rsp),%r15
  5aa715:	00 
  5aa716:	49 39 df             	cmp    %rbx,%r15
  5aa719:	0f 86 73 53 00 00    	jbe    5afa92 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5a62>
  5aa71f:	48 8b 84 24 a8 02 00 	mov    0x2a8(%rsp),%rax
  5aa726:	00 
  5aa727:	44 8b 3c 98          	mov    (%rax,%rbx,4),%r15d
  5aa72b:	48 8b 44 24 40       	mov    0x40(%rsp),%rax
  5aa730:	48 8b a8 88 00 00 00 	mov    0x88(%rax),%rbp
  5aa737:	48 85 ed             	test   %rbp,%rbp
  5aa73a:	0f 84 9b 00 00 00    	je     5aa7db <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x7ab>
  5aa740:	48 8b 75 00          	mov    0x0(%rbp),%rsi
  5aa744:	48 85 f6             	test   %rsi,%rsi
  5aa747:	0f 84 54 4f 00 00    	je     5af6a1 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5671>
  5aa74d:	48 8b 5d 10          	mov    0x10(%rbp),%rbx
  5aa751:	48 8b 45 08          	mov    0x8(%rbp),%rax
  5aa755:	48 8d bc 24 a0 00 00 	lea    0xa0(%rsp),%rdi
  5aa75c:	00 
  5aa75d:	48 8b 54 24 20       	mov    0x20(%rsp),%rdx
  5aa762:	48 8d 0d af e9 50 00 	lea    0x50e9af(%rip),%rcx        # ab9118 <anon.c906c25ea787c8c2757c1f36aabcd0ba.92.llvm.18178969024155037896+0x4e8>
  5aa769:	4c 8b 44 24 08       	mov    0x8(%rsp),%r8
  5aa76e:	4c 8d 0d c3 e9 50 00 	lea    0x50e9c3(%rip),%r9        # ab9138 <anon.c906c25ea787c8c2757c1f36aabcd0ba.92.llvm.18178969024155037896+0x508>
  5aa775:	ff 50 18             	call   *0x18(%rax)
  5aa778:	48 8b 84 24 a0 00 00 	mov    0xa0(%rsp),%rax
  5aa77f:	00 
  5aa780:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  5aa784:	0f 85 07 09 00 00    	jne    5ab091 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1061>
  5aa78a:	48 8b 75 00          	mov    0x0(%rbp),%rsi
  5aa78e:	48 8b 45 08          	mov    0x8(%rbp),%rax
  5aa792:	48 8d bc 24 a0 00 00 	lea    0xa0(%rsp),%rdi
  5aa799:	00 
  5aa79a:	48 8b 54 24 20       	mov    0x20(%rsp),%rdx
  5aa79f:	48 8d 0d 72 e9 50 00 	lea    0x50e972(%rip),%rcx        # ab9118 <anon.c906c25ea787c8c2757c1f36aabcd0ba.92.llvm.18178969024155037896+0x4e8>
  5aa7a6:	4c 8b 44 24 08       	mov    0x8(%rsp),%r8
  5aa7ab:	4c 8d 0d 86 e9 50 00 	lea    0x50e986(%rip),%r9        # ab9138 <anon.c906c25ea787c8c2757c1f36aabcd0ba.92.llvm.18178969024155037896+0x508>
  5aa7b2:	ff 50 28             	call   *0x28(%rax)
  5aa7b5:	48 8b 84 24 a0 00 00 	mov    0xa0(%rsp),%rax
  5aa7bc:	00 
  5aa7bd:	44 8b bc 24 a8 00 00 	mov    0xa8(%rsp),%r15d
  5aa7c4:	00 
  5aa7c5:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  5aa7c9:	0f 85 fb 08 00 00    	jne    5ab0ca <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x109a>
  5aa7cf:	48 89 dd             	mov    %rbx,%rbp
  5aa7d2:	48 85 db             	test   %rbx,%rbx
  5aa7d5:	0f 85 65 ff ff ff    	jne    5aa740 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x710>
  5aa7db:	48 8b 9c 24 b0 02 00 	mov    0x2b0(%rsp),%rbx
  5aa7e2:	00 
  5aa7e3:	48 3b 9c 24 a0 02 00 	cmp    0x2a0(%rsp),%rbx
  5aa7ea:	00 
  5aa7eb:	75 0e                	jne    5aa7fb <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x7cb>
  5aa7ed:	48 8d bc 24 a0 02 00 	lea    0x2a0(%rsp),%rdi
  5aa7f4:	00 
  5aa7f5:	ff 15 05 f8 53 00    	call   *0x53f805(%rip)        # aea000 <_DYNAMIC+0x450>
  5aa7fb:	48 8b 84 24 a8 02 00 	mov    0x2a8(%rsp),%rax
  5aa802:	00 
  5aa803:	44 89 3c 98          	mov    %r15d,(%rax,%rbx,4)
  5aa807:	48 ff c3             	inc    %rbx
  5aa80a:	48 89 9c 24 b0 02 00 	mov    %rbx,0x2b0(%rsp)
  5aa811:	00 
  5aa812:	48 8b 54 24 40       	mov    0x40(%rsp),%rdx
  5aa817:	48 8b 72 78          	mov    0x78(%rdx),%rsi
  5aa81b:	48 85 f6             	test   %rsi,%rsi
  5aa81e:	74 41                	je     5aa861 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x831>
  5aa820:	48 8b 82 80 00 00 00 	mov    0x80(%rdx),%rax
  5aa827:	48 8d bc 24 a0 00 00 	lea    0xa0(%rsp),%rdi
  5aa82e:	00 
  5aa82f:	48 8b 54 24 20       	mov    0x20(%rsp),%rdx
  5aa834:	48 8d 0d dd e8 50 00 	lea    0x50e8dd(%rip),%rcx        # ab9118 <anon.c906c25ea787c8c2757c1f36aabcd0ba.92.llvm.18178969024155037896+0x4e8>
  5aa83b:	4c 8b 44 24 08       	mov    0x8(%rsp),%r8
  5aa840:	4c 8d 0d f1 e8 50 00 	lea    0x50e8f1(%rip),%r9        # ab9138 <anon.c906c25ea787c8c2757c1f36aabcd0ba.92.llvm.18178969024155037896+0x508>
  5aa847:	ff 50 18             	call   *0x18(%rax)
  5aa84a:	48 8b 84 24 a0 00 00 	mov    0xa0(%rsp),%rax
  5aa851:	00 
  5aa852:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  5aa856:	0f 85 35 08 00 00    	jne    5ab091 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1061>
  5aa85c:	48 8b 54 24 40       	mov    0x40(%rsp),%rdx
  5aa861:	48 8b 1a             	mov    (%rdx),%rbx
  5aa864:	48 83 fb ff          	cmp    $0xffffffffffffffff,%rbx
  5aa868:	74 52                	je     5aa8bc <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x88c>
  5aa86a:	48 b8 01 00 00 00 00 	movabs $0x8000000000000001,%rax
  5aa871:	00 00 80 
  5aa874:	48 ff c0             	inc    %rax
  5aa877:	48 39 c3             	cmp    %rax,%rbx
  5aa87a:	75 4a                	jne    5aa8c6 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x896>
  5aa87c:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  5aa880:	4c 8b 42 10          	mov    0x10(%rdx),%r8
  5aa884:	48 8d bc 24 a0 00 00 	lea    0xa0(%rsp),%rdi
  5aa88b:	00 
  5aa88c:	48 8b 74 24 08       	mov    0x8(%rsp),%rsi
  5aa891:	48 8b 54 24 20       	mov    0x20(%rsp),%rdx
  5aa896:	e8 c5 8d 13 00       	call   6e3660 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui6sourceINtB5_7SourcesNtNtNtB7_7runtime12style_ledger9AdversaryE7resolveB7_>
  5aa89b:	48 8b 84 24 a0 00 00 	mov    0xa0(%rsp),%rax
  5aa8a2:	00 
  5aa8a3:	4c 8b bc 24 a8 00 00 	mov    0xa8(%rsp),%r15
  5aa8aa:	00 
  5aa8ab:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  5aa8af:	0f 85 b3 4d 00 00    	jne    5af668 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5638>
  5aa8b5:	4d 85 ff             	test   %r15,%r15
  5aa8b8:	74 14                	je     5aa8ce <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x89e>
  5aa8ba:	eb 24                	jmp    5aa8e0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x8b0>
  5aa8bc:	45 31 ff             	xor    %r15d,%r15d
  5aa8bf:	4d 85 ff             	test   %r15,%r15
  5aa8c2:	74 0a                	je     5aa8ce <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x89e>
  5aa8c4:	eb 1a                	jmp    5aa8e0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x8b0>
  5aa8c6:	45 31 ff             	xor    %r15d,%r15d
  5aa8c9:	4d 85 ff             	test   %r15,%r15
  5aa8cc:	75 12                	jne    5aa8e0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x8b0>
  5aa8ce:	48 8b 44 24 40       	mov    0x40(%rsp),%rax
  5aa8d3:	80 b8 90 00 00 00 02 	cmpb   $0x2,0x90(%rax)
  5aa8da:	0f 84 83 49 00 00    	je     5af263 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5233>
  5aa8e0:	4d 85 ff             	test   %r15,%r15
  5aa8e3:	0f 84 b8 01 00 00    	je     5aaaa1 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0xa71>
  5aa8e9:	48 83 fb ff          	cmp    $0xffffffffffffffff,%rbx
  5aa8ed:	0f 84 55 3e 00 00    	je     5ae748 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4718>
  5aa8f3:	48 b8 01 00 00 00 00 	movabs $0x8000000000000001,%rax
  5aa8fa:	00 00 80 
  5aa8fd:	48 ff c0             	inc    %rax
  5aa900:	48 8b 4c 24 40       	mov    0x40(%rsp),%rcx
  5aa905:	48 39 01             	cmp    %rax,(%rcx)
  5aa908:	0f 85 3a 3e 00 00    	jne    5ae748 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4718>
  5aa90e:	48 8b 44 24 40       	mov    0x40(%rsp),%rax
  5aa913:	48 8b 78 08          	mov    0x8(%rax),%rdi
  5aa917:	48 8b 40 10          	mov    0x10(%rax),%rax
  5aa91b:	ff 50 30             	call   *0x30(%rax)
  5aa91e:	48 85 c0             	test   %rax,%rax
  5aa921:	0f 84 21 3e 00 00    	je     5ae748 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4718>
  5aa927:	48 8b 9c 24 30 02 00 	mov    0x230(%rsp),%rbx
  5aa92e:	00 
  5aa92f:	48 85 db             	test   %rbx,%rbx
  5aa932:	0f 84 84 00 00 00    	je     5aa9bc <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x98c>
  5aa938:	48 8b 8c 24 38 02 00 	mov    0x238(%rsp),%rcx
  5aa93f:	00 
  5aa940:	0f b7 b3 1a 02 00 00 	movzwl 0x21a(%rbx),%esi
  5aa947:	8d 3c f5 00 00 00 00 	lea    0x0(,%rsi,8),%edi
  5aa94e:	4c 8d 04 bf          	lea    (%rdi,%rdi,4),%r8
  5aa952:	49 c7 c6 ff ff ff ff 	mov    $0xffffffffffffffff,%r14
  5aa959:	31 ff                	xor    %edi,%edi
  5aa95b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
  5aa960:	4d 89 c1             	mov    %r8,%r9
  5aa963:	49 01 f9             	add    %rdi,%r9
  5aa966:	74 24                	je     5aa98c <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x95c>
  5aa968:	4e 3b 7c f3 10       	cmp    0x10(%rbx,%r14,8),%r15
  5aa96d:	41 0f 97 c1          	seta   %r9b
  5aa971:	41 80 d9 00          	sbb    $0x0,%r9b
  5aa975:	48 83 c7 d8          	add    $0xffffffffffffffd8,%rdi
  5aa979:	49 ff c6             	inc    %r14
  5aa97c:	41 80 f9 01          	cmp    $0x1,%r9b
  5aa980:	74 de                	je     5aa960 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x930>
  5aa982:	41 0f b6 f1          	movzbl %r9b,%esi
  5aa986:	85 f6                	test   %esi,%esi
  5aa988:	75 05                	jne    5aa98f <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x95f>
  5aa98a:	eb 17                	jmp    5aa9a3 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x973>
  5aa98c:	49 89 f6             	mov    %rsi,%r14
  5aa98f:	48 83 e9 01          	sub    $0x1,%rcx
  5aa993:	0f 82 62 01 00 00    	jb     5aaafb <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0xacb>
  5aa999:	4a 8b 9c f3 20 02 00 	mov    0x220(%rbx,%r14,8),%rbx
  5aa9a0:	00 
  5aa9a1:	eb 9d                	jmp    5aa940 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x910>
  5aa9a3:	48 29 fb             	sub    %rdi,%rbx
  5aa9a6:	48 83 c3 38          	add    $0x38,%rbx
  5aa9aa:	4c 89 74 24 50       	mov    %r14,0x50(%rsp)
  5aa9af:	4c 8d b4 24 30 02 00 	lea    0x230(%rsp),%r14
  5aa9b6:	00 
  5aa9b7:	e9 a4 00 00 00       	jmp    5aaa60 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0xa30>
  5aa9bc:	31 db                	xor    %ebx,%ebx
  5aa9be:	4c 89 bc 24 00 03 00 	mov    %r15,0x300(%rsp)
  5aa9c5:	00 
  5aa9c6:	48 8d 8c 24 30 02 00 	lea    0x230(%rsp),%rcx
  5aa9cd:	00 
  5aa9ce:	48 89 8c 24 08 03 00 	mov    %rcx,0x308(%rsp)
  5aa9d5:	00 
  5aa9d6:	48 89 9c 24 10 03 00 	mov    %rbx,0x310(%rsp)
  5aa9dd:	00 
  5aa9de:	48 8b 4c 24 50       	mov    0x50(%rsp),%rcx
  5aa9e3:	48 89 8c 24 18 03 00 	mov    %rcx,0x318(%rsp)
  5aa9ea:	00 
  5aa9eb:	4c 89 b4 24 20 03 00 	mov    %r14,0x320(%rsp)
  5aa9f2:	00 
  5aa9f3:	48 89 84 24 b8 00 00 	mov    %rax,0xb8(%rsp)
  5aa9fa:	00 
  5aa9fb:	48 89 94 24 c0 00 00 	mov    %rdx,0xc0(%rsp)
  5aaa02:	00 
  5aaa03:	48 c7 84 24 a0 00 00 	movq   $0x0,0xa0(%rsp)
  5aaa0a:	00 00 00 00 00 
  5aaa0f:	48 c7 84 24 a8 00 00 	movq   $0x4,0xa8(%rsp)
  5aaa16:	00 04 00 00 00 
  5aaa1b:	48 c7 84 24 b0 00 00 	movq   $0x0,0xb0(%rsp)
  5aaa22:	00 00 00 00 00 
  5aaa27:	48 8d bc 24 90 01 00 	lea    0x190(%rsp),%rdi
  5aaa2e:	00 
  5aaa2f:	48 8d b4 24 00 03 00 	lea    0x300(%rsp),%rsi
  5aaa36:	00 
  5aaa37:	48 8d 94 24 a0 00 00 	lea    0xa0(%rsp),%rdx
  5aaa3e:	00 
  5aaa3f:	e8 2c dd 1c 00       	call   778770 <_RNvMs4_NtNtNtNtCscdodAO9FK5_5alloc11collections5btree3map5entryINtB5_11VacantEntryNtNtCs6gaF1xUz9Bf_4gpui6source7FieldIdNtNtB1m_7runtime6FanoutE12insert_entryB1m_.llvm.5148459089407822190>
  5aaa44:	48 8b 84 24 90 01 00 	mov    0x190(%rsp),%rax
  5aaa4b:	00 
  5aaa4c:	48 8b 8c 24 a0 01 00 	mov    0x1a0(%rsp),%rcx
  5aaa53:	00 
  5aaa54:	48 8d 0c 89          	lea    (%rcx,%rcx,4),%rcx
  5aaa58:	48 8d 1c c8          	lea    (%rax,%rcx,8),%rbx
  5aaa5c:	48 83 c3 60          	add    $0x60,%rbx
  5aaa60:	48 81 bc 24 80 00 00 	cmpq   $0x186a0,0x80(%rsp)
  5aaa67:	00 a0 86 01 00 
  5aaa6c:	0f 83 94 4d 00 00    	jae    5af806 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x57d6>
  5aaa72:	4c 8b 6b 10          	mov    0x10(%rbx),%r13
  5aaa76:	4c 3b 2b             	cmp    (%rbx),%r13
  5aaa79:	75 08                	jne    5aaa83 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0xa53>
  5aaa7b:	48 89 df             	mov    %rbx,%rdi
  5aaa7e:	e8 6d 2f 22 00       	call   7cd9f0 <_RNvMs3_NtCscdodAO9FK5_5alloc7raw_vecINtB5_6RawVecNtNtCs6gaF1xUz9Bf_4gpui7runtime6ParentE8grow_oneBP_>
  5aaa83:	48 8b 84 24 80 00 00 	mov    0x80(%rsp),%rax
  5aaa8a:	00 
  5aaa8b:	8d 04 85 00 00 00 00 	lea    0x0(,%rax,4),%eax
  5aaa92:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  5aaa96:	42 89 04 a9          	mov    %eax,(%rcx,%r13,4)
  5aaa9a:	49 ff c5             	inc    %r13
  5aaa9d:	4c 89 6b 10          	mov    %r13,0x10(%rbx)
  5aaaa1:	48 8b 9c 24 98 02 00 	mov    0x298(%rsp),%rbx
  5aaaa8:	00 
  5aaaa9:	48 3b 9c 24 88 02 00 	cmp    0x288(%rsp),%rbx
  5aaab0:	00 
  5aaab1:	75 0d                	jne    5aaac0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0xa90>
  5aaab3:	48 8d bc 24 88 02 00 	lea    0x288(%rsp),%rdi
  5aaaba:	00 
  5aaabb:	e8 80 29 22 00       	call   7cd440 <_RNvMs3_NtCscdodAO9FK5_5alloc7raw_vecINtB5_6RawVecINtNtCs4NRVxsYgnAr_4core6option6OptionNtNtCs6gaF1xUz9Bf_4gpui6source7FieldIdEE8grow_oneB1r_>
  5aaac0:	48 8b 4c 24 40       	mov    0x40(%rsp),%rcx
  5aaac5:	48 81 c1 98 00 00 00 	add    $0x98,%rcx
  5aaacc:	48 ff 84 24 80 00 00 	incq   0x80(%rsp)
  5aaad3:	00 
  5aaad4:	48 8b 84 24 90 02 00 	mov    0x290(%rsp),%rax
  5aaadb:	00 
  5aaadc:	4c 89 3c d8          	mov    %r15,(%rax,%rbx,8)
  5aaae0:	49 89 cf             	mov    %rcx,%r15
  5aaae3:	48 ff c3             	inc    %rbx
  5aaae6:	48 89 9c 24 98 02 00 	mov    %rbx,0x298(%rsp)
  5aaaed:	00 
  5aaaee:	48 3b 4c 24 60       	cmp    0x60(%rsp),%rcx
  5aaaf3:	0f 85 6a fb ff ff    	jne    5aa663 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x633>
  5aaaf9:	eb 0e                	jmp    5aab09 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0xad9>
  5aaafb:	48 c7 44 24 50 00 00 	movq   $0x0,0x50(%rsp)
  5aab02:	00 00 
  5aab04:	e9 b5 fe ff ff       	jmp    5aa9be <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x98e>
  5aab09:	4c 8b b4 24 50 04 00 	mov    0x450(%rsp),%r14
  5aab10:	00 
  5aab11:	4d 85 f6             	test   %r14,%r14
  5aab14:	0f 84 f0 05 00 00    	je     5ab10a <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x10da>
  5aab1a:	4c 89 f3             	mov    %r14,%rbx
  5aab1d:	48 c1 e3 04          	shl    $0x4,%rbx
  5aab21:	ff 15 c9 f3 53 00    	call   *0x53f3c9(%rip)        # ae9ef0 <_DYNAMIC+0x340>
  5aab27:	be 08 00 00 00       	mov    $0x8,%esi
  5aab2c:	48 89 df             	mov    %rbx,%rdi
  5aab2f:	ff 15 bb f2 53 00    	call   *0x53f2bb(%rip)        # ae9df0 <_DYNAMIC+0x240>
  5aab35:	48 85 c0             	test   %rax,%rax
  5aab38:	0f 84 cd 4f 00 00    	je     5afb0b <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5adb>
  5aab3e:	4c 89 b4 24 b8 02 00 	mov    %r14,0x2b8(%rsp)
  5aab45:	00 
  5aab46:	48 89 84 24 c0 02 00 	mov    %rax,0x2c0(%rsp)
  5aab4d:	00 
  5aab4e:	48 c7 84 24 c8 02 00 	movq   $0x0,0x2c8(%rsp)
  5aab55:	00 00 00 00 00 
  5aab5a:	4c 8b ac 24 48 04 00 	mov    0x448(%rsp),%r13
  5aab61:	00 
  5aab62:	49 6b c6 38          	imul   $0x38,%r14,%rax
  5aab66:	4c 01 e8             	add    %r13,%rax
  5aab69:	48 89 84 24 80 00 00 	mov    %rax,0x80(%rsp)
  5aab70:	00 
  5aab71:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  5aab76:	48 05 50 02 00 00    	add    $0x250,%rax
  5aab7c:	48 89 44 24 60       	mov    %rax,0x60(%rsp)
  5aab81:	48 b8 01 00 00 00 00 	movabs $0x8000000000000001,%rax
  5aab88:	00 00 80 
  5aab8b:	48 ff c0             	inc    %rax
  5aab8e:	48 89 44 24 40       	mov    %rax,0x40(%rsp)
  5aab93:	eb 45                	jmp    5aabda <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0xbaa>
  5aab95:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
  5aab9c:	00 00 00 00 
  5aaba0:	49 83 c5 38          	add    $0x38,%r13
  5aaba4:	48 8b 84 24 c0 02 00 	mov    0x2c0(%rsp),%rax
  5aabab:	00 
  5aabac:	48 89 e9             	mov    %rbp,%rcx
  5aabaf:	48 c1 e1 04          	shl    $0x4,%rcx
  5aabb3:	48 8b 54 24 08       	mov    0x8(%rsp),%rdx
  5aabb8:	48 89 14 08          	mov    %rdx,(%rax,%rcx,1)
  5aabbc:	4c 89 7c 08 08       	mov    %r15,0x8(%rax,%rcx,1)
  5aabc1:	48 ff c5             	inc    %rbp
  5aabc4:	48 89 ac 24 c8 02 00 	mov    %rbp,0x2c8(%rsp)
  5aabcb:	00 
  5aabcc:	4c 3b ac 24 80 00 00 	cmp    0x80(%rsp),%r13
  5aabd3:	00 
  5aabd4:	0f 84 54 05 00 00    	je     5ab12e <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x10fe>
  5aabda:	49 8b 45 00          	mov    0x0(%r13),%rax
  5aabde:	49 8b 4d 18          	mov    0x18(%r13),%rcx
  5aabe2:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  5aabe6:	0f 84 04 01 00 00    	je     5aacf0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0xcc0>
  5aabec:	48 3b 44 24 40       	cmp    0x40(%rsp),%rax
  5aabf1:	0f 85 f9 00 00 00    	jne    5aacf0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0xcc0>
  5aabf7:	48 89 4c 24 18       	mov    %rcx,0x18(%rsp)
  5aabfc:	49 8b 4d 08          	mov    0x8(%r13),%rcx
  5aac00:	4d 8b 45 10          	mov    0x10(%r13),%r8
  5aac04:	48 8d bc 24 a0 00 00 	lea    0xa0(%rsp),%rdi
  5aac0b:	00 
  5aac0c:	48 8b 74 24 60       	mov    0x60(%rsp),%rsi
  5aac11:	48 8b 54 24 20       	mov    0x20(%rsp),%rdx
  5aac16:	e8 45 8a 13 00       	call   6e3660 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui6sourceINtB5_7SourcesNtNtNtB7_7runtime12style_ledger9AdversaryE7resolveB7_>
  5aac1b:	48 8b 84 24 a0 00 00 	mov    0xa0(%rsp),%rax
  5aac22:	00 
  5aac23:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  5aac27:	0f 85 ac 12 00 00    	jne    5abed9 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1ea9>
  5aac2d:	48 8b 8c 24 a8 00 00 	mov    0xa8(%rsp),%rcx
  5aac34:	00 
  5aac35:	48 89 4c 24 08       	mov    %rcx,0x8(%rsp)
  5aac3a:	48 85 c9             	test   %rcx,%rcx
  5aac3d:	0f 84 c5 00 00 00    	je     5aad08 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0xcd8>
  5aac43:	48 8b 44 24 40       	mov    0x40(%rsp),%rax
  5aac48:	49 39 45 00          	cmp    %rax,0x0(%r13)
  5aac4c:	0f 85 98 3a 00 00    	jne    5ae6ea <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x46ba>
  5aac52:	49 8b 7d 08          	mov    0x8(%r13),%rdi
  5aac56:	49 8b 45 10          	mov    0x10(%r13),%rax
  5aac5a:	ff 50 30             	call   *0x30(%rax)
  5aac5d:	48 85 c0             	test   %rax,%rax
  5aac60:	0f 84 84 3a 00 00    	je     5ae6ea <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x46ba>
  5aac66:	48 8b ac 24 30 02 00 	mov    0x230(%rsp),%rbp
  5aac6d:	00 
  5aac6e:	48 85 ed             	test   %rbp,%rbp
  5aac71:	0f 84 c7 00 00 00    	je     5aad3e <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0xd0e>
  5aac77:	48 8b 8c 24 38 02 00 	mov    0x238(%rsp),%rcx
  5aac7e:	00 
  5aac7f:	0f b7 b5 1a 02 00 00 	movzwl 0x21a(%rbp),%esi
  5aac86:	8d 3c f5 00 00 00 00 	lea    0x0(,%rsi,8),%edi
  5aac8d:	4c 8d 04 bf          	lea    (%rdi,%rdi,4),%r8
  5aac91:	48 c7 c3 ff ff ff ff 	mov    $0xffffffffffffffff,%rbx
  5aac98:	31 ff                	xor    %edi,%edi
  5aac9a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
  5aaca0:	4d 89 c1             	mov    %r8,%r9
  5aaca3:	49 01 f9             	add    %rdi,%r9
  5aaca6:	74 29                	je     5aacd1 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0xca1>
  5aaca8:	4c 8b 4c 24 08       	mov    0x8(%rsp),%r9
  5aacad:	4c 3b 4c dd 10       	cmp    0x10(%rbp,%rbx,8),%r9
  5aacb2:	41 0f 97 c1          	seta   %r9b
  5aacb6:	41 80 d9 00          	sbb    $0x0,%r9b
  5aacba:	48 83 c7 d8          	add    $0xffffffffffffffd8,%rdi
  5aacbe:	48 ff c3             	inc    %rbx
  5aacc1:	41 80 f9 01          	cmp    $0x1,%r9b
  5aacc5:	74 d9                	je     5aaca0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0xc70>
  5aacc7:	41 0f b6 f1          	movzbl %r9b,%esi
  5aaccb:	85 f6                	test   %esi,%esi
  5aaccd:	75 05                	jne    5aacd4 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0xca4>
  5aaccf:	eb 54                	jmp    5aad25 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0xcf5>
  5aacd1:	48 89 f3             	mov    %rsi,%rbx
  5aacd4:	48 83 e9 01          	sub    $0x1,%rcx
  5aacd8:	0f 82 97 03 00 00    	jb     5ab075 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1045>
  5aacde:	48 8b ac dd 20 02 00 	mov    0x220(%rbp,%rbx,8),%rbp
  5aace5:	00 
  5aace6:	eb 97                	jmp    5aac7f <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0xc4f>
  5aace8:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  5aacef:	00 
  5aacf0:	48 c7 44 24 08 00 00 	movq   $0x0,0x8(%rsp)
  5aacf7:	00 00 
  5aacf9:	48 83 f9 ff          	cmp    $0xffffffffffffffff,%rcx
  5aacfd:	0f 85 2d 01 00 00    	jne    5aae30 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0xe00>
  5aad03:	e9 28 02 00 00       	jmp    5aaf30 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0xf00>
  5aad08:	48 c7 44 24 08 00 00 	movq   $0x0,0x8(%rsp)
  5aad0f:	00 00 
  5aad11:	48 8b 4c 24 18       	mov    0x18(%rsp),%rcx
  5aad16:	48 83 f9 ff          	cmp    $0xffffffffffffffff,%rcx
  5aad1a:	0f 85 10 01 00 00    	jne    5aae30 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0xe00>
  5aad20:	e9 0b 02 00 00       	jmp    5aaf30 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0xf00>
  5aad25:	48 29 fd             	sub    %rdi,%rbp
  5aad28:	48 83 c5 38          	add    $0x38,%rbp
  5aad2c:	48 89 5c 24 50       	mov    %rbx,0x50(%rsp)
  5aad31:	48 8d 9c 24 30 02 00 	lea    0x230(%rsp),%rbx
  5aad38:	00 
  5aad39:	e9 a9 00 00 00       	jmp    5aade7 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0xdb7>
  5aad3e:	31 ed                	xor    %ebp,%ebp
  5aad40:	48 8b 4c 24 08       	mov    0x8(%rsp),%rcx
  5aad45:	48 89 8c 24 00 03 00 	mov    %rcx,0x300(%rsp)
  5aad4c:	00 
  5aad4d:	48 8d 8c 24 30 02 00 	lea    0x230(%rsp),%rcx
  5aad54:	00 
  5aad55:	48 89 8c 24 08 03 00 	mov    %rcx,0x308(%rsp)
  5aad5c:	00 
  5aad5d:	48 89 ac 24 10 03 00 	mov    %rbp,0x310(%rsp)
  5aad64:	00 
  5aad65:	48 8b 4c 24 50       	mov    0x50(%rsp),%rcx
  5aad6a:	48 89 8c 24 18 03 00 	mov    %rcx,0x318(%rsp)
  5aad71:	00 
  5aad72:	48 89 9c 24 20 03 00 	mov    %rbx,0x320(%rsp)
  5aad79:	00 
  5aad7a:	48 89 84 24 b8 00 00 	mov    %rax,0xb8(%rsp)
  5aad81:	00 
  5aad82:	48 89 94 24 c0 00 00 	mov    %rdx,0xc0(%rsp)
  5aad89:	00 
  5aad8a:	48 c7 84 24 a0 00 00 	movq   $0x0,0xa0(%rsp)
  5aad91:	00 00 00 00 00 
  5aad96:	48 c7 84 24 a8 00 00 	movq   $0x4,0xa8(%rsp)
  5aad9d:	00 04 00 00 00 
  5aada2:	48 c7 84 24 b0 00 00 	movq   $0x0,0xb0(%rsp)
  5aada9:	00 00 00 00 00 
  5aadae:	48 8d bc 24 90 01 00 	lea    0x190(%rsp),%rdi
  5aadb5:	00 
  5aadb6:	48 8d b4 24 00 03 00 	lea    0x300(%rsp),%rsi
  5aadbd:	00 
  5aadbe:	48 8d 94 24 a0 00 00 	lea    0xa0(%rsp),%rdx
  5aadc5:	00 
  5aadc6:	e8 a5 d9 1c 00       	call   778770 <_RNvMs4_NtNtNtNtCscdodAO9FK5_5alloc11collections5btree3map5entryINtB5_11VacantEntryNtNtCs6gaF1xUz9Bf_4gpui6source7FieldIdNtNtB1m_7runtime6FanoutE12insert_entryB1m_.llvm.5148459089407822190>
  5aadcb:	48 8b 84 24 90 01 00 	mov    0x190(%rsp),%rax
  5aadd2:	00 
  5aadd3:	48 8b 8c 24 a0 01 00 	mov    0x1a0(%rsp),%rcx
  5aadda:	00 
  5aaddb:	48 8d 0c 89          	lea    (%rcx,%rcx,4),%rcx
  5aaddf:	48 8d 2c c8          	lea    (%rax,%rcx,8),%rbp
  5aade3:	48 83 c5 60          	add    $0x60,%rbp
  5aade7:	45 8b 7d 30          	mov    0x30(%r13),%r15d
  5aadeb:	41 81 ff 9f 86 01 00 	cmp    $0x1869f,%r15d
  5aadf2:	0f 87 50 49 00 00    	ja     5af748 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5718>
  5aadf8:	4c 8b 75 10          	mov    0x10(%rbp),%r14
  5aadfc:	4c 3b 75 00          	cmp    0x0(%rbp),%r14
  5aae00:	75 08                	jne    5aae0a <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0xdda>
  5aae02:	48 89 ef             	mov    %rbp,%rdi
  5aae05:	e8 e6 2b 22 00       	call   7cd9f0 <_RNvMs3_NtCscdodAO9FK5_5alloc7raw_vecINtB5_6RawVecNtNtCs6gaF1xUz9Bf_4gpui7runtime6ParentE8grow_oneBP_>
  5aae0a:	42 8d 04 bd 01 00 00 	lea    0x1(,%r15,4),%eax
  5aae11:	00 
  5aae12:	48 8b 4d 08          	mov    0x8(%rbp),%rcx
  5aae16:	42 89 04 b1          	mov    %eax,(%rcx,%r14,4)
  5aae1a:	49 ff c6             	inc    %r14
  5aae1d:	4c 89 75 10          	mov    %r14,0x10(%rbp)
  5aae21:	48 8b 4c 24 18       	mov    0x18(%rsp),%rcx
  5aae26:	48 83 f9 ff          	cmp    $0xffffffffffffffff,%rcx
  5aae2a:	0f 84 00 01 00 00    	je     5aaf30 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0xf00>
  5aae30:	48 8b 44 24 40       	mov    0x40(%rsp),%rax
  5aae35:	49 39 45 18          	cmp    %rax,0x18(%r13)
  5aae39:	0f 85 f1 00 00 00    	jne    5aaf30 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0xf00>
  5aae3f:	49 8b 4d 20          	mov    0x20(%r13),%rcx
  5aae43:	4d 8b 45 28          	mov    0x28(%r13),%r8
  5aae47:	48 8d bc 24 a0 00 00 	lea    0xa0(%rsp),%rdi
  5aae4e:	00 
  5aae4f:	48 8b 74 24 60       	mov    0x60(%rsp),%rsi
  5aae54:	48 8b 54 24 20       	mov    0x20(%rsp),%rdx
  5aae59:	e8 02 88 13 00       	call   6e3660 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui6sourceINtB5_7SourcesNtNtNtB7_7runtime12style_ledger9AdversaryE7resolveB7_>
  5aae5e:	48 8b 84 24 a0 00 00 	mov    0xa0(%rsp),%rax
  5aae65:	00 
  5aae66:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  5aae6a:	0f 85 69 10 00 00    	jne    5abed9 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1ea9>
  5aae70:	4c 8b bc 24 a8 00 00 	mov    0xa8(%rsp),%r15
  5aae77:	00 
  5aae78:	4d 85 ff             	test   %r15,%r15
  5aae7b:	0f 84 af 00 00 00    	je     5aaf30 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0xf00>
  5aae81:	48 8b 44 24 40       	mov    0x40(%rsp),%rax
  5aae86:	49 39 45 18          	cmp    %rax,0x18(%r13)
  5aae8a:	0f 85 5f 38 00 00    	jne    5ae6ef <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x46bf>
  5aae90:	49 8b 7d 20          	mov    0x20(%r13),%rdi
  5aae94:	49 8b 45 28          	mov    0x28(%r13),%rax
  5aae98:	ff 50 30             	call   *0x30(%rax)
  5aae9b:	48 85 c0             	test   %rax,%rax
  5aae9e:	0f 84 4b 38 00 00    	je     5ae6ef <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x46bf>
  5aaea4:	48 8b ac 24 30 02 00 	mov    0x230(%rsp),%rbp
  5aaeab:	00 
  5aaeac:	48 85 ed             	test   %rbp,%rbp
  5aaeaf:	0f 84 bf 00 00 00    	je     5aaf74 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0xf44>
  5aaeb5:	48 8b 8c 24 38 02 00 	mov    0x238(%rsp),%rcx
  5aaebc:	00 
  5aaebd:	0f b7 b5 1a 02 00 00 	movzwl 0x21a(%rbp),%esi
  5aaec4:	8d 3c f5 00 00 00 00 	lea    0x0(,%rsi,8),%edi
  5aaecb:	4c 8d 04 bf          	lea    (%rdi,%rdi,4),%r8
  5aaecf:	48 c7 c3 ff ff ff ff 	mov    $0xffffffffffffffff,%rbx
  5aaed6:	31 ff                	xor    %edi,%edi
  5aaed8:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  5aaedf:	00 
  5aaee0:	4d 89 c1             	mov    %r8,%r9
  5aaee3:	49 01 f9             	add    %rdi,%r9
  5aaee6:	74 24                	je     5aaf0c <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0xedc>
  5aaee8:	4c 3b 7c dd 10       	cmp    0x10(%rbp,%rbx,8),%r15
  5aaeed:	41 0f 97 c1          	seta   %r9b
  5aaef1:	41 80 d9 00          	sbb    $0x0,%r9b
  5aaef5:	48 83 c7 d8          	add    $0xffffffffffffffd8,%rdi
  5aaef9:	48 ff c3             	inc    %rbx
  5aaefc:	41 80 f9 01          	cmp    $0x1,%r9b
  5aaf00:	74 de                	je     5aaee0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0xeb0>
  5aaf02:	41 0f b6 f1          	movzbl %r9b,%esi
  5aaf06:	85 f6                	test   %esi,%esi
  5aaf08:	75 05                	jne    5aaf0f <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0xedf>
  5aaf0a:	eb 4f                	jmp    5aaf5b <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0xf2b>
  5aaf0c:	48 89 f3             	mov    %rsi,%rbx
  5aaf0f:	48 83 e9 01          	sub    $0x1,%rcx
  5aaf13:	0f 82 6a 01 00 00    	jb     5ab083 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1053>
  5aaf19:	48 8b ac dd 20 02 00 	mov    0x220(%rbp,%rbx,8),%rbp
  5aaf20:	00 
  5aaf21:	eb 9a                	jmp    5aaebd <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0xe8d>
  5aaf23:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  5aaf2a:	84 00 00 00 00 00 
  5aaf30:	45 31 ff             	xor    %r15d,%r15d
  5aaf33:	48 8b ac 24 c8 02 00 	mov    0x2c8(%rsp),%rbp
  5aaf3a:	00 
  5aaf3b:	48 3b ac 24 b8 02 00 	cmp    0x2b8(%rsp),%rbp
  5aaf42:	00 
  5aaf43:	0f 85 57 fc ff ff    	jne    5aaba0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0xb70>
  5aaf49:	48 8d bc 24 b8 02 00 	lea    0x2b8(%rsp),%rdi
  5aaf50:	00 
  5aaf51:	e8 7a 24 22 00       	call   7cd3d0 <_RNvMs3_NtCscdodAO9FK5_5alloc7raw_vecINtB5_6RawVecAINtNtCs4NRVxsYgnAr_4core6option6OptionNtNtCs6gaF1xUz9Bf_4gpui6source7FieldIdEj2_E8grow_oneB1s_>
  5aaf56:	e9 45 fc ff ff       	jmp    5aaba0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0xb70>
  5aaf5b:	48 29 fd             	sub    %rdi,%rbp
  5aaf5e:	48 83 c5 38          	add    $0x38,%rbp
  5aaf62:	48 89 5c 24 50       	mov    %rbx,0x50(%rsp)
  5aaf67:	48 8d 9c 24 30 02 00 	lea    0x230(%rsp),%rbx
  5aaf6e:	00 
  5aaf6f:	e9 a4 00 00 00       	jmp    5ab018 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0xfe8>
  5aaf74:	31 ed                	xor    %ebp,%ebp
  5aaf76:	4c 89 bc 24 00 03 00 	mov    %r15,0x300(%rsp)
  5aaf7d:	00 
  5aaf7e:	48 8d 8c 24 30 02 00 	lea    0x230(%rsp),%rcx
  5aaf85:	00 
  5aaf86:	48 89 8c 24 08 03 00 	mov    %rcx,0x308(%rsp)
  5aaf8d:	00 
  5aaf8e:	48 89 ac 24 10 03 00 	mov    %rbp,0x310(%rsp)
  5aaf95:	00 
  5aaf96:	48 8b 4c 24 50       	mov    0x50(%rsp),%rcx
  5aaf9b:	48 89 8c 24 18 03 00 	mov    %rcx,0x318(%rsp)
  5aafa2:	00 
  5aafa3:	48 89 9c 24 20 03 00 	mov    %rbx,0x320(%rsp)
  5aafaa:	00 
  5aafab:	48 89 84 24 b8 00 00 	mov    %rax,0xb8(%rsp)
  5aafb2:	00 
  5aafb3:	48 89 94 24 c0 00 00 	mov    %rdx,0xc0(%rsp)
  5aafba:	00 
  5aafbb:	48 c7 84 24 a0 00 00 	movq   $0x0,0xa0(%rsp)
  5aafc2:	00 00 00 00 00 
  5aafc7:	48 c7 84 24 a8 00 00 	movq   $0x4,0xa8(%rsp)
  5aafce:	00 04 00 00 00 
  5aafd3:	48 c7 84 24 b0 00 00 	movq   $0x0,0xb0(%rsp)
  5aafda:	00 00 00 00 00 
  5aafdf:	48 8d bc 24 90 01 00 	lea    0x190(%rsp),%rdi
  5aafe6:	00 
  5aafe7:	48 8d b4 24 00 03 00 	lea    0x300(%rsp),%rsi
  5aafee:	00 
  5aafef:	48 8d 94 24 a0 00 00 	lea    0xa0(%rsp),%rdx
  5aaff6:	00 
  5aaff7:	e8 74 d7 1c 00       	call   778770 <_RNvMs4_NtNtNtNtCscdodAO9FK5_5alloc11collections5btree3map5entryINtB5_11VacantEntryNtNtCs6gaF1xUz9Bf_4gpui6source7FieldIdNtNtB1m_7runtime6FanoutE12insert_entryB1m_.llvm.5148459089407822190>
  5aaffc:	48 8b 84 24 90 01 00 	mov    0x190(%rsp),%rax
  5ab003:	00 
  5ab004:	48 8b 8c 24 a0 01 00 	mov    0x1a0(%rsp),%rcx
  5ab00b:	00 
  5ab00c:	48 8d 0c 89          	lea    (%rcx,%rcx,4),%rcx
  5ab010:	48 8d 2c c8          	lea    (%rax,%rcx,8),%rbp
  5ab014:	48 83 c5 60          	add    $0x60,%rbp
  5ab018:	41 8b 4d 30          	mov    0x30(%r13),%ecx
  5ab01c:	48 89 4c 24 18       	mov    %rcx,0x18(%rsp)
  5ab021:	81 f9 a0 86 01 00    	cmp    $0x186a0,%ecx
  5ab027:	0f 83 1b 47 00 00    	jae    5af748 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5718>
  5ab02d:	4c 8b 75 10          	mov    0x10(%rbp),%r14
  5ab031:	4c 3b 75 00          	cmp    0x0(%rbp),%r14
  5ab035:	75 08                	jne    5ab03f <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x100f>
  5ab037:	48 89 ef             	mov    %rbp,%rdi
  5ab03a:	e8 b1 29 22 00       	call   7cd9f0 <_RNvMs3_NtCscdodAO9FK5_5alloc7raw_vecINtB5_6RawVecNtNtCs6gaF1xUz9Bf_4gpui7runtime6ParentE8grow_oneBP_>
  5ab03f:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
  5ab044:	8d 04 85 02 00 00 00 	lea    0x2(,%rax,4),%eax
  5ab04b:	48 8b 4d 08          	mov    0x8(%rbp),%rcx
  5ab04f:	42 89 04 b1          	mov    %eax,(%rcx,%r14,4)
  5ab053:	49 ff c6             	inc    %r14
  5ab056:	4c 89 75 10          	mov    %r14,0x10(%rbp)
  5ab05a:	48 8b ac 24 c8 02 00 	mov    0x2c8(%rsp),%rbp
  5ab061:	00 
  5ab062:	48 3b ac 24 b8 02 00 	cmp    0x2b8(%rsp),%rbp
  5ab069:	00 
  5ab06a:	0f 85 30 fb ff ff    	jne    5aaba0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0xb70>
  5ab070:	e9 d4 fe ff ff       	jmp    5aaf49 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0xf19>
  5ab075:	48 c7 44 24 50 00 00 	movq   $0x0,0x50(%rsp)
  5ab07c:	00 00 
  5ab07e:	e9 bd fc ff ff       	jmp    5aad40 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0xd10>
  5ab083:	48 c7 44 24 50 00 00 	movq   $0x0,0x50(%rsp)
  5ab08a:	00 00 
  5ab08c:	e9 e5 fe ff ff       	jmp    5aaf76 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0xf46>
  5ab091:	0f 10 84 24 a8 00 00 	movups 0xa8(%rsp),%xmm0
  5ab098:	00 
  5ab099:	48 8b 8c 24 88 00 00 	mov    0x88(%rsp),%rcx
  5ab0a0:	00 
  5ab0a1:	48 c7 01 1f 00 00 00 	movq   $0x1f,(%rcx)
  5ab0a8:	48 89 41 08          	mov    %rax,0x8(%rcx)
  5ab0ac:	0f 11 41 10          	movups %xmm0,0x10(%rcx)
  5ab0b0:	48 8b 8c 24 30 02 00 	mov    0x230(%rsp),%rcx
  5ab0b7:	00 
  5ab0b8:	48 85 c9             	test   %rcx,%rcx
  5ab0bb:	0f 85 df 41 00 00    	jne    5af2a0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5270>
  5ab0c1:	31 c9                	xor    %ecx,%ecx
  5ab0c3:	31 c0                	xor    %eax,%eax
  5ab0c5:	e9 23 42 00 00       	jmp    5af2ed <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x52bd>
  5ab0ca:	8b 8c 24 b4 00 00 00 	mov    0xb4(%rsp),%ecx
  5ab0d1:	48 8b 94 24 88 00 00 	mov    0x88(%rsp),%rdx
  5ab0d8:	00 
  5ab0d9:	89 4a 1c             	mov    %ecx,0x1c(%rdx)
  5ab0dc:	48 8b 8c 24 ac 00 00 	mov    0xac(%rsp),%rcx
  5ab0e3:	00 
  5ab0e4:	48 89 4a 14          	mov    %rcx,0x14(%rdx)
  5ab0e8:	48 c7 02 1f 00 00 00 	movq   $0x1f,(%rdx)
  5ab0ef:	48 89 42 08          	mov    %rax,0x8(%rdx)
  5ab0f3:	44 89 7a 10          	mov    %r15d,0x10(%rdx)
  5ab0f7:	48 8b 8c 24 30 02 00 	mov    0x230(%rsp),%rcx
  5ab0fe:	00 
  5ab0ff:	48 85 c9             	test   %rcx,%rcx
  5ab102:	0f 85 98 41 00 00    	jne    5af2a0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5270>
  5ab108:	eb b7                	jmp    5ab0c1 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1091>
  5ab10a:	48 c7 84 24 b8 02 00 	movq   $0x0,0x2b8(%rsp)
  5ab111:	00 00 00 00 00 
  5ab116:	48 c7 84 24 c0 02 00 	movq   $0x8,0x2c0(%rsp)
  5ab11d:	00 08 00 00 00 
  5ab122:	48 c7 84 24 c8 02 00 	movq   $0x0,0x2c8(%rsp)
  5ab129:	00 00 00 00 00 
  5ab12e:	48 c7 84 24 58 04 00 	movq   $0x0,0x458(%rsp)
  5ab135:	00 00 00 00 00 
  5ab13a:	48 c7 84 24 68 04 00 	movq   $0x0,0x468(%rsp)
  5ab141:	00 00 00 00 00 
  5ab146:	48 8b 84 24 30 02 00 	mov    0x230(%rsp),%rax
  5ab14d:	00 
  5ab14e:	4c 8b b4 24 40 02 00 	mov    0x240(%rsp),%r14
  5ab155:	00 
  5ab156:	48 85 c0             	test   %rax,%rax
  5ab159:	0f 95 c1             	setne  %cl
  5ab15c:	4d 85 f6             	test   %r14,%r14
  5ab15f:	0f 95 c2             	setne  %dl
  5ab162:	20 ca                	and    %cl,%dl
  5ab164:	80 fa 01             	cmp    $0x1,%dl
  5ab167:	0f 85 61 02 00 00    	jne    5ab3ce <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x139e>
  5ab16d:	48 8b ac 24 38 02 00 	mov    0x238(%rsp),%rbp
  5ab174:	00 
  5ab175:	45 31 ed             	xor    %r13d,%r13d
  5ab178:	4c 8d 7c 24 6f       	lea    0x6f(%rsp),%r15
  5ab17d:	48 8d 9c 24 a0 00 00 	lea    0xa0(%rsp),%rbx
  5ab184:	00 
  5ab185:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
  5ab18c:	00 00 00 00 
  5ab190:	4d 85 ed             	test   %r13,%r13
  5ab193:	74 2b                	je     5ab1c0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1190>
  5ab195:	41 0f b7 8d 1a 02 00 	movzwl 0x21a(%r13),%ecx
  5ab19c:	00 
  5ab19d:	48 39 cd             	cmp    %rcx,%rbp
  5ab1a0:	0f 83 ca 00 00 00    	jae    5ab270 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1240>
  5ab1a6:	4c 89 e9             	mov    %r13,%rcx
  5ab1a9:	48 89 ea             	mov    %rbp,%rdx
  5ab1ac:	e9 e3 00 00 00       	jmp    5ab294 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1264>
  5ab1b1:	66 66 66 66 66 66 2e 	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  5ab1b8:	0f 1f 84 00 00 00 00 
  5ab1bf:	00 
  5ab1c0:	48 85 ed             	test   %rbp,%rbp
  5ab1c3:	74 38                	je     5ab1fd <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x11cd>
  5ab1c5:	48 89 e9             	mov    %rbp,%rcx
  5ab1c8:	49 89 c5             	mov    %rax,%r13
  5ab1cb:	48 83 e1 07          	and    $0x7,%rcx
  5ab1cf:	74 31                	je     5ab202 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x11d2>
  5ab1d1:	31 d2                	xor    %edx,%edx
  5ab1d3:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  5ab1da:	84 00 00 00 00 00 
  5ab1e0:	4d 8b ad 20 02 00 00 	mov    0x220(%r13),%r13
  5ab1e7:	48 ff c2             	inc    %rdx
  5ab1ea:	48 39 d1             	cmp    %rdx,%rcx
  5ab1ed:	75 f1                	jne    5ab1e0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x11b0>
  5ab1ef:	48 89 e8             	mov    %rbp,%rax
  5ab1f2:	48 29 d0             	sub    %rdx,%rax
  5ab1f5:	48 83 fd 08          	cmp    $0x8,%rbp
  5ab1f9:	73 15                	jae    5ab210 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x11e0>
  5ab1fb:	eb 51                	jmp    5ab24e <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x121e>
  5ab1fd:	49 89 c5             	mov    %rax,%r13
  5ab200:	eb 4c                	jmp    5ab24e <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x121e>
  5ab202:	48 89 e8             	mov    %rbp,%rax
  5ab205:	48 83 fd 08          	cmp    $0x8,%rbp
  5ab209:	72 43                	jb     5ab24e <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x121e>
  5ab20b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
  5ab210:	49 8b 8d 20 02 00 00 	mov    0x220(%r13),%rcx
  5ab217:	48 8b 89 20 02 00 00 	mov    0x220(%rcx),%rcx
  5ab21e:	48 8b 89 20 02 00 00 	mov    0x220(%rcx),%rcx
  5ab225:	48 8b 89 20 02 00 00 	mov    0x220(%rcx),%rcx
  5ab22c:	48 8b 89 20 02 00 00 	mov    0x220(%rcx),%rcx
  5ab233:	48 8b 89 20 02 00 00 	mov    0x220(%rcx),%rcx
  5ab23a:	48 8b 89 20 02 00 00 	mov    0x220(%rcx),%rcx
  5ab241:	4c 8b a9 20 02 00 00 	mov    0x220(%rcx),%r13
  5ab248:	48 83 c0 f8          	add    $0xfffffffffffffff8,%rax
  5ab24c:	75 c2                	jne    5ab210 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x11e0>
  5ab24e:	31 c0                	xor    %eax,%eax
  5ab250:	31 ed                	xor    %ebp,%ebp
  5ab252:	41 0f b7 8d 1a 02 00 	movzwl 0x21a(%r13),%ecx
  5ab259:	00 
  5ab25a:	48 39 cd             	cmp    %rcx,%rbp
  5ab25d:	0f 82 43 ff ff ff    	jb     5ab1a6 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1176>
  5ab263:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  5ab26a:	84 00 00 00 00 00 
  5ab270:	49 8b 4d 00          	mov    0x0(%r13),%rcx
  5ab274:	48 85 c9             	test   %rcx,%rcx
  5ab277:	0f 84 ec 45 00 00    	je     5af869 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5839>
  5ab27d:	48 ff c0             	inc    %rax
  5ab280:	41 0f b7 95 18 02 00 	movzwl 0x218(%r13),%edx
  5ab287:	00 
  5ab288:	49 89 cd             	mov    %rcx,%r13
  5ab28b:	66 3b 91 1a 02 00 00 	cmp    0x21a(%rcx),%dx
  5ab292:	73 dc                	jae    5ab270 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1240>
  5ab294:	48 85 c0             	test   %rax,%rax
  5ab297:	0f 84 93 00 00 00    	je     5ab330 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1300>
  5ab29d:	48 8d 34 d1          	lea    (%rcx,%rdx,8),%rsi
  5ab2a1:	48 81 c6 28 02 00 00 	add    $0x228,%rsi
  5ab2a8:	48 89 c7             	mov    %rax,%rdi
  5ab2ab:	48 83 e7 07          	and    $0x7,%rdi
  5ab2af:	0f 84 ae 00 00 00    	je     5ab363 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1333>
  5ab2b5:	45 31 c0             	xor    %r8d,%r8d
  5ab2b8:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  5ab2bf:	00 
  5ab2c0:	4c 8b 2e             	mov    (%rsi),%r13
  5ab2c3:	49 8d b5 20 02 00 00 	lea    0x220(%r13),%rsi
  5ab2ca:	49 ff c0             	inc    %r8
  5ab2cd:	4c 39 c7             	cmp    %r8,%rdi
  5ab2d0:	75 ee                	jne    5ab2c0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1290>
  5ab2d2:	48 89 c7             	mov    %rax,%rdi
  5ab2d5:	4c 29 c7             	sub    %r8,%rdi
  5ab2d8:	48 83 f8 08          	cmp    $0x8,%rax
  5ab2dc:	72 43                	jb     5ab321 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x12f1>
  5ab2de:	66 90                	xchg   %ax,%ax
  5ab2e0:	48 8b 06             	mov    (%rsi),%rax
  5ab2e3:	48 8b 80 20 02 00 00 	mov    0x220(%rax),%rax
  5ab2ea:	48 8b 80 20 02 00 00 	mov    0x220(%rax),%rax
  5ab2f1:	48 8b 80 20 02 00 00 	mov    0x220(%rax),%rax
  5ab2f8:	48 8b 80 20 02 00 00 	mov    0x220(%rax),%rax
  5ab2ff:	48 8b 80 20 02 00 00 	mov    0x220(%rax),%rax
  5ab306:	48 8b 80 20 02 00 00 	mov    0x220(%rax),%rax
  5ab30d:	4c 8b a8 20 02 00 00 	mov    0x220(%rax),%r13
  5ab314:	49 8d b5 20 02 00 00 	lea    0x220(%r13),%rsi
  5ab31b:	48 83 c7 f8          	add    $0xfffffffffffffff8,%rdi
  5ab31f:	75 bf                	jne    5ab2e0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x12b0>
  5ab321:	31 ed                	xor    %ebp,%ebp
  5ab323:	eb 12                	jmp    5ab337 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1307>
  5ab325:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
  5ab32c:	00 00 00 00 
  5ab330:	48 8d 6a 01          	lea    0x1(%rdx),%rbp
  5ab334:	49 89 cd             	mov    %rcx,%r13
  5ab337:	48 8d 04 92          	lea    (%rdx,%rdx,4),%rax
  5ab33b:	48 8b 7c c1 68       	mov    0x68(%rcx,%rax,8),%rdi
  5ab340:	48 8b 74 c1 70       	mov    0x70(%rcx,%rax,8),%rsi
  5ab345:	4c 89 bc 24 a0 00 00 	mov    %r15,0xa0(%rsp)
  5ab34c:	00 
  5ab34d:	48 83 fe 02          	cmp    $0x2,%rsi
  5ab351:	73 1e                	jae    5ab371 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1341>
  5ab353:	b8 00 00 00 00       	mov    $0x0,%eax
  5ab358:	49 ff ce             	dec    %r14
  5ab35b:	0f 85 2f fe ff ff    	jne    5ab190 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1160>
  5ab361:	eb 6b                	jmp    5ab3ce <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x139e>
  5ab363:	48 89 c7             	mov    %rax,%rdi
  5ab366:	48 83 f8 08          	cmp    $0x8,%rax
  5ab36a:	72 b5                	jb     5ab321 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x12f1>
  5ab36c:	e9 6f ff ff ff       	jmp    5ab2e0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x12b0>
  5ab371:	48 83 fe 15          	cmp    $0x15,%rsi
  5ab375:	73 4d                	jae    5ab3c4 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1394>
  5ab377:	48 8d 04 b7          	lea    (%rdi,%rsi,4),%rax
  5ab37b:	48 8d 4f 04          	lea    0x4(%rdi),%rcx
  5ab37f:	ba 04 00 00 00       	mov    $0x4,%edx
  5ab384:	eb 13                	jmp    5ab399 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1369>
  5ab386:	49 89 f8             	mov    %rdi,%r8
  5ab389:	41 89 30             	mov    %esi,(%r8)
  5ab38c:	48 83 c1 04          	add    $0x4,%rcx
  5ab390:	48 83 c2 04          	add    $0x4,%rdx
  5ab394:	48 39 c1             	cmp    %rax,%rcx
  5ab397:	74 ba                	je     5ab353 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1323>
  5ab399:	44 8b 49 fc          	mov    -0x4(%rcx),%r9d
  5ab39d:	8b 31                	mov    (%rcx),%esi
  5ab39f:	44 39 ce             	cmp    %r9d,%esi
  5ab3a2:	73 e8                	jae    5ab38c <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x135c>
  5ab3a4:	49 89 d0             	mov    %rdx,%r8
  5ab3a7:	46 89 0c 07          	mov    %r9d,(%rdi,%r8,1)
  5ab3ab:	49 83 f8 04          	cmp    $0x4,%r8
  5ab3af:	74 d5                	je     5ab386 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1356>
  5ab3b1:	46 8b 4c 07 f8       	mov    -0x8(%rdi,%r8,1),%r9d
  5ab3b6:	49 83 c0 fc          	add    $0xfffffffffffffffc,%r8
  5ab3ba:	44 39 ce             	cmp    %r9d,%esi
  5ab3bd:	72 e8                	jb     5ab3a7 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1377>
  5ab3bf:	49 01 f8             	add    %rdi,%r8
  5ab3c2:	eb c5                	jmp    5ab389 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1359>
  5ab3c4:	48 89 da             	mov    %rbx,%rdx
  5ab3c7:	e8 54 5f 14 00       	call   6f1320 <_RINvNtNtNtCs4NRVxsYgnAr_4core5slice4sort8unstable7ipnsortNtNtNtCs6gaF1xUz9Bf_4gpui7runtime8metadata11DestinationNCINvMB6_SBT_20sort_unstable_by_keymNCNvMsq_BX_INtBX_7RuntimeNtNtBX_12style_ledger9AdversaryE14describe_inners8_0E0EBZ_>
  5ab3cc:	eb 85                	jmp    5ab353 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1323>
  5ab3ce:	48 8b 5c 24 10       	mov    0x10(%rsp),%rbx
  5ab3d3:	48 8b 83 48 02 00 00 	mov    0x248(%rbx),%rax
  5ab3da:	48 89 84 24 60 05 00 	mov    %rax,0x560(%rsp)
  5ab3e1:	00 
  5ab3e2:	0f 10 83 28 02 00 00 	movups 0x228(%rbx),%xmm0
  5ab3e9:	0f 10 8b 38 02 00 00 	movups 0x238(%rbx),%xmm1
  5ab3f0:	0f 29 8c 24 50 05 00 	movaps %xmm1,0x550(%rsp)
  5ab3f7:	00 
  5ab3f8:	0f 29 84 24 40 05 00 	movaps %xmm0,0x540(%rsp)
  5ab3ff:	00 
  5ab400:	48 c7 83 28 02 00 00 	movq   $0x0,0x228(%rbx)
  5ab407:	00 00 00 00 
  5ab40b:	48 8b 83 b8 02 00 00 	mov    0x2b8(%rbx),%rax
  5ab412:	48 8b 8b c0 02 00 00 	mov    0x2c0(%rbx),%rcx
  5ab419:	48 8b 93 c8 02 00 00 	mov    0x2c8(%rbx),%rdx
  5ab420:	48 c7 83 b8 02 00 00 	movq   $0x0,0x2b8(%rbx)
  5ab427:	00 00 00 00 
  5ab42b:	48 c7 83 c0 02 00 00 	movq   $0x8,0x2c0(%rbx)
  5ab432:	08 00 00 00 
  5ab436:	48 c7 83 c8 02 00 00 	movq   $0x0,0x2c8(%rbx)
  5ab43d:	00 00 00 00 
  5ab441:	48 8d 14 92          	lea    (%rdx,%rdx,4),%rdx
  5ab445:	48 8d 14 d1          	lea    (%rcx,%rdx,8),%rdx
  5ab449:	48 89 8c 24 a0 00 00 	mov    %rcx,0xa0(%rsp)
  5ab450:	00 
  5ab451:	48 89 8c 24 a8 00 00 	mov    %rcx,0xa8(%rsp)
  5ab458:	00 
  5ab459:	48 89 84 24 b0 00 00 	mov    %rax,0xb0(%rsp)
  5ab460:	00 
  5ab461:	48 89 94 24 b8 00 00 	mov    %rdx,0xb8(%rsp)
  5ab468:	00 
  5ab469:	48 8d bc 24 88 04 00 	lea    0x488(%rsp),%rdi
  5ab470:	00 
  5ab471:	48 8d b4 24 a0 00 00 	lea    0xa0(%rsp),%rsi
  5ab478:	00 
  5ab479:	e8 32 16 22 00       	call   7ccab0 <_RINvNtNtCscdodAO9FK5_5alloc3vec16in_place_collect18from_iter_in_placeINtNtNtNtCs4NRVxsYgnAr_4core4iter8adapters3map3MapINtNtB4_9into_iter8IntoIterNtNtCs6gaF1xUz9Bf_4gpui7runtime4NodeENcNtINtNtB1e_6option6OptionB2k_E4Some0EB2Z_EB2o_>
  5ab47e:	48 c7 84 24 a8 05 00 	movq   $0x0,0x5a8(%rsp)
  5ab485:	00 00 00 00 00 
  5ab48a:	48 c7 84 24 b8 05 00 	movq   $0x0,0x5b8(%rsp)
  5ab491:	00 00 00 00 00 
  5ab496:	48 c7 84 24 c0 05 00 	movq   $0x0,0x5c0(%rsp)
  5ab49d:	00 00 00 00 00 
  5ab4a2:	48 c7 84 24 d0 05 00 	movq   $0x0,0x5d0(%rsp)
  5ab4a9:	00 00 00 00 00 
  5ab4ae:	48 c7 84 24 d8 05 00 	movq   $0x0,0x5d8(%rsp)
  5ab4b5:	00 00 00 00 00 
  5ab4ba:	48 c7 84 24 e8 05 00 	movq   $0x0,0x5e8(%rsp)
  5ab4c1:	00 00 00 00 00 
  5ab4c6:	48 8b 83 18 08 00 00 	mov    0x818(%rbx),%rax
  5ab4cd:	48 8b 8b 20 08 00 00 	mov    0x820(%rbx),%rcx
  5ab4d4:	31 d2                	xor    %edx,%edx
  5ab4d6:	48 89 c6             	mov    %rax,%rsi
  5ab4d9:	48 85 c0             	test   %rax,%rax
  5ab4dc:	40 0f 95 c7          	setne  %dil
  5ab4e0:	74 07                	je     5ab4e9 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x14b9>
  5ab4e2:	48 8b b3 28 08 00 00 	mov    0x828(%rbx),%rsi
  5ab4e9:	40 88 fa             	mov    %dil,%dl
  5ab4ec:	48 89 94 24 a0 00 00 	mov    %rdx,0xa0(%rsp)
  5ab4f3:	00 
  5ab4f4:	48 c7 84 24 a8 00 00 	movq   $0x0,0xa8(%rsp)
  5ab4fb:	00 00 00 00 00 
  5ab500:	48 89 84 24 b0 00 00 	mov    %rax,0xb0(%rsp)
  5ab507:	00 
  5ab508:	48 89 8c 24 b8 00 00 	mov    %rcx,0xb8(%rsp)
  5ab50f:	00 
  5ab510:	48 89 94 24 c0 00 00 	mov    %rdx,0xc0(%rsp)
  5ab517:	00 
  5ab518:	48 c7 84 24 c8 00 00 	movq   $0x0,0xc8(%rsp)
  5ab51f:	00 00 00 00 00 
  5ab524:	48 89 84 24 d0 00 00 	mov    %rax,0xd0(%rsp)
  5ab52b:	00 
  5ab52c:	48 89 8c 24 d8 00 00 	mov    %rcx,0xd8(%rsp)
  5ab533:	00 
  5ab534:	48 89 b4 24 e0 00 00 	mov    %rsi,0xe0(%rsp)
  5ab53b:	00 
  5ab53c:	40 b5 01             	mov    $0x1,%bpl
  5ab53f:	48 8d bc 24 f0 06 00 	lea    0x6f0(%rsp),%rdi
  5ab546:	00 
  5ab547:	48 8d b4 24 a0 00 00 	lea    0xa0(%rsp),%rsi
  5ab54e:	00 
  5ab54f:	41 b5 01             	mov    $0x1,%r13b
  5ab552:	e8 f9 54 17 00       	call   720a50 <_RINvXs1o_NtNtNtCscdodAO9FK5_5alloc11collections5btree3mapINtB7_8BTreeMapyNtNtCs6gaF1xUz9Bf_4gpui4list6ListIdEINtNtNtNtCs4NRVxsYgnAr_4core4iter6traits7collect12FromIteratorTyB19_EE9from_iterINtNtNtB1Q_8adapters3map3MapINtB7_4IterB19_NtNtNtB1d_7runtime4list9ListStateENCNvMsq_B3M_INtB3M_7RuntimeNtNtB3M_12style_ledger9AdversaryE14describe_inners9_0EEB1d_>
  5ab557:	48 c7 84 24 10 05 00 	movq   $0x0,0x510(%rsp)
  5ab55e:	00 00 00 00 00 
  5ab563:	48 c7 84 24 20 05 00 	movq   $0x0,0x520(%rsp)
  5ab56a:	00 00 00 00 00 
  5ab56f:	4c 8b ac 24 98 04 00 	mov    0x498(%rsp),%r13
  5ab576:	00 
  5ab577:	4d 85 ed             	test   %r13,%r13
  5ab57a:	4c 89 ac 24 30 04 00 	mov    %r13,0x430(%rsp)
  5ab581:	00 
  5ab582:	0f 84 8e 07 00 00    	je     5abd16 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1ce6>
  5ab588:	4c 8b b4 24 90 04 00 	mov    0x490(%rsp),%r14
  5ab58f:	00 
  5ab590:	4a 8d 04 ad 00 00 00 	lea    0x0(,%r13,4),%rax
  5ab597:	00 
  5ab598:	4c 01 e8             	add    %r13,%rax
  5ab59b:	49 8d 04 c6          	lea    (%r14,%rax,8),%rax
  5ab59f:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  5ab5a4:	31 db                	xor    %ebx,%ebx
  5ab5a6:	41 bb 01 00 00 00    	mov    $0x1,%r11d
  5ab5ac:	4d 89 f5             	mov    %r14,%r13
  5ab5af:	4c 89 74 24 20       	mov    %r14,0x20(%rsp)
  5ab5b4:	eb 2d                	jmp    5ab5e3 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x15b3>
  5ab5b6:	48 8b 8c 24 b8 00 00 	mov    0xb8(%rsp),%rcx
  5ab5bd:	00 
  5ab5be:	48 89 9c c8 68 01 00 	mov    %rbx,0x168(%rax,%rcx,8)
  5ab5c5:	00 
  5ab5c6:	41 bb 01 00 00 00    	mov    $0x1,%r11d
  5ab5cc:	49 83 c5 28          	add    $0x28,%r13
  5ab5d0:	48 ff c3             	inc    %rbx
  5ab5d3:	4c 3b 6c 24 08       	cmp    0x8(%rsp),%r13
  5ab5d8:	4c 8b 74 24 20       	mov    0x20(%rsp),%r14
  5ab5dd:	0f 84 c4 06 00 00    	je     5abca7 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1c77>
  5ab5e3:	49 83 7d 00 00       	cmpq   $0x0,0x0(%r13)
  5ab5e8:	0f 84 d1 40 00 00    	je     5af6bf <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x568f>
  5ab5ee:	41 8b 7d 18          	mov    0x18(%r13),%edi
  5ab5f2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  5ab5f7:	48 39 c7             	cmp    %rax,%rdi
  5ab5fa:	0f 84 f0 00 00 00    	je     5ab6f0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x16c0>
  5ab600:	48 39 bc 24 30 04 00 	cmp    %rdi,0x430(%rsp)
  5ab607:	00 
  5ab608:	0f 86 e4 42 00 00    	jbe    5af8f2 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x58c2>
  5ab60e:	48 8d 04 bf          	lea    (%rdi,%rdi,4),%rax
  5ab612:	4d 8b 3c c6          	mov    (%r14,%rax,8),%r15
  5ab616:	41 be 01 00 00 00    	mov    $0x1,%r14d
  5ab61c:	4d 85 ff             	test   %r15,%r15
  5ab61f:	0f 84 be 40 00 00    	je     5af6e3 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x56b3>
  5ab625:	48 8b 84 24 10 05 00 	mov    0x510(%rsp),%rax
  5ab62c:	00 
  5ab62d:	48 85 c0             	test   %rax,%rax
  5ab630:	0f 84 ce 00 00 00    	je     5ab704 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x16d4>
  5ab636:	48 8b 8c 24 18 05 00 	mov    0x518(%rsp),%rcx
  5ab63d:	00 
  5ab63e:	4d 85 f6             	test   %r14,%r14
  5ab641:	0f 84 79 00 00 00    	je     5ab6c0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1690>
  5ab647:	0f b7 b0 12 01 00 00 	movzwl 0x112(%rax),%esi
  5ab64e:	89 f7                	mov    %esi,%edi
  5ab650:	c1 e7 04             	shl    $0x4,%edi
  5ab653:	48 c7 c2 ff ff ff ff 	mov    $0xffffffffffffffff,%rdx
  5ab65a:	49 89 c0             	mov    %rax,%r8
  5ab65d:	0f 1f 00             	nopl   (%rax)
  5ab660:	48 85 ff             	test   %rdi,%rdi
  5ab663:	74 3b                	je     5ab6a0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1670>
  5ab665:	4d 3b 78 08          	cmp    0x8(%r8),%r15
  5ab669:	41 0f 97 c1          	seta   %r9b
  5ab66d:	41 80 d9 00          	sbb    $0x0,%r9b
  5ab671:	41 f6 00 01          	testb  $0x1,(%r8)
  5ab675:	4d 8d 40 10          	lea    0x10(%r8),%r8
  5ab679:	45 0f b6 c9          	movzbl %r9b,%r9d
  5ab67d:	45 0f 44 cb          	cmove  %r11d,%r9d
  5ab681:	48 ff c2             	inc    %rdx
  5ab684:	48 83 c7 f0          	add    $0xfffffffffffffff0,%rdi
  5ab688:	41 80 f9 01          	cmp    $0x1,%r9b
  5ab68c:	74 d2                	je     5ab660 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1630>
  5ab68e:	41 0f b6 f1          	movzbl %r9b,%esi
  5ab692:	85 f6                	test   %esi,%esi
  5ab694:	0f 84 da 00 00 00    	je     5ab774 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1744>
  5ab69a:	eb 07                	jmp    5ab6a3 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1673>
  5ab69c:	0f 1f 40 00          	nopl   0x0(%rax)
  5ab6a0:	48 89 f2             	mov    %rsi,%rdx
  5ab6a3:	48 83 e9 01          	sub    $0x1,%rcx
  5ab6a7:	0f 82 87 00 00 00    	jb     5ab734 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1704>
  5ab6ad:	48 8b 84 d0 18 01 00 	mov    0x118(%rax,%rdx,8),%rax
  5ab6b4:	00 
  5ab6b5:	eb 90                	jmp    5ab647 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1617>
  5ab6b7:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
  5ab6be:	00 00 
  5ab6c0:	66 83 b8 12 01 00 00 	cmpw   $0x0,0x112(%rax)
  5ab6c7:	00 
  5ab6c8:	74 09                	je     5ab6d3 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x16a3>
  5ab6ca:	f6 00 01             	testb  $0x1,(%rax)
  5ab6cd:	0f 84 9f 00 00 00    	je     5ab772 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1742>
  5ab6d3:	48 83 e9 01          	sub    $0x1,%rcx
  5ab6d7:	72 59                	jb     5ab732 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1702>
  5ab6d9:	48 8b 80 18 01 00 00 	mov    0x118(%rax),%rax
  5ab6e0:	eb de                	jmp    5ab6c0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1690>
  5ab6e2:	66 66 66 66 66 2e 0f 	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  5ab6e9:	1f 84 00 00 00 00 00 
  5ab6f0:	45 31 f6             	xor    %r14d,%r14d
  5ab6f3:	48 8b 84 24 10 05 00 	mov    0x510(%rsp),%rax
  5ab6fa:	00 
  5ab6fb:	48 85 c0             	test   %rax,%rax
  5ab6fe:	0f 85 32 ff ff ff    	jne    5ab636 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1606>
  5ab704:	4c 89 b4 24 a0 00 00 	mov    %r14,0xa0(%rsp)
  5ab70b:	00 
  5ab70c:	4c 89 bc 24 a8 00 00 	mov    %r15,0xa8(%rsp)
  5ab713:	00 
  5ab714:	48 8d 84 24 10 05 00 	lea    0x510(%rsp),%rax
  5ab71b:	00 
  5ab71c:	48 89 84 24 b0 00 00 	mov    %rax,0xb0(%rsp)
  5ab723:	00 
  5ab724:	48 c7 84 24 b8 00 00 	movq   $0x0,0xb8(%rsp)
  5ab72b:	00 00 00 00 00 
  5ab730:	eb 76                	jmp    5ab7a8 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1778>
  5ab732:	31 d2                	xor    %edx,%edx
  5ab734:	48 89 84 24 b8 00 00 	mov    %rax,0xb8(%rsp)
  5ab73b:	00 
  5ab73c:	48 c7 84 24 c0 00 00 	movq   $0x0,0xc0(%rsp)
  5ab743:	00 00 00 00 00 
  5ab748:	48 89 94 24 c8 00 00 	mov    %rdx,0xc8(%rsp)
  5ab74f:	00 
  5ab750:	4c 89 b4 24 a0 00 00 	mov    %r14,0xa0(%rsp)
  5ab757:	00 
  5ab758:	4c 89 bc 24 a8 00 00 	mov    %r15,0xa8(%rsp)
  5ab75f:	00 
  5ab760:	48 8d 84 24 10 05 00 	lea    0x510(%rsp),%rax
  5ab767:	00 
  5ab768:	48 89 84 24 b0 00 00 	mov    %rax,0xb0(%rsp)
  5ab76f:	00 
  5ab770:	eb 36                	jmp    5ab7a8 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1778>
  5ab772:	31 d2                	xor    %edx,%edx
  5ab774:	48 89 84 24 a8 00 00 	mov    %rax,0xa8(%rsp)
  5ab77b:	00 
  5ab77c:	48 89 8c 24 b0 00 00 	mov    %rcx,0xb0(%rsp)
  5ab783:	00 
  5ab784:	48 89 94 24 b8 00 00 	mov    %rdx,0xb8(%rsp)
  5ab78b:	00 
  5ab78c:	48 8d 84 24 10 05 00 	lea    0x510(%rsp),%rax
  5ab793:	00 
  5ab794:	48 89 84 24 c0 00 00 	mov    %rax,0xc0(%rsp)
  5ab79b:	00 
  5ab79c:	48 c7 84 24 a0 00 00 	movq   $0x2,0xa0(%rsp)
  5ab7a3:	00 02 00 00 00 
  5ab7a8:	48 8d bc 24 a0 00 00 	lea    0xa0(%rsp),%rdi
  5ab7af:	00 
  5ab7b0:	e8 8b cc 1c 00       	call   778440 <_RNvMs3_NtNtNtNtCscdodAO9FK5_5alloc11collections5btree3map5entryINtB5_5EntryINtNtCs4NRVxsYgnAr_4core6option6OptionyEjE10or_defaultCs6gaF1xUz9Bf_4gpui>
  5ab7b5:	48 ff 00             	incq   (%rax)
  5ab7b8:	41 8b 45 1c          	mov    0x1c(%r13),%eax
  5ab7bc:	41 8b 4d 20          	mov    0x20(%r13),%ecx
  5ab7c0:	83 e1 07             	and    $0x7,%ecx
  5ab7c3:	48 8d 15 82 30 ac ff 	lea    -0x53cf7e(%rip),%rdx        # 6e84c <anon.5f884de6e78125e25881320d811d32df.354.llvm.17146438997930651657+0x78c>
  5ab7ca:	48 63 0c 8a          	movslq (%rdx,%rcx,4),%rcx
  5ab7ce:	48 01 d1             	add    %rdx,%rcx
  5ab7d1:	ff e1                	jmp    *%rcx
  5ab7d3:	31 c9                	xor    %ecx,%ecx
  5ab7d5:	eb 19                	jmp    5ab7f0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x17c0>
  5ab7d7:	b1 05                	mov    $0x5,%cl
  5ab7d9:	eb 15                	jmp    5ab7f0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x17c0>
  5ab7db:	b1 06                	mov    $0x6,%cl
  5ab7dd:	eb 11                	jmp    5ab7f0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x17c0>
  5ab7df:	b1 02                	mov    $0x2,%cl
  5ab7e1:	eb 0d                	jmp    5ab7f0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x17c0>
  5ab7e3:	b1 01                	mov    $0x1,%cl
  5ab7e5:	eb 09                	jmp    5ab7f0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x17c0>
  5ab7e7:	b1 04                	mov    $0x4,%cl
  5ab7e9:	eb 05                	jmp    5ab7f0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x17c0>
  5ab7eb:	b1 03                	mov    $0x3,%cl
  5ab7ed:	0f 1f 00             	nopl   (%rax)
  5ab7f0:	4c 89 b4 24 90 01 00 	mov    %r14,0x190(%rsp)
  5ab7f7:	00 
  5ab7f8:	4c 89 bc 24 98 01 00 	mov    %r15,0x198(%rsp)
  5ab7ff:	00 
  5ab800:	89 84 24 a0 01 00 00 	mov    %eax,0x1a0(%rsp)
  5ab807:	88 8c 24 a4 01 00 00 	mov    %cl,0x1a4(%rsp)
  5ab80e:	48 8b b4 24 a8 05 00 	mov    0x5a8(%rsp),%rsi
  5ab815:	00 
  5ab816:	48 85 f6             	test   %rsi,%rsi
  5ab819:	74 65                	je     5ab880 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1850>
  5ab81b:	48 8b 94 24 b0 05 00 	mov    0x5b0(%rsp),%rdx
  5ab822:	00 
  5ab823:	48 8d bc 24 a0 00 00 	lea    0xa0(%rsp),%rdi
  5ab82a:	00 
  5ab82b:	48 8d 8c 24 90 01 00 	lea    0x190(%rsp),%rcx
  5ab832:	00 
  5ab833:	e8 f8 bd 0c 00       	call   677630 <_RINvMs_NtNtNtCscdodAO9FK5_5alloc11collections5btree6searchINtNtB7_4node7NodeRefNtNtBX_6marker3MutTINtNtCs4NRVxsYgnAr_4core6option6OptionyEmNtNtCs6gaF1xUz9Bf_4gpui7element8NodeKindEjNtB1h_14LeafOrInternalE11search_treeB1x_EB2h_>
  5ab838:	48 8b 84 24 a8 00 00 	mov    0xa8(%rsp),%rax
  5ab83f:	00 
  5ab840:	80 bc 24 a0 00 00 00 	cmpb   $0x0,0xa0(%rsp)
  5ab847:	00 
  5ab848:	0f 84 a2 00 00 00    	je     5ab8f0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x18c0>
  5ab84e:	48 8d b4 24 b0 00 00 	lea    0xb0(%rsp),%rsi
  5ab855:	00 
  5ab856:	0f 10 06             	movups (%rsi),%xmm0
  5ab859:	0f 29 84 24 b0 03 00 	movaps %xmm0,0x3b0(%rsp)
  5ab860:	00 
  5ab861:	48 8b 94 24 98 01 00 	mov    0x198(%rsp),%rdx
  5ab868:	00 
  5ab869:	48 8b 8c 24 a0 01 00 	mov    0x1a0(%rsp),%rcx
  5ab870:	00 
  5ab871:	eb 22                	jmp    5ab895 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1865>
  5ab873:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  5ab87a:	84 00 00 00 00 00 
  5ab880:	48 8b 8c 24 a0 01 00 	mov    0x1a0(%rsp),%rcx
  5ab887:	00 
  5ab888:	4c 89 fa             	mov    %r15,%rdx
  5ab88b:	31 c0                	xor    %eax,%eax
  5ab88d:	48 8d b4 24 b0 00 00 	lea    0xb0(%rsp),%rsi
  5ab894:	00 
  5ab895:	4c 89 b4 24 a0 00 00 	mov    %r14,0xa0(%rsp)
  5ab89c:	00 
  5ab89d:	48 89 94 24 a8 00 00 	mov    %rdx,0xa8(%rsp)
  5ab8a4:	00 
  5ab8a5:	48 89 8c 24 b0 00 00 	mov    %rcx,0xb0(%rsp)
  5ab8ac:	00 
  5ab8ad:	48 8d 8c 24 a8 05 00 	lea    0x5a8(%rsp),%rcx
  5ab8b4:	00 
  5ab8b5:	48 89 8c 24 b8 00 00 	mov    %rcx,0xb8(%rsp)
  5ab8bc:	00 
  5ab8bd:	48 89 84 24 c0 00 00 	mov    %rax,0xc0(%rsp)
  5ab8c4:	00 
  5ab8c5:	0f 28 84 24 b0 03 00 	movaps 0x3b0(%rsp),%xmm0
  5ab8cc:	00 
  5ab8cd:	0f 11 46 18          	movups %xmm0,0x18(%rsi)
  5ab8d1:	48 8d bc 24 00 03 00 	lea    0x300(%rsp),%rdi
  5ab8d8:	00 
  5ab8d9:	48 8d b4 24 a0 00 00 	lea    0xa0(%rsp),%rsi
  5ab8e0:	00 
  5ab8e1:	48 89 da             	mov    %rbx,%rdx
  5ab8e4:	e8 67 d3 1c 00       	call   778c50 <_RNvMs4_NtNtNtNtCscdodAO9FK5_5alloc11collections5btree3map5entryINtB5_11VacantEntryTINtNtCs4NRVxsYgnAr_4core6option6OptionyEmNtNtCs6gaF1xUz9Bf_4gpui7element8NodeKindEjE12insert_entryB22_>
  5ab8e9:	eb 15                	jmp    5ab900 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x18d0>
  5ab8eb:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
  5ab8f0:	48 8b 8c 24 b8 00 00 	mov    0xb8(%rsp),%rcx
  5ab8f7:	00 
  5ab8f8:	48 89 9c c8 10 01 00 	mov    %rbx,0x110(%rax,%rcx,8)
  5ab8ff:	00 
  5ab900:	49 8b 45 00          	mov    0x0(%r13),%rax
  5ab904:	48 8b 54 24 10       	mov    0x10(%rsp),%rdx
  5ab909:	48 8b 8a 30 08 00 00 	mov    0x830(%rdx),%rcx
  5ab910:	48 85 c9             	test   %rcx,%rcx
  5ab913:	41 bb 01 00 00 00    	mov    $0x1,%r11d
  5ab919:	0f 84 d2 01 00 00    	je     5abaf1 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1ac1>
  5ab91f:	48 8b 92 38 08 00 00 	mov    0x838(%rdx),%rdx
  5ab926:	44 0f b7 81 c2 01 00 	movzwl 0x1c2(%rcx),%r8d
  5ab92d:	00 
  5ab92e:	45 89 c1             	mov    %r8d,%r9d
  5ab931:	41 c1 e1 05          	shl    $0x5,%r9d
  5ab935:	48 c7 c6 ff ff ff ff 	mov    $0xffffffffffffffff,%rsi
  5ab93c:	31 ff                	xor    %edi,%edi
  5ab93e:	66 90                	xchg   %ax,%ax
  5ab940:	49 39 f9             	cmp    %rdi,%r9
  5ab943:	74 2b                	je     5ab970 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1940>
  5ab945:	48 3b 84 f1 70 01 00 	cmp    0x170(%rcx,%rsi,8),%rax
  5ab94c:	00 
  5ab94d:	41 0f 97 c2          	seta   %r10b
  5ab951:	41 80 da 00          	sbb    $0x0,%r10b
  5ab955:	48 83 c7 20          	add    $0x20,%rdi
  5ab959:	48 ff c6             	inc    %rsi
  5ab95c:	41 80 fa 01          	cmp    $0x1,%r10b
  5ab960:	74 de                	je     5ab940 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1910>
  5ab962:	45 0f b6 c2          	movzbl %r10b,%r8d
  5ab966:	45 85 c0             	test   %r8d,%r8d
  5ab969:	75 08                	jne    5ab973 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1943>
  5ab96b:	eb 23                	jmp    5ab990 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1960>
  5ab96d:	0f 1f 00             	nopl   (%rax)
  5ab970:	4c 89 c6             	mov    %r8,%rsi
  5ab973:	48 83 ea 01          	sub    $0x1,%rdx
  5ab977:	0f 82 74 01 00 00    	jb     5abaf1 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1ac1>
  5ab97d:	48 8b 8c f1 c8 01 00 	mov    0x1c8(%rcx,%rsi,8),%rcx
  5ab984:	00 
  5ab985:	eb 9f                	jmp    5ab926 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x18f6>
  5ab987:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
  5ab98e:	00 00 
  5ab990:	80 7c 39 fc 01       	cmpb   $0x1,-0x4(%rcx,%rdi,1)
  5ab995:	0f 85 56 01 00 00    	jne    5abaf1 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1ac1>
  5ab99b:	48 8b 6c 39 e8       	mov    -0x18(%rcx,%rdi,1),%rbp
  5ab9a0:	41 8b 45 20          	mov    0x20(%r13),%eax
  5ab9a4:	83 e0 07             	and    $0x7,%eax
  5ab9a7:	48 8d 0d be 2e ac ff 	lea    -0x53d142(%rip),%rcx        # 6e86c <anon.5f884de6e78125e25881320d811d32df.354.llvm.17146438997930651657+0x7ac>
  5ab9ae:	48 63 04 81          	movslq (%rcx,%rax,4),%rax
  5ab9b2:	48 01 c8             	add    %rcx,%rax
  5ab9b5:	ff e0                	jmp    *%rax
  5ab9b7:	31 c0                	xor    %eax,%eax
  5ab9b9:	eb 25                	jmp    5ab9e0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x19b0>
  5ab9bb:	b0 05                	mov    $0x5,%al
  5ab9bd:	eb 21                	jmp    5ab9e0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x19b0>
  5ab9bf:	b0 06                	mov    $0x6,%al
  5ab9c1:	eb 1d                	jmp    5ab9e0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x19b0>
  5ab9c3:	b0 02                	mov    $0x2,%al
  5ab9c5:	eb 19                	jmp    5ab9e0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x19b0>
  5ab9c7:	b0 01                	mov    $0x1,%al
  5ab9c9:	eb 15                	jmp    5ab9e0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x19b0>
  5ab9cb:	b0 04                	mov    $0x4,%al
  5ab9cd:	eb 11                	jmp    5ab9e0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x19b0>
  5ab9cf:	b0 03                	mov    $0x3,%al
  5ab9d1:	66 66 66 66 66 66 2e 	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  5ab9d8:	0f 1f 84 00 00 00 00 
  5ab9df:	00 
  5ab9e0:	4c 89 b4 24 90 01 00 	mov    %r14,0x190(%rsp)
  5ab9e7:	00 
  5ab9e8:	4c 89 bc 24 98 01 00 	mov    %r15,0x198(%rsp)
  5ab9ef:	00 
  5ab9f0:	48 89 ac 24 a0 01 00 	mov    %rbp,0x1a0(%rsp)
  5ab9f7:	00 
  5ab9f8:	88 84 24 a8 01 00 00 	mov    %al,0x1a8(%rsp)
  5ab9ff:	48 8b b4 24 c0 05 00 	mov    0x5c0(%rsp),%rsi
  5aba06:	00 
  5aba07:	48 85 f6             	test   %rsi,%rsi
  5aba0a:	74 58                	je     5aba64 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1a34>
  5aba0c:	48 8b 94 24 c8 05 00 	mov    0x5c8(%rsp),%rdx
  5aba13:	00 
  5aba14:	48 8d bc 24 a0 00 00 	lea    0xa0(%rsp),%rdi
  5aba1b:	00 
  5aba1c:	48 8d 8c 24 90 01 00 	lea    0x190(%rsp),%rcx
  5aba23:	00 
  5aba24:	e8 57 ba 0c 00       	call   677480 <_RINvMs_NtNtNtCscdodAO9FK5_5alloc11collections5btree6searchINtNtB7_4node7NodeRefNtNtBX_6marker3MutTINtNtCs4NRVxsYgnAr_4core6option6OptionyENtNtCs6gaF1xUz9Bf_4gpui4list6ListIdNtNtB2g_7element8NodeKindEjNtB1h_14LeafOrInternalE11search_treeB1x_EB2g_>
  5aba29:	48 8b 84 24 a8 00 00 	mov    0xa8(%rsp),%rax
  5aba30:	00 
  5aba31:	80 bc 24 a0 00 00 00 	cmpb   $0x0,0xa0(%rsp)
  5aba38:	00 
  5aba39:	0f 84 98 00 00 00    	je     5abad7 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1aa7>
  5aba3f:	48 8d b4 24 b0 00 00 	lea    0xb0(%rsp),%rsi
  5aba46:	00 
  5aba47:	0f 10 06             	movups (%rsi),%xmm0
  5aba4a:	0f 29 84 24 b0 03 00 	movaps %xmm0,0x3b0(%rsp)
  5aba51:	00 
  5aba52:	48 8b 94 24 98 01 00 	mov    0x198(%rsp),%rdx
  5aba59:	00 
  5aba5a:	48 8b 8c 24 a8 01 00 	mov    0x1a8(%rsp),%rcx
  5aba61:	00 
  5aba62:	eb 15                	jmp    5aba79 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1a49>
  5aba64:	48 8b 8c 24 a8 01 00 	mov    0x1a8(%rsp),%rcx
  5aba6b:	00 
  5aba6c:	4c 89 fa             	mov    %r15,%rdx
  5aba6f:	31 c0                	xor    %eax,%eax
  5aba71:	48 8d b4 24 b0 00 00 	lea    0xb0(%rsp),%rsi
  5aba78:	00 
  5aba79:	4c 89 b4 24 a0 00 00 	mov    %r14,0xa0(%rsp)
  5aba80:	00 
  5aba81:	48 89 94 24 a8 00 00 	mov    %rdx,0xa8(%rsp)
  5aba88:	00 
  5aba89:	48 89 ac 24 b0 00 00 	mov    %rbp,0xb0(%rsp)
  5aba90:	00 
  5aba91:	48 89 8c 24 b8 00 00 	mov    %rcx,0xb8(%rsp)
  5aba98:	00 
  5aba99:	48 8d 8c 24 c0 05 00 	lea    0x5c0(%rsp),%rcx
  5abaa0:	00 
  5abaa1:	48 89 8c 24 c0 00 00 	mov    %rcx,0xc0(%rsp)
  5abaa8:	00 
  5abaa9:	48 89 84 24 c8 00 00 	mov    %rax,0xc8(%rsp)
  5abab0:	00 
  5abab1:	0f 28 84 24 b0 03 00 	movaps 0x3b0(%rsp),%xmm0
  5abab8:	00 
  5abab9:	0f 11 46 20          	movups %xmm0,0x20(%rsi)
  5ababd:	48 8d bc 24 00 03 00 	lea    0x300(%rsp),%rdi
  5abac4:	00 
  5abac5:	48 8d b4 24 a0 00 00 	lea    0xa0(%rsp),%rsi
  5abacc:	00 
  5abacd:	48 89 da             	mov    %rbx,%rdx
  5abad0:	e8 7b d0 1c 00       	call   778b50 <_RNvMs4_NtNtNtNtCscdodAO9FK5_5alloc11collections5btree3map5entryINtB5_11VacantEntryTINtNtCs4NRVxsYgnAr_4core6option6OptionyENtNtCs6gaF1xUz9Bf_4gpui4list7ItemKeyNtNtB21_7element8NodeKindEjE12insert_entryB21_>
  5abad5:	eb 10                	jmp    5abae7 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1ab7>
  5abad7:	48 8b 8c 24 b8 00 00 	mov    0xb8(%rsp),%rcx
  5abade:	00 
  5abadf:	48 89 9c c8 68 01 00 	mov    %rbx,0x168(%rax,%rcx,8)
  5abae6:	00 
  5abae7:	49 8b 45 00          	mov    0x0(%r13),%rax
  5abaeb:	41 bb 01 00 00 00    	mov    $0x1,%r11d
  5abaf1:	48 8b 8c 24 f0 06 00 	mov    0x6f0(%rsp),%rcx
  5abaf8:	00 
  5abaf9:	48 85 c9             	test   %rcx,%rcx
  5abafc:	0f 84 ca fa ff ff    	je     5ab5cc <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x159c>
  5abb02:	48 8b 94 24 f8 06 00 	mov    0x6f8(%rsp),%rdx
  5abb09:	00 
  5abb0a:	0f b7 b9 ba 00 00 00 	movzwl 0xba(%rcx),%edi
  5abb11:	41 89 f8             	mov    %edi,%r8d
  5abb14:	41 c1 e0 03          	shl    $0x3,%r8d
  5abb18:	48 c7 c6 ff ff ff ff 	mov    $0xffffffffffffffff,%rsi
  5abb1f:	90                   	nop
  5abb20:	4d 85 c0             	test   %r8,%r8
  5abb23:	74 2b                	je     5abb50 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1b20>
  5abb25:	48 3b 44 f1 10       	cmp    0x10(%rcx,%rsi,8),%rax
  5abb2a:	41 0f 97 c1          	seta   %r9b
  5abb2e:	41 80 d9 00          	sbb    $0x0,%r9b
  5abb32:	48 ff c6             	inc    %rsi
  5abb35:	49 83 c0 f8          	add    $0xfffffffffffffff8,%r8
  5abb39:	41 80 f9 01          	cmp    $0x1,%r9b
  5abb3d:	74 e1                	je     5abb20 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1af0>
  5abb3f:	41 0f b6 f9          	movzbl %r9b,%edi
  5abb43:	85 ff                	test   %edi,%edi
  5abb45:	75 0c                	jne    5abb53 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1b23>
  5abb47:	eb 27                	jmp    5abb70 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1b40>
  5abb49:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  5abb50:	48 89 fe             	mov    %rdi,%rsi
  5abb53:	48 83 ea 01          	sub    $0x1,%rdx
  5abb57:	0f 82 6f fa ff ff    	jb     5ab5cc <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x159c>
  5abb5d:	48 8b 8c f1 c0 00 00 	mov    0xc0(%rcx,%rsi,8),%rcx
  5abb64:	00 
  5abb65:	eb a3                	jmp    5abb0a <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1ada>
  5abb67:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
  5abb6e:	00 00 
  5abb70:	48 8b 6c f1 60       	mov    0x60(%rcx,%rsi,8),%rbp
  5abb75:	41 8b 45 20          	mov    0x20(%r13),%eax
  5abb79:	83 e0 07             	and    $0x7,%eax
  5abb7c:	48 8d 0d 09 2d ac ff 	lea    -0x53d2f7(%rip),%rcx        # 6e88c <anon.5f884de6e78125e25881320d811d32df.354.llvm.17146438997930651657+0x7cc>
  5abb83:	48 63 04 81          	movslq (%rcx,%rax,4),%rax
  5abb87:	48 01 c8             	add    %rcx,%rax
  5abb8a:	ff e0                	jmp    *%rax
  5abb8c:	31 c0                	xor    %eax,%eax
  5abb8e:	eb 20                	jmp    5abbb0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1b80>
  5abb90:	b0 04                	mov    $0x4,%al
  5abb92:	eb 1c                	jmp    5abbb0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1b80>
  5abb94:	b0 02                	mov    $0x2,%al
  5abb96:	eb 18                	jmp    5abbb0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1b80>
  5abb98:	b0 03                	mov    $0x3,%al
  5abb9a:	eb 14                	jmp    5abbb0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1b80>
  5abb9c:	b0 01                	mov    $0x1,%al
  5abb9e:	eb 10                	jmp    5abbb0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1b80>
  5abba0:	b0 05                	mov    $0x5,%al
  5abba2:	eb 0c                	jmp    5abbb0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1b80>
  5abba4:	b0 06                	mov    $0x6,%al
  5abba6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  5abbad:	00 00 00 
  5abbb0:	4c 89 b4 24 90 01 00 	mov    %r14,0x190(%rsp)
  5abbb7:	00 
  5abbb8:	4c 89 bc 24 98 01 00 	mov    %r15,0x198(%rsp)
  5abbbf:	00 
  5abbc0:	48 89 ac 24 a0 01 00 	mov    %rbp,0x1a0(%rsp)
  5abbc7:	00 
  5abbc8:	88 84 24 a8 01 00 00 	mov    %al,0x1a8(%rsp)
  5abbcf:	48 8b b4 24 d8 05 00 	mov    0x5d8(%rsp),%rsi
  5abbd6:	00 
  5abbd7:	48 85 f6             	test   %rsi,%rsi
  5abbda:	74 58                	je     5abc34 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1c04>
  5abbdc:	48 8b 94 24 e0 05 00 	mov    0x5e0(%rsp),%rdx
  5abbe3:	00 
  5abbe4:	48 8d bc 24 a0 00 00 	lea    0xa0(%rsp),%rdi
  5abbeb:	00 
  5abbec:	48 8d 8c 24 90 01 00 	lea    0x190(%rsp),%rcx
  5abbf3:	00 
  5abbf4:	e8 87 b8 0c 00       	call   677480 <_RINvMs_NtNtNtCscdodAO9FK5_5alloc11collections5btree6searchINtNtB7_4node7NodeRefNtNtBX_6marker3MutTINtNtCs4NRVxsYgnAr_4core6option6OptionyENtNtCs6gaF1xUz9Bf_4gpui4list6ListIdNtNtB2g_7element8NodeKindEjNtB1h_14LeafOrInternalE11search_treeB1x_EB2g_>
  5abbf9:	48 8b 84 24 a8 00 00 	mov    0xa8(%rsp),%rax
  5abc00:	00 
  5abc01:	80 bc 24 a0 00 00 00 	cmpb   $0x0,0xa0(%rsp)
  5abc08:	00 
  5abc09:	0f 84 a7 f9 ff ff    	je     5ab5b6 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1586>
  5abc0f:	48 8d 94 24 b0 00 00 	lea    0xb0(%rsp),%rdx
  5abc16:	00 
  5abc17:	0f 10 02             	movups (%rdx),%xmm0
  5abc1a:	0f 29 84 24 b0 03 00 	movaps %xmm0,0x3b0(%rsp)
  5abc21:	00 
  5abc22:	4c 8b bc 24 98 01 00 	mov    0x198(%rsp),%r15
  5abc29:	00 
  5abc2a:	48 8b 8c 24 a8 01 00 	mov    0x1a8(%rsp),%rcx
  5abc31:	00 
  5abc32:	eb 12                	jmp    5abc46 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1c16>
  5abc34:	48 8b 8c 24 a8 01 00 	mov    0x1a8(%rsp),%rcx
  5abc3b:	00 
  5abc3c:	31 c0                	xor    %eax,%eax
  5abc3e:	48 8d 94 24 b0 00 00 	lea    0xb0(%rsp),%rdx
  5abc45:	00 
  5abc46:	4c 89 b4 24 a0 00 00 	mov    %r14,0xa0(%rsp)
  5abc4d:	00 
  5abc4e:	4c 89 bc 24 a8 00 00 	mov    %r15,0xa8(%rsp)
  5abc55:	00 
  5abc56:	48 89 ac 24 b0 00 00 	mov    %rbp,0xb0(%rsp)
  5abc5d:	00 
  5abc5e:	48 89 8c 24 b8 00 00 	mov    %rcx,0xb8(%rsp)
  5abc65:	00 
  5abc66:	48 8d 8c 24 d8 05 00 	lea    0x5d8(%rsp),%rcx
  5abc6d:	00 
  5abc6e:	48 89 8c 24 c0 00 00 	mov    %rcx,0xc0(%rsp)
  5abc75:	00 
  5abc76:	48 89 84 24 c8 00 00 	mov    %rax,0xc8(%rsp)
  5abc7d:	00 
  5abc7e:	0f 28 84 24 b0 03 00 	movaps 0x3b0(%rsp),%xmm0
  5abc85:	00 
  5abc86:	0f 11 42 20          	movups %xmm0,0x20(%rdx)
  5abc8a:	48 8d bc 24 00 03 00 	lea    0x300(%rsp),%rdi
  5abc91:	00 
  5abc92:	48 8d b4 24 a0 00 00 	lea    0xa0(%rsp),%rsi
  5abc99:	00 
  5abc9a:	48 89 da             	mov    %rbx,%rdx
  5abc9d:	e8 ae cd 1c 00       	call   778a50 <_RNvMs4_NtNtNtNtCscdodAO9FK5_5alloc11collections5btree3map5entryINtB5_11VacantEntryTINtNtCs4NRVxsYgnAr_4core6option6OptionyENtNtCs6gaF1xUz9Bf_4gpui4list6ListIdNtNtB21_7element8NodeKindEjE12insert_entryB21_>
  5abca2:	e9 1f f9 ff ff       	jmp    5ab5c6 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1596>
  5abca7:	4c 8b ac 24 30 04 00 	mov    0x430(%rsp),%r13
  5abcae:	00 
  5abcaf:	4a 8d 1c ed 00 00 00 	lea    0x0(,%r13,8),%rbx
  5abcb6:	00 
  5abcb7:	ff 15 33 e2 53 00    	call   *0x53e233(%rip)        # ae9ef0 <_DYNAMIC+0x340>
  5abcbd:	be 08 00 00 00       	mov    $0x8,%esi
  5abcc2:	48 89 df             	mov    %rbx,%rdi
  5abcc5:	ff 15 25 e1 53 00    	call   *0x53e125(%rip)        # ae9df0 <_DYNAMIC+0x240>
  5abccb:	48 89 84 24 80 00 00 	mov    %rax,0x80(%rsp)
  5abcd2:	00 
  5abcd3:	48 85 c0             	test   %rax,%rax
  5abcd6:	0f 84 7a 3e 00 00    	je     5afb56 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5b26>
  5abcdc:	31 c0                	xor    %eax,%eax
  5abcde:	48 8b 94 24 80 00 00 	mov    0x80(%rsp),%rdx
  5abce5:	00 
  5abce6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  5abced:	00 00 00 
  5abcf0:	49 8b 0e             	mov    (%r14),%rcx
  5abcf3:	48 85 c9             	test   %rcx,%rcx
  5abcf6:	0f 84 d5 39 00 00    	je     5af6d1 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x56a1>
  5abcfc:	48 89 0c c2          	mov    %rcx,(%rdx,%rax,8)
  5abd00:	48 ff c0             	inc    %rax
  5abd03:	49 83 c6 28          	add    $0x28,%r14
  5abd07:	49 39 c5             	cmp    %rax,%r13
  5abd0a:	75 e4                	jne    5abcf0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1cc0>
  5abd0c:	4c 89 ac 24 d8 02 00 	mov    %r13,0x2d8(%rsp)
  5abd13:	00 
  5abd14:	eb 19                	jmp    5abd2f <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1cff>
  5abd16:	b8 08 00 00 00       	mov    $0x8,%eax
  5abd1b:	48 89 84 24 80 00 00 	mov    %rax,0x80(%rsp)
  5abd22:	00 
  5abd23:	48 c7 84 24 d8 02 00 	movq   $0x0,0x2d8(%rsp)
  5abd2a:	00 00 00 00 00 
  5abd2f:	48 b8 01 00 00 00 00 	movabs $0x8000000000000001,%rax
  5abd36:	00 00 80 
  5abd39:	48 ff c8             	dec    %rax
  5abd3c:	48 c7 84 24 38 07 00 	movq   $0x0,0x738(%rsp)
  5abd43:	00 00 00 00 00 
  5abd48:	4c 89 a4 24 40 07 00 	mov    %r12,0x740(%rsp)
  5abd4f:	00 
  5abd50:	48 89 84 24 50 02 00 	mov    %rax,0x250(%rsp)
  5abd57:	00 
  5abd58:	48 89 84 24 08 07 00 	mov    %rax,0x708(%rsp)
  5abd5f:	00 
  5abd60:	4d 85 e4             	test   %r12,%r12
  5abd63:	4a 8d 04 e5 00 00 00 	lea    0x0(,%r12,8),%rax
  5abd6a:	00 
  5abd6b:	74 5b                	je     5abdc8 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1d98>
  5abd6d:	48 8d 1c 80          	lea    (%rax,%rax,4),%rbx
  5abd71:	ff 15 79 e1 53 00    	call   *0x53e179(%rip)        # ae9ef0 <_DYNAMIC+0x340>
  5abd77:	be 08 00 00 00       	mov    $0x8,%esi
  5abd7c:	48 89 df             	mov    %rbx,%rdi
  5abd7f:	ff 15 6b e0 53 00    	call   *0x53e06b(%rip)        # ae9df0 <_DYNAMIC+0x240>
  5abd85:	48 85 c0             	test   %rax,%rax
  5abd88:	0f 84 b8 3d 00 00    	je     5afb46 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5b16>
  5abd8e:	4c 89 a4 24 18 02 00 	mov    %r12,0x218(%rsp)
  5abd95:	00 
  5abd96:	48 89 84 24 20 02 00 	mov    %rax,0x220(%rsp)
  5abd9d:	00 
  5abd9e:	48 c7 84 24 28 02 00 	movq   $0x0,0x228(%rsp)
  5abda5:	00 00 00 00 00 
  5abdaa:	48 8b 84 24 40 06 00 	mov    0x640(%rsp),%rax
  5abdb1:	00 
  5abdb2:	44 89 e1             	mov    %r12d,%ecx
  5abdb5:	83 e1 03             	and    $0x3,%ecx
  5abdb8:	49 83 fc 04          	cmp    $0x4,%r12
  5abdbc:	73 40                	jae    5abdfe <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1dce>
  5abdbe:	31 d2                	xor    %edx,%edx
  5abdc0:	45 31 f6             	xor    %r14d,%r14d
  5abdc3:	e9 a1 00 00 00       	jmp    5abe69 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1e39>
  5abdc8:	48 c7 84 24 18 02 00 	movq   $0x0,0x218(%rsp)
  5abdcf:	00 00 00 00 00 
  5abdd4:	48 c7 84 24 20 02 00 	movq   $0x8,0x220(%rsp)
  5abddb:	00 08 00 00 00 
  5abde0:	48 c7 84 24 28 02 00 	movq   $0x0,0x228(%rsp)
  5abde7:	00 00 00 00 00 
  5abdec:	b8 08 00 00 00       	mov    $0x8,%eax
  5abdf1:	4c 8b bc 24 40 06 00 	mov    0x640(%rsp),%r15
  5abdf8:	00 
  5abdf9:	e9 04 01 00 00       	jmp    5abf02 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1ed2>
  5abdfe:	44 89 e6             	mov    %r12d,%esi
  5abe01:	81 e6 fc ff 01 00    	and    $0x1fffc,%esi
  5abe07:	31 d2                	xor    %edx,%edx
  5abe09:	48 89 c7             	mov    %rax,%rdi
  5abe0c:	45 31 f6             	xor    %r14d,%r14d
  5abe0f:	90                   	nop
  5abe10:	45 31 c0             	xor    %r8d,%r8d
  5abe13:	48 83 3f ff          	cmpq   $0xffffffffffffffff,(%rdi)
  5abe17:	41 0f 95 c0          	setne  %r8b
  5abe1b:	4d 01 f0             	add    %r14,%r8
  5abe1e:	45 31 c9             	xor    %r9d,%r9d
  5abe21:	48 83 bf 98 00 00 00 	cmpq   $0xffffffffffffffff,0x98(%rdi)
  5abe28:	ff 
  5abe29:	41 0f 95 c1          	setne  %r9b
  5abe2d:	45 31 d2             	xor    %r10d,%r10d
  5abe30:	48 83 bf 30 01 00 00 	cmpq   $0xffffffffffffffff,0x130(%rdi)
  5abe37:	ff 
  5abe38:	41 0f 95 c2          	setne  %r10b
  5abe3c:	4d 01 ca             	add    %r9,%r10
  5abe3f:	4d 01 c2             	add    %r8,%r10
  5abe42:	45 31 f6             	xor    %r14d,%r14d
  5abe45:	48 83 bf c8 01 00 00 	cmpq   $0xffffffffffffffff,0x1c8(%rdi)
  5abe4c:	ff 
  5abe4d:	41 0f 95 c6          	setne  %r14b
  5abe51:	4d 01 d6             	add    %r10,%r14
  5abe54:	48 83 c2 04          	add    $0x4,%rdx
  5abe58:	48 81 c7 60 02 00 00 	add    $0x260,%rdi
  5abe5f:	48 39 d6             	cmp    %rdx,%rsi
  5abe62:	75 ac                	jne    5abe10 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1de0>
  5abe64:	48 85 c9             	test   %rcx,%rcx
  5abe67:	74 31                	je     5abe9a <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1e6a>
  5abe69:	48 69 d2 98 00 00 00 	imul   $0x98,%rdx,%rdx
  5abe70:	48 01 c2             	add    %rax,%rdx
  5abe73:	48 69 c9 98 00 00 00 	imul   $0x98,%rcx,%rcx
  5abe7a:	31 f6                	xor    %esi,%esi
  5abe7c:	0f 1f 40 00          	nopl   0x0(%rax)
  5abe80:	31 ff                	xor    %edi,%edi
  5abe82:	48 83 3c 32 ff       	cmpq   $0xffffffffffffffff,(%rdx,%rsi,1)
  5abe87:	40 0f 95 c7          	setne  %dil
  5abe8b:	49 01 fe             	add    %rdi,%r14
  5abe8e:	48 81 c6 98 00 00 00 	add    $0x98,%rsi
  5abe95:	48 39 f1             	cmp    %rsi,%rcx
  5abe98:	75 e6                	jne    5abe80 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1e50>
  5abe9a:	49 89 c7             	mov    %rax,%r15
  5abe9d:	4d 85 f6             	test   %r14,%r14
  5abea0:	74 5b                	je     5abefd <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1ecd>
  5abea2:	4c 89 f0             	mov    %r14,%rax
  5abea5:	48 c1 e0 04          	shl    $0x4,%rax
  5abea9:	48 8d 1c 80          	lea    (%rax,%rax,4),%rbx
  5abead:	ff 15 3d e0 53 00    	call   *0x53e03d(%rip)        # ae9ef0 <_DYNAMIC+0x340>
  5abeb3:	be 08 00 00 00       	mov    $0x8,%esi
  5abeb8:	48 89 df             	mov    %rbx,%rdi
  5abebb:	ff 15 2f df 53 00    	call   *0x53df2f(%rip)        # ae9df0 <_DYNAMIC+0x240>
  5abec1:	48 85 c0             	test   %rax,%rax
  5abec4:	75 3f                	jne    5abf05 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1ed5>
  5abec6:	bf 08 00 00 00       	mov    $0x8,%edi
  5abecb:	48 89 de             	mov    %rbx,%rsi
  5abece:	ff 15 24 e0 53 00    	call   *0x53e024(%rip)        # ae9ef8 <_DYNAMIC+0x348>
  5abed4:	e9 f3 3c 00 00       	jmp    5afbcc <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5b9c>
  5abed9:	0f 10 84 24 a8 00 00 	movups 0xa8(%rsp),%xmm0
  5abee0:	00 
  5abee1:	48 8b 8c 24 88 00 00 	mov    0x88(%rsp),%rcx
  5abee8:	00 
  5abee9:	48 c7 01 1f 00 00 00 	movq   $0x1f,(%rcx)
  5abef0:	48 89 41 08          	mov    %rax,0x8(%rcx)
  5abef4:	0f 11 41 10          	movups %xmm0,0x10(%rcx)
  5abef8:	e9 0d 28 00 00       	jmp    5ae70a <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x46da>
  5abefd:	b8 08 00 00 00       	mov    $0x8,%eax
  5abf02:	45 31 f6             	xor    %r14d,%r14d
  5abf05:	4c 89 b4 24 28 05 00 	mov    %r14,0x528(%rsp)
  5abf0c:	00 
  5abf0d:	48 89 84 24 30 05 00 	mov    %rax,0x530(%rsp)
  5abf14:	00 
  5abf15:	48 c7 84 24 38 05 00 	movq   $0x0,0x538(%rsp)
  5abf1c:	00 00 00 00 00 
  5abf21:	49 8d 44 24 01       	lea    0x1(%r12),%rax
  5abf26:	48 8d 1c 85 00 00 00 	lea    0x0(,%rax,4),%rbx
  5abf2d:	00 
  5abf2e:	ff 15 bc df 53 00    	call   *0x53dfbc(%rip)        # ae9ef0 <_DYNAMIC+0x340>
  5abf34:	be 04 00 00 00       	mov    $0x4,%esi
  5abf39:	48 89 df             	mov    %rbx,%rdi
  5abf3c:	ff 15 c6 de 53 00    	call   *0x53dec6(%rip)        # ae9e08 <_DYNAMIC+0x258>
  5abf42:	48 89 84 24 48 02 00 	mov    %rax,0x248(%rsp)
  5abf49:	00 
  5abf4a:	48 85 c0             	test   %rax,%rax
  5abf4d:	0f 84 cb 3b 00 00    	je     5afb1e <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5aee>
  5abf53:	48 89 9c 24 d0 02 00 	mov    %rbx,0x2d0(%rsp)
  5abf5a:	00 
  5abf5b:	48 8b 84 24 10 02 00 	mov    0x210(%rsp),%rax
  5abf62:	00 
  5abf63:	4c 01 f8             	add    %r15,%rax
  5abf66:	4c 89 bc 24 00 04 00 	mov    %r15,0x400(%rsp)
  5abf6d:	00 
  5abf6e:	4c 89 bc 24 08 04 00 	mov    %r15,0x408(%rsp)
  5abf75:	00 
  5abf76:	48 8b 4c 24 70       	mov    0x70(%rsp),%rcx
  5abf7b:	48 89 8c 24 10 04 00 	mov    %rcx,0x410(%rsp)
  5abf82:	00 
  5abf83:	48 89 84 24 10 02 00 	mov    %rax,0x210(%rsp)
  5abf8a:	00 
  5abf8b:	48 89 84 24 18 04 00 	mov    %rax,0x418(%rsp)
  5abf92:	00 
  5abf93:	48 c7 84 24 20 04 00 	movq   $0x0,0x420(%rsp)
  5abf9a:	00 00 00 00 00 
  5abf9f:	4d 85 e4             	test   %r12,%r12
  5abfa2:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  5abfa7:	0f 84 cd 13 00 00    	je     5ad37a <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x334a>
  5abfad:	4c 89 fe             	mov    %r15,%rsi
  5abfb0:	48 05 48 08 00 00    	add    $0x848,%rax
  5abfb6:	48 89 44 24 60       	mov    %rax,0x60(%rsp)
  5abfbb:	45 31 f6             	xor    %r14d,%r14d
  5abfbe:	48 8d 05 03 ca 50 00 	lea    0x50ca03(%rip),%rax        # ab89c8 <anon.c906c25ea787c8c2757c1f36aabcd0ba.27.llvm.18178969024155037896+0x228>
  5abfc5:	48 89 84 24 c0 04 00 	mov    %rax,0x4c0(%rsp)
  5abfcc:	00 
  5abfcd:	41 bf 01 00 00 00    	mov    $0x1,%r15d
  5abfd3:	48 8d 05 1e cb 50 00 	lea    0x50cb1e(%rip),%rax        # ab8af8 <anon.c906c25ea787c8c2757c1f36aabcd0ba.64.llvm.18178969024155037896+0x88>
  5abfda:	48 89 84 24 b8 04 00 	mov    %rax,0x4b8(%rsp)
  5abfe1:	00 
  5abfe2:	31 c0                	xor    %eax,%eax
  5abfe4:	eb 43                	jmp    5ac029 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1ff9>
  5abfe6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  5abfed:	00 00 00 
  5abff0:	0f b6 44 24 08       	movzbl 0x8(%rsp),%eax
  5abff5:	48 8b 8c 24 d8 04 00 	mov    0x4d8(%rsp),%rcx
  5abffc:	00 
  5abffd:	48 01 c1             	add    %rax,%rcx
  5ac000:	48 89 c8             	mov    %rcx,%rax
  5ac003:	4c 8b 6c 24 58       	mov    0x58(%rsp),%r13
  5ac008:	4c 8b b4 24 d0 04 00 	mov    0x4d0(%rsp),%r14
  5ac00f:	00 
  5ac010:	48 8b 8c 24 f8 01 00 	mov    0x1f8(%rsp),%rcx
  5ac017:	00 
  5ac018:	48 89 ce             	mov    %rcx,%rsi
  5ac01b:	48 3b 8c 24 10 02 00 	cmp    0x210(%rsp),%rcx
  5ac022:	00 
  5ac023:	0f 84 53 13 00 00    	je     5ad37c <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x334c>
  5ac029:	48 8d 8e 98 00 00 00 	lea    0x98(%rsi),%rcx
  5ac030:	48 89 8c 24 08 04 00 	mov    %rcx,0x408(%rsp)
  5ac037:	00 
  5ac038:	48 8b 1e             	mov    (%rsi),%rbx
  5ac03b:	48 83 fb fe          	cmp    $0xfffffffffffffffe,%rbx
  5ac03f:	0f 84 37 13 00 00    	je     5ad37c <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x334c>
  5ac045:	48 89 8c 24 f8 01 00 	mov    %rcx,0x1f8(%rsp)
  5ac04c:	00 
  5ac04d:	48 89 84 24 d8 04 00 	mov    %rax,0x4d8(%rsp)
  5ac054:	00 
  5ac055:	48 83 c6 08          	add    $0x8,%rsi
  5ac059:	ba 90 00 00 00       	mov    $0x90,%edx
  5ac05e:	48 8d bc 24 a8 00 00 	lea    0xa8(%rsp),%rdi
  5ac065:	00 
  5ac066:	ff 15 e4 dd 53 00    	call   *0x53dde4(%rip)        # ae9e50 <memcpy@GLIBC_2.14>
  5ac06c:	49 8d 46 01          	lea    0x1(%r14),%rax
  5ac070:	48 89 84 24 d0 04 00 	mov    %rax,0x4d0(%rsp)
  5ac077:	00 
  5ac078:	48 89 84 24 20 04 00 	mov    %rax,0x420(%rsp)
  5ac07f:	00 
  5ac080:	48 89 9c 24 a0 00 00 	mov    %rbx,0xa0(%rsp)
  5ac087:	00 
  5ac088:	0f b6 b4 24 b8 00 00 	movzbl 0xb8(%rsp),%esi
  5ac08f:	00 
  5ac090:	8b 84 24 bc 00 00 00 	mov    0xbc(%rsp),%eax
  5ac097:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
  5ac09c:	48 ff c0             	inc    %rax
  5ac09f:	40 84 f6             	test   %sil,%sil
  5ac0a2:	b9 00 00 00 00       	mov    $0x0,%ecx
  5ac0a7:	48 0f 45 c8          	cmovne %rax,%rcx
  5ac0ab:	4c 39 e1             	cmp    %r12,%rcx
  5ac0ae:	0f 87 9a 38 00 00    	ja     5af94e <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x591e>
  5ac0b4:	48 8b 94 24 48 02 00 	mov    0x248(%rsp),%rdx
  5ac0bb:	00 
  5ac0bc:	8b 04 8a             	mov    (%rdx,%rcx,4),%eax
  5ac0bf:	48 89 84 24 80 02 00 	mov    %rax,0x280(%rsp)
  5ac0c6:	00 
  5ac0c7:	ff c0                	inc    %eax
  5ac0c9:	89 04 8a             	mov    %eax,(%rdx,%rcx,4)
  5ac0cc:	40 84 f6             	test   %sil,%sil
  5ac0cf:	40 88 74 24 50       	mov    %sil,0x50(%rsp)
  5ac0d4:	74 52                	je     5ac128 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x20f8>
  5ac0d6:	48 8b b4 24 28 02 00 	mov    0x228(%rsp),%rsi
  5ac0dd:	00 
  5ac0de:	48 8b 54 24 18       	mov    0x18(%rsp),%rdx
  5ac0e3:	48 39 d6             	cmp    %rdx,%rsi
  5ac0e6:	0f 86 39 39 00 00    	jbe    5afa25 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x59f5>
  5ac0ec:	48 8b 84 24 20 02 00 	mov    0x220(%rsp),%rax
  5ac0f3:	00 
  5ac0f4:	48 8d 14 92          	lea    (%rdx,%rdx,4),%rdx
  5ac0f8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  5ac0fc:	48 89 44 24 20       	mov    %rax,0x20(%rsp)
  5ac101:	b8 01 00 00 00       	mov    $0x1,%eax
  5ac106:	80 bc 24 98 00 00 00 	cmpb   $0x0,0x98(%rsp)
  5ac10d:	00 
  5ac10e:	75 24                	jne    5ac134 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2104>
  5ac110:	31 c9                	xor    %ecx,%ecx
  5ac112:	48 8b 94 24 c0 06 00 	mov    0x6c0(%rsp),%rdx
  5ac119:	00 
  5ac11a:	48 85 d2             	test   %rdx,%rdx
  5ac11d:	0f 85 f9 00 00 00    	jne    5ac21c <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x21ec>
  5ac123:	e9 de 01 00 00       	jmp    5ac306 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x22d6>
  5ac128:	31 c0                	xor    %eax,%eax
  5ac12a:	80 bc 24 98 00 00 00 	cmpb   $0x0,0x98(%rsp)
  5ac131:	00 
  5ac132:	74 dc                	je     5ac110 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x20e0>
  5ac134:	48 8b 94 24 10 05 00 	mov    0x510(%rsp),%rdx
  5ac13b:	00 
  5ac13c:	48 85 d2             	test   %rdx,%rdx
  5ac13f:	0f 84 a9 00 00 00    	je     5ac1ee <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x21be>
  5ac145:	48 8b b4 24 18 05 00 	mov    0x518(%rsp),%rsi
  5ac14c:	00 
  5ac14d:	48 85 c0             	test   %rax,%rax
  5ac150:	74 7e                	je     5ac1d0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x21a0>
  5ac152:	44 0f b7 82 12 01 00 	movzwl 0x112(%rdx),%r8d
  5ac159:	00 
  5ac15a:	45 89 c1             	mov    %r8d,%r9d
  5ac15d:	41 c1 e1 04          	shl    $0x4,%r9d
  5ac161:	48 c7 c7 ff ff ff ff 	mov    $0xffffffffffffffff,%rdi
  5ac168:	49 89 d2             	mov    %rdx,%r10
  5ac16b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
  5ac170:	4d 85 c9             	test   %r9,%r9
  5ac173:	74 39                	je     5ac1ae <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x217e>
  5ac175:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  5ac17a:	4d 3b 5a 08          	cmp    0x8(%r10),%r11
  5ac17e:	41 0f 97 c3          	seta   %r11b
  5ac182:	41 80 db 00          	sbb    $0x0,%r11b
  5ac186:	41 f6 02 01          	testb  $0x1,(%r10)
  5ac18a:	4d 8d 52 10          	lea    0x10(%r10),%r10
  5ac18e:	45 0f b6 db          	movzbl %r11b,%r11d
  5ac192:	45 0f 44 df          	cmove  %r15d,%r11d
  5ac196:	48 ff c7             	inc    %rdi
  5ac199:	49 83 c1 f0          	add    $0xfffffffffffffff0,%r9
  5ac19d:	41 80 fb 01          	cmp    $0x1,%r11b
  5ac1a1:	74 cd                	je     5ac170 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2140>
  5ac1a3:	45 0f b6 c3          	movzbl %r11b,%r8d
  5ac1a7:	45 85 c0             	test   %r8d,%r8d
  5ac1aa:	74 48                	je     5ac1f4 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x21c4>
  5ac1ac:	eb 03                	jmp    5ac1b1 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2181>
  5ac1ae:	4c 89 c7             	mov    %r8,%rdi
  5ac1b1:	48 83 ee 01          	sub    $0x1,%rsi
  5ac1b5:	72 37                	jb     5ac1ee <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x21be>
  5ac1b7:	48 8b 94 fa 18 01 00 	mov    0x118(%rdx,%rdi,8),%rdx
  5ac1be:	00 
  5ac1bf:	eb 91                	jmp    5ac152 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2122>
  5ac1c1:	66 66 66 66 66 66 2e 	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  5ac1c8:	0f 1f 84 00 00 00 00 
  5ac1cf:	00 
  5ac1d0:	66 83 ba 12 01 00 00 	cmpw   $0x0,0x112(%rdx)
  5ac1d7:	00 
  5ac1d8:	74 05                	je     5ac1df <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x21af>
  5ac1da:	f6 02 01             	testb  $0x1,(%rdx)
  5ac1dd:	74 13                	je     5ac1f2 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x21c2>
  5ac1df:	48 83 ee 01          	sub    $0x1,%rsi
  5ac1e3:	72 09                	jb     5ac1ee <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x21be>
  5ac1e5:	48 8b 92 18 01 00 00 	mov    0x118(%rdx),%rdx
  5ac1ec:	eb e2                	jmp    5ac1d0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x21a0>
  5ac1ee:	31 d2                	xor    %edx,%edx
  5ac1f0:	eb 0a                	jmp    5ac1fc <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x21cc>
  5ac1f2:	31 ff                	xor    %edi,%edi
  5ac1f4:	48 8b 94 fa b8 00 00 	mov    0xb8(%rdx,%rdi,8),%rdx
  5ac1fb:	00 
  5ac1fc:	48 8b b4 24 e0 02 00 	mov    0x2e0(%rsp),%rsi
  5ac203:	00 
  5ac204:	48 3b 14 ce          	cmp    (%rsi,%rcx,8),%rdx
  5ac208:	0f 94 c1             	sete   %cl
  5ac20b:	48 8b 94 24 c0 06 00 	mov    0x6c0(%rsp),%rdx
  5ac212:	00 
  5ac213:	48 85 d2             	test   %rdx,%rdx
  5ac216:	0f 84 ea 00 00 00    	je     5ac306 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x22d6>
  5ac21c:	48 8b b4 24 c8 06 00 	mov    0x6c8(%rsp),%rsi
  5ac223:	00 
  5ac224:	44 0f b7 8a 12 01 00 	movzwl 0x112(%rdx),%r9d
  5ac22b:	00 
  5ac22c:	45 89 ca             	mov    %r9d,%r10d
  5ac22f:	41 c1 e2 04          	shl    $0x4,%r10d
  5ac233:	48 c7 c7 ff ff ff ff 	mov    $0xffffffffffffffff,%rdi
  5ac23a:	45 31 c0             	xor    %r8d,%r8d
  5ac23d:	0f 1f 00             	nopl   (%rax)
  5ac240:	4d 39 c2             	cmp    %r8,%r10
  5ac243:	74 2b                	je     5ac270 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2240>
  5ac245:	4c 3b b4 fa c0 00 00 	cmp    0xc0(%rdx,%rdi,8),%r14
  5ac24c:	00 
  5ac24d:	41 0f 97 c3          	seta   %r11b
  5ac251:	41 80 db 00          	sbb    $0x0,%r11b
  5ac255:	49 83 c0 10          	add    $0x10,%r8
  5ac259:	48 ff c7             	inc    %rdi
  5ac25c:	41 80 fb 01          	cmp    $0x1,%r11b
  5ac260:	74 de                	je     5ac240 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2210>
  5ac262:	45 0f b6 cb          	movzbl %r11b,%r9d
  5ac266:	45 85 c9             	test   %r9d,%r9d
  5ac269:	75 08                	jne    5ac273 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2243>
  5ac26b:	eb 23                	jmp    5ac290 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2260>
  5ac26d:	0f 1f 00             	nopl   (%rax)
  5ac270:	4c 89 cf             	mov    %r9,%rdi
  5ac273:	48 83 ee 01          	sub    $0x1,%rsi
  5ac277:	0f 82 89 00 00 00    	jb     5ac306 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x22d6>
  5ac27d:	48 8b 94 fa 18 01 00 	mov    0x118(%rdx,%rdi,8),%rdx
  5ac284:	00 
  5ac285:	eb 9d                	jmp    5ac224 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x21f4>
  5ac287:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
  5ac28e:	00 00 
  5ac290:	80 bc 24 98 00 00 00 	cmpb   $0x0,0x98(%rsp)
  5ac297:	00 
  5ac298:	0f 84 42 03 00 00    	je     5ac5e0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x25b0>
  5ac29e:	4a 8b 4c 02 f8       	mov    -0x8(%rdx,%r8,1),%rcx
  5ac2a3:	48 8b 49 08          	mov    0x8(%rcx),%rcx
  5ac2a7:	0f b6 94 24 30 01 00 	movzbl 0x130(%rsp),%edx
  5ac2ae:	00 
  5ac2af:	48 89 84 24 90 01 00 	mov    %rax,0x190(%rsp)
  5ac2b6:	00 
  5ac2b7:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  5ac2bc:	48 89 84 24 98 01 00 	mov    %rax,0x198(%rsp)
  5ac2c3:	00 
  5ac2c4:	48 89 8c 24 a0 01 00 	mov    %rcx,0x1a0(%rsp)
  5ac2cb:	00 
  5ac2cc:	88 94 24 a8 01 00 00 	mov    %dl,0x1a8(%rsp)
  5ac2d3:	48 8b b4 24 c0 05 00 	mov    0x5c0(%rsp),%rsi
  5ac2da:	00 
  5ac2db:	48 85 f6             	test   %rsi,%rsi
  5ac2de:	0f 84 14 01 00 00    	je     5ac3f8 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x23c8>
  5ac2e4:	48 8b 94 24 c8 05 00 	mov    0x5c8(%rsp),%rdx
  5ac2eb:	00 
  5ac2ec:	48 8d bc 24 00 03 00 	lea    0x300(%rsp),%rdi
  5ac2f3:	00 
  5ac2f4:	48 8d 8c 24 90 01 00 	lea    0x190(%rsp),%rcx
  5ac2fb:	00 
  5ac2fc:	e8 7f b1 0c 00       	call   677480 <_RINvMs_NtNtNtCscdodAO9FK5_5alloc11collections5btree6searchINtNtB7_4node7NodeRefNtNtBX_6marker3MutTINtNtCs4NRVxsYgnAr_4core6option6OptionyENtNtCs6gaF1xUz9Bf_4gpui4list6ListIdNtNtB2g_7element8NodeKindEjNtB1h_14LeafOrInternalE11search_treeB1x_EB2g_>
  5ac301:	e9 e4 00 00 00       	jmp    5ac3ea <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x23ba>
  5ac306:	48 8b 94 24 a8 06 00 	mov    0x6a8(%rsp),%rdx
  5ac30d:	00 
  5ac30e:	48 85 d2             	test   %rdx,%rdx
  5ac311:	0f 84 e8 00 00 00    	je     5ac3ff <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x23cf>
  5ac317:	48 8b b4 24 b0 06 00 	mov    0x6b0(%rsp),%rsi
  5ac31e:	00 
  5ac31f:	44 0f b7 82 ba 00 00 	movzwl 0xba(%rdx),%r8d
  5ac326:	00 
  5ac327:	45 89 c1             	mov    %r8d,%r9d
  5ac32a:	41 c1 e1 03          	shl    $0x3,%r9d
  5ac32e:	48 c7 c7 ff ff ff ff 	mov    $0xffffffffffffffff,%rdi
  5ac335:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
  5ac33c:	00 00 00 00 
  5ac340:	4d 85 c9             	test   %r9,%r9
  5ac343:	74 25                	je     5ac36a <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x233a>
  5ac345:	4c 3b 74 fa 10       	cmp    0x10(%rdx,%rdi,8),%r14
  5ac34a:	41 0f 97 c2          	seta   %r10b
  5ac34e:	41 80 da 00          	sbb    $0x0,%r10b
  5ac352:	48 ff c7             	inc    %rdi
  5ac355:	49 83 c1 f8          	add    $0xfffffffffffffff8,%r9
  5ac359:	41 80 fa 01          	cmp    $0x1,%r10b
  5ac35d:	74 e1                	je     5ac340 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2310>
  5ac35f:	45 0f b6 c2          	movzbl %r10b,%r8d
  5ac363:	45 85 c0             	test   %r8d,%r8d
  5ac366:	75 05                	jne    5ac36d <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x233d>
  5ac368:	eb 17                	jmp    5ac381 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2351>
  5ac36a:	4c 89 c7             	mov    %r8,%rdi
  5ac36d:	48 83 ee 01          	sub    $0x1,%rsi
  5ac371:	0f 82 88 00 00 00    	jb     5ac3ff <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x23cf>
  5ac377:	48 8b 94 fa c0 00 00 	mov    0xc0(%rdx,%rdi,8),%rdx
  5ac37e:	00 
  5ac37f:	eb 9e                	jmp    5ac31f <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x22ef>
  5ac381:	80 bc 24 98 00 00 00 	cmpb   $0x0,0x98(%rsp)
  5ac388:	00 
  5ac389:	0f 84 51 02 00 00    	je     5ac5e0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x25b0>
  5ac38f:	48 8b 4c fa 60       	mov    0x60(%rdx,%rdi,8),%rcx
  5ac394:	0f b6 94 24 30 01 00 	movzbl 0x130(%rsp),%edx
  5ac39b:	00 
  5ac39c:	48 89 84 24 90 01 00 	mov    %rax,0x190(%rsp)
  5ac3a3:	00 
  5ac3a4:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  5ac3a9:	48 89 84 24 98 01 00 	mov    %rax,0x198(%rsp)
  5ac3b0:	00 
  5ac3b1:	48 89 8c 24 a0 01 00 	mov    %rcx,0x1a0(%rsp)
  5ac3b8:	00 
  5ac3b9:	88 94 24 a8 01 00 00 	mov    %dl,0x1a8(%rsp)
  5ac3c0:	48 8b b4 24 d8 05 00 	mov    0x5d8(%rsp),%rsi
  5ac3c7:	00 
  5ac3c8:	48 85 f6             	test   %rsi,%rsi
  5ac3cb:	74 2b                	je     5ac3f8 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x23c8>
  5ac3cd:	48 8b 94 24 e0 05 00 	mov    0x5e0(%rsp),%rdx
  5ac3d4:	00 
  5ac3d5:	48 8d bc 24 00 03 00 	lea    0x300(%rsp),%rdi
  5ac3dc:	00 
  5ac3dd:	48 8d 8c 24 90 01 00 	lea    0x190(%rsp),%rcx
  5ac3e4:	00 
  5ac3e5:	e8 96 b0 0c 00       	call   677480 <_RINvMs_NtNtNtCscdodAO9FK5_5alloc11collections5btree6searchINtNtB7_4node7NodeRefNtNtBX_6marker3MutTINtNtCs4NRVxsYgnAr_4core6option6OptionyENtNtCs6gaF1xUz9Bf_4gpui4list6ListIdNtNtB2g_7element8NodeKindEjNtB1h_14LeafOrInternalE11search_treeB1x_EB2g_>
  5ac3ea:	80 bc 24 00 03 00 00 	cmpb   $0x0,0x300(%rsp)
  5ac3f1:	00 
  5ac3f2:	0f 84 92 00 00 00    	je     5ac48a <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x245a>
  5ac3f8:	31 c0                	xor    %eax,%eax
  5ac3fa:	e9 a5 00 00 00       	jmp    5ac4a4 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2474>
  5ac3ff:	84 c9                	test   %cl,%cl
  5ac401:	0f 84 d9 01 00 00    	je     5ac5e0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x25b0>
  5ac407:	0f b6 8c 24 30 01 00 	movzbl 0x130(%rsp),%ecx
  5ac40e:	00 
  5ac40f:	48 89 84 24 90 01 00 	mov    %rax,0x190(%rsp)
  5ac416:	00 
  5ac417:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  5ac41c:	48 89 84 24 98 01 00 	mov    %rax,0x198(%rsp)
  5ac423:	00 
  5ac424:	48 8b 84 24 80 02 00 	mov    0x280(%rsp),%rax
  5ac42b:	00 
  5ac42c:	89 84 24 a0 01 00 00 	mov    %eax,0x1a0(%rsp)
  5ac433:	88 8c 24 a4 01 00 00 	mov    %cl,0x1a4(%rsp)
  5ac43a:	48 8b b4 24 a8 05 00 	mov    0x5a8(%rsp),%rsi
  5ac441:	00 
  5ac442:	48 85 f6             	test   %rsi,%rsi
  5ac445:	74 b1                	je     5ac3f8 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x23c8>
  5ac447:	48 8b 94 24 b0 05 00 	mov    0x5b0(%rsp),%rdx
  5ac44e:	00 
  5ac44f:	48 8d bc 24 00 03 00 	lea    0x300(%rsp),%rdi
  5ac456:	00 
  5ac457:	48 8d 8c 24 90 01 00 	lea    0x190(%rsp),%rcx
  5ac45e:	00 
  5ac45f:	e8 cc b1 0c 00       	call   677630 <_RINvMs_NtNtNtCscdodAO9FK5_5alloc11collections5btree6searchINtNtB7_4node7NodeRefNtNtBX_6marker3MutTINtNtCs4NRVxsYgnAr_4core6option6OptionyEmNtNtCs6gaF1xUz9Bf_4gpui7element8NodeKindEjNtB1h_14LeafOrInternalE11search_treeB1x_EB2h_>
  5ac464:	80 bc 24 00 03 00 00 	cmpb   $0x0,0x300(%rsp)
  5ac46b:	00 
  5ac46c:	75 8a                	jne    5ac3f8 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x23c8>
  5ac46e:	48 8b 84 24 08 03 00 	mov    0x308(%rsp),%rax
  5ac475:	00 
  5ac476:	48 8b 8c 24 18 03 00 	mov    0x318(%rsp),%rcx
  5ac47d:	00 
  5ac47e:	48 8d 04 c8          	lea    (%rax,%rcx,8),%rax
  5ac482:	48 05 10 01 00 00    	add    $0x110,%rax
  5ac488:	eb 1a                	jmp    5ac4a4 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2474>
  5ac48a:	48 8b 84 24 08 03 00 	mov    0x308(%rsp),%rax
  5ac491:	00 
  5ac492:	48 8b 8c 24 18 03 00 	mov    0x318(%rsp),%rcx
  5ac499:	00 
  5ac49a:	48 8d 04 c8          	lea    (%rax,%rcx,8),%rax
  5ac49e:	48 05 68 01 00 00    	add    $0x168,%rax
  5ac4a4:	48 85 c0             	test   %rax,%rax
  5ac4a7:	0f 84 33 01 00 00    	je     5ac5e0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x25b0>
  5ac4ad:	48 8b b4 24 98 04 00 	mov    0x498(%rsp),%rsi
  5ac4b4:	00 
  5ac4b5:	48 8b 08             	mov    (%rax),%rcx
  5ac4b8:	48 39 f1             	cmp    %rsi,%rcx
  5ac4bb:	0f 83 50 35 00 00    	jae    5afa11 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x59e1>
  5ac4c1:	48 8b 94 24 90 04 00 	mov    0x490(%rsp),%rdx
  5ac4c8:	00 
  5ac4c9:	48 8d 0c 89          	lea    (%rcx,%rcx,4),%rcx
  5ac4cd:	4c 8b 04 ca          	mov    (%rdx,%rcx,8),%r8
  5ac4d1:	4c 8b 7c ca 08       	mov    0x8(%rdx,%rcx,8),%r15
  5ac4d6:	48 8b 74 ca 10       	mov    0x10(%rdx,%rcx,8),%rsi
  5ac4db:	48 89 74 24 58       	mov    %rsi,0x58(%rsp)
  5ac4e0:	8b 7c ca 20          	mov    0x20(%rdx,%rcx,8),%edi
  5ac4e4:	8b 74 ca 24          	mov    0x24(%rdx,%rcx,8),%esi
  5ac4e8:	89 b4 24 90 00 00 00 	mov    %esi,0x90(%rsp)
  5ac4ef:	48 c7 04 ca 00 00 00 	movq   $0x0,(%rdx,%rcx,8)
  5ac4f6:	00 
  5ac4f7:	4c 89 84 24 28 04 00 	mov    %r8,0x428(%rsp)
  5ac4fe:	00 
  5ac4ff:	4d 85 c0             	test   %r8,%r8
  5ac502:	0f 84 d8 00 00 00    	je     5ac5e0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x25b0>
  5ac508:	48 8b b4 24 b0 02 00 	mov    0x2b0(%rsp),%rsi
  5ac50f:	00 
  5ac510:	49 39 f6             	cmp    %rsi,%r14
  5ac513:	0f 83 b5 35 00 00    	jae    5aface <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5a9e>
  5ac519:	48 8b 8c 24 a8 02 00 	mov    0x2a8(%rsp),%rcx
  5ac520:	00 
  5ac521:	8b 94 24 90 00 00 00 	mov    0x90(%rsp),%edx
  5ac528:	42 3b 14 b1          	cmp    (%rcx,%r14,4),%edx
  5ac52c:	75 74                	jne    5ac5a2 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2572>
  5ac52e:	48 8b 94 24 40 05 00 	mov    0x540(%rsp),%rdx
  5ac535:	00 
  5ac536:	48 8d 0d 2b f5 ac ff 	lea    -0x530ad5(%rip),%rcx        # 7ba68 <anon.5f884de6e78125e25881320d811d32df.113.llvm.17146438997930651657+0x8>
  5ac53d:	48 85 d2             	test   %rdx,%rdx
  5ac540:	48 8b ac 24 38 04 00 	mov    0x438(%rsp),%rbp
  5ac547:	00 
  5ac548:	4c 89 bc 24 78 02 00 	mov    %r15,0x278(%rsp)
  5ac54f:	00 
  5ac550:	0f 84 a1 0d 00 00    	je     5ad2f7 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x32c7>
  5ac556:	48 8b 00             	mov    (%rax),%rax
  5ac559:	48 83 fa 02          	cmp    $0x2,%rdx
  5ac55d:	0f 85 77 0d 00 00    	jne    5ad2da <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x32aa>
  5ac563:	48 8b b4 24 60 05 00 	mov    0x560(%rsp),%rsi
  5ac56a:	00 
  5ac56b:	48 39 f0             	cmp    %rsi,%rax
  5ac56e:	0f 83 32 36 00 00    	jae    5afba6 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5b76>
  5ac574:	48 8b b4 24 50 05 00 	mov    0x550(%rsp),%rsi
  5ac57b:	00 
  5ac57c:	48 8b 8c 24 58 05 00 	mov    0x558(%rsp),%rcx
  5ac583:	00 
  5ac584:	0f b6 04 01          	movzbl (%rcx,%rax,1),%eax
  5ac588:	48 39 c6             	cmp    %rax,%rsi
  5ac58b:	0f 86 06 36 00 00    	jbe    5afb97 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5b67>
  5ac591:	48 6b c8 58          	imul   $0x58,%rax,%rcx
  5ac595:	48 03 8c 24 48 05 00 	add    0x548(%rsp),%rcx
  5ac59c:	00 
  5ac59d:	e9 55 0d 00 00       	jmp    5ad2f7 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x32c7>
  5ac5a2:	4d 85 ff             	test   %r15,%r15
  5ac5a5:	74 39                	je     5ac5e0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x25b0>
  5ac5a7:	48 8b 44 24 58       	mov    0x58(%rsp),%rax
  5ac5ac:	48 8b 00             	mov    (%rax),%rax
  5ac5af:	48 85 c0             	test   %rax,%rax
  5ac5b2:	74 05                	je     5ac5b9 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2589>
  5ac5b4:	4c 89 ff             	mov    %r15,%rdi
  5ac5b7:	ff d0                	call   *%rax
  5ac5b9:	48 8b 44 24 58       	mov    0x58(%rsp),%rax
  5ac5be:	48 8b 70 08          	mov    0x8(%rax),%rsi
  5ac5c2:	48 85 f6             	test   %rsi,%rsi
  5ac5c5:	74 19                	je     5ac5e0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x25b0>
  5ac5c7:	48 8b 44 24 58       	mov    0x58(%rsp),%rax
  5ac5cc:	48 8b 50 10          	mov    0x10(%rax),%rdx
  5ac5d0:	4c 89 ff             	mov    %r15,%rdi
  5ac5d3:	ff 15 1f d8 53 00    	call   *0x53d81f(%rip)        # ae9df8 <_DYNAMIC+0x248>
  5ac5d9:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  5ac5e0:	48 8d 8c 24 c0 00 00 	lea    0xc0(%rsp),%rcx
  5ac5e7:	00 
  5ac5e8:	48 8b 41 50          	mov    0x50(%rcx),%rax
  5ac5ec:	48 89 84 24 a0 06 00 	mov    %rax,0x6a0(%rsp)
  5ac5f3:	00 
  5ac5f4:	0f 10 41 40          	movups 0x40(%rcx),%xmm0
  5ac5f8:	0f 29 84 24 90 06 00 	movaps %xmm0,0x690(%rsp)
  5ac5ff:	00 
  5ac600:	f3 0f 6f 01          	movdqu (%rcx),%xmm0
  5ac604:	f3 0f 6f 49 10       	movdqu 0x10(%rcx),%xmm1
  5ac609:	f3 0f 6f 51 20       	movdqu 0x20(%rcx),%xmm2
  5ac60e:	0f 10 59 30          	movups 0x30(%rcx),%xmm3
  5ac612:	0f 29 9c 24 80 06 00 	movaps %xmm3,0x680(%rsp)
  5ac619:	00 
  5ac61a:	66 0f 7f 94 24 70 06 	movdqa %xmm2,0x670(%rsp)
  5ac621:	00 00 
  5ac623:	66 0f 7f 8c 24 60 06 	movdqa %xmm1,0x660(%rsp)
  5ac62a:	00 00 
  5ac62c:	66 0f 7f 84 24 50 06 	movdqa %xmm0,0x650(%rsp)
  5ac633:	00 00 
  5ac635:	48 8b 4c 24 10       	mov    0x10(%rsp),%rcx
  5ac63a:	4c 8b b9 e0 07 00 00 	mov    0x7e0(%rcx),%r15
  5ac641:	49 8d 47 01          	lea    0x1(%r15),%rax
  5ac645:	48 89 81 e0 07 00 00 	mov    %rax,0x7e0(%rcx)
  5ac64c:	48 8b 7c 24 60       	mov    0x60(%rsp),%rdi
  5ac651:	4c 89 fe             	mov    %r15,%rsi
  5ac654:	e8 e7 c4 17 00       	call   728b40 <_RNvMsi_NtNtNtCscdodAO9FK5_5alloc11collections5btree3mapINtB5_8BTreeMapyNtNtB7_7set_val9SetValZSTE6insertCs6gaF1xUz9Bf_4gpui>
  5ac659:	4d 85 ff             	test   %r15,%r15
  5ac65c:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
  5ac661:	0f 84 8e 30 00 00    	je     5af6f5 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x56c5>
  5ac667:	3d a0 86 01 00       	cmp    $0x186a0,%eax
  5ac66c:	0f 93 c0             	setae  %al
  5ac66f:	22 44 24 50          	and    0x50(%rsp),%al
  5ac673:	3c 01                	cmp    $0x1,%al
  5ac675:	0f 84 4d 31 00 00    	je     5af7c8 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5798>
  5ac67b:	48 8b b4 24 b0 02 00 	mov    0x2b0(%rsp),%rsi
  5ac682:	00 
  5ac683:	49 39 f6             	cmp    %rsi,%r14
  5ac686:	0f 83 db 32 00 00    	jae    5af967 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5937>
  5ac68c:	0f b6 bc 24 30 01 00 	movzbl 0x130(%rsp),%edi
  5ac693:	00 
  5ac694:	48 8b 84 24 a8 02 00 	mov    0x2a8(%rsp),%rax
  5ac69b:	00 
  5ac69c:	42 8b 04 b0          	mov    (%rax,%r14,4),%eax
  5ac6a0:	89 84 24 90 00 00 00 	mov    %eax,0x90(%rsp)
  5ac6a7:	b0 01                	mov    $0x1,%al
  5ac6a9:	89 84 24 08 02 00 00 	mov    %eax,0x208(%rsp)
  5ac6b0:	48 c7 84 24 28 04 00 	movq   $0x0,0x428(%rsp)
  5ac6b7:	00 00 00 00 00 
  5ac6bc:	48 89 ac 24 78 02 00 	mov    %rbp,0x278(%rsp)
  5ac6c3:	00 
  5ac6c4:	4c 89 6c 24 58       	mov    %r13,0x58(%rsp)
  5ac6c9:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
  5ac6ce:	48 89 44 24 30       	mov    %rax,0x30(%rsp)
  5ac6d3:	48 c7 44 24 40 00 00 	movq   $0x0,0x40(%rsp)
  5ac6da:	00 00 
  5ac6dc:	48 8b ac 24 38 04 00 	mov    0x438(%rsp),%rbp
  5ac6e3:	00 
  5ac6e4:	89 f8                	mov    %edi,%eax
  5ac6e6:	83 e0 07             	and    $0x7,%eax
  5ac6e9:	48 89 84 24 68 02 00 	mov    %rax,0x268(%rsp)
  5ac6f0:	00 
  5ac6f1:	83 f8 06             	cmp    $0x6,%eax
  5ac6f4:	0f 83 09 05 00 00    	jae    5acc03 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2bd3>
  5ac6fa:	c1 ef 03             	shr    $0x3,%edi
  5ac6fd:	74 76                	je     5ac775 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2745>
  5ac6ff:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  5ac704:	48 8b b0 e0 02 00 00 	mov    0x2e0(%rax),%rsi
  5ac70b:	ff cf                	dec    %edi
  5ac70d:	48 39 fe             	cmp    %rdi,%rsi
  5ac710:	0f 86 93 32 00 00    	jbe    5af9a9 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5979>
  5ac716:	48 8b 80 d8 02 00 00 	mov    0x2d8(%rax),%rax
  5ac71d:	48 8d 0c bf          	lea    (%rdi,%rdi,4),%rcx
  5ac721:	48 c1 e1 04          	shl    $0x4,%rcx
  5ac725:	0f 10 44 08 40       	movups 0x40(%rax,%rcx,1),%xmm0
  5ac72a:	0f 29 84 24 f0 03 00 	movaps %xmm0,0x3f0(%rsp)
  5ac731:	00 
  5ac732:	f3 0f 6f 04 08       	movdqu (%rax,%rcx,1),%xmm0
  5ac737:	f3 0f 6f 4c 08 10    	movdqu 0x10(%rax,%rcx,1),%xmm1
  5ac73d:	f3 0f 6f 54 08 20    	movdqu 0x20(%rax,%rcx,1),%xmm2
  5ac743:	0f 10 5c 08 30       	movups 0x30(%rax,%rcx,1),%xmm3
  5ac748:	0f 29 9c 24 e0 03 00 	movaps %xmm3,0x3e0(%rsp)
  5ac74f:	00 
  5ac750:	66 0f 7f 94 24 d0 03 	movdqa %xmm2,0x3d0(%rsp)
  5ac757:	00 00 
  5ac759:	66 0f 7f 8c 24 c0 03 	movdqa %xmm1,0x3c0(%rsp)
  5ac760:	00 00 
  5ac762:	66 0f 7f 84 24 b0 03 	movdqa %xmm0,0x3b0(%rsp)
  5ac769:	00 00 
  5ac76b:	48 c7 04 08 fe ff ff 	movq   $0xfffffffffffffffe,(%rax,%rcx,1)
  5ac772:	ff 
  5ac773:	eb 0c                	jmp    5ac781 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2751>
  5ac775:	48 c7 84 24 b0 03 00 	movq   $0xfffffffffffffffe,0x3b0(%rsp)
  5ac77c:	00 fe ff ff ff 
  5ac781:	b0 02                	mov    $0x2,%al
  5ac783:	48 8b 94 24 20 06 00 	mov    0x620(%rsp),%rdx
  5ac78a:	00 
  5ac78b:	48 85 d2             	test   %rdx,%rdx
  5ac78e:	0f 84 43 01 00 00    	je     5ac8d7 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x28a7>
  5ac794:	48 8b b4 24 28 06 00 	mov    0x628(%rsp),%rsi
  5ac79b:	00 
  5ac79c:	44 0f b7 82 ba 00 00 	movzwl 0xba(%rdx),%r8d
  5ac7a3:	00 
  5ac7a4:	45 89 c1             	mov    %r8d,%r9d
  5ac7a7:	41 c1 e1 03          	shl    $0x3,%r9d
  5ac7ab:	48 c7 c7 ff ff ff ff 	mov    $0xffffffffffffffff,%rdi
  5ac7b2:	66 66 66 66 66 2e 0f 	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  5ac7b9:	1f 84 00 00 00 00 00 
  5ac7c0:	4d 85 c9             	test   %r9,%r9
  5ac7c3:	74 2b                	je     5ac7f0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x27c0>
  5ac7c5:	4c 3b 74 fa 10       	cmp    0x10(%rdx,%rdi,8),%r14
  5ac7ca:	41 0f 97 c2          	seta   %r10b
  5ac7ce:	41 80 da 00          	sbb    $0x0,%r10b
  5ac7d2:	48 ff c7             	inc    %rdi
  5ac7d5:	49 83 c1 f8          	add    $0xfffffffffffffff8,%r9
  5ac7d9:	41 80 fa 01          	cmp    $0x1,%r10b
  5ac7dd:	74 e1                	je     5ac7c0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2790>
  5ac7df:	45 0f b6 c2          	movzbl %r10b,%r8d
  5ac7e3:	45 85 c0             	test   %r8d,%r8d
  5ac7e6:	75 0b                	jne    5ac7f3 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x27c3>
  5ac7e8:	eb 26                	jmp    5ac810 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x27e0>
  5ac7ea:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
  5ac7f0:	4c 89 c7             	mov    %r8,%rdi
  5ac7f3:	48 83 ee 01          	sub    $0x1,%rsi
  5ac7f7:	0f 82 da 00 00 00    	jb     5ac8d7 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x28a7>
  5ac7fd:	48 8b 94 fa c0 00 00 	mov    0xc0(%rdx,%rdi,8),%rdx
  5ac804:	00 
  5ac805:	eb 95                	jmp    5ac79c <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x276c>
  5ac807:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
  5ac80e:	00 00 
  5ac810:	44 8b 4c fa 60       	mov    0x60(%rdx,%rdi,8),%r9d
  5ac815:	48 8b b4 24 80 04 00 	mov    0x480(%rsp),%rsi
  5ac81c:	00 
  5ac81d:	4c 89 8c 24 00 02 00 	mov    %r9,0x200(%rsp)
  5ac824:	00 
  5ac825:	4c 39 ce             	cmp    %r9,%rsi
  5ac828:	0f 86 61 31 00 00    	jbe    5af98f <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x595f>
  5ac82e:	0f b6 54 fa 64       	movzbl 0x64(%rdx,%rdi,8),%edx
  5ac833:	88 94 24 60 02 00 00 	mov    %dl,0x260(%rsp)
  5ac83a:	c7 84 24 70 02 00 00 	movl   $0x0,0x270(%rsp)
  5ac841:	00 00 00 00 
  5ac845:	3c 02                	cmp    $0x2,%al
  5ac847:	0f 84 b2 00 00 00    	je     5ac8ff <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x28cf>
  5ac84d:	48 8b 94 24 78 04 00 	mov    0x478(%rsp),%rdx
  5ac854:	00 
  5ac855:	48 8b b4 24 00 02 00 	mov    0x200(%rsp),%rsi
  5ac85c:	00 
  5ac85d:	48 8b 14 f2          	mov    (%rdx,%rsi,8),%rdx
  5ac861:	48 3b 4a 28          	cmp    0x28(%rdx),%rcx
  5ac865:	0f 85 94 00 00 00    	jne    5ac8ff <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x28cf>
  5ac86b:	32 84 24 60 02 00 00 	xor    0x260(%rsp),%al
  5ac872:	8b 8c 24 08 02 00 00 	mov    0x208(%rsp),%ecx
  5ac879:	88 4c 24 08          	mov    %cl,0x8(%rsp)
  5ac87d:	a8 01                	test   $0x1,%al
  5ac87f:	75 7e                	jne    5ac8ff <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x28cf>
  5ac881:	48 83 fb ff          	cmp    $0xffffffffffffffff,%rbx
  5ac885:	0f 84 9c 00 00 00    	je     5ac927 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x28f7>
  5ac88b:	48 89 d8             	mov    %rbx,%rax
  5ac88e:	48 33 84 24 50 02 00 	xor    0x250(%rsp),%rax
  5ac895:	00 
  5ac896:	48 85 db             	test   %rbx,%rbx
  5ac899:	b9 01 00 00 00       	mov    $0x1,%ecx
  5ac89e:	48 0f 49 c1          	cmovns %rcx,%rax
  5ac8a2:	48 8b 8c 24 a8 00 00 	mov    0xa8(%rsp),%rcx
  5ac8a9:	00 
  5ac8aa:	48 89 8c 24 58 02 00 	mov    %rcx,0x258(%rsp)
  5ac8b1:	00 
  5ac8b2:	48 85 c0             	test   %rax,%rax
  5ac8b5:	74 0a                	je     5ac8c1 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2891>
  5ac8b7:	48 83 f8 01          	cmp    $0x1,%rax
  5ac8bb:	0f 85 8f 00 00 00    	jne    5ac950 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2920>
  5ac8c1:	48 c7 44 24 70 ff ff 	movq   $0xffffffffffffffff,0x70(%rsp)
  5ac8c8:	ff ff 
  5ac8ca:	48 8b 9c 24 b0 00 00 	mov    0xb0(%rsp),%rbx
  5ac8d1:	00 
  5ac8d2:	e9 b9 00 00 00       	jmp    5ac990 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2960>
  5ac8d7:	c6 84 24 60 02 00 00 	movb   $0x2,0x260(%rsp)
  5ac8de:	02 
  5ac8df:	b1 01                	mov    $0x1,%cl
  5ac8e1:	89 8c 24 70 02 00 00 	mov    %ecx,0x270(%rsp)
  5ac8e8:	48 89 8c 24 00 02 00 	mov    %rcx,0x200(%rsp)
  5ac8ef:	00 
  5ac8f0:	8b 8c 24 08 02 00 00 	mov    0x208(%rsp),%ecx
  5ac8f7:	88 4c 24 08          	mov    %cl,0x8(%rsp)
  5ac8fb:	3c 02                	cmp    $0x2,%al
  5ac8fd:	74 82                	je     5ac881 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2851>
  5ac8ff:	48 8b 7c 24 60       	mov    0x60(%rsp),%rdi
  5ac904:	4c 89 fe             	mov    %r15,%rsi
  5ac907:	e8 34 c2 17 00       	call   728b40 <_RNvMsi_NtNtNtCscdodAO9FK5_5alloc11collections5btree3mapINtB5_8BTreeMapyNtNtB7_7set_val9SetValZSTE6insertCs6gaF1xUz9Bf_4gpui>
  5ac90c:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  5ac911:	c6 80 5b 09 00 00 01 	movb   $0x1,0x95b(%rax)
  5ac918:	c6 44 24 08 01       	movb   $0x1,0x8(%rsp)
  5ac91d:	48 83 fb ff          	cmp    $0xffffffffffffffff,%rbx
  5ac921:	0f 85 64 ff ff ff    	jne    5ac88b <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x285b>
  5ac927:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  5ac92c:	48 ff 80 00 09 00 00 	incq   0x900(%rax)
  5ac933:	48 c7 44 24 70 fe ff 	movq   $0xfffffffffffffffe,0x70(%rsp)
  5ac93a:	ff ff 
  5ac93c:	48 83 bc 24 b0 03 00 	cmpq   $0xfffffffffffffffe,0x3b0(%rsp)
  5ac943:	00 fe 
  5ac945:	0f 85 82 00 00 00    	jne    5ac9cd <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x299d>
  5ac94b:	e9 6a 04 00 00       	jmp    5acdba <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2d8a>
  5ac950:	48 8b 84 24 b0 00 00 	mov    0xb0(%rsp),%rax
  5ac957:	00 
  5ac958:	48 8d bc 24 00 03 00 	lea    0x300(%rsp),%rdi
  5ac95f:	00 
  5ac960:	48 8b b4 24 58 02 00 	mov    0x258(%rsp),%rsi
  5ac967:	00 
  5ac968:	ff 50 28             	call   *0x28(%rax)
  5ac96b:	48 8b 84 24 00 03 00 	mov    0x300(%rsp),%rax
  5ac972:	00 
  5ac973:	48 89 44 24 70       	mov    %rax,0x70(%rsp)
  5ac978:	48 8b 84 24 08 03 00 	mov    0x308(%rsp),%rax
  5ac97f:	00 
  5ac980:	48 89 84 24 58 02 00 	mov    %rax,0x258(%rsp)
  5ac987:	00 
  5ac988:	48 8b 9c 24 10 03 00 	mov    0x310(%rsp),%rbx
  5ac98f:	00 
  5ac990:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  5ac995:	48 ff 80 00 09 00 00 	incq   0x900(%rax)
  5ac99c:	4c 8b ac 24 b0 03 00 	mov    0x3b0(%rsp),%r13
  5ac9a3:	00 
  5ac9a4:	49 83 fd fe          	cmp    $0xfffffffffffffffe,%r13
  5ac9a8:	75 16                	jne    5ac9c0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2990>
  5ac9aa:	48 83 7c 24 70 fe    	cmpq   $0xfffffffffffffffe,0x70(%rsp)
  5ac9b0:	75 67                	jne    5aca19 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x29e9>
  5ac9b2:	48 c7 44 24 70 fe ff 	movq   $0xfffffffffffffffe,0x70(%rsp)
  5ac9b9:	ff ff 
  5ac9bb:	e9 fa 03 00 00       	jmp    5acdba <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2d8a>
  5ac9c0:	48 83 7c 24 70 fe    	cmpq   $0xfffffffffffffffe,0x70(%rsp)
  5ac9c6:	75 21                	jne    5ac9e9 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x29b9>
  5ac9c8:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  5ac9cd:	c6 80 58 09 00 00 01 	movb   $0x1,0x958(%rax)
  5ac9d4:	48 c7 c3 fe ff ff ff 	mov    $0xfffffffffffffffe,%rbx
  5ac9db:	48 c7 44 24 70 fe ff 	movq   $0xfffffffffffffffe,0x70(%rsp)
  5ac9e2:	ff ff 
  5ac9e4:	e9 62 03 00 00       	jmp    5acd4b <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2d1b>
  5ac9e9:	48 8b bc 24 f0 03 00 	mov    0x3f0(%rsp),%rdi
  5ac9f0:	00 
  5ac9f1:	48 8b 07             	mov    (%rdi),%rax
  5ac9f4:	48 d1 e8             	shr    $1,%rax
  5ac9f7:	48 39 d8             	cmp    %rbx,%rax
  5ac9fa:	75 1d                	jne    5aca19 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x29e9>
  5ac9fc:	48 83 c7 10          	add    $0x10,%rdi
  5aca00:	48 8b b4 24 58 02 00 	mov    0x258(%rsp),%rsi
  5aca07:	00 
  5aca08:	48 89 da             	mov    %rbx,%rdx
  5aca0b:	ff 15 2f d4 53 00    	call   *0x53d42f(%rip)        # ae9e40 <bcmp@GLIBC_2.2.5>
  5aca11:	85 c0                	test   %eax,%eax
  5aca13:	0f 84 a1 03 00 00    	je     5acdba <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2d8a>
  5aca19:	49 83 fd fe          	cmp    $0xfffffffffffffffe,%r13
  5aca1d:	0f 94 c0             	sete   %al
  5aca20:	48 8b 4c 24 10       	mov    0x10(%rsp),%rcx
  5aca25:	08 81 58 09 00 00    	or     %al,0x958(%rcx)
  5aca2b:	48 8b b4 24 98 02 00 	mov    0x298(%rsp),%rsi
  5aca32:	00 
  5aca33:	49 39 f6             	cmp    %rsi,%r14
  5aca36:	0f 83 01 30 00 00    	jae    5afa3d <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5a0d>
  5aca3c:	48 8b ac 24 90 02 00 	mov    0x290(%rsp),%rbp
  5aca43:	00 
  5aca44:	4a 8b 44 f5 00       	mov    0x0(%rbp,%r14,8),%rax
  5aca49:	48 85 c0             	test   %rax,%rax
  5aca4c:	74 71                	je     5acabf <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2a8f>
  5aca4e:	48 8b 8c 24 58 04 00 	mov    0x458(%rsp),%rcx
  5aca55:	00 
  5aca56:	48 85 c9             	test   %rcx,%rcx
  5aca59:	74 64                	je     5acabf <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2a8f>
  5aca5b:	48 8b 94 24 60 04 00 	mov    0x460(%rsp),%rdx
  5aca62:	00 
  5aca63:	0f b7 b9 ba 00 00 00 	movzwl 0xba(%rcx),%edi
  5aca6a:	41 89 f8             	mov    %edi,%r8d
  5aca6d:	41 c1 e0 03          	shl    $0x3,%r8d
  5aca71:	48 c7 c6 ff ff ff ff 	mov    $0xffffffffffffffff,%rsi
  5aca78:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  5aca7f:	00 
  5aca80:	4d 85 c0             	test   %r8,%r8
  5aca83:	74 27                	je     5acaac <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2a7c>
  5aca85:	48 3b 44 f1 10       	cmp    0x10(%rcx,%rsi,8),%rax
  5aca8a:	41 0f 97 c1          	seta   %r9b
  5aca8e:	41 80 d9 00          	sbb    $0x0,%r9b
  5aca92:	48 ff c6             	inc    %rsi
  5aca95:	49 83 c0 f8          	add    $0xfffffffffffffff8,%r8
  5aca99:	41 80 f9 01          	cmp    $0x1,%r9b
  5aca9d:	74 e1                	je     5aca80 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2a50>
  5aca9f:	41 0f b6 f9          	movzbl %r9b,%edi
  5acaa3:	85 ff                	test   %edi,%edi
  5acaa5:	75 08                	jne    5acaaf <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2a7f>
  5acaa7:	e9 ba 01 00 00       	jmp    5acc66 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2c36>
  5acaac:	48 89 fe             	mov    %rdi,%rsi
  5acaaf:	48 83 ea 01          	sub    $0x1,%rdx
  5acab3:	72 0a                	jb     5acabf <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2a8f>
  5acab5:	48 8b 8c f1 c0 00 00 	mov    0xc0(%rcx,%rsi,8),%rcx
  5acabc:	00 
  5acabd:	eb a4                	jmp    5aca63 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2a33>
  5acabf:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  5acac4:	f3 0f 6f 80 08 09 00 	movdqu 0x908(%rax),%xmm0
  5acacb:	00 
  5acacc:	66 48 0f 6e cb       	movq   %rbx,%xmm1
  5acad1:	66 0f 6f 15 27 03 ac 	movdqa -0x53fcd9(%rip),%xmm2        # 6ce00 <anon.5f884de6e78125e25881320d811d32df.391.llvm.17146438997930651657+0xd80>
  5acad8:	ff 
  5acad9:	66 0f 6c d1          	punpcklqdq %xmm1,%xmm2
  5acadd:	66 0f d4 d0          	paddq  %xmm0,%xmm2
  5acae1:	f3 0f 7f 90 08 09 00 	movdqu %xmm2,0x908(%rax)
  5acae8:	00 
  5acae9:	4c 8d 2d d0 0c ac ff 	lea    -0x53f330(%rip),%r13        # 6d7c0 <anon.1f6b7bab1fc61e0fcd36456038a862fb.80.llvm.5148459089407822190>
  5acaf0:	48 85 db             	test   %rbx,%rbx
  5acaf3:	74 47                	je     5acb3c <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2b0c>
  5acaf5:	48 8d bc 24 00 03 00 	lea    0x300(%rsp),%rdi
  5acafc:	00 
  5acafd:	48 89 de             	mov    %rbx,%rsi
  5acb00:	31 d2                	xor    %edx,%edx
  5acb02:	31 c9                	xor    %ecx,%ecx
  5acb04:	ff 15 3e d3 53 00    	call   *0x53d33e(%rip)        # ae9e48 <_DYNAMIC+0x298>
  5acb0a:	48 8b bc 24 00 03 00 	mov    0x300(%rsp),%rdi
  5acb11:	00 
  5acb12:	48 83 ff ff          	cmp    $0xffffffffffffffff,%rdi
  5acb16:	0f 85 c7 2f 00 00    	jne    5afae3 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5ab3>
  5acb1c:	48 8b 84 24 08 03 00 	mov    0x308(%rsp),%rax
  5acb23:	00 
  5acb24:	49 89 c5             	mov    %rax,%r13
  5acb27:	48 8d 78 10          	lea    0x10(%rax),%rdi
  5acb2b:	48 8b b4 24 58 02 00 	mov    0x258(%rsp),%rsi
  5acb32:	00 
  5acb33:	48 89 da             	mov    %rbx,%rdx
  5acb36:	ff 15 14 d3 53 00    	call   *0x53d314(%rip)        # ae9e50 <memcpy@GLIBC_2.14>
  5acb3c:	4a 8b 44 f5 00       	mov    0x0(%rbp,%r14,8),%rax
  5acb41:	48 85 c0             	test   %rax,%rax
  5acb44:	0f 84 df 01 00 00    	je     5acd29 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2cf9>
  5acb4a:	41 f6 45 00 01       	testb  $0x1,0x0(%r13)
  5acb4f:	75 34                	jne    5acb85 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2b55>
  5acb51:	4c 89 ee             	mov    %r13,%rsi
  5acb54:	49 8b 4d 08          	mov    0x8(%r13),%rcx
  5acb58:	f6 c1 01             	test   $0x1,%cl
  5acb5b:	75 28                	jne    5acb85 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2b55>
  5acb5d:	b9 02 00 00 00       	mov    $0x2,%ecx
  5acb62:	f0 48 0f c1 4e 08    	lock xadd %rcx,0x8(%rsi)
  5acb68:	48 ba 01 00 00 00 00 	movabs $0x8000000000000001,%rdx
  5acb6f:	00 00 80 
  5acb72:	48 21 d1             	and    %rdx,%rcx
  5acb75:	48 3b 8c 24 50 02 00 	cmp    0x250(%rsp),%rcx
  5acb7c:	00 
  5acb7d:	75 06                	jne    5acb85 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2b55>
  5acb7f:	f0 48 83 4e 08 01    	lock orq $0x1,0x8(%rsi)
  5acb85:	48 8b 8c 24 58 04 00 	mov    0x458(%rsp),%rcx
  5acb8c:	00 
  5acb8d:	48 85 c9             	test   %rcx,%rcx
  5acb90:	0f 84 45 01 00 00    	je     5accdb <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2cab>
  5acb96:	48 8b 94 24 60 04 00 	mov    0x460(%rsp),%rdx
  5acb9d:	00 
  5acb9e:	0f b7 b9 ba 00 00 00 	movzwl 0xba(%rcx),%edi
  5acba5:	41 89 f8             	mov    %edi,%r8d
  5acba8:	41 c1 e0 03          	shl    $0x3,%r8d
  5acbac:	48 c7 c6 ff ff ff ff 	mov    $0xffffffffffffffff,%rsi
  5acbb3:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  5acbba:	84 00 00 00 00 00 
  5acbc0:	4d 85 c0             	test   %r8,%r8
  5acbc3:	74 27                	je     5acbec <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2bbc>
  5acbc5:	48 3b 44 f1 10       	cmp    0x10(%rcx,%rsi,8),%rax
  5acbca:	41 0f 97 c1          	seta   %r9b
  5acbce:	41 80 d9 00          	sbb    $0x0,%r9b
  5acbd2:	48 ff c6             	inc    %rsi
  5acbd5:	49 83 c0 f8          	add    $0xfffffffffffffff8,%r8
  5acbd9:	41 80 f9 01          	cmp    $0x1,%r9b
  5acbdd:	74 e1                	je     5acbc0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2b90>
  5acbdf:	41 0f b6 f9          	movzbl %r9b,%edi
  5acbe3:	85 ff                	test   %edi,%edi
  5acbe5:	75 08                	jne    5acbef <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2bbf>
  5acbe7:	e9 c1 00 00 00       	jmp    5accad <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2c7d>
  5acbec:	48 89 fe             	mov    %rdi,%rsi
  5acbef:	48 83 ea 01          	sub    $0x1,%rdx
  5acbf3:	0f 82 e4 00 00 00    	jb     5accdd <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2cad>
  5acbf9:	48 8b 8c f1 c0 00 00 	mov    0xc0(%rcx,%rsi,8),%rcx
  5acc00:	00 
  5acc01:	eb 9b                	jmp    5acb9e <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2b6e>
  5acc03:	0f 85 1b 2c 00 00    	jne    5af824 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x57f4>
  5acc09:	c1 ef 03             	shr    $0x3,%edi
  5acc0c:	8d 57 ff             	lea    -0x1(%rdi),%edx
  5acc0f:	48 c7 84 24 b0 03 00 	movq   $0xfffffffffffffffe,0x3b0(%rsp)
  5acc16:	00 fe ff ff ff 
  5acc1b:	b0 02                	mov    $0x2,%al
  5acc1d:	83 ef 01             	sub    $0x1,%edi
  5acc20:	0f 82 5d fb ff ff    	jb     5ac783 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2753>
  5acc26:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  5acc2b:	48 8b 88 a8 07 00 00 	mov    0x7a8(%rax),%rcx
  5acc32:	48 85 c9             	test   %rcx,%rcx
  5acc35:	0f 84 1c 2c 00 00    	je     5af857 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5827>
  5acc3b:	d1 ea                	shr    $1,%edx
  5acc3d:	89 d0                	mov    %edx,%eax
  5acc3f:	48 8b 71 10          	mov    0x10(%rcx),%rsi
  5acc43:	48 39 c6             	cmp    %rax,%rsi
  5acc46:	0f 86 e5 2e 00 00    	jbe    5afb31 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5b01>
  5acc4c:	48 8b 49 08          	mov    0x8(%rcx),%rcx
  5acc50:	48 8b 04 c1          	mov    (%rcx,%rax,8),%rax
  5acc54:	48 8b 48 28          	mov    0x28(%rax),%rcx
  5acc58:	40 f6 d7             	not    %dil
  5acc5b:	40 80 e7 01          	and    $0x1,%dil
  5acc5f:	89 f8                	mov    %edi,%eax
  5acc61:	e9 1d fb ff ff       	jmp    5ac783 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2753>
  5acc66:	48 8b 54 f1 60       	mov    0x60(%rcx,%rsi,8),%rdx
  5acc6b:	f6 02 01             	testb  $0x1,(%rdx)
  5acc6e:	75 38                	jne    5acca8 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2c78>
  5acc70:	48 8b 42 08          	mov    0x8(%rdx),%rax
  5acc74:	a8 01                	test   $0x1,%al
  5acc76:	75 30                	jne    5acca8 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2c78>
  5acc78:	b8 02 00 00 00       	mov    $0x2,%eax
  5acc7d:	f0 48 0f c1 42 08    	lock xadd %rax,0x8(%rdx)
  5acc83:	48 b9 01 00 00 00 00 	movabs $0x8000000000000001,%rcx
  5acc8a:	00 00 80 
  5acc8d:	48 21 c8             	and    %rcx,%rax
  5acc90:	48 3b 84 24 50 02 00 	cmp    0x250(%rsp),%rax
  5acc97:	00 
  5acc98:	75 0e                	jne    5acca8 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2c78>
  5acc9a:	49 89 d5             	mov    %rdx,%r13
  5acc9d:	f0 48 83 4a 08 01    	lock orq $0x1,0x8(%rdx)
  5acca3:	e9 81 00 00 00       	jmp    5acd29 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2cf9>
  5acca8:	49 89 d5             	mov    %rdx,%r13
  5accab:	eb 7c                	jmp    5acd29 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2cf9>
  5accad:	48 8b 7c f1 60       	mov    0x60(%rcx,%rsi,8),%rdi
  5accb2:	4c 89 6c f1 60       	mov    %r13,0x60(%rcx,%rsi,8)
  5accb7:	f6 07 01             	testb  $0x1,(%rdi)
  5accba:	75 6d                	jne    5acd29 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2cf9>
  5accbc:	48 8b 47 08          	mov    0x8(%rdi),%rax
  5accc0:	a8 01                	test   $0x1,%al
  5accc2:	75 65                	jne    5acd29 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2cf9>
  5accc4:	48 8d 47 08          	lea    0x8(%rdi),%rax
  5accc8:	f0 48 83 28 02       	lock subq $0x2,(%rax)
  5acccd:	75 5a                	jne    5acd29 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2cf9>
  5acccf:	48 8b 47 08          	mov    0x8(%rdi),%rax
  5accd3:	ff 15 7f d1 53 00    	call   *0x53d17f(%rip)        # ae9e58 <_DYNAMIC+0x2a8>
  5accd9:	eb 4e                	jmp    5acd29 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2cf9>
  5accdb:	31 c9                	xor    %ecx,%ecx
  5accdd:	48 89 84 24 00 03 00 	mov    %rax,0x300(%rsp)
  5acce4:	00 
  5acce5:	48 8d 84 24 58 04 00 	lea    0x458(%rsp),%rax
  5accec:	00 
  5acced:	48 89 84 24 08 03 00 	mov    %rax,0x308(%rsp)
  5accf4:	00 
  5accf5:	48 89 8c 24 10 03 00 	mov    %rcx,0x310(%rsp)
  5accfc:	00 
  5accfd:	48 c7 84 24 18 03 00 	movq   $0x0,0x318(%rsp)
  5acd04:	00 00 00 00 00 
  5acd09:	48 89 b4 24 20 03 00 	mov    %rsi,0x320(%rsp)
  5acd10:	00 
  5acd11:	48 8d bc 24 90 01 00 	lea    0x190(%rsp),%rdi
  5acd18:	00 
  5acd19:	48 8d b4 24 00 03 00 	lea    0x300(%rsp),%rsi
  5acd20:	00 
  5acd21:	4c 89 ea             	mov    %r13,%rdx
  5acd24:	e8 47 b9 1c 00       	call   778670 <_RNvMs4_NtNtNtNtCscdodAO9FK5_5alloc11collections5btree3map5entryINtB5_11VacantEntryNtNtCs6gaF1xUz9Bf_4gpui6source7FieldIdNtNtB1m_11shared_text10SharedTextE12insert_entryB1m_>
  5acd29:	4a 8b 44 f5 00       	mov    0x0(%rbp,%r14,8),%rax
  5acd2e:	48 89 84 24 90 05 00 	mov    %rax,0x590(%rsp)
  5acd35:	00 
  5acd36:	48 c7 c3 ff ff ff ff 	mov    $0xffffffffffffffff,%rbx
  5acd3d:	48 83 bc 24 b0 03 00 	cmpq   $0xfffffffffffffffe,0x3b0(%rsp)
  5acd44:	00 fe 
  5acd46:	4c 89 ed             	mov    %r13,%rbp
  5acd49:	74 31                	je     5acd7c <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2d4c>
  5acd4b:	48 8b bc 24 f0 03 00 	mov    0x3f0(%rsp),%rdi
  5acd52:	00 
  5acd53:	f6 07 01             	testb  $0x1,(%rdi)
  5acd56:	75 17                	jne    5acd6f <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2d3f>
  5acd58:	48 8b 47 08          	mov    0x8(%rdi),%rax
  5acd5c:	a8 01                	test   $0x1,%al
  5acd5e:	75 0f                	jne    5acd6f <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2d3f>
  5acd60:	48 8d 47 08          	lea    0x8(%rdi),%rax
  5acd64:	f0 48 83 28 02       	lock subq $0x2,(%rax)
  5acd69:	0f 84 fc 05 00 00    	je     5ad36b <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x333b>
  5acd6f:	48 8d bc 24 b0 03 00 	lea    0x3b0(%rsp),%rdi
  5acd76:	00 
  5acd77:	e8 94 c9 f7 ff       	call   529710 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtB4_6option6OptionNtNtCs6gaF1xUz9Bf_4gpui7runtime6ShapedEEB11_.llvm.18178969024155037896>
  5acd7c:	48 89 9c 24 b0 03 00 	mov    %rbx,0x3b0(%rsp)
  5acd83:	00 
  5acd84:	48 89 ac 24 f0 03 00 	mov    %rbp,0x3f0(%rsp)
  5acd8b:	00 
  5acd8c:	48 8b 84 24 90 05 00 	mov    0x590(%rsp),%rax
  5acd93:	00 
  5acd94:	48 89 84 24 f8 03 00 	mov    %rax,0x3f8(%rsp)
  5acd9b:	00 
  5acd9c:	48 8b 7c 24 60       	mov    0x60(%rsp),%rdi
  5acda1:	4c 89 fe             	mov    %r15,%rsi
  5acda4:	e8 97 bd 17 00       	call   728b40 <_RNvMsi_NtNtNtCscdodAO9FK5_5alloc11collections5btree3mapINtB5_8BTreeMapyNtNtB7_7set_val9SetValZSTE6insertCs6gaF1xUz9Bf_4gpui>
  5acda9:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  5acdae:	c6 80 5b 09 00 00 01 	movb   $0x1,0x95b(%rax)
  5acdb5:	c6 44 24 08 01       	movb   $0x1,0x8(%rsp)
  5acdba:	48 8d bc 24 48 07 00 	lea    0x748(%rsp),%rdi
  5acdc1:	00 
  5acdc2:	48 8b b4 24 98 05 00 	mov    0x598(%rsp),%rsi
  5acdc9:	00 
  5acdca:	4c 89 fa             	mov    %r15,%rdx
  5acdcd:	48 8d 8c 24 c0 00 00 	lea    0xc0(%rsp),%rcx
  5acdd4:	00 
  5acdd5:	e8 76 b2 17 00       	call   728050 <_RNvMs5_NtCs6gaF1xUz9Bf_4gpui8propertyNtB5_9Overrides7resolve>
  5acdda:	48 8d bc 24 50 06 00 	lea    0x650(%rsp),%rdi
  5acde1:	00 
  5acde2:	48 8d b4 24 48 07 00 	lea    0x748(%rsp),%rsi
  5acde9:	00 
  5acdea:	e8 f1 16 0b 00       	call   65e4e0 <_RNvXse_NtCs6gaF1xUz9Bf_4gpui5styleNtB5_5StyleNtNtCs4NRVxsYgnAr_4core3cmp9PartialEq2eq>
  5acdef:	84 c0                	test   %al,%al
  5acdf1:	75 11                	jne    5ace04 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2dd4>
  5acdf3:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  5acdf8:	c6 80 5b 09 00 00 01 	movb   $0x1,0x95b(%rax)
  5acdff:	c6 44 24 08 01       	movb   $0x1,0x8(%rsp)
  5ace04:	0f b6 84 24 48 07 00 	movzbl 0x748(%rsp),%eax
  5ace0b:	00 
  5ace0c:	83 bc 24 50 06 00 00 	cmpl   $0x1,0x650(%rsp)
  5ace13:	01 
  5ace14:	75 27                	jne    5ace3d <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2e0d>
  5ace16:	84 c0                	test   %al,%al
  5ace18:	0f 84 b2 00 00 00    	je     5aced0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2ea0>
  5ace1e:	f3 0f 10 84 24 54 06 	movss  0x654(%rsp),%xmm0
  5ace25:	00 00 
  5ace27:	0f 2e 84 24 4c 07 00 	ucomiss 0x74c(%rsp),%xmm0
  5ace2e:	00 
  5ace2f:	0f 85 9b 00 00 00    	jne    5aced0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2ea0>
  5ace35:	0f 8a 95 00 00 00    	jp     5aced0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2ea0>
  5ace3b:	eb 08                	jmp    5ace45 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2e15>
  5ace3d:	84 c0                	test   %al,%al
  5ace3f:	0f 85 8b 00 00 00    	jne    5aced0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2ea0>
  5ace45:	0f b6 84 24 50 07 00 	movzbl 0x750(%rsp),%eax
  5ace4c:	00 
  5ace4d:	83 bc 24 58 06 00 00 	cmpl   $0x1,0x658(%rsp)
  5ace54:	01 
  5ace55:	75 1b                	jne    5ace72 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2e42>
  5ace57:	84 c0                	test   %al,%al
  5ace59:	74 75                	je     5aced0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2ea0>
  5ace5b:	f3 0f 10 84 24 5c 06 	movss  0x65c(%rsp),%xmm0
  5ace62:	00 00 
  5ace64:	0f 2e 84 24 54 07 00 	ucomiss 0x754(%rsp),%xmm0
  5ace6b:	00 
  5ace6c:	75 62                	jne    5aced0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2ea0>
  5ace6e:	7a 60                	jp     5aced0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2ea0>
  5ace70:	eb 04                	jmp    5ace76 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2e46>
  5ace72:	84 c0                	test   %al,%al
  5ace74:	75 5a                	jne    5aced0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2ea0>
  5ace76:	f3 0f 10 84 24 60 06 	movss  0x660(%rsp),%xmm0
  5ace7d:	00 00 
  5ace7f:	0f 2e 84 24 58 07 00 	ucomiss 0x758(%rsp),%xmm0
  5ace86:	00 
  5ace87:	75 47                	jne    5aced0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2ea0>
  5ace89:	7a 45                	jp     5aced0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2ea0>
  5ace8b:	f3 0f 10 84 24 64 06 	movss  0x664(%rsp),%xmm0
  5ace92:	00 00 
  5ace94:	0f 2e 84 24 5c 07 00 	ucomiss 0x75c(%rsp),%xmm0
  5ace9b:	00 
  5ace9c:	75 32                	jne    5aced0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2ea0>
  5ace9e:	7a 30                	jp     5aced0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2ea0>
  5acea0:	f3 0f 10 84 24 68 06 	movss  0x668(%rsp),%xmm0
  5acea7:	00 00 
  5acea9:	f3 0f 10 8c 24 60 07 	movss  0x760(%rsp),%xmm1
  5aceb0:	00 00 
  5aceb2:	0f 2e c1             	ucomiss %xmm1,%xmm0
  5aceb5:	75 19                	jne    5aced0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2ea0>
  5aceb7:	7a 17                	jp     5aced0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2ea0>
  5aceb9:	0f b6 84 24 a4 06 00 	movzbl 0x6a4(%rsp),%eax
  5acec0:	00 
  5acec1:	3a 84 24 9c 07 00 00 	cmp    0x79c(%rsp),%al
  5acec8:	74 25                	je     5aceef <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2ebf>
  5aceca:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
  5aced0:	48 8b 7c 24 60       	mov    0x60(%rsp),%rdi
  5aced5:	4c 89 fe             	mov    %r15,%rsi
  5aced8:	e8 63 bc 17 00       	call   728b40 <_RNvMsi_NtNtNtCscdodAO9FK5_5alloc11collections5btree3mapINtB5_8BTreeMapyNtNtB7_7set_val9SetValZSTE6insertCs6gaF1xUz9Bf_4gpui>
  5acedd:	f3 0f 10 84 24 68 06 	movss  0x668(%rsp),%xmm0
  5acee4:	00 00 
  5acee6:	f3 0f 10 8c 24 60 07 	movss  0x760(%rsp),%xmm1
  5aceed:	00 00 
  5aceef:	0f 2e c1             	ucomiss %xmm1,%xmm0
  5acef2:	75 02                	jne    5acef6 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2ec6>
  5acef4:	7b 24                	jnp    5acf1a <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2eea>
  5acef6:	48 83 bc 24 b0 03 00 	cmpq   $0xfffffffffffffffe,0x3b0(%rsp)
  5acefd:	00 fe 
  5aceff:	74 19                	je     5acf1a <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2eea>
  5acf01:	48 8d bc 24 b0 03 00 	lea    0x3b0(%rsp),%rdi
  5acf08:	00 
  5acf09:	e8 02 c8 f7 ff       	call   529710 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtB4_6option6OptionNtNtCs6gaF1xUz9Bf_4gpui7runtime6ShapedEEB11_.llvm.18178969024155037896>
  5acf0e:	48 c7 84 24 b0 03 00 	movq   $0xffffffffffffffff,0x3b0(%rsp)
  5acf15:	00 ff ff ff ff 
  5acf1a:	48 83 7c 24 40 00    	cmpq   $0x0,0x40(%rsp)
  5acf20:	0f 95 c0             	setne  %al
  5acf23:	48 8b 9c 24 18 01 00 	mov    0x118(%rsp),%rbx
  5acf2a:	00 
  5acf2b:	48 85 db             	test   %rbx,%rbx
  5acf2e:	0f 95 c1             	setne  %cl
  5acf31:	30 c1                	xor    %al,%cl
  5acf33:	74 11                	je     5acf46 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2f16>
  5acf35:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  5acf3a:	c6 80 5b 09 00 00 01 	movb   $0x1,0x95b(%rax)
  5acf41:	c6 44 24 08 01       	movb   $0x1,0x8(%rsp)
  5acf46:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
  5acf4c:	80 7c 24 50 00       	cmpb   $0x0,0x50(%rsp)
  5acf51:	74 13                	je     5acf66 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2f36>
  5acf53:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
  5acf58:	41 89 c5             	mov    %eax,%r13d
  5acf5b:	3d a0 86 01 00       	cmp    $0x186a0,%eax
  5acf60:	0f 83 00 28 00 00    	jae    5af766 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5736>
  5acf66:	48 8d bc 24 08 07 00 	lea    0x708(%rsp),%rdi
  5acf6d:	00 
  5acf6e:	48 8d b4 24 48 07 00 	lea    0x748(%rsp),%rsi
  5acf75:	00 
  5acf76:	e8 e5 b4 f9 ff       	call   548460 <_RNvMs_NtNtCs6gaF1xUz9Bf_4gpui7runtime6stylesNtB4_7Builder4push>
  5acf7b:	48 8b 84 24 20 01 00 	mov    0x120(%rsp),%rax
  5acf82:	00 
  5acf83:	48 89 44 24 38       	mov    %rax,0x38(%rsp)
  5acf88:	48 83 7c 24 40 00    	cmpq   $0x0,0x40(%rsp)
  5acf8e:	74 36                	je     5acfc6 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2f96>
  5acf90:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
  5acf95:	48 8b 00             	mov    (%rax),%rax
  5acf98:	48 85 c0             	test   %rax,%rax
  5acf9b:	74 07                	je     5acfa4 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2f74>
  5acf9d:	48 8b 7c 24 40       	mov    0x40(%rsp),%rdi
  5acfa2:	ff d0                	call   *%rax
  5acfa4:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
  5acfa9:	48 8b 70 08          	mov    0x8(%rax),%rsi
  5acfad:	48 85 f6             	test   %rsi,%rsi
  5acfb0:	74 14                	je     5acfc6 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2f96>
  5acfb2:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
  5acfb7:	48 8b 50 10          	mov    0x10(%rax),%rdx
  5acfbb:	48 8b 7c 24 40       	mov    0x40(%rsp),%rdi
  5acfc0:	ff 15 32 ce 53 00    	call   *0x53ce32(%rip)        # ae9df8 <_DYNAMIC+0x248>
  5acfc6:	48 89 ac 24 38 04 00 	mov    %rbp,0x438(%rsp)
  5acfcd:	00 
  5acfce:	48 83 bc 24 b0 03 00 	cmpq   $0xfffffffffffffffe,0x3b0(%rsp)
  5acfd5:	00 fe 
  5acfd7:	0f 94 c0             	sete   %al
  5acfda:	89 44 24 18          	mov    %eax,0x18(%rsp)
  5acfde:	bd ff ff ff ff       	mov    $0xffffffff,%ebp
  5acfe3:	0f 84 59 01 00 00    	je     5ad142 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x3112>
  5acfe9:	0f 28 84 24 f0 03 00 	movaps 0x3f0(%rsp),%xmm0
  5acff0:	00 
  5acff1:	0f 29 84 24 d0 01 00 	movaps %xmm0,0x1d0(%rsp)
  5acff8:	00 
  5acff9:	0f 28 84 24 b0 03 00 	movaps 0x3b0(%rsp),%xmm0
  5ad000:	00 
  5ad001:	0f 28 8c 24 c0 03 00 	movaps 0x3c0(%rsp),%xmm1
  5ad008:	00 
  5ad009:	0f 28 94 24 d0 03 00 	movaps 0x3d0(%rsp),%xmm2
  5ad010:	00 
  5ad011:	0f 28 9c 24 e0 03 00 	movaps 0x3e0(%rsp),%xmm3
  5ad018:	00 
  5ad019:	0f 29 9c 24 c0 01 00 	movaps %xmm3,0x1c0(%rsp)
  5ad020:	00 
  5ad021:	0f 29 94 24 b0 01 00 	movaps %xmm2,0x1b0(%rsp)
  5ad028:	00 
  5ad029:	0f 29 8c 24 a0 01 00 	movaps %xmm1,0x1a0(%rsp)
  5ad030:	00 
  5ad031:	0f 29 84 24 90 01 00 	movaps %xmm0,0x190(%rsp)
  5ad038:	00 
  5ad039:	48 8b b4 24 98 02 00 	mov    0x298(%rsp),%rsi
  5ad040:	00 
  5ad041:	49 39 f6             	cmp    %rsi,%r14
  5ad044:	0f 83 88 29 00 00    	jae    5af9d2 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x59a2>
  5ad04a:	48 8b 84 24 90 02 00 	mov    0x290(%rsp),%rax
  5ad051:	00 
  5ad052:	4a 8b 04 f0          	mov    (%rax,%r14,8),%rax
  5ad056:	48 89 84 24 d8 01 00 	mov    %rax,0x1d8(%rsp)
  5ad05d:	00 
  5ad05e:	48 8b ac 24 38 05 00 	mov    0x538(%rsp),%rbp
  5ad065:	00 
  5ad066:	48 8b 84 24 d0 01 00 	mov    0x1d0(%rsp),%rax
  5ad06d:	00 
  5ad06e:	48 89 84 24 40 03 00 	mov    %rax,0x340(%rsp)
  5ad075:	00 
  5ad076:	48 8b 84 24 d8 01 00 	mov    0x1d8(%rsp),%rax
  5ad07d:	00 
  5ad07e:	48 89 84 24 48 03 00 	mov    %rax,0x348(%rsp)
  5ad085:	00 
  5ad086:	0f 28 84 24 90 01 00 	movaps 0x190(%rsp),%xmm0
  5ad08d:	00 
  5ad08e:	0f 28 8c 24 a0 01 00 	movaps 0x1a0(%rsp),%xmm1
  5ad095:	00 
  5ad096:	0f 28 94 24 b0 01 00 	movaps 0x1b0(%rsp),%xmm2
  5ad09d:	00 
  5ad09e:	0f 28 9c 24 c0 01 00 	movaps 0x1c0(%rsp),%xmm3
  5ad0a5:	00 
  5ad0a6:	0f 29 9c 24 30 03 00 	movaps %xmm3,0x330(%rsp)
  5ad0ad:	00 
  5ad0ae:	0f 29 94 24 20 03 00 	movaps %xmm2,0x320(%rsp)
  5ad0b5:	00 
  5ad0b6:	0f 29 8c 24 10 03 00 	movaps %xmm1,0x310(%rsp)
  5ad0bd:	00 
  5ad0be:	0f 29 84 24 00 03 00 	movaps %xmm0,0x300(%rsp)
  5ad0c5:	00 
  5ad0c6:	48 3b ac 24 28 05 00 	cmp    0x528(%rsp),%rbp
  5ad0cd:	00 
  5ad0ce:	75 0d                	jne    5ad0dd <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x30ad>
  5ad0d0:	48 8d bc 24 28 05 00 	lea    0x528(%rsp),%rdi
  5ad0d7:	00 
  5ad0d8:	e8 d3 03 22 00       	call   7cd4b0 <_RNvMs3_NtCscdodAO9FK5_5alloc7raw_vecINtB5_6RawVecINtNtCs4NRVxsYgnAr_4core6option6OptionNtNtCs6gaF1xUz9Bf_4gpui7runtime8TextSiteEE8grow_oneB1r_>
  5ad0dd:	48 8b 84 24 30 05 00 	mov    0x530(%rsp),%rax
  5ad0e4:	00 
  5ad0e5:	48 8d 0c ad 00 00 00 	lea    0x0(,%rbp,4),%rcx
  5ad0ec:	00 
  5ad0ed:	48 01 e9             	add    %rbp,%rcx
  5ad0f0:	48 c1 e1 04          	shl    $0x4,%rcx
  5ad0f4:	0f 28 84 24 40 03 00 	movaps 0x340(%rsp),%xmm0
  5ad0fb:	00 
  5ad0fc:	0f 11 44 08 40       	movups %xmm0,0x40(%rax,%rcx,1)
  5ad101:	0f 28 84 24 00 03 00 	movaps 0x300(%rsp),%xmm0
  5ad108:	00 
  5ad109:	0f 28 8c 24 10 03 00 	movaps 0x310(%rsp),%xmm1
  5ad110:	00 
  5ad111:	66 0f 6f 94 24 20 03 	movdqa 0x320(%rsp),%xmm2
  5ad118:	00 00 
  5ad11a:	0f 28 9c 24 30 03 00 	movaps 0x330(%rsp),%xmm3
  5ad121:	00 
  5ad122:	0f 11 5c 08 30       	movups %xmm3,0x30(%rax,%rcx,1)
  5ad127:	f3 0f 7f 54 08 20    	movdqu %xmm2,0x20(%rax,%rcx,1)
  5ad12d:	0f 11 4c 08 10       	movups %xmm1,0x10(%rax,%rcx,1)
  5ad132:	0f 11 04 08          	movups %xmm0,(%rax,%rcx,1)
  5ad136:	48 8d 45 01          	lea    0x1(%rbp),%rax
  5ad13a:	48 89 84 24 38 05 00 	mov    %rax,0x538(%rsp)
  5ad141:	00 
  5ad142:	80 bc 24 70 02 00 00 	cmpb   $0x0,0x270(%rsp)
  5ad149:	00 
  5ad14a:	74 44                	je     5ad190 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x3160>
  5ad14c:	83 bc 24 68 02 00 00 	cmpl   $0x7,0x268(%rsp)
  5ad153:	07 
  5ad154:	0f 84 e8 26 00 00    	je     5af842 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5812>
  5ad15a:	83 fd ff             	cmp    $0xffffffff,%ebp
  5ad15d:	74 72                	je     5ad1d1 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x31a1>
  5ad15f:	81 fd 9f 86 01 00    	cmp    $0x1869f,%ebp
  5ad165:	0f 87 7b 26 00 00    	ja     5af7e6 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x57b6>
  5ad16b:	48 8b 84 24 68 02 00 	mov    0x268(%rsp),%rax
  5ad172:	00 
  5ad173:	8d 04 e8             	lea    (%rax,%rbp,8),%eax
  5ad176:	83 c0 08             	add    $0x8,%eax
  5ad179:	48 89 c5             	mov    %rax,%rbp
  5ad17c:	4c 8b b4 24 28 02 00 	mov    0x228(%rsp),%r14
  5ad183:	00 
  5ad184:	4c 3b b4 24 18 02 00 	cmp    0x218(%rsp),%r14
  5ad18b:	00 
  5ad18c:	74 5d                	je     5ad1eb <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x31bb>
  5ad18e:	eb 68                	jmp    5ad1f8 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x31c8>
  5ad190:	48 8b 8c 24 00 02 00 	mov    0x200(%rsp),%rcx
  5ad197:	00 
  5ad198:	81 f9 a0 86 01 00    	cmp    $0x186a0,%ecx
  5ad19e:	0f 83 eb 25 00 00    	jae    5af78f <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x575f>
  5ad1a4:	c1 e1 04             	shl    $0x4,%ecx
  5ad1a7:	0f b6 84 24 60 02 00 	movzbl 0x260(%rsp),%eax
  5ad1ae:	00 
  5ad1af:	f6 d0                	not    %al
  5ad1b1:	0f b6 c0             	movzbl %al,%eax
  5ad1b4:	83 e0 01             	and    $0x1,%eax
  5ad1b7:	8d 2c c1             	lea    (%rcx,%rax,8),%ebp
  5ad1ba:	83 c5 0e             	add    $0xe,%ebp
  5ad1bd:	4c 8b b4 24 28 02 00 	mov    0x228(%rsp),%r14
  5ad1c4:	00 
  5ad1c5:	4c 3b b4 24 18 02 00 	cmp    0x218(%rsp),%r14
  5ad1cc:	00 
  5ad1cd:	74 1c                	je     5ad1eb <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x31bb>
  5ad1cf:	eb 27                	jmp    5ad1f8 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x31c8>
  5ad1d1:	48 8b ac 24 68 02 00 	mov    0x268(%rsp),%rbp
  5ad1d8:	00 
  5ad1d9:	4c 8b b4 24 28 02 00 	mov    0x228(%rsp),%r14
  5ad1e0:	00 
  5ad1e1:	4c 3b b4 24 18 02 00 	cmp    0x218(%rsp),%r14
  5ad1e8:	00 
  5ad1e9:	75 0d                	jne    5ad1f8 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x31c8>
  5ad1eb:	48 8d bc 24 18 02 00 	lea    0x218(%rsp),%rdi
  5ad1f2:	00 
  5ad1f3:	e8 88 07 22 00       	call   7cd980 <_RNvMs3_NtCscdodAO9FK5_5alloc7raw_vecINtB5_6RawVecNtNtCs6gaF1xUz9Bf_4gpui7runtime4NodeE8grow_oneBP_>
  5ad1f8:	48 8b 84 24 20 02 00 	mov    0x220(%rsp),%rax
  5ad1ff:	00 
  5ad200:	4b 8d 0c b6          	lea    (%r14,%r14,4),%rcx
  5ad204:	4c 89 3c c8          	mov    %r15,(%rax,%rcx,8)
  5ad208:	48 89 5c c8 08       	mov    %rbx,0x8(%rax,%rcx,8)
  5ad20d:	48 8b 54 24 38       	mov    0x38(%rsp),%rdx
  5ad212:	48 89 54 c8 10       	mov    %rdx,0x10(%rax,%rcx,8)
  5ad217:	44 89 6c c8 18       	mov    %r13d,0x18(%rax,%rcx,8)
  5ad21c:	48 8b 94 24 80 02 00 	mov    0x280(%rsp),%rdx
  5ad223:	00 
  5ad224:	89 54 c8 1c          	mov    %edx,0x1c(%rax,%rcx,8)
  5ad228:	89 6c c8 20          	mov    %ebp,0x20(%rax,%rcx,8)
  5ad22c:	8b 94 24 90 00 00 00 	mov    0x90(%rsp),%edx
  5ad233:	89 54 c8 24          	mov    %edx,0x24(%rax,%rcx,8)
  5ad237:	49 ff c6             	inc    %r14
  5ad23a:	4c 89 b4 24 28 02 00 	mov    %r14,0x228(%rsp)
  5ad241:	00 
  5ad242:	48 8b 74 24 70       	mov    0x70(%rsp),%rsi
  5ad247:	48 8d 46 ff          	lea    -0x1(%rsi),%rax
  5ad24b:	48 83 f8 fc          	cmp    $0xfffffffffffffffc,%rax
  5ad24f:	77 13                	ja     5ad264 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x3234>
  5ad251:	ba 01 00 00 00       	mov    $0x1,%edx
  5ad256:	48 8b bc 24 58 02 00 	mov    0x258(%rsp),%rdi
  5ad25d:	00 
  5ad25e:	ff 15 94 cb 53 00    	call   *0x53cb94(%rip)        # ae9df8 <_DYNAMIC+0x248>
  5ad264:	48 8b b4 24 a0 00 00 	mov    0xa0(%rsp),%rsi
  5ad26b:	00 
  5ad26c:	48 83 fe ff          	cmp    $0xffffffffffffffff,%rsi
  5ad270:	48 8b ac 24 78 02 00 	mov    0x278(%rsp),%rbp
  5ad277:	00 
  5ad278:	41 bf 01 00 00 00    	mov    $0x1,%r15d
  5ad27e:	4c 8d b4 24 00 03 00 	lea    0x300(%rsp),%r14
  5ad285:	00 
  5ad286:	74 18                	je     5ad2a0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x3270>
  5ad288:	48 85 f6             	test   %rsi,%rsi
  5ad28b:	7e 13                	jle    5ad2a0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x3270>
  5ad28d:	48 8b bc 24 a8 00 00 	mov    0xa8(%rsp),%rdi
  5ad294:	00 
  5ad295:	ba 01 00 00 00       	mov    $0x1,%edx
  5ad29a:	ff 15 58 cb 53 00    	call   *0x53cb58(%rip)        # ae9df8 <_DYNAMIC+0x248>
  5ad2a0:	48 8b 9c 24 28 01 00 	mov    0x128(%rsp),%rbx
  5ad2a7:	00 
  5ad2a8:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  5ad2af:	00 
  5ad2b0:	48 85 db             	test   %rbx,%rbx
  5ad2b3:	0f 84 37 ed ff ff    	je     5abff0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1fc0>
  5ad2b9:	48 89 d8             	mov    %rbx,%rax
  5ad2bc:	48 89 9c 24 00 03 00 	mov    %rbx,0x300(%rsp)
  5ad2c3:	00 
  5ad2c4:	48 8b 5b 10          	mov    0x10(%rbx),%rbx
  5ad2c8:	48 c7 40 10 00 00 00 	movq   $0x0,0x10(%rax)
  5ad2cf:	00 
  5ad2d0:	4c 89 f7             	mov    %r14,%rdi
  5ad2d3:	e8 88 e9 21 00       	call   7cbc60 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtCscdodAO9FK5_5alloc5boxed3BoxNtNtCs6gaF1xUz9Bf_4gpui7element17ComponentBoundaryEEB1d_.llvm.6226793394568926217>
  5ad2d8:	eb d6                	jmp    5ad2b0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x3280>
  5ad2da:	48 8b b4 24 58 05 00 	mov    0x558(%rsp),%rsi
  5ad2e1:	00 
  5ad2e2:	48 39 f0             	cmp    %rsi,%rax
  5ad2e5:	0f 83 a3 28 00 00    	jae    5afb8e <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5b5e>
  5ad2eb:	48 6b c8 58          	imul   $0x58,%rax,%rcx
  5ad2ef:	48 03 8c 24 50 05 00 	add    0x550(%rsp),%rcx
  5ad2f6:	00 
  5ad2f7:	48 8b 41 50          	mov    0x50(%rcx),%rax
  5ad2fb:	48 89 84 24 a0 06 00 	mov    %rax,0x6a0(%rsp)
  5ad302:	00 
  5ad303:	0f 10 41 40          	movups 0x40(%rcx),%xmm0
  5ad307:	0f 29 84 24 90 06 00 	movaps %xmm0,0x690(%rsp)
  5ad30e:	00 
  5ad30f:	f3 0f 6f 01          	movdqu (%rcx),%xmm0
  5ad313:	f3 0f 6f 49 10       	movdqu 0x10(%rcx),%xmm1
  5ad318:	f3 0f 6f 51 20       	movdqu 0x20(%rcx),%xmm2
  5ad31d:	0f 10 59 30          	movups 0x30(%rcx),%xmm3
  5ad321:	0f 29 9c 24 80 06 00 	movaps %xmm3,0x680(%rsp)
  5ad328:	00 
  5ad329:	66 0f 7f 94 24 70 06 	movdqa %xmm2,0x670(%rsp)
  5ad330:	00 00 
  5ad332:	66 0f 7f 8c 24 60 06 	movdqa %xmm1,0x660(%rsp)
  5ad339:	00 00 
  5ad33b:	66 0f 7f 84 24 50 06 	movdqa %xmm0,0x650(%rsp)
  5ad342:	00 00 
  5ad344:	c7 84 24 08 02 00 00 	movl   $0x0,0x208(%rsp)
  5ad34b:	00 00 00 00 
  5ad34f:	48 8b 44 24 58       	mov    0x58(%rsp),%rax
  5ad354:	48 89 44 24 30       	mov    %rax,0x30(%rsp)
  5ad359:	4c 89 7c 24 40       	mov    %r15,0x40(%rsp)
  5ad35e:	4c 8b bc 24 28 04 00 	mov    0x428(%rsp),%r15
  5ad365:	00 
  5ad366:	e9 79 f3 ff ff       	jmp    5ac6e4 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x26b4>
  5ad36b:	48 8b 47 08          	mov    0x8(%rdi),%rax
  5ad36f:	ff 15 e3 ca 53 00    	call   *0x53cae3(%rip)        # ae9e58 <_DYNAMIC+0x2a8>
  5ad375:	e9 f5 f9 ff ff       	jmp    5acd6f <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2d3f>
  5ad37a:	31 c0                	xor    %eax,%eax
  5ad37c:	48 89 84 24 d8 04 00 	mov    %rax,0x4d8(%rsp)
  5ad383:	00 
  5ad384:	40 b5 01             	mov    $0x1,%bpl
  5ad387:	48 8d bc 24 00 04 00 	lea    0x400(%rsp),%rdi
  5ad38e:	00 
  5ad38f:	41 b6 01             	mov    $0x1,%r14b
  5ad392:	e8 79 37 1b 00       	call   760b10 <_RNvXse_NtNtCscdodAO9FK5_5alloc3vec9into_iterINtB5_8IntoIterNtNtCs6gaF1xUz9Bf_4gpui7element9DraftNodeENtNtNtCs4NRVxsYgnAr_4core3ops4drop4Drop4dropBZ_>
  5ad397:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  5ad39c:	48 8d b8 a8 07 00 00 	lea    0x7a8(%rax),%rdi
  5ad3a3:	48 8b 84 24 80 04 00 	mov    0x480(%rsp),%rax
  5ad3aa:	00 
  5ad3ab:	48 89 84 24 b0 00 00 	mov    %rax,0xb0(%rsp)
  5ad3b2:	00 
  5ad3b3:	0f 28 84 24 70 04 00 	movaps 0x470(%rsp),%xmm0
  5ad3ba:	00 
  5ad3bb:	0f 29 84 24 a0 00 00 	movaps %xmm0,0xa0(%rsp)
  5ad3c2:	00 
  5ad3c3:	45 31 f6             	xor    %r14d,%r14d
  5ad3c6:	48 8d b4 24 a0 00 00 	lea    0xa0(%rsp),%rsi
  5ad3cd:	00 
  5ad3ce:	e8 bd 89 1d 00       	call   785d90 <_RNvNtNtCs6gaF1xUz9Bf_4gpui7runtime5image9reconcile>
  5ad3d3:	48 8b b4 24 98 04 00 	mov    0x498(%rsp),%rsi
  5ad3da:	00 
  5ad3db:	48 85 f6             	test   %rsi,%rsi
  5ad3de:	4c 8b 8c 24 30 04 00 	mov    0x430(%rsp),%r9
  5ad3e5:	00 
  5ad3e6:	74 1f                	je     5ad407 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x33d7>
  5ad3e8:	48 8b 8c 24 90 04 00 	mov    0x490(%rsp),%rcx
  5ad3ef:	00 
  5ad3f0:	89 f0                	mov    %esi,%eax
  5ad3f2:	83 e0 03             	and    $0x3,%eax
  5ad3f5:	48 83 fe 04          	cmp    $0x4,%rsi
  5ad3f9:	4c 8b 44 24 10       	mov    0x10(%rsp),%r8
  5ad3fe:	73 11                	jae    5ad411 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x33e1>
  5ad400:	31 d2                	xor    %edx,%edx
  5ad402:	45 31 d2             	xor    %r10d,%r10d
  5ad405:	eb 51                	jmp    5ad458 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x3428>
  5ad407:	45 31 d2             	xor    %r10d,%r10d
  5ad40a:	4c 8b 44 24 10       	mov    0x10(%rsp),%r8
  5ad40f:	eb 71                	jmp    5ad482 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x3452>
  5ad411:	48 83 e6 fc          	and    $0xfffffffffffffffc,%rsi
  5ad415:	31 d2                	xor    %edx,%edx
  5ad417:	48 89 cf             	mov    %rcx,%rdi
  5ad41a:	45 31 d2             	xor    %r10d,%r10d
  5ad41d:	0f 1f 00             	nopl   (%rax)
  5ad420:	48 83 3f 01          	cmpq   $0x1,(%rdi)
  5ad424:	49 83 da ff          	sbb    $0xffffffffffffffff,%r10
  5ad428:	48 83 7f 28 01       	cmpq   $0x1,0x28(%rdi)
  5ad42d:	49 83 da ff          	sbb    $0xffffffffffffffff,%r10
  5ad431:	48 83 7f 50 01       	cmpq   $0x1,0x50(%rdi)
  5ad436:	49 83 da ff          	sbb    $0xffffffffffffffff,%r10
  5ad43a:	48 83 7f 78 01       	cmpq   $0x1,0x78(%rdi)
  5ad43f:	49 83 da ff          	sbb    $0xffffffffffffffff,%r10
  5ad443:	48 83 c2 04          	add    $0x4,%rdx
  5ad447:	48 81 c7 a0 00 00 00 	add    $0xa0,%rdi
  5ad44e:	48 39 d6             	cmp    %rdx,%rsi
  5ad451:	75 cd                	jne    5ad420 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x33f0>
  5ad453:	48 85 c0             	test   %rax,%rax
  5ad456:	74 2a                	je     5ad482 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x3452>
  5ad458:	48 8d 14 92          	lea    (%rdx,%rdx,4),%rdx
  5ad45c:	48 8d 0c d1          	lea    (%rcx,%rdx,8),%rcx
  5ad460:	c1 e0 03             	shl    $0x3,%eax
  5ad463:	48 8d 04 80          	lea    (%rax,%rax,4),%rax
  5ad467:	31 d2                	xor    %edx,%edx
  5ad469:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  5ad470:	48 83 3c 11 01       	cmpq   $0x1,(%rcx,%rdx,1)
  5ad475:	49 83 da ff          	sbb    $0xffffffffffffffff,%r10
  5ad479:	48 83 c2 28          	add    $0x28,%rdx
  5ad47d:	48 39 d0             	cmp    %rdx,%rax
  5ad480:	75 ee                	jne    5ad470 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x3440>
  5ad482:	b0 01                	mov    $0x1,%al
  5ad484:	48 8b 8c 24 d8 02 00 	mov    0x2d8(%rsp),%rcx
  5ad48b:	00 
  5ad48c:	48 3b 8c 24 28 02 00 	cmp    0x228(%rsp),%rcx
  5ad493:	00 
  5ad494:	75 3f                	jne    5ad4d5 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x34a5>
  5ad496:	48 83 bc 24 d8 02 00 	cmpq   $0x0,0x2d8(%rsp)
  5ad49d:	00 00 
  5ad49f:	74 32                	je     5ad4d3 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x34a3>
  5ad4a1:	48 8b 8c 24 20 02 00 	mov    0x220(%rsp),%rcx
  5ad4a8:	00 
  5ad4a9:	49 ff c9             	dec    %r9
  5ad4ac:	31 d2                	xor    %edx,%edx
  5ad4ae:	66 90                	xchg   %ax,%ax
  5ad4b0:	48 8b 84 24 80 00 00 	mov    0x80(%rsp),%rax
  5ad4b7:	00 
  5ad4b8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  5ad4bc:	48 3b 01             	cmp    (%rcx),%rax
  5ad4bf:	0f 95 c0             	setne  %al
  5ad4c2:	75 11                	jne    5ad4d5 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x34a5>
  5ad4c4:	48 83 c1 28          	add    $0x28,%rcx
  5ad4c8:	49 39 d1             	cmp    %rdx,%r9
  5ad4cb:	48 8d 52 01          	lea    0x1(%rdx),%rdx
  5ad4cf:	75 df                	jne    5ad4b0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x3480>
  5ad4d1:	eb 02                	jmp    5ad4d5 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x34a5>
  5ad4d3:	31 c0                	xor    %eax,%eax
  5ad4d5:	41 08 80 59 09 00 00 	or     %al,0x959(%r8)
  5ad4dc:	41 08 80 5b 09 00 00 	or     %al,0x95b(%r8)
  5ad4e3:	48 c7 84 24 f0 05 00 	movq   $0x0,0x5f0(%rsp)
  5ad4ea:	00 00 00 00 00 
  5ad4ef:	48 c7 84 24 00 06 00 	movq   $0x0,0x600(%rsp)
  5ad4f6:	00 00 00 00 00 
  5ad4fb:	48 c7 84 24 08 06 00 	movq   $0x0,0x608(%rsp)
  5ad502:	00 00 00 00 00 
  5ad507:	48 c7 84 24 18 06 00 	movq   $0x0,0x618(%rsp)
  5ad50e:	00 00 00 00 00 
  5ad513:	4c 8b bc 24 f0 04 00 	mov    0x4f0(%rsp),%r15
  5ad51a:	00 
  5ad51b:	4c 8b a4 24 f8 04 00 	mov    0x4f8(%rsp),%r12
  5ad522:	00 
  5ad523:	48 8b 84 24 00 05 00 	mov    0x500(%rsp),%rax
  5ad52a:	00 
  5ad52b:	48 69 d0 a8 00 00 00 	imul   $0xa8,%rax,%rdx
  5ad532:	4c 01 e2             	add    %r12,%rdx
  5ad535:	4c 89 a4 24 b0 03 00 	mov    %r12,0x3b0(%rsp)
  5ad53c:	00 
  5ad53d:	4c 89 a4 24 b8 03 00 	mov    %r12,0x3b8(%rsp)
  5ad544:	00 
  5ad545:	4c 89 bc 24 c0 03 00 	mov    %r15,0x3c0(%rsp)
  5ad54c:	00 
  5ad54d:	48 89 94 24 70 02 00 	mov    %rdx,0x270(%rsp)
  5ad554:	00 
  5ad555:	48 89 94 24 c8 03 00 	mov    %rdx,0x3c8(%rsp)
  5ad55c:	00 
  5ad55d:	4c 89 a4 24 10 02 00 	mov    %r12,0x210(%rsp)
  5ad564:	00 
  5ad565:	48 85 c0             	test   %rax,%rax
  5ad568:	4c 89 94 24 08 02 00 	mov    %r10,0x208(%rsp)
  5ad56f:	00 
  5ad570:	0f 84 3d 07 00 00    	je     5adcb3 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x3c83>
  5ad576:	49 8d 80 48 08 00 00 	lea    0x848(%r8),%rax
  5ad57d:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  5ad582:	48 8b 84 24 10 02 00 	mov    0x210(%rsp),%rax
  5ad589:	00 
  5ad58a:	4c 89 bc 24 68 02 00 	mov    %r15,0x268(%rsp)
  5ad591:	00 
  5ad592:	eb 1d                	jmp    5ad5b1 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x3581>
  5ad594:	66 66 66 2e 0f 1f 84 	data16 data16 cs nopw 0x0(%rax,%rax,1)
  5ad59b:	00 00 00 00 00 
  5ad5a0:	48 89 d8             	mov    %rbx,%rax
  5ad5a3:	48 3b 9c 24 70 02 00 	cmp    0x270(%rsp),%rbx
  5ad5aa:	00 
  5ad5ab:	0f 84 f2 06 00 00    	je     5adca3 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x3c73>
  5ad5b1:	4c 8d a0 a8 00 00 00 	lea    0xa8(%rax),%r12
  5ad5b8:	48 8b 08             	mov    (%rax),%rcx
  5ad5bb:	48 83 f9 02          	cmp    $0x2,%rcx
  5ad5bf:	0f 84 e6 06 00 00    	je     5adcab <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x3c7b>
  5ad5c5:	48 89 8c 24 d0 04 00 	mov    %rcx,0x4d0(%rsp)
  5ad5cc:	00 
  5ad5cd:	4c 89 a4 24 f8 01 00 	mov    %r12,0x1f8(%rsp)
  5ad5d4:	00 
  5ad5d5:	48 8b 48 18          	mov    0x18(%rax),%rcx
  5ad5d9:	48 89 8c 24 00 02 00 	mov    %rcx,0x200(%rsp)
  5ad5e0:	00 
  5ad5e1:	4c 8b 58 20          	mov    0x20(%rax),%r11
  5ad5e5:	48 8b 48 30          	mov    0x30(%rax),%rcx
  5ad5e9:	48 89 4c 24 18       	mov    %rcx,0x18(%rsp)
  5ad5ee:	48 8b 48 38          	mov    0x38(%rax),%rcx
  5ad5f2:	48 89 4c 24 50       	mov    %rcx,0x50(%rsp)
  5ad5f7:	48 8b 48 40          	mov    0x40(%rax),%rcx
  5ad5fb:	48 89 4c 24 38       	mov    %rcx,0x38(%rsp)
  5ad600:	48 8b 48 48          	mov    0x48(%rax),%rcx
  5ad604:	48 89 4c 24 30       	mov    %rcx,0x30(%rsp)
  5ad609:	48 8b 48 50          	mov    0x50(%rax),%rcx
  5ad60d:	48 89 4c 24 60       	mov    %rcx,0x60(%rsp)
  5ad612:	0f 10 40 58          	movups 0x58(%rax),%xmm0
  5ad616:	0f 29 44 24 40       	movaps %xmm0,0x40(%rsp)
  5ad61b:	0f 10 40 68          	movups 0x68(%rax),%xmm0
  5ad61f:	0f 29 44 24 70       	movaps %xmm0,0x70(%rsp)
  5ad624:	48 8b 48 78          	mov    0x78(%rax),%rcx
  5ad628:	48 89 4c 24 58       	mov    %rcx,0x58(%rsp)
  5ad62d:	48 8b 98 80 00 00 00 	mov    0x80(%rax),%rbx
  5ad634:	48 8b 88 88 00 00 00 	mov    0x88(%rax),%rcx
  5ad63b:	48 89 8c 24 98 00 00 	mov    %rcx,0x98(%rsp)
  5ad642:	00 
  5ad643:	4c 8b b0 90 00 00 00 	mov    0x90(%rax),%r14
  5ad64a:	48 8b 88 98 00 00 00 	mov    0x98(%rax),%rcx
  5ad651:	4c 8b a8 a0 00 00 00 	mov    0xa0(%rax),%r13
  5ad658:	66 0f 10 40 08       	movupd 0x8(%rax),%xmm0
  5ad65d:	66 0f 29 84 24 00 04 	movapd %xmm0,0x400(%rsp)
  5ad664:	00 00 
  5ad666:	48 8b 94 24 28 02 00 	mov    0x228(%rsp),%rdx
  5ad66d:	00 
  5ad66e:	48 89 8c 24 80 02 00 	mov    %rcx,0x280(%rsp)
  5ad675:	00 
  5ad676:	48 89 94 24 60 02 00 	mov    %rdx,0x260(%rsp)
  5ad67d:	00 
  5ad67e:	48 39 d1             	cmp    %rdx,%rcx
  5ad681:	4c 89 9c 24 78 02 00 	mov    %r11,0x278(%rsp)
  5ad688:	00 
  5ad689:	48 89 9c 24 90 00 00 	mov    %rbx,0x90(%rsp)
  5ad690:	00 
  5ad691:	0f 83 85 22 00 00    	jae    5af91c <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x58ec>
  5ad697:	48 8b 84 24 a0 05 00 	mov    0x5a0(%rsp),%rax
  5ad69e:	00 
  5ad69f:	48 8b 08             	mov    (%rax),%rcx
  5ad6a2:	b0 01                	mov    $0x1,%al
  5ad6a4:	48 85 c9             	test   %rcx,%rcx
  5ad6a7:	0f 84 13 01 00 00    	je     5ad7c0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x3790>
  5ad6ad:	48 8b 54 24 10       	mov    0x10(%rsp),%rdx
  5ad6b2:	48 8b b2 20 08 00 00 	mov    0x820(%rdx),%rsi
  5ad6b9:	44 0f b7 81 32 05 00 	movzwl 0x532(%rcx),%r8d
  5ad6c0:	00 
  5ad6c1:	4d 6b c8 70          	imul   $0x70,%r8,%r9
  5ad6c5:	48 c7 c7 ff ff ff ff 	mov    $0xffffffffffffffff,%rdi
  5ad6cc:	31 d2                	xor    %edx,%edx
  5ad6ce:	66 90                	xchg   %ax,%ax
  5ad6d0:	49 39 d1             	cmp    %rdx,%r9
  5ad6d3:	74 2b                	je     5ad700 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x36d0>
  5ad6d5:	4c 3b ac f9 e0 04 00 	cmp    0x4e0(%rcx,%rdi,8),%r13
  5ad6dc:	00 
  5ad6dd:	41 0f 97 c2          	seta   %r10b
  5ad6e1:	41 80 da 00          	sbb    $0x0,%r10b
  5ad6e5:	48 83 c2 70          	add    $0x70,%rdx
  5ad6e9:	48 ff c7             	inc    %rdi
  5ad6ec:	41 80 fa 01          	cmp    $0x1,%r10b
  5ad6f0:	74 de                	je     5ad6d0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x36a0>
  5ad6f2:	45 0f b6 c2          	movzbl %r10b,%r8d
  5ad6f6:	45 85 c0             	test   %r8d,%r8d
  5ad6f9:	75 08                	jne    5ad703 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x36d3>
  5ad6fb:	eb 23                	jmp    5ad720 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x36f0>
  5ad6fd:	0f 1f 00             	nopl   (%rax)
  5ad700:	4c 89 c7             	mov    %r8,%rdi
  5ad703:	48 83 ee 01          	sub    $0x1,%rsi
  5ad707:	0f 82 b3 00 00 00    	jb     5ad7c0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x3790>
  5ad70d:	48 8b 8c f9 38 05 00 	mov    0x538(%rcx,%rdi,8),%rcx
  5ad714:	00 
  5ad715:	eb a2                	jmp    5ad6b9 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x3689>
  5ad717:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
  5ad71e:	00 00 
  5ad720:	f2 0f 10 44 11 d8    	movsd  -0x28(%rcx,%rdx,1),%xmm0
  5ad726:	66 0f 28 4c 24 40    	movapd 0x40(%rsp),%xmm1
  5ad72c:	66 0f 2e c1          	ucomisd %xmm1,%xmm0
  5ad730:	0f 85 8a 00 00 00    	jne    5ad7c0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x3790>
  5ad736:	0f 8a 84 00 00 00    	jp     5ad7c0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x3790>
  5ad73c:	f2 0f 10 44 11 e0    	movsd  -0x20(%rcx,%rdx,1),%xmm0
  5ad742:	66 0f 15 c9          	unpckhpd %xmm1,%xmm1
  5ad746:	66 0f 2e c1          	ucomisd %xmm1,%xmm0
  5ad74a:	75 74                	jne    5ad7c0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x3790>
  5ad74c:	7a 72                	jp     5ad7c0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x3790>
  5ad74e:	f2 0f 10 44 11 e8    	movsd  -0x18(%rcx,%rdx,1),%xmm0
  5ad754:	66 0f 28 4c 24 70    	movapd 0x70(%rsp),%xmm1
  5ad75a:	66 0f 2e c1          	ucomisd %xmm1,%xmm0
  5ad75e:	75 60                	jne    5ad7c0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x3790>
  5ad760:	7a 5e                	jp     5ad7c0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x3790>
  5ad762:	f2 0f 10 44 11 f0    	movsd  -0x10(%rcx,%rdx,1),%xmm0
  5ad768:	66 0f 15 c9          	unpckhpd %xmm1,%xmm1
  5ad76c:	66 0f 2e c1          	ucomisd %xmm1,%xmm0
  5ad770:	75 4e                	jne    5ad7c0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x3790>
  5ad772:	7a 4c                	jp     5ad7c0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x3790>
  5ad774:	48 8b 74 24 60       	mov    0x60(%rsp),%rsi
  5ad779:	48 39 74 11 d0       	cmp    %rsi,-0x30(%rcx,%rdx,1)
  5ad77e:	75 40                	jne    5ad7c0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x3790>
  5ad780:	48 8b 74 24 18       	mov    0x18(%rsp),%rsi
  5ad785:	48 39 74 11 b0       	cmp    %rsi,-0x50(%rcx,%rdx,1)
  5ad78a:	75 34                	jne    5ad7c0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x3790>
  5ad78c:	48 8b 74 24 50       	mov    0x50(%rsp),%rsi
  5ad791:	48 39 74 11 b8       	cmp    %rsi,-0x48(%rcx,%rdx,1)
  5ad796:	75 28                	jne    5ad7c0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x3790>
  5ad798:	48 8b 74 24 38       	mov    0x38(%rsp),%rsi
  5ad79d:	48 39 74 11 c0       	cmp    %rsi,-0x40(%rcx,%rdx,1)
  5ad7a2:	75 1c                	jne    5ad7c0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x3790>
  5ad7a4:	48 8b 74 24 30       	mov    0x30(%rsp),%rsi
  5ad7a9:	48 39 74 11 c8       	cmp    %rsi,-0x38(%rcx,%rdx,1)
  5ad7ae:	75 10                	jne    5ad7c0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x3790>
  5ad7b0:	48 8b 44 24 58       	mov    0x58(%rsp),%rax
  5ad7b5:	48 39 44 11 f8       	cmp    %rax,-0x8(%rcx,%rdx,1)
  5ad7ba:	0f 95 c0             	setne  %al
  5ad7bd:	0f 1f 00             	nopl   (%rax)
  5ad7c0:	48 8b 8c 24 20 02 00 	mov    0x220(%rsp),%rcx
  5ad7c7:	00 
  5ad7c8:	48 8b 94 24 80 02 00 	mov    0x280(%rsp),%rdx
  5ad7cf:	00 
  5ad7d0:	48 8d 14 92          	lea    (%rdx,%rdx,4),%rdx
  5ad7d4:	48 8b 0c d1          	mov    (%rcx,%rdx,8),%rcx
  5ad7d8:	48 89 8c 24 38 04 00 	mov    %rcx,0x438(%rsp)
  5ad7df:	00 
  5ad7e0:	48 8b 4c 24 10       	mov    0x10(%rsp),%rcx
  5ad7e5:	08 81 5b 09 00 00    	or     %al,0x95b(%rcx)
  5ad7eb:	4d 85 f6             	test   %r14,%r14
  5ad7ee:	0f 84 7c 02 00 00    	je     5ada70 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x3a40>
  5ad7f4:	49 c1 e6 05          	shl    $0x5,%r14
  5ad7f8:	48 8b 9c 24 98 00 00 	mov    0x98(%rsp),%rbx
  5ad7ff:	00 
  5ad800:	49 01 de             	add    %rbx,%r14
  5ad803:	eb 32                	jmp    5ad837 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x3807>
  5ad805:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
  5ad80c:	00 00 00 00 
  5ad810:	0f 10 84 24 90 01 00 	movups 0x190(%rsp),%xmm0
  5ad817:	00 
  5ad818:	0f 10 8c 24 a0 01 00 	movups 0x1a0(%rsp),%xmm1
  5ad81f:	00 
  5ad820:	0f 11 4c 38 f0       	movups %xmm1,-0x10(%rax,%rdi,1)
  5ad825:	0f 11 44 38 e0       	movups %xmm0,-0x20(%rax,%rdi,1)
  5ad82a:	48 83 c3 20          	add    $0x20,%rbx
  5ad82e:	4c 39 f3             	cmp    %r14,%rbx
  5ad831:	0f 84 39 02 00 00    	je     5ada70 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x3a40>
  5ad837:	48 8b 3b             	mov    (%rbx),%rdi
  5ad83a:	48 8b b4 24 28 02 00 	mov    0x228(%rsp),%rsi
  5ad841:	00 
  5ad842:	48 39 f7             	cmp    %rsi,%rdi
  5ad845:	0f 83 56 20 00 00    	jae    5af8a1 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5871>
  5ad84b:	4c 8b 7b 08          	mov    0x8(%rbx),%r15
  5ad84f:	8b 6b 10             	mov    0x10(%rbx),%ebp
  5ad852:	f2 0f 10 43 14       	movsd  0x14(%rbx),%xmm0
  5ad857:	0f 29 44 24 20       	movaps %xmm0,0x20(%rsp)
  5ad85c:	48 8b 84 24 20 02 00 	mov    0x220(%rsp),%rax
  5ad863:	00 
  5ad864:	48 8d 0c bf          	lea    (%rdi,%rdi,4),%rcx
  5ad868:	4c 8b 24 c8          	mov    (%rax,%rcx,8),%r12
  5ad86c:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  5ad871:	48 8b 80 30 08 00 00 	mov    0x830(%rax),%rax
  5ad878:	48 85 c0             	test   %rax,%rax
  5ad87b:	0f 84 b4 00 00 00    	je     5ad935 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x3905>
  5ad881:	48 8b 4c 24 10       	mov    0x10(%rsp),%rcx
  5ad886:	48 8b 89 38 08 00 00 	mov    0x838(%rcx),%rcx
  5ad88d:	0f b7 b8 c2 01 00 00 	movzwl 0x1c2(%rax),%edi
  5ad894:	41 89 f8             	mov    %edi,%r8d
  5ad897:	41 c1 e0 05          	shl    $0x5,%r8d
  5ad89b:	48 c7 c2 ff ff ff ff 	mov    $0xffffffffffffffff,%rdx
  5ad8a2:	31 f6                	xor    %esi,%esi
  5ad8a4:	66 66 66 2e 0f 1f 84 	data16 data16 cs nopw 0x0(%rax,%rax,1)
  5ad8ab:	00 00 00 00 00 
  5ad8b0:	49 39 f0             	cmp    %rsi,%r8
  5ad8b3:	74 3b                	je     5ad8f0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x38c0>
  5ad8b5:	4c 3b a4 d0 70 01 00 	cmp    0x170(%rax,%rdx,8),%r12
  5ad8bc:	00 
  5ad8bd:	41 0f 97 c1          	seta   %r9b
  5ad8c1:	41 80 d9 00          	sbb    $0x0,%r9b
  5ad8c5:	48 83 c6 20          	add    $0x20,%rsi
  5ad8c9:	48 ff c2             	inc    %rdx
  5ad8cc:	41 80 f9 01          	cmp    $0x1,%r9b
  5ad8d0:	74 de                	je     5ad8b0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x3880>
  5ad8d2:	41 0f b6 f9          	movzbl %r9b,%edi
  5ad8d6:	85 ff                	test   %edi,%edi
  5ad8d8:	74 36                	je     5ad910 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x38e0>
  5ad8da:	48 83 e9 01          	sub    $0x1,%rcx
  5ad8de:	73 19                	jae    5ad8f9 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x38c9>
  5ad8e0:	eb 53                	jmp    5ad935 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x3905>
  5ad8e2:	66 66 66 66 66 2e 0f 	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  5ad8e9:	1f 84 00 00 00 00 00 
  5ad8f0:	48 89 fa             	mov    %rdi,%rdx
  5ad8f3:	48 83 e9 01          	sub    $0x1,%rcx
  5ad8f7:	72 3c                	jb     5ad935 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x3905>
  5ad8f9:	48 8b 84 d0 c8 01 00 	mov    0x1c8(%rax,%rdx,8),%rax
  5ad900:	00 
  5ad901:	eb 8a                	jmp    5ad88d <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x385d>
  5ad903:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  5ad90a:	84 00 00 00 00 00 
  5ad910:	f3 0f 10 44 30 f4    	movss  -0xc(%rax,%rsi,1),%xmm0
  5ad916:	0f 2e 44 24 20       	ucomiss 0x20(%rsp),%xmm0
  5ad91b:	75 18                	jne    5ad935 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x3905>
  5ad91d:	7a 16                	jp     5ad935 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x3905>
  5ad91f:	f3 0f 10 44 30 f8    	movss  -0x8(%rax,%rsi,1),%xmm0
  5ad925:	0f 28 4c 24 20       	movaps 0x20(%rsp),%xmm1
  5ad92a:	0f c6 c9 55          	shufps $0x55,%xmm1,%xmm1
  5ad92e:	0f 2e c1             	ucomiss %xmm1,%xmm0
  5ad931:	75 02                	jne    5ad935 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x3905>
  5ad933:	7b 19                	jnp    5ad94e <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x391e>
  5ad935:	48 8b 7c 24 08       	mov    0x8(%rsp),%rdi
  5ad93a:	4c 89 e6             	mov    %r12,%rsi
  5ad93d:	e8 fe b1 17 00       	call   728b40 <_RNvMsi_NtNtNtCscdodAO9FK5_5alloc11collections5btree3mapINtB5_8BTreeMapyNtNtB7_7set_val9SetValZSTE6insertCs6gaF1xUz9Bf_4gpui>
  5ad942:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  5ad947:	c6 80 5b 09 00 00 01 	movb   $0x1,0x95b(%rax)
  5ad94e:	4c 89 ac 24 90 01 00 	mov    %r13,0x190(%rsp)
  5ad955:	00 
  5ad956:	4c 89 bc 24 98 01 00 	mov    %r15,0x198(%rsp)
  5ad95d:	00 
  5ad95e:	89 ac 24 a0 01 00 00 	mov    %ebp,0x1a0(%rsp)
  5ad965:	0f 28 44 24 20       	movaps 0x20(%rsp),%xmm0
  5ad96a:	0f 13 84 24 a4 01 00 	movlps %xmm0,0x1a4(%rsp)
  5ad971:	00 
  5ad972:	c6 84 24 ac 01 00 00 	movb   $0x1,0x1ac(%rsp)
  5ad979:	01 
  5ad97a:	48 8b 84 24 08 06 00 	mov    0x608(%rsp),%rax
  5ad981:	00 
  5ad982:	48 85 c0             	test   %rax,%rax
  5ad985:	0f 84 85 00 00 00    	je     5ada10 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x39e0>
  5ad98b:	48 8b 8c 24 10 06 00 	mov    0x610(%rsp),%rcx
  5ad992:	00 
  5ad993:	0f b7 b0 c2 01 00 00 	movzwl 0x1c2(%rax),%esi
  5ad99a:	41 89 f0             	mov    %esi,%r8d
  5ad99d:	41 c1 e0 05          	shl    $0x5,%r8d
  5ad9a1:	48 c7 c2 ff ff ff ff 	mov    $0xffffffffffffffff,%rdx
  5ad9a8:	31 ff                	xor    %edi,%edi
  5ad9aa:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
  5ad9b0:	49 39 f8             	cmp    %rdi,%r8
  5ad9b3:	74 3b                	je     5ad9f0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x39c0>
  5ad9b5:	4c 3b a4 d0 70 01 00 	cmp    0x170(%rax,%rdx,8),%r12
  5ad9bc:	00 
  5ad9bd:	41 0f 97 c1          	seta   %r9b
  5ad9c1:	41 80 d9 00          	sbb    $0x0,%r9b
  5ad9c5:	48 83 c7 20          	add    $0x20,%rdi
  5ad9c9:	48 ff c2             	inc    %rdx
  5ad9cc:	41 80 f9 01          	cmp    $0x1,%r9b
  5ad9d0:	74 de                	je     5ad9b0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x3980>
  5ad9d2:	41 0f b6 f1          	movzbl %r9b,%esi
  5ad9d6:	85 f6                	test   %esi,%esi
  5ad9d8:	0f 84 32 fe ff ff    	je     5ad810 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x37e0>
  5ad9de:	48 83 e9 01          	sub    $0x1,%rcx
  5ad9e2:	73 15                	jae    5ad9f9 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x39c9>
  5ad9e4:	eb 2c                	jmp    5ada12 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x39e2>
  5ad9e6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  5ad9ed:	00 00 00 
  5ad9f0:	48 89 f2             	mov    %rsi,%rdx
  5ad9f3:	48 83 e9 01          	sub    $0x1,%rcx
  5ad9f7:	72 19                	jb     5ada12 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x39e2>
  5ad9f9:	48 8b 84 d0 c8 01 00 	mov    0x1c8(%rax,%rdx,8),%rax
  5ada00:	00 
  5ada01:	eb 90                	jmp    5ad993 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x3963>
  5ada03:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  5ada0a:	84 00 00 00 00 00 
  5ada10:	31 c0                	xor    %eax,%eax
  5ada12:	48 8d 8c 24 08 06 00 	lea    0x608(%rsp),%rcx
  5ada19:	00 
  5ada1a:	48 89 8c 24 a0 00 00 	mov    %rcx,0xa0(%rsp)
  5ada21:	00 
  5ada22:	4c 89 a4 24 a8 00 00 	mov    %r12,0xa8(%rsp)
  5ada29:	00 
  5ada2a:	48 89 84 24 b0 00 00 	mov    %rax,0xb0(%rsp)
  5ada31:	00 
  5ada32:	48 c7 84 24 b8 00 00 	movq   $0x0,0xb8(%rsp)
  5ada39:	00 00 00 00 00 
  5ada3e:	48 89 94 24 c0 00 00 	mov    %rdx,0xc0(%rsp)
  5ada45:	00 
  5ada46:	48 8d bc 24 00 03 00 	lea    0x300(%rsp),%rdi
  5ada4d:	00 
  5ada4e:	48 8d b4 24 a0 00 00 	lea    0xa0(%rsp),%rsi
  5ada55:	00 
  5ada56:	48 8d 94 24 90 01 00 	lea    0x190(%rsp),%rdx
  5ada5d:	00 
  5ada5e:	e8 1d b5 1c 00       	call   778f80 <_RNvMs4_NtNtNtNtCscdodAO9FK5_5alloc11collections5btree3map5entryINtB5_11VacantEntryyNtNtNtCs6gaF1xUz9Bf_4gpui7runtime4list7ListRowE12insert_entryB1p_>
  5ada63:	e9 c2 fd ff ff       	jmp    5ad82a <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x37fa>
  5ada68:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  5ada6f:	00 
  5ada70:	48 8b b4 24 90 00 00 	mov    0x90(%rsp),%rsi
  5ada77:	00 
  5ada78:	48 85 f6             	test   %rsi,%rsi
  5ada7b:	74 17                	je     5ada94 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x3a64>
  5ada7d:	48 c1 e6 05          	shl    $0x5,%rsi
  5ada81:	ba 08 00 00 00       	mov    $0x8,%edx
  5ada86:	48 8b bc 24 98 00 00 	mov    0x98(%rsp),%rdi
  5ada8d:	00 
  5ada8e:	ff 15 64 c3 53 00    	call   *0x53c364(%rip)        # ae9df8 <_DYNAMIC+0x248>
  5ada94:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
  5ada99:	48 89 84 24 c0 00 00 	mov    %rax,0xc0(%rsp)
  5adaa0:	00 
  5adaa1:	48 8b 44 24 50       	mov    0x50(%rsp),%rax
  5adaa6:	48 89 84 24 c8 00 00 	mov    %rax,0xc8(%rsp)
  5adaad:	00 
  5adaae:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
  5adab3:	48 89 84 24 d0 00 00 	mov    %rax,0xd0(%rsp)
  5adaba:	00 
  5adabb:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
  5adac0:	48 89 84 24 d8 00 00 	mov    %rax,0xd8(%rsp)
  5adac7:	00 
  5adac8:	48 8b 44 24 60       	mov    0x60(%rsp),%rax
  5adacd:	48 89 84 24 e0 00 00 	mov    %rax,0xe0(%rsp)
  5adad4:	00 
  5adad5:	0f 28 44 24 40       	movaps 0x40(%rsp),%xmm0
  5adada:	0f 11 84 24 e8 00 00 	movups %xmm0,0xe8(%rsp)
  5adae1:	00 
  5adae2:	0f 28 44 24 70       	movaps 0x70(%rsp),%xmm0
  5adae7:	0f 11 84 24 f8 00 00 	movups %xmm0,0xf8(%rsp)
  5adaee:	00 
  5adaef:	48 8b 44 24 58       	mov    0x58(%rsp),%rax
  5adaf4:	48 89 84 24 08 01 00 	mov    %rax,0x108(%rsp)
  5adafb:	00 
  5adafc:	48 8b 84 24 d0 04 00 	mov    0x4d0(%rsp),%rax
  5adb03:	00 
  5adb04:	48 89 84 24 a0 00 00 	mov    %rax,0xa0(%rsp)
  5adb0b:	00 
  5adb0c:	66 0f 28 84 24 00 04 	movapd 0x400(%rsp),%xmm0
  5adb13:	00 00 
  5adb15:	48 8d 84 24 a8 00 00 	lea    0xa8(%rsp),%rax
  5adb1c:	00 
  5adb1d:	66 0f 11 00          	movupd %xmm0,(%rax)
  5adb21:	48 8b 84 24 38 04 00 	mov    0x438(%rsp),%rax
  5adb28:	00 
  5adb29:	48 89 84 24 b8 00 00 	mov    %rax,0xb8(%rsp)
  5adb30:	00 
  5adb31:	48 8b 84 24 f0 05 00 	mov    0x5f0(%rsp),%rax
  5adb38:	00 
  5adb39:	48 85 c0             	test   %rax,%rax
  5adb3c:	0f 84 d1 00 00 00    	je     5adc13 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x3be3>
  5adb42:	48 8b 94 24 f8 05 00 	mov    0x5f8(%rsp),%rdx
  5adb49:	00 
  5adb4a:	0f b7 b8 32 05 00 00 	movzwl 0x532(%rax),%edi
  5adb51:	4c 6b c7 70          	imul   $0x70,%rdi,%r8
  5adb55:	48 c7 c1 ff ff ff ff 	mov    $0xffffffffffffffff,%rcx
  5adb5c:	31 f6                	xor    %esi,%esi
  5adb5e:	66 90                	xchg   %ax,%ax
  5adb60:	49 39 f0             	cmp    %rsi,%r8
  5adb63:	74 2b                	je     5adb90 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x3b60>
  5adb65:	4c 3b ac c8 e0 04 00 	cmp    0x4e0(%rax,%rcx,8),%r13
  5adb6c:	00 
  5adb6d:	41 0f 97 c1          	seta   %r9b
  5adb71:	41 80 d9 00          	sbb    $0x0,%r9b
  5adb75:	48 83 c6 70          	add    $0x70,%rsi
  5adb79:	48 ff c1             	inc    %rcx
  5adb7c:	41 80 f9 01          	cmp    $0x1,%r9b
  5adb80:	74 de                	je     5adb60 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x3b30>
  5adb82:	41 0f b6 f9          	movzbl %r9b,%edi
  5adb86:	85 ff                	test   %edi,%edi
  5adb88:	75 09                	jne    5adb93 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x3b63>
  5adb8a:	eb 24                	jmp    5adbb0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x3b80>
  5adb8c:	0f 1f 40 00          	nopl   0x0(%rax)
  5adb90:	48 89 f9             	mov    %rdi,%rcx
  5adb93:	48 83 ea 01          	sub    $0x1,%rdx
  5adb97:	72 7c                	jb     5adc15 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x3be5>
  5adb99:	48 8b 84 c8 38 05 00 	mov    0x538(%rax,%rcx,8),%rax
  5adba0:	00 
  5adba1:	eb a7                	jmp    5adb4a <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x3b1a>
  5adba3:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  5adbaa:	84 00 00 00 00 00 
  5adbb0:	0f 10 84 24 00 01 00 	movups 0x100(%rsp),%xmm0
  5adbb7:	00 
  5adbb8:	0f 11 44 30 f0       	movups %xmm0,-0x10(%rax,%rsi,1)
  5adbbd:	0f 10 84 24 f0 00 00 	movups 0xf0(%rsp),%xmm0
  5adbc4:	00 
  5adbc5:	0f 11 44 30 e0       	movups %xmm0,-0x20(%rax,%rsi,1)
  5adbca:	0f 10 84 24 e0 00 00 	movups 0xe0(%rsp),%xmm0
  5adbd1:	00 
  5adbd2:	0f 11 44 30 d0       	movups %xmm0,-0x30(%rax,%rsi,1)
  5adbd7:	66 0f 10 84 24 a0 00 	movupd 0xa0(%rsp),%xmm0
  5adbde:	00 00 
  5adbe0:	66 0f 10 8c 24 b0 00 	movupd 0xb0(%rsp),%xmm1
  5adbe7:	00 00 
  5adbe9:	f3 0f 6f 94 24 c0 00 	movdqu 0xc0(%rsp),%xmm2
  5adbf0:	00 00 
  5adbf2:	0f 10 9c 24 d0 00 00 	movups 0xd0(%rsp),%xmm3
  5adbf9:	00 
  5adbfa:	0f 11 5c 30 c0       	movups %xmm3,-0x40(%rax,%rsi,1)
  5adbff:	f3 0f 7f 54 30 b0    	movdqu %xmm2,-0x50(%rax,%rsi,1)
  5adc05:	66 0f 11 4c 30 a0    	movupd %xmm1,-0x60(%rax,%rsi,1)
  5adc0b:	66 0f 11 44 30 90    	movupd %xmm0,-0x70(%rax,%rsi,1)
  5adc11:	eb 53                	jmp    5adc66 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x3c36>
  5adc13:	31 c0                	xor    %eax,%eax
  5adc15:	48 8d 94 24 f0 05 00 	lea    0x5f0(%rsp),%rdx
  5adc1c:	00 
  5adc1d:	48 89 94 24 00 03 00 	mov    %rdx,0x300(%rsp)
  5adc24:	00 
  5adc25:	4c 89 ac 24 08 03 00 	mov    %r13,0x308(%rsp)
  5adc2c:	00 
  5adc2d:	48 89 84 24 10 03 00 	mov    %rax,0x310(%rsp)
  5adc34:	00 
  5adc35:	48 c7 84 24 18 03 00 	movq   $0x0,0x318(%rsp)
  5adc3c:	00 00 00 00 00 
  5adc41:	48 89 8c 24 20 03 00 	mov    %rcx,0x320(%rsp)
  5adc48:	00 
  5adc49:	48 8d bc 24 90 01 00 	lea    0x190(%rsp),%rdi
  5adc50:	00 
  5adc51:	48 8d b4 24 00 03 00 	lea    0x300(%rsp),%rsi
  5adc58:	00 
  5adc59:	48 8d 94 24 a0 00 00 	lea    0xa0(%rsp),%rdx
  5adc60:	00 
  5adc61:	e8 ea a8 1c 00       	call   778550 <_RNvMs4_NtNtNtNtCscdodAO9FK5_5alloc11collections5btree3map5entryINtB5_11VacantEntryNtNtCs6gaF1xUz9Bf_4gpui4list6ListIdNtNtNtB1m_7runtime4list9ListStateE12insert_entryB1m_>
  5adc66:	4c 8b bc 24 68 02 00 	mov    0x268(%rsp),%r15
  5adc6d:	00 
  5adc6e:	48 8b 9c 24 f8 01 00 	mov    0x1f8(%rsp),%rbx
  5adc75:	00 
  5adc76:	48 8b b4 24 00 02 00 	mov    0x200(%rsp),%rsi
  5adc7d:	00 
  5adc7e:	48 85 f6             	test   %rsi,%rsi
  5adc81:	0f 84 19 f9 ff ff    	je     5ad5a0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x3570>
  5adc87:	48 c1 e6 03          	shl    $0x3,%rsi
  5adc8b:	ba 08 00 00 00       	mov    $0x8,%edx
  5adc90:	48 8b bc 24 78 02 00 	mov    0x278(%rsp),%rdi
  5adc97:	00 
  5adc98:	ff 15 5a c1 53 00    	call   *0x53c15a(%rip)        # ae9df8 <_DYNAMIC+0x248>
  5adc9e:	e9 fd f8 ff ff       	jmp    5ad5a0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x3570>
  5adca3:	4c 8b a4 24 70 02 00 	mov    0x270(%rsp),%r12
  5adcaa:	00 
  5adcab:	4c 89 a4 24 b8 03 00 	mov    %r12,0x3b8(%rsp)
  5adcb2:	00 
  5adcb3:	48 8b b4 24 70 02 00 	mov    0x270(%rsp),%rsi
  5adcba:	00 
  5adcbb:	48 89 f0             	mov    %rsi,%rax
  5adcbe:	4c 29 e0             	sub    %r12,%rax
  5adcc1:	48 c1 e8 03          	shr    $0x3,%rax
  5adcc5:	48 b9 31 0c c3 30 0c 	movabs $0xc30c30c30c30c31,%rcx
  5adccc:	c3 30 0c 
  5adccf:	48 f7 e1             	mul    %rcx
  5adcd2:	4c 39 e6             	cmp    %r12,%rsi
  5adcd5:	74 5c                	je     5add33 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x3d03>
  5adcd7:	48 89 d3             	mov    %rdx,%rbx
  5adcda:	49 81 c4 88 00 00 00 	add    $0x88,%r12
  5adce1:	4c 8b 35 10 c1 53 00 	mov    0x53c110(%rip),%r14        # ae9df8 <_DYNAMIC+0x248>
  5adce8:	eb 12                	jmp    5adcfc <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x3ccc>
  5adcea:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
  5adcf0:	49 81 c4 a8 00 00 00 	add    $0xa8,%r12
  5adcf7:	48 ff cb             	dec    %rbx
  5adcfa:	74 37                	je     5add33 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x3d03>
  5adcfc:	49 8b 74 24 90       	mov    -0x70(%r12),%rsi
  5add01:	48 85 f6             	test   %rsi,%rsi
  5add04:	74 11                	je     5add17 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x3ce7>
  5add06:	49 8b 7c 24 98       	mov    -0x68(%r12),%rdi
  5add0b:	48 c1 e6 03          	shl    $0x3,%rsi
  5add0f:	ba 08 00 00 00       	mov    $0x8,%edx
  5add14:	41 ff d6             	call   *%r14
  5add17:	49 8b 74 24 f8       	mov    -0x8(%r12),%rsi
  5add1c:	48 85 f6             	test   %rsi,%rsi
  5add1f:	74 cf                	je     5adcf0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x3cc0>
  5add21:	49 8b 3c 24          	mov    (%r12),%rdi
  5add25:	48 c1 e6 05          	shl    $0x5,%rsi
  5add29:	ba 08 00 00 00       	mov    $0x8,%edx
  5add2e:	41 ff d6             	call   *%r14
  5add31:	eb bd                	jmp    5adcf0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x3cc0>
  5add33:	4d 85 ff             	test   %r15,%r15
  5add36:	74 1a                	je     5add52 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x3d22>
  5add38:	49 69 f7 a8 00 00 00 	imul   $0xa8,%r15,%rsi
  5add3f:	ba 08 00 00 00       	mov    $0x8,%edx
  5add44:	48 8b bc 24 10 02 00 	mov    0x210(%rsp),%rdi
  5add4b:	00 
  5add4c:	ff 15 a6 c0 53 00    	call   *0x53c0a6(%rip)        # ae9df8 <_DYNAMIC+0x248>
  5add52:	4c 8b b4 24 50 04 00 	mov    0x450(%rsp),%r14
  5add59:	00 
  5add5a:	48 8b 8c 24 00 06 00 	mov    0x600(%rsp),%rcx
  5add61:	00 
  5add62:	4c 09 f1             	or     %r14,%rcx
  5add65:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  5add6a:	48 8b 80 10 08 00 00 	mov    0x810(%rax),%rax
  5add71:	b2 01                	mov    $0x1,%dl
  5add73:	48 09 c1             	or     %rax,%rcx
  5add76:	0f 84 70 0b 00 00    	je     5ae8ec <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x48bc>
  5add7c:	48 85 c0             	test   %rax,%rax
  5add7f:	0f 85 df 00 00 00    	jne    5ade64 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x3e34>
  5add85:	48 c7 84 24 a0 00 00 	movq   $0x0,0xa0(%rsp)
  5add8c:	00 00 00 00 00 
  5add91:	48 c7 84 24 a8 00 00 	movq   $0x8,0xa8(%rsp)
  5add98:	00 08 00 00 00 
  5add9d:	48 c7 84 24 78 01 00 	movq   $0x0,0x178(%rsp)
  5adda4:	00 00 00 00 00 
  5adda9:	48 c7 84 24 88 01 00 	movq   $0x0,0x188(%rsp)
  5addb0:	00 00 00 00 00 
  5addb5:	0f 57 c0             	xorps  %xmm0,%xmm0
  5addb8:	0f 11 84 24 b0 00 00 	movups %xmm0,0xb0(%rsp)
  5addbf:	00 
  5addc0:	48 c7 84 24 c0 00 00 	movq   $0x8,0xc0(%rsp)
  5addc7:	00 08 00 00 00 
  5addcc:	0f 11 84 24 c8 00 00 	movups %xmm0,0xc8(%rsp)
  5addd3:	00 
  5addd4:	48 c7 84 24 d8 00 00 	movq   $0x8,0xd8(%rsp)
  5adddb:	00 08 00 00 00 
  5adde0:	0f 11 84 24 e0 00 00 	movups %xmm0,0xe0(%rsp)
  5adde7:	00 
  5adde8:	48 c7 84 24 f0 00 00 	movq   $0x8,0xf0(%rsp)
  5addef:	00 08 00 00 00 
  5addf4:	0f 11 84 24 f8 00 00 	movups %xmm0,0xf8(%rsp)
  5addfb:	00 
  5addfc:	48 c7 84 24 08 01 00 	movq   $0x8,0x108(%rsp)
  5ade03:	00 08 00 00 00 
  5ade08:	48 c7 84 24 10 01 00 	movq   $0x0,0x110(%rsp)
  5ade0f:	00 00 00 00 00 
  5ade14:	48 c7 84 24 18 01 00 	movq   $0xffffffffffffffff,0x118(%rsp)
  5ade1b:	00 ff ff ff ff 
  5ade20:	ff 15 ca c0 53 00    	call   *0x53c0ca(%rip)        # ae9ef0 <_DYNAMIC+0x340>
  5ade26:	bf f0 00 00 00       	mov    $0xf0,%edi
  5ade2b:	be 08 00 00 00       	mov    $0x8,%esi
  5ade30:	ff 15 ba bf 53 00    	call   *0x53bfba(%rip)        # ae9df0 <_DYNAMIC+0x240>
  5ade36:	48 85 c0             	test   %rax,%rax
  5ade39:	0f 84 84 1a 00 00    	je     5af8c3 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5893>
  5ade3f:	48 89 c3             	mov    %rax,%rbx
  5ade42:	48 8d b4 24 a0 00 00 	lea    0xa0(%rsp),%rsi
  5ade49:	00 
  5ade4a:	ba f0 00 00 00       	mov    $0xf0,%edx
  5ade4f:	48 89 c7             	mov    %rax,%rdi
  5ade52:	ff 15 f8 bf 53 00    	call   *0x53bff8(%rip)        # ae9e50 <memcpy@GLIBC_2.14>
  5ade58:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  5ade5d:	48 89 98 10 08 00 00 	mov    %rbx,0x810(%rax)
  5ade64:	4d 85 f6             	test   %r14,%r14
  5ade67:	74 38                	je     5adea1 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x3e71>
  5ade69:	4a 8d 04 f5 00 00 00 	lea    0x0(,%r14,8),%rax
  5ade70:	00 
  5ade71:	48 8d 1c 40          	lea    (%rax,%rax,2),%rbx
  5ade75:	ff 15 75 c0 53 00    	call   *0x53c075(%rip)        # ae9ef0 <_DYNAMIC+0x340>
  5ade7b:	be 08 00 00 00       	mov    $0x8,%esi
  5ade80:	48 89 df             	mov    %rbx,%rdi
  5ade83:	ff 15 67 bf 53 00    	call   *0x53bf67(%rip)        # ae9df0 <_DYNAMIC+0x240>
  5ade89:	48 85 c0             	test   %rax,%rax
  5ade8c:	75 18                	jne    5adea6 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x3e76>
  5ade8e:	bf 08 00 00 00       	mov    $0x8,%edi
  5ade93:	48 89 de             	mov    %rbx,%rsi
  5ade96:	ff 15 5c c0 53 00    	call   *0x53c05c(%rip)        # ae9ef8 <_DYNAMIC+0x348>
  5ade9c:	e9 2b 1d 00 00       	jmp    5afbcc <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5b9c>
  5adea1:	b8 08 00 00 00       	mov    $0x8,%eax
  5adea6:	48 8b bc 24 40 04 00 	mov    0x440(%rsp),%rdi
  5adead:	00 
  5adeae:	4c 8b a4 24 48 04 00 	mov    0x448(%rsp),%r12
  5adeb5:	00 
  5adeb6:	4d 6b c6 38          	imul   $0x38,%r14,%r8
  5adeba:	4d 01 e0             	add    %r12,%r8
  5adebd:	48 8b 8c 24 b8 02 00 	mov    0x2b8(%rsp),%rcx
  5adec4:	00 
  5adec5:	48 8b 94 24 c0 02 00 	mov    0x2c0(%rsp),%rdx
  5adecc:	00 
  5adecd:	4c 8b 8c 24 c8 02 00 	mov    0x2c8(%rsp),%r9
  5aded4:	00 
  5aded5:	49 c1 e1 04          	shl    $0x4,%r9
  5aded9:	49 01 d1             	add    %rdx,%r9
  5adedc:	4c 89 b4 24 a0 04 00 	mov    %r14,0x4a0(%rsp)
  5adee3:	00 
  5adee4:	48 89 84 24 a8 04 00 	mov    %rax,0x4a8(%rsp)
  5adeeb:	00 
  5adeec:	48 c7 84 24 b0 04 00 	movq   $0x0,0x4b0(%rsp)
  5adef3:	00 00 00 00 00 
  5adef8:	0f 57 c0             	xorps  %xmm0,%xmm0
  5adefb:	0f 11 84 24 e0 00 00 	movups %xmm0,0xe0(%rsp)
  5adf02:	00 
  5adf03:	4c 89 a4 24 a0 00 00 	mov    %r12,0xa0(%rsp)
  5adf0a:	00 
  5adf0b:	4c 89 a4 24 a8 00 00 	mov    %r12,0xa8(%rsp)
  5adf12:	00 
  5adf13:	48 89 7c 24 58       	mov    %rdi,0x58(%rsp)
  5adf18:	48 89 bc 24 b0 00 00 	mov    %rdi,0xb0(%rsp)
  5adf1f:	00 
  5adf20:	4c 89 44 24 60       	mov    %r8,0x60(%rsp)
  5adf25:	4c 89 84 24 b8 00 00 	mov    %r8,0xb8(%rsp)
  5adf2c:	00 
  5adf2d:	48 89 94 24 c0 00 00 	mov    %rdx,0xc0(%rsp)
  5adf34:	00 
  5adf35:	48 89 54 24 50       	mov    %rdx,0x50(%rsp)
  5adf3a:	48 89 94 24 c8 00 00 	mov    %rdx,0xc8(%rsp)
  5adf41:	00 
  5adf42:	48 89 4c 24 30       	mov    %rcx,0x30(%rsp)
  5adf47:	48 89 8c 24 d0 00 00 	mov    %rcx,0xd0(%rsp)
  5adf4e:	00 
  5adf4f:	4c 89 4c 24 18       	mov    %r9,0x18(%rsp)
  5adf54:	4c 89 8c 24 d8 00 00 	mov    %r9,0xd8(%rsp)
  5adf5b:	00 
  5adf5c:	4c 89 64 24 38       	mov    %r12,0x38(%rsp)
  5adf61:	4d 85 f6             	test   %r14,%r14
  5adf64:	0f 84 47 08 00 00    	je     5ae7b1 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4781>
  5adf6a:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
  5adf6f:	48 8b 54 24 50       	mov    0x50(%rsp),%rdx
  5adf74:	eb 40                	jmp    5adfb6 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x3f86>
  5adf76:	48 8b 84 24 a8 04 00 	mov    0x4a8(%rsp),%rax
  5adf7d:	00 
  5adf7e:	48 8d 0c 5b          	lea    (%rbx,%rbx,2),%rcx
  5adf82:	4c 89 2c c8          	mov    %r13,(%rax,%rcx,8)
  5adf86:	0f 28 44 24 20       	movaps 0x20(%rsp),%xmm0
  5adf8b:	0f 11 44 c8 08       	movups %xmm0,0x8(%rax,%rcx,8)
  5adf90:	48 ff c3             	inc    %rbx
  5adf93:	48 89 9c 24 b0 04 00 	mov    %rbx,0x4b0(%rsp)
  5adf9a:	00 
  5adf9b:	48 8b 4c 24 70       	mov    0x70(%rsp),%rcx
  5adfa0:	48 89 c8             	mov    %rcx,%rax
  5adfa3:	48 8b 94 24 98 00 00 	mov    0x98(%rsp),%rdx
  5adfaa:	00 
  5adfab:	48 3b 4c 24 60       	cmp    0x60(%rsp),%rcx
  5adfb0:	0f 84 82 08 00 00    	je     5ae838 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4808>
  5adfb6:	4c 8d 60 38          	lea    0x38(%rax),%r12
  5adfba:	4c 89 a4 24 a8 00 00 	mov    %r12,0xa8(%rsp)
  5adfc1:	00 
  5adfc2:	4c 8b 38             	mov    (%rax),%r15
  5adfc5:	49 83 ff fe          	cmp    $0xfffffffffffffffe,%r15
  5adfc9:	0f 84 e2 07 00 00    	je     5ae7b1 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4781>
  5adfcf:	48 8b 68 08          	mov    0x8(%rax),%rbp
  5adfd3:	48 8b 58 18          	mov    0x18(%rax),%rbx
  5adfd7:	4c 8b 70 20          	mov    0x20(%rax),%r14
  5adfdb:	48 3b 54 24 18       	cmp    0x18(%rsp),%rdx
  5adfe0:	0f 84 93 07 00 00    	je     5ae779 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4749>
  5adfe6:	48 8b 48 10          	mov    0x10(%rax),%rcx
  5adfea:	48 8d 72 10          	lea    0x10(%rdx),%rsi
  5adfee:	48 89 b4 24 98 00 00 	mov    %rsi,0x98(%rsp)
  5adff5:	00 
  5adff6:	48 89 b4 24 c8 00 00 	mov    %rsi,0xc8(%rsp)
  5adffd:	00 
  5adffe:	f3 0f 6f 02          	movdqu (%rdx),%xmm0
  5ae002:	66 0f 7f 84 24 a0 07 	movdqa %xmm0,0x7a0(%rsp)
  5ae009:	00 00 
  5ae00b:	8b 78 30             	mov    0x30(%rax),%edi
  5ae00e:	48 8b b4 24 28 02 00 	mov    0x228(%rsp),%rsi
  5ae015:	00 
  5ae016:	48 39 fe             	cmp    %rdi,%rsi
  5ae019:	0f 86 e0 19 00 00    	jbe    5af9ff <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x59cf>
  5ae01f:	48 8b 94 24 20 02 00 	mov    0x220(%rsp),%rdx
  5ae026:	00 
  5ae027:	48 8d 34 bf          	lea    (%rdi,%rdi,4),%rsi
  5ae02b:	48 8b 14 f2          	mov    (%rdx,%rsi,8),%rdx
  5ae02f:	48 89 54 24 08       	mov    %rdx,0x8(%rsp)
  5ae034:	48 8b 54 24 10       	mov    0x10(%rsp),%rdx
  5ae039:	48 8b b2 10 08 00 00 	mov    0x810(%rdx),%rsi
  5ae040:	48 8b 56 10          	mov    0x10(%rsi),%rdx
  5ae044:	48 85 d2             	test   %rdx,%rdx
  5ae047:	4c 89 64 24 70       	mov    %r12,0x70(%rsp)
  5ae04c:	74 53                	je     5ae0a1 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4071>
  5ae04e:	4c 8b 5e 08          	mov    0x8(%rsi),%r11
  5ae052:	48 83 fa 01          	cmp    $0x1,%rdx
  5ae056:	75 0c                	jne    5ae064 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4034>
  5ae058:	48 8b 54 24 08       	mov    0x8(%rsp),%rdx
  5ae05d:	49 39 13             	cmp    %rdx,(%r11)
  5ae060:	74 42                	je     5ae0a4 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4074>
  5ae062:	eb 3d                	jmp    5ae0a1 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4071>
  5ae064:	31 f6                	xor    %esi,%esi
  5ae066:	4c 8b 54 24 08       	mov    0x8(%rsp),%r10
  5ae06b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
  5ae070:	48 89 f7             	mov    %rsi,%rdi
  5ae073:	49 89 d0             	mov    %rdx,%r8
  5ae076:	49 d1 e8             	shr    $1,%r8
  5ae079:	4c 01 c6             	add    %r8,%rsi
  5ae07c:	4c 8d 0c 76          	lea    (%rsi,%rsi,2),%r9
  5ae080:	4f 39 14 cb          	cmp    %r10,(%r11,%r9,8)
  5ae084:	48 0f 47 f7          	cmova  %rdi,%rsi
  5ae088:	4c 29 c2             	sub    %r8,%rdx
  5ae08b:	48 83 fa 01          	cmp    $0x1,%rdx
  5ae08f:	77 df                	ja     5ae070 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4040>
  5ae091:	48 8d 14 76          	lea    (%rsi,%rsi,2),%rdx
  5ae095:	4d 39 14 d3          	cmp    %r10,(%r11,%rdx,8)
  5ae099:	75 06                	jne    5ae0a1 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4071>
  5ae09b:	4d 8d 1c d3          	lea    (%r11,%rdx,8),%r11
  5ae09f:	eb 03                	jmp    5ae0a4 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4074>
  5ae0a1:	45 31 db             	xor    %r11d,%r11d
  5ae0a4:	4c 89 5c 24 40       	mov    %r11,0x40(%rsp)
  5ae0a9:	48 8b 40 28          	mov    0x28(%rax),%rax
  5ae0ad:	66 0f ef c0          	pxor   %xmm0,%xmm0
  5ae0b1:	66 0f 7f 84 24 70 05 	movdqa %xmm0,0x570(%rsp)
  5ae0b8:	00 00 
  5ae0ba:	4c 89 bc 24 10 03 00 	mov    %r15,0x310(%rsp)
  5ae0c1:	00 
  5ae0c2:	48 89 ac 24 18 03 00 	mov    %rbp,0x318(%rsp)
  5ae0c9:	00 
  5ae0ca:	48 89 8c 24 20 03 00 	mov    %rcx,0x320(%rsp)
  5ae0d1:	00 
  5ae0d2:	48 89 9c 24 28 03 00 	mov    %rbx,0x328(%rsp)
  5ae0d9:	00 
  5ae0da:	4c 89 b4 24 30 03 00 	mov    %r14,0x330(%rsp)
  5ae0e1:	00 
  5ae0e2:	48 89 84 24 38 03 00 	mov    %rax,0x338(%rsp)
  5ae0e9:	00 
  5ae0ea:	48 c7 84 24 08 03 00 	movq   $0x2,0x308(%rsp)
  5ae0f1:	00 02 00 00 00 
  5ae0f6:	48 c7 84 24 40 03 00 	movq   $0x0,0x340(%rsp)
  5ae0fd:	00 00 00 00 00 
  5ae102:	41 bf 02 00 00 00    	mov    $0x2,%r15d
  5ae108:	31 c9                	xor    %ecx,%ecx
  5ae10a:	4c 8d a4 24 10 03 00 	lea    0x310(%rsp),%r12
  5ae111:	00 
  5ae112:	4c 8b 6c 24 08       	mov    0x8(%rsp),%r13
  5ae117:	eb 23                	jmp    5ae13c <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x410c>
  5ae119:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  5ae120:	48 8b 84 24 00 03 00 	mov    0x300(%rsp),%rax
  5ae127:	00 
  5ae128:	4c 8b bc 24 08 03 00 	mov    0x308(%rsp),%r15
  5ae12f:	00 
  5ae130:	48 89 c1             	mov    %rax,%rcx
  5ae133:	49 39 c7             	cmp    %rax,%r15
  5ae136:	0f 84 41 05 00 00    	je     5ae67d <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x464d>
  5ae13c:	48 8d 41 01          	lea    0x1(%rcx),%rax
  5ae140:	48 89 84 24 00 03 00 	mov    %rax,0x300(%rsp)
  5ae147:	00 
  5ae148:	48 8d 0c 49          	lea    (%rcx,%rcx,2),%rcx
  5ae14c:	4d 8b 34 cc          	mov    (%r12,%rcx,8),%r14
  5ae150:	49 83 fe fe          	cmp    $0xfffffffffffffffe,%r14
  5ae154:	0f 84 1e 05 00 00    	je     5ae678 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4648>
  5ae15a:	48 8b 9c 24 40 03 00 	mov    0x340(%rsp),%rbx
  5ae161:	00 
  5ae162:	48 8d 53 01          	lea    0x1(%rbx),%rdx
  5ae166:	48 89 94 24 40 03 00 	mov    %rdx,0x340(%rsp)
  5ae16d:	00 
  5ae16e:	49 83 fe ff          	cmp    $0xffffffffffffffff,%r14
  5ae172:	74 bc                	je     5ae130 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4100>
  5ae174:	49 8d 04 cc          	lea    (%r12,%rcx,8),%rax
  5ae178:	48 8b 70 08          	mov    0x8(%rax),%rsi
  5ae17c:	48 8b 40 10          	mov    0x10(%rax),%rax
  5ae180:	48 b9 01 00 00 00 00 	movabs $0x8000000000000001,%rcx
  5ae187:	00 00 80 
  5ae18a:	48 ff c1             	inc    %rcx
  5ae18d:	49 39 ce             	cmp    %rcx,%r14
  5ae190:	48 89 74 24 20       	mov    %rsi,0x20(%rsp)
  5ae195:	0f 85 d5 00 00 00    	jne    5ae270 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4240>
  5ae19b:	48 8d bc 24 00 04 00 	lea    0x400(%rsp),%rdi
  5ae1a2:	00 
  5ae1a3:	ff 50 28             	call   *0x28(%rax)
  5ae1a6:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  5ae1ab:	48 85 f6             	test   %rsi,%rsi
  5ae1ae:	0f 84 e6 00 00 00    	je     5ae29a <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x426a>
  5ae1b4:	31 c9                	xor    %ecx,%ecx
  5ae1b6:	48 85 db             	test   %rbx,%rbx
  5ae1b9:	0f 95 c1             	setne  %cl
  5ae1bc:	48 83 7c ce 08 00    	cmpq   $0x0,0x8(%rsi,%rcx,8)
  5ae1c2:	48 8b 54 24 10       	mov    0x10(%rsp),%rdx
  5ae1c7:	48 8b 82 00 09 00 00 	mov    0x900(%rdx),%rax
  5ae1ce:	0f 84 d2 00 00 00    	je     5ae2a6 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4276>
  5ae1d4:	48 8d 0c cd 08 00 00 	lea    0x8(,%rcx,8),%rcx
  5ae1db:	00 
  5ae1dc:	48 ff c0             	inc    %rax
  5ae1df:	48 89 82 00 09 00 00 	mov    %rax,0x900(%rdx)
  5ae1e6:	48 8b 94 24 10 04 00 	mov    0x410(%rsp),%rdx
  5ae1ed:	00 
  5ae1ee:	48 8b 2c 0e          	mov    (%rsi,%rcx,1),%rbp
  5ae1f2:	4c 8b 7d 00          	mov    0x0(%rbp),%r15
  5ae1f6:	4c 89 f8             	mov    %r15,%rax
  5ae1f9:	48 d1 e8             	shr    $1,%rax
  5ae1fc:	48 39 d0             	cmp    %rdx,%rax
  5ae1ff:	0f 85 ab 00 00 00    	jne    5ae2b0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4280>
  5ae205:	48 8b b4 24 08 04 00 	mov    0x408(%rsp),%rsi
  5ae20c:	00 
  5ae20d:	48 8d 7d 10          	lea    0x10(%rbp),%rdi
  5ae211:	ff 15 29 bc 53 00    	call   *0x53bc29(%rip)        # ae9e40 <bcmp@GLIBC_2.2.5>
  5ae217:	85 c0                	test   %eax,%eax
  5ae219:	0f 85 91 00 00 00    	jne    5ae2b0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4280>
  5ae21f:	41 f6 c7 01          	test   $0x1,%r15b
  5ae223:	75 30                	jne    5ae255 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4225>
  5ae225:	48 8b 45 08          	mov    0x8(%rbp),%rax
  5ae229:	a8 01                	test   $0x1,%al
  5ae22b:	75 28                	jne    5ae255 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4225>
  5ae22d:	b8 02 00 00 00       	mov    $0x2,%eax
  5ae232:	f0 48 0f c1 45 08    	lock xadd %rax,0x8(%rbp)
  5ae238:	48 b9 01 00 00 00 00 	movabs $0x8000000000000001,%rcx
  5ae23f:	00 00 80 
  5ae242:	48 21 c8             	and    %rcx,%rax
  5ae245:	48 3b 84 24 50 02 00 	cmp    0x250(%rsp),%rax
  5ae24c:	00 
  5ae24d:	75 06                	jne    5ae255 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4225>
  5ae24f:	f0 48 83 4d 08 01    	lock orq $0x1,0x8(%rbp)
  5ae255:	48 83 fb 01          	cmp    $0x1,%rbx
  5ae259:	0f 86 81 03 00 00    	jbe    5ae5e0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x45b0>
  5ae25f:	e9 50 18 00 00       	jmp    5afab4 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5a84>
  5ae264:	66 66 66 2e 0f 1f 84 	data16 data16 cs nopw 0x0(%rax,%rax,1)
  5ae26b:	00 00 00 00 00 
  5ae270:	48 89 b4 24 08 04 00 	mov    %rsi,0x408(%rsp)
  5ae277:	00 
  5ae278:	48 89 84 24 10 04 00 	mov    %rax,0x410(%rsp)
  5ae27f:	00 
  5ae280:	48 c7 84 24 00 04 00 	movq   $0xffffffffffffffff,0x400(%rsp)
  5ae287:	00 ff ff ff ff 
  5ae28c:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  5ae291:	48 85 f6             	test   %rsi,%rsi
  5ae294:	0f 85 1a ff ff ff    	jne    5ae1b4 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4184>
  5ae29a:	48 8b 54 24 10       	mov    0x10(%rsp),%rdx
  5ae29f:	48 8b 82 00 09 00 00 	mov    0x900(%rdx),%rax
  5ae2a6:	48 ff c0             	inc    %rax
  5ae2a9:	48 89 82 00 09 00 00 	mov    %rax,0x900(%rdx)
  5ae2b0:	48 83 fb 02          	cmp    $0x2,%rbx
  5ae2b4:	0f 83 1e 16 00 00    	jae    5af8d8 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x58a8>
  5ae2ba:	4c 8b ac dc a0 07 00 	mov    0x7a0(%rsp,%rbx,8),%r13
  5ae2c1:	00 
  5ae2c2:	4d 85 ed             	test   %r13,%r13
  5ae2c5:	0f 84 85 00 00 00    	je     5ae350 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4320>
  5ae2cb:	48 8b 84 24 58 04 00 	mov    0x458(%rsp),%rax
  5ae2d2:	00 
  5ae2d3:	48 85 c0             	test   %rax,%rax
  5ae2d6:	0f 84 50 01 00 00    	je     5ae42c <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x43fc>
  5ae2dc:	48 8b 8c 24 60 04 00 	mov    0x460(%rsp),%rcx
  5ae2e3:	00 
  5ae2e4:	0f b7 b0 ba 00 00 00 	movzwl 0xba(%rax),%esi
  5ae2eb:	89 f7                	mov    %esi,%edi
  5ae2ed:	c1 e7 03             	shl    $0x3,%edi
  5ae2f0:	48 c7 c2 ff ff ff ff 	mov    $0xffffffffffffffff,%rdx
  5ae2f7:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
  5ae2fe:	00 00 
  5ae300:	48 85 ff             	test   %rdi,%rdi
  5ae303:	74 2b                	je     5ae330 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4300>
  5ae305:	4c 3b 6c d0 10       	cmp    0x10(%rax,%rdx,8),%r13
  5ae30a:	41 0f 97 c0          	seta   %r8b
  5ae30e:	41 80 d8 00          	sbb    $0x0,%r8b
  5ae312:	48 ff c2             	inc    %rdx
  5ae315:	48 83 c7 f8          	add    $0xfffffffffffffff8,%rdi
  5ae319:	41 80 f8 01          	cmp    $0x1,%r8b
  5ae31d:	74 e1                	je     5ae300 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x42d0>
  5ae31f:	41 0f b6 f0          	movzbl %r8b,%esi
  5ae323:	85 f6                	test   %esi,%esi
  5ae325:	75 0c                	jne    5ae333 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4303>
  5ae327:	e9 b4 00 00 00       	jmp    5ae3e0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x43b0>
  5ae32c:	0f 1f 40 00          	nopl   0x0(%rax)
  5ae330:	48 89 f2             	mov    %rsi,%rdx
  5ae333:	48 83 e9 01          	sub    $0x1,%rcx
  5ae337:	0f 82 ef 00 00 00    	jb     5ae42c <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x43fc>
  5ae33d:	48 8b 84 d0 c0 00 00 	mov    0xc0(%rax,%rdx,8),%rax
  5ae344:	00 
  5ae345:	eb 9d                	jmp    5ae2e4 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x42b4>
  5ae347:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
  5ae34e:	00 00 
  5ae350:	4c 8b a4 24 10 04 00 	mov    0x410(%rsp),%r12
  5ae357:	00 
  5ae358:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  5ae35d:	f3 0f 6f 80 08 09 00 	movdqu 0x908(%rax),%xmm0
  5ae364:	00 
  5ae365:	66 49 0f 6e cc       	movq   %r12,%xmm1
  5ae36a:	66 0f 6f 15 8e ea ab 	movdqa -0x541572(%rip),%xmm2        # 6ce00 <anon.5f884de6e78125e25881320d811d32df.391.llvm.17146438997930651657+0xd80>
  5ae371:	ff 
  5ae372:	66 0f 6c d1          	punpcklqdq %xmm1,%xmm2
  5ae376:	66 0f d4 d0          	paddq  %xmm0,%xmm2
  5ae37a:	f3 0f 7f 90 08 09 00 	movdqu %xmm2,0x908(%rax)
  5ae381:	00 
  5ae382:	48 8d 2d 37 f4 ab ff 	lea    -0x540bc9(%rip),%rbp        # 6d7c0 <anon.1f6b7bab1fc61e0fcd36456038a862fb.80.llvm.5148459089407822190>
  5ae389:	4d 85 e4             	test   %r12,%r12
  5ae38c:	0f 84 4e 02 00 00    	je     5ae5e0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x45b0>
  5ae392:	4c 8b bc 24 08 04 00 	mov    0x408(%rsp),%r15
  5ae399:	00 
  5ae39a:	48 8d bc 24 90 01 00 	lea    0x190(%rsp),%rdi
  5ae3a1:	00 
  5ae3a2:	4c 89 e6             	mov    %r12,%rsi
  5ae3a5:	31 d2                	xor    %edx,%edx
  5ae3a7:	31 c9                	xor    %ecx,%ecx
  5ae3a9:	ff 15 99 ba 53 00    	call   *0x53ba99(%rip)        # ae9e48 <_DYNAMIC+0x298>
  5ae3af:	48 8b bc 24 90 01 00 	mov    0x190(%rsp),%rdi
  5ae3b6:	00 
  5ae3b7:	48 83 ff ff          	cmp    $0xffffffffffffffff,%rdi
  5ae3bb:	0f 85 4b 15 00 00    	jne    5af90c <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x58dc>
  5ae3c1:	48 8b ac 24 98 01 00 	mov    0x198(%rsp),%rbp
  5ae3c8:	00 
  5ae3c9:	48 8d 7d 10          	lea    0x10(%rbp),%rdi
  5ae3cd:	4c 89 fe             	mov    %r15,%rsi
  5ae3d0:	4c 89 e2             	mov    %r12,%rdx
  5ae3d3:	ff 15 77 ba 53 00    	call   *0x53ba77(%rip)        # ae9e50 <memcpy@GLIBC_2.14>
  5ae3d9:	e9 02 02 00 00       	jmp    5ae5e0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x45b0>
  5ae3de:	66 90                	xchg   %ax,%ax
  5ae3e0:	48 8b 6c d0 60       	mov    0x60(%rax,%rdx,8),%rbp
  5ae3e5:	f6 45 00 01          	testb  $0x1,0x0(%rbp)
  5ae3e9:	0f 85 f1 01 00 00    	jne    5ae5e0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x45b0>
  5ae3ef:	48 8b 45 08          	mov    0x8(%rbp),%rax
  5ae3f3:	a8 01                	test   $0x1,%al
  5ae3f5:	0f 85 e5 01 00 00    	jne    5ae5e0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x45b0>
  5ae3fb:	b8 02 00 00 00       	mov    $0x2,%eax
  5ae400:	f0 48 0f c1 45 08    	lock xadd %rax,0x8(%rbp)
  5ae406:	48 b9 01 00 00 00 00 	movabs $0x8000000000000001,%rcx
  5ae40d:	00 00 80 
  5ae410:	48 21 c8             	and    %rcx,%rax
  5ae413:	48 3b 84 24 50 02 00 	cmp    0x250(%rsp),%rax
  5ae41a:	00 
  5ae41b:	0f 85 bf 01 00 00    	jne    5ae5e0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x45b0>
  5ae421:	f0 48 83 4d 08 01    	lock orq $0x1,0x8(%rbp)
  5ae427:	e9 b4 01 00 00       	jmp    5ae5e0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x45b0>
  5ae42c:	4c 8b a4 24 10 04 00 	mov    0x410(%rsp),%r12
  5ae433:	00 
  5ae434:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  5ae439:	f3 0f 6f 80 08 09 00 	movdqu 0x908(%rax),%xmm0
  5ae440:	00 
  5ae441:	66 49 0f 6e cc       	movq   %r12,%xmm1
  5ae446:	66 0f 6f 15 b2 e9 ab 	movdqa -0x54164e(%rip),%xmm2        # 6ce00 <anon.5f884de6e78125e25881320d811d32df.391.llvm.17146438997930651657+0xd80>
  5ae44d:	ff 
  5ae44e:	66 0f 6c d1          	punpcklqdq %xmm1,%xmm2
  5ae452:	66 0f d4 d0          	paddq  %xmm0,%xmm2
  5ae456:	f3 0f 7f 90 08 09 00 	movdqu %xmm2,0x908(%rax)
  5ae45d:	00 
  5ae45e:	48 8d 2d 5b f3 ab ff 	lea    -0x540ca5(%rip),%rbp        # 6d7c0 <anon.1f6b7bab1fc61e0fcd36456038a862fb.80.llvm.5148459089407822190>
  5ae465:	4d 85 e4             	test   %r12,%r12
  5ae468:	74 47                	je     5ae4b1 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4481>
  5ae46a:	4c 8b bc 24 08 04 00 	mov    0x408(%rsp),%r15
  5ae471:	00 
  5ae472:	48 8d bc 24 90 01 00 	lea    0x190(%rsp),%rdi
  5ae479:	00 
  5ae47a:	4c 89 e6             	mov    %r12,%rsi
  5ae47d:	31 d2                	xor    %edx,%edx
  5ae47f:	31 c9                	xor    %ecx,%ecx
  5ae481:	ff 15 c1 b9 53 00    	call   *0x53b9c1(%rip)        # ae9e48 <_DYNAMIC+0x298>
  5ae487:	48 8b bc 24 90 01 00 	mov    0x190(%rsp),%rdi
  5ae48e:	00 
  5ae48f:	48 83 ff ff          	cmp    $0xffffffffffffffff,%rdi
  5ae493:	0f 85 73 14 00 00    	jne    5af90c <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x58dc>
  5ae499:	48 8b ac 24 98 01 00 	mov    0x198(%rsp),%rbp
  5ae4a0:	00 
  5ae4a1:	48 8d 7d 10          	lea    0x10(%rbp),%rdi
  5ae4a5:	4c 89 fe             	mov    %r15,%rsi
  5ae4a8:	4c 89 e2             	mov    %r12,%rdx
  5ae4ab:	ff 15 9f b9 53 00    	call   *0x53b99f(%rip)        # ae9e50 <memcpy@GLIBC_2.14>
  5ae4b1:	f6 45 00 01          	testb  $0x1,0x0(%rbp)
  5ae4b5:	75 30                	jne    5ae4e7 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x44b7>
  5ae4b7:	48 8b 45 08          	mov    0x8(%rbp),%rax
  5ae4bb:	a8 01                	test   $0x1,%al
  5ae4bd:	75 28                	jne    5ae4e7 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x44b7>
  5ae4bf:	b8 02 00 00 00       	mov    $0x2,%eax
  5ae4c4:	f0 48 0f c1 45 08    	lock xadd %rax,0x8(%rbp)
  5ae4ca:	48 b9 01 00 00 00 00 	movabs $0x8000000000000001,%rcx
  5ae4d1:	00 00 80 
  5ae4d4:	48 21 c8             	and    %rcx,%rax
  5ae4d7:	48 3b 84 24 50 02 00 	cmp    0x250(%rsp),%rax
  5ae4de:	00 
  5ae4df:	75 06                	jne    5ae4e7 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x44b7>
  5ae4e1:	f0 48 83 4d 08 01    	lock orq $0x1,0x8(%rbp)
  5ae4e7:	48 8b 84 24 58 04 00 	mov    0x458(%rsp),%rax
  5ae4ee:	00 
  5ae4ef:	48 85 c0             	test   %rax,%rax
  5ae4f2:	0f 84 92 00 00 00    	je     5ae58a <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x455a>
  5ae4f8:	48 8b 8c 24 60 04 00 	mov    0x460(%rsp),%rcx
  5ae4ff:	00 
  5ae500:	0f b7 b0 ba 00 00 00 	movzwl 0xba(%rax),%esi
  5ae507:	89 f7                	mov    %esi,%edi
  5ae509:	c1 e7 03             	shl    $0x3,%edi
  5ae50c:	48 c7 c2 ff ff ff ff 	mov    $0xffffffffffffffff,%rdx
  5ae513:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  5ae51a:	84 00 00 00 00 00 
  5ae520:	48 85 ff             	test   %rdi,%rdi
  5ae523:	74 24                	je     5ae549 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4519>
  5ae525:	4c 3b 6c d0 10       	cmp    0x10(%rax,%rdx,8),%r13
  5ae52a:	41 0f 97 c0          	seta   %r8b
  5ae52e:	41 80 d8 00          	sbb    $0x0,%r8b
  5ae532:	48 ff c2             	inc    %rdx
  5ae535:	48 83 c7 f8          	add    $0xfffffffffffffff8,%rdi
  5ae539:	41 80 f8 01          	cmp    $0x1,%r8b
  5ae53d:	74 e1                	je     5ae520 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x44f0>
  5ae53f:	41 0f b6 f0          	movzbl %r8b,%esi
  5ae543:	85 f6                	test   %esi,%esi
  5ae545:	75 05                	jne    5ae54c <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x451c>
  5ae547:	eb 13                	jmp    5ae55c <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x452c>
  5ae549:	48 89 f2             	mov    %rsi,%rdx
  5ae54c:	48 83 e9 01          	sub    $0x1,%rcx
  5ae550:	72 3a                	jb     5ae58c <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x455c>
  5ae552:	48 8b 84 d0 c0 00 00 	mov    0xc0(%rax,%rdx,8),%rax
  5ae559:	00 
  5ae55a:	eb a4                	jmp    5ae500 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x44d0>
  5ae55c:	48 8b 7c d0 60       	mov    0x60(%rax,%rdx,8),%rdi
  5ae561:	48 89 6c d0 60       	mov    %rbp,0x60(%rax,%rdx,8)
  5ae566:	f6 07 01             	testb  $0x1,(%rdi)
  5ae569:	75 75                	jne    5ae5e0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x45b0>
  5ae56b:	48 8b 47 08          	mov    0x8(%rdi),%rax
  5ae56f:	a8 01                	test   $0x1,%al
  5ae571:	75 6d                	jne    5ae5e0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x45b0>
  5ae573:	48 8d 47 08          	lea    0x8(%rdi),%rax
  5ae577:	f0 48 83 28 02       	lock subq $0x2,(%rax)
  5ae57c:	75 62                	jne    5ae5e0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x45b0>
  5ae57e:	48 8b 47 08          	mov    0x8(%rdi),%rax
  5ae582:	ff 15 d0 b8 53 00    	call   *0x53b8d0(%rip)        # ae9e58 <_DYNAMIC+0x2a8>
  5ae588:	eb 56                	jmp    5ae5e0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x45b0>
  5ae58a:	31 c0                	xor    %eax,%eax
  5ae58c:	4c 89 ac 24 90 01 00 	mov    %r13,0x190(%rsp)
  5ae593:	00 
  5ae594:	48 8d 8c 24 58 04 00 	lea    0x458(%rsp),%rcx
  5ae59b:	00 
  5ae59c:	48 89 8c 24 98 01 00 	mov    %rcx,0x198(%rsp)
  5ae5a3:	00 
  5ae5a4:	48 89 84 24 a0 01 00 	mov    %rax,0x1a0(%rsp)
  5ae5ab:	00 
  5ae5ac:	48 c7 84 24 a8 01 00 	movq   $0x0,0x1a8(%rsp)
  5ae5b3:	00 00 00 00 00 
  5ae5b8:	48 89 94 24 b0 01 00 	mov    %rdx,0x1b0(%rsp)
  5ae5bf:	00 
  5ae5c0:	48 8d bc 24 b0 03 00 	lea    0x3b0(%rsp),%rdi
  5ae5c7:	00 
  5ae5c8:	48 8d b4 24 90 01 00 	lea    0x190(%rsp),%rsi
  5ae5cf:	00 
  5ae5d0:	48 89 ea             	mov    %rbp,%rdx
  5ae5d3:	e8 98 a0 1c 00       	call   778670 <_RNvMs4_NtNtNtNtCscdodAO9FK5_5alloc11collections5btree3map5entryINtB5_11VacantEntryNtNtCs6gaF1xUz9Bf_4gpui6source7FieldIdNtNtB1m_11shared_text10SharedTextE12insert_entryB1m_>
  5ae5d8:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  5ae5df:	00 
  5ae5e0:	48 8b bc dc 70 05 00 	mov    0x570(%rsp,%rbx,8),%rdi
  5ae5e7:	00 
  5ae5e8:	48 85 ff             	test   %rdi,%rdi
  5ae5eb:	74 23                	je     5ae610 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x45e0>
  5ae5ed:	f6 07 01             	testb  $0x1,(%rdi)
  5ae5f0:	75 1e                	jne    5ae610 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x45e0>
  5ae5f2:	48 8b 47 08          	mov    0x8(%rdi),%rax
  5ae5f6:	a8 01                	test   $0x1,%al
  5ae5f8:	75 16                	jne    5ae610 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x45e0>
  5ae5fa:	48 8d 47 08          	lea    0x8(%rdi),%rax
  5ae5fe:	f0 48 83 28 02       	lock subq $0x2,(%rax)
  5ae603:	74 67                	je     5ae66c <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x463c>
  5ae605:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
  5ae60c:	00 00 00 00 
  5ae610:	48 89 ac dc 70 05 00 	mov    %rbp,0x570(%rsp,%rbx,8)
  5ae617:	00 
  5ae618:	48 8b b4 24 00 04 00 	mov    0x400(%rsp),%rsi
  5ae61f:	00 
  5ae620:	48 83 fe ff          	cmp    $0xffffffffffffffff,%rsi
  5ae624:	74 18                	je     5ae63e <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x460e>
  5ae626:	48 85 f6             	test   %rsi,%rsi
  5ae629:	74 13                	je     5ae63e <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x460e>
  5ae62b:	48 8b bc 24 08 04 00 	mov    0x408(%rsp),%rdi
  5ae632:	00 
  5ae633:	ba 01 00 00 00       	mov    $0x1,%edx
  5ae638:	ff 15 ba b7 53 00    	call   *0x53b7ba(%rip)        # ae9df8 <_DYNAMIC+0x248>
  5ae63e:	4d 85 f6             	test   %r14,%r14
  5ae641:	4c 8d a4 24 10 03 00 	lea    0x310(%rsp),%r12
  5ae648:	00 
  5ae649:	4c 8b 6c 24 08       	mov    0x8(%rsp),%r13
  5ae64e:	0f 8e cc fa ff ff    	jle    5ae120 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x40f0>
  5ae654:	ba 01 00 00 00       	mov    $0x1,%edx
  5ae659:	48 8b 7c 24 20       	mov    0x20(%rsp),%rdi
  5ae65e:	4c 89 f6             	mov    %r14,%rsi
  5ae661:	ff 15 91 b7 53 00    	call   *0x53b791(%rip)        # ae9df8 <_DYNAMIC+0x248>
  5ae667:	e9 b4 fa ff ff       	jmp    5ae120 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x40f0>
  5ae66c:	48 8b 47 08          	mov    0x8(%rdi),%rax
  5ae670:	ff 15 e2 b7 53 00    	call   *0x53b7e2(%rip)        # ae9e58 <_DYNAMIC+0x2a8>
  5ae676:	eb 98                	jmp    5ae610 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x45e0>
  5ae678:	49 29 c7             	sub    %rax,%r15
  5ae67b:	75 35                	jne    5ae6b2 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4682>
  5ae67d:	0f 28 84 24 70 05 00 	movaps 0x570(%rsp),%xmm0
  5ae684:	00 
  5ae685:	0f 29 44 24 20       	movaps %xmm0,0x20(%rsp)
  5ae68a:	48 8b 9c 24 b0 04 00 	mov    0x4b0(%rsp),%rbx
  5ae691:	00 
  5ae692:	48 3b 9c 24 a0 04 00 	cmp    0x4a0(%rsp),%rbx
  5ae699:	00 
  5ae69a:	0f 85 d6 f8 ff ff    	jne    5adf76 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x3f46>
  5ae6a0:	48 8d bc 24 a0 04 00 	lea    0x4a0(%rsp),%rdi
  5ae6a7:	00 
  5ae6a8:	e8 23 f4 21 00       	call   7cdad0 <_RNvMs3_NtCscdodAO9FK5_5alloc7raw_vecINtB5_6RawVecNtNtNtCs6gaF1xUz9Bf_4gpui7runtime8metadata3RowE8grow_oneBR_>
  5ae6ad:	e9 c4 f8 ff ff       	jmp    5adf76 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x3f46>
  5ae6b2:	49 8d 1c cc          	lea    (%r12,%rcx,8),%rbx
  5ae6b6:	48 83 c3 20          	add    $0x20,%rbx
  5ae6ba:	eb 0d                	jmp    5ae6c9 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4699>
  5ae6bc:	0f 1f 40 00          	nopl   0x0(%rax)
  5ae6c0:	48 83 c3 18          	add    $0x18,%rbx
  5ae6c4:	49 ff cf             	dec    %r15
  5ae6c7:	74 b4                	je     5ae67d <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x464d>
  5ae6c9:	48 8b 73 f8          	mov    -0x8(%rbx),%rsi
  5ae6cd:	48 83 fe ff          	cmp    $0xffffffffffffffff,%rsi
  5ae6d1:	74 ed                	je     5ae6c0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4690>
  5ae6d3:	48 85 f6             	test   %rsi,%rsi
  5ae6d6:	78 e8                	js     5ae6c0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4690>
  5ae6d8:	74 e6                	je     5ae6c0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4690>
  5ae6da:	48 8b 3b             	mov    (%rbx),%rdi
  5ae6dd:	ba 01 00 00 00       	mov    $0x1,%edx
  5ae6e2:	ff 15 10 b7 53 00    	call   *0x53b710(%rip)        # ae9df8 <_DYNAMIC+0x248>
  5ae6e8:	eb d6                	jmp    5ae6c0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4690>
  5ae6ea:	4c 8b 7c 24 08       	mov    0x8(%rsp),%r15
  5ae6ef:	48 8b 84 24 88 00 00 	mov    0x88(%rsp),%rax
  5ae6f6:	00 
  5ae6f7:	48 c7 00 1f 00 00 00 	movq   $0x1f,(%rax)
  5ae6fe:	48 c7 40 08 0c 00 00 	movq   $0xc,0x8(%rax)
  5ae705:	00 
  5ae706:	4c 89 78 10          	mov    %r15,0x10(%rax)
  5ae70a:	48 8b b4 24 b8 02 00 	mov    0x2b8(%rsp),%rsi
  5ae711:	00 
  5ae712:	48 85 f6             	test   %rsi,%rsi
  5ae715:	0f 84 74 0b 00 00    	je     5af28f <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x525f>
  5ae71b:	48 8b bc 24 c0 02 00 	mov    0x2c0(%rsp),%rdi
  5ae722:	00 
  5ae723:	48 c1 e6 04          	shl    $0x4,%rsi
  5ae727:	ba 08 00 00 00       	mov    $0x8,%edx
  5ae72c:	ff 15 c6 b6 53 00    	call   *0x53b6c6(%rip)        # ae9df8 <_DYNAMIC+0x248>
  5ae732:	48 8b 8c 24 30 02 00 	mov    0x230(%rsp),%rcx
  5ae739:	00 
  5ae73a:	48 85 c9             	test   %rcx,%rcx
  5ae73d:	0f 85 5d 0b 00 00    	jne    5af2a0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5270>
  5ae743:	e9 79 c9 ff ff       	jmp    5ab0c1 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1091>
  5ae748:	48 8b 84 24 88 00 00 	mov    0x88(%rsp),%rax
  5ae74f:	00 
  5ae750:	48 c7 00 1f 00 00 00 	movq   $0x1f,(%rax)
  5ae757:	48 c7 40 08 0c 00 00 	movq   $0xc,0x8(%rax)
  5ae75e:	00 
  5ae75f:	4c 89 78 10          	mov    %r15,0x10(%rax)
  5ae763:	48 8b 8c 24 30 02 00 	mov    0x230(%rsp),%rcx
  5ae76a:	00 
  5ae76b:	48 85 c9             	test   %rcx,%rcx
  5ae76e:	0f 85 2c 0b 00 00    	jne    5af2a0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5270>
  5ae774:	e9 48 c9 ff ff       	jmp    5ab0c1 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1091>
  5ae779:	49 83 ff ff          	cmp    $0xffffffffffffffff,%r15
  5ae77d:	74 16                	je     5ae795 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4765>
  5ae77f:	4d 85 ff             	test   %r15,%r15
  5ae782:	7e 11                	jle    5ae795 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4765>
  5ae784:	ba 01 00 00 00       	mov    $0x1,%edx
  5ae789:	48 89 ef             	mov    %rbp,%rdi
  5ae78c:	4c 89 fe             	mov    %r15,%rsi
  5ae78f:	ff 15 63 b6 53 00    	call   *0x53b663(%rip)        # ae9df8 <_DYNAMIC+0x248>
  5ae795:	48 83 fb ff          	cmp    $0xffffffffffffffff,%rbx
  5ae799:	74 16                	je     5ae7b1 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4781>
  5ae79b:	48 85 db             	test   %rbx,%rbx
  5ae79e:	7e 11                	jle    5ae7b1 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4781>
  5ae7a0:	ba 01 00 00 00       	mov    $0x1,%edx
  5ae7a5:	4c 89 f7             	mov    %r14,%rdi
  5ae7a8:	48 89 de             	mov    %rbx,%rsi
  5ae7ab:	ff 15 47 b6 53 00    	call   *0x53b647(%rip)        # ae9df8 <_DYNAMIC+0x248>
  5ae7b1:	48 8b 74 24 60       	mov    0x60(%rsp),%rsi
  5ae7b6:	48 89 f0             	mov    %rsi,%rax
  5ae7b9:	4c 29 e0             	sub    %r12,%rax
  5ae7bc:	48 c1 e8 03          	shr    $0x3,%rax
  5ae7c0:	48 b9 93 24 49 92 24 	movabs $0x2492492492492493,%rcx
  5ae7c7:	49 92 24 
  5ae7ca:	48 f7 e1             	mul    %rcx
  5ae7cd:	4c 39 e6             	cmp    %r12,%rsi
  5ae7d0:	74 66                	je     5ae838 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4808>
  5ae7d2:	48 89 d3             	mov    %rdx,%rbx
  5ae7d5:	49 83 c4 20          	add    $0x20,%r12
  5ae7d9:	4c 8b 35 18 b6 53 00 	mov    0x53b618(%rip),%r14        # ae9df8 <_DYNAMIC+0x248>
  5ae7e0:	eb 17                	jmp    5ae7f9 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x47c9>
  5ae7e2:	66 66 66 66 66 2e 0f 	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  5ae7e9:	1f 84 00 00 00 00 00 
  5ae7f0:	49 83 c4 38          	add    $0x38,%r12
  5ae7f4:	48 ff cb             	dec    %rbx
  5ae7f7:	74 3f                	je     5ae838 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4808>
  5ae7f9:	49 8b 74 24 e0       	mov    -0x20(%r12),%rsi
  5ae7fe:	48 83 fe ff          	cmp    $0xffffffffffffffff,%rsi
  5ae802:	74 14                	je     5ae818 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x47e8>
  5ae804:	48 85 f6             	test   %rsi,%rsi
  5ae807:	78 0f                	js     5ae818 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x47e8>
  5ae809:	74 0d                	je     5ae818 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x47e8>
  5ae80b:	49 8b 7c 24 e8       	mov    -0x18(%r12),%rdi
  5ae810:	ba 01 00 00 00       	mov    $0x1,%edx
  5ae815:	41 ff d6             	call   *%r14
  5ae818:	49 8b 74 24 f8       	mov    -0x8(%r12),%rsi
  5ae81d:	48 83 fe ff          	cmp    $0xffffffffffffffff,%rsi
  5ae821:	74 cd                	je     5ae7f0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x47c0>
  5ae823:	48 85 f6             	test   %rsi,%rsi
  5ae826:	78 c8                	js     5ae7f0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x47c0>
  5ae828:	74 c6                	je     5ae7f0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x47c0>
  5ae82a:	49 8b 3c 24          	mov    (%r12),%rdi
  5ae82e:	ba 01 00 00 00       	mov    $0x1,%edx
  5ae833:	41 ff d6             	call   *%r14
  5ae836:	eb b8                	jmp    5ae7f0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x47c0>
  5ae838:	48 8b 44 24 58       	mov    0x58(%rsp),%rax
  5ae83d:	48 85 c0             	test   %rax,%rax
  5ae840:	74 14                	je     5ae856 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4826>
  5ae842:	48 6b f0 38          	imul   $0x38,%rax,%rsi
  5ae846:	ba 08 00 00 00       	mov    $0x8,%edx
  5ae84b:	48 8b 7c 24 38       	mov    0x38(%rsp),%rdi
  5ae850:	ff 15 a2 b5 53 00    	call   *0x53b5a2(%rip)        # ae9df8 <_DYNAMIC+0x248>
  5ae856:	48 8b 74 24 30       	mov    0x30(%rsp),%rsi
  5ae85b:	48 85 f6             	test   %rsi,%rsi
  5ae85e:	48 8b 5c 24 10       	mov    0x10(%rsp),%rbx
  5ae863:	74 14                	je     5ae879 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4849>
  5ae865:	48 c1 e6 04          	shl    $0x4,%rsi
  5ae869:	ba 08 00 00 00       	mov    $0x8,%edx
  5ae86e:	48 8b 7c 24 50       	mov    0x50(%rsp),%rdi
  5ae873:	ff 15 7f b5 53 00    	call   *0x53b57f(%rip)        # ae9df8 <_DYNAMIC+0x248>
  5ae879:	48 8b bc 24 a8 04 00 	mov    0x4a8(%rsp),%rdi
  5ae880:	00 
  5ae881:	48 8b b4 24 b0 04 00 	mov    0x4b0(%rsp),%rsi
  5ae888:	00 
  5ae889:	48 8d 44 24 6f       	lea    0x6f(%rsp),%rax
  5ae88e:	48 89 84 24 a0 00 00 	mov    %rax,0xa0(%rsp)
  5ae895:	00 
  5ae896:	48 83 fe 02          	cmp    $0x2,%rsi
  5ae89a:	0f 83 db 0f 00 00    	jae    5af87b <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x584b>
  5ae8a0:	48 8b 84 24 b0 04 00 	mov    0x4b0(%rsp),%rax
  5ae8a7:	00 
  5ae8a8:	48 89 84 24 b0 00 00 	mov    %rax,0xb0(%rsp)
  5ae8af:	00 
  5ae8b0:	0f 10 84 24 a0 04 00 	movups 0x4a0(%rsp),%xmm0
  5ae8b7:	00 
  5ae8b8:	0f 29 84 24 a0 00 00 	movaps %xmm0,0xa0(%rsp)
  5ae8bf:	00 
  5ae8c0:	48 8b bb 10 08 00 00 	mov    0x810(%rbx),%rdi
  5ae8c7:	e8 14 7d f8 ff       	call   5365e0 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtCscdodAO9FK5_5alloc3vec3VecNtNtNtCs6gaF1xUz9Bf_4gpui7runtime8metadata8DeclaredEEB1d_>
  5ae8cc:	48 8b 83 10 08 00 00 	mov    0x810(%rbx),%rax
  5ae8d3:	48 8b 8c 24 b0 00 00 	mov    0xb0(%rsp),%rcx
  5ae8da:	00 
  5ae8db:	48 89 48 10          	mov    %rcx,0x10(%rax)
  5ae8df:	0f 28 84 24 a0 00 00 	movaps 0xa0(%rsp),%xmm0
  5ae8e6:	00 
  5ae8e7:	0f 11 00             	movups %xmm0,(%rax)
  5ae8ea:	31 d2                	xor    %edx,%edx
  5ae8ec:	89 54 24 20          	mov    %edx,0x20(%rsp)
  5ae8f0:	48 8b 84 24 00 06 00 	mov    0x600(%rsp),%rax
  5ae8f7:	00 
  5ae8f8:	48 89 84 24 b0 00 00 	mov    %rax,0xb0(%rsp)
  5ae8ff:	00 
  5ae900:	0f 10 84 24 f0 05 00 	movups 0x5f0(%rsp),%xmm0
  5ae907:	00 
  5ae908:	0f 29 84 24 a0 00 00 	movaps %xmm0,0xa0(%rsp)
  5ae90f:	00 
  5ae910:	48 8b 9c 24 a0 05 00 	mov    0x5a0(%rsp),%rbx
  5ae917:	00 
  5ae918:	48 89 df             	mov    %rbx,%rdi
  5ae91b:	e8 c0 fb 17 00       	call   72e4e0 <_RNvXNtNtNtCscdodAO9FK5_5alloc11collections5btree3mapINtB2_8BTreeMapNtNtCs6gaF1xUz9Bf_4gpui4list6ListIdNtNtNtB17_7runtime4list9ListStateENtNtNtCs4NRVxsYgnAr_4core3ops4drop4Drop4dropB17_>
  5ae920:	48 8b 84 24 b0 00 00 	mov    0xb0(%rsp),%rax
  5ae927:	00 
  5ae928:	48 89 43 10          	mov    %rax,0x10(%rbx)
  5ae92c:	0f 28 84 24 a0 00 00 	movaps 0xa0(%rsp),%xmm0
  5ae933:	00 
  5ae934:	0f 11 03             	movups %xmm0,(%rbx)
  5ae937:	48 8b 84 24 18 06 00 	mov    0x618(%rsp),%rax
  5ae93e:	00 
  5ae93f:	48 89 84 24 b0 00 00 	mov    %rax,0xb0(%rsp)
  5ae946:	00 
  5ae947:	0f 10 84 24 08 06 00 	movups 0x608(%rsp),%xmm0
  5ae94e:	00 
  5ae94f:	0f 29 84 24 a0 00 00 	movaps %xmm0,0xa0(%rsp)
  5ae956:	00 
  5ae957:	48 8b 5c 24 10       	mov    0x10(%rsp),%rbx
  5ae95c:	4c 8d b3 30 08 00 00 	lea    0x830(%rbx),%r14
  5ae963:	4c 89 f7             	mov    %r14,%rdi
  5ae966:	e8 65 07 18 00       	call   72f0d0 <_RNvXNtNtNtCscdodAO9FK5_5alloc11collections5btree3mapINtB2_8BTreeMapTINtNtCs4NRVxsYgnAr_4core6option6OptionyENtNtCs6gaF1xUz9Bf_4gpui4list6ListIdNtNtB1M_7element8NodeKindEjENtNtNtB19_3ops4drop4Drop4dropB1M_>
  5ae96b:	48 81 c3 b8 02 00 00 	add    $0x2b8,%rbx
  5ae972:	48 8b 84 24 b0 00 00 	mov    0xb0(%rsp),%rax
  5ae979:	00 
  5ae97a:	49 89 46 10          	mov    %rax,0x10(%r14)
  5ae97e:	0f 28 84 24 a0 00 00 	movaps 0xa0(%rsp),%xmm0
  5ae985:	00 
  5ae986:	41 0f 11 06          	movups %xmm0,(%r14)
  5ae98a:	48 8b 84 24 28 02 00 	mov    0x228(%rsp),%rax
  5ae991:	00 
  5ae992:	48 89 84 24 b0 00 00 	mov    %rax,0xb0(%rsp)
  5ae999:	00 
  5ae99a:	0f 10 84 24 18 02 00 	movups 0x218(%rsp),%xmm0
  5ae9a1:	00 
  5ae9a2:	0f 29 84 24 a0 00 00 	movaps %xmm0,0xa0(%rsp)
  5ae9a9:	00 
  5ae9aa:	48 89 df             	mov    %rbx,%rdi
  5ae9ad:	e8 6e db 12 00       	call   6dc520 <_RNvXso_NtCscdodAO9FK5_5alloc3vecINtB5_3VecNtNtCs6gaF1xUz9Bf_4gpui7runtime4NodeENtNtNtCs4NRVxsYgnAr_4core3ops4drop4Drop4dropBI_>
  5ae9b2:	48 8b 03             	mov    (%rbx),%rax
  5ae9b5:	48 85 c0             	test   %rax,%rax
  5ae9b8:	4c 8b 74 24 10       	mov    0x10(%rsp),%r14
  5ae9bd:	74 1a                	je     5ae9d9 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x49a9>
  5ae9bf:	49 8b be c0 02 00 00 	mov    0x2c0(%r14),%rdi
  5ae9c6:	48 c1 e0 03          	shl    $0x3,%rax
  5ae9ca:	48 8d 34 80          	lea    (%rax,%rax,4),%rsi
  5ae9ce:	ba 08 00 00 00       	mov    $0x8,%edx
  5ae9d3:	ff 15 1f b4 53 00    	call   *0x53b41f(%rip)        # ae9df8 <_DYNAMIC+0x248>
  5ae9d9:	48 8b 84 24 b0 00 00 	mov    0xb0(%rsp),%rax
  5ae9e0:	00 
  5ae9e1:	48 89 43 10          	mov    %rax,0x10(%rbx)
  5ae9e5:	0f 28 84 24 a0 00 00 	movaps 0xa0(%rsp),%xmm0
  5ae9ec:	00 
  5ae9ed:	0f 11 03             	movups %xmm0,(%rbx)
  5ae9f0:	0f 10 84 24 08 07 00 	movups 0x708(%rsp),%xmm0
  5ae9f7:	00 
  5ae9f8:	0f 10 8c 24 18 07 00 	movups 0x718(%rsp),%xmm1
  5ae9ff:	00 
  5aea00:	f3 0f 6f 94 24 28 07 	movdqu 0x728(%rsp),%xmm2
  5aea07:	00 00 
  5aea09:	0f 10 9c 24 38 07 00 	movups 0x738(%rsp),%xmm3
  5aea10:	00 
  5aea11:	0f 29 9c 24 d0 00 00 	movaps %xmm3,0xd0(%rsp)
  5aea18:	00 
  5aea19:	66 0f 7f 94 24 c0 00 	movdqa %xmm2,0xc0(%rsp)
  5aea20:	00 00 
  5aea22:	0f 29 8c 24 b0 00 00 	movaps %xmm1,0xb0(%rsp)
  5aea29:	00 
  5aea2a:	0f 29 84 24 a0 00 00 	movaps %xmm0,0xa0(%rsp)
  5aea31:	00 
  5aea32:	48 8d bc 24 00 03 00 	lea    0x300(%rsp),%rdi
  5aea39:	00 
  5aea3a:	48 8d b4 24 a0 00 00 	lea    0xa0(%rsp),%rsi
  5aea41:	00 
  5aea42:	e8 99 b2 1c 00       	call   779ce0 <_RNvMs_NtNtCs6gaF1xUz9Bf_4gpui7runtime6stylesNtB4_7Builder6finish>
  5aea47:	49 8d 9e 28 02 00 00 	lea    0x228(%r14),%rbx
  5aea4e:	48 8b 03             	mov    (%rbx),%rax
  5aea51:	48 85 c0             	test   %rax,%rax
  5aea54:	74 63                	je     5aeab9 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4a89>
  5aea56:	83 f8 01             	cmp    $0x1,%eax
  5aea59:	75 1e                	jne    5aea79 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4a49>
  5aea5b:	49 8b 86 30 02 00 00 	mov    0x230(%r14),%rax
  5aea62:	48 85 c0             	test   %rax,%rax
  5aea65:	74 52                	je     5aeab9 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4a89>
  5aea67:	49 8b be 38 02 00 00 	mov    0x238(%r14),%rdi
  5aea6e:	48 6b f0 58          	imul   $0x58,%rax,%rsi
  5aea72:	ba 04 00 00 00       	mov    $0x4,%edx
  5aea77:	eb 3a                	jmp    5aeab3 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4a83>
  5aea79:	49 8b 86 38 02 00 00 	mov    0x238(%r14),%rax
  5aea80:	48 85 c0             	test   %rax,%rax
  5aea83:	74 16                	je     5aea9b <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4a6b>
  5aea85:	49 8b be 30 02 00 00 	mov    0x230(%r14),%rdi
  5aea8c:	48 6b f0 58          	imul   $0x58,%rax,%rsi
  5aea90:	ba 04 00 00 00       	mov    $0x4,%edx
  5aea95:	ff 15 5d b3 53 00    	call   *0x53b35d(%rip)        # ae9df8 <_DYNAMIC+0x248>
  5aea9b:	49 8b b6 48 02 00 00 	mov    0x248(%r14),%rsi
  5aeaa2:	48 85 f6             	test   %rsi,%rsi
  5aeaa5:	74 12                	je     5aeab9 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4a89>
  5aeaa7:	49 8b be 40 02 00 00 	mov    0x240(%r14),%rdi
  5aeaae:	ba 01 00 00 00       	mov    $0x1,%edx
  5aeab3:	ff 15 3f b3 53 00    	call   *0x53b33f(%rip)        # ae9df8 <_DYNAMIC+0x248>
  5aeab9:	48 8b 84 24 20 03 00 	mov    0x320(%rsp),%rax
  5aeac0:	00 
  5aeac1:	48 89 43 20          	mov    %rax,0x20(%rbx)
  5aeac5:	0f 10 84 24 00 03 00 	movups 0x300(%rsp),%xmm0
  5aeacc:	00 
  5aeacd:	0f 10 8c 24 10 03 00 	movups 0x310(%rsp),%xmm1
  5aead4:	00 
  5aead5:	0f 11 4b 10          	movups %xmm1,0x10(%rbx)
  5aead9:	0f 11 03             	movups %xmm0,(%rbx)
  5aeadc:	48 8b 84 24 38 05 00 	mov    0x538(%rsp),%rax
  5aeae3:	00 
  5aeae4:	48 89 84 24 b0 00 00 	mov    %rax,0xb0(%rsp)
  5aeaeb:	00 
  5aeaec:	0f 10 84 24 28 05 00 	movups 0x528(%rsp),%xmm0
  5aeaf3:	00 
  5aeaf4:	0f 29 84 24 a0 00 00 	movaps %xmm0,0xa0(%rsp)
  5aeafb:	00 
  5aeafc:	49 8d 9e d0 02 00 00 	lea    0x2d0(%r14),%rbx
  5aeb03:	48 89 df             	mov    %rbx,%rdi
  5aeb06:	e8 e5 d7 12 00       	call   6dc2f0 <_RNvXso_NtCscdodAO9FK5_5alloc3vecINtB5_3VecINtNtCs4NRVxsYgnAr_4core6option6OptionNtNtCs6gaF1xUz9Bf_4gpui7runtime8TextSiteEENtNtNtBJ_3ops4drop4Drop4dropB1k_>
  5aeb0b:	48 8b 03             	mov    (%rbx),%rax
  5aeb0e:	48 85 c0             	test   %rax,%rax
  5aeb11:	74 1a                	je     5aeb2d <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4afd>
  5aeb13:	49 8b be d8 02 00 00 	mov    0x2d8(%r14),%rdi
  5aeb1a:	48 c1 e0 04          	shl    $0x4,%rax
  5aeb1e:	48 8d 34 80          	lea    (%rax,%rax,4),%rsi
  5aeb22:	ba 08 00 00 00       	mov    $0x8,%edx
  5aeb27:	ff 15 cb b2 53 00    	call   *0x53b2cb(%rip)        # ae9df8 <_DYNAMIC+0x248>
  5aeb2d:	48 8b 84 24 b0 00 00 	mov    0xb0(%rsp),%rax
  5aeb34:	00 
  5aeb35:	48 89 43 10          	mov    %rax,0x10(%rbx)
  5aeb39:	0f 28 84 24 a0 00 00 	movaps 0xa0(%rsp),%xmm0
  5aeb40:	00 
  5aeb41:	0f 11 03             	movups %xmm0,(%rbx)
  5aeb44:	48 8b 84 24 40 02 00 	mov    0x240(%rsp),%rax
  5aeb4b:	00 
  5aeb4c:	48 89 84 24 a0 01 00 	mov    %rax,0x1a0(%rsp)
  5aeb53:	00 
  5aeb54:	0f 10 84 24 30 02 00 	movups 0x230(%rsp),%xmm0
  5aeb5b:	00 
  5aeb5c:	0f 29 84 24 90 01 00 	movaps %xmm0,0x190(%rsp)
  5aeb63:	00 
  5aeb64:	49 8b 8e c8 07 00 00 	mov    0x7c8(%r14),%rcx
  5aeb6b:	48 85 c9             	test   %rcx,%rcx
  5aeb6e:	74 4d                	je     5aebbd <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4b8d>
  5aeb70:	49 8b 96 d0 07 00 00 	mov    0x7d0(%r14),%rdx
  5aeb77:	49 8b 86 d8 07 00 00 	mov    0x7d8(%r14),%rax
  5aeb7e:	48 c7 84 24 a8 00 00 	movq   $0x0,0xa8(%rsp)
  5aeb85:	00 00 00 00 00 
  5aeb8a:	48 89 8c 24 b0 00 00 	mov    %rcx,0xb0(%rsp)
  5aeb91:	00 
  5aeb92:	48 89 94 24 b8 00 00 	mov    %rdx,0xb8(%rsp)
  5aeb99:	00 
  5aeb9a:	48 c7 84 24 c8 00 00 	movq   $0x0,0xc8(%rsp)
  5aeba1:	00 00 00 00 00 
  5aeba6:	48 89 8c 24 d0 00 00 	mov    %rcx,0xd0(%rsp)
  5aebad:	00 
  5aebae:	48 89 94 24 d8 00 00 	mov    %rdx,0xd8(%rsp)
  5aebb5:	00 
  5aebb6:	b9 01 00 00 00       	mov    $0x1,%ecx
  5aebbb:	eb 04                	jmp    5aebc1 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4b91>
  5aebbd:	31 c9                	xor    %ecx,%ecx
  5aebbf:	31 c0                	xor    %eax,%eax
  5aebc1:	4d 8d be c8 07 00 00 	lea    0x7c8(%r14),%r15
  5aebc8:	48 89 8c 24 a0 00 00 	mov    %rcx,0xa0(%rsp)
  5aebcf:	00 
  5aebd0:	48 89 8c 24 c0 00 00 	mov    %rcx,0xc0(%rsp)
  5aebd7:	00 
  5aebd8:	48 89 84 24 e0 00 00 	mov    %rax,0xe0(%rsp)
  5aebdf:	00 
  5aebe0:	48 8d bc 24 00 03 00 	lea    0x300(%rsp),%rdi
  5aebe7:	00 
  5aebe8:	48 8d b4 24 a0 00 00 	lea    0xa0(%rsp),%rsi
  5aebef:	00 
  5aebf0:	e8 eb a7 17 00       	call   7293e0 <_RNvMsz_NtNtNtCscdodAO9FK5_5alloc11collections5btree3mapINtB5_8IntoIterNtNtCs6gaF1xUz9Bf_4gpui6source7FieldIdNtNtB1a_7runtime6FanoutE10dying_nextB1a_.llvm.555413502705965614>
  5aebf5:	48 8b 84 24 00 03 00 	mov    0x300(%rsp),%rax
  5aebfc:	00 
  5aebfd:	48 85 c0             	test   %rax,%rax
  5aec00:	74 64                	je     5aec66 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4c36>
  5aec02:	48 8d 9c 24 00 03 00 	lea    0x300(%rsp),%rbx
  5aec09:	00 
  5aec0a:	4c 8d b4 24 a0 00 00 	lea    0xa0(%rsp),%r14
  5aec11:	00 
  5aec12:	4c 8b 25 df b1 53 00 	mov    0x53b1df(%rip),%r12        # ae9df8 <_DYNAMIC+0x248>
  5aec19:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  5aec20:	48 8b 8c 24 10 03 00 	mov    0x310(%rsp),%rcx
  5aec27:	00 
  5aec28:	48 8d 0c 89          	lea    (%rcx,%rcx,4),%rcx
  5aec2c:	48 8b 74 c8 60       	mov    0x60(%rax,%rcx,8),%rsi
  5aec31:	48 85 f6             	test   %rsi,%rsi
  5aec34:	74 18                	je     5aec4e <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4c1e>
  5aec36:	48 8d 04 c8          	lea    (%rax,%rcx,8),%rax
  5aec3a:	48 83 c0 60          	add    $0x60,%rax
  5aec3e:	48 8b 78 08          	mov    0x8(%rax),%rdi
  5aec42:	48 c1 e6 02          	shl    $0x2,%rsi
  5aec46:	ba 04 00 00 00       	mov    $0x4,%edx
  5aec4b:	41 ff d4             	call   *%r12
  5aec4e:	48 89 df             	mov    %rbx,%rdi
  5aec51:	4c 89 f6             	mov    %r14,%rsi
  5aec54:	e8 87 a7 17 00       	call   7293e0 <_RNvMsz_NtNtNtCscdodAO9FK5_5alloc11collections5btree3mapINtB5_8IntoIterNtNtCs6gaF1xUz9Bf_4gpui6source7FieldIdNtNtB1a_7runtime6FanoutE10dying_nextB1a_.llvm.555413502705965614>
  5aec59:	48 8b 84 24 00 03 00 	mov    0x300(%rsp),%rax
  5aec60:	00 
  5aec61:	48 85 c0             	test   %rax,%rax
  5aec64:	75 ba                	jne    5aec20 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4bf0>
  5aec66:	48 8b 84 24 a0 01 00 	mov    0x1a0(%rsp),%rax
  5aec6d:	00 
  5aec6e:	49 89 47 10          	mov    %rax,0x10(%r15)
  5aec72:	0f 28 84 24 90 01 00 	movaps 0x190(%rsp),%xmm0
  5aec79:	00 
  5aec7a:	41 0f 11 07          	movups %xmm0,(%r15)
  5aec7e:	4c 8b 74 24 10       	mov    0x10(%rsp),%r14
  5aec83:	49 8b 86 c0 02 00 00 	mov    0x2c0(%r14),%rax
  5aec8a:	49 8b 8e c8 02 00 00 	mov    0x2c8(%r14),%rcx
  5aec91:	48 8d 0c 89          	lea    (%rcx,%rcx,4),%rcx
  5aec95:	48 8d 0c c8          	lea    (%rax,%rcx,8),%rcx
  5aec99:	48 89 84 24 a0 00 00 	mov    %rax,0xa0(%rsp)
  5aeca0:	00 
  5aeca1:	48 89 8c 24 a8 00 00 	mov    %rcx,0xa8(%rsp)
  5aeca8:	00 
  5aeca9:	48 c7 84 24 b0 00 00 	movq   $0x0,0xb0(%rsp)
  5aecb0:	00 00 00 00 00 
  5aecb5:	48 8d bc 24 00 03 00 	lea    0x300(%rsp),%rdi
  5aecbc:	00 
  5aecbd:	48 8d b4 24 a0 00 00 	lea    0xa0(%rsp),%rsi
  5aecc4:	00 
  5aecc5:	8b 6c 24 20          	mov    0x20(%rsp),%ebp
  5aecc9:	e8 42 6b 17 00       	call   725810 <_RINvXs1o_NtNtNtCscdodAO9FK5_5alloc11collections5btree3mapINtB7_8BTreeMapyjEINtNtNtNtCs4NRVxsYgnAr_4core4iter6traits7collect12FromIteratorTyjEE9from_iterINtNtNtB1i_8adapters3map3MapINtNtB2v_9enumerate9EnumerateINtNtNtB1k_5slice4iter4IterNtNtCs6gaF1xUz9Bf_4gpui7runtime4NodeEENCNvMsq_B3O_INtB3O_7RuntimeNtNtB3O_12style_ledger9AdversaryE14describe_innersz_0EEB3Q_>
  5aecce:	49 8d 9e b0 07 00 00 	lea    0x7b0(%r14),%rbx
  5aecd5:	48 89 df             	mov    %rbx,%rdi
  5aecd8:	e8 c3 0a 18 00       	call   72f7a0 <_RNvXNtNtNtCscdodAO9FK5_5alloc11collections5btree3mapINtB2_8BTreeMapjNtNtCs6gaF1xUz9Bf_4gpui4list6ListIdENtNtNtCs4NRVxsYgnAr_4core3ops4drop4Drop4dropB18_>
  5aecdd:	48 8b 84 24 10 03 00 	mov    0x310(%rsp),%rax
  5aece4:	00 
  5aece5:	48 89 43 10          	mov    %rax,0x10(%rbx)
  5aece9:	0f 10 84 24 00 03 00 	movups 0x300(%rsp),%xmm0
  5aecf0:	00 
  5aecf1:	0f 11 03             	movups %xmm0,(%rbx)
  5aecf4:	48 8b bc 24 98 05 00 	mov    0x598(%rsp),%rdi
  5aecfb:	00 
  5aecfc:	48 89 de             	mov    %rbx,%rsi
  5aecff:	e8 9c 61 16 00       	call   714ea0 <_RINvMs5_NtCs6gaF1xUz9Bf_4gpui8propertyNtB6_9Overrides6retainNCNvMsq_NtB8_7runtimeINtB14_7RuntimeNtNtB14_12style_ledger9AdversaryE14describe_innersA_0EB8_>
  5aed04:	49 8b 86 10 08 00 00 	mov    0x810(%r14),%rax
  5aed0b:	48 85 c0             	test   %rax,%rax
  5aed0e:	0f 84 08 01 00 00    	je     5aee1c <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4dec>
  5aed14:	48 89 9c 24 90 01 00 	mov    %rbx,0x190(%rsp)
  5aed1b:	00 
  5aed1c:	48 8b 88 d8 00 00 00 	mov    0xd8(%rax),%rcx
  5aed23:	48 85 c9             	test   %rcx,%rcx
  5aed26:	74 3e                	je     5aed66 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4d36>
  5aed28:	48 8d 90 d8 00 00 00 	lea    0xd8(%rax),%rdx
  5aed2f:	48 8b b0 e0 00 00 00 	mov    0xe0(%rax),%rsi
  5aed36:	48 85 f6             	test   %rsi,%rsi
  5aed39:	4c 8d 8c 24 90 01 00 	lea    0x190(%rsp),%r9
  5aed40:	00 
  5aed41:	74 78                	je     5aedbb <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4d8b>
  5aed43:	48 89 f7             	mov    %rsi,%rdi
  5aed46:	48 83 e7 07          	and    $0x7,%rdi
  5aed4a:	74 28                	je     5aed74 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4d44>
  5aed4c:	45 31 c0             	xor    %r8d,%r8d
  5aed4f:	48 8b 89 c8 01 00 00 	mov    0x1c8(%rcx),%rcx
  5aed56:	49 ff c0             	inc    %r8
  5aed59:	4c 39 c7             	cmp    %r8,%rdi
  5aed5c:	75 f1                	jne    5aed4f <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4d1f>
  5aed5e:	48 89 f7             	mov    %rsi,%rdi
  5aed61:	4c 29 c7             	sub    %r8,%rdi
  5aed64:	eb 11                	jmp    5aed77 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4d47>
  5aed66:	31 c9                	xor    %ecx,%ecx
  5aed68:	31 d2                	xor    %edx,%edx
  5aed6a:	4c 8d 8c 24 90 01 00 	lea    0x190(%rsp),%r9
  5aed71:	00 
  5aed72:	eb 47                	jmp    5aedbb <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4d8b>
  5aed74:	48 89 f7             	mov    %rsi,%rdi
  5aed77:	48 83 fe 08          	cmp    $0x8,%rsi
  5aed7b:	72 3e                	jb     5aedbb <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4d8b>
  5aed7d:	48 8b 89 c8 01 00 00 	mov    0x1c8(%rcx),%rcx
  5aed84:	48 8b 89 c8 01 00 00 	mov    0x1c8(%rcx),%rcx
  5aed8b:	48 8b 89 c8 01 00 00 	mov    0x1c8(%rcx),%rcx
  5aed92:	48 8b 89 c8 01 00 00 	mov    0x1c8(%rcx),%rcx
  5aed99:	48 8b 89 c8 01 00 00 	mov    0x1c8(%rcx),%rcx
  5aeda0:	48 8b 89 c8 01 00 00 	mov    0x1c8(%rcx),%rcx
  5aeda7:	48 8b 89 c8 01 00 00 	mov    0x1c8(%rcx),%rcx
  5aedae:	48 8b 89 c8 01 00 00 	mov    0x1c8(%rcx),%rcx
  5aedb5:	48 83 c7 f8          	add    $0xfffffffffffffff8,%rdi
  5aedb9:	75 c2                	jne    5aed7d <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4d4d>
  5aedbb:	48 05 e8 00 00 00    	add    $0xe8,%rax
  5aedc1:	4c 89 8c 24 a0 00 00 	mov    %r9,0xa0(%rsp)
  5aedc8:	00 
  5aedc9:	48 89 84 24 a8 00 00 	mov    %rax,0xa8(%rsp)
  5aedd0:	00 
  5aedd1:	48 89 94 24 b0 00 00 	mov    %rdx,0xb0(%rsp)
  5aedd8:	00 
  5aedd9:	48 89 8c 24 b8 00 00 	mov    %rcx,0xb8(%rsp)
  5aede0:	00 
  5aede1:	0f 57 c0             	xorps  %xmm0,%xmm0
  5aede4:	0f 11 84 24 c0 00 00 	movups %xmm0,0xc0(%rsp)
  5aedeb:	00 
  5aedec:	48 8d bc 24 00 03 00 	lea    0x300(%rsp),%rdi
  5aedf3:	00 
  5aedf4:	48 8d b4 24 a0 00 00 	lea    0xa0(%rsp),%rsi
  5aedfb:	00 
  5aedfc:	e8 2f 25 18 00       	call   731330 <_RNvXsU_NtNtNtCscdodAO9FK5_5alloc11collections5btree3mapINtB5_9ExtractIfyAINtNtCs6gaF1xUz9Bf_4gpui8property12ContributionINtNtCs4NRVxsYgnAr_4core6option6OptionNtNtB1e_11shared_text10SharedTextEEj2_NtNtNtB1Z_3ops5range9RangeFullNCINvMsi_B5_INtB5_8BTreeMapyB18_E6retainNCNvMsq_NtB1e_7runtimeINtB4o_7RuntimeNtNtB4o_12style_ledger9AdversaryE14describe_innersB_0E0ENtNtNtNtB1Z_4iter6traits8iterator8Iterator4nextB1e_>
  5aee01:	48 8b 84 24 08 03 00 	mov    0x308(%rsp),%rax
  5aee08:	00 
  5aee09:	48 83 f8 02          	cmp    $0x2,%rax
  5aee0d:	0f 85 5b 03 00 00    	jne    5af16e <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x513e>
  5aee13:	4c 8b 74 24 10       	mov    0x10(%rsp),%r14
  5aee18:	8b 6c 24 20          	mov    0x20(%rsp),%ebp
  5aee1c:	41 c6 86 5a 09 00 00 	movb   $0x1,0x95a(%r14)
  5aee23:	01 
  5aee24:	49 8b b6 e8 07 00 00 	mov    0x7e8(%r14),%rsi
  5aee2b:	48 85 f6             	test   %rsi,%rsi
  5aee2e:	74 5b                	je     5aee8b <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4e5b>
  5aee30:	49 8b 96 f0 07 00 00 	mov    0x7f0(%r14),%rdx
  5aee37:	4c 89 f7             	mov    %r14,%rdi
  5aee3a:	e8 e1 1b 00 00       	call   5b0a20 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE6locateB7_>
  5aee3f:	48 83 f8 01          	cmp    $0x1,%rax
  5aee43:	75 3b                	jne    5aee80 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4e50>
  5aee45:	49 8b b6 c8 02 00 00 	mov    0x2c8(%r14),%rsi
  5aee4c:	48 39 f2             	cmp    %rsi,%rdx
  5aee4f:	0f 83 64 0d 00 00    	jae    5afbb9 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5b89>
  5aee55:	49 8b 8e c0 02 00 00 	mov    0x2c0(%r14),%rcx
  5aee5c:	48 8d 14 92          	lea    (%rdx,%rdx,4),%rdx
  5aee60:	48 8d 04 d1          	lea    (%rcx,%rdx,8),%rax
  5aee64:	8b 4c d1 20          	mov    0x20(%rcx,%rdx,8),%ecx
  5aee68:	83 e1 07             	and    $0x7,%ecx
  5aee6b:	ba 73 00 00 00       	mov    $0x73,%edx
  5aee70:	0f a3 ca             	bt     %ecx,%edx
  5aee73:	0f 83 be 03 00 00    	jae    5af237 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5207>
  5aee79:	48 83 78 08 00       	cmpq   $0x0,0x8(%rax)
  5aee7e:	75 0b                	jne    5aee8b <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4e5b>
  5aee80:	49 c7 86 e8 07 00 00 	movq   $0x0,0x7e8(%r14)
  5aee87:	00 00 00 00 
  5aee8b:	48 8b 84 24 08 02 00 	mov    0x208(%rsp),%rax
  5aee92:	00 
  5aee93:	48 03 84 24 d8 04 00 	add    0x4d8(%rsp),%rax
  5aee9a:	00 
  5aee9b:	49 89 86 48 09 00 00 	mov    %rax,0x948(%r14)
  5aeea2:	48 8b 84 24 88 00 00 	mov    0x88(%rsp),%rax
  5aeea9:	00 
  5aeeaa:	48 c7 00 fe ff ff ff 	movq   $0xfffffffffffffffe,(%rax)
  5aeeb1:	ba 04 00 00 00       	mov    $0x4,%edx
  5aeeb6:	48 8b bc 24 48 02 00 	mov    0x248(%rsp),%rdi
  5aeebd:	00 
  5aeebe:	48 8b b4 24 d0 02 00 	mov    0x2d0(%rsp),%rsi
  5aeec5:	00 
  5aeec6:	ff 15 2c af 53 00    	call   *0x53af2c(%rip)        # ae9df8 <_DYNAMIC+0x248>
  5aeecc:	48 8b b4 24 d8 02 00 	mov    0x2d8(%rsp),%rsi
  5aeed3:	00 
  5aeed4:	48 85 f6             	test   %rsi,%rsi
  5aeed7:	74 17                	je     5aeef0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4ec0>
  5aeed9:	48 c1 e6 03          	shl    $0x3,%rsi
  5aeedd:	ba 08 00 00 00       	mov    $0x8,%edx
  5aeee2:	48 8b bc 24 80 00 00 	mov    0x80(%rsp),%rdi
  5aeee9:	00 
  5aeeea:	ff 15 08 af 53 00    	call   *0x53af08(%rip)        # ae9df8 <_DYNAMIC+0x248>
  5aeef0:	48 8d bc 24 10 05 00 	lea    0x510(%rsp),%rdi
  5aeef7:	00 
  5aeef8:	e8 33 eb 17 00       	call   72da30 <_RNvXNtNtNtCscdodAO9FK5_5alloc11collections5btree3mapINtB2_8BTreeMapINtNtCs4NRVxsYgnAr_4core6option6OptionyEjENtNtNtB18_3ops4drop4Drop4dropCs6gaF1xUz9Bf_4gpui>
  5aeefd:	45 31 ed             	xor    %r13d,%r13d
  5aef00:	48 8d bc 24 f0 06 00 	lea    0x6f0(%rsp),%rdi
  5aef07:	00 
  5aef08:	e8 93 08 18 00       	call   72f7a0 <_RNvXNtNtNtCscdodAO9FK5_5alloc11collections5btree3mapINtB2_8BTreeMapjNtNtCs6gaF1xUz9Bf_4gpui4list6ListIdENtNtNtCs4NRVxsYgnAr_4core3ops4drop4Drop4dropB18_>
  5aef0d:	48 8d bc 24 d8 05 00 	lea    0x5d8(%rsp),%rdi
  5aef14:	00 
  5aef15:	e8 b6 01 18 00       	call   72f0d0 <_RNvXNtNtNtCscdodAO9FK5_5alloc11collections5btree3mapINtB2_8BTreeMapTINtNtCs4NRVxsYgnAr_4core6option6OptionyENtNtCs6gaF1xUz9Bf_4gpui4list6ListIdNtNtB1M_7element8NodeKindEjENtNtNtB19_3ops4drop4Drop4dropB1M_>
  5aef1a:	48 8d bc 24 c0 05 00 	lea    0x5c0(%rsp),%rdi
  5aef21:	00 
  5aef22:	e8 a9 01 18 00       	call   72f0d0 <_RNvXNtNtNtCscdodAO9FK5_5alloc11collections5btree3mapINtB2_8BTreeMapTINtNtCs4NRVxsYgnAr_4core6option6OptionyENtNtCs6gaF1xUz9Bf_4gpui4list6ListIdNtNtB1M_7element8NodeKindEjENtNtNtB19_3ops4drop4Drop4dropB1M_>
  5aef27:	48 8d bc 24 a8 05 00 	lea    0x5a8(%rsp),%rdi
  5aef2e:	00 
  5aef2f:	e8 0c 05 18 00       	call   72f440 <_RNvXNtNtNtCscdodAO9FK5_5alloc11collections5btree3mapINtB2_8BTreeMapTINtNtCs4NRVxsYgnAr_4core6option6OptionyEmNtNtCs6gaF1xUz9Bf_4gpui7element8NodeKindEjENtNtNtB19_3ops4drop4Drop4dropB1N_>
  5aef34:	48 8d bc 24 88 04 00 	lea    0x488(%rsp),%rdi
  5aef3b:	00 
  5aef3c:	e8 df d2 12 00       	call   6dc220 <_RNvXso_NtCscdodAO9FK5_5alloc3vecINtB5_3VecINtNtCs4NRVxsYgnAr_4core6option6OptionNtNtCs6gaF1xUz9Bf_4gpui7runtime4NodeEENtNtNtBJ_3ops4drop4Drop4dropB1k_>
  5aef41:	48 8b 84 24 88 04 00 	mov    0x488(%rsp),%rax
  5aef48:	00 
  5aef49:	48 85 c0             	test   %rax,%rax
  5aef4c:	74 1b                	je     5aef69 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4f39>
  5aef4e:	48 8b bc 24 90 04 00 	mov    0x490(%rsp),%rdi
  5aef55:	00 
  5aef56:	48 c1 e0 03          	shl    $0x3,%rax
  5aef5a:	48 8d 34 80          	lea    (%rax,%rax,4),%rsi
  5aef5e:	ba 08 00 00 00       	mov    $0x8,%edx
  5aef63:	ff 15 8f ae 53 00    	call   *0x53ae8f(%rip)        # ae9df8 <_DYNAMIC+0x248>
  5aef69:	48 8b 84 24 40 05 00 	mov    0x540(%rsp),%rax
  5aef70:	00 
  5aef71:	48 85 c0             	test   %rax,%rax
  5aef74:	74 6a                	je     5aefe0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4fb0>
  5aef76:	48 83 f8 01          	cmp    $0x1,%rax
  5aef7a:	75 20                	jne    5aef9c <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4f6c>
  5aef7c:	48 8b 84 24 48 05 00 	mov    0x548(%rsp),%rax
  5aef83:	00 
  5aef84:	48 85 c0             	test   %rax,%rax
  5aef87:	74 57                	je     5aefe0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4fb0>
  5aef89:	48 8b bc 24 50 05 00 	mov    0x550(%rsp),%rdi
  5aef90:	00 
  5aef91:	48 6b f0 58          	imul   $0x58,%rax,%rsi
  5aef95:	ba 04 00 00 00       	mov    $0x4,%edx
  5aef9a:	eb 3e                	jmp    5aefda <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4faa>
  5aef9c:	48 8b 84 24 50 05 00 	mov    0x550(%rsp),%rax
  5aefa3:	00 
  5aefa4:	48 85 c0             	test   %rax,%rax
  5aefa7:	74 17                	je     5aefc0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4f90>
  5aefa9:	48 8b bc 24 48 05 00 	mov    0x548(%rsp),%rdi
  5aefb0:	00 
  5aefb1:	48 6b f0 58          	imul   $0x58,%rax,%rsi
  5aefb5:	ba 04 00 00 00       	mov    $0x4,%edx
  5aefba:	ff 15 38 ae 53 00    	call   *0x53ae38(%rip)        # ae9df8 <_DYNAMIC+0x248>
  5aefc0:	48 8b b4 24 60 05 00 	mov    0x560(%rsp),%rsi
  5aefc7:	00 
  5aefc8:	48 85 f6             	test   %rsi,%rsi
  5aefcb:	74 13                	je     5aefe0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4fb0>
  5aefcd:	48 8b bc 24 58 05 00 	mov    0x558(%rsp),%rdi
  5aefd4:	00 
  5aefd5:	ba 01 00 00 00       	mov    $0x1,%edx
  5aefda:	ff 15 18 ae 53 00    	call   *0x53ae18(%rip)        # ae9df8 <_DYNAMIC+0x248>
  5aefe0:	48 8d bc 24 58 04 00 	lea    0x458(%rsp),%rdi
  5aefe7:	00 
  5aefe8:	e8 63 f8 17 00       	call   72e850 <_RNvXNtNtNtCscdodAO9FK5_5alloc11collections5btree3mapINtB2_8BTreeMapNtNtCs6gaF1xUz9Bf_4gpui6source7FieldIdNtNtB17_11shared_text10SharedTextENtNtNtCs4NRVxsYgnAr_4core3ops4drop4Drop4dropB17_>
  5aefed:	40 84 ed             	test   %bpl,%bpl
  5aeff0:	74 24                	je     5af016 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4fe6>
  5aeff2:	48 8b b4 24 b8 02 00 	mov    0x2b8(%rsp),%rsi
  5aeff9:	00 
  5aeffa:	48 85 f6             	test   %rsi,%rsi
  5aeffd:	74 17                	je     5af016 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4fe6>
  5aefff:	48 8b bc 24 c0 02 00 	mov    0x2c0(%rsp),%rdi
  5af006:	00 
  5af007:	48 c1 e6 04          	shl    $0x4,%rsi
  5af00b:	ba 08 00 00 00       	mov    $0x8,%edx
  5af010:	ff 15 e2 ad 53 00    	call   *0x53ade2(%rip)        # ae9df8 <_DYNAMIC+0x248>
  5af016:	ba 08 00 00 00       	mov    $0x8,%edx
  5af01b:	48 8b bc 24 e0 02 00 	mov    0x2e0(%rsp),%rdi
  5af022:	00 
  5af023:	48 8b b4 24 c8 04 00 	mov    0x4c8(%rsp),%rsi
  5af02a:	00 
  5af02b:	ff 15 c7 ad 53 00    	call   *0x53adc7(%rip)        # ae9df8 <_DYNAMIC+0x248>
  5af031:	48 8b b4 24 a0 02 00 	mov    0x2a0(%rsp),%rsi
  5af038:	00 
  5af039:	48 85 f6             	test   %rsi,%rsi
  5af03c:	74 17                	je     5af055 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5025>
  5af03e:	48 8b bc 24 a8 02 00 	mov    0x2a8(%rsp),%rdi
  5af045:	00 
  5af046:	48 c1 e6 02          	shl    $0x2,%rsi
  5af04a:	ba 04 00 00 00       	mov    $0x4,%edx
  5af04f:	ff 15 a3 ad 53 00    	call   *0x53ada3(%rip)        # ae9df8 <_DYNAMIC+0x248>
  5af055:	48 8b b4 24 88 02 00 	mov    0x288(%rsp),%rsi
  5af05c:	00 
  5af05d:	48 85 f6             	test   %rsi,%rsi
  5af060:	74 17                	je     5af079 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5049>
  5af062:	48 8b bc 24 90 02 00 	mov    0x290(%rsp),%rdi
  5af069:	00 
  5af06a:	48 c1 e6 03          	shl    $0x3,%rsi
  5af06e:	ba 08 00 00 00       	mov    $0x8,%edx
  5af073:	ff 15 7f ad 53 00    	call   *0x53ad7f(%rip)        # ae9df8 <_DYNAMIC+0x248>
  5af079:	48 8b b4 24 e8 02 00 	mov    0x2e8(%rsp),%rsi
  5af080:	00 
  5af081:	48 85 f6             	test   %rsi,%rsi
  5af084:	74 17                	je     5af09d <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x506d>
  5af086:	48 8b bc 24 f0 02 00 	mov    0x2f0(%rsp),%rdi
  5af08d:	00 
  5af08e:	48 c1 e6 03          	shl    $0x3,%rsi
  5af092:	ba 08 00 00 00       	mov    $0x8,%edx
  5af097:	ff 15 5b ad 53 00    	call   *0x53ad5b(%rip)        # ae9df8 <_DYNAMIC+0x248>
  5af09d:	45 31 f6             	xor    %r14d,%r14d
  5af0a0:	48 8d bc 24 20 06 00 	lea    0x620(%rsp),%rdi
  5af0a7:	00 
  5af0a8:	e8 f3 06 18 00       	call   72f7a0 <_RNvXNtNtNtCscdodAO9FK5_5alloc11collections5btree3mapINtB2_8BTreeMapjNtNtCs6gaF1xUz9Bf_4gpui4list6ListIdENtNtNtCs4NRVxsYgnAr_4core3ops4drop4Drop4dropB18_>
  5af0ad:	45 31 ed             	xor    %r13d,%r13d
  5af0b0:	48 8d bc 24 c0 06 00 	lea    0x6c0(%rsp),%rdi
  5af0b7:	00 
  5af0b8:	89 eb                	mov    %ebp,%ebx
  5af0ba:	45 31 ff             	xor    %r15d,%r15d
  5af0bd:	e8 6e e9 17 00       	call   72da30 <_RNvXNtNtNtCscdodAO9FK5_5alloc11collections5btree3mapINtB2_8BTreeMapINtNtCs4NRVxsYgnAr_4core6option6OptionyEjENtNtNtB18_3ops4drop4Drop4dropCs6gaF1xUz9Bf_4gpui>
  5af0c2:	45 31 ed             	xor    %r13d,%r13d
  5af0c5:	48 8d bc 24 a8 06 00 	lea    0x6a8(%rsp),%rdi
  5af0cc:	00 
  5af0cd:	45 31 ff             	xor    %r15d,%r15d
  5af0d0:	8b 6c 24 20          	mov    0x20(%rsp),%ebp
  5af0d4:	e8 c7 06 18 00       	call   72f7a0 <_RNvXNtNtNtCscdodAO9FK5_5alloc11collections5btree3mapINtB2_8BTreeMapjNtNtCs6gaF1xUz9Bf_4gpui4list6ListIdENtNtNtCs4NRVxsYgnAr_4core3ops4drop4Drop4dropB18_>
  5af0d9:	40 84 ed             	test   %bpl,%bpl
  5af0dc:	0f 84 67 05 00 00    	je     5af649 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5619>
  5af0e2:	48 8b 9c 24 48 04 00 	mov    0x448(%rsp),%rbx
  5af0e9:	00 
  5af0ea:	4c 8b b4 24 50 04 00 	mov    0x450(%rsp),%r14
  5af0f1:	00 
  5af0f2:	4d 85 f6             	test   %r14,%r14
  5af0f5:	74 5d                	je     5af154 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5124>
  5af0f7:	4c 8d 7b 20          	lea    0x20(%rbx),%r15
  5af0fb:	4c 8b 25 f6 ac 53 00 	mov    0x53acf6(%rip),%r12        # ae9df8 <_DYNAMIC+0x248>
  5af102:	eb 15                	jmp    5af119 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x50e9>
  5af104:	66 66 66 2e 0f 1f 84 	data16 data16 cs nopw 0x0(%rax,%rax,1)
  5af10b:	00 00 00 00 00 
  5af110:	49 83 c7 38          	add    $0x38,%r15
  5af114:	49 ff ce             	dec    %r14
  5af117:	74 3b                	je     5af154 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5124>
  5af119:	49 8b 77 e0          	mov    -0x20(%r15),%rsi
  5af11d:	48 83 fe ff          	cmp    $0xffffffffffffffff,%rsi
  5af121:	74 13                	je     5af136 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5106>
  5af123:	48 85 f6             	test   %rsi,%rsi
  5af126:	78 0e                	js     5af136 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5106>
  5af128:	74 0c                	je     5af136 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5106>
  5af12a:	49 8b 7f e8          	mov    -0x18(%r15),%rdi
  5af12e:	ba 01 00 00 00       	mov    $0x1,%edx
  5af133:	41 ff d4             	call   *%r12
  5af136:	49 8b 77 f8          	mov    -0x8(%r15),%rsi
  5af13a:	48 83 fe ff          	cmp    $0xffffffffffffffff,%rsi
  5af13e:	74 d0                	je     5af110 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x50e0>
  5af140:	48 85 f6             	test   %rsi,%rsi
  5af143:	78 cb                	js     5af110 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x50e0>
  5af145:	74 c9                	je     5af110 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x50e0>
  5af147:	49 8b 3f             	mov    (%r15),%rdi
  5af14a:	ba 01 00 00 00       	mov    $0x1,%edx
  5af14f:	41 ff d4             	call   *%r12
  5af152:	eb bc                	jmp    5af110 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x50e0>
  5af154:	48 8b 84 24 40 04 00 	mov    0x440(%rsp),%rax
  5af15b:	00 
  5af15c:	48 85 c0             	test   %rax,%rax
  5af15f:	0f 84 e4 04 00 00    	je     5af649 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5619>
  5af165:	48 6b f0 38          	imul   $0x38,%rax,%rsi
  5af169:	e9 cd 04 00 00       	jmp    5af63b <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x560b>
  5af16e:	48 8d 9c 24 00 03 00 	lea    0x300(%rsp),%rbx
  5af175:	00 
  5af176:	4c 8d b4 24 a0 00 00 	lea    0xa0(%rsp),%r14
  5af17d:	00 
  5af17e:	4c 8b 2d d3 ac 53 00 	mov    0x53acd3(%rip),%r13        # ae9e58 <_DYNAMIC+0x2a8>
  5af185:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
  5af18c:	00 00 00 00 
  5af190:	4c 8b a4 24 18 03 00 	mov    0x318(%rsp),%r12
  5af197:	00 
  5af198:	4c 8b bc 24 20 03 00 	mov    0x320(%rsp),%r15
  5af19f:	00 
  5af1a0:	48 85 c0             	test   %rax,%rax
  5af1a3:	74 2b                	je     5af1d0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x51a0>
  5af1a5:	48 8b bc 24 10 03 00 	mov    0x310(%rsp),%rdi
  5af1ac:	00 
  5af1ad:	48 85 ff             	test   %rdi,%rdi
  5af1b0:	74 1e                	je     5af1d0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x51a0>
  5af1b2:	f6 07 01             	testb  $0x1,(%rdi)
  5af1b5:	75 19                	jne    5af1d0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x51a0>
  5af1b7:	48 8b 47 08          	mov    0x8(%rdi),%rax
  5af1bb:	a8 01                	test   $0x1,%al
  5af1bd:	75 11                	jne    5af1d0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x51a0>
  5af1bf:	48 8d 47 08          	lea    0x8(%rdi),%rax
  5af1c3:	f0 48 83 28 02       	lock subq $0x2,(%rax)
  5af1c8:	74 58                	je     5af222 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x51f2>
  5af1ca:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
  5af1d0:	4d 85 e4             	test   %r12,%r12
  5af1d3:	74 2b                	je     5af200 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x51d0>
  5af1d5:	4d 85 ff             	test   %r15,%r15
  5af1d8:	74 26                	je     5af200 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x51d0>
  5af1da:	41 f6 07 01          	testb  $0x1,(%r15)
  5af1de:	75 20                	jne    5af200 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x51d0>
  5af1e0:	49 8b 47 08          	mov    0x8(%r15),%rax
  5af1e4:	a8 01                	test   $0x1,%al
  5af1e6:	75 18                	jne    5af200 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x51d0>
  5af1e8:	49 8d 47 08          	lea    0x8(%r15),%rax
  5af1ec:	f0 48 83 28 02       	lock subq $0x2,(%rax)
  5af1f1:	74 38                	je     5af22b <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x51fb>
  5af1f3:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  5af1fa:	84 00 00 00 00 00 
  5af200:	48 89 df             	mov    %rbx,%rdi
  5af203:	4c 89 f6             	mov    %r14,%rsi
  5af206:	e8 25 21 18 00       	call   731330 <_RNvXsU_NtNtNtCscdodAO9FK5_5alloc11collections5btree3mapINtB5_9ExtractIfyAINtNtCs6gaF1xUz9Bf_4gpui8property12ContributionINtNtCs4NRVxsYgnAr_4core6option6OptionNtNtB1e_11shared_text10SharedTextEEj2_NtNtNtB1Z_3ops5range9RangeFullNCINvMsi_B5_INtB5_8BTreeMapyB18_E6retainNCNvMsq_NtB1e_7runtimeINtB4o_7RuntimeNtNtB4o_12style_ledger9AdversaryE14describe_innersB_0E0ENtNtNtNtB1Z_4iter6traits8iterator8Iterator4nextB1e_>
  5af20b:	48 8b 84 24 08 03 00 	mov    0x308(%rsp),%rax
  5af212:	00 
  5af213:	48 83 f8 02          	cmp    $0x2,%rax
  5af217:	0f 85 73 ff ff ff    	jne    5af190 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5160>
  5af21d:	e9 f1 fb ff ff       	jmp    5aee13 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4de3>
  5af222:	48 8b 47 08          	mov    0x8(%rdi),%rax
  5af226:	41 ff d5             	call   *%r13
  5af229:	eb a5                	jmp    5af1d0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x51a0>
  5af22b:	49 8b 47 08          	mov    0x8(%r15),%rax
  5af22f:	4c 89 ff             	mov    %r15,%rdi
  5af232:	41 ff d5             	call   *%r13
  5af235:	eb c9                	jmp    5af200 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x51d0>
  5af237:	b8 0c 00 00 00       	mov    $0xc,%eax
  5af23c:	0f a3 c8             	bt     %ecx,%eax
  5af23f:	0f 82 46 fc ff ff    	jb     5aee8b <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4e5b>
  5af245:	48 8d 3d 9c c8 ac ff 	lea    -0x533764(%rip),%rdi        # 7bae8 <anon.5f884de6e78125e25881320d811d32df.113.llvm.17146438997930651657+0x88>
  5af24c:	48 8d 15 4d 99 50 00 	lea    0x50994d(%rip),%rdx        # ab8ba0 <anon.c906c25ea787c8c2757c1f36aabcd0ba.64.llvm.18178969024155037896+0x130>
  5af253:	be a1 00 00 00       	mov    $0xa1,%esi
  5af258:	ff 15 d2 ab 53 00    	call   *0x53abd2(%rip)        # ae9e30 <_DYNAMIC+0x280>
  5af25e:	e9 69 09 00 00       	jmp    5afbcc <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5b9c>
  5af263:	48 8b 84 24 88 00 00 	mov    0x88(%rsp),%rax
  5af26a:	00 
  5af26b:	48 c7 00 1b 00 00 00 	movq   $0x1b,(%rax)
  5af272:	eb 0f                	jmp    5af283 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5253>
  5af274:	48 8b 84 24 88 00 00 	mov    0x88(%rsp),%rax
  5af27b:	00 
  5af27c:	48 c7 00 1c 00 00 00 	movq   $0x1c,(%rax)
  5af283:	48 8b 8c 24 80 00 00 	mov    0x80(%rsp),%rcx
  5af28a:	00 
  5af28b:	48 89 48 08          	mov    %rcx,0x8(%rax)
  5af28f:	48 8b 8c 24 30 02 00 	mov    0x230(%rsp),%rcx
  5af296:	00 
  5af297:	48 85 c9             	test   %rcx,%rcx
  5af29a:	0f 84 21 be ff ff    	je     5ab0c1 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1091>
  5af2a0:	48 8b 94 24 38 02 00 	mov    0x238(%rsp),%rdx
  5af2a7:	00 
  5af2a8:	48 8b 84 24 40 02 00 	mov    0x240(%rsp),%rax
  5af2af:	00 
  5af2b0:	48 c7 84 24 a8 00 00 	movq   $0x0,0xa8(%rsp)
  5af2b7:	00 00 00 00 00 
  5af2bc:	48 89 8c 24 b0 00 00 	mov    %rcx,0xb0(%rsp)
  5af2c3:	00 
  5af2c4:	48 89 94 24 b8 00 00 	mov    %rdx,0xb8(%rsp)
  5af2cb:	00 
  5af2cc:	48 c7 84 24 c8 00 00 	movq   $0x0,0xc8(%rsp)
  5af2d3:	00 00 00 00 00 
  5af2d8:	48 89 8c 24 d0 00 00 	mov    %rcx,0xd0(%rsp)
  5af2df:	00 
  5af2e0:	48 89 94 24 d8 00 00 	mov    %rdx,0xd8(%rsp)
  5af2e7:	00 
  5af2e8:	b9 01 00 00 00       	mov    $0x1,%ecx
  5af2ed:	48 89 8c 24 a0 00 00 	mov    %rcx,0xa0(%rsp)
  5af2f4:	00 
  5af2f5:	48 89 8c 24 c0 00 00 	mov    %rcx,0xc0(%rsp)
  5af2fc:	00 
  5af2fd:	48 89 84 24 e0 00 00 	mov    %rax,0xe0(%rsp)
  5af304:	00 
  5af305:	48 8d bc 24 00 03 00 	lea    0x300(%rsp),%rdi
  5af30c:	00 
  5af30d:	48 8d b4 24 a0 00 00 	lea    0xa0(%rsp),%rsi
  5af314:	00 
  5af315:	e8 c6 a0 17 00       	call   7293e0 <_RNvMsz_NtNtNtCscdodAO9FK5_5alloc11collections5btree3mapINtB5_8IntoIterNtNtCs6gaF1xUz9Bf_4gpui6source7FieldIdNtNtB1a_7runtime6FanoutE10dying_nextB1a_.llvm.555413502705965614>
  5af31a:	48 8b 84 24 00 03 00 	mov    0x300(%rsp),%rax
  5af321:	00 
  5af322:	48 85 c0             	test   %rax,%rax
  5af325:	74 5f                	je     5af386 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5356>
  5af327:	48 8d 9c 24 00 03 00 	lea    0x300(%rsp),%rbx
  5af32e:	00 
  5af32f:	4c 8d b4 24 a0 00 00 	lea    0xa0(%rsp),%r14
  5af336:	00 
  5af337:	4c 8b 3d ba aa 53 00 	mov    0x53aaba(%rip),%r15        # ae9df8 <_DYNAMIC+0x248>
  5af33e:	66 90                	xchg   %ax,%ax
  5af340:	48 8b 8c 24 10 03 00 	mov    0x310(%rsp),%rcx
  5af347:	00 
  5af348:	48 8d 0c 89          	lea    (%rcx,%rcx,4),%rcx
  5af34c:	48 8b 74 c8 60       	mov    0x60(%rax,%rcx,8),%rsi
  5af351:	48 85 f6             	test   %rsi,%rsi
  5af354:	74 18                	je     5af36e <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x533e>
  5af356:	48 8d 04 c8          	lea    (%rax,%rcx,8),%rax
  5af35a:	48 83 c0 60          	add    $0x60,%rax
  5af35e:	48 8b 78 08          	mov    0x8(%rax),%rdi
  5af362:	48 c1 e6 02          	shl    $0x2,%rsi
  5af366:	ba 04 00 00 00       	mov    $0x4,%edx
  5af36b:	41 ff d7             	call   *%r15
  5af36e:	48 89 df             	mov    %rbx,%rdi
  5af371:	4c 89 f6             	mov    %r14,%rsi
  5af374:	e8 67 a0 17 00       	call   7293e0 <_RNvMsz_NtNtNtCscdodAO9FK5_5alloc11collections5btree3mapINtB5_8IntoIterNtNtCs6gaF1xUz9Bf_4gpui6source7FieldIdNtNtB1a_7runtime6FanoutE10dying_nextB1a_.llvm.555413502705965614>
  5af379:	48 8b 84 24 00 03 00 	mov    0x300(%rsp),%rax
  5af380:	00 
  5af381:	48 85 c0             	test   %rax,%rax
  5af384:	75 ba                	jne    5af340 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5310>
  5af386:	ba 08 00 00 00       	mov    $0x8,%edx
  5af38b:	48 8b bc 24 e0 02 00 	mov    0x2e0(%rsp),%rdi
  5af392:	00 
  5af393:	4a 8d 34 e5 08 00 00 	lea    0x8(,%r12,8),%rsi
  5af39a:	00 
  5af39b:	ff 15 57 aa 53 00    	call   *0x53aa57(%rip)        # ae9df8 <_DYNAMIC+0x248>
  5af3a1:	48 8b b4 24 a0 02 00 	mov    0x2a0(%rsp),%rsi
  5af3a8:	00 
  5af3a9:	48 85 f6             	test   %rsi,%rsi
  5af3ac:	74 17                	je     5af3c5 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5395>
  5af3ae:	48 8b bc 24 a8 02 00 	mov    0x2a8(%rsp),%rdi
  5af3b5:	00 
  5af3b6:	48 c1 e6 02          	shl    $0x2,%rsi
  5af3ba:	ba 04 00 00 00       	mov    $0x4,%edx
  5af3bf:	ff 15 33 aa 53 00    	call   *0x53aa33(%rip)        # ae9df8 <_DYNAMIC+0x248>
  5af3c5:	48 8b b4 24 88 02 00 	mov    0x288(%rsp),%rsi
  5af3cc:	00 
  5af3cd:	48 85 f6             	test   %rsi,%rsi
  5af3d0:	74 17                	je     5af3e9 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x53b9>
  5af3d2:	48 8b bc 24 90 02 00 	mov    0x290(%rsp),%rdi
  5af3d9:	00 
  5af3da:	48 c1 e6 03          	shl    $0x3,%rsi
  5af3de:	ba 08 00 00 00       	mov    $0x8,%edx
  5af3e3:	ff 15 0f aa 53 00    	call   *0x53aa0f(%rip)        # ae9df8 <_DYNAMIC+0x248>
  5af3e9:	48 8b b4 24 e8 02 00 	mov    0x2e8(%rsp),%rsi
  5af3f0:	00 
  5af3f1:	48 85 f6             	test   %rsi,%rsi
  5af3f4:	74 17                	je     5af40d <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x53dd>
  5af3f6:	48 8b bc 24 f0 02 00 	mov    0x2f0(%rsp),%rdi
  5af3fd:	00 
  5af3fe:	48 c1 e6 03          	shl    $0x3,%rsi
  5af402:	ba 08 00 00 00       	mov    $0x8,%edx
  5af407:	ff 15 eb a9 53 00    	call   *0x53a9eb(%rip)        # ae9df8 <_DYNAMIC+0x248>
  5af40d:	40 b5 01             	mov    $0x1,%bpl
  5af410:	48 8d bc 24 20 06 00 	lea    0x620(%rsp),%rdi
  5af417:	00 
  5af418:	41 b6 01             	mov    $0x1,%r14b
  5af41b:	e8 80 03 18 00       	call   72f7a0 <_RNvXNtNtNtCscdodAO9FK5_5alloc11collections5btree3mapINtB2_8BTreeMapjNtNtCs6gaF1xUz9Bf_4gpui4list6ListIdENtNtNtCs4NRVxsYgnAr_4core3ops4drop4Drop4dropB18_>
  5af420:	48 8b 84 24 80 04 00 	mov    0x480(%rsp),%rax
  5af427:	00 
  5af428:	48 85 c0             	test   %rax,%rax
  5af42b:	74 41                	je     5af46e <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x543e>
  5af42d:	48 8b 9c 24 78 04 00 	mov    0x478(%rsp),%rbx
  5af434:	00 
  5af435:	41 be 01 00 00 00    	mov    $0x1,%r14d
  5af43b:	49 29 c6             	sub    %rax,%r14
  5af43e:	4c 8b 3d f3 a9 53 00 	mov    0x53a9f3(%rip),%r15        # ae9e38 <_DYNAMIC+0x288>
  5af445:	eb 16                	jmp    5af45d <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x542d>
  5af447:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
  5af44e:	00 00 
  5af450:	48 83 c3 08          	add    $0x8,%rbx
  5af454:	49 ff c6             	inc    %r14
  5af457:	49 83 fe 01          	cmp    $0x1,%r14
  5af45b:	74 11                	je     5af46e <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x543e>
  5af45d:	48 8b 03             	mov    (%rbx),%rax
  5af460:	f0 48 ff 08          	lock decq (%rax)
  5af464:	75 ea                	jne    5af450 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5420>
  5af466:	48 89 df             	mov    %rbx,%rdi
  5af469:	41 ff d7             	call   *%r15
  5af46c:	eb e2                	jmp    5af450 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5420>
  5af46e:	48 8b b4 24 70 04 00 	mov    0x470(%rsp),%rsi
  5af475:	00 
  5af476:	48 85 f6             	test   %rsi,%rsi
  5af479:	74 17                	je     5af492 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5462>
  5af47b:	48 8b bc 24 78 04 00 	mov    0x478(%rsp),%rdi
  5af482:	00 
  5af483:	48 c1 e6 03          	shl    $0x3,%rsi
  5af487:	ba 08 00 00 00       	mov    $0x8,%edx
  5af48c:	ff 15 66 a9 53 00    	call   *0x53a966(%rip)        # ae9df8 <_DYNAMIC+0x248>
  5af492:	45 31 ed             	xor    %r13d,%r13d
  5af495:	b3 01                	mov    $0x1,%bl
  5af497:	48 8d bc 24 c0 06 00 	lea    0x6c0(%rsp),%rdi
  5af49e:	00 
  5af49f:	41 b7 01             	mov    $0x1,%r15b
  5af4a2:	e8 89 e5 17 00       	call   72da30 <_RNvXNtNtNtCscdodAO9FK5_5alloc11collections5btree3mapINtB2_8BTreeMapINtNtCs4NRVxsYgnAr_4core6option6OptionyEjENtNtNtB18_3ops4drop4Drop4dropCs6gaF1xUz9Bf_4gpui>
  5af4a7:	40 b5 01             	mov    $0x1,%bpl
  5af4aa:	48 8d bc 24 a8 06 00 	lea    0x6a8(%rsp),%rdi
  5af4b1:	00 
  5af4b2:	41 b7 01             	mov    $0x1,%r15b
  5af4b5:	e8 e6 02 18 00       	call   72f7a0 <_RNvXNtNtNtCscdodAO9FK5_5alloc11collections5btree3mapINtB2_8BTreeMapjNtNtCs6gaF1xUz9Bf_4gpui4list6ListIdENtNtNtCs4NRVxsYgnAr_4core3ops4drop4Drop4dropB18_>
  5af4ba:	48 8b 8c 24 e8 04 00 	mov    0x4e8(%rsp),%rcx
  5af4c1:	00 
  5af4c2:	48 85 c9             	test   %rcx,%rcx
  5af4c5:	0f 95 c0             	setne  %al
  5af4c8:	41 84 c5             	test   %al,%r13b
  5af4cb:	74 1b                	je     5af4e8 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x54b8>
  5af4cd:	48 c1 e1 03          	shl    $0x3,%rcx
  5af4d1:	48 8d 34 49          	lea    (%rcx,%rcx,2),%rsi
  5af4d5:	ba 08 00 00 00       	mov    $0x8,%edx
  5af4da:	48 8b bc 24 e0 04 00 	mov    0x4e0(%rsp),%rdi
  5af4e1:	00 
  5af4e2:	ff 15 10 a9 53 00    	call   *0x53a910(%rip)        # ae9df8 <_DYNAMIC+0x248>
  5af4e8:	48 8b 9c 24 48 04 00 	mov    0x448(%rsp),%rbx
  5af4ef:	00 
  5af4f0:	4c 8b b4 24 50 04 00 	mov    0x450(%rsp),%r14
  5af4f7:	00 
  5af4f8:	4d 85 f6             	test   %r14,%r14
  5af4fb:	74 57                	je     5af554 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5524>
  5af4fd:	4c 8d 7b 20          	lea    0x20(%rbx),%r15
  5af501:	4c 8b 2d f0 a8 53 00 	mov    0x53a8f0(%rip),%r13        # ae9df8 <_DYNAMIC+0x248>
  5af508:	eb 0f                	jmp    5af519 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x54e9>
  5af50a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
  5af510:	49 83 c7 38          	add    $0x38,%r15
  5af514:	49 ff ce             	dec    %r14
  5af517:	74 3b                	je     5af554 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5524>
  5af519:	49 8b 77 e0          	mov    -0x20(%r15),%rsi
  5af51d:	48 83 fe ff          	cmp    $0xffffffffffffffff,%rsi
  5af521:	74 13                	je     5af536 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5506>
  5af523:	48 85 f6             	test   %rsi,%rsi
  5af526:	78 0e                	js     5af536 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5506>
  5af528:	74 0c                	je     5af536 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5506>
  5af52a:	49 8b 7f e8          	mov    -0x18(%r15),%rdi
  5af52e:	ba 01 00 00 00       	mov    $0x1,%edx
  5af533:	41 ff d5             	call   *%r13
  5af536:	49 8b 77 f8          	mov    -0x8(%r15),%rsi
  5af53a:	48 83 fe ff          	cmp    $0xffffffffffffffff,%rsi
  5af53e:	74 d0                	je     5af510 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x54e0>
  5af540:	48 85 f6             	test   %rsi,%rsi
  5af543:	78 cb                	js     5af510 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x54e0>
  5af545:	74 c9                	je     5af510 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x54e0>
  5af547:	49 8b 3f             	mov    (%r15),%rdi
  5af54a:	ba 01 00 00 00       	mov    $0x1,%edx
  5af54f:	41 ff d5             	call   *%r13
  5af552:	eb bc                	jmp    5af510 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x54e0>
  5af554:	48 8b 84 24 40 04 00 	mov    0x440(%rsp),%rax
  5af55b:	00 
  5af55c:	48 85 c0             	test   %rax,%rax
  5af55f:	74 12                	je     5af573 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5543>
  5af561:	48 6b f0 38          	imul   $0x38,%rax,%rsi
  5af565:	ba 08 00 00 00       	mov    $0x8,%edx
  5af56a:	48 89 df             	mov    %rbx,%rdi
  5af56d:	ff 15 85 a8 53 00    	call   *0x53a885(%rip)        # ae9df8 <_DYNAMIC+0x248>
  5af573:	48 8b 9c 24 f8 04 00 	mov    0x4f8(%rsp),%rbx
  5af57a:	00 
  5af57b:	4c 8b b4 24 00 05 00 	mov    0x500(%rsp),%r14
  5af582:	00 
  5af583:	4d 85 f6             	test   %r14,%r14
  5af586:	74 57                	je     5af5df <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x55af>
  5af588:	4c 8d bb 88 00 00 00 	lea    0x88(%rbx),%r15
  5af58f:	4c 8b 2d 62 a8 53 00 	mov    0x53a862(%rip),%r13        # ae9df8 <_DYNAMIC+0x248>
  5af596:	eb 14                	jmp    5af5ac <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x557c>
  5af598:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  5af59f:	00 
  5af5a0:	49 81 c7 a8 00 00 00 	add    $0xa8,%r15
  5af5a7:	49 ff ce             	dec    %r14
  5af5aa:	74 33                	je     5af5df <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x55af>
  5af5ac:	49 8b 77 90          	mov    -0x70(%r15),%rsi
  5af5b0:	48 85 f6             	test   %rsi,%rsi
  5af5b3:	74 10                	je     5af5c5 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5595>
  5af5b5:	49 8b 7f 98          	mov    -0x68(%r15),%rdi
  5af5b9:	48 c1 e6 03          	shl    $0x3,%rsi
  5af5bd:	ba 08 00 00 00       	mov    $0x8,%edx
  5af5c2:	41 ff d5             	call   *%r13
  5af5c5:	49 8b 77 f8          	mov    -0x8(%r15),%rsi
  5af5c9:	48 85 f6             	test   %rsi,%rsi
  5af5cc:	74 d2                	je     5af5a0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5570>
  5af5ce:	49 8b 3f             	mov    (%r15),%rdi
  5af5d1:	48 c1 e6 05          	shl    $0x5,%rsi
  5af5d5:	ba 08 00 00 00       	mov    $0x8,%edx
  5af5da:	41 ff d5             	call   *%r13
  5af5dd:	eb c1                	jmp    5af5a0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5570>
  5af5df:	48 8b 84 24 f0 04 00 	mov    0x4f0(%rsp),%rax
  5af5e6:	00 
  5af5e7:	48 85 c0             	test   %rax,%rax
  5af5ea:	74 15                	je     5af601 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x55d1>
  5af5ec:	48 69 f0 a8 00 00 00 	imul   $0xa8,%rax,%rsi
  5af5f3:	ba 08 00 00 00       	mov    $0x8,%edx
  5af5f8:	48 89 df             	mov    %rbx,%rdi
  5af5fb:	ff 15 f7 a7 53 00    	call   *0x53a7f7(%rip)        # ae9df8 <_DYNAMIC+0x248>
  5af601:	48 8b 9c 24 40 06 00 	mov    0x640(%rsp),%rbx
  5af608:	00 
  5af609:	49 ff c4             	inc    %r12
  5af60c:	48 89 df             	mov    %rbx,%rdi
  5af60f:	90                   	nop
  5af610:	49 83 fc 01          	cmp    $0x1,%r12
  5af614:	74 14                	je     5af62a <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x55fa>
  5af616:	4c 8d b7 98 00 00 00 	lea    0x98(%rdi),%r14
  5af61d:	49 ff cc             	dec    %r12
  5af620:	e8 db 6a 12 00       	call   6d6100 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueNtNtCs6gaF1xUz9Bf_4gpui7element9DraftNodeEBF_.llvm.6411074540271373818>
  5af625:	4c 89 f7             	mov    %r14,%rdi
  5af628:	eb e6                	jmp    5af610 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x55e0>
  5af62a:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  5af62f:	48 85 c0             	test   %rax,%rax
  5af632:	74 15                	je     5af649 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5619>
  5af634:	48 69 f0 98 00 00 00 	imul   $0x98,%rax,%rsi
  5af63b:	ba 08 00 00 00       	mov    $0x8,%edx
  5af640:	48 89 df             	mov    %rbx,%rdi
  5af643:	ff 15 af a7 53 00    	call   *0x53a7af(%rip)        # ae9df8 <_DYNAMIC+0x248>
  5af649:	48 8d bc 24 d8 06 00 	lea    0x6d8(%rsp),%rdi
  5af650:	00 
  5af651:	e8 8a eb 17 00       	call   72e1e0 <_RNvXNtNtNtCscdodAO9FK5_5alloc11collections5btree3mapINtB2_8BTreeMapNtNtCs6gaF1xUz9Bf_4gpui4list6ListIdNtNtB4_7set_val9SetValZSTENtNtNtCs4NRVxsYgnAr_4core3ops4drop4Drop4dropB17_>
  5af656:	48 81 c4 b8 07 00 00 	add    $0x7b8,%rsp
  5af65d:	5b                   	pop    %rbx
  5af65e:	41 5c                	pop    %r12
  5af660:	41 5d                	pop    %r13
  5af662:	41 5e                	pop    %r14
  5af664:	41 5f                	pop    %r15
  5af666:	5d                   	pop    %rbp
  5af667:	c3                   	ret
  5af668:	48 8b 8c 24 b0 00 00 	mov    0xb0(%rsp),%rcx
  5af66f:	00 
  5af670:	48 8b 94 24 88 00 00 	mov    0x88(%rsp),%rdx
  5af677:	00 
  5af678:	48 c7 02 1f 00 00 00 	movq   $0x1f,(%rdx)
  5af67f:	48 89 42 08          	mov    %rax,0x8(%rdx)
  5af683:	4c 89 7a 10          	mov    %r15,0x10(%rdx)
  5af687:	48 89 4a 18          	mov    %rcx,0x18(%rdx)
  5af68b:	48 8b 8c 24 30 02 00 	mov    0x230(%rsp),%rcx
  5af692:	00 
  5af693:	48 85 c9             	test   %rcx,%rcx
  5af696:	0f 85 04 fc ff ff    	jne    5af2a0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5270>
  5af69c:	e9 20 ba ff ff       	jmp    5ab0c1 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1091>
  5af6a1:	48 8d 3d 6b c5 ac ff 	lea    -0x533a95(%rip),%rdi        # 7bc13 <anon.c906c25ea787c8c2757c1f36aabcd0ba.91.llvm.18178969024155037896+0x5e>
  5af6a8:	48 8d 15 c1 97 50 00 	lea    0x5097c1(%rip),%rdx        # ab8e70 <anon.c906c25ea787c8c2757c1f36aabcd0ba.92.llvm.18178969024155037896+0x240>
  5af6af:	be 1b 00 00 00       	mov    $0x1b,%esi
  5af6b4:	ff 15 a6 a7 53 00    	call   *0x53a7a6(%rip)        # ae9e60 <_DYNAMIC+0x2b0>
  5af6ba:	e9 0d 05 00 00       	jmp    5afbcc <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5b9c>
  5af6bf:	48 8d 3d 7a 97 50 00 	lea    0x50977a(%rip),%rdi        # ab8e40 <anon.c906c25ea787c8c2757c1f36aabcd0ba.92.llvm.18178969024155037896+0x210>
  5af6c6:	ff 15 9c a7 53 00    	call   *0x53a79c(%rip)        # ae9e68 <_DYNAMIC+0x2b8>
  5af6cc:	e9 fb 04 00 00       	jmp    5afbcc <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5b9c>
  5af6d1:	48 8d 3d 40 d5 50 00 	lea    0x50d540(%rip),%rdi        # abcc18 <anon.44dba9ca3a5ffd621ac1ab2f4c761e66.4.llvm.12823008243119239470>
  5af6d8:	ff 15 8a a7 53 00    	call   *0x53a78a(%rip)        # ae9e68 <_DYNAMIC+0x2b8>
  5af6de:	e9 e9 04 00 00       	jmp    5afbcc <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5b9c>
  5af6e3:	48 8d 3d c6 92 50 00 	lea    0x5092c6(%rip),%rdi        # ab89b0 <anon.c906c25ea787c8c2757c1f36aabcd0ba.27.llvm.18178969024155037896+0x210>
  5af6ea:	ff 15 78 a7 53 00    	call   *0x53a778(%rip)        # ae9e68 <_DYNAMIC+0x2b8>
  5af6f0:	e9 d7 04 00 00       	jmp    5afbcc <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5b9c>
  5af6f5:	48 8d 3d 01 c5 ac ff 	lea    -0x533aff(%rip),%rdi        # 7bbfd <anon.c906c25ea787c8c2757c1f36aabcd0ba.91.llvm.18178969024155037896+0x48>
  5af6fc:	48 8d 15 f5 96 50 00 	lea    0x5096f5(%rip),%rdx        # ab8df8 <anon.c906c25ea787c8c2757c1f36aabcd0ba.92.llvm.18178969024155037896+0x1c8>
  5af703:	be 16 00 00 00       	mov    $0x16,%esi
  5af708:	ff 15 52 a7 53 00    	call   *0x53a752(%rip)        # ae9e60 <_DYNAMIC+0x2b0>
  5af70e:	e9 b9 04 00 00       	jmp    5afbcc <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5b9c>
  5af713:	48 8b 84 24 88 00 00 	mov    0x88(%rsp),%rax
  5af71a:	00 
  5af71b:	48 c7 00 1e 00 00 00 	movq   $0x1e,(%rax)
  5af722:	41 b5 01             	mov    $0x1,%r13b
  5af725:	e9 6d fd ff ff       	jmp    5af497 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5467>
  5af72a:	48 8d 3d b7 c3 ac ff 	lea    -0x533c49(%rip),%rdi        # 7bae8 <anon.5f884de6e78125e25881320d811d32df.113.llvm.17146438997930651657+0x88>
  5af731:	48 8d 15 68 94 50 00 	lea    0x509468(%rip),%rdx        # ab8ba0 <anon.c906c25ea787c8c2757c1f36aabcd0ba.64.llvm.18178969024155037896+0x130>
  5af738:	be a1 00 00 00       	mov    $0xa1,%esi
  5af73d:	ff 15 ed a6 53 00    	call   *0x53a6ed(%rip)        # ae9e30 <_DYNAMIC+0x280>
  5af743:	e9 84 04 00 00       	jmp    5afbcc <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5b9c>
  5af748:	48 8d 3d a0 fd ac ff 	lea    -0x530260(%rip),%rdi        # 7f4ef <anon.45400ae144863d14b1a5886db4cd3638.66.llvm.4697723738452961617>
  5af74f:	48 8d 15 da 0f 51 00 	lea    0x510fda(%rip),%rdx        # ac0730 <anon.45400ae144863d14b1a5886db4cd3638.68.llvm.4697723738452961617>
  5af756:	be 22 00 00 00       	mov    $0x22,%esi
  5af75b:	ff 15 a7 a8 53 00    	call   *0x53a8a7(%rip)        # aea008 <_DYNAMIC+0x458>
  5af761:	e9 66 04 00 00       	jmp    5afbcc <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5b9c>
  5af766:	41 b7 01             	mov    $0x1,%r15b
  5af769:	48 8d 3d b6 bb ac ff 	lea    -0x53444a(%rip),%rdi        # 7b326 <anon.c906c25ea787c8c2757c1f36aabcd0ba.26.llvm.18178969024155037896>
  5af770:	48 8d 15 29 90 50 00 	lea    0x509029(%rip),%rdx        # ab87a0 <anon.c906c25ea787c8c2757c1f36aabcd0ba.27.llvm.18178969024155037896>
  5af777:	be 55 00 00 00       	mov    $0x55,%esi
  5af77c:	40 b5 01             	mov    $0x1,%bpl
  5af77f:	48 8b 5c 24 70       	mov    0x70(%rsp),%rbx
  5af784:	ff 15 a6 a6 53 00    	call   *0x53a6a6(%rip)        # ae9e30 <_DYNAMIC+0x280>
  5af78a:	e9 3d 04 00 00       	jmp    5afbcc <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5b9c>
  5af78f:	31 ed                	xor    %ebp,%ebp
  5af791:	48 8d 3d a0 c3 ac ff 	lea    -0x533c60(%rip),%rdi        # 7bb38 <anon.5f884de6e78125e25881320d811d32df.113.llvm.17146438997930651657+0xd8>
  5af798:	48 8d 15 19 94 50 00 	lea    0x509419(%rip),%rdx        # ab8bb8 <anon.c906c25ea787c8c2757c1f36aabcd0ba.64.llvm.18178969024155037896+0x148>
  5af79f:	be 37 00 00 00       	mov    $0x37,%esi
  5af7a4:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
  5af7a9:	48 89 44 24 30       	mov    %rax,0x30(%rsp)
  5af7ae:	48 89 5c 24 40       	mov    %rbx,0x40(%rsp)
  5af7b3:	48 8b 5c 24 70       	mov    0x70(%rsp),%rbx
  5af7b8:	44 8b 7c 24 18       	mov    0x18(%rsp),%r15d
  5af7bd:	ff 15 45 a8 53 00    	call   *0x53a845(%rip)        # aea008 <_DYNAMIC+0x458>
  5af7c3:	e9 04 04 00 00       	jmp    5afbcc <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5b9c>
  5af7c8:	48 8d 3d 57 bb ac ff 	lea    -0x5344a9(%rip),%rdi        # 7b326 <anon.c906c25ea787c8c2757c1f36aabcd0ba.26.llvm.18178969024155037896>
  5af7cf:	48 8d 15 ca 8f 50 00 	lea    0x508fca(%rip),%rdx        # ab87a0 <anon.c906c25ea787c8c2757c1f36aabcd0ba.27.llvm.18178969024155037896>
  5af7d6:	be 55 00 00 00       	mov    $0x55,%esi
  5af7db:	ff 15 4f a6 53 00    	call   *0x53a64f(%rip)        # ae9e30 <_DYNAMIC+0x280>
  5af7e1:	e9 e6 03 00 00       	jmp    5afbcc <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5b9c>
  5af7e6:	be 51 00 00 00       	mov    $0x51,%esi
  5af7eb:	48 8d 3d ce c2 ac ff 	lea    -0x533d32(%rip),%rdi        # 7bac0 <anon.5f884de6e78125e25881320d811d32df.113.llvm.17146438997930651657+0x60>
  5af7f2:	48 8d 15 8f 93 50 00 	lea    0x50938f(%rip),%rdx        # ab8b88 <anon.c906c25ea787c8c2757c1f36aabcd0ba.64.llvm.18178969024155037896+0x118>
  5af7f9:	31 ed                	xor    %ebp,%ebp
  5af7fb:	ff 15 2f a6 53 00    	call   *0x53a62f(%rip)        # ae9e30 <_DYNAMIC+0x280>
  5af801:	e9 c6 03 00 00       	jmp    5afbcc <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5b9c>
  5af806:	48 8d 3d e2 fc ac ff 	lea    -0x53031e(%rip),%rdi        # 7f4ef <anon.45400ae144863d14b1a5886db4cd3638.66.llvm.4697723738452961617>
  5af80d:	48 8d 15 1c 0f 51 00 	lea    0x510f1c(%rip),%rdx        # ac0730 <anon.45400ae144863d14b1a5886db4cd3638.68.llvm.4697723738452961617>
  5af814:	be 22 00 00 00       	mov    $0x22,%esi
  5af819:	ff 15 e9 a7 53 00    	call   *0x53a7e9(%rip)        # aea008 <_DYNAMIC+0x458>
  5af81f:	e9 a8 03 00 00       	jmp    5afbcc <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5b9c>
  5af824:	48 8d 3d bd c2 ac ff 	lea    -0x533d43(%rip),%rdi        # 7bae8 <anon.5f884de6e78125e25881320d811d32df.113.llvm.17146438997930651657+0x88>
  5af82b:	48 8d 15 6e 93 50 00 	lea    0x50936e(%rip),%rdx        # ab8ba0 <anon.c906c25ea787c8c2757c1f36aabcd0ba.64.llvm.18178969024155037896+0x130>
  5af832:	be a1 00 00 00       	mov    $0xa1,%esi
  5af837:	ff 15 f3 a5 53 00    	call   *0x53a5f3(%rip)        # ae9e30 <_DYNAMIC+0x280>
  5af83d:	e9 8a 03 00 00       	jmp    5afbcc <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5b9c>
  5af842:	be a1 00 00 00       	mov    $0xa1,%esi
  5af847:	48 8d 15 52 93 50 00 	lea    0x509352(%rip),%rdx        # ab8ba0 <anon.c906c25ea787c8c2757c1f36aabcd0ba.64.llvm.18178969024155037896+0x130>
  5af84e:	48 8d 3d 93 c2 ac ff 	lea    -0x533d6d(%rip),%rdi        # 7bae8 <anon.5f884de6e78125e25881320d811d32df.113.llvm.17146438997930651657+0x88>
  5af855:	eb a2                	jmp    5af7f9 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x57c9>
  5af857:	48 8d 3d b2 91 50 00 	lea    0x5091b2(%rip),%rdi        # ab8a10 <anon.c906c25ea787c8c2757c1f36aabcd0ba.27.llvm.18178969024155037896+0x270>
  5af85e:	ff 15 04 a6 53 00    	call   *0x53a604(%rip)        # ae9e68 <_DYNAMIC+0x2b8>
  5af864:	e9 63 03 00 00       	jmp    5afbcc <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5b9c>
  5af869:	48 8d 3d a8 8f 50 00 	lea    0x508fa8(%rip),%rdi        # ab8818 <anon.c906c25ea787c8c2757c1f36aabcd0ba.27.llvm.18178969024155037896+0x78>
  5af870:	ff 15 f2 a5 53 00    	call   *0x53a5f2(%rip)        # ae9e68 <_DYNAMIC+0x2b8>
  5af876:	e9 51 03 00 00       	jmp    5afbcc <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5b9c>
  5af87b:	48 83 fe 15          	cmp    $0x15,%rsi
  5af87f:	0f 83 49 03 00 00    	jae    5afbce <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5b9e>
  5af885:	48 8d 8c 24 a0 00 00 	lea    0xa0(%rsp),%rcx
  5af88c:	00 
  5af88d:	ba 01 00 00 00       	mov    $0x1,%edx
  5af892:	e8 79 30 0b 00       	call   662910 <_RINvNtNtNtNtCs4NRVxsYgnAr_4core5slice4sort6shared9smallsort25insertion_sort_shift_leftNtNtNtCs6gaF1xUz9Bf_4gpui7runtime8metadata8DeclaredNCINvMB8_SB1m_20sort_unstable_by_keyyNCNvMsq_B1q_INtB1q_7RuntimeINtNtNtB1q_8delivery5tests5FaultKh0_EE14describe_innersy_0E0EB1s_>
  5af897:	48 8b 5c 24 10       	mov    0x10(%rsp),%rbx
  5af89c:	e9 ff ef ff ff       	jmp    5ae8a0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4870>
  5af8a1:	48 8b 84 24 f8 01 00 	mov    0x1f8(%rsp),%rax
  5af8a8:	00 
  5af8a9:	48 89 84 24 b8 03 00 	mov    %rax,0x3b8(%rsp)
  5af8b0:	00 
  5af8b1:	48 8d 15 10 95 50 00 	lea    0x509510(%rip),%rdx        # ab8dc8 <anon.c906c25ea787c8c2757c1f36aabcd0ba.92.llvm.18178969024155037896+0x198>
  5af8b8:	ff 15 6a a5 53 00    	call   *0x53a56a(%rip)        # ae9e28 <_DYNAMIC+0x278>
  5af8be:	e9 09 03 00 00       	jmp    5afbcc <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5b9c>
  5af8c3:	bf 08 00 00 00       	mov    $0x8,%edi
  5af8c8:	be f0 00 00 00       	mov    $0xf0,%esi
  5af8cd:	ff 15 a5 a5 53 00    	call   *0x53a5a5(%rip)        # ae9e78 <_DYNAMIC+0x2c8>
  5af8d3:	e9 f4 02 00 00       	jmp    5afbcc <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5b9c>
  5af8d8:	48 8d 15 a1 94 50 00 	lea    0x5094a1(%rip),%rdx        # ab8d80 <anon.c906c25ea787c8c2757c1f36aabcd0ba.92.llvm.18178969024155037896+0x150>
  5af8df:	be 02 00 00 00       	mov    $0x2,%esi
  5af8e4:	48 89 df             	mov    %rbx,%rdi
  5af8e7:	ff 15 3b a5 53 00    	call   *0x53a53b(%rip)        # ae9e28 <_DYNAMIC+0x278>
  5af8ed:	e9 da 02 00 00       	jmp    5afbcc <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5b9c>
  5af8f2:	48 8d 15 9f 90 50 00 	lea    0x50909f(%rip),%rdx        # ab8998 <anon.c906c25ea787c8c2757c1f36aabcd0ba.27.llvm.18178969024155037896+0x1f8>
  5af8f9:	48 8b b4 24 30 04 00 	mov    0x430(%rsp),%rsi
  5af900:	00 
  5af901:	ff 15 21 a5 53 00    	call   *0x53a521(%rip)        # ae9e28 <_DYNAMIC+0x278>
  5af907:	e9 c0 02 00 00       	jmp    5afbcc <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5b9c>
  5af90c:	48 85 ff             	test   %rdi,%rdi
  5af90f:	75 6b                	jne    5af97c <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x594c>
  5af911:	ff 15 59 a5 53 00    	call   *0x53a559(%rip)        # ae9e70 <_DYNAMIC+0x2c0>
  5af917:	e9 b0 02 00 00       	jmp    5afbcc <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5b9c>
  5af91c:	48 8b 84 24 f8 01 00 	mov    0x1f8(%rsp),%rax
  5af923:	00 
  5af924:	48 89 84 24 b8 03 00 	mov    %rax,0x3b8(%rsp)
  5af92b:	00 
  5af92c:	48 8d 15 7d 94 50 00 	lea    0x50947d(%rip),%rdx        # ab8db0 <anon.c906c25ea787c8c2757c1f36aabcd0ba.92.llvm.18178969024155037896+0x180>
  5af933:	48 8b bc 24 80 02 00 	mov    0x280(%rsp),%rdi
  5af93a:	00 
  5af93b:	48 8b b4 24 60 02 00 	mov    0x260(%rsp),%rsi
  5af942:	00 
  5af943:	ff 15 df a4 53 00    	call   *0x53a4df(%rip)        # ae9e28 <_DYNAMIC+0x278>
  5af949:	e9 7e 02 00 00       	jmp    5afbcc <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5b9c>
  5af94e:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
  5af953:	48 8b b4 24 88 05 00 	mov    0x588(%rsp),%rsi
  5af95a:	00 
  5af95b:	48 8d 05 7e 94 50 00 	lea    0x50947e(%rip),%rax        # ab8de0 <anon.c906c25ea787c8c2757c1f36aabcd0ba.92.llvm.18178969024155037896+0x1b0>
  5af962:	e9 b6 00 00 00       	jmp    5afa1d <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x59ed>
  5af967:	48 8d 15 a2 94 50 00 	lea    0x5094a2(%rip),%rdx        # ab8e10 <anon.c906c25ea787c8c2757c1f36aabcd0ba.92.llvm.18178969024155037896+0x1e0>
  5af96e:	4c 89 f7             	mov    %r14,%rdi
  5af971:	ff 15 b1 a4 53 00    	call   *0x53a4b1(%rip)        # ae9e28 <_DYNAMIC+0x278>
  5af977:	e9 50 02 00 00       	jmp    5afbcc <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5b9c>
  5af97c:	48 8b b4 24 98 01 00 	mov    0x198(%rsp),%rsi
  5af983:	00 
  5af984:	ff 15 ee a4 53 00    	call   *0x53a4ee(%rip)        # ae9e78 <_DYNAMIC+0x2c8>
  5af98a:	e9 3d 02 00 00       	jmp    5afbcc <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5b9c>
  5af98f:	48 8d 15 92 90 50 00 	lea    0x509092(%rip),%rdx        # ab8a28 <anon.c906c25ea787c8c2757c1f36aabcd0ba.27.llvm.18178969024155037896+0x288>
  5af996:	48 8b bc 24 00 02 00 	mov    0x200(%rsp),%rdi
  5af99d:	00 
  5af99e:	ff 15 84 a4 53 00    	call   *0x53a484(%rip)        # ae9e28 <_DYNAMIC+0x278>
  5af9a4:	e9 23 02 00 00       	jmp    5afbcc <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5b9c>
  5af9a9:	48 8d 15 c0 91 50 00 	lea    0x5091c0(%rip),%rdx        # ab8b70 <anon.c906c25ea787c8c2757c1f36aabcd0ba.64.llvm.18178969024155037896+0x100>
  5af9b0:	ff 15 72 a4 53 00    	call   *0x53a472(%rip)        # ae9e28 <_DYNAMIC+0x278>
  5af9b6:	e9 11 02 00 00       	jmp    5afbcc <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5b9c>
  5af9bb:	48 89 c3             	mov    %rax,%rbx
  5af9be:	4c 8b bc 24 88 05 00 	mov    0x588(%rsp),%r15
  5af9c5:	00 
  5af9c6:	48 8d 05 8b 94 50 00 	lea    0x50948b(%rip),%rax        # ab8e58 <anon.c906c25ea787c8c2757c1f36aabcd0ba.92.llvm.18178969024155037896+0x228>
  5af9cd:	e9 c7 00 00 00       	jmp    5afa99 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5a69>
  5af9d2:	48 8d 15 4f 94 50 00 	lea    0x50944f(%rip),%rdx        # ab8e28 <anon.c906c25ea787c8c2757c1f36aabcd0ba.92.llvm.18178969024155037896+0x1f8>
  5af9d9:	4c 89 f7             	mov    %r14,%rdi
  5af9dc:	ff 15 46 a4 53 00    	call   *0x53a446(%rip)        # ae9e28 <_DYNAMIC+0x278>
  5af9e2:	e9 e5 01 00 00       	jmp    5afbcc <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5b9c>
  5af9e7:	bf 08 00 00 00       	mov    $0x8,%edi
  5af9ec:	48 8b b4 24 c8 04 00 	mov    0x4c8(%rsp),%rsi
  5af9f3:	00 
  5af9f4:	ff 15 fe a4 53 00    	call   *0x53a4fe(%rip)        # ae9ef8 <_DYNAMIC+0x348>
  5af9fa:	e9 cd 01 00 00       	jmp    5afbcc <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5b9c>
  5af9ff:	48 8d 15 62 93 50 00 	lea    0x509362(%rip),%rdx        # ab8d68 <anon.c906c25ea787c8c2757c1f36aabcd0ba.92.llvm.18178969024155037896+0x138>
  5afa06:	ff 15 1c a4 53 00    	call   *0x53a41c(%rip)        # ae9e28 <_DYNAMIC+0x278>
  5afa0c:	e9 bb 01 00 00       	jmp    5afbcc <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5b9c>
  5afa11:	48 89 4c 24 18       	mov    %rcx,0x18(%rsp)
  5afa16:	48 8d 05 c3 8f 50 00 	lea    0x508fc3(%rip),%rax        # ab89e0 <anon.c906c25ea787c8c2757c1f36aabcd0ba.27.llvm.18178969024155037896+0x240>
  5afa1d:	48 89 84 24 c0 04 00 	mov    %rax,0x4c0(%rsp)
  5afa24:	00 
  5afa25:	48 8b 7c 24 18       	mov    0x18(%rsp),%rdi
  5afa2a:	48 8b 94 24 c0 04 00 	mov    0x4c0(%rsp),%rdx
  5afa31:	00 
  5afa32:	ff 15 f0 a3 53 00    	call   *0x53a3f0(%rip)        # ae9e28 <_DYNAMIC+0x278>
  5afa38:	e9 8f 01 00 00       	jmp    5afbcc <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5b9c>
  5afa3d:	b0 01                	mov    $0x1,%al
  5afa3f:	89 44 24 18          	mov    %eax,0x18(%rsp)
  5afa43:	48 8d 15 f6 8f 50 00 	lea    0x508ff6(%rip),%rdx        # ab8a40 <anon.c906c25ea787c8c2757c1f36aabcd0ba.27.llvm.18178969024155037896+0x2a0>
  5afa4a:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
  5afa4f:	48 89 44 24 38       	mov    %rax,0x38(%rsp)
  5afa54:	48 8b 5c 24 40       	mov    0x40(%rsp),%rbx
  5afa59:	40 b5 01             	mov    $0x1,%bpl
  5afa5c:	4c 89 f7             	mov    %r14,%rdi
  5afa5f:	ff 15 c3 a3 53 00    	call   *0x53a3c3(%rip)        # ae9e28 <_DYNAMIC+0x278>
  5afa65:	e9 62 01 00 00       	jmp    5afbcc <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5b9c>
  5afa6a:	bf 08 00 00 00       	mov    $0x8,%edi
  5afa6f:	48 89 de             	mov    %rbx,%rsi
  5afa72:	ff 15 80 a4 53 00    	call   *0x53a480(%rip)        # ae9ef8 <_DYNAMIC+0x348>
  5afa78:	e9 4f 01 00 00       	jmp    5afbcc <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5b9c>
  5afa7d:	bf 08 00 00 00       	mov    $0x8,%edi
  5afa82:	48 8b 74 24 38       	mov    0x38(%rsp),%rsi
  5afa87:	ff 15 6b a4 53 00    	call   *0x53a46b(%rip)        # ae9ef8 <_DYNAMIC+0x348>
  5afa8d:	e9 3a 01 00 00       	jmp    5afbcc <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5b9c>
  5afa92:	48 8d 05 e7 8e 50 00 	lea    0x508ee7(%rip),%rax        # ab8980 <anon.c906c25ea787c8c2757c1f36aabcd0ba.27.llvm.18178969024155037896+0x1e0>
  5afa99:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
  5afa9e:	48 89 df             	mov    %rbx,%rdi
  5afaa1:	4c 89 fe             	mov    %r15,%rsi
  5afaa4:	48 8b 54 24 18       	mov    0x18(%rsp),%rdx
  5afaa9:	ff 15 79 a3 53 00    	call   *0x53a379(%rip)        # ae9e28 <_DYNAMIC+0x278>
  5afaaf:	e9 18 01 00 00       	jmp    5afbcc <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5b9c>
  5afab4:	48 8d 15 dd 92 50 00 	lea    0x5092dd(%rip),%rdx        # ab8d98 <anon.c906c25ea787c8c2757c1f36aabcd0ba.92.llvm.18178969024155037896+0x168>
  5afabb:	be 02 00 00 00       	mov    $0x2,%esi
  5afac0:	48 89 df             	mov    %rbx,%rdi
  5afac3:	ff 15 5f a3 53 00    	call   *0x53a35f(%rip)        # ae9e28 <_DYNAMIC+0x278>
  5afac9:	e9 fe 00 00 00       	jmp    5afbcc <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5b9c>
  5aface:	48 8d 15 23 8f 50 00 	lea    0x508f23(%rip),%rdx        # ab89f8 <anon.c906c25ea787c8c2757c1f36aabcd0ba.27.llvm.18178969024155037896+0x258>
  5afad5:	4c 89 f7             	mov    %r14,%rdi
  5afad8:	ff 15 4a a3 53 00    	call   *0x53a34a(%rip)        # ae9e28 <_DYNAMIC+0x278>
  5afade:	e9 e9 00 00 00       	jmp    5afbcc <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5b9c>
  5afae3:	48 85 ff             	test   %rdi,%rdi
  5afae6:	75 7e                	jne    5afb66 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5b36>
  5afae8:	b0 01                	mov    $0x1,%al
  5afaea:	89 44 24 18          	mov    %eax,0x18(%rsp)
  5afaee:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
  5afaf3:	48 89 44 24 38       	mov    %rax,0x38(%rsp)
  5afaf8:	48 8b 5c 24 40       	mov    0x40(%rsp),%rbx
  5afafd:	40 b5 01             	mov    $0x1,%bpl
  5afb00:	ff 15 6a a3 53 00    	call   *0x53a36a(%rip)        # ae9e70 <_DYNAMIC+0x2c0>
  5afb06:	e9 c1 00 00 00       	jmp    5afbcc <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5b9c>
  5afb0b:	bf 08 00 00 00       	mov    $0x8,%edi
  5afb10:	48 89 de             	mov    %rbx,%rsi
  5afb13:	ff 15 df a3 53 00    	call   *0x53a3df(%rip)        # ae9ef8 <_DYNAMIC+0x348>
  5afb19:	e9 ae 00 00 00       	jmp    5afbcc <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5b9c>
  5afb1e:	bf 04 00 00 00       	mov    $0x4,%edi
  5afb23:	48 89 de             	mov    %rbx,%rsi
  5afb26:	ff 15 cc a3 53 00    	call   *0x53a3cc(%rip)        # ae9ef8 <_DYNAMIC+0x348>
  5afb2c:	e9 9b 00 00 00       	jmp    5afbcc <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5b9c>
  5afb31:	48 8d 15 70 8d 50 00 	lea    0x508d70(%rip),%rdx        # ab88a8 <anon.c906c25ea787c8c2757c1f36aabcd0ba.27.llvm.18178969024155037896+0x108>
  5afb38:	48 89 c7             	mov    %rax,%rdi
  5afb3b:	ff 15 e7 a2 53 00    	call   *0x53a2e7(%rip)        # ae9e28 <_DYNAMIC+0x278>
  5afb41:	e9 86 00 00 00       	jmp    5afbcc <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5b9c>
  5afb46:	bf 08 00 00 00       	mov    $0x8,%edi
  5afb4b:	48 89 de             	mov    %rbx,%rsi
  5afb4e:	ff 15 a4 a3 53 00    	call   *0x53a3a4(%rip)        # ae9ef8 <_DYNAMIC+0x348>
  5afb54:	eb 76                	jmp    5afbcc <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5b9c>
  5afb56:	bf 08 00 00 00       	mov    $0x8,%edi
  5afb5b:	48 89 de             	mov    %rbx,%rsi
  5afb5e:	ff 15 94 a3 53 00    	call   *0x53a394(%rip)        # ae9ef8 <_DYNAMIC+0x348>
  5afb64:	eb 66                	jmp    5afbcc <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5b9c>
  5afb66:	48 8b b4 24 08 03 00 	mov    0x308(%rsp),%rsi
  5afb6d:	00 
  5afb6e:	b0 01                	mov    $0x1,%al
  5afb70:	89 44 24 18          	mov    %eax,0x18(%rsp)
  5afb74:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
  5afb79:	48 89 44 24 38       	mov    %rax,0x38(%rsp)
  5afb7e:	48 8b 5c 24 40       	mov    0x40(%rsp),%rbx
  5afb83:	40 b5 01             	mov    $0x1,%bpl
  5afb86:	ff 15 ec a2 53 00    	call   *0x53a2ec(%rip)        # ae9e78 <_DYNAMIC+0x2c8>
  5afb8c:	eb 3e                	jmp    5afbcc <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5b9c>
  5afb8e:	48 8d 0d 4b 8f 50 00 	lea    0x508f4b(%rip),%rcx        # ab8ae0 <anon.c906c25ea787c8c2757c1f36aabcd0ba.64.llvm.18178969024155037896+0x70>
  5afb95:	eb 07                	jmp    5afb9e <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5b6e>
  5afb97:	48 8d 0d 72 8f 50 00 	lea    0x508f72(%rip),%rcx        # ab8b10 <anon.c906c25ea787c8c2757c1f36aabcd0ba.64.llvm.18178969024155037896+0xa0>
  5afb9e:	48 89 8c 24 b8 04 00 	mov    %rcx,0x4b8(%rsp)
  5afba5:	00 
  5afba6:	48 89 c7             	mov    %rax,%rdi
  5afba9:	48 8b 94 24 b8 04 00 	mov    0x4b8(%rsp),%rdx
  5afbb0:	00 
  5afbb1:	ff 15 71 a2 53 00    	call   *0x53a271(%rip)        # ae9e28 <_DYNAMIC+0x278>
  5afbb7:	eb 13                	jmp    5afbcc <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5b9c>
  5afbb9:	48 8d 05 c8 8b 50 00 	lea    0x508bc8(%rip),%rax        # ab8788 <__frame_dummy_init_array_entry+0x218>
  5afbc0:	48 89 d7             	mov    %rdx,%rdi
  5afbc3:	48 89 c2             	mov    %rax,%rdx
  5afbc6:	ff 15 5c a2 53 00    	call   *0x53a25c(%rip)        # ae9e28 <_DYNAMIC+0x278>
  5afbcc:	0f 0b                	ud2
  5afbce:	48 8d 94 24 a0 00 00 	lea    0xa0(%rsp),%rdx
  5afbd5:	00 
  5afbd6:	e8 65 36 14 00       	call   6f3240 <_RINvNtNtNtCs4NRVxsYgnAr_4core5slice4sort8unstable7ipnsortNtNtNtCs6gaF1xUz9Bf_4gpui7runtime8metadata8DeclaredNCINvMB6_SBT_20sort_unstable_by_keyyNCNvMsq_BX_INtBX_7RuntimeNtNtBX_12style_ledger9AdversaryE14describe_innersy_0E0EBZ_>
  5afbdb:	48 8b 5c 24 10       	mov    0x10(%rsp),%rbx
  5afbe0:	e9 bb ec ff ff       	jmp    5ae8a0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4870>
  5afbe5:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  5afbea:	e9 12 08 00 00       	jmp    5b0401 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x63d1>
  5afbef:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  5afbf4:	b0 01                	mov    $0x1,%al
  5afbf6:	89 44 24 20          	mov    %eax,0x20(%rsp)
  5afbfa:	41 b5 01             	mov    $0x1,%r13b
  5afbfd:	41 b6 01             	mov    $0x1,%r14b
  5afc00:	b0 01                	mov    $0x1,%al
  5afc02:	89 44 24 10          	mov    %eax,0x10(%rsp)
  5afc06:	41 b7 01             	mov    $0x1,%r15b
  5afc09:	e9 5f 0c 00 00       	jmp    5b086d <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x683d>
  5afc0e:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  5afc13:	4c 89 e7             	mov    %r12,%rdi
  5afc16:	4c 89 fe             	mov    %r15,%rsi
  5afc19:	e8 82 59 f8 ff       	call   5355a0 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtCs6gaF1xUz9Bf_4gpui8property12ContributionINtNtB4_6option6OptionNtNtBG_11shared_text10SharedTextEEEBG_>
  5afc1e:	e9 4a 06 00 00       	jmp    5b026d <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x623d>
  5afc23:	ff 15 ef a1 53 00    	call   *0x53a1ef(%rip)        # ae9e18 <_DYNAMIC+0x268>
  5afc29:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  5afc2e:	48 8d bc 24 b0 03 00 	lea    0x3b0(%rsp),%rdi
  5afc35:	00 
  5afc36:	e8 d5 9a f7 ff       	call   529710 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtB4_6option6OptionNtNtCs6gaF1xUz9Bf_4gpui7runtime6ShapedEEB11_.llvm.18178969024155037896>
  5afc3b:	e9 23 05 00 00       	jmp    5b0163 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x6133>
  5afc40:	ff 15 d2 a1 53 00    	call   *0x53a1d2(%rip)        # ae9e18 <_DYNAMIC+0x268>
  5afc46:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  5afc4b:	48 89 ac dc 70 05 00 	mov    %rbp,0x570(%rsp,%rbx,8)
  5afc52:	00 
  5afc53:	e9 2d 07 00 00       	jmp    5b0385 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x6355>
  5afc58:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  5afc5d:	e9 08 08 00 00       	jmp    5b046a <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x643a>
  5afc62:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  5afc67:	48 8b 44 24 58       	mov    0x58(%rsp),%rax
  5afc6c:	48 8b 70 08          	mov    0x8(%rax),%rsi
  5afc70:	40 b5 01             	mov    $0x1,%bpl
  5afc73:	48 85 f6             	test   %rsi,%rsi
  5afc76:	0f 84 73 0a 00 00    	je     5b06ef <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x66bf>
  5afc7c:	48 8b 44 24 58       	mov    0x58(%rsp),%rax
  5afc81:	48 8b 50 10          	mov    0x10(%rax),%rdx
  5afc85:	4c 89 ff             	mov    %r15,%rdi
  5afc88:	ff 15 6a a1 53 00    	call   *0x53a16a(%rip)        # ae9df8 <_DYNAMIC+0x248>
  5afc8e:	e9 5c 0a 00 00       	jmp    5b06ef <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x66bf>
  5afc93:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  5afc98:	41 b7 01             	mov    $0x1,%r15b
  5afc9b:	b0 01                	mov    $0x1,%al
  5afc9d:	89 44 24 10          	mov    %eax,0x10(%rsp)
  5afca1:	41 b6 01             	mov    $0x1,%r14b
  5afca4:	41 b4 01             	mov    $0x1,%r12b
  5afca7:	b0 01                	mov    $0x1,%al
  5afca9:	89 44 24 20          	mov    %eax,0x20(%rsp)
  5afcad:	e9 dc 0a 00 00       	jmp    5b078e <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x675e>
  5afcb2:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  5afcb7:	4c 89 ef             	mov    %r13,%rdi
  5afcba:	e8 41 7b f8 ff       	call   537800 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueNtNtCs6gaF1xUz9Bf_4gpui11shared_text10SharedTextEBF_>
  5afcbf:	e9 5e 07 00 00       	jmp    5b0422 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x63f2>
  5afcc4:	ff 15 4e a1 53 00    	call   *0x53a14e(%rip)        # ae9e18 <_DYNAMIC+0x268>
  5afcca:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  5afccf:	48 8b 83 10 08 00 00 	mov    0x810(%rbx),%rax
  5afcd6:	48 8b 8c 24 b0 00 00 	mov    0xb0(%rsp),%rcx
  5afcdd:	00 
  5afcde:	48 89 48 10          	mov    %rcx,0x10(%rax)
  5afce2:	0f 28 84 24 a0 00 00 	movaps 0xa0(%rsp),%xmm0
  5afce9:	00 
  5afcea:	0f 11 00             	movups %xmm0,(%rax)
  5afced:	e9 1c 07 00 00       	jmp    5b040e <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x63de>
  5afcf2:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  5afcf7:	41 b7 01             	mov    $0x1,%r15b
  5afcfa:	b0 01                	mov    $0x1,%al
  5afcfc:	89 44 24 10          	mov    %eax,0x10(%rsp)
  5afd00:	41 b6 01             	mov    $0x1,%r14b
  5afd03:	b0 01                	mov    $0x1,%al
  5afd05:	89 44 24 20          	mov    %eax,0x20(%rsp)
  5afd09:	e9 95 0a 00 00       	jmp    5b07a3 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x6773>
  5afd0e:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  5afd13:	b0 01                	mov    $0x1,%al
  5afd15:	89 84 24 08 02 00 00 	mov    %eax,0x208(%rsp)
  5afd1c:	b8 01 00 00 00       	mov    $0x1,%eax
  5afd21:	48 89 84 24 28 04 00 	mov    %rax,0x428(%rsp)
  5afd28:	00 
  5afd29:	40 b5 01             	mov    $0x1,%bpl
  5afd2c:	e9 8d 09 00 00       	jmp    5b06be <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x668e>
  5afd31:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  5afd36:	45 31 ed             	xor    %r13d,%r13d
  5afd39:	45 31 f6             	xor    %r14d,%r14d
  5afd3c:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%rsp)
  5afd43:	00 
  5afd44:	45 31 ff             	xor    %r15d,%r15d
  5afd47:	e9 2e 0b 00 00       	jmp    5b087a <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x684a>
  5afd4c:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  5afd51:	48 8b 84 24 88 04 00 	mov    0x488(%rsp),%rax
  5afd58:	00 
  5afd59:	48 85 c0             	test   %rax,%rax
  5afd5c:	74 1b                	je     5afd79 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5d49>
  5afd5e:	48 8b bc 24 90 04 00 	mov    0x490(%rsp),%rdi
  5afd65:	00 
  5afd66:	48 c1 e0 03          	shl    $0x3,%rax
  5afd6a:	48 8d 34 80          	lea    (%rax,%rax,4),%rsi
  5afd6e:	ba 08 00 00 00       	mov    $0x8,%edx
  5afd73:	ff 15 7f a0 53 00    	call   *0x53a07f(%rip)        # ae9df8 <_DYNAMIC+0x248>
  5afd79:	45 31 ed             	xor    %r13d,%r13d
  5afd7c:	45 31 f6             	xor    %r14d,%r14d
  5afd7f:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%rsp)
  5afd86:	00 
  5afd87:	45 31 ff             	xor    %r15d,%r15d
  5afd8a:	e9 d1 0a 00 00       	jmp    5b0860 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x6830>
  5afd8f:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  5afd94:	45 31 ed             	xor    %r13d,%r13d
  5afd97:	45 31 f6             	xor    %r14d,%r14d
  5afd9a:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%rsp)
  5afda1:	00 
  5afda2:	45 31 ff             	xor    %r15d,%r15d
  5afda5:	e9 a9 0a 00 00       	jmp    5b0853 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x6823>
  5afdaa:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  5afdaf:	45 31 ed             	xor    %r13d,%r13d
  5afdb2:	45 31 f6             	xor    %r14d,%r14d
  5afdb5:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%rsp)
  5afdbc:	00 
  5afdbd:	45 31 ff             	xor    %r15d,%r15d
  5afdc0:	e9 81 0a 00 00       	jmp    5b0846 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x6816>
  5afdc5:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  5afdca:	45 31 ed             	xor    %r13d,%r13d
  5afdcd:	45 31 f6             	xor    %r14d,%r14d
  5afdd0:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%rsp)
  5afdd7:	00 
  5afdd8:	45 31 ff             	xor    %r15d,%r15d
  5afddb:	e9 59 0a 00 00       	jmp    5b0839 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x6809>
  5afde0:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  5afde5:	45 31 ed             	xor    %r13d,%r13d
  5afde8:	45 31 f6             	xor    %r14d,%r14d
  5afdeb:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%rsp)
  5afdf2:	00 
  5afdf3:	45 31 ff             	xor    %r15d,%r15d
  5afdf6:	e9 24 0a 00 00       	jmp    5b081f <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x67ef>
  5afdfb:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  5afe00:	48 8b 84 24 10 03 00 	mov    0x310(%rsp),%rax
  5afe07:	00 
  5afe08:	48 89 43 10          	mov    %rax,0x10(%rbx)
  5afe0c:	0f 10 84 24 00 03 00 	movups 0x300(%rsp),%xmm0
  5afe13:	00 
  5afe14:	0f 11 03             	movups %xmm0,(%rbx)
  5afe17:	e9 51 04 00 00       	jmp    5b026d <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x623d>
  5afe1c:	e9 2f 04 00 00       	jmp    5b0250 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x6220>
  5afe21:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  5afe26:	48 8b 03             	mov    (%rbx),%rax
  5afe29:	48 85 c0             	test   %rax,%rax
  5afe2c:	74 1f                	je     5afe4d <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5e1d>
  5afe2e:	48 8b 4c 24 10       	mov    0x10(%rsp),%rcx
  5afe33:	48 8b b9 d8 02 00 00 	mov    0x2d8(%rcx),%rdi
  5afe3a:	48 c1 e0 04          	shl    $0x4,%rax
  5afe3e:	48 8d 34 80          	lea    (%rax,%rax,4),%rsi
  5afe42:	ba 08 00 00 00       	mov    $0x8,%edx
  5afe47:	ff 15 ab 9f 53 00    	call   *0x539fab(%rip)        # ae9df8 <_DYNAMIC+0x248>
  5afe4d:	48 8b 84 24 b0 00 00 	mov    0xb0(%rsp),%rax
  5afe54:	00 
  5afe55:	48 89 43 10          	mov    %rax,0x10(%rbx)
  5afe59:	0f 28 84 24 a0 00 00 	movaps 0xa0(%rsp),%xmm0
  5afe60:	00 
  5afe61:	0f 11 03             	movups %xmm0,(%rbx)
  5afe64:	41 b5 01             	mov    $0x1,%r13b
  5afe67:	e9 04 04 00 00       	jmp    5b0270 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x6240>
  5afe6c:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  5afe71:	ba 04 00 00 00       	mov    $0x4,%edx
  5afe76:	48 8b bc 24 48 02 00 	mov    0x248(%rsp),%rdi
  5afe7d:	00 
  5afe7e:	48 8b b4 24 d0 02 00 	mov    0x2d0(%rsp),%rsi
  5afe85:	00 
  5afe86:	ff 15 6c 9f 53 00    	call   *0x539f6c(%rip)        # ae9df8 <_DYNAMIC+0x248>
  5afe8c:	45 31 ff             	xor    %r15d,%r15d
  5afe8f:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%rsp)
  5afe96:	00 
  5afe97:	45 31 f6             	xor    %r14d,%r14d
  5afe9a:	45 31 e4             	xor    %r12d,%r12d
  5afe9d:	31 ed                	xor    %ebp,%ebp
  5afe9f:	e9 d8 08 00 00       	jmp    5b077c <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x674c>
  5afea4:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  5afea9:	48 8b 03             	mov    (%rbx),%rax
  5afeac:	48 85 c0             	test   %rax,%rax
  5afeaf:	74 1f                	je     5afed0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5ea0>
  5afeb1:	48 8b 4c 24 10       	mov    0x10(%rsp),%rcx
  5afeb6:	48 8b b9 c0 02 00 00 	mov    0x2c0(%rcx),%rdi
  5afebd:	48 c1 e0 03          	shl    $0x3,%rax
  5afec1:	48 8d 34 80          	lea    (%rax,%rax,4),%rsi
  5afec5:	ba 08 00 00 00       	mov    $0x8,%edx
  5afeca:	ff 15 28 9f 53 00    	call   *0x539f28(%rip)        # ae9df8 <_DYNAMIC+0x248>
  5afed0:	48 8b 84 24 b0 00 00 	mov    0xb0(%rsp),%rax
  5afed7:	00 
  5afed8:	48 89 43 10          	mov    %rax,0x10(%rbx)
  5afedc:	0f 28 84 24 a0 00 00 	movaps 0xa0(%rsp),%xmm0
  5afee3:	00 
  5afee4:	0f 11 03             	movups %xmm0,(%rbx)
  5afee7:	31 ed                	xor    %ebp,%ebp
  5afee9:	e9 b3 06 00 00       	jmp    5b05a1 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x6571>
  5afeee:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  5afef3:	48 8b 84 24 b0 00 00 	mov    0xb0(%rsp),%rax
  5afefa:	00 
  5afefb:	49 89 46 10          	mov    %rax,0x10(%r14)
  5afeff:	0f 28 84 24 a0 00 00 	movaps 0xa0(%rsp),%xmm0
  5aff06:	00 
  5aff07:	41 0f 11 06          	movups %xmm0,(%r14)
  5aff0b:	40 b5 01             	mov    $0x1,%bpl
  5aff0e:	e9 8e 06 00 00       	jmp    5b05a1 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x6571>
  5aff13:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  5aff18:	48 8b 84 24 b0 00 00 	mov    0xb0(%rsp),%rax
  5aff1f:	00 
  5aff20:	48 89 43 10          	mov    %rax,0x10(%rbx)
  5aff24:	0f 28 84 24 a0 00 00 	movaps 0xa0(%rsp),%xmm0
  5aff2b:	00 
  5aff2c:	0f 11 03             	movups %xmm0,(%rbx)
  5aff2f:	31 db                	xor    %ebx,%ebx
  5aff31:	e9 4a 06 00 00       	jmp    5b0580 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x6550>
  5aff36:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  5aff3b:	41 b7 01             	mov    $0x1,%r15b
  5aff3e:	b0 01                	mov    $0x1,%al
  5aff40:	89 44 24 10          	mov    %eax,0x10(%rsp)
  5aff44:	41 b6 01             	mov    $0x1,%r14b
  5aff47:	41 b4 01             	mov    $0x1,%r12b
  5aff4a:	40 b5 01             	mov    $0x1,%bpl
  5aff4d:	b0 01                	mov    $0x1,%al
  5aff4f:	89 44 24 20          	mov    %eax,0x20(%rsp)
  5aff53:	e9 24 08 00 00       	jmp    5b077c <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x674c>
  5aff58:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  5aff5d:	b0 01                	mov    $0x1,%al
  5aff5f:	89 44 24 20          	mov    %eax,0x20(%rsp)
  5aff63:	41 b5 01             	mov    $0x1,%r13b
  5aff66:	41 b6 01             	mov    $0x1,%r14b
  5aff69:	b0 01                	mov    $0x1,%al
  5aff6b:	89 44 24 10          	mov    %eax,0x10(%rsp)
  5aff6f:	41 b7 01             	mov    $0x1,%r15b
  5aff72:	e9 e9 08 00 00       	jmp    5b0860 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x6830>
  5aff77:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  5aff7c:	66 0f 6f 44 24 20    	movdqa 0x20(%rsp),%xmm0
  5aff82:	66 48 0f 7e c7       	movq   %xmm0,%rdi
  5aff87:	66 0f 70 c0 ee       	pshufd $0xee,%xmm0,%xmm0
  5aff8c:	66 48 0f 7e c6       	movq   %xmm0,%rsi
  5aff91:	e8 ca 8a f8 ff       	call   538a60 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueNtNtNtCs6gaF1xUz9Bf_4gpui7runtime8metadata5NamesEBH_>
  5aff96:	e9 59 04 00 00       	jmp    5b03f4 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x63c4>
  5aff9b:	ff 15 77 9e 53 00    	call   *0x539e77(%rip)        # ae9e18 <_DYNAMIC+0x268>
  5affa1:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  5affa6:	4c 89 ff             	mov    %r15,%rdi
  5affa9:	48 8b 74 24 58       	mov    0x58(%rsp),%rsi
  5affae:	e8 fd 96 f7 ff       	call   5296b0 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtB4_6option6OptionNtNtCs6gaF1xUz9Bf_4gpui7element7HandlerEEB11_>
  5affb3:	e9 34 07 00 00       	jmp    5b06ec <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x66bc>
  5affb8:	ff 15 5a 9e 53 00    	call   *0x539e5a(%rip)        # ae9e18 <_DYNAMIC+0x268>
  5affbe:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  5affc3:	b0 01                	mov    $0x1,%al
  5affc5:	89 44 24 20          	mov    %eax,0x20(%rsp)
  5affc9:	b0 01                	mov    $0x1,%al
  5affcb:	89 44 24 10          	mov    %eax,0x10(%rsp)
  5affcf:	e9 87 07 00 00       	jmp    5b075b <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x672b>
  5affd4:	89 6c 24 20          	mov    %ebp,0x20(%rsp)
  5affd8:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  5affdd:	45 89 ee             	mov    %r13d,%r14d
  5affe0:	44 89 e8             	mov    %r13d,%eax
  5affe3:	89 44 24 10          	mov    %eax,0x10(%rsp)
  5affe7:	45 89 ef             	mov    %r13d,%r15d
  5affea:	e9 3d 08 00 00       	jmp    5b082c <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x67fc>
  5affef:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  5afff4:	48 89 ef             	mov    %rbp,%rdi
  5afff7:	e8 84 96 f7 ff       	call   529680 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtB4_6option6OptionNtNtCs6gaF1xUz9Bf_4gpui11shared_text10SharedTextEEB11_>
  5afffc:	e9 84 03 00 00       	jmp    5b0385 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x6355>
  5b0001:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  5b0006:	48 8d bc 24 00 03 00 	lea    0x300(%rsp),%rdi
  5b000d:	00 
  5b000e:	e8 cd 98 f7 ff       	call   5298e0 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtB4_6option6OptionNtNtCs6gaF1xUz9Bf_4gpui7runtime8TextSiteEEB11_>
  5b0013:	e9 b3 01 00 00       	jmp    5b01cb <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x619b>
  5b0018:	ff 15 fa 9d 53 00    	call   *0x539dfa(%rip)        # ae9e18 <_DYNAMIC+0x268>
  5b001e:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  5b0023:	40 b5 01             	mov    $0x1,%bpl
  5b0026:	41 b6 01             	mov    $0x1,%r14b
  5b0029:	b0 01                	mov    $0x1,%al
  5b002b:	89 44 24 10          	mov    %eax,0x10(%rsp)
  5b002f:	41 b7 01             	mov    $0x1,%r15b
  5b0032:	e9 dc 08 00 00       	jmp    5b0913 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x68e3>
  5b0037:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  5b003c:	40 b5 01             	mov    $0x1,%bpl
  5b003f:	41 b6 01             	mov    $0x1,%r14b
  5b0042:	b0 01                	mov    $0x1,%al
  5b0044:	89 44 24 10          	mov    %eax,0x10(%rsp)
  5b0048:	41 b7 01             	mov    $0x1,%r15b
  5b004b:	e9 e7 08 00 00       	jmp    5b0937 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x6907>
  5b0050:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  5b0055:	40 b5 01             	mov    $0x1,%bpl
  5b0058:	41 b6 01             	mov    $0x1,%r14b
  5b005b:	b0 01                	mov    $0x1,%al
  5b005d:	89 44 24 10          	mov    %eax,0x10(%rsp)
  5b0061:	41 b7 01             	mov    $0x1,%r15b
  5b0064:	e9 f2 08 00 00       	jmp    5b095b <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x692b>
  5b0069:	e9 79 06 00 00       	jmp    5b06e7 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x66b7>
  5b006e:	e9 c2 03 00 00       	jmp    5b0435 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x6405>
  5b0073:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  5b0078:	48 89 ef             	mov    %rbp,%rdi
  5b007b:	e8 80 77 f8 ff       	call   537800 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueNtNtCs6gaF1xUz9Bf_4gpui11shared_text10SharedTextEBF_>
  5b0080:	e9 00 03 00 00       	jmp    5b0385 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x6355>
  5b0085:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  5b008a:	49 83 ff ff          	cmp    $0xffffffffffffffff,%r15
  5b008e:	74 16                	je     5b00a6 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x6076>
  5b0090:	4d 85 ff             	test   %r15,%r15
  5b0093:	7e 11                	jle    5b00a6 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x6076>
  5b0095:	ba 01 00 00 00       	mov    $0x1,%edx
  5b009a:	48 89 ef             	mov    %rbp,%rdi
  5b009d:	4c 89 fe             	mov    %r15,%rsi
  5b00a0:	ff 15 52 9d 53 00    	call   *0x539d52(%rip)        # ae9df8 <_DYNAMIC+0x248>
  5b00a6:	48 83 fb ff          	cmp    $0xffffffffffffffff,%rbx
  5b00aa:	0f 84 44 03 00 00    	je     5b03f4 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x63c4>
  5b00b0:	48 85 db             	test   %rbx,%rbx
  5b00b3:	0f 8e 3b 03 00 00    	jle    5b03f4 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x63c4>
  5b00b9:	ba 01 00 00 00       	mov    $0x1,%edx
  5b00be:	4c 89 f7             	mov    %r14,%rdi
  5b00c1:	48 89 de             	mov    %rbx,%rsi
  5b00c4:	ff 15 2e 9d 53 00    	call   *0x539d2e(%rip)        # ae9df8 <_DYNAMIC+0x248>
  5b00ca:	e9 25 03 00 00       	jmp    5b03f4 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x63c4>
  5b00cf:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  5b00d4:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
  5b00d9:	48 8b 70 08          	mov    0x8(%rax),%rsi
  5b00dd:	48 85 f6             	test   %rsi,%rsi
  5b00e0:	74 14                	je     5b00f6 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x60c6>
  5b00e2:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
  5b00e7:	48 8b 50 10          	mov    0x10(%rax),%rdx
  5b00eb:	48 8b 7c 24 40       	mov    0x40(%rsp),%rdi
  5b00f0:	ff 15 02 9d 53 00    	call   *0x539d02(%rip)        # ae9df8 <_DYNAMIC+0x248>
  5b00f6:	31 ed                	xor    %ebp,%ebp
  5b00f8:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
  5b00fd:	48 89 44 24 30       	mov    %rax,0x30(%rsp)
  5b0102:	48 89 5c 24 40       	mov    %rbx,0x40(%rsp)
  5b0107:	41 b6 01             	mov    $0x1,%r14b
  5b010a:	48 8b 5c 24 70       	mov    0x70(%rsp),%rbx
  5b010f:	41 b7 01             	mov    $0x1,%r15b
  5b0112:	e9 56 05 00 00       	jmp    5b066d <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x663d>
  5b0117:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  5b011c:	48 8b 84 24 f8 01 00 	mov    0x1f8(%rsp),%rax
  5b0123:	00 
  5b0124:	48 89 84 24 b8 03 00 	mov    %rax,0x3b8(%rsp)
  5b012b:	00 
  5b012c:	e9 ce 03 00 00       	jmp    5b04ff <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x64cf>
  5b0131:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  5b0136:	44 89 f0             	mov    %r14d,%eax
  5b0139:	89 44 24 10          	mov    %eax,0x10(%rsp)
  5b013d:	45 89 f7             	mov    %r14d,%r15d
  5b0140:	e9 23 08 00 00       	jmp    5b0968 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x6938>
  5b0145:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  5b014a:	40 b5 01             	mov    $0x1,%bpl
  5b014d:	41 b6 01             	mov    $0x1,%r14b
  5b0150:	b0 01                	mov    $0x1,%al
  5b0152:	89 44 24 10          	mov    %eax,0x10(%rsp)
  5b0156:	41 b7 01             	mov    $0x1,%r15b
  5b0159:	e9 91 07 00 00       	jmp    5b08ef <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x68bf>
  5b015e:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  5b0163:	48 89 9c 24 b0 03 00 	mov    %rbx,0x3b0(%rsp)
  5b016a:	00 
  5b016b:	48 89 ac 24 f0 03 00 	mov    %rbp,0x3f0(%rsp)
  5b0172:	00 
  5b0173:	48 8b 84 24 90 05 00 	mov    0x590(%rsp),%rax
  5b017a:	00 
  5b017b:	48 89 84 24 f8 03 00 	mov    %rax,0x3f8(%rsp)
  5b0182:	00 
  5b0183:	e9 9a 02 00 00       	jmp    5b0422 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x63f2>
  5b0188:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  5b018d:	48 89 df             	mov    %rbx,%rdi
  5b0190:	48 8b 74 24 38       	mov    0x38(%rsp),%rsi
  5b0195:	e8 16 95 f7 ff       	call   5296b0 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtB4_6option6OptionNtNtCs6gaF1xUz9Bf_4gpui7element7HandlerEEB11_>
  5b019a:	45 31 f6             	xor    %r14d,%r14d
  5b019d:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
  5b01a2:	48 89 44 24 30       	mov    %rax,0x30(%rsp)
  5b01a7:	48 89 5c 24 40       	mov    %rbx,0x40(%rsp)
  5b01ac:	31 ed                	xor    %ebp,%ebp
  5b01ae:	e9 8d 04 00 00       	jmp    5b0640 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x6610>
  5b01b3:	ff 15 5f 9c 53 00    	call   *0x539c5f(%rip)        # ae9e18 <_DYNAMIC+0x268>
  5b01b9:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  5b01be:	48 8d bc 24 90 01 00 	lea    0x190(%rsp),%rdi
  5b01c5:	00 
  5b01c6:	e8 75 77 f8 ff       	call   537940 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueNtNtCs6gaF1xUz9Bf_4gpui7runtime8TextSiteEBF_>
  5b01cb:	41 b6 01             	mov    $0x1,%r14b
  5b01ce:	45 31 ff             	xor    %r15d,%r15d
  5b01d1:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
  5b01d6:	48 89 44 24 30       	mov    %rax,0x30(%rsp)
  5b01db:	48 89 5c 24 40       	mov    %rbx,0x40(%rsp)
  5b01e0:	31 ed                	xor    %ebp,%ebp
  5b01e2:	48 8b 5c 24 70       	mov    0x70(%rsp),%rbx
  5b01e7:	e9 81 04 00 00       	jmp    5b066d <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x663d>
  5b01ec:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  5b01f1:	48 c7 84 24 b0 03 00 	movq   $0xffffffffffffffff,0x3b0(%rsp)
  5b01f8:	00 ff ff ff ff 
  5b01fd:	e9 20 02 00 00       	jmp    5b0422 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x63f2>
  5b0202:	e9 ac 03 00 00       	jmp    5b05b3 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x6583>
  5b0207:	e9 40 04 00 00       	jmp    5b064c <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x661c>
  5b020c:	e9 a2 03 00 00       	jmp    5b05b3 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x6583>
  5b0211:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  5b0216:	40 b5 01             	mov    $0x1,%bpl
  5b0219:	e9 fd 00 00 00       	jmp    5b031b <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x62eb>
  5b021e:	e9 c4 04 00 00       	jmp    5b06e7 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x66b7>
  5b0223:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  5b0228:	e9 d2 02 00 00       	jmp    5b04ff <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x64cf>
  5b022d:	e9 82 00 00 00       	jmp    5b02b4 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x6284>
  5b0232:	e9 7c 06 00 00       	jmp    5b08b3 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x6883>
  5b0237:	e9 44 01 00 00       	jmp    5b0380 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x6350>
  5b023c:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  5b0241:	e9 5f 01 00 00       	jmp    5b03a5 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x6375>
  5b0246:	e9 9c 04 00 00       	jmp    5b06e7 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x66b7>
  5b024b:	e9 fc 03 00 00       	jmp    5b064c <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x661c>
  5b0250:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  5b0255:	48 8b 84 24 a0 01 00 	mov    0x1a0(%rsp),%rax
  5b025c:	00 
  5b025d:	49 89 47 10          	mov    %rax,0x10(%r15)
  5b0261:	0f 28 84 24 90 01 00 	movaps 0x190(%rsp),%xmm0
  5b0268:	00 
  5b0269:	41 0f 11 07          	movups %xmm0,(%r15)
  5b026d:	45 31 ed             	xor    %r13d,%r13d
  5b0270:	ba 04 00 00 00       	mov    $0x4,%edx
  5b0275:	48 8b bc 24 48 02 00 	mov    0x248(%rsp),%rdi
  5b027c:	00 
  5b027d:	48 8b b4 24 d0 02 00 	mov    0x2d0(%rsp),%rsi
  5b0284:	00 
  5b0285:	ff 15 6d 9b 53 00    	call   *0x539b6d(%rip)        # ae9df8 <_DYNAMIC+0x248>
  5b028b:	eb 4a                	jmp    5b02d7 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x62a7>
  5b028d:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  5b0292:	e9 66 07 00 00       	jmp    5b09fd <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x69cd>
  5b0297:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  5b029c:	48 8d bc 24 a0 00 00 	lea    0xa0(%rsp),%rdi
  5b02a3:	00 
  5b02a4:	e8 d7 bd 21 00       	call   7cc080 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueNtNtCs6gaF1xUz9Bf_4gpui7element2ElEBF_.llvm.6226793394568926217>
  5b02a9:	e9 4f 07 00 00       	jmp    5b09fd <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x69cd>
  5b02ae:	ff 15 64 9b 53 00    	call   *0x539b64(%rip)        # ae9e18 <_DYNAMIC+0x268>
  5b02b4:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  5b02b9:	ba 04 00 00 00       	mov    $0x4,%edx
  5b02be:	48 8b bc 24 48 02 00 	mov    0x248(%rsp),%rdi
  5b02c5:	00 
  5b02c6:	48 8b b4 24 d0 02 00 	mov    0x2d0(%rsp),%rsi
  5b02cd:	00 
  5b02ce:	ff 15 24 9b 53 00    	call   *0x539b24(%rip)        # ae9df8 <_DYNAMIC+0x248>
  5b02d4:	45 31 ed             	xor    %r13d,%r13d
  5b02d7:	45 31 f6             	xor    %r14d,%r14d
  5b02da:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%rsp)
  5b02e1:	00 
  5b02e2:	45 31 ff             	xor    %r15d,%r15d
  5b02e5:	e9 c9 04 00 00       	jmp    5b07b3 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x6783>
  5b02ea:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  5b02ef:	4d 85 f6             	test   %r14,%r14
  5b02f2:	75 35                	jne    5b0329 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x62f9>
  5b02f4:	48 8b b4 24 70 04 00 	mov    0x470(%rsp),%rsi
  5b02fb:	00 
  5b02fc:	40 b5 01             	mov    $0x1,%bpl
  5b02ff:	48 85 f6             	test   %rsi,%rsi
  5b0302:	74 17                	je     5b031b <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x62eb>
  5b0304:	48 8b bc 24 78 04 00 	mov    0x478(%rsp),%rdi
  5b030b:	00 
  5b030c:	48 c1 e6 03          	shl    $0x3,%rsi
  5b0310:	ba 08 00 00 00       	mov    $0x8,%edx
  5b0315:	ff 15 dd 9a 53 00    	call   *0x539add(%rip)        # ae9df8 <_DYNAMIC+0x248>
  5b031b:	b0 01                	mov    $0x1,%al
  5b031d:	89 44 24 10          	mov    %eax,0x10(%rsp)
  5b0321:	41 b7 01             	mov    $0x1,%r15b
  5b0324:	e9 51 06 00 00       	jmp    5b097a <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x694a>
  5b0329:	48 83 c3 08          	add    $0x8,%rbx
  5b032d:	49 f7 de             	neg    %r14
  5b0330:	eb 17                	jmp    5b0349 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x6319>
  5b0332:	66 66 66 66 66 2e 0f 	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  5b0339:	1f 84 00 00 00 00 00 
  5b0340:	48 83 c3 08          	add    $0x8,%rbx
  5b0344:	49 ff ce             	dec    %r14
  5b0347:	74 ab                	je     5b02f4 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x62c4>
  5b0349:	48 8b 03             	mov    (%rbx),%rax
  5b034c:	f0 48 ff 08          	lock decq (%rax)
  5b0350:	75 ee                	jne    5b0340 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x6310>
  5b0352:	48 89 df             	mov    %rbx,%rdi
  5b0355:	41 ff d7             	call   *%r15
  5b0358:	eb e6                	jmp    5b0340 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x6310>
  5b035a:	ff 15 b8 9a 53 00    	call   *0x539ab8(%rip)        # ae9e18 <_DYNAMIC+0x268>
  5b0360:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  5b0365:	44 89 7c 24 10       	mov    %r15d,0x10(%rsp)
  5b036a:	e9 28 06 00 00       	jmp    5b0997 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x6967>
  5b036f:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  5b0374:	89 dd                	mov    %ebx,%ebp
  5b0376:	44 89 7c 24 10       	mov    %r15d,0x10(%rsp)
  5b037b:	e9 0a 06 00 00       	jmp    5b098a <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x695a>
  5b0380:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  5b0385:	48 8b b4 24 00 04 00 	mov    0x400(%rsp),%rsi
  5b038c:	00 
  5b038d:	48 85 f6             	test   %rsi,%rsi
  5b0390:	7e 13                	jle    5b03a5 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x6375>
  5b0392:	48 8b bc 24 08 04 00 	mov    0x408(%rsp),%rdi
  5b0399:	00 
  5b039a:	ba 01 00 00 00       	mov    $0x1,%edx
  5b039f:	ff 15 53 9a 53 00    	call   *0x539a53(%rip)        # ae9df8 <_DYNAMIC+0x248>
  5b03a5:	4d 85 f6             	test   %r14,%r14
  5b03a8:	7e 13                	jle    5b03bd <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x638d>
  5b03aa:	ba 01 00 00 00       	mov    $0x1,%edx
  5b03af:	48 8b 7c 24 20       	mov    0x20(%rsp),%rdi
  5b03b4:	4c 89 f6             	mov    %r14,%rsi
  5b03b7:	ff 15 3b 9a 53 00    	call   *0x539a3b(%rip)        # ae9df8 <_DYNAMIC+0x248>
  5b03bd:	48 8b b4 24 00 03 00 	mov    0x300(%rsp),%rsi
  5b03c4:	00 
  5b03c5:	48 8b 94 24 08 03 00 	mov    0x308(%rsp),%rdx
  5b03cc:	00 
  5b03cd:	48 8d bc 24 10 03 00 	lea    0x310(%rsp),%rdi
  5b03d4:	00 
  5b03d5:	e8 46 65 1e 00       	call   796920 <_RNvXs_NtNtNtCs4NRVxsYgnAr_4core5array4iter10iter_innerAINtNtNtBa_3mem12maybe_uninit11MaybeUninitINtNtBa_6option6OptionNtNtCs6gaF1xUz9Bf_4gpui6source4TextEEj2_NtB4_11PartialDrop12partial_dropB1W_>
  5b03da:	48 8b bc 24 78 05 00 	mov    0x578(%rsp),%rdi
  5b03e1:	00 
  5b03e2:	e8 99 92 f7 ff       	call   529680 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtB4_6option6OptionNtNtCs6gaF1xUz9Bf_4gpui11shared_text10SharedTextEEB11_>
  5b03e7:	48 8b bc 24 70 05 00 	mov    0x570(%rsp),%rdi
  5b03ee:	00 
  5b03ef:	e8 8c 92 f7 ff       	call   529680 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtB4_6option6OptionNtNtCs6gaF1xUz9Bf_4gpui11shared_text10SharedTextEEB11_>
  5b03f4:	48 8d bc 24 a0 00 00 	lea    0xa0(%rsp),%rdi
  5b03fb:	00 
  5b03fc:	e8 0f 66 f8 ff       	call   536a10 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtNtNtB4_4iter8adapters3zip3ZipINtNtNtCscdodAO9FK5_5alloc3vec9into_iter8IntoIterNtNtCs6gaF1xUz9Bf_4gpui8semantic15AnnotationDraftEIB1a_AINtNtB4_6option6OptionNtNtB20_6source7FieldIdEj2_EEEB20_>
  5b0401:	48 8d bc 24 a0 04 00 	lea    0x4a0(%rsp),%rdi
  5b0408:	00 
  5b0409:	e8 d2 61 f8 ff       	call   5365e0 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtCscdodAO9FK5_5alloc3vec3VecNtNtNtCs6gaF1xUz9Bf_4gpui7runtime8metadata8DeclaredEEB1d_>
  5b040e:	b3 01                	mov    $0x1,%bl
  5b0410:	c7 44 24 20 00 00 00 	movl   $0x0,0x20(%rsp)
  5b0417:	00 
  5b0418:	e9 63 01 00 00       	jmp    5b0580 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x6550>
  5b041d:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  5b0422:	41 b7 01             	mov    $0x1,%r15b
  5b0425:	41 b6 01             	mov    $0x1,%r14b
  5b0428:	40 b5 01             	mov    $0x1,%bpl
  5b042b:	48 8b 5c 24 70       	mov    0x70(%rsp),%rbx
  5b0430:	e9 38 02 00 00       	jmp    5b066d <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x663d>
  5b0435:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  5b043a:	41 b7 01             	mov    $0x1,%r15b
  5b043d:	b0 01                	mov    $0x1,%al
  5b043f:	89 44 24 10          	mov    %eax,0x10(%rsp)
  5b0443:	41 b6 01             	mov    $0x1,%r14b
  5b0446:	40 b5 01             	mov    $0x1,%bpl
  5b0449:	e9 86 04 00 00       	jmp    5b08d4 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x68a4>
  5b044e:	e9 60 04 00 00       	jmp    5b08b3 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x6883>
  5b0453:	e9 a0 03 00 00       	jmp    5b07f8 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x67c8>
  5b0458:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  5b045d:	48 8d bc 24 a0 00 00 	lea    0xa0(%rsp),%rdi
  5b0464:	00 
  5b0465:	e8 a6 88 f8 ff       	call   538d10 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueNtNtNtCs6gaF1xUz9Bf_4gpui7runtime8metadata8MetadataEBH_>
  5b046a:	b3 01                	mov    $0x1,%bl
  5b046c:	b0 01                	mov    $0x1,%al
  5b046e:	89 44 24 20          	mov    %eax,0x20(%rsp)
  5b0472:	e9 09 01 00 00       	jmp    5b0580 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x6550>
  5b0477:	ff 15 9b 99 53 00    	call   *0x53999b(%rip)        # ae9e18 <_DYNAMIC+0x268>
  5b047d:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  5b0482:	48 89 9c 24 28 01 00 	mov    %rbx,0x128(%rsp)
  5b0489:	00 
  5b048a:	48 85 db             	test   %rbx,%rbx
  5b048d:	0f 84 a9 02 00 00    	je     5b073c <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x670c>
  5b0493:	48 8d bc 24 28 01 00 	lea    0x128(%rsp),%rdi
  5b049a:	00 
  5b049b:	e8 b0 63 f8 ff       	call   536850 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtCscdodAO9FK5_5alloc5boxed3BoxNtNtCs6gaF1xUz9Bf_4gpui7element17ComponentBoundaryEEB1d_>
  5b04a0:	e9 97 02 00 00       	jmp    5b073c <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x670c>
  5b04a5:	ff 15 6d 99 53 00    	call   *0x53996d(%rip)        # ae9e18 <_DYNAMIC+0x268>
  5b04ab:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  5b04b0:	eb 15                	jmp    5b04c7 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x6497>
  5b04b2:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  5b04b7:	48 8b 84 24 f8 01 00 	mov    0x1f8(%rsp),%rax
  5b04be:	00 
  5b04bf:	48 89 84 24 b8 03 00 	mov    %rax,0x3b8(%rsp)
  5b04c6:	00 
  5b04c7:	48 83 bc 24 90 00 00 	cmpq   $0x0,0x90(%rsp)
  5b04ce:	00 00 
  5b04d0:	75 0e                	jne    5b04e0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x64b0>
  5b04d2:	48 c7 84 24 90 00 00 	movq   $0x0,0x90(%rsp)
  5b04d9:	00 00 00 00 00 
  5b04de:	eb 1f                	jmp    5b04ff <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x64cf>
  5b04e0:	48 8b b4 24 90 00 00 	mov    0x90(%rsp),%rsi
  5b04e7:	00 
  5b04e8:	48 c1 e6 05          	shl    $0x5,%rsi
  5b04ec:	ba 08 00 00 00       	mov    $0x8,%edx
  5b04f1:	48 8b bc 24 98 00 00 	mov    0x98(%rsp),%rdi
  5b04f8:	00 
  5b04f9:	ff 15 f9 98 53 00    	call   *0x5398f9(%rip)        # ae9df8 <_DYNAMIC+0x248>
  5b04ff:	48 83 bc 24 00 02 00 	cmpq   $0x0,0x200(%rsp)
  5b0506:	00 00 
  5b0508:	74 1f                	je     5b0529 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x64f9>
  5b050a:	48 8b b4 24 00 02 00 	mov    0x200(%rsp),%rsi
  5b0511:	00 
  5b0512:	48 c1 e6 03          	shl    $0x3,%rsi
  5b0516:	ba 08 00 00 00       	mov    $0x8,%edx
  5b051b:	48 8b bc 24 78 02 00 	mov    0x278(%rsp),%rdi
  5b0522:	00 
  5b0523:	ff 15 cf 98 53 00    	call   *0x5398cf(%rip)        # ae9df8 <_DYNAMIC+0x248>
  5b0529:	48 8b 84 24 60 02 00 	mov    0x260(%rsp),%rax
  5b0530:	00 
  5b0531:	48 39 84 24 80 02 00 	cmp    %rax,0x280(%rsp)
  5b0538:	00 
  5b0539:	0f 92 c0             	setb   %al
  5b053c:	48 83 bc 24 90 00 00 	cmpq   $0x0,0x90(%rsp)
  5b0543:	00 00 
  5b0545:	0f 94 c1             	sete   %cl
  5b0548:	08 c1                	or     %al,%cl
  5b054a:	75 1f                	jne    5b056b <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x653b>
  5b054c:	48 8b b4 24 90 00 00 	mov    0x90(%rsp),%rsi
  5b0553:	00 
  5b0554:	48 c1 e6 05          	shl    $0x5,%rsi
  5b0558:	ba 08 00 00 00       	mov    $0x8,%edx
  5b055d:	48 8b bc 24 98 00 00 	mov    0x98(%rsp),%rdi
  5b0564:	00 
  5b0565:	ff 15 8d 98 53 00    	call   *0x53988d(%rip)        # ae9df8 <_DYNAMIC+0x248>
  5b056b:	b3 01                	mov    $0x1,%bl
  5b056d:	48 8d bc 24 b0 03 00 	lea    0x3b0(%rsp),%rdi
  5b0574:	00 
  5b0575:	e8 f6 03 1b 00       	call   760970 <_RNvXse_NtNtCscdodAO9FK5_5alloc3vec9into_iterINtB5_8IntoIterNtNtCs6gaF1xUz9Bf_4gpui4list9ListDraftENtNtNtCs4NRVxsYgnAr_4core3ops4drop4Drop4dropBZ_>
  5b057a:	b0 01                	mov    $0x1,%al
  5b057c:	89 44 24 20          	mov    %eax,0x20(%rsp)
  5b0580:	48 8d bc 24 08 06 00 	lea    0x608(%rsp),%rdi
  5b0587:	00 
  5b0588:	e8 43 eb 17 00       	call   72f0d0 <_RNvXNtNtNtCscdodAO9FK5_5alloc11collections5btree3mapINtB2_8BTreeMapTINtNtCs4NRVxsYgnAr_4core6option6OptionyENtNtCs6gaF1xUz9Bf_4gpui4list6ListIdNtNtB1M_7element8NodeKindEjENtNtNtB19_3ops4drop4Drop4dropB1M_>
  5b058d:	40 b5 01             	mov    $0x1,%bpl
  5b0590:	84 db                	test   %bl,%bl
  5b0592:	74 0d                	je     5b05a1 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x6571>
  5b0594:	48 8d bc 24 f0 05 00 	lea    0x5f0(%rsp),%rdi
  5b059b:	00 
  5b059c:	e8 3f df 17 00       	call   72e4e0 <_RNvXNtNtNtCscdodAO9FK5_5alloc11collections5btree3mapINtB2_8BTreeMapNtNtCs6gaF1xUz9Bf_4gpui4list6ListIdNtNtNtB17_7runtime4list9ListStateENtNtNtCs4NRVxsYgnAr_4core3ops4drop4Drop4dropB17_>
  5b05a1:	45 31 f6             	xor    %r14d,%r14d
  5b05a4:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%rsp)
  5b05ab:	00 
  5b05ac:	e9 aa 01 00 00       	jmp    5b075b <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x672b>
  5b05b1:	0f 0b                	ud2
  5b05b3:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  5b05b8:	41 b7 01             	mov    $0x1,%r15b
  5b05bb:	41 b6 01             	mov    $0x1,%r14b
  5b05be:	40 b5 01             	mov    $0x1,%bpl
  5b05c1:	e9 c7 00 00 00       	jmp    5b068d <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x665d>
  5b05c6:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  5b05cb:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
  5b05d0:	49 ff cc             	dec    %r12
  5b05d3:	74 14                	je     5b05e9 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x65b9>
  5b05d5:	4d 8d be 98 00 00 00 	lea    0x98(%r14),%r15
  5b05dc:	4c 89 f7             	mov    %r14,%rdi
  5b05df:	e8 1c 5b 12 00       	call   6d6100 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueNtNtCs6gaF1xUz9Bf_4gpui7element9DraftNodeEBF_.llvm.6411074540271373818>
  5b05e4:	4d 89 fe             	mov    %r15,%r14
  5b05e7:	eb e7                	jmp    5b05d0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x65a0>
  5b05e9:	48 83 7c 24 70 00    	cmpq   $0x0,0x70(%rsp)
  5b05ef:	0f 84 08 04 00 00    	je     5b09fd <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x69cd>
  5b05f5:	48 69 74 24 70 98 00 	imul   $0x98,0x70(%rsp),%rsi
  5b05fc:	00 00 
  5b05fe:	ba 08 00 00 00       	mov    $0x8,%edx
  5b0603:	48 89 df             	mov    %rbx,%rdi
  5b0606:	ff 15 ec 97 53 00    	call   *0x5397ec(%rip)        # ae9df8 <_DYNAMIC+0x248>
  5b060c:	e9 ec 03 00 00       	jmp    5b09fd <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x69cd>
  5b0611:	ff 15 01 98 53 00    	call   *0x539801(%rip)        # ae9e18 <_DYNAMIC+0x268>
  5b0617:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  5b061c:	40 b5 01             	mov    $0x1,%bpl
  5b061f:	e9 8b 00 00 00       	jmp    5b06af <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x667f>
  5b0624:	e9 8a 02 00 00       	jmp    5b08b3 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x6883>
  5b0629:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  5b062e:	41 b6 01             	mov    $0x1,%r14b
  5b0631:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
  5b0636:	48 89 44 24 30       	mov    %rax,0x30(%rsp)
  5b063b:	48 89 5c 24 40       	mov    %rbx,0x40(%rsp)
  5b0640:	48 8b 5c 24 70       	mov    0x70(%rsp),%rbx
  5b0645:	44 8b 7c 24 18       	mov    0x18(%rsp),%r15d
  5b064a:	eb 21                	jmp    5b066d <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x663d>
  5b064c:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  5b0651:	41 b7 01             	mov    $0x1,%r15b
  5b0654:	b0 01                	mov    $0x1,%al
  5b0656:	89 44 24 10          	mov    %eax,0x10(%rsp)
  5b065a:	41 b6 01             	mov    $0x1,%r14b
  5b065d:	41 b5 01             	mov    $0x1,%r13b
  5b0660:	e9 1c 02 00 00       	jmp    5b0881 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x6851>
  5b0665:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  5b066a:	41 b6 01             	mov    $0x1,%r14b
  5b066d:	48 8d 43 ff          	lea    -0x1(%rbx),%rax
  5b0671:	48 83 f8 fc          	cmp    $0xfffffffffffffffc,%rax
  5b0675:	77 16                	ja     5b068d <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x665d>
  5b0677:	ba 01 00 00 00       	mov    $0x1,%edx
  5b067c:	48 8b bc 24 58 02 00 	mov    0x258(%rsp),%rdi
  5b0683:	00 
  5b0684:	48 89 de             	mov    %rbx,%rsi
  5b0687:	ff 15 6b 97 53 00    	call   *0x53976b(%rip)        # ae9df8 <_DYNAMIC+0x248>
  5b068d:	45 84 ff             	test   %r15b,%r15b
  5b0690:	74 18                	je     5b06aa <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x667a>
  5b0692:	48 83 bc 24 b0 03 00 	cmpq   $0xfffffffffffffffe,0x3b0(%rsp)
  5b0699:	00 fe 
  5b069b:	74 0d                	je     5b06aa <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x667a>
  5b069d:	48 8d bc 24 b0 03 00 	lea    0x3b0(%rsp),%rdi
  5b06a4:	00 
  5b06a5:	e8 96 72 f8 ff       	call   537940 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueNtNtCs6gaF1xUz9Bf_4gpui7runtime8TextSiteEBF_>
  5b06aa:	45 84 f6             	test   %r14b,%r14b
  5b06ad:	74 0f                	je     5b06be <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x668e>
  5b06af:	48 8b 7c 24 40       	mov    0x40(%rsp),%rdi
  5b06b4:	48 8b 74 24 30       	mov    0x30(%rsp),%rsi
  5b06b9:	e8 f2 8f f7 ff       	call   5296b0 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtB4_6option6OptionNtNtCs6gaF1xUz9Bf_4gpui7element7HandlerEEB11_>
  5b06be:	48 83 bc 24 28 04 00 	cmpq   $0x0,0x428(%rsp)
  5b06c5:	00 00 
  5b06c7:	0f 95 c0             	setne  %al
  5b06ca:	84 84 24 08 02 00 00 	test   %al,0x208(%rsp)
  5b06d1:	74 1c                	je     5b06ef <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x66bf>
  5b06d3:	48 8b bc 24 78 02 00 	mov    0x278(%rsp),%rdi
  5b06da:	00 
  5b06db:	48 8b 74 24 58       	mov    0x58(%rsp),%rsi
  5b06e0:	e8 cb 8f f7 ff       	call   5296b0 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtB4_6option6OptionNtNtCs6gaF1xUz9Bf_4gpui7element7HandlerEEB11_>
  5b06e5:	eb 08                	jmp    5b06ef <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x66bf>
  5b06e7:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  5b06ec:	40 b5 01             	mov    $0x1,%bpl
  5b06ef:	48 8b b4 24 a0 00 00 	mov    0xa0(%rsp),%rsi
  5b06f6:	00 
  5b06f7:	48 83 fe ff          	cmp    $0xffffffffffffffff,%rsi
  5b06fb:	74 18                	je     5b0715 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x66e5>
  5b06fd:	48 85 f6             	test   %rsi,%rsi
  5b0700:	7e 13                	jle    5b0715 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x66e5>
  5b0702:	48 8b bc 24 a8 00 00 	mov    0xa8(%rsp),%rdi
  5b0709:	00 
  5b070a:	ba 01 00 00 00       	mov    $0x1,%edx
  5b070f:	ff 15 e3 96 53 00    	call   *0x5396e3(%rip)        # ae9df8 <_DYNAMIC+0x248>
  5b0715:	40 84 ed             	test   %bpl,%bpl
  5b0718:	74 15                	je     5b072f <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x66ff>
  5b071a:	48 8b bc 24 18 01 00 	mov    0x118(%rsp),%rdi
  5b0721:	00 
  5b0722:	48 8b b4 24 20 01 00 	mov    0x120(%rsp),%rsi
  5b0729:	00 
  5b072a:	e8 81 8f f7 ff       	call   5296b0 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtB4_6option6OptionNtNtCs6gaF1xUz9Bf_4gpui7element7HandlerEEB11_>
  5b072f:	48 8d bc 24 28 01 00 	lea    0x128(%rsp),%rdi
  5b0736:	00 
  5b0737:	e8 f4 70 f8 ff       	call   537830 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueNtNtCs6gaF1xUz9Bf_4gpui7element19ComponentBoundariesEBF_>
  5b073c:	b0 01                	mov    $0x1,%al
  5b073e:	89 44 24 20          	mov    %eax,0x20(%rsp)
  5b0742:	48 8d bc 24 00 04 00 	lea    0x400(%rsp),%rdi
  5b0749:	00 
  5b074a:	e8 c1 03 1b 00       	call   760b10 <_RNvXse_NtNtCscdodAO9FK5_5alloc3vec9into_iterINtB5_8IntoIterNtNtCs6gaF1xUz9Bf_4gpui7element9DraftNodeENtNtNtCs4NRVxsYgnAr_4core3ops4drop4Drop4dropBZ_>
  5b074f:	40 b5 01             	mov    $0x1,%bpl
  5b0752:	41 b6 01             	mov    $0x1,%r14b
  5b0755:	b0 01                	mov    $0x1,%al
  5b0757:	89 44 24 10          	mov    %eax,0x10(%rsp)
  5b075b:	ba 04 00 00 00       	mov    $0x4,%edx
  5b0760:	48 8b bc 24 48 02 00 	mov    0x248(%rsp),%rdi
  5b0767:	00 
  5b0768:	48 8b b4 24 d0 02 00 	mov    0x2d0(%rsp),%rsi
  5b076f:	00 
  5b0770:	ff 15 82 96 53 00    	call   *0x539682(%rip)        # ae9df8 <_DYNAMIC+0x248>
  5b0776:	41 b4 01             	mov    $0x1,%r12b
  5b0779:	45 31 ff             	xor    %r15d,%r15d
  5b077c:	48 8d bc 24 28 05 00 	lea    0x528(%rsp),%rdi
  5b0783:	00 
  5b0784:	e8 b7 4e f8 ff       	call   535640 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtCscdodAO9FK5_5alloc3vec3VecINtNtB4_6option6OptionNtNtCs6gaF1xUz9Bf_4gpui7runtime8TextSiteEEEB1x_>
  5b0789:	40 84 ed             	test   %bpl,%bpl
  5b078c:	74 0d                	je     5b079b <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x676b>
  5b078e:	48 8d bc 24 18 02 00 	lea    0x218(%rsp),%rdi
  5b0795:	00 
  5b0796:	e8 d5 5a f8 ff       	call   536270 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtCscdodAO9FK5_5alloc3vec3VecNtNtCs6gaF1xUz9Bf_4gpui7runtime4NodeEEB1b_>
  5b079b:	41 b5 01             	mov    $0x1,%r13b
  5b079e:	45 84 e4             	test   %r12b,%r12b
  5b07a1:	74 10                	je     5b07b3 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x6783>
  5b07a3:	48 8d bc 24 08 07 00 	lea    0x708(%rsp),%rdi
  5b07aa:	00 
  5b07ab:	e8 20 82 f8 ff       	call   5389d0 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueNtNtNtCs6gaF1xUz9Bf_4gpui7runtime6styles8BuildingEBH_>
  5b07b0:	41 b5 01             	mov    $0x1,%r13b
  5b07b3:	48 8b b4 24 d8 02 00 	mov    0x2d8(%rsp),%rsi
  5b07ba:	00 
  5b07bb:	48 85 f6             	test   %rsi,%rsi
  5b07be:	74 52                	je     5b0812 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x67e2>
  5b07c0:	48 c1 e6 03          	shl    $0x3,%rsi
  5b07c4:	ba 08 00 00 00       	mov    $0x8,%edx
  5b07c9:	48 8b bc 24 80 00 00 	mov    0x80(%rsp),%rdi
  5b07d0:	00 
  5b07d1:	ff 15 21 96 53 00    	call   *0x539621(%rip)        # ae9df8 <_DYNAMIC+0x248>
  5b07d7:	eb 39                	jmp    5b0812 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x67e2>
  5b07d9:	eb 1d                	jmp    5b07f8 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x67c8>
  5b07db:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  5b07e0:	ba 08 00 00 00       	mov    $0x8,%edx
  5b07e5:	48 8b bc 24 80 00 00 	mov    0x80(%rsp),%rdi
  5b07ec:	00 
  5b07ed:	48 89 de             	mov    %rbx,%rsi
  5b07f0:	ff 15 02 96 53 00    	call   *0x539602(%rip)        # ae9df8 <_DYNAMIC+0x248>
  5b07f6:	eb 05                	jmp    5b07fd <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x67cd>
  5b07f8:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  5b07fd:	b0 01                	mov    $0x1,%al
  5b07ff:	89 44 24 20          	mov    %eax,0x20(%rsp)
  5b0803:	41 b5 01             	mov    $0x1,%r13b
  5b0806:	41 b6 01             	mov    $0x1,%r14b
  5b0809:	b0 01                	mov    $0x1,%al
  5b080b:	89 44 24 10          	mov    %eax,0x10(%rsp)
  5b080f:	41 b7 01             	mov    $0x1,%r15b
  5b0812:	48 8d bc 24 10 05 00 	lea    0x510(%rsp),%rdi
  5b0819:	00 
  5b081a:	e8 11 d2 17 00       	call   72da30 <_RNvXNtNtNtCscdodAO9FK5_5alloc11collections5btree3mapINtB2_8BTreeMapINtNtCs4NRVxsYgnAr_4core6option6OptionyEjENtNtNtB18_3ops4drop4Drop4dropCs6gaF1xUz9Bf_4gpui>
  5b081f:	48 8d bc 24 f0 06 00 	lea    0x6f0(%rsp),%rdi
  5b0826:	00 
  5b0827:	e8 74 ef 17 00       	call   72f7a0 <_RNvXNtNtNtCscdodAO9FK5_5alloc11collections5btree3mapINtB2_8BTreeMapjNtNtCs6gaF1xUz9Bf_4gpui4list6ListIdENtNtNtCs4NRVxsYgnAr_4core3ops4drop4Drop4dropB18_>
  5b082c:	48 8d bc 24 d8 05 00 	lea    0x5d8(%rsp),%rdi
  5b0833:	00 
  5b0834:	e8 97 e8 17 00       	call   72f0d0 <_RNvXNtNtNtCscdodAO9FK5_5alloc11collections5btree3mapINtB2_8BTreeMapTINtNtCs4NRVxsYgnAr_4core6option6OptionyENtNtCs6gaF1xUz9Bf_4gpui4list6ListIdNtNtB1M_7element8NodeKindEjENtNtNtB19_3ops4drop4Drop4dropB1M_>
  5b0839:	48 8d bc 24 c0 05 00 	lea    0x5c0(%rsp),%rdi
  5b0840:	00 
  5b0841:	e8 8a e8 17 00       	call   72f0d0 <_RNvXNtNtNtCscdodAO9FK5_5alloc11collections5btree3mapINtB2_8BTreeMapTINtNtCs4NRVxsYgnAr_4core6option6OptionyENtNtCs6gaF1xUz9Bf_4gpui4list6ListIdNtNtB1M_7element8NodeKindEjENtNtNtB19_3ops4drop4Drop4dropB1M_>
  5b0846:	48 8d bc 24 a8 05 00 	lea    0x5a8(%rsp),%rdi
  5b084d:	00 
  5b084e:	e8 ed eb 17 00       	call   72f440 <_RNvXNtNtNtCscdodAO9FK5_5alloc11collections5btree3mapINtB2_8BTreeMapTINtNtCs4NRVxsYgnAr_4core6option6OptionyEmNtNtCs6gaF1xUz9Bf_4gpui7element8NodeKindEjENtNtNtB19_3ops4drop4Drop4dropB1N_>
  5b0853:	48 8d bc 24 88 04 00 	lea    0x488(%rsp),%rdi
  5b085a:	00 
  5b085b:	e8 70 4d f8 ff       	call   5355d0 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtCscdodAO9FK5_5alloc3vec3VecINtNtB4_6option6OptionNtNtCs6gaF1xUz9Bf_4gpui7runtime4NodeEEEB1x_>
  5b0860:	48 8d bc 24 40 05 00 	lea    0x540(%rsp),%rdi
  5b0867:	00 
  5b0868:	e8 f3 80 f8 ff       	call   538960 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueNtNtNtCs6gaF1xUz9Bf_4gpui7runtime6styles6StylesEBH_>
  5b086d:	48 8d bc 24 58 04 00 	lea    0x458(%rsp),%rdi
  5b0874:	00 
  5b0875:	e8 d6 df 17 00       	call   72e850 <_RNvXNtNtNtCscdodAO9FK5_5alloc11collections5btree3mapINtB2_8BTreeMapNtNtCs6gaF1xUz9Bf_4gpui6source7FieldIdNtNtB17_11shared_text10SharedTextENtNtNtCs4NRVxsYgnAr_4core3ops4drop4Drop4dropB17_>
  5b087a:	80 7c 24 20 00       	cmpb   $0x0,0x20(%rsp)
  5b087f:	74 29                	je     5b08aa <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x687a>
  5b0881:	48 8b b4 24 b8 02 00 	mov    0x2b8(%rsp),%rsi
  5b0888:	00 
  5b0889:	40 b5 01             	mov    $0x1,%bpl
  5b088c:	48 85 f6             	test   %rsi,%rsi
  5b088f:	74 1b                	je     5b08ac <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x687c>
  5b0891:	48 8b bc 24 c0 02 00 	mov    0x2c0(%rsp),%rdi
  5b0898:	00 
  5b0899:	48 c1 e6 04          	shl    $0x4,%rsi
  5b089d:	ba 08 00 00 00       	mov    $0x8,%edx
  5b08a2:	ff 15 50 95 53 00    	call   *0x539550(%rip)        # ae9df8 <_DYNAMIC+0x248>
  5b08a8:	eb 02                	jmp    5b08ac <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x687c>
  5b08aa:	31 ed                	xor    %ebp,%ebp
  5b08ac:	45 84 ed             	test   %r13b,%r13b
  5b08af:	75 16                	jne    5b08c7 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x6897>
  5b08b1:	eb 21                	jmp    5b08d4 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x68a4>
  5b08b3:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  5b08b8:	41 b7 01             	mov    $0x1,%r15b
  5b08bb:	b0 01                	mov    $0x1,%al
  5b08bd:	89 44 24 10          	mov    %eax,0x10(%rsp)
  5b08c1:	41 b6 01             	mov    $0x1,%r14b
  5b08c4:	40 b5 01             	mov    $0x1,%bpl
  5b08c7:	48 8d bc 24 30 02 00 	lea    0x230(%rsp),%rdi
  5b08ce:	00 
  5b08cf:	e8 6c e0 17 00       	call   72e940 <_RNvXNtNtNtCscdodAO9FK5_5alloc11collections5btree3mapINtB2_8BTreeMapNtNtCs6gaF1xUz9Bf_4gpui6source7FieldIdNtNtB17_7runtime6FanoutENtNtNtCs4NRVxsYgnAr_4core3ops4drop4Drop4dropB17_>
  5b08d4:	ba 08 00 00 00       	mov    $0x8,%edx
  5b08d9:	48 8b bc 24 e0 02 00 	mov    0x2e0(%rsp),%rdi
  5b08e0:	00 
  5b08e1:	48 8b b4 24 c8 04 00 	mov    0x4c8(%rsp),%rsi
  5b08e8:	00 
  5b08e9:	ff 15 09 95 53 00    	call   *0x539509(%rip)        # ae9df8 <_DYNAMIC+0x248>
  5b08ef:	48 8b b4 24 a0 02 00 	mov    0x2a0(%rsp),%rsi
  5b08f6:	00 
  5b08f7:	48 85 f6             	test   %rsi,%rsi
  5b08fa:	74 17                	je     5b0913 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x68e3>
  5b08fc:	48 8b bc 24 a8 02 00 	mov    0x2a8(%rsp),%rdi
  5b0903:	00 
  5b0904:	48 c1 e6 02          	shl    $0x2,%rsi
  5b0908:	ba 04 00 00 00       	mov    $0x4,%edx
  5b090d:	ff 15 e5 94 53 00    	call   *0x5394e5(%rip)        # ae9df8 <_DYNAMIC+0x248>
  5b0913:	48 8b b4 24 88 02 00 	mov    0x288(%rsp),%rsi
  5b091a:	00 
  5b091b:	48 85 f6             	test   %rsi,%rsi
  5b091e:	74 17                	je     5b0937 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x6907>
  5b0920:	48 8b bc 24 90 02 00 	mov    0x290(%rsp),%rdi
  5b0927:	00 
  5b0928:	48 c1 e6 03          	shl    $0x3,%rsi
  5b092c:	ba 08 00 00 00       	mov    $0x8,%edx
  5b0931:	ff 15 c1 94 53 00    	call   *0x5394c1(%rip)        # ae9df8 <_DYNAMIC+0x248>
  5b0937:	48 8b b4 24 e8 02 00 	mov    0x2e8(%rsp),%rsi
  5b093e:	00 
  5b093f:	48 85 f6             	test   %rsi,%rsi
  5b0942:	74 17                	je     5b095b <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x692b>
  5b0944:	48 8b bc 24 f0 02 00 	mov    0x2f0(%rsp),%rdi
  5b094b:	00 
  5b094c:	48 c1 e6 03          	shl    $0x3,%rsi
  5b0950:	ba 08 00 00 00       	mov    $0x8,%edx
  5b0955:	ff 15 9d 94 53 00    	call   *0x53949d(%rip)        # ae9df8 <_DYNAMIC+0x248>
  5b095b:	48 8d bc 24 20 06 00 	lea    0x620(%rsp),%rdi
  5b0962:	00 
  5b0963:	e8 38 ee 17 00       	call   72f7a0 <_RNvXNtNtNtCscdodAO9FK5_5alloc11collections5btree3mapINtB2_8BTreeMapjNtNtCs6gaF1xUz9Bf_4gpui4list6ListIdENtNtNtCs4NRVxsYgnAr_4core3ops4drop4Drop4dropB18_>
  5b0968:	45 84 f6             	test   %r14b,%r14b
  5b096b:	74 0d                	je     5b097a <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x694a>
  5b096d:	48 8d bc 24 70 04 00 	lea    0x470(%rsp),%rdi
  5b0974:	00 
  5b0975:	e8 f6 5a f8 ff       	call   536470 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtCscdodAO9FK5_5alloc3vec3VecNtNtCs7XZEQI6Z5Ts_11gpui_canvas5image5ImageEECs6gaF1xUz9Bf_4gpui>
  5b097a:	48 8d bc 24 c0 06 00 	lea    0x6c0(%rsp),%rdi
  5b0981:	00 
  5b0982:	e8 a9 d0 17 00       	call   72da30 <_RNvXNtNtNtCscdodAO9FK5_5alloc11collections5btree3mapINtB2_8BTreeMapINtNtCs4NRVxsYgnAr_4core6option6OptionyEjENtNtNtB18_3ops4drop4Drop4dropCs6gaF1xUz9Bf_4gpui>
  5b0987:	45 31 ed             	xor    %r13d,%r13d
  5b098a:	48 8d bc 24 a8 06 00 	lea    0x6a8(%rsp),%rdi
  5b0991:	00 
  5b0992:	e8 09 ee 17 00       	call   72f7a0 <_RNvXNtNtNtCscdodAO9FK5_5alloc11collections5btree3mapINtB2_8BTreeMapjNtNtCs6gaF1xUz9Bf_4gpui4list6ListIdENtNtNtCs4NRVxsYgnAr_4core3ops4drop4Drop4dropB18_>
  5b0997:	48 8b 8c 24 e8 04 00 	mov    0x4e8(%rsp),%rcx
  5b099e:	00 
  5b099f:	48 85 c9             	test   %rcx,%rcx
  5b09a2:	0f 95 c0             	setne  %al
  5b09a5:	41 84 c5             	test   %al,%r13b
  5b09a8:	74 1b                	je     5b09c5 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x6995>
  5b09aa:	48 c1 e1 03          	shl    $0x3,%rcx
  5b09ae:	48 8d 34 49          	lea    (%rcx,%rcx,2),%rsi
  5b09b2:	ba 08 00 00 00       	mov    $0x8,%edx
  5b09b7:	48 8b bc 24 e0 04 00 	mov    0x4e0(%rsp),%rdi
  5b09be:	00 
  5b09bf:	ff 15 33 94 53 00    	call   *0x539433(%rip)        # ae9df8 <_DYNAMIC+0x248>
  5b09c5:	40 84 ed             	test   %bpl,%bpl
  5b09c8:	74 0d                	je     5b09d7 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x69a7>
  5b09ca:	48 8d bc 24 40 04 00 	lea    0x440(%rsp),%rdi
  5b09d1:	00 
  5b09d2:	e8 e9 59 f8 ff       	call   5363c0 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtCscdodAO9FK5_5alloc3vec3VecNtNtCs6gaF1xUz9Bf_4gpui8semantic15AnnotationDraftEEB1b_>
  5b09d7:	80 7c 24 10 00       	cmpb   $0x0,0x10(%rsp)
  5b09dc:	74 0d                	je     5b09eb <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x69bb>
  5b09de:	48 8d bc 24 f0 04 00 	lea    0x4f0(%rsp),%rdi
  5b09e5:	00 
  5b09e6:	e8 55 56 f8 ff       	call   536040 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtCscdodAO9FK5_5alloc3vec3VecNtNtCs6gaF1xUz9Bf_4gpui4list9ListDraftEEB1b_>
  5b09eb:	45 84 ff             	test   %r15b,%r15b
  5b09ee:	74 0d                	je     5b09fd <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x69cd>
  5b09f0:	48 8d bc 24 38 06 00 	lea    0x638(%rsp),%rdi
  5b09f7:	00 
  5b09f8:	e8 f3 56 f8 ff       	call   5360f0 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtCscdodAO9FK5_5alloc3vec3VecNtNtCs6gaF1xUz9Bf_4gpui7element9DraftNodeEEB1b_>
  5b09fd:	48 8d bc 24 d8 06 00 	lea    0x6d8(%rsp),%rdi
  5b0a04:	00 
  5b0a05:	e8 d6 d7 17 00       	call   72e1e0 <_RNvXNtNtNtCscdodAO9FK5_5alloc11collections5btree3mapINtB2_8BTreeMapNtNtCs6gaF1xUz9Bf_4gpui4list6ListIdNtNtB4_7set_val9SetValZSTENtNtNtCs4NRVxsYgnAr_4core3ops4drop4Drop4dropB17_>
  5b0a0a:	48 8b 7c 24 08       	mov    0x8(%rsp),%rdi
  5b0a0f:	e8 bc 68 50 00       	call   ab72d0 <_Unwind_Resume@plt>
  5b0a14:	ff 15 fe 93 53 00    	call   *0x5393fe(%rip)        # ae9e18 <_DYNAMIC+0x268>
