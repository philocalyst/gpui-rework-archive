
/tmp/gpui-validated-lookup-apps-47b10baaa49b35f2e0adf9713c95b13d4bbe776de05550eb007192163d59af6f:     file format elf64-x86-64


Disassembly of section .text:

00000000005aa050 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_>:
  5aa050:	55                   	push   %rbp
  5aa051:	41 57                	push   %r15
  5aa053:	41 56                	push   %r14
  5aa055:	41 55                	push   %r13
  5aa057:	41 54                	push   %r12
  5aa059:	53                   	push   %rbx
  5aa05a:	48 81 ec b8 07 00 00 	sub    $0x7b8,%rsp
  5aa061:	4c 89 c3             	mov    %r8,%rbx
  5aa064:	49 89 ce             	mov    %rcx,%r14
  5aa067:	49 89 f4             	mov    %rsi,%r12
  5aa06a:	48 89 bc 24 88 00 00 	mov    %rdi,0x88(%rsp)
  5aa071:	00 
  5aa072:	0f b6 86 5a 09 00 00 	movzbl 0x95a(%rsi),%eax
  5aa079:	88 84 24 98 00 00 00 	mov    %al,0x98(%rsp)
  5aa080:	48 ff 86 e8 08 00 00 	incq   0x8e8(%rsi)
  5aa087:	85 d2                	test   %edx,%edx
  5aa089:	75 08                	jne    5aa093 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x43>
  5aa08b:	49 ff 84 24 e0 08 00 	incq   0x8e0(%r12)
  5aa092:	00 
  5aa093:	48 c7 84 24 d8 06 00 	movq   $0x0,0x6d8(%rsp)
  5aa09a:	00 00 00 00 00 
  5aa09f:	48 c7 84 24 e8 06 00 	movq   $0x0,0x6e8(%rsp)
  5aa0a6:	00 00 00 00 00 
  5aa0ab:	49 8d 8c 24 98 07 00 	lea    0x798(%r12),%rcx
  5aa0b2:	00 
  5aa0b3:	49 8b 84 24 98 07 00 	mov    0x798(%r12),%rax
  5aa0ba:	00 
  5aa0bb:	48 c7 84 24 b8 03 00 	movq   $0x0,0x3b8(%rsp)
  5aa0c2:	00 00 00 00 00 
  5aa0c7:	48 89 84 24 c0 03 00 	mov    %rax,0x3c0(%rsp)
  5aa0ce:	00 
  5aa0cf:	48 89 4c 24 20       	mov    %rcx,0x20(%rsp)
  5aa0d4:	48 89 8c 24 b0 03 00 	mov    %rcx,0x3b0(%rsp)
  5aa0db:	00 
  5aa0dc:	c6 84 24 48 01 00 00 	movb   $0x0,0x148(%rsp)
  5aa0e3:	00 
  5aa0e4:	48 c7 84 24 b8 00 00 	movq   $0xffffffffffffffff,0xb8(%rsp)
  5aa0eb:	00 ff ff ff ff 
  5aa0f0:	48 c7 84 24 a0 00 00 	movq   $0x0,0xa0(%rsp)
  5aa0f7:	00 00 00 00 00 
  5aa0fc:	48 c7 84 24 a8 00 00 	movq   $0x8,0xa8(%rsp)
  5aa103:	00 08 00 00 00 
  5aa108:	48 c7 84 24 b0 00 00 	movq   $0x0,0xb0(%rsp)
  5aa10f:	00 00 00 00 00 
  5aa114:	0f 10 05 f5 59 ad ff 	movups -0x52a60b(%rip),%xmm0        # 7fb10 <anon.1f6b7bab1fc61e0fcd36456038a862fb.78.llvm.12454362996328431623>
  5aa11b:	0f 11 84 24 d0 00 00 	movups %xmm0,0xd0(%rsp)
  5aa122:	00 
  5aa123:	0f 10 05 f6 59 ad ff 	movups -0x52a60a(%rip),%xmm0        # 7fb20 <anon.1f6b7bab1fc61e0fcd36456038a862fb.78.llvm.12454362996328431623+0x10>
  5aa12a:	0f 11 84 24 e0 00 00 	movups %xmm0,0xe0(%rsp)
  5aa131:	00 
  5aa132:	0f 10 05 f7 59 ad ff 	movups -0x52a609(%rip),%xmm0        # 7fb30 <anon.1f6b7bab1fc61e0fcd36456038a862fb.78.llvm.12454362996328431623+0x20>
  5aa139:	0f 11 84 24 f0 00 00 	movups %xmm0,0xf0(%rsp)
  5aa140:	00 
  5aa141:	0f 10 05 f8 59 ad ff 	movups -0x52a608(%rip),%xmm0        # 7fb40 <anon.1f6b7bab1fc61e0fcd36456038a862fb.78.llvm.12454362996328431623+0x30>
  5aa148:	0f 11 84 24 00 01 00 	movups %xmm0,0x100(%rsp)
  5aa14f:	00 
  5aa150:	0f 10 05 f9 59 ad ff 	movups -0x52a607(%rip),%xmm0        # 7fb50 <anon.1f6b7bab1fc61e0fcd36456038a862fb.78.llvm.12454362996328431623+0x40>
  5aa157:	0f 11 84 24 10 01 00 	movups %xmm0,0x110(%rsp)
  5aa15e:	00 
  5aa15f:	48 8b 05 fa 59 ad ff 	mov    -0x52a606(%rip),%rax        # 7fb60 <anon.1f6b7bab1fc61e0fcd36456038a862fb.78.llvm.12454362996328431623+0x50>
  5aa166:	48 89 84 24 20 01 00 	mov    %rax,0x120(%rsp)
  5aa16d:	00 
  5aa16e:	48 c7 84 24 28 01 00 	movq   $0x0,0x128(%rsp)
  5aa175:	00 00 00 00 00 
  5aa17a:	0f 57 c0             	xorps  %xmm0,%xmm0
  5aa17d:	0f 11 84 24 38 01 00 	movups %xmm0,0x138(%rsp)
  5aa184:	00 
  5aa185:	c6 84 24 24 01 00 00 	movb   $0x1,0x124(%rsp)
  5aa18c:	01 
  5aa18d:	48 8d bc 24 b0 03 00 	lea    0x3b0(%rsp),%rdi
  5aa194:	00 
  5aa195:	48 8d b4 24 a0 00 00 	lea    0xa0(%rsp),%rsi
  5aa19c:	00 
  5aa19d:	e8 8e d4 18 00       	call   737630 <_RNvXsi_NtCs6gaF1xUz9Bf_4gpui7elementINtNtNtNtCs4NRVxsYgnAr_4core4iter8adapters3map3MapINtNtNtBH_3ops5range5RangejENCNvXs0_NtNtB7_7runtime12style_ledgerNtB1W_9AdversaryNtB7_4View4view0EINtB5_8ChildSeqINtNtB5_5shape4IterNtB3e_3OneEE6appendB7_>
  5aa1a2:	4c 8d bc 24 00 03 00 	lea    0x300(%rsp),%r15
  5aa1a9:	00 
  5aa1aa:	48 8d b4 24 a0 00 00 	lea    0xa0(%rsp),%rsi
  5aa1b1:	00 
  5aa1b2:	ba b0 00 00 00       	mov    $0xb0,%edx
  5aa1b7:	4c 89 ff             	mov    %r15,%rdi
  5aa1ba:	ff 15 40 fe 53 00    	call   *0x53fe40(%rip)        # aea000 <memcpy@GLIBC_2.14>
  5aa1c0:	49 8d 8c 24 f8 07 00 	lea    0x7f8(%r12),%rcx
  5aa1c7:	00 
  5aa1c8:	4c 89 64 24 10       	mov    %r12,0x10(%rsp)
  5aa1cd:	49 8d 94 24 18 08 00 	lea    0x818(%r12),%rdx
  5aa1d4:	00 
  5aa1d5:	48 8d 84 24 d8 06 00 	lea    0x6d8(%rsp),%rax
  5aa1dc:	00 
  5aa1dd:	48 89 84 24 a0 00 00 	mov    %rax,0xa0(%rsp)
  5aa1e4:	00 
  5aa1e5:	48 89 8c 24 98 05 00 	mov    %rcx,0x598(%rsp)
  5aa1ec:	00 
  5aa1ed:	48 89 8c 24 a8 00 00 	mov    %rcx,0xa8(%rsp)
  5aa1f4:	00 
  5aa1f5:	48 89 94 24 a0 05 00 	mov    %rdx,0x5a0(%rsp)
  5aa1fc:	00 
  5aa1fd:	48 89 94 24 b0 00 00 	mov    %rdx,0xb0(%rsp)
  5aa204:	00 
  5aa205:	4c 89 b4 24 b8 00 00 	mov    %r14,0xb8(%rsp)
  5aa20c:	00 
  5aa20d:	4c 8d 05 0c e6 50 00 	lea    0x50e60c(%rip),%r8        # ab8820 <__frame_dummy_init_array_entry+0xd0>
  5aa214:	48 8d bc 24 90 01 00 	lea    0x190(%rsp),%rdi
  5aa21b:	00 
  5aa21c:	4c 8d 8c 24 a0 00 00 	lea    0xa0(%rsp),%r9
  5aa223:	00 
  5aa224:	ba a0 86 01 00       	mov    $0x186a0,%edx
  5aa229:	4c 89 fe             	mov    %r15,%rsi
  5aa22c:	48 89 d9             	mov    %rbx,%rcx
  5aa22f:	e8 3c 98 1f 00       	call   7a3a70 <_RINvMs4_NtCs6gaF1xUz9Bf_4gpui7elementNtB6_2El13flatten_listsNCNvMsq_NtB8_7runtimeINtB14_7RuntimeNtNtB14_12style_ledger9AdversaryE14describe_inner0EB8_>
  5aa234:	48 8b 8c 24 90 01 00 	mov    0x190(%rsp),%rcx
  5aa23b:	00 
  5aa23c:	48 8b 94 24 98 01 00 	mov    0x198(%rsp),%rdx
  5aa243:	00 
  5aa244:	4c 8b a4 24 a0 01 00 	mov    0x1a0(%rsp),%r12
  5aa24b:	00 
  5aa24c:	48 83 f9 ff          	cmp    $0xffffffffffffffff,%rcx
  5aa250:	0f 84 31 01 00 00    	je     5aa387 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x337>
  5aa256:	48 8b 84 24 b8 01 00 	mov    0x1b8(%rsp),%rax
  5aa25d:	00 
  5aa25e:	48 89 84 24 00 05 00 	mov    %rax,0x500(%rsp)
  5aa265:	00 
  5aa266:	0f 10 84 24 a8 01 00 	movups 0x1a8(%rsp),%xmm0
  5aa26d:	00 
  5aa26e:	0f 29 84 24 f0 04 00 	movaps %xmm0,0x4f0(%rsp)
  5aa275:	00 
  5aa276:	48 8b 84 24 d0 01 00 	mov    0x1d0(%rsp),%rax
  5aa27d:	00 
  5aa27e:	48 89 84 24 50 04 00 	mov    %rax,0x450(%rsp)
  5aa285:	00 
  5aa286:	0f 10 84 24 c0 01 00 	movups 0x1c0(%rsp),%xmm0
  5aa28d:	00 
  5aa28e:	0f 29 84 24 40 04 00 	movaps %xmm0,0x440(%rsp)
  5aa295:	00 
  5aa296:	48 8b 84 24 d8 01 00 	mov    0x1d8(%rsp),%rax
  5aa29d:	00 
  5aa29e:	48 89 84 24 e8 04 00 	mov    %rax,0x4e8(%rsp)
  5aa2a5:	00 
  5aa2a6:	48 8b 84 24 e0 01 00 	mov    0x1e0(%rsp),%rax
  5aa2ad:	00 
  5aa2ae:	48 89 84 24 e0 04 00 	mov    %rax,0x4e0(%rsp)
  5aa2b5:	00 
  5aa2b6:	48 8b 84 24 e8 01 00 	mov    0x1e8(%rsp),%rax
  5aa2bd:	00 
  5aa2be:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  5aa2c3:	48 89 4c 24 70       	mov    %rcx,0x70(%rsp)
  5aa2c8:	48 89 8c 24 38 06 00 	mov    %rcx,0x638(%rsp)
  5aa2cf:	00 
  5aa2d0:	48 89 54 24 40       	mov    %rdx,0x40(%rsp)
  5aa2d5:	48 89 94 24 40 06 00 	mov    %rdx,0x640(%rsp)
  5aa2dc:	00 
  5aa2dd:	4c 89 a4 24 48 06 00 	mov    %r12,0x648(%rsp)
  5aa2e4:	00 
  5aa2e5:	48 8b 9c 24 f8 04 00 	mov    0x4f8(%rsp),%rbx
  5aa2ec:	00 
  5aa2ed:	4c 69 b4 24 00 05 00 	imul   $0xa8,0x500(%rsp),%r14
  5aa2f4:	00 a8 00 00 00 
  5aa2f9:	49 01 de             	add    %rbx,%r14
  5aa2fc:	40 b5 01             	mov    $0x1,%bpl
  5aa2ff:	48 8d bc 24 a8 06 00 	lea    0x6a8(%rsp),%rdi
  5aa306:	00 
  5aa307:	41 b5 01             	mov    $0x1,%r13b
  5aa30a:	41 b7 01             	mov    $0x1,%r15b
  5aa30d:	48 89 de             	mov    %rbx,%rsi
  5aa310:	4c 89 f2             	mov    %r14,%rdx
  5aa313:	e8 48 0e 17 00       	call   71b160 <_RINvXs1o_NtNtNtCscdodAO9FK5_5alloc11collections5btree3mapINtB7_8BTreeMapjNtNtCs6gaF1xUz9Bf_4gpui4list6ListIdEINtNtNtNtCs4NRVxsYgnAr_4core4iter6traits7collect12FromIteratorTjB19_EE9from_iterINtNtNtB1Q_8adapters3map3MapINtNtNtB1S_5slice4iter4IterNtB1b_9ListDraftENCNvMsq_NtB1d_7runtimeINtB4j_7RuntimeNtNtB4j_12style_ledger9AdversaryE14describe_inners_0EEB1d_>
  5aa318:	48 89 9c 24 a0 00 00 	mov    %rbx,0xa0(%rsp)
  5aa31f:	00 
  5aa320:	4c 89 b4 24 a8 00 00 	mov    %r14,0xa8(%rsp)
  5aa327:	00 
  5aa328:	48 c7 84 24 b0 00 00 	movq   $0x0,0xb0(%rsp)
  5aa32f:	00 00 00 00 00 
  5aa334:	48 c7 84 24 c8 00 00 	movq   $0x0,0xc8(%rsp)
  5aa33b:	00 00 00 00 00 
  5aa340:	b3 01                	mov    $0x1,%bl
  5aa342:	48 8d bc 24 c0 06 00 	lea    0x6c0(%rsp),%rdi
  5aa349:	00 
  5aa34a:	48 8d b4 24 a0 00 00 	lea    0xa0(%rsp),%rsi
  5aa351:	00 
  5aa352:	41 b5 01             	mov    $0x1,%r13b
  5aa355:	41 b7 01             	mov    $0x1,%r15b
  5aa358:	e8 83 41 17 00       	call   71e4e0 <_RINvXs1o_NtNtNtCscdodAO9FK5_5alloc11collections5btree3mapINtB7_8BTreeMapjTNtNtCs6gaF1xUz9Bf_4gpui4list6ListIdRNtB1c_8RowDraftEEINtNtNtNtCs4NRVxsYgnAr_4core4iter6traits7collect12FromIteratorTjB19_EE9from_iterINtNtNtB28_8adapters7flatten7FlatMapINtNtNtB2a_5slice4iter4IterNtB1c_9ListDraftEINtNtB3o_3map3MapIB3U_B1K_ENCNCNvMsq_NtB1e_7runtimeINtB5c_7RuntimeNtNtB5c_12style_ledger9AdversaryE14describe_inners0_00ENCB56_s0_0EEB1e_>
  5aa35d:	49 81 fc a0 86 01 00 	cmp    $0x186a0,%r12
  5aa364:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  5aa369:	4c 8b 7c 24 40       	mov    0x40(%rsp),%r15
  5aa36e:	76 33                	jbe    5aa3a3 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x353>
  5aa370:	48 8b 84 24 88 00 00 	mov    0x88(%rsp),%rax
  5aa377:	00 
  5aa378:	48 c7 00 1d 00 00 00 	movq   $0x1d,(%rax)
  5aa37f:	41 b5 01             	mov    $0x1,%r13b
  5aa382:	e9 90 51 00 00       	jmp    5af517 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x54c7>
  5aa387:	48 8b 84 24 88 00 00 	mov    0x88(%rsp),%rax
  5aa38e:	00 
  5aa38f:	48 c7 00 25 00 00 00 	movq   $0x25,(%rax)
  5aa396:	48 89 50 08          	mov    %rdx,0x8(%rax)
  5aa39a:	4c 89 60 10          	mov    %r12,0x10(%rax)
  5aa39e:	e9 26 53 00 00       	jmp    5af6c9 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5679>
  5aa3a3:	48 8b 80 e0 07 00 00 	mov    0x7e0(%rax),%rax
  5aa3aa:	4c 01 e0             	add    %r12,%rax
  5aa3ad:	0f 82 e0 53 00 00    	jb     5af793 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5743>
  5aa3b3:	48 8b 84 24 e8 04 00 	mov    0x4e8(%rsp),%rax
  5aa3ba:	00 
  5aa3bb:	48 89 84 24 90 01 00 	mov    %rax,0x190(%rsp)
  5aa3c2:	00 
  5aa3c3:	48 8b 84 24 e0 04 00 	mov    0x4e0(%rsp),%rax
  5aa3ca:	00 
  5aa3cb:	48 89 84 24 98 01 00 	mov    %rax,0x198(%rsp)
  5aa3d2:	00 
  5aa3d3:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  5aa3d8:	48 89 84 24 a0 01 00 	mov    %rax,0x1a0(%rsp)
  5aa3df:	00 
  5aa3e0:	48 8d bc 24 a0 00 00 	lea    0xa0(%rsp),%rdi
  5aa3e7:	00 
  5aa3e8:	48 8d b4 24 90 01 00 	lea    0x190(%rsp),%rsi
  5aa3ef:	00 
  5aa3f0:	e8 3b b5 1d 00       	call   785930 <_RNvNtNtCs6gaF1xUz9Bf_4gpui7runtime5image8describe>
  5aa3f5:	48 8b 84 24 a0 00 00 	mov    0xa0(%rsp),%rax
  5aa3fc:	00 
  5aa3fd:	0f 10 84 24 a8 00 00 	movups 0xa8(%rsp),%xmm0
  5aa404:	00 
  5aa405:	0f 29 84 24 00 03 00 	movaps %xmm0,0x300(%rsp)
  5aa40c:	00 
  5aa40d:	0f 10 84 24 b8 00 00 	movups 0xb8(%rsp),%xmm0
  5aa414:	00 
  5aa415:	0f 29 84 24 10 03 00 	movaps %xmm0,0x310(%rsp)
  5aa41c:	00 
  5aa41d:	0f 10 84 24 c8 00 00 	movups 0xc8(%rsp),%xmm0
  5aa424:	00 
  5aa425:	0f 29 84 24 20 03 00 	movaps %xmm0,0x320(%rsp)
  5aa42c:	00 
  5aa42d:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  5aa431:	0f 85 00 01 00 00    	jne    5aa537 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4e7>
  5aa437:	48 8b 84 24 10 03 00 	mov    0x310(%rsp),%rax
  5aa43e:	00 
  5aa43f:	48 89 84 24 80 04 00 	mov    %rax,0x480(%rsp)
  5aa446:	00 
  5aa447:	0f 28 84 24 00 03 00 	movaps 0x300(%rsp),%xmm0
  5aa44e:	00 
  5aa44f:	0f 29 84 24 70 04 00 	movaps %xmm0,0x470(%rsp)
  5aa456:	00 
  5aa457:	48 8b 84 24 28 03 00 	mov    0x328(%rsp),%rax
  5aa45e:	00 
  5aa45f:	48 89 84 24 30 06 00 	mov    %rax,0x630(%rsp)
  5aa466:	00 
  5aa467:	0f 10 84 24 18 03 00 	movups 0x318(%rsp),%xmm0
  5aa46e:	00 
  5aa46f:	0f 29 84 24 20 06 00 	movaps %xmm0,0x620(%rsp)
  5aa476:	00 
  5aa477:	4a 8d 1c e5 00 00 00 	lea    0x0(,%r12,8),%rbx
  5aa47e:	00 
  5aa47f:	4d 85 e4             	test   %r12,%r12
  5aa482:	0f 84 e8 00 00 00    	je     5aa570 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x520>
  5aa488:	ff 15 12 fc 53 00    	call   *0x53fc12(%rip)        # aea0a0 <_DYNAMIC+0x340>
  5aa48e:	be 08 00 00 00       	mov    $0x8,%esi
  5aa493:	48 89 df             	mov    %rbx,%rdi
  5aa496:	ff 15 04 fb 53 00    	call   *0x53fb04(%rip)        # ae9fa0 <_DYNAMIC+0x240>
  5aa49c:	48 85 c0             	test   %rax,%rax
  5aa49f:	0f 84 45 56 00 00    	je     5afaea <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5a9a>
  5aa4a5:	4c 89 a4 24 e8 02 00 	mov    %r12,0x2e8(%rsp)
  5aa4ac:	00 
  5aa4ad:	48 89 84 24 f0 02 00 	mov    %rax,0x2f0(%rsp)
  5aa4b4:	00 
  5aa4b5:	48 c7 84 24 f8 02 00 	movq   $0x0,0x2f8(%rsp)
  5aa4bc:	00 00 00 00 00 
  5aa4c1:	ff 15 d9 fb 53 00    	call   *0x53fbd9(%rip)        # aea0a0 <_DYNAMIC+0x340>
  5aa4c7:	be 08 00 00 00       	mov    $0x8,%esi
  5aa4cc:	48 89 5c 24 38       	mov    %rbx,0x38(%rsp)
  5aa4d1:	48 89 df             	mov    %rbx,%rdi
  5aa4d4:	ff 15 c6 fa 53 00    	call   *0x53fac6(%rip)        # ae9fa0 <_DYNAMIC+0x240>
  5aa4da:	48 85 c0             	test   %rax,%rax
  5aa4dd:	0f 84 1a 56 00 00    	je     5afafd <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5aad>
  5aa4e3:	4c 89 a4 24 88 02 00 	mov    %r12,0x288(%rsp)
  5aa4ea:	00 
  5aa4eb:	48 89 84 24 90 02 00 	mov    %rax,0x290(%rsp)
  5aa4f2:	00 
  5aa4f3:	48 c7 84 24 98 02 00 	movq   $0x0,0x298(%rsp)
  5aa4fa:	00 00 00 00 00 
  5aa4ff:	4a 8d 1c a5 00 00 00 	lea    0x0(,%r12,4),%rbx
  5aa506:	00 
  5aa507:	ff 15 93 fb 53 00    	call   *0x53fb93(%rip)        # aea0a0 <_DYNAMIC+0x340>
  5aa50d:	be 04 00 00 00       	mov    $0x4,%esi
  5aa512:	48 89 df             	mov    %rbx,%rdi
  5aa515:	ff 15 85 fa 53 00    	call   *0x53fa85(%rip)        # ae9fa0 <_DYNAMIC+0x240>
  5aa51b:	48 85 c0             	test   %rax,%rax
  5aa51e:	0f 85 99 00 00 00    	jne    5aa5bd <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x56d>
  5aa524:	bf 04 00 00 00       	mov    $0x4,%edi
  5aa529:	48 89 de             	mov    %rbx,%rsi
  5aa52c:	ff 15 76 fb 53 00    	call   *0x53fb76(%rip)        # aea0a8 <_DYNAMIC+0x348>
  5aa532:	e9 0f 57 00 00       	jmp    5afc46 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5bf6>
  5aa537:	0f 28 84 24 00 03 00 	movaps 0x300(%rsp),%xmm0
  5aa53e:	00 
  5aa53f:	0f 28 8c 24 10 03 00 	movaps 0x310(%rsp),%xmm1
  5aa546:	00 
  5aa547:	66 0f 6f 94 24 20 03 	movdqa 0x320(%rsp),%xmm2
  5aa54e:	00 00 
  5aa550:	48 8b 8c 24 88 00 00 	mov    0x88(%rsp),%rcx
  5aa557:	00 
  5aa558:	f3 0f 7f 51 28       	movdqu %xmm2,0x28(%rcx)
  5aa55d:	0f 11 49 18          	movups %xmm1,0x18(%rcx)
  5aa561:	0f 11 41 08          	movups %xmm0,0x8(%rcx)
  5aa565:	48 89 01             	mov    %rax,(%rcx)
  5aa568:	45 31 ed             	xor    %r13d,%r13d
  5aa56b:	e9 a7 4f 00 00       	jmp    5af517 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x54c7>
  5aa570:	48 c7 84 24 e8 02 00 	movq   $0x0,0x2e8(%rsp)
  5aa577:	00 00 00 00 00 
  5aa57c:	48 c7 84 24 f0 02 00 	movq   $0x8,0x2f0(%rsp)
  5aa583:	00 08 00 00 00 
  5aa588:	48 c7 84 24 f8 02 00 	movq   $0x0,0x2f8(%rsp)
  5aa58f:	00 00 00 00 00 
  5aa594:	48 c7 84 24 88 02 00 	movq   $0x0,0x288(%rsp)
  5aa59b:	00 00 00 00 00 
  5aa5a0:	48 c7 84 24 90 02 00 	movq   $0x8,0x290(%rsp)
  5aa5a7:	00 08 00 00 00 
  5aa5ac:	48 c7 84 24 98 02 00 	movq   $0x0,0x298(%rsp)
  5aa5b3:	00 00 00 00 00 
  5aa5b8:	b8 04 00 00 00       	mov    $0x4,%eax
  5aa5bd:	4c 89 a4 24 a0 02 00 	mov    %r12,0x2a0(%rsp)
  5aa5c4:	00 
  5aa5c5:	48 89 84 24 a8 02 00 	mov    %rax,0x2a8(%rsp)
  5aa5cc:	00 
  5aa5cd:	48 c7 84 24 b0 02 00 	movq   $0x0,0x2b0(%rsp)
  5aa5d4:	00 00 00 00 00 
  5aa5d9:	4a 8d 1c e5 08 00 00 	lea    0x8(,%r12,8),%rbx
  5aa5e0:	00 
  5aa5e1:	ff 15 b9 fa 53 00    	call   *0x53fab9(%rip)        # aea0a0 <_DYNAMIC+0x340>
  5aa5e7:	be 08 00 00 00       	mov    $0x8,%esi
  5aa5ec:	48 89 9c 24 c8 04 00 	mov    %rbx,0x4c8(%rsp)
  5aa5f3:	00 
  5aa5f4:	48 89 df             	mov    %rbx,%rdi
  5aa5f7:	ff 15 bb f9 53 00    	call   *0x53f9bb(%rip)        # ae9fb8 <_DYNAMIC+0x258>
  5aa5fd:	48 89 84 24 e0 02 00 	mov    %rax,0x2e0(%rsp)
  5aa604:	00 
  5aa605:	48 85 c0             	test   %rax,%rax
  5aa608:	0f 84 59 54 00 00    	je     5afa67 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5a17>
  5aa60e:	49 8d 44 24 01       	lea    0x1(%r12),%rax
  5aa613:	48 89 84 24 88 05 00 	mov    %rax,0x588(%rsp)
  5aa61a:	00 
  5aa61b:	49 69 c4 98 00 00 00 	imul   $0x98,%r12,%rax
  5aa622:	48 89 84 24 10 02 00 	mov    %rax,0x210(%rsp)
  5aa629:	00 
  5aa62a:	48 c7 84 24 30 02 00 	movq   $0x0,0x230(%rsp)
  5aa631:	00 00 00 00 00 
  5aa636:	48 c7 84 24 40 02 00 	movq   $0x0,0x240(%rsp)
  5aa63d:	00 00 00 00 00 
  5aa642:	4d 85 e4             	test   %r12,%r12
  5aa645:	0f 84 de 04 00 00    	je     5aab29 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0xad9>
  5aa64b:	48 8b 84 24 10 02 00 	mov    0x210(%rsp),%rax
  5aa652:	00 
  5aa653:	4c 01 f8             	add    %r15,%rax
  5aa656:	48 89 44 24 60       	mov    %rax,0x60(%rsp)
  5aa65b:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  5aa660:	48 05 50 02 00 00    	add    $0x250,%rax
  5aa666:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  5aa66b:	48 c7 84 24 80 00 00 	movq   $0x0,0x80(%rsp)
  5aa672:	00 00 00 00 00 
  5aa677:	48 8d 05 b2 e4 50 00 	lea    0x50e4b2(%rip),%rax        # ab8b30 <anon.2a25786c1a741fd89e690b6b2ddad436.26.llvm.18021777786862421399+0x1c8>
  5aa67e:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
  5aa683:	41 0f b6 6f 18       	movzbl 0x18(%r15),%ebp
  5aa688:	4c 89 7c 24 40       	mov    %r15,0x40(%rsp)
  5aa68d:	41 8b 5f 1c          	mov    0x1c(%r15),%ebx
  5aa691:	48 8d 43 01          	lea    0x1(%rbx),%rax
  5aa695:	40 84 ed             	test   %bpl,%bpl
  5aa698:	b9 00 00 00 00       	mov    $0x0,%ecx
  5aa69d:	48 0f 45 c8          	cmovne %rax,%rcx
  5aa6a1:	4c 39 e1             	cmp    %r12,%rcx
  5aa6a4:	0f 87 91 53 00 00    	ja     5afa3b <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x59eb>
  5aa6aa:	48 8b 84 24 e0 02 00 	mov    0x2e0(%rsp),%rax
  5aa6b1:	00 
  5aa6b2:	48 ff 04 c8          	incq   (%rax,%rcx,8)
  5aa6b6:	48 8b 84 24 f0 02 00 	mov    0x2f0(%rsp),%rax
  5aa6bd:	00 
  5aa6be:	4c 8b bc 24 f8 02 00 	mov    0x2f8(%rsp),%r15
  5aa6c5:	00 
  5aa6c6:	40 84 ed             	test   %bpl,%bpl
  5aa6c9:	74 29                	je     5aa6f4 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x6a4>
  5aa6cb:	49 39 df             	cmp    %rbx,%r15
  5aa6ce:	0f 86 4a 54 00 00    	jbe    5afb1e <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5ace>
  5aa6d4:	4c 8b 2c d8          	mov    (%rax,%rbx,8),%r13
  5aa6d8:	49 ff c5             	inc    %r13
  5aa6db:	49 81 fd 80 00 00 00 	cmp    $0x80,%r13
  5aa6e2:	0f 87 03 4c 00 00    	ja     5af2eb <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x529b>
  5aa6e8:	4c 3b bc 24 e8 02 00 	cmp    0x2e8(%rsp),%r15
  5aa6ef:	00 
  5aa6f0:	74 0f                	je     5aa701 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x6b1>
  5aa6f2:	eb 23                	jmp    5aa717 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x6c7>
  5aa6f4:	45 31 ed             	xor    %r13d,%r13d
  5aa6f7:	4c 3b bc 24 e8 02 00 	cmp    0x2e8(%rsp),%r15
  5aa6fe:	00 
  5aa6ff:	75 16                	jne    5aa717 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x6c7>
  5aa701:	48 8d bc 24 e8 02 00 	lea    0x2e8(%rsp),%rdi
  5aa708:	00 
  5aa709:	ff 15 99 fa 53 00    	call   *0x53fa99(%rip)        # aea1a8 <_DYNAMIC+0x448>
  5aa70f:	48 8b 84 24 f0 02 00 	mov    0x2f0(%rsp),%rax
  5aa716:	00 
  5aa717:	4e 89 2c f8          	mov    %r13,(%rax,%r15,8)
  5aa71b:	49 ff c7             	inc    %r15
  5aa71e:	4c 89 bc 24 f8 02 00 	mov    %r15,0x2f8(%rsp)
  5aa725:	00 
  5aa726:	45 31 ff             	xor    %r15d,%r15d
  5aa729:	40 84 ed             	test   %bpl,%bpl
  5aa72c:	74 1d                	je     5aa74b <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x6fb>
  5aa72e:	4c 8b bc 24 b0 02 00 	mov    0x2b0(%rsp),%r15
  5aa735:	00 
  5aa736:	49 39 df             	cmp    %rbx,%r15
  5aa739:	0f 86 d3 53 00 00    	jbe    5afb12 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5ac2>
  5aa73f:	48 8b 84 24 a8 02 00 	mov    0x2a8(%rsp),%rax
  5aa746:	00 
  5aa747:	44 8b 3c 98          	mov    (%rax,%rbx,4),%r15d
  5aa74b:	48 8b 44 24 40       	mov    0x40(%rsp),%rax
  5aa750:	48 8b a8 88 00 00 00 	mov    0x88(%rax),%rbp
  5aa757:	48 85 ed             	test   %rbp,%rbp
  5aa75a:	0f 84 9b 00 00 00    	je     5aa7fb <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x7ab>
  5aa760:	48 8b 75 00          	mov    0x0(%rbp),%rsi
  5aa764:	48 85 f6             	test   %rsi,%rsi
  5aa767:	0f 84 b4 4f 00 00    	je     5af721 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x56d1>
  5aa76d:	48 8b 5d 10          	mov    0x10(%rbp),%rbx
  5aa771:	48 8b 45 08          	mov    0x8(%rbp),%rax
  5aa775:	48 8d bc 24 a0 00 00 	lea    0xa0(%rsp),%rdi
  5aa77c:	00 
  5aa77d:	48 8b 54 24 20       	mov    0x20(%rsp),%rdx
  5aa782:	48 8d 0d 57 eb 50 00 	lea    0x50eb57(%rip),%rcx        # ab92e0 <anon.2a25786c1a741fd89e690b6b2ddad436.91.llvm.18021777786862421399+0x4e8>
  5aa789:	4c 8b 44 24 08       	mov    0x8(%rsp),%r8
  5aa78e:	4c 8d 0d 6b eb 50 00 	lea    0x50eb6b(%rip),%r9        # ab9300 <anon.2a25786c1a741fd89e690b6b2ddad436.91.llvm.18021777786862421399+0x508>
  5aa795:	ff 50 18             	call   *0x18(%rax)
  5aa798:	48 8b 84 24 a0 00 00 	mov    0xa0(%rsp),%rax
  5aa79f:	00 
  5aa7a0:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  5aa7a4:	0f 85 07 09 00 00    	jne    5ab0b1 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1061>
  5aa7aa:	48 8b 75 00          	mov    0x0(%rbp),%rsi
  5aa7ae:	48 8b 45 08          	mov    0x8(%rbp),%rax
  5aa7b2:	48 8d bc 24 a0 00 00 	lea    0xa0(%rsp),%rdi
  5aa7b9:	00 
  5aa7ba:	48 8b 54 24 20       	mov    0x20(%rsp),%rdx
  5aa7bf:	48 8d 0d 1a eb 50 00 	lea    0x50eb1a(%rip),%rcx        # ab92e0 <anon.2a25786c1a741fd89e690b6b2ddad436.91.llvm.18021777786862421399+0x4e8>
  5aa7c6:	4c 8b 44 24 08       	mov    0x8(%rsp),%r8
  5aa7cb:	4c 8d 0d 2e eb 50 00 	lea    0x50eb2e(%rip),%r9        # ab9300 <anon.2a25786c1a741fd89e690b6b2ddad436.91.llvm.18021777786862421399+0x508>
  5aa7d2:	ff 50 28             	call   *0x28(%rax)
  5aa7d5:	48 8b 84 24 a0 00 00 	mov    0xa0(%rsp),%rax
  5aa7dc:	00 
  5aa7dd:	44 8b bc 24 a8 00 00 	mov    0xa8(%rsp),%r15d
  5aa7e4:	00 
  5aa7e5:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  5aa7e9:	0f 85 fb 08 00 00    	jne    5ab0ea <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x109a>
  5aa7ef:	48 89 dd             	mov    %rbx,%rbp
  5aa7f2:	48 85 db             	test   %rbx,%rbx
  5aa7f5:	0f 85 65 ff ff ff    	jne    5aa760 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x710>
  5aa7fb:	48 8b 9c 24 b0 02 00 	mov    0x2b0(%rsp),%rbx
  5aa802:	00 
  5aa803:	48 3b 9c 24 a0 02 00 	cmp    0x2a0(%rsp),%rbx
  5aa80a:	00 
  5aa80b:	75 0e                	jne    5aa81b <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x7cb>
  5aa80d:	48 8d bc 24 a0 02 00 	lea    0x2a0(%rsp),%rdi
  5aa814:	00 
  5aa815:	ff 15 95 f9 53 00    	call   *0x53f995(%rip)        # aea1b0 <_DYNAMIC+0x450>
  5aa81b:	48 8b 84 24 a8 02 00 	mov    0x2a8(%rsp),%rax
  5aa822:	00 
  5aa823:	44 89 3c 98          	mov    %r15d,(%rax,%rbx,4)
  5aa827:	48 ff c3             	inc    %rbx
  5aa82a:	48 89 9c 24 b0 02 00 	mov    %rbx,0x2b0(%rsp)
  5aa831:	00 
  5aa832:	48 8b 54 24 40       	mov    0x40(%rsp),%rdx
  5aa837:	48 8b 72 78          	mov    0x78(%rdx),%rsi
  5aa83b:	48 85 f6             	test   %rsi,%rsi
  5aa83e:	74 41                	je     5aa881 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x831>
  5aa840:	48 8b 82 80 00 00 00 	mov    0x80(%rdx),%rax
  5aa847:	48 8d bc 24 a0 00 00 	lea    0xa0(%rsp),%rdi
  5aa84e:	00 
  5aa84f:	48 8b 54 24 20       	mov    0x20(%rsp),%rdx
  5aa854:	48 8d 0d 85 ea 50 00 	lea    0x50ea85(%rip),%rcx        # ab92e0 <anon.2a25786c1a741fd89e690b6b2ddad436.91.llvm.18021777786862421399+0x4e8>
  5aa85b:	4c 8b 44 24 08       	mov    0x8(%rsp),%r8
  5aa860:	4c 8d 0d 99 ea 50 00 	lea    0x50ea99(%rip),%r9        # ab9300 <anon.2a25786c1a741fd89e690b6b2ddad436.91.llvm.18021777786862421399+0x508>
  5aa867:	ff 50 18             	call   *0x18(%rax)
  5aa86a:	48 8b 84 24 a0 00 00 	mov    0xa0(%rsp),%rax
  5aa871:	00 
  5aa872:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  5aa876:	0f 85 35 08 00 00    	jne    5ab0b1 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1061>
  5aa87c:	48 8b 54 24 40       	mov    0x40(%rsp),%rdx
  5aa881:	48 8b 1a             	mov    (%rdx),%rbx
  5aa884:	48 83 fb ff          	cmp    $0xffffffffffffffff,%rbx
  5aa888:	74 52                	je     5aa8dc <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x88c>
  5aa88a:	48 b8 01 00 00 00 00 	movabs $0x8000000000000001,%rax
  5aa891:	00 00 80 
  5aa894:	48 ff c0             	inc    %rax
  5aa897:	48 39 c3             	cmp    %rax,%rbx
  5aa89a:	75 4a                	jne    5aa8e6 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x896>
  5aa89c:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  5aa8a0:	4c 8b 42 10          	mov    0x10(%rdx),%r8
  5aa8a4:	48 8d bc 24 a0 00 00 	lea    0xa0(%rsp),%rdi
  5aa8ab:	00 
  5aa8ac:	48 8b 74 24 08       	mov    0x8(%rsp),%rsi
  5aa8b1:	48 8b 54 24 20       	mov    0x20(%rsp),%rdx
  5aa8b6:	e8 85 8f 13 00       	call   6e3840 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui6sourceINtB5_7SourcesNtNtNtB7_7runtime12style_ledger9AdversaryE7resolveB7_>
  5aa8bb:	48 8b 84 24 a0 00 00 	mov    0xa0(%rsp),%rax
  5aa8c2:	00 
  5aa8c3:	4c 8b bc 24 a8 00 00 	mov    0xa8(%rsp),%r15
  5aa8ca:	00 
  5aa8cb:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  5aa8cf:	0f 85 13 4e 00 00    	jne    5af6e8 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5698>
  5aa8d5:	4d 85 ff             	test   %r15,%r15
  5aa8d8:	74 14                	je     5aa8ee <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x89e>
  5aa8da:	eb 24                	jmp    5aa900 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x8b0>
  5aa8dc:	45 31 ff             	xor    %r15d,%r15d
  5aa8df:	4d 85 ff             	test   %r15,%r15
  5aa8e2:	74 0a                	je     5aa8ee <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x89e>
  5aa8e4:	eb 1a                	jmp    5aa900 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x8b0>
  5aa8e6:	45 31 ff             	xor    %r15d,%r15d
  5aa8e9:	4d 85 ff             	test   %r15,%r15
  5aa8ec:	75 12                	jne    5aa900 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x8b0>
  5aa8ee:	48 8b 44 24 40       	mov    0x40(%rsp),%rax
  5aa8f3:	80 b8 90 00 00 00 02 	cmpb   $0x2,0x90(%rax)
  5aa8fa:	0f 84 da 49 00 00    	je     5af2da <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x528a>
  5aa900:	4d 85 ff             	test   %r15,%r15
  5aa903:	0f 84 b8 01 00 00    	je     5aaac1 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0xa71>
  5aa909:	48 83 fb ff          	cmp    $0xffffffffffffffff,%rbx
  5aa90d:	0f 84 55 3e 00 00    	je     5ae768 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4718>
  5aa913:	48 b8 01 00 00 00 00 	movabs $0x8000000000000001,%rax
  5aa91a:	00 00 80 
  5aa91d:	48 ff c0             	inc    %rax
  5aa920:	48 8b 4c 24 40       	mov    0x40(%rsp),%rcx
  5aa925:	48 39 01             	cmp    %rax,(%rcx)
  5aa928:	0f 85 3a 3e 00 00    	jne    5ae768 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4718>
  5aa92e:	48 8b 44 24 40       	mov    0x40(%rsp),%rax
  5aa933:	48 8b 78 08          	mov    0x8(%rax),%rdi
  5aa937:	48 8b 40 10          	mov    0x10(%rax),%rax
  5aa93b:	ff 50 30             	call   *0x30(%rax)
  5aa93e:	48 85 c0             	test   %rax,%rax
  5aa941:	0f 84 21 3e 00 00    	je     5ae768 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4718>
  5aa947:	48 8b 9c 24 30 02 00 	mov    0x230(%rsp),%rbx
  5aa94e:	00 
  5aa94f:	48 85 db             	test   %rbx,%rbx
  5aa952:	0f 84 84 00 00 00    	je     5aa9dc <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x98c>
  5aa958:	48 8b 8c 24 38 02 00 	mov    0x238(%rsp),%rcx
  5aa95f:	00 
  5aa960:	0f b7 b3 1a 02 00 00 	movzwl 0x21a(%rbx),%esi
  5aa967:	8d 3c f5 00 00 00 00 	lea    0x0(,%rsi,8),%edi
  5aa96e:	4c 8d 04 bf          	lea    (%rdi,%rdi,4),%r8
  5aa972:	49 c7 c6 ff ff ff ff 	mov    $0xffffffffffffffff,%r14
  5aa979:	31 ff                	xor    %edi,%edi
  5aa97b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
  5aa980:	4d 89 c1             	mov    %r8,%r9
  5aa983:	49 01 f9             	add    %rdi,%r9
  5aa986:	74 24                	je     5aa9ac <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x95c>
  5aa988:	4e 3b 7c f3 10       	cmp    0x10(%rbx,%r14,8),%r15
  5aa98d:	41 0f 97 c1          	seta   %r9b
  5aa991:	41 80 d9 00          	sbb    $0x0,%r9b
  5aa995:	48 83 c7 d8          	add    $0xffffffffffffffd8,%rdi
  5aa999:	49 ff c6             	inc    %r14
  5aa99c:	41 80 f9 01          	cmp    $0x1,%r9b
  5aa9a0:	74 de                	je     5aa980 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x930>
  5aa9a2:	41 0f b6 f1          	movzbl %r9b,%esi
  5aa9a6:	85 f6                	test   %esi,%esi
  5aa9a8:	75 05                	jne    5aa9af <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x95f>
  5aa9aa:	eb 17                	jmp    5aa9c3 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x973>
  5aa9ac:	49 89 f6             	mov    %rsi,%r14
  5aa9af:	48 83 e9 01          	sub    $0x1,%rcx
  5aa9b3:	0f 82 62 01 00 00    	jb     5aab1b <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0xacb>
  5aa9b9:	4a 8b 9c f3 20 02 00 	mov    0x220(%rbx,%r14,8),%rbx
  5aa9c0:	00 
  5aa9c1:	eb 9d                	jmp    5aa960 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x910>
  5aa9c3:	48 29 fb             	sub    %rdi,%rbx
  5aa9c6:	48 83 c3 38          	add    $0x38,%rbx
  5aa9ca:	4c 89 74 24 50       	mov    %r14,0x50(%rsp)
  5aa9cf:	4c 8d b4 24 30 02 00 	lea    0x230(%rsp),%r14
  5aa9d6:	00 
  5aa9d7:	e9 a4 00 00 00       	jmp    5aaa80 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0xa30>
  5aa9dc:	31 db                	xor    %ebx,%ebx
  5aa9de:	4c 89 bc 24 00 03 00 	mov    %r15,0x300(%rsp)
  5aa9e5:	00 
  5aa9e6:	48 8d 8c 24 30 02 00 	lea    0x230(%rsp),%rcx
  5aa9ed:	00 
  5aa9ee:	48 89 8c 24 08 03 00 	mov    %rcx,0x308(%rsp)
  5aa9f5:	00 
  5aa9f6:	48 89 9c 24 10 03 00 	mov    %rbx,0x310(%rsp)
  5aa9fd:	00 
  5aa9fe:	48 8b 4c 24 50       	mov    0x50(%rsp),%rcx
  5aaa03:	48 89 8c 24 18 03 00 	mov    %rcx,0x318(%rsp)
  5aaa0a:	00 
  5aaa0b:	4c 89 b4 24 20 03 00 	mov    %r14,0x320(%rsp)
  5aaa12:	00 
  5aaa13:	48 89 84 24 b8 00 00 	mov    %rax,0xb8(%rsp)
  5aaa1a:	00 
  5aaa1b:	48 89 94 24 c0 00 00 	mov    %rdx,0xc0(%rsp)
  5aaa22:	00 
  5aaa23:	48 c7 84 24 a0 00 00 	movq   $0x0,0xa0(%rsp)
  5aaa2a:	00 00 00 00 00 
  5aaa2f:	48 c7 84 24 a8 00 00 	movq   $0x4,0xa8(%rsp)
  5aaa36:	00 04 00 00 00 
  5aaa3b:	48 c7 84 24 b0 00 00 	movq   $0x0,0xb0(%rsp)
  5aaa42:	00 00 00 00 00 
  5aaa47:	48 8d bc 24 90 01 00 	lea    0x190(%rsp),%rdi
  5aaa4e:	00 
  5aaa4f:	48 8d b4 24 00 03 00 	lea    0x300(%rsp),%rsi
  5aaa56:	00 
  5aaa57:	48 8d 94 24 a0 00 00 	lea    0xa0(%rsp),%rdx
  5aaa5e:	00 
  5aaa5f:	e8 ec de 1c 00       	call   778950 <_RNvMs4_NtNtNtNtCscdodAO9FK5_5alloc11collections5btree3map5entryINtB5_11VacantEntryNtNtCs6gaF1xUz9Bf_4gpui6source7FieldIdNtNtB1m_7runtime6FanoutE12insert_entryB1m_.llvm.12454362996328431623>
  5aaa64:	48 8b 84 24 90 01 00 	mov    0x190(%rsp),%rax
  5aaa6b:	00 
  5aaa6c:	48 8b 8c 24 a0 01 00 	mov    0x1a0(%rsp),%rcx
  5aaa73:	00 
  5aaa74:	48 8d 0c 89          	lea    (%rcx,%rcx,4),%rcx
  5aaa78:	48 8d 1c c8          	lea    (%rax,%rcx,8),%rbx
  5aaa7c:	48 83 c3 60          	add    $0x60,%rbx
  5aaa80:	48 81 bc 24 80 00 00 	cmpq   $0x186a0,0x80(%rsp)
  5aaa87:	00 a0 86 01 00 
  5aaa8c:	0f 83 f4 4d 00 00    	jae    5af886 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5836>
  5aaa92:	4c 8b 6b 10          	mov    0x10(%rbx),%r13
  5aaa96:	4c 3b 2b             	cmp    (%rbx),%r13
  5aaa99:	75 08                	jne    5aaaa3 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0xa53>
  5aaa9b:	48 89 df             	mov    %rbx,%rdi
  5aaa9e:	e8 2d 31 22 00       	call   7cdbd0 <_RNvMs3_NtCscdodAO9FK5_5alloc7raw_vecINtB5_6RawVecNtNtCs6gaF1xUz9Bf_4gpui7runtime6ParentE8grow_oneBP_>
  5aaaa3:	48 8b 84 24 80 00 00 	mov    0x80(%rsp),%rax
  5aaaaa:	00 
  5aaaab:	8d 04 85 00 00 00 00 	lea    0x0(,%rax,4),%eax
  5aaab2:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  5aaab6:	42 89 04 a9          	mov    %eax,(%rcx,%r13,4)
  5aaaba:	49 ff c5             	inc    %r13
  5aaabd:	4c 89 6b 10          	mov    %r13,0x10(%rbx)
  5aaac1:	48 8b 9c 24 98 02 00 	mov    0x298(%rsp),%rbx
  5aaac8:	00 
  5aaac9:	48 3b 9c 24 88 02 00 	cmp    0x288(%rsp),%rbx
  5aaad0:	00 
  5aaad1:	75 0d                	jne    5aaae0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0xa90>
  5aaad3:	48 8d bc 24 88 02 00 	lea    0x288(%rsp),%rdi
  5aaada:	00 
  5aaadb:	e8 40 2b 22 00       	call   7cd620 <_RNvMs3_NtCscdodAO9FK5_5alloc7raw_vecINtB5_6RawVecINtNtCs4NRVxsYgnAr_4core6option6OptionNtNtCs6gaF1xUz9Bf_4gpui6source7FieldIdEE8grow_oneB1r_>
  5aaae0:	48 8b 4c 24 40       	mov    0x40(%rsp),%rcx
  5aaae5:	48 81 c1 98 00 00 00 	add    $0x98,%rcx
  5aaaec:	48 ff 84 24 80 00 00 	incq   0x80(%rsp)
  5aaaf3:	00 
  5aaaf4:	48 8b 84 24 90 02 00 	mov    0x290(%rsp),%rax
  5aaafb:	00 
  5aaafc:	4c 89 3c d8          	mov    %r15,(%rax,%rbx,8)
  5aab00:	49 89 cf             	mov    %rcx,%r15
  5aab03:	48 ff c3             	inc    %rbx
  5aab06:	48 89 9c 24 98 02 00 	mov    %rbx,0x298(%rsp)
  5aab0d:	00 
  5aab0e:	48 3b 4c 24 60       	cmp    0x60(%rsp),%rcx
  5aab13:	0f 85 6a fb ff ff    	jne    5aa683 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x633>
  5aab19:	eb 0e                	jmp    5aab29 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0xad9>
  5aab1b:	48 c7 44 24 50 00 00 	movq   $0x0,0x50(%rsp)
  5aab22:	00 00 
  5aab24:	e9 b5 fe ff ff       	jmp    5aa9de <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x98e>
  5aab29:	4c 8b b4 24 50 04 00 	mov    0x450(%rsp),%r14
  5aab30:	00 
  5aab31:	4d 85 f6             	test   %r14,%r14
  5aab34:	0f 84 f0 05 00 00    	je     5ab12a <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x10da>
  5aab3a:	4c 89 f3             	mov    %r14,%rbx
  5aab3d:	48 c1 e3 04          	shl    $0x4,%rbx
  5aab41:	ff 15 59 f5 53 00    	call   *0x53f559(%rip)        # aea0a0 <_DYNAMIC+0x340>
  5aab47:	be 08 00 00 00       	mov    $0x8,%esi
  5aab4c:	48 89 df             	mov    %rbx,%rdi
  5aab4f:	ff 15 4b f4 53 00    	call   *0x53f44b(%rip)        # ae9fa0 <_DYNAMIC+0x240>
  5aab55:	48 85 c0             	test   %rax,%rax
  5aab58:	0f 84 2d 50 00 00    	je     5afb8b <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5b3b>
  5aab5e:	4c 89 b4 24 b8 02 00 	mov    %r14,0x2b8(%rsp)
  5aab65:	00 
  5aab66:	48 89 84 24 c0 02 00 	mov    %rax,0x2c0(%rsp)
  5aab6d:	00 
  5aab6e:	48 c7 84 24 c8 02 00 	movq   $0x0,0x2c8(%rsp)
  5aab75:	00 00 00 00 00 
  5aab7a:	4c 8b ac 24 48 04 00 	mov    0x448(%rsp),%r13
  5aab81:	00 
  5aab82:	49 6b c6 38          	imul   $0x38,%r14,%rax
  5aab86:	4c 01 e8             	add    %r13,%rax
  5aab89:	48 89 84 24 80 00 00 	mov    %rax,0x80(%rsp)
  5aab90:	00 
  5aab91:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  5aab96:	48 05 50 02 00 00    	add    $0x250,%rax
  5aab9c:	48 89 44 24 60       	mov    %rax,0x60(%rsp)
  5aaba1:	48 b8 01 00 00 00 00 	movabs $0x8000000000000001,%rax
  5aaba8:	00 00 80 
  5aabab:	48 ff c0             	inc    %rax
  5aabae:	48 89 44 24 40       	mov    %rax,0x40(%rsp)
  5aabb3:	eb 45                	jmp    5aabfa <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0xbaa>
  5aabb5:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
  5aabbc:	00 00 00 00 
  5aabc0:	49 83 c5 38          	add    $0x38,%r13
  5aabc4:	48 8b 84 24 c0 02 00 	mov    0x2c0(%rsp),%rax
  5aabcb:	00 
  5aabcc:	48 89 e9             	mov    %rbp,%rcx
  5aabcf:	48 c1 e1 04          	shl    $0x4,%rcx
  5aabd3:	48 8b 54 24 08       	mov    0x8(%rsp),%rdx
  5aabd8:	48 89 14 08          	mov    %rdx,(%rax,%rcx,1)
  5aabdc:	4c 89 7c 08 08       	mov    %r15,0x8(%rax,%rcx,1)
  5aabe1:	48 ff c5             	inc    %rbp
  5aabe4:	48 89 ac 24 c8 02 00 	mov    %rbp,0x2c8(%rsp)
  5aabeb:	00 
  5aabec:	4c 3b ac 24 80 00 00 	cmp    0x80(%rsp),%r13
  5aabf3:	00 
  5aabf4:	0f 84 54 05 00 00    	je     5ab14e <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x10fe>
  5aabfa:	49 8b 45 00          	mov    0x0(%r13),%rax
  5aabfe:	49 8b 4d 18          	mov    0x18(%r13),%rcx
  5aac02:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  5aac06:	0f 84 04 01 00 00    	je     5aad10 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0xcc0>
  5aac0c:	48 3b 44 24 40       	cmp    0x40(%rsp),%rax
  5aac11:	0f 85 f9 00 00 00    	jne    5aad10 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0xcc0>
  5aac17:	48 89 4c 24 18       	mov    %rcx,0x18(%rsp)
  5aac1c:	49 8b 4d 08          	mov    0x8(%r13),%rcx
  5aac20:	4d 8b 45 10          	mov    0x10(%r13),%r8
  5aac24:	48 8d bc 24 a0 00 00 	lea    0xa0(%rsp),%rdi
  5aac2b:	00 
  5aac2c:	48 8b 74 24 60       	mov    0x60(%rsp),%rsi
  5aac31:	48 8b 54 24 20       	mov    0x20(%rsp),%rdx
  5aac36:	e8 05 8c 13 00       	call   6e3840 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui6sourceINtB5_7SourcesNtNtNtB7_7runtime12style_ledger9AdversaryE7resolveB7_>
  5aac3b:	48 8b 84 24 a0 00 00 	mov    0xa0(%rsp),%rax
  5aac42:	00 
  5aac43:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  5aac47:	0f 85 ac 12 00 00    	jne    5abef9 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1ea9>
  5aac4d:	48 8b 8c 24 a8 00 00 	mov    0xa8(%rsp),%rcx
  5aac54:	00 
  5aac55:	48 89 4c 24 08       	mov    %rcx,0x8(%rsp)
  5aac5a:	48 85 c9             	test   %rcx,%rcx
  5aac5d:	0f 84 c5 00 00 00    	je     5aad28 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0xcd8>
  5aac63:	48 8b 44 24 40       	mov    0x40(%rsp),%rax
  5aac68:	49 39 45 00          	cmp    %rax,0x0(%r13)
  5aac6c:	0f 85 98 3a 00 00    	jne    5ae70a <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x46ba>
  5aac72:	49 8b 7d 08          	mov    0x8(%r13),%rdi
  5aac76:	49 8b 45 10          	mov    0x10(%r13),%rax
  5aac7a:	ff 50 30             	call   *0x30(%rax)
  5aac7d:	48 85 c0             	test   %rax,%rax
  5aac80:	0f 84 84 3a 00 00    	je     5ae70a <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x46ba>
  5aac86:	48 8b ac 24 30 02 00 	mov    0x230(%rsp),%rbp
  5aac8d:	00 
  5aac8e:	48 85 ed             	test   %rbp,%rbp
  5aac91:	0f 84 c7 00 00 00    	je     5aad5e <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0xd0e>
  5aac97:	48 8b 8c 24 38 02 00 	mov    0x238(%rsp),%rcx
  5aac9e:	00 
  5aac9f:	0f b7 b5 1a 02 00 00 	movzwl 0x21a(%rbp),%esi
  5aaca6:	8d 3c f5 00 00 00 00 	lea    0x0(,%rsi,8),%edi
  5aacad:	4c 8d 04 bf          	lea    (%rdi,%rdi,4),%r8
  5aacb1:	48 c7 c3 ff ff ff ff 	mov    $0xffffffffffffffff,%rbx
  5aacb8:	31 ff                	xor    %edi,%edi
  5aacba:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
  5aacc0:	4d 89 c1             	mov    %r8,%r9
  5aacc3:	49 01 f9             	add    %rdi,%r9
  5aacc6:	74 29                	je     5aacf1 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0xca1>
  5aacc8:	4c 8b 4c 24 08       	mov    0x8(%rsp),%r9
  5aaccd:	4c 3b 4c dd 10       	cmp    0x10(%rbp,%rbx,8),%r9
  5aacd2:	41 0f 97 c1          	seta   %r9b
  5aacd6:	41 80 d9 00          	sbb    $0x0,%r9b
  5aacda:	48 83 c7 d8          	add    $0xffffffffffffffd8,%rdi
  5aacde:	48 ff c3             	inc    %rbx
  5aace1:	41 80 f9 01          	cmp    $0x1,%r9b
  5aace5:	74 d9                	je     5aacc0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0xc70>
  5aace7:	41 0f b6 f1          	movzbl %r9b,%esi
  5aaceb:	85 f6                	test   %esi,%esi
  5aaced:	75 05                	jne    5aacf4 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0xca4>
  5aacef:	eb 54                	jmp    5aad45 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0xcf5>
  5aacf1:	48 89 f3             	mov    %rsi,%rbx
  5aacf4:	48 83 e9 01          	sub    $0x1,%rcx
  5aacf8:	0f 82 97 03 00 00    	jb     5ab095 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1045>
  5aacfe:	48 8b ac dd 20 02 00 	mov    0x220(%rbp,%rbx,8),%rbp
  5aad05:	00 
  5aad06:	eb 97                	jmp    5aac9f <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0xc4f>
  5aad08:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  5aad0f:	00 
  5aad10:	48 c7 44 24 08 00 00 	movq   $0x0,0x8(%rsp)
  5aad17:	00 00 
  5aad19:	48 83 f9 ff          	cmp    $0xffffffffffffffff,%rcx
  5aad1d:	0f 85 2d 01 00 00    	jne    5aae50 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0xe00>
  5aad23:	e9 28 02 00 00       	jmp    5aaf50 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0xf00>
  5aad28:	48 c7 44 24 08 00 00 	movq   $0x0,0x8(%rsp)
  5aad2f:	00 00 
  5aad31:	48 8b 4c 24 18       	mov    0x18(%rsp),%rcx
  5aad36:	48 83 f9 ff          	cmp    $0xffffffffffffffff,%rcx
  5aad3a:	0f 85 10 01 00 00    	jne    5aae50 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0xe00>
  5aad40:	e9 0b 02 00 00       	jmp    5aaf50 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0xf00>
  5aad45:	48 29 fd             	sub    %rdi,%rbp
  5aad48:	48 83 c5 38          	add    $0x38,%rbp
  5aad4c:	48 89 5c 24 50       	mov    %rbx,0x50(%rsp)
  5aad51:	48 8d 9c 24 30 02 00 	lea    0x230(%rsp),%rbx
  5aad58:	00 
  5aad59:	e9 a9 00 00 00       	jmp    5aae07 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0xdb7>
  5aad5e:	31 ed                	xor    %ebp,%ebp
  5aad60:	48 8b 4c 24 08       	mov    0x8(%rsp),%rcx
  5aad65:	48 89 8c 24 00 03 00 	mov    %rcx,0x300(%rsp)
  5aad6c:	00 
  5aad6d:	48 8d 8c 24 30 02 00 	lea    0x230(%rsp),%rcx
  5aad74:	00 
  5aad75:	48 89 8c 24 08 03 00 	mov    %rcx,0x308(%rsp)
  5aad7c:	00 
  5aad7d:	48 89 ac 24 10 03 00 	mov    %rbp,0x310(%rsp)
  5aad84:	00 
  5aad85:	48 8b 4c 24 50       	mov    0x50(%rsp),%rcx
  5aad8a:	48 89 8c 24 18 03 00 	mov    %rcx,0x318(%rsp)
  5aad91:	00 
  5aad92:	48 89 9c 24 20 03 00 	mov    %rbx,0x320(%rsp)
  5aad99:	00 
  5aad9a:	48 89 84 24 b8 00 00 	mov    %rax,0xb8(%rsp)
  5aada1:	00 
  5aada2:	48 89 94 24 c0 00 00 	mov    %rdx,0xc0(%rsp)
  5aada9:	00 
  5aadaa:	48 c7 84 24 a0 00 00 	movq   $0x0,0xa0(%rsp)
  5aadb1:	00 00 00 00 00 
  5aadb6:	48 c7 84 24 a8 00 00 	movq   $0x4,0xa8(%rsp)
  5aadbd:	00 04 00 00 00 
  5aadc2:	48 c7 84 24 b0 00 00 	movq   $0x0,0xb0(%rsp)
  5aadc9:	00 00 00 00 00 
  5aadce:	48 8d bc 24 90 01 00 	lea    0x190(%rsp),%rdi
  5aadd5:	00 
  5aadd6:	48 8d b4 24 00 03 00 	lea    0x300(%rsp),%rsi
  5aaddd:	00 
  5aadde:	48 8d 94 24 a0 00 00 	lea    0xa0(%rsp),%rdx
  5aade5:	00 
  5aade6:	e8 65 db 1c 00       	call   778950 <_RNvMs4_NtNtNtNtCscdodAO9FK5_5alloc11collections5btree3map5entryINtB5_11VacantEntryNtNtCs6gaF1xUz9Bf_4gpui6source7FieldIdNtNtB1m_7runtime6FanoutE12insert_entryB1m_.llvm.12454362996328431623>
  5aadeb:	48 8b 84 24 90 01 00 	mov    0x190(%rsp),%rax
  5aadf2:	00 
  5aadf3:	48 8b 8c 24 a0 01 00 	mov    0x1a0(%rsp),%rcx
  5aadfa:	00 
  5aadfb:	48 8d 0c 89          	lea    (%rcx,%rcx,4),%rcx
  5aadff:	48 8d 2c c8          	lea    (%rax,%rcx,8),%rbp
  5aae03:	48 83 c5 60          	add    $0x60,%rbp
  5aae07:	45 8b 7d 30          	mov    0x30(%r13),%r15d
  5aae0b:	41 81 ff 9f 86 01 00 	cmp    $0x1869f,%r15d
  5aae12:	0f 87 b0 49 00 00    	ja     5af7c8 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5778>
  5aae18:	4c 8b 75 10          	mov    0x10(%rbp),%r14
  5aae1c:	4c 3b 75 00          	cmp    0x0(%rbp),%r14
  5aae20:	75 08                	jne    5aae2a <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0xdda>
  5aae22:	48 89 ef             	mov    %rbp,%rdi
  5aae25:	e8 a6 2d 22 00       	call   7cdbd0 <_RNvMs3_NtCscdodAO9FK5_5alloc7raw_vecINtB5_6RawVecNtNtCs6gaF1xUz9Bf_4gpui7runtime6ParentE8grow_oneBP_>
  5aae2a:	42 8d 04 bd 01 00 00 	lea    0x1(,%r15,4),%eax
  5aae31:	00 
  5aae32:	48 8b 4d 08          	mov    0x8(%rbp),%rcx
  5aae36:	42 89 04 b1          	mov    %eax,(%rcx,%r14,4)
  5aae3a:	49 ff c6             	inc    %r14
  5aae3d:	4c 89 75 10          	mov    %r14,0x10(%rbp)
  5aae41:	48 8b 4c 24 18       	mov    0x18(%rsp),%rcx
  5aae46:	48 83 f9 ff          	cmp    $0xffffffffffffffff,%rcx
  5aae4a:	0f 84 00 01 00 00    	je     5aaf50 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0xf00>
  5aae50:	48 8b 44 24 40       	mov    0x40(%rsp),%rax
  5aae55:	49 39 45 18          	cmp    %rax,0x18(%r13)
  5aae59:	0f 85 f1 00 00 00    	jne    5aaf50 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0xf00>
  5aae5f:	49 8b 4d 20          	mov    0x20(%r13),%rcx
  5aae63:	4d 8b 45 28          	mov    0x28(%r13),%r8
  5aae67:	48 8d bc 24 a0 00 00 	lea    0xa0(%rsp),%rdi
  5aae6e:	00 
  5aae6f:	48 8b 74 24 60       	mov    0x60(%rsp),%rsi
  5aae74:	48 8b 54 24 20       	mov    0x20(%rsp),%rdx
  5aae79:	e8 c2 89 13 00       	call   6e3840 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui6sourceINtB5_7SourcesNtNtNtB7_7runtime12style_ledger9AdversaryE7resolveB7_>
  5aae7e:	48 8b 84 24 a0 00 00 	mov    0xa0(%rsp),%rax
  5aae85:	00 
  5aae86:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  5aae8a:	0f 85 69 10 00 00    	jne    5abef9 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1ea9>
  5aae90:	4c 8b bc 24 a8 00 00 	mov    0xa8(%rsp),%r15
  5aae97:	00 
  5aae98:	4d 85 ff             	test   %r15,%r15
  5aae9b:	0f 84 af 00 00 00    	je     5aaf50 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0xf00>
  5aaea1:	48 8b 44 24 40       	mov    0x40(%rsp),%rax
  5aaea6:	49 39 45 18          	cmp    %rax,0x18(%r13)
  5aaeaa:	0f 85 5f 38 00 00    	jne    5ae70f <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x46bf>
  5aaeb0:	49 8b 7d 20          	mov    0x20(%r13),%rdi
  5aaeb4:	49 8b 45 28          	mov    0x28(%r13),%rax
  5aaeb8:	ff 50 30             	call   *0x30(%rax)
  5aaebb:	48 85 c0             	test   %rax,%rax
  5aaebe:	0f 84 4b 38 00 00    	je     5ae70f <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x46bf>
  5aaec4:	48 8b ac 24 30 02 00 	mov    0x230(%rsp),%rbp
  5aaecb:	00 
  5aaecc:	48 85 ed             	test   %rbp,%rbp
  5aaecf:	0f 84 bf 00 00 00    	je     5aaf94 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0xf44>
  5aaed5:	48 8b 8c 24 38 02 00 	mov    0x238(%rsp),%rcx
  5aaedc:	00 
  5aaedd:	0f b7 b5 1a 02 00 00 	movzwl 0x21a(%rbp),%esi
  5aaee4:	8d 3c f5 00 00 00 00 	lea    0x0(,%rsi,8),%edi
  5aaeeb:	4c 8d 04 bf          	lea    (%rdi,%rdi,4),%r8
  5aaeef:	48 c7 c3 ff ff ff ff 	mov    $0xffffffffffffffff,%rbx
  5aaef6:	31 ff                	xor    %edi,%edi
  5aaef8:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  5aaeff:	00 
  5aaf00:	4d 89 c1             	mov    %r8,%r9
  5aaf03:	49 01 f9             	add    %rdi,%r9
  5aaf06:	74 24                	je     5aaf2c <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0xedc>
  5aaf08:	4c 3b 7c dd 10       	cmp    0x10(%rbp,%rbx,8),%r15
  5aaf0d:	41 0f 97 c1          	seta   %r9b
  5aaf11:	41 80 d9 00          	sbb    $0x0,%r9b
  5aaf15:	48 83 c7 d8          	add    $0xffffffffffffffd8,%rdi
  5aaf19:	48 ff c3             	inc    %rbx
  5aaf1c:	41 80 f9 01          	cmp    $0x1,%r9b
  5aaf20:	74 de                	je     5aaf00 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0xeb0>
  5aaf22:	41 0f b6 f1          	movzbl %r9b,%esi
  5aaf26:	85 f6                	test   %esi,%esi
  5aaf28:	75 05                	jne    5aaf2f <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0xedf>
  5aaf2a:	eb 4f                	jmp    5aaf7b <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0xf2b>
  5aaf2c:	48 89 f3             	mov    %rsi,%rbx
  5aaf2f:	48 83 e9 01          	sub    $0x1,%rcx
  5aaf33:	0f 82 6a 01 00 00    	jb     5ab0a3 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1053>
  5aaf39:	48 8b ac dd 20 02 00 	mov    0x220(%rbp,%rbx,8),%rbp
  5aaf40:	00 
  5aaf41:	eb 9a                	jmp    5aaedd <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0xe8d>
  5aaf43:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  5aaf4a:	84 00 00 00 00 00 
  5aaf50:	45 31 ff             	xor    %r15d,%r15d
  5aaf53:	48 8b ac 24 c8 02 00 	mov    0x2c8(%rsp),%rbp
  5aaf5a:	00 
  5aaf5b:	48 3b ac 24 b8 02 00 	cmp    0x2b8(%rsp),%rbp
  5aaf62:	00 
  5aaf63:	0f 85 57 fc ff ff    	jne    5aabc0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0xb70>
  5aaf69:	48 8d bc 24 b8 02 00 	lea    0x2b8(%rsp),%rdi
  5aaf70:	00 
  5aaf71:	e8 3a 26 22 00       	call   7cd5b0 <_RNvMs3_NtCscdodAO9FK5_5alloc7raw_vecINtB5_6RawVecAINtNtCs4NRVxsYgnAr_4core6option6OptionNtNtCs6gaF1xUz9Bf_4gpui6source7FieldIdEj2_E8grow_oneB1s_>
  5aaf76:	e9 45 fc ff ff       	jmp    5aabc0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0xb70>
  5aaf7b:	48 29 fd             	sub    %rdi,%rbp
  5aaf7e:	48 83 c5 38          	add    $0x38,%rbp
  5aaf82:	48 89 5c 24 50       	mov    %rbx,0x50(%rsp)
  5aaf87:	48 8d 9c 24 30 02 00 	lea    0x230(%rsp),%rbx
  5aaf8e:	00 
  5aaf8f:	e9 a4 00 00 00       	jmp    5ab038 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0xfe8>
  5aaf94:	31 ed                	xor    %ebp,%ebp
  5aaf96:	4c 89 bc 24 00 03 00 	mov    %r15,0x300(%rsp)
  5aaf9d:	00 
  5aaf9e:	48 8d 8c 24 30 02 00 	lea    0x230(%rsp),%rcx
  5aafa5:	00 
  5aafa6:	48 89 8c 24 08 03 00 	mov    %rcx,0x308(%rsp)
  5aafad:	00 
  5aafae:	48 89 ac 24 10 03 00 	mov    %rbp,0x310(%rsp)
  5aafb5:	00 
  5aafb6:	48 8b 4c 24 50       	mov    0x50(%rsp),%rcx
  5aafbb:	48 89 8c 24 18 03 00 	mov    %rcx,0x318(%rsp)
  5aafc2:	00 
  5aafc3:	48 89 9c 24 20 03 00 	mov    %rbx,0x320(%rsp)
  5aafca:	00 
  5aafcb:	48 89 84 24 b8 00 00 	mov    %rax,0xb8(%rsp)
  5aafd2:	00 
  5aafd3:	48 89 94 24 c0 00 00 	mov    %rdx,0xc0(%rsp)
  5aafda:	00 
  5aafdb:	48 c7 84 24 a0 00 00 	movq   $0x0,0xa0(%rsp)
  5aafe2:	00 00 00 00 00 
  5aafe7:	48 c7 84 24 a8 00 00 	movq   $0x4,0xa8(%rsp)
  5aafee:	00 04 00 00 00 
  5aaff3:	48 c7 84 24 b0 00 00 	movq   $0x0,0xb0(%rsp)
  5aaffa:	00 00 00 00 00 
  5aafff:	48 8d bc 24 90 01 00 	lea    0x190(%rsp),%rdi
  5ab006:	00 
  5ab007:	48 8d b4 24 00 03 00 	lea    0x300(%rsp),%rsi
  5ab00e:	00 
  5ab00f:	48 8d 94 24 a0 00 00 	lea    0xa0(%rsp),%rdx
  5ab016:	00 
  5ab017:	e8 34 d9 1c 00       	call   778950 <_RNvMs4_NtNtNtNtCscdodAO9FK5_5alloc11collections5btree3map5entryINtB5_11VacantEntryNtNtCs6gaF1xUz9Bf_4gpui6source7FieldIdNtNtB1m_7runtime6FanoutE12insert_entryB1m_.llvm.12454362996328431623>
  5ab01c:	48 8b 84 24 90 01 00 	mov    0x190(%rsp),%rax
  5ab023:	00 
  5ab024:	48 8b 8c 24 a0 01 00 	mov    0x1a0(%rsp),%rcx
  5ab02b:	00 
  5ab02c:	48 8d 0c 89          	lea    (%rcx,%rcx,4),%rcx
  5ab030:	48 8d 2c c8          	lea    (%rax,%rcx,8),%rbp
  5ab034:	48 83 c5 60          	add    $0x60,%rbp
  5ab038:	41 8b 4d 30          	mov    0x30(%r13),%ecx
  5ab03c:	48 89 4c 24 18       	mov    %rcx,0x18(%rsp)
  5ab041:	81 f9 a0 86 01 00    	cmp    $0x186a0,%ecx
  5ab047:	0f 83 7b 47 00 00    	jae    5af7c8 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5778>
  5ab04d:	4c 8b 75 10          	mov    0x10(%rbp),%r14
  5ab051:	4c 3b 75 00          	cmp    0x0(%rbp),%r14
  5ab055:	75 08                	jne    5ab05f <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x100f>
  5ab057:	48 89 ef             	mov    %rbp,%rdi
  5ab05a:	e8 71 2b 22 00       	call   7cdbd0 <_RNvMs3_NtCscdodAO9FK5_5alloc7raw_vecINtB5_6RawVecNtNtCs6gaF1xUz9Bf_4gpui7runtime6ParentE8grow_oneBP_>
  5ab05f:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
  5ab064:	8d 04 85 02 00 00 00 	lea    0x2(,%rax,4),%eax
  5ab06b:	48 8b 4d 08          	mov    0x8(%rbp),%rcx
  5ab06f:	42 89 04 b1          	mov    %eax,(%rcx,%r14,4)
  5ab073:	49 ff c6             	inc    %r14
  5ab076:	4c 89 75 10          	mov    %r14,0x10(%rbp)
  5ab07a:	48 8b ac 24 c8 02 00 	mov    0x2c8(%rsp),%rbp
  5ab081:	00 
  5ab082:	48 3b ac 24 b8 02 00 	cmp    0x2b8(%rsp),%rbp
  5ab089:	00 
  5ab08a:	0f 85 30 fb ff ff    	jne    5aabc0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0xb70>
  5ab090:	e9 d4 fe ff ff       	jmp    5aaf69 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0xf19>
  5ab095:	48 c7 44 24 50 00 00 	movq   $0x0,0x50(%rsp)
  5ab09c:	00 00 
  5ab09e:	e9 bd fc ff ff       	jmp    5aad60 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0xd10>
  5ab0a3:	48 c7 44 24 50 00 00 	movq   $0x0,0x50(%rsp)
  5ab0aa:	00 00 
  5ab0ac:	e9 e5 fe ff ff       	jmp    5aaf96 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0xf46>
  5ab0b1:	0f 10 84 24 a8 00 00 	movups 0xa8(%rsp),%xmm0
  5ab0b8:	00 
  5ab0b9:	48 8b 8c 24 88 00 00 	mov    0x88(%rsp),%rcx
  5ab0c0:	00 
  5ab0c1:	48 c7 01 1f 00 00 00 	movq   $0x1f,(%rcx)
  5ab0c8:	48 89 41 08          	mov    %rax,0x8(%rcx)
  5ab0cc:	0f 11 41 10          	movups %xmm0,0x10(%rcx)
  5ab0d0:	48 8b 8c 24 30 02 00 	mov    0x230(%rsp),%rcx
  5ab0d7:	00 
  5ab0d8:	48 85 c9             	test   %rcx,%rcx
  5ab0db:	0f 85 36 42 00 00    	jne    5af317 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x52c7>
  5ab0e1:	31 c9                	xor    %ecx,%ecx
  5ab0e3:	31 c0                	xor    %eax,%eax
  5ab0e5:	e9 7a 42 00 00       	jmp    5af364 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5314>
  5ab0ea:	8b 8c 24 b4 00 00 00 	mov    0xb4(%rsp),%ecx
  5ab0f1:	48 8b 94 24 88 00 00 	mov    0x88(%rsp),%rdx
  5ab0f8:	00 
  5ab0f9:	89 4a 1c             	mov    %ecx,0x1c(%rdx)
  5ab0fc:	48 8b 8c 24 ac 00 00 	mov    0xac(%rsp),%rcx
  5ab103:	00 
  5ab104:	48 89 4a 14          	mov    %rcx,0x14(%rdx)
  5ab108:	48 c7 02 1f 00 00 00 	movq   $0x1f,(%rdx)
  5ab10f:	48 89 42 08          	mov    %rax,0x8(%rdx)
  5ab113:	44 89 7a 10          	mov    %r15d,0x10(%rdx)
  5ab117:	48 8b 8c 24 30 02 00 	mov    0x230(%rsp),%rcx
  5ab11e:	00 
  5ab11f:	48 85 c9             	test   %rcx,%rcx
  5ab122:	0f 85 ef 41 00 00    	jne    5af317 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x52c7>
  5ab128:	eb b7                	jmp    5ab0e1 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1091>
  5ab12a:	48 c7 84 24 b8 02 00 	movq   $0x0,0x2b8(%rsp)
  5ab131:	00 00 00 00 00 
  5ab136:	48 c7 84 24 c0 02 00 	movq   $0x8,0x2c0(%rsp)
  5ab13d:	00 08 00 00 00 
  5ab142:	48 c7 84 24 c8 02 00 	movq   $0x0,0x2c8(%rsp)
  5ab149:	00 00 00 00 00 
  5ab14e:	48 c7 84 24 58 04 00 	movq   $0x0,0x458(%rsp)
  5ab155:	00 00 00 00 00 
  5ab15a:	48 c7 84 24 68 04 00 	movq   $0x0,0x468(%rsp)
  5ab161:	00 00 00 00 00 
  5ab166:	48 8b 84 24 30 02 00 	mov    0x230(%rsp),%rax
  5ab16d:	00 
  5ab16e:	4c 8b b4 24 40 02 00 	mov    0x240(%rsp),%r14
  5ab175:	00 
  5ab176:	48 85 c0             	test   %rax,%rax
  5ab179:	0f 95 c1             	setne  %cl
  5ab17c:	4d 85 f6             	test   %r14,%r14
  5ab17f:	0f 95 c2             	setne  %dl
  5ab182:	20 ca                	and    %cl,%dl
  5ab184:	80 fa 01             	cmp    $0x1,%dl
  5ab187:	0f 85 61 02 00 00    	jne    5ab3ee <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x139e>
  5ab18d:	48 8b ac 24 38 02 00 	mov    0x238(%rsp),%rbp
  5ab194:	00 
  5ab195:	45 31 ed             	xor    %r13d,%r13d
  5ab198:	4c 8d 7c 24 6f       	lea    0x6f(%rsp),%r15
  5ab19d:	48 8d 9c 24 a0 00 00 	lea    0xa0(%rsp),%rbx
  5ab1a4:	00 
  5ab1a5:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
  5ab1ac:	00 00 00 00 
  5ab1b0:	4d 85 ed             	test   %r13,%r13
  5ab1b3:	74 2b                	je     5ab1e0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1190>
  5ab1b5:	41 0f b7 8d 1a 02 00 	movzwl 0x21a(%r13),%ecx
  5ab1bc:	00 
  5ab1bd:	48 39 cd             	cmp    %rcx,%rbp
  5ab1c0:	0f 83 ca 00 00 00    	jae    5ab290 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1240>
  5ab1c6:	4c 89 e9             	mov    %r13,%rcx
  5ab1c9:	48 89 ea             	mov    %rbp,%rdx
  5ab1cc:	e9 e3 00 00 00       	jmp    5ab2b4 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1264>
  5ab1d1:	66 66 66 66 66 66 2e 	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  5ab1d8:	0f 1f 84 00 00 00 00 
  5ab1df:	00 
  5ab1e0:	48 85 ed             	test   %rbp,%rbp
  5ab1e3:	74 38                	je     5ab21d <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x11cd>
  5ab1e5:	48 89 e9             	mov    %rbp,%rcx
  5ab1e8:	49 89 c5             	mov    %rax,%r13
  5ab1eb:	48 83 e1 07          	and    $0x7,%rcx
  5ab1ef:	74 31                	je     5ab222 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x11d2>
  5ab1f1:	31 d2                	xor    %edx,%edx
  5ab1f3:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  5ab1fa:	84 00 00 00 00 00 
  5ab200:	4d 8b ad 20 02 00 00 	mov    0x220(%r13),%r13
  5ab207:	48 ff c2             	inc    %rdx
  5ab20a:	48 39 d1             	cmp    %rdx,%rcx
  5ab20d:	75 f1                	jne    5ab200 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x11b0>
  5ab20f:	48 89 e8             	mov    %rbp,%rax
  5ab212:	48 29 d0             	sub    %rdx,%rax
  5ab215:	48 83 fd 08          	cmp    $0x8,%rbp
  5ab219:	73 15                	jae    5ab230 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x11e0>
  5ab21b:	eb 51                	jmp    5ab26e <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x121e>
  5ab21d:	49 89 c5             	mov    %rax,%r13
  5ab220:	eb 4c                	jmp    5ab26e <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x121e>
  5ab222:	48 89 e8             	mov    %rbp,%rax
  5ab225:	48 83 fd 08          	cmp    $0x8,%rbp
  5ab229:	72 43                	jb     5ab26e <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x121e>
  5ab22b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
  5ab230:	49 8b 8d 20 02 00 00 	mov    0x220(%r13),%rcx
  5ab237:	48 8b 89 20 02 00 00 	mov    0x220(%rcx),%rcx
  5ab23e:	48 8b 89 20 02 00 00 	mov    0x220(%rcx),%rcx
  5ab245:	48 8b 89 20 02 00 00 	mov    0x220(%rcx),%rcx
  5ab24c:	48 8b 89 20 02 00 00 	mov    0x220(%rcx),%rcx
  5ab253:	48 8b 89 20 02 00 00 	mov    0x220(%rcx),%rcx
  5ab25a:	48 8b 89 20 02 00 00 	mov    0x220(%rcx),%rcx
  5ab261:	4c 8b a9 20 02 00 00 	mov    0x220(%rcx),%r13
  5ab268:	48 83 c0 f8          	add    $0xfffffffffffffff8,%rax
  5ab26c:	75 c2                	jne    5ab230 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x11e0>
  5ab26e:	31 c0                	xor    %eax,%eax
  5ab270:	31 ed                	xor    %ebp,%ebp
  5ab272:	41 0f b7 8d 1a 02 00 	movzwl 0x21a(%r13),%ecx
  5ab279:	00 
  5ab27a:	48 39 cd             	cmp    %rcx,%rbp
  5ab27d:	0f 82 43 ff ff ff    	jb     5ab1c6 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1176>
  5ab283:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  5ab28a:	84 00 00 00 00 00 
  5ab290:	49 8b 4d 00          	mov    0x0(%r13),%rcx
  5ab294:	48 85 c9             	test   %rcx,%rcx
  5ab297:	0f 84 4c 46 00 00    	je     5af8e9 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5899>
  5ab29d:	48 ff c0             	inc    %rax
  5ab2a0:	41 0f b7 95 18 02 00 	movzwl 0x218(%r13),%edx
  5ab2a7:	00 
  5ab2a8:	49 89 cd             	mov    %rcx,%r13
  5ab2ab:	66 3b 91 1a 02 00 00 	cmp    0x21a(%rcx),%dx
  5ab2b2:	73 dc                	jae    5ab290 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1240>
  5ab2b4:	48 85 c0             	test   %rax,%rax
  5ab2b7:	0f 84 93 00 00 00    	je     5ab350 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1300>
  5ab2bd:	48 8d 34 d1          	lea    (%rcx,%rdx,8),%rsi
  5ab2c1:	48 81 c6 28 02 00 00 	add    $0x228,%rsi
  5ab2c8:	48 89 c7             	mov    %rax,%rdi
  5ab2cb:	48 83 e7 07          	and    $0x7,%rdi
  5ab2cf:	0f 84 ae 00 00 00    	je     5ab383 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1333>
  5ab2d5:	45 31 c0             	xor    %r8d,%r8d
  5ab2d8:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  5ab2df:	00 
  5ab2e0:	4c 8b 2e             	mov    (%rsi),%r13
  5ab2e3:	49 8d b5 20 02 00 00 	lea    0x220(%r13),%rsi
  5ab2ea:	49 ff c0             	inc    %r8
  5ab2ed:	4c 39 c7             	cmp    %r8,%rdi
  5ab2f0:	75 ee                	jne    5ab2e0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1290>
  5ab2f2:	48 89 c7             	mov    %rax,%rdi
  5ab2f5:	4c 29 c7             	sub    %r8,%rdi
  5ab2f8:	48 83 f8 08          	cmp    $0x8,%rax
  5ab2fc:	72 43                	jb     5ab341 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x12f1>
  5ab2fe:	66 90                	xchg   %ax,%ax
  5ab300:	48 8b 06             	mov    (%rsi),%rax
  5ab303:	48 8b 80 20 02 00 00 	mov    0x220(%rax),%rax
  5ab30a:	48 8b 80 20 02 00 00 	mov    0x220(%rax),%rax
  5ab311:	48 8b 80 20 02 00 00 	mov    0x220(%rax),%rax
  5ab318:	48 8b 80 20 02 00 00 	mov    0x220(%rax),%rax
  5ab31f:	48 8b 80 20 02 00 00 	mov    0x220(%rax),%rax
  5ab326:	48 8b 80 20 02 00 00 	mov    0x220(%rax),%rax
  5ab32d:	4c 8b a8 20 02 00 00 	mov    0x220(%rax),%r13
  5ab334:	49 8d b5 20 02 00 00 	lea    0x220(%r13),%rsi
  5ab33b:	48 83 c7 f8          	add    $0xfffffffffffffff8,%rdi
  5ab33f:	75 bf                	jne    5ab300 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x12b0>
  5ab341:	31 ed                	xor    %ebp,%ebp
  5ab343:	eb 12                	jmp    5ab357 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1307>
  5ab345:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
  5ab34c:	00 00 00 00 
  5ab350:	48 8d 6a 01          	lea    0x1(%rdx),%rbp
  5ab354:	49 89 cd             	mov    %rcx,%r13
  5ab357:	48 8d 04 92          	lea    (%rdx,%rdx,4),%rax
  5ab35b:	48 8b 7c c1 68       	mov    0x68(%rcx,%rax,8),%rdi
  5ab360:	48 8b 74 c1 70       	mov    0x70(%rcx,%rax,8),%rsi
  5ab365:	4c 89 bc 24 a0 00 00 	mov    %r15,0xa0(%rsp)
  5ab36c:	00 
  5ab36d:	48 83 fe 02          	cmp    $0x2,%rsi
  5ab371:	73 1e                	jae    5ab391 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1341>
  5ab373:	b8 00 00 00 00       	mov    $0x0,%eax
  5ab378:	49 ff ce             	dec    %r14
  5ab37b:	0f 85 2f fe ff ff    	jne    5ab1b0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1160>
  5ab381:	eb 6b                	jmp    5ab3ee <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x139e>
  5ab383:	48 89 c7             	mov    %rax,%rdi
  5ab386:	48 83 f8 08          	cmp    $0x8,%rax
  5ab38a:	72 b5                	jb     5ab341 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x12f1>
  5ab38c:	e9 6f ff ff ff       	jmp    5ab300 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x12b0>
  5ab391:	48 83 fe 15          	cmp    $0x15,%rsi
  5ab395:	73 4d                	jae    5ab3e4 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1394>
  5ab397:	48 8d 04 b7          	lea    (%rdi,%rsi,4),%rax
  5ab39b:	48 8d 4f 04          	lea    0x4(%rdi),%rcx
  5ab39f:	ba 04 00 00 00       	mov    $0x4,%edx
  5ab3a4:	eb 13                	jmp    5ab3b9 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1369>
  5ab3a6:	49 89 f8             	mov    %rdi,%r8
  5ab3a9:	41 89 30             	mov    %esi,(%r8)
  5ab3ac:	48 83 c1 04          	add    $0x4,%rcx
  5ab3b0:	48 83 c2 04          	add    $0x4,%rdx
  5ab3b4:	48 39 c1             	cmp    %rax,%rcx
  5ab3b7:	74 ba                	je     5ab373 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1323>
  5ab3b9:	44 8b 49 fc          	mov    -0x4(%rcx),%r9d
  5ab3bd:	8b 31                	mov    (%rcx),%esi
  5ab3bf:	44 39 ce             	cmp    %r9d,%esi
  5ab3c2:	73 e8                	jae    5ab3ac <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x135c>
  5ab3c4:	49 89 d0             	mov    %rdx,%r8
  5ab3c7:	46 89 0c 07          	mov    %r9d,(%rdi,%r8,1)
  5ab3cb:	49 83 f8 04          	cmp    $0x4,%r8
  5ab3cf:	74 d5                	je     5ab3a6 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1356>
  5ab3d1:	46 8b 4c 07 f8       	mov    -0x8(%rdi,%r8,1),%r9d
  5ab3d6:	49 83 c0 fc          	add    $0xfffffffffffffffc,%r8
  5ab3da:	44 39 ce             	cmp    %r9d,%esi
  5ab3dd:	72 e8                	jb     5ab3c7 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1377>
  5ab3df:	49 01 f8             	add    %rdi,%r8
  5ab3e2:	eb c5                	jmp    5ab3a9 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1359>
  5ab3e4:	48 89 da             	mov    %rbx,%rdx
  5ab3e7:	e8 14 61 14 00       	call   6f1500 <_RINvNtNtNtCs4NRVxsYgnAr_4core5slice4sort8unstable7ipnsortNtNtNtCs6gaF1xUz9Bf_4gpui7runtime8metadata11DestinationNCINvMB6_SBT_20sort_unstable_by_keymNCNvMsq_BX_INtBX_7RuntimeNtNtBX_12style_ledger9AdversaryE14describe_inners8_0E0EBZ_>
  5ab3ec:	eb 85                	jmp    5ab373 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1323>
  5ab3ee:	48 8b 5c 24 10       	mov    0x10(%rsp),%rbx
  5ab3f3:	48 8b 83 48 02 00 00 	mov    0x248(%rbx),%rax
  5ab3fa:	48 89 84 24 60 05 00 	mov    %rax,0x560(%rsp)
  5ab401:	00 
  5ab402:	0f 10 83 28 02 00 00 	movups 0x228(%rbx),%xmm0
  5ab409:	0f 10 8b 38 02 00 00 	movups 0x238(%rbx),%xmm1
  5ab410:	0f 29 8c 24 50 05 00 	movaps %xmm1,0x550(%rsp)
  5ab417:	00 
  5ab418:	0f 29 84 24 40 05 00 	movaps %xmm0,0x540(%rsp)
  5ab41f:	00 
  5ab420:	48 c7 83 28 02 00 00 	movq   $0x0,0x228(%rbx)
  5ab427:	00 00 00 00 
  5ab42b:	48 8b 83 b8 02 00 00 	mov    0x2b8(%rbx),%rax
  5ab432:	48 8b 8b c0 02 00 00 	mov    0x2c0(%rbx),%rcx
  5ab439:	48 8b 93 c8 02 00 00 	mov    0x2c8(%rbx),%rdx
  5ab440:	48 c7 83 b8 02 00 00 	movq   $0x0,0x2b8(%rbx)
  5ab447:	00 00 00 00 
  5ab44b:	48 c7 83 c0 02 00 00 	movq   $0x8,0x2c0(%rbx)
  5ab452:	08 00 00 00 
  5ab456:	48 c7 83 c8 02 00 00 	movq   $0x0,0x2c8(%rbx)
  5ab45d:	00 00 00 00 
  5ab461:	48 8d 14 92          	lea    (%rdx,%rdx,4),%rdx
  5ab465:	48 8d 14 d1          	lea    (%rcx,%rdx,8),%rdx
  5ab469:	48 89 8c 24 a0 00 00 	mov    %rcx,0xa0(%rsp)
  5ab470:	00 
  5ab471:	48 89 8c 24 a8 00 00 	mov    %rcx,0xa8(%rsp)
  5ab478:	00 
  5ab479:	48 89 84 24 b0 00 00 	mov    %rax,0xb0(%rsp)
  5ab480:	00 
  5ab481:	48 89 94 24 b8 00 00 	mov    %rdx,0xb8(%rsp)
  5ab488:	00 
  5ab489:	48 8d bc 24 88 04 00 	lea    0x488(%rsp),%rdi
  5ab490:	00 
  5ab491:	48 8d b4 24 a0 00 00 	lea    0xa0(%rsp),%rsi
  5ab498:	00 
  5ab499:	e8 f2 17 22 00       	call   7ccc90 <_RINvNtNtCscdodAO9FK5_5alloc3vec16in_place_collect18from_iter_in_placeINtNtNtNtCs4NRVxsYgnAr_4core4iter8adapters3map3MapINtNtB4_9into_iter8IntoIterNtNtCs6gaF1xUz9Bf_4gpui7runtime4NodeENcNtINtNtB1e_6option6OptionB2k_E4Some0EB2Z_EB2o_>
  5ab49e:	48 c7 84 24 a8 05 00 	movq   $0x0,0x5a8(%rsp)
  5ab4a5:	00 00 00 00 00 
  5ab4aa:	48 c7 84 24 b8 05 00 	movq   $0x0,0x5b8(%rsp)
  5ab4b1:	00 00 00 00 00 
  5ab4b6:	48 c7 84 24 c0 05 00 	movq   $0x0,0x5c0(%rsp)
  5ab4bd:	00 00 00 00 00 
  5ab4c2:	48 c7 84 24 d0 05 00 	movq   $0x0,0x5d0(%rsp)
  5ab4c9:	00 00 00 00 00 
  5ab4ce:	48 c7 84 24 d8 05 00 	movq   $0x0,0x5d8(%rsp)
  5ab4d5:	00 00 00 00 00 
  5ab4da:	48 c7 84 24 e8 05 00 	movq   $0x0,0x5e8(%rsp)
  5ab4e1:	00 00 00 00 00 
  5ab4e6:	48 8b 83 18 08 00 00 	mov    0x818(%rbx),%rax
  5ab4ed:	48 8b 8b 20 08 00 00 	mov    0x820(%rbx),%rcx
  5ab4f4:	31 d2                	xor    %edx,%edx
  5ab4f6:	48 89 c6             	mov    %rax,%rsi
  5ab4f9:	48 85 c0             	test   %rax,%rax
  5ab4fc:	40 0f 95 c7          	setne  %dil
  5ab500:	74 07                	je     5ab509 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x14b9>
  5ab502:	48 8b b3 28 08 00 00 	mov    0x828(%rbx),%rsi
  5ab509:	40 88 fa             	mov    %dil,%dl
  5ab50c:	48 89 94 24 a0 00 00 	mov    %rdx,0xa0(%rsp)
  5ab513:	00 
  5ab514:	48 c7 84 24 a8 00 00 	movq   $0x0,0xa8(%rsp)
  5ab51b:	00 00 00 00 00 
  5ab520:	48 89 84 24 b0 00 00 	mov    %rax,0xb0(%rsp)
  5ab527:	00 
  5ab528:	48 89 8c 24 b8 00 00 	mov    %rcx,0xb8(%rsp)
  5ab52f:	00 
  5ab530:	48 89 94 24 c0 00 00 	mov    %rdx,0xc0(%rsp)
  5ab537:	00 
  5ab538:	48 c7 84 24 c8 00 00 	movq   $0x0,0xc8(%rsp)
  5ab53f:	00 00 00 00 00 
  5ab544:	48 89 84 24 d0 00 00 	mov    %rax,0xd0(%rsp)
  5ab54b:	00 
  5ab54c:	48 89 8c 24 d8 00 00 	mov    %rcx,0xd8(%rsp)
  5ab553:	00 
  5ab554:	48 89 b4 24 e0 00 00 	mov    %rsi,0xe0(%rsp)
  5ab55b:	00 
  5ab55c:	40 b5 01             	mov    $0x1,%bpl
  5ab55f:	48 8d bc 24 f0 06 00 	lea    0x6f0(%rsp),%rdi
  5ab566:	00 
  5ab567:	48 8d b4 24 a0 00 00 	lea    0xa0(%rsp),%rsi
  5ab56e:	00 
  5ab56f:	41 b5 01             	mov    $0x1,%r13b
  5ab572:	e8 b9 56 17 00       	call   720c30 <_RINvXs1o_NtNtNtCscdodAO9FK5_5alloc11collections5btree3mapINtB7_8BTreeMapyNtNtCs6gaF1xUz9Bf_4gpui4list6ListIdEINtNtNtNtCs4NRVxsYgnAr_4core4iter6traits7collect12FromIteratorTyB19_EE9from_iterINtNtNtB1Q_8adapters3map3MapINtB7_4IterB19_NtNtNtB1d_7runtime4list9ListStateENCNvMsq_B3M_INtB3M_7RuntimeNtNtB3M_12style_ledger9AdversaryE14describe_inners9_0EEB1d_>
  5ab577:	48 c7 84 24 10 05 00 	movq   $0x0,0x510(%rsp)
  5ab57e:	00 00 00 00 00 
  5ab583:	48 c7 84 24 20 05 00 	movq   $0x0,0x520(%rsp)
  5ab58a:	00 00 00 00 00 
  5ab58f:	4c 8b ac 24 98 04 00 	mov    0x498(%rsp),%r13
  5ab596:	00 
  5ab597:	4d 85 ed             	test   %r13,%r13
  5ab59a:	4c 89 ac 24 30 04 00 	mov    %r13,0x430(%rsp)
  5ab5a1:	00 
  5ab5a2:	0f 84 8e 07 00 00    	je     5abd36 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1ce6>
  5ab5a8:	4c 8b b4 24 90 04 00 	mov    0x490(%rsp),%r14
  5ab5af:	00 
  5ab5b0:	4a 8d 04 ad 00 00 00 	lea    0x0(,%r13,4),%rax
  5ab5b7:	00 
  5ab5b8:	4c 01 e8             	add    %r13,%rax
  5ab5bb:	49 8d 04 c6          	lea    (%r14,%rax,8),%rax
  5ab5bf:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  5ab5c4:	31 db                	xor    %ebx,%ebx
  5ab5c6:	41 bb 01 00 00 00    	mov    $0x1,%r11d
  5ab5cc:	4d 89 f5             	mov    %r14,%r13
  5ab5cf:	4c 89 74 24 20       	mov    %r14,0x20(%rsp)
  5ab5d4:	eb 2d                	jmp    5ab603 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x15b3>
  5ab5d6:	48 8b 8c 24 b8 00 00 	mov    0xb8(%rsp),%rcx
  5ab5dd:	00 
  5ab5de:	48 89 9c c8 68 01 00 	mov    %rbx,0x168(%rax,%rcx,8)
  5ab5e5:	00 
  5ab5e6:	41 bb 01 00 00 00    	mov    $0x1,%r11d
  5ab5ec:	49 83 c5 28          	add    $0x28,%r13
  5ab5f0:	48 ff c3             	inc    %rbx
  5ab5f3:	4c 3b 6c 24 08       	cmp    0x8(%rsp),%r13
  5ab5f8:	4c 8b 74 24 20       	mov    0x20(%rsp),%r14
  5ab5fd:	0f 84 c4 06 00 00    	je     5abcc7 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1c77>
  5ab603:	49 83 7d 00 00       	cmpq   $0x0,0x0(%r13)
  5ab608:	0f 84 31 41 00 00    	je     5af73f <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x56ef>
  5ab60e:	41 8b 7d 18          	mov    0x18(%r13),%edi
  5ab612:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  5ab617:	48 39 c7             	cmp    %rax,%rdi
  5ab61a:	0f 84 f0 00 00 00    	je     5ab710 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x16c0>
  5ab620:	48 39 bc 24 30 04 00 	cmp    %rdi,0x430(%rsp)
  5ab627:	00 
  5ab628:	0f 86 44 43 00 00    	jbe    5af972 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5922>
  5ab62e:	48 8d 04 bf          	lea    (%rdi,%rdi,4),%rax
  5ab632:	4d 8b 3c c6          	mov    (%r14,%rax,8),%r15
  5ab636:	41 be 01 00 00 00    	mov    $0x1,%r14d
  5ab63c:	4d 85 ff             	test   %r15,%r15
  5ab63f:	0f 84 1e 41 00 00    	je     5af763 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5713>
  5ab645:	48 8b 84 24 10 05 00 	mov    0x510(%rsp),%rax
  5ab64c:	00 
  5ab64d:	48 85 c0             	test   %rax,%rax
  5ab650:	0f 84 ce 00 00 00    	je     5ab724 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x16d4>
  5ab656:	48 8b 8c 24 18 05 00 	mov    0x518(%rsp),%rcx
  5ab65d:	00 
  5ab65e:	4d 85 f6             	test   %r14,%r14
  5ab661:	0f 84 79 00 00 00    	je     5ab6e0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1690>
  5ab667:	0f b7 b0 12 01 00 00 	movzwl 0x112(%rax),%esi
  5ab66e:	89 f7                	mov    %esi,%edi
  5ab670:	c1 e7 04             	shl    $0x4,%edi
  5ab673:	48 c7 c2 ff ff ff ff 	mov    $0xffffffffffffffff,%rdx
  5ab67a:	49 89 c0             	mov    %rax,%r8
  5ab67d:	0f 1f 00             	nopl   (%rax)
  5ab680:	48 85 ff             	test   %rdi,%rdi
  5ab683:	74 3b                	je     5ab6c0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1670>
  5ab685:	4d 3b 78 08          	cmp    0x8(%r8),%r15
  5ab689:	41 0f 97 c1          	seta   %r9b
  5ab68d:	41 80 d9 00          	sbb    $0x0,%r9b
  5ab691:	41 f6 00 01          	testb  $0x1,(%r8)
  5ab695:	4d 8d 40 10          	lea    0x10(%r8),%r8
  5ab699:	45 0f b6 c9          	movzbl %r9b,%r9d
  5ab69d:	45 0f 44 cb          	cmove  %r11d,%r9d
  5ab6a1:	48 ff c2             	inc    %rdx
  5ab6a4:	48 83 c7 f0          	add    $0xfffffffffffffff0,%rdi
  5ab6a8:	41 80 f9 01          	cmp    $0x1,%r9b
  5ab6ac:	74 d2                	je     5ab680 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1630>
  5ab6ae:	41 0f b6 f1          	movzbl %r9b,%esi
  5ab6b2:	85 f6                	test   %esi,%esi
  5ab6b4:	0f 84 da 00 00 00    	je     5ab794 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1744>
  5ab6ba:	eb 07                	jmp    5ab6c3 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1673>
  5ab6bc:	0f 1f 40 00          	nopl   0x0(%rax)
  5ab6c0:	48 89 f2             	mov    %rsi,%rdx
  5ab6c3:	48 83 e9 01          	sub    $0x1,%rcx
  5ab6c7:	0f 82 87 00 00 00    	jb     5ab754 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1704>
  5ab6cd:	48 8b 84 d0 18 01 00 	mov    0x118(%rax,%rdx,8),%rax
  5ab6d4:	00 
  5ab6d5:	eb 90                	jmp    5ab667 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1617>
  5ab6d7:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
  5ab6de:	00 00 
  5ab6e0:	66 83 b8 12 01 00 00 	cmpw   $0x0,0x112(%rax)
  5ab6e7:	00 
  5ab6e8:	74 09                	je     5ab6f3 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x16a3>
  5ab6ea:	f6 00 01             	testb  $0x1,(%rax)
  5ab6ed:	0f 84 9f 00 00 00    	je     5ab792 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1742>
  5ab6f3:	48 83 e9 01          	sub    $0x1,%rcx
  5ab6f7:	72 59                	jb     5ab752 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1702>
  5ab6f9:	48 8b 80 18 01 00 00 	mov    0x118(%rax),%rax
  5ab700:	eb de                	jmp    5ab6e0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1690>
  5ab702:	66 66 66 66 66 2e 0f 	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  5ab709:	1f 84 00 00 00 00 00 
  5ab710:	45 31 f6             	xor    %r14d,%r14d
  5ab713:	48 8b 84 24 10 05 00 	mov    0x510(%rsp),%rax
  5ab71a:	00 
  5ab71b:	48 85 c0             	test   %rax,%rax
  5ab71e:	0f 85 32 ff ff ff    	jne    5ab656 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1606>
  5ab724:	4c 89 b4 24 a0 00 00 	mov    %r14,0xa0(%rsp)
  5ab72b:	00 
  5ab72c:	4c 89 bc 24 a8 00 00 	mov    %r15,0xa8(%rsp)
  5ab733:	00 
  5ab734:	48 8d 84 24 10 05 00 	lea    0x510(%rsp),%rax
  5ab73b:	00 
  5ab73c:	48 89 84 24 b0 00 00 	mov    %rax,0xb0(%rsp)
  5ab743:	00 
  5ab744:	48 c7 84 24 b8 00 00 	movq   $0x0,0xb8(%rsp)
  5ab74b:	00 00 00 00 00 
  5ab750:	eb 76                	jmp    5ab7c8 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1778>
  5ab752:	31 d2                	xor    %edx,%edx
  5ab754:	48 89 84 24 b8 00 00 	mov    %rax,0xb8(%rsp)
  5ab75b:	00 
  5ab75c:	48 c7 84 24 c0 00 00 	movq   $0x0,0xc0(%rsp)
  5ab763:	00 00 00 00 00 
  5ab768:	48 89 94 24 c8 00 00 	mov    %rdx,0xc8(%rsp)
  5ab76f:	00 
  5ab770:	4c 89 b4 24 a0 00 00 	mov    %r14,0xa0(%rsp)
  5ab777:	00 
  5ab778:	4c 89 bc 24 a8 00 00 	mov    %r15,0xa8(%rsp)
  5ab77f:	00 
  5ab780:	48 8d 84 24 10 05 00 	lea    0x510(%rsp),%rax
  5ab787:	00 
  5ab788:	48 89 84 24 b0 00 00 	mov    %rax,0xb0(%rsp)
  5ab78f:	00 
  5ab790:	eb 36                	jmp    5ab7c8 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1778>
  5ab792:	31 d2                	xor    %edx,%edx
  5ab794:	48 89 84 24 a8 00 00 	mov    %rax,0xa8(%rsp)
  5ab79b:	00 
  5ab79c:	48 89 8c 24 b0 00 00 	mov    %rcx,0xb0(%rsp)
  5ab7a3:	00 
  5ab7a4:	48 89 94 24 b8 00 00 	mov    %rdx,0xb8(%rsp)
  5ab7ab:	00 
  5ab7ac:	48 8d 84 24 10 05 00 	lea    0x510(%rsp),%rax
  5ab7b3:	00 
  5ab7b4:	48 89 84 24 c0 00 00 	mov    %rax,0xc0(%rsp)
  5ab7bb:	00 
  5ab7bc:	48 c7 84 24 a0 00 00 	movq   $0x2,0xa0(%rsp)
  5ab7c3:	00 02 00 00 00 
  5ab7c8:	48 8d bc 24 a0 00 00 	lea    0xa0(%rsp),%rdi
  5ab7cf:	00 
  5ab7d0:	e8 4b ce 1c 00       	call   778620 <_RNvMs3_NtNtNtNtCscdodAO9FK5_5alloc11collections5btree3map5entryINtB5_5EntryINtNtCs4NRVxsYgnAr_4core6option6OptionyEjE10or_defaultCs6gaF1xUz9Bf_4gpui>
  5ab7d5:	48 ff 00             	incq   (%rax)
  5ab7d8:	41 8b 45 1c          	mov    0x1c(%r13),%eax
  5ab7dc:	41 8b 4d 20          	mov    0x20(%r13),%ecx
  5ab7e0:	83 e1 07             	and    $0x7,%ecx
  5ab7e3:	48 8d 15 32 30 ac ff 	lea    -0x53cfce(%rip),%rdx        # 6e81c <anon.5f884de6e78125e25881320d811d32df.354.llvm.17146438997930651657+0x78c>
  5ab7ea:	48 63 0c 8a          	movslq (%rdx,%rcx,4),%rcx
  5ab7ee:	48 01 d1             	add    %rdx,%rcx
  5ab7f1:	ff e1                	jmp    *%rcx
  5ab7f3:	31 c9                	xor    %ecx,%ecx
  5ab7f5:	eb 19                	jmp    5ab810 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x17c0>
  5ab7f7:	b1 05                	mov    $0x5,%cl
  5ab7f9:	eb 15                	jmp    5ab810 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x17c0>
  5ab7fb:	b1 06                	mov    $0x6,%cl
  5ab7fd:	eb 11                	jmp    5ab810 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x17c0>
  5ab7ff:	b1 02                	mov    $0x2,%cl
  5ab801:	eb 0d                	jmp    5ab810 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x17c0>
  5ab803:	b1 01                	mov    $0x1,%cl
  5ab805:	eb 09                	jmp    5ab810 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x17c0>
  5ab807:	b1 04                	mov    $0x4,%cl
  5ab809:	eb 05                	jmp    5ab810 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x17c0>
  5ab80b:	b1 03                	mov    $0x3,%cl
  5ab80d:	0f 1f 00             	nopl   (%rax)
  5ab810:	4c 89 b4 24 90 01 00 	mov    %r14,0x190(%rsp)
  5ab817:	00 
  5ab818:	4c 89 bc 24 98 01 00 	mov    %r15,0x198(%rsp)
  5ab81f:	00 
  5ab820:	89 84 24 a0 01 00 00 	mov    %eax,0x1a0(%rsp)
  5ab827:	88 8c 24 a4 01 00 00 	mov    %cl,0x1a4(%rsp)
  5ab82e:	48 8b b4 24 a8 05 00 	mov    0x5a8(%rsp),%rsi
  5ab835:	00 
  5ab836:	48 85 f6             	test   %rsi,%rsi
  5ab839:	74 65                	je     5ab8a0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1850>
  5ab83b:	48 8b 94 24 b0 05 00 	mov    0x5b0(%rsp),%rdx
  5ab842:	00 
  5ab843:	48 8d bc 24 a0 00 00 	lea    0xa0(%rsp),%rdi
  5ab84a:	00 
  5ab84b:	48 8d 8c 24 90 01 00 	lea    0x190(%rsp),%rcx
  5ab852:	00 
  5ab853:	e8 b8 bf 0c 00       	call   677810 <_RINvMs_NtNtNtCscdodAO9FK5_5alloc11collections5btree6searchINtNtB7_4node7NodeRefNtNtBX_6marker3MutTINtNtCs4NRVxsYgnAr_4core6option6OptionyEmNtNtCs6gaF1xUz9Bf_4gpui7element8NodeKindEjNtB1h_14LeafOrInternalE11search_treeB1x_EB2h_>
  5ab858:	48 8b 84 24 a8 00 00 	mov    0xa8(%rsp),%rax
  5ab85f:	00 
  5ab860:	80 bc 24 a0 00 00 00 	cmpb   $0x0,0xa0(%rsp)
  5ab867:	00 
  5ab868:	0f 84 a2 00 00 00    	je     5ab910 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x18c0>
  5ab86e:	48 8d b4 24 b0 00 00 	lea    0xb0(%rsp),%rsi
  5ab875:	00 
  5ab876:	0f 10 06             	movups (%rsi),%xmm0
  5ab879:	0f 29 84 24 b0 03 00 	movaps %xmm0,0x3b0(%rsp)
  5ab880:	00 
  5ab881:	48 8b 94 24 98 01 00 	mov    0x198(%rsp),%rdx
  5ab888:	00 
  5ab889:	48 8b 8c 24 a0 01 00 	mov    0x1a0(%rsp),%rcx
  5ab890:	00 
  5ab891:	eb 22                	jmp    5ab8b5 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1865>
  5ab893:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  5ab89a:	84 00 00 00 00 00 
  5ab8a0:	48 8b 8c 24 a0 01 00 	mov    0x1a0(%rsp),%rcx
  5ab8a7:	00 
  5ab8a8:	4c 89 fa             	mov    %r15,%rdx
  5ab8ab:	31 c0                	xor    %eax,%eax
  5ab8ad:	48 8d b4 24 b0 00 00 	lea    0xb0(%rsp),%rsi
  5ab8b4:	00 
  5ab8b5:	4c 89 b4 24 a0 00 00 	mov    %r14,0xa0(%rsp)
  5ab8bc:	00 
  5ab8bd:	48 89 94 24 a8 00 00 	mov    %rdx,0xa8(%rsp)
  5ab8c4:	00 
  5ab8c5:	48 89 8c 24 b0 00 00 	mov    %rcx,0xb0(%rsp)
  5ab8cc:	00 
  5ab8cd:	48 8d 8c 24 a8 05 00 	lea    0x5a8(%rsp),%rcx
  5ab8d4:	00 
  5ab8d5:	48 89 8c 24 b8 00 00 	mov    %rcx,0xb8(%rsp)
  5ab8dc:	00 
  5ab8dd:	48 89 84 24 c0 00 00 	mov    %rax,0xc0(%rsp)
  5ab8e4:	00 
  5ab8e5:	0f 28 84 24 b0 03 00 	movaps 0x3b0(%rsp),%xmm0
  5ab8ec:	00 
  5ab8ed:	0f 11 46 18          	movups %xmm0,0x18(%rsi)
  5ab8f1:	48 8d bc 24 00 03 00 	lea    0x300(%rsp),%rdi
  5ab8f8:	00 
  5ab8f9:	48 8d b4 24 a0 00 00 	lea    0xa0(%rsp),%rsi
  5ab900:	00 
  5ab901:	48 89 da             	mov    %rbx,%rdx
  5ab904:	e8 27 d5 1c 00       	call   778e30 <_RNvMs4_NtNtNtNtCscdodAO9FK5_5alloc11collections5btree3map5entryINtB5_11VacantEntryTINtNtCs4NRVxsYgnAr_4core6option6OptionyEmNtNtCs6gaF1xUz9Bf_4gpui7element8NodeKindEjE12insert_entryB22_>
  5ab909:	eb 15                	jmp    5ab920 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x18d0>
  5ab90b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
  5ab910:	48 8b 8c 24 b8 00 00 	mov    0xb8(%rsp),%rcx
  5ab917:	00 
  5ab918:	48 89 9c c8 10 01 00 	mov    %rbx,0x110(%rax,%rcx,8)
  5ab91f:	00 
  5ab920:	49 8b 45 00          	mov    0x0(%r13),%rax
  5ab924:	48 8b 54 24 10       	mov    0x10(%rsp),%rdx
  5ab929:	48 8b 8a 30 08 00 00 	mov    0x830(%rdx),%rcx
  5ab930:	48 85 c9             	test   %rcx,%rcx
  5ab933:	41 bb 01 00 00 00    	mov    $0x1,%r11d
  5ab939:	0f 84 d2 01 00 00    	je     5abb11 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1ac1>
  5ab93f:	48 8b 92 38 08 00 00 	mov    0x838(%rdx),%rdx
  5ab946:	44 0f b7 81 c2 01 00 	movzwl 0x1c2(%rcx),%r8d
  5ab94d:	00 
  5ab94e:	45 89 c1             	mov    %r8d,%r9d
  5ab951:	41 c1 e1 05          	shl    $0x5,%r9d
  5ab955:	48 c7 c6 ff ff ff ff 	mov    $0xffffffffffffffff,%rsi
  5ab95c:	31 ff                	xor    %edi,%edi
  5ab95e:	66 90                	xchg   %ax,%ax
  5ab960:	49 39 f9             	cmp    %rdi,%r9
  5ab963:	74 2b                	je     5ab990 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1940>
  5ab965:	48 3b 84 f1 70 01 00 	cmp    0x170(%rcx,%rsi,8),%rax
  5ab96c:	00 
  5ab96d:	41 0f 97 c2          	seta   %r10b
  5ab971:	41 80 da 00          	sbb    $0x0,%r10b
  5ab975:	48 83 c7 20          	add    $0x20,%rdi
  5ab979:	48 ff c6             	inc    %rsi
  5ab97c:	41 80 fa 01          	cmp    $0x1,%r10b
  5ab980:	74 de                	je     5ab960 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1910>
  5ab982:	45 0f b6 c2          	movzbl %r10b,%r8d
  5ab986:	45 85 c0             	test   %r8d,%r8d
  5ab989:	75 08                	jne    5ab993 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1943>
  5ab98b:	eb 23                	jmp    5ab9b0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1960>
  5ab98d:	0f 1f 00             	nopl   (%rax)
  5ab990:	4c 89 c6             	mov    %r8,%rsi
  5ab993:	48 83 ea 01          	sub    $0x1,%rdx
  5ab997:	0f 82 74 01 00 00    	jb     5abb11 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1ac1>
  5ab99d:	48 8b 8c f1 c8 01 00 	mov    0x1c8(%rcx,%rsi,8),%rcx
  5ab9a4:	00 
  5ab9a5:	eb 9f                	jmp    5ab946 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x18f6>
  5ab9a7:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
  5ab9ae:	00 00 
  5ab9b0:	80 7c 39 fc 01       	cmpb   $0x1,-0x4(%rcx,%rdi,1)
  5ab9b5:	0f 85 56 01 00 00    	jne    5abb11 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1ac1>
  5ab9bb:	48 8b 6c 39 e8       	mov    -0x18(%rcx,%rdi,1),%rbp
  5ab9c0:	41 8b 45 20          	mov    0x20(%r13),%eax
  5ab9c4:	83 e0 07             	and    $0x7,%eax
  5ab9c7:	48 8d 0d 6e 2e ac ff 	lea    -0x53d192(%rip),%rcx        # 6e83c <anon.5f884de6e78125e25881320d811d32df.354.llvm.17146438997930651657+0x7ac>
  5ab9ce:	48 63 04 81          	movslq (%rcx,%rax,4),%rax
  5ab9d2:	48 01 c8             	add    %rcx,%rax
  5ab9d5:	ff e0                	jmp    *%rax
  5ab9d7:	31 c0                	xor    %eax,%eax
  5ab9d9:	eb 25                	jmp    5aba00 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x19b0>
  5ab9db:	b0 05                	mov    $0x5,%al
  5ab9dd:	eb 21                	jmp    5aba00 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x19b0>
  5ab9df:	b0 06                	mov    $0x6,%al
  5ab9e1:	eb 1d                	jmp    5aba00 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x19b0>
  5ab9e3:	b0 02                	mov    $0x2,%al
  5ab9e5:	eb 19                	jmp    5aba00 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x19b0>
  5ab9e7:	b0 01                	mov    $0x1,%al
  5ab9e9:	eb 15                	jmp    5aba00 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x19b0>
  5ab9eb:	b0 04                	mov    $0x4,%al
  5ab9ed:	eb 11                	jmp    5aba00 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x19b0>
  5ab9ef:	b0 03                	mov    $0x3,%al
  5ab9f1:	66 66 66 66 66 66 2e 	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  5ab9f8:	0f 1f 84 00 00 00 00 
  5ab9ff:	00 
  5aba00:	4c 89 b4 24 90 01 00 	mov    %r14,0x190(%rsp)
  5aba07:	00 
  5aba08:	4c 89 bc 24 98 01 00 	mov    %r15,0x198(%rsp)
  5aba0f:	00 
  5aba10:	48 89 ac 24 a0 01 00 	mov    %rbp,0x1a0(%rsp)
  5aba17:	00 
  5aba18:	88 84 24 a8 01 00 00 	mov    %al,0x1a8(%rsp)
  5aba1f:	48 8b b4 24 c0 05 00 	mov    0x5c0(%rsp),%rsi
  5aba26:	00 
  5aba27:	48 85 f6             	test   %rsi,%rsi
  5aba2a:	74 58                	je     5aba84 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1a34>
  5aba2c:	48 8b 94 24 c8 05 00 	mov    0x5c8(%rsp),%rdx
  5aba33:	00 
  5aba34:	48 8d bc 24 a0 00 00 	lea    0xa0(%rsp),%rdi
  5aba3b:	00 
  5aba3c:	48 8d 8c 24 90 01 00 	lea    0x190(%rsp),%rcx
  5aba43:	00 
  5aba44:	e8 17 bc 0c 00       	call   677660 <_RINvMs_NtNtNtCscdodAO9FK5_5alloc11collections5btree6searchINtNtB7_4node7NodeRefNtNtBX_6marker3MutTINtNtCs4NRVxsYgnAr_4core6option6OptionyENtNtCs6gaF1xUz9Bf_4gpui4list6ListIdNtNtB2g_7element8NodeKindEjNtB1h_14LeafOrInternalE11search_treeB1x_EB2g_>
  5aba49:	48 8b 84 24 a8 00 00 	mov    0xa8(%rsp),%rax
  5aba50:	00 
  5aba51:	80 bc 24 a0 00 00 00 	cmpb   $0x0,0xa0(%rsp)
  5aba58:	00 
  5aba59:	0f 84 98 00 00 00    	je     5abaf7 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1aa7>
  5aba5f:	48 8d b4 24 b0 00 00 	lea    0xb0(%rsp),%rsi
  5aba66:	00 
  5aba67:	0f 10 06             	movups (%rsi),%xmm0
  5aba6a:	0f 29 84 24 b0 03 00 	movaps %xmm0,0x3b0(%rsp)
  5aba71:	00 
  5aba72:	48 8b 94 24 98 01 00 	mov    0x198(%rsp),%rdx
  5aba79:	00 
  5aba7a:	48 8b 8c 24 a8 01 00 	mov    0x1a8(%rsp),%rcx
  5aba81:	00 
  5aba82:	eb 15                	jmp    5aba99 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1a49>
  5aba84:	48 8b 8c 24 a8 01 00 	mov    0x1a8(%rsp),%rcx
  5aba8b:	00 
  5aba8c:	4c 89 fa             	mov    %r15,%rdx
  5aba8f:	31 c0                	xor    %eax,%eax
  5aba91:	48 8d b4 24 b0 00 00 	lea    0xb0(%rsp),%rsi
  5aba98:	00 
  5aba99:	4c 89 b4 24 a0 00 00 	mov    %r14,0xa0(%rsp)
  5abaa0:	00 
  5abaa1:	48 89 94 24 a8 00 00 	mov    %rdx,0xa8(%rsp)
  5abaa8:	00 
  5abaa9:	48 89 ac 24 b0 00 00 	mov    %rbp,0xb0(%rsp)
  5abab0:	00 
  5abab1:	48 89 8c 24 b8 00 00 	mov    %rcx,0xb8(%rsp)
  5abab8:	00 
  5abab9:	48 8d 8c 24 c0 05 00 	lea    0x5c0(%rsp),%rcx
  5abac0:	00 
  5abac1:	48 89 8c 24 c0 00 00 	mov    %rcx,0xc0(%rsp)
  5abac8:	00 
  5abac9:	48 89 84 24 c8 00 00 	mov    %rax,0xc8(%rsp)
  5abad0:	00 
  5abad1:	0f 28 84 24 b0 03 00 	movaps 0x3b0(%rsp),%xmm0
  5abad8:	00 
  5abad9:	0f 11 46 20          	movups %xmm0,0x20(%rsi)
  5abadd:	48 8d bc 24 00 03 00 	lea    0x300(%rsp),%rdi
  5abae4:	00 
  5abae5:	48 8d b4 24 a0 00 00 	lea    0xa0(%rsp),%rsi
  5abaec:	00 
  5abaed:	48 89 da             	mov    %rbx,%rdx
  5abaf0:	e8 3b d2 1c 00       	call   778d30 <_RNvMs4_NtNtNtNtCscdodAO9FK5_5alloc11collections5btree3map5entryINtB5_11VacantEntryTINtNtCs4NRVxsYgnAr_4core6option6OptionyENtNtCs6gaF1xUz9Bf_4gpui4list7ItemKeyNtNtB21_7element8NodeKindEjE12insert_entryB21_>
  5abaf5:	eb 10                	jmp    5abb07 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1ab7>
  5abaf7:	48 8b 8c 24 b8 00 00 	mov    0xb8(%rsp),%rcx
  5abafe:	00 
  5abaff:	48 89 9c c8 68 01 00 	mov    %rbx,0x168(%rax,%rcx,8)
  5abb06:	00 
  5abb07:	49 8b 45 00          	mov    0x0(%r13),%rax
  5abb0b:	41 bb 01 00 00 00    	mov    $0x1,%r11d
  5abb11:	48 8b 8c 24 f0 06 00 	mov    0x6f0(%rsp),%rcx
  5abb18:	00 
  5abb19:	48 85 c9             	test   %rcx,%rcx
  5abb1c:	0f 84 ca fa ff ff    	je     5ab5ec <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x159c>
  5abb22:	48 8b 94 24 f8 06 00 	mov    0x6f8(%rsp),%rdx
  5abb29:	00 
  5abb2a:	0f b7 b9 ba 00 00 00 	movzwl 0xba(%rcx),%edi
  5abb31:	41 89 f8             	mov    %edi,%r8d
  5abb34:	41 c1 e0 03          	shl    $0x3,%r8d
  5abb38:	48 c7 c6 ff ff ff ff 	mov    $0xffffffffffffffff,%rsi
  5abb3f:	90                   	nop
  5abb40:	4d 85 c0             	test   %r8,%r8
  5abb43:	74 2b                	je     5abb70 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1b20>
  5abb45:	48 3b 44 f1 10       	cmp    0x10(%rcx,%rsi,8),%rax
  5abb4a:	41 0f 97 c1          	seta   %r9b
  5abb4e:	41 80 d9 00          	sbb    $0x0,%r9b
  5abb52:	48 ff c6             	inc    %rsi
  5abb55:	49 83 c0 f8          	add    $0xfffffffffffffff8,%r8
  5abb59:	41 80 f9 01          	cmp    $0x1,%r9b
  5abb5d:	74 e1                	je     5abb40 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1af0>
  5abb5f:	41 0f b6 f9          	movzbl %r9b,%edi
  5abb63:	85 ff                	test   %edi,%edi
  5abb65:	75 0c                	jne    5abb73 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1b23>
  5abb67:	eb 27                	jmp    5abb90 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1b40>
  5abb69:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  5abb70:	48 89 fe             	mov    %rdi,%rsi
  5abb73:	48 83 ea 01          	sub    $0x1,%rdx
  5abb77:	0f 82 6f fa ff ff    	jb     5ab5ec <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x159c>
  5abb7d:	48 8b 8c f1 c0 00 00 	mov    0xc0(%rcx,%rsi,8),%rcx
  5abb84:	00 
  5abb85:	eb a3                	jmp    5abb2a <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1ada>
  5abb87:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
  5abb8e:	00 00 
  5abb90:	48 8b 6c f1 60       	mov    0x60(%rcx,%rsi,8),%rbp
  5abb95:	41 8b 45 20          	mov    0x20(%r13),%eax
  5abb99:	83 e0 07             	and    $0x7,%eax
  5abb9c:	48 8d 0d b9 2c ac ff 	lea    -0x53d347(%rip),%rcx        # 6e85c <anon.5f884de6e78125e25881320d811d32df.354.llvm.17146438997930651657+0x7cc>
  5abba3:	48 63 04 81          	movslq (%rcx,%rax,4),%rax
  5abba7:	48 01 c8             	add    %rcx,%rax
  5abbaa:	ff e0                	jmp    *%rax
  5abbac:	31 c0                	xor    %eax,%eax
  5abbae:	eb 20                	jmp    5abbd0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1b80>
  5abbb0:	b0 04                	mov    $0x4,%al
  5abbb2:	eb 1c                	jmp    5abbd0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1b80>
  5abbb4:	b0 02                	mov    $0x2,%al
  5abbb6:	eb 18                	jmp    5abbd0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1b80>
  5abbb8:	b0 03                	mov    $0x3,%al
  5abbba:	eb 14                	jmp    5abbd0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1b80>
  5abbbc:	b0 01                	mov    $0x1,%al
  5abbbe:	eb 10                	jmp    5abbd0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1b80>
  5abbc0:	b0 05                	mov    $0x5,%al
  5abbc2:	eb 0c                	jmp    5abbd0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1b80>
  5abbc4:	b0 06                	mov    $0x6,%al
  5abbc6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  5abbcd:	00 00 00 
  5abbd0:	4c 89 b4 24 90 01 00 	mov    %r14,0x190(%rsp)
  5abbd7:	00 
  5abbd8:	4c 89 bc 24 98 01 00 	mov    %r15,0x198(%rsp)
  5abbdf:	00 
  5abbe0:	48 89 ac 24 a0 01 00 	mov    %rbp,0x1a0(%rsp)
  5abbe7:	00 
  5abbe8:	88 84 24 a8 01 00 00 	mov    %al,0x1a8(%rsp)
  5abbef:	48 8b b4 24 d8 05 00 	mov    0x5d8(%rsp),%rsi
  5abbf6:	00 
  5abbf7:	48 85 f6             	test   %rsi,%rsi
  5abbfa:	74 58                	je     5abc54 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1c04>
  5abbfc:	48 8b 94 24 e0 05 00 	mov    0x5e0(%rsp),%rdx
  5abc03:	00 
  5abc04:	48 8d bc 24 a0 00 00 	lea    0xa0(%rsp),%rdi
  5abc0b:	00 
  5abc0c:	48 8d 8c 24 90 01 00 	lea    0x190(%rsp),%rcx
  5abc13:	00 
  5abc14:	e8 47 ba 0c 00       	call   677660 <_RINvMs_NtNtNtCscdodAO9FK5_5alloc11collections5btree6searchINtNtB7_4node7NodeRefNtNtBX_6marker3MutTINtNtCs4NRVxsYgnAr_4core6option6OptionyENtNtCs6gaF1xUz9Bf_4gpui4list6ListIdNtNtB2g_7element8NodeKindEjNtB1h_14LeafOrInternalE11search_treeB1x_EB2g_>
  5abc19:	48 8b 84 24 a8 00 00 	mov    0xa8(%rsp),%rax
  5abc20:	00 
  5abc21:	80 bc 24 a0 00 00 00 	cmpb   $0x0,0xa0(%rsp)
  5abc28:	00 
  5abc29:	0f 84 a7 f9 ff ff    	je     5ab5d6 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1586>
  5abc2f:	48 8d 94 24 b0 00 00 	lea    0xb0(%rsp),%rdx
  5abc36:	00 
  5abc37:	0f 10 02             	movups (%rdx),%xmm0
  5abc3a:	0f 29 84 24 b0 03 00 	movaps %xmm0,0x3b0(%rsp)
  5abc41:	00 
  5abc42:	4c 8b bc 24 98 01 00 	mov    0x198(%rsp),%r15
  5abc49:	00 
  5abc4a:	48 8b 8c 24 a8 01 00 	mov    0x1a8(%rsp),%rcx
  5abc51:	00 
  5abc52:	eb 12                	jmp    5abc66 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1c16>
  5abc54:	48 8b 8c 24 a8 01 00 	mov    0x1a8(%rsp),%rcx
  5abc5b:	00 
  5abc5c:	31 c0                	xor    %eax,%eax
  5abc5e:	48 8d 94 24 b0 00 00 	lea    0xb0(%rsp),%rdx
  5abc65:	00 
  5abc66:	4c 89 b4 24 a0 00 00 	mov    %r14,0xa0(%rsp)
  5abc6d:	00 
  5abc6e:	4c 89 bc 24 a8 00 00 	mov    %r15,0xa8(%rsp)
  5abc75:	00 
  5abc76:	48 89 ac 24 b0 00 00 	mov    %rbp,0xb0(%rsp)
  5abc7d:	00 
  5abc7e:	48 89 8c 24 b8 00 00 	mov    %rcx,0xb8(%rsp)
  5abc85:	00 
  5abc86:	48 8d 8c 24 d8 05 00 	lea    0x5d8(%rsp),%rcx
  5abc8d:	00 
  5abc8e:	48 89 8c 24 c0 00 00 	mov    %rcx,0xc0(%rsp)
  5abc95:	00 
  5abc96:	48 89 84 24 c8 00 00 	mov    %rax,0xc8(%rsp)
  5abc9d:	00 
  5abc9e:	0f 28 84 24 b0 03 00 	movaps 0x3b0(%rsp),%xmm0
  5abca5:	00 
  5abca6:	0f 11 42 20          	movups %xmm0,0x20(%rdx)
  5abcaa:	48 8d bc 24 00 03 00 	lea    0x300(%rsp),%rdi
  5abcb1:	00 
  5abcb2:	48 8d b4 24 a0 00 00 	lea    0xa0(%rsp),%rsi
  5abcb9:	00 
  5abcba:	48 89 da             	mov    %rbx,%rdx
  5abcbd:	e8 6e cf 1c 00       	call   778c30 <_RNvMs4_NtNtNtNtCscdodAO9FK5_5alloc11collections5btree3map5entryINtB5_11VacantEntryTINtNtCs4NRVxsYgnAr_4core6option6OptionyENtNtCs6gaF1xUz9Bf_4gpui4list6ListIdNtNtB21_7element8NodeKindEjE12insert_entryB21_>
  5abcc2:	e9 1f f9 ff ff       	jmp    5ab5e6 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1596>
  5abcc7:	4c 8b ac 24 30 04 00 	mov    0x430(%rsp),%r13
  5abcce:	00 
  5abccf:	4a 8d 1c ed 00 00 00 	lea    0x0(,%r13,8),%rbx
  5abcd6:	00 
  5abcd7:	ff 15 c3 e3 53 00    	call   *0x53e3c3(%rip)        # aea0a0 <_DYNAMIC+0x340>
  5abcdd:	be 08 00 00 00       	mov    $0x8,%esi
  5abce2:	48 89 df             	mov    %rbx,%rdi
  5abce5:	ff 15 b5 e2 53 00    	call   *0x53e2b5(%rip)        # ae9fa0 <_DYNAMIC+0x240>
  5abceb:	48 89 84 24 80 00 00 	mov    %rax,0x80(%rsp)
  5abcf2:	00 
  5abcf3:	48 85 c0             	test   %rax,%rax
  5abcf6:	0f 84 da 3e 00 00    	je     5afbd6 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5b86>
  5abcfc:	31 c0                	xor    %eax,%eax
  5abcfe:	48 8b 94 24 80 00 00 	mov    0x80(%rsp),%rdx
  5abd05:	00 
  5abd06:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  5abd0d:	00 00 00 
  5abd10:	49 8b 0e             	mov    (%r14),%rcx
  5abd13:	48 85 c9             	test   %rcx,%rcx
  5abd16:	0f 84 35 3a 00 00    	je     5af751 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5701>
  5abd1c:	48 89 0c c2          	mov    %rcx,(%rdx,%rax,8)
  5abd20:	48 ff c0             	inc    %rax
  5abd23:	49 83 c6 28          	add    $0x28,%r14
  5abd27:	49 39 c5             	cmp    %rax,%r13
  5abd2a:	75 e4                	jne    5abd10 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1cc0>
  5abd2c:	4c 89 ac 24 d8 02 00 	mov    %r13,0x2d8(%rsp)
  5abd33:	00 
  5abd34:	eb 19                	jmp    5abd4f <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1cff>
  5abd36:	b8 08 00 00 00       	mov    $0x8,%eax
  5abd3b:	48 89 84 24 80 00 00 	mov    %rax,0x80(%rsp)
  5abd42:	00 
  5abd43:	48 c7 84 24 d8 02 00 	movq   $0x0,0x2d8(%rsp)
  5abd4a:	00 00 00 00 00 
  5abd4f:	48 b8 01 00 00 00 00 	movabs $0x8000000000000001,%rax
  5abd56:	00 00 80 
  5abd59:	48 ff c8             	dec    %rax
  5abd5c:	48 c7 84 24 38 07 00 	movq   $0x0,0x738(%rsp)
  5abd63:	00 00 00 00 00 
  5abd68:	4c 89 a4 24 40 07 00 	mov    %r12,0x740(%rsp)
  5abd6f:	00 
  5abd70:	48 89 84 24 50 02 00 	mov    %rax,0x250(%rsp)
  5abd77:	00 
  5abd78:	48 89 84 24 08 07 00 	mov    %rax,0x708(%rsp)
  5abd7f:	00 
  5abd80:	4d 85 e4             	test   %r12,%r12
  5abd83:	4a 8d 04 e5 00 00 00 	lea    0x0(,%r12,8),%rax
  5abd8a:	00 
  5abd8b:	74 5b                	je     5abde8 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1d98>
  5abd8d:	48 8d 1c 80          	lea    (%rax,%rax,4),%rbx
  5abd91:	ff 15 09 e3 53 00    	call   *0x53e309(%rip)        # aea0a0 <_DYNAMIC+0x340>
  5abd97:	be 08 00 00 00       	mov    $0x8,%esi
  5abd9c:	48 89 df             	mov    %rbx,%rdi
  5abd9f:	ff 15 fb e1 53 00    	call   *0x53e1fb(%rip)        # ae9fa0 <_DYNAMIC+0x240>
  5abda5:	48 85 c0             	test   %rax,%rax
  5abda8:	0f 84 18 3e 00 00    	je     5afbc6 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5b76>
  5abdae:	4c 89 a4 24 18 02 00 	mov    %r12,0x218(%rsp)
  5abdb5:	00 
  5abdb6:	48 89 84 24 20 02 00 	mov    %rax,0x220(%rsp)
  5abdbd:	00 
  5abdbe:	48 c7 84 24 28 02 00 	movq   $0x0,0x228(%rsp)
  5abdc5:	00 00 00 00 00 
  5abdca:	48 8b 84 24 40 06 00 	mov    0x640(%rsp),%rax
  5abdd1:	00 
  5abdd2:	44 89 e1             	mov    %r12d,%ecx
  5abdd5:	83 e1 03             	and    $0x3,%ecx
  5abdd8:	49 83 fc 04          	cmp    $0x4,%r12
  5abddc:	73 40                	jae    5abe1e <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1dce>
  5abdde:	31 d2                	xor    %edx,%edx
  5abde0:	45 31 f6             	xor    %r14d,%r14d
  5abde3:	e9 a1 00 00 00       	jmp    5abe89 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1e39>
  5abde8:	48 c7 84 24 18 02 00 	movq   $0x0,0x218(%rsp)
  5abdef:	00 00 00 00 00 
  5abdf4:	48 c7 84 24 20 02 00 	movq   $0x8,0x220(%rsp)
  5abdfb:	00 08 00 00 00 
  5abe00:	48 c7 84 24 28 02 00 	movq   $0x0,0x228(%rsp)
  5abe07:	00 00 00 00 00 
  5abe0c:	b8 08 00 00 00       	mov    $0x8,%eax
  5abe11:	4c 8b bc 24 40 06 00 	mov    0x640(%rsp),%r15
  5abe18:	00 
  5abe19:	e9 04 01 00 00       	jmp    5abf22 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1ed2>
  5abe1e:	44 89 e6             	mov    %r12d,%esi
  5abe21:	81 e6 fc ff 01 00    	and    $0x1fffc,%esi
  5abe27:	31 d2                	xor    %edx,%edx
  5abe29:	48 89 c7             	mov    %rax,%rdi
  5abe2c:	45 31 f6             	xor    %r14d,%r14d
  5abe2f:	90                   	nop
  5abe30:	45 31 c0             	xor    %r8d,%r8d
  5abe33:	48 83 3f ff          	cmpq   $0xffffffffffffffff,(%rdi)
  5abe37:	41 0f 95 c0          	setne  %r8b
  5abe3b:	4d 01 f0             	add    %r14,%r8
  5abe3e:	45 31 c9             	xor    %r9d,%r9d
  5abe41:	48 83 bf 98 00 00 00 	cmpq   $0xffffffffffffffff,0x98(%rdi)
  5abe48:	ff 
  5abe49:	41 0f 95 c1          	setne  %r9b
  5abe4d:	45 31 d2             	xor    %r10d,%r10d
  5abe50:	48 83 bf 30 01 00 00 	cmpq   $0xffffffffffffffff,0x130(%rdi)
  5abe57:	ff 
  5abe58:	41 0f 95 c2          	setne  %r10b
  5abe5c:	4d 01 ca             	add    %r9,%r10
  5abe5f:	4d 01 c2             	add    %r8,%r10
  5abe62:	45 31 f6             	xor    %r14d,%r14d
  5abe65:	48 83 bf c8 01 00 00 	cmpq   $0xffffffffffffffff,0x1c8(%rdi)
  5abe6c:	ff 
  5abe6d:	41 0f 95 c6          	setne  %r14b
  5abe71:	4d 01 d6             	add    %r10,%r14
  5abe74:	48 83 c2 04          	add    $0x4,%rdx
  5abe78:	48 81 c7 60 02 00 00 	add    $0x260,%rdi
  5abe7f:	48 39 d6             	cmp    %rdx,%rsi
  5abe82:	75 ac                	jne    5abe30 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1de0>
  5abe84:	48 85 c9             	test   %rcx,%rcx
  5abe87:	74 31                	je     5abeba <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1e6a>
  5abe89:	48 69 d2 98 00 00 00 	imul   $0x98,%rdx,%rdx
  5abe90:	48 01 c2             	add    %rax,%rdx
  5abe93:	48 69 c9 98 00 00 00 	imul   $0x98,%rcx,%rcx
  5abe9a:	31 f6                	xor    %esi,%esi
  5abe9c:	0f 1f 40 00          	nopl   0x0(%rax)
  5abea0:	31 ff                	xor    %edi,%edi
  5abea2:	48 83 3c 32 ff       	cmpq   $0xffffffffffffffff,(%rdx,%rsi,1)
  5abea7:	40 0f 95 c7          	setne  %dil
  5abeab:	49 01 fe             	add    %rdi,%r14
  5abeae:	48 81 c6 98 00 00 00 	add    $0x98,%rsi
  5abeb5:	48 39 f1             	cmp    %rsi,%rcx
  5abeb8:	75 e6                	jne    5abea0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1e50>
  5abeba:	49 89 c7             	mov    %rax,%r15
  5abebd:	4d 85 f6             	test   %r14,%r14
  5abec0:	74 5b                	je     5abf1d <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1ecd>
  5abec2:	4c 89 f0             	mov    %r14,%rax
  5abec5:	48 c1 e0 04          	shl    $0x4,%rax
  5abec9:	48 8d 1c 80          	lea    (%rax,%rax,4),%rbx
  5abecd:	ff 15 cd e1 53 00    	call   *0x53e1cd(%rip)        # aea0a0 <_DYNAMIC+0x340>
  5abed3:	be 08 00 00 00       	mov    $0x8,%esi
  5abed8:	48 89 df             	mov    %rbx,%rdi
  5abedb:	ff 15 bf e0 53 00    	call   *0x53e0bf(%rip)        # ae9fa0 <_DYNAMIC+0x240>
  5abee1:	48 85 c0             	test   %rax,%rax
  5abee4:	75 3f                	jne    5abf25 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1ed5>
  5abee6:	bf 08 00 00 00       	mov    $0x8,%edi
  5abeeb:	48 89 de             	mov    %rbx,%rsi
  5abeee:	ff 15 b4 e1 53 00    	call   *0x53e1b4(%rip)        # aea0a8 <_DYNAMIC+0x348>
  5abef4:	e9 4d 3d 00 00       	jmp    5afc46 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5bf6>
  5abef9:	0f 10 84 24 a8 00 00 	movups 0xa8(%rsp),%xmm0
  5abf00:	00 
  5abf01:	48 8b 8c 24 88 00 00 	mov    0x88(%rsp),%rcx
  5abf08:	00 
  5abf09:	48 c7 01 1f 00 00 00 	movq   $0x1f,(%rcx)
  5abf10:	48 89 41 08          	mov    %rax,0x8(%rcx)
  5abf14:	0f 11 41 10          	movups %xmm0,0x10(%rcx)
  5abf18:	e9 0d 28 00 00       	jmp    5ae72a <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x46da>
  5abf1d:	b8 08 00 00 00       	mov    $0x8,%eax
  5abf22:	45 31 f6             	xor    %r14d,%r14d
  5abf25:	4c 89 b4 24 28 05 00 	mov    %r14,0x528(%rsp)
  5abf2c:	00 
  5abf2d:	48 89 84 24 30 05 00 	mov    %rax,0x530(%rsp)
  5abf34:	00 
  5abf35:	48 c7 84 24 38 05 00 	movq   $0x0,0x538(%rsp)
  5abf3c:	00 00 00 00 00 
  5abf41:	49 8d 44 24 01       	lea    0x1(%r12),%rax
  5abf46:	48 8d 1c 85 00 00 00 	lea    0x0(,%rax,4),%rbx
  5abf4d:	00 
  5abf4e:	ff 15 4c e1 53 00    	call   *0x53e14c(%rip)        # aea0a0 <_DYNAMIC+0x340>
  5abf54:	be 04 00 00 00       	mov    $0x4,%esi
  5abf59:	48 89 df             	mov    %rbx,%rdi
  5abf5c:	ff 15 56 e0 53 00    	call   *0x53e056(%rip)        # ae9fb8 <_DYNAMIC+0x258>
  5abf62:	48 89 84 24 48 02 00 	mov    %rax,0x248(%rsp)
  5abf69:	00 
  5abf6a:	48 85 c0             	test   %rax,%rax
  5abf6d:	0f 84 2b 3c 00 00    	je     5afb9e <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5b4e>
  5abf73:	48 89 9c 24 d0 02 00 	mov    %rbx,0x2d0(%rsp)
  5abf7a:	00 
  5abf7b:	48 8b 84 24 10 02 00 	mov    0x210(%rsp),%rax
  5abf82:	00 
  5abf83:	4c 01 f8             	add    %r15,%rax
  5abf86:	4c 89 bc 24 00 04 00 	mov    %r15,0x400(%rsp)
  5abf8d:	00 
  5abf8e:	4c 89 bc 24 08 04 00 	mov    %r15,0x408(%rsp)
  5abf95:	00 
  5abf96:	48 8b 4c 24 70       	mov    0x70(%rsp),%rcx
  5abf9b:	48 89 8c 24 10 04 00 	mov    %rcx,0x410(%rsp)
  5abfa2:	00 
  5abfa3:	48 89 84 24 10 02 00 	mov    %rax,0x210(%rsp)
  5abfaa:	00 
  5abfab:	48 89 84 24 18 04 00 	mov    %rax,0x418(%rsp)
  5abfb2:	00 
  5abfb3:	48 c7 84 24 20 04 00 	movq   $0x0,0x420(%rsp)
  5abfba:	00 00 00 00 00 
  5abfbf:	4d 85 e4             	test   %r12,%r12
  5abfc2:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  5abfc7:	0f 84 cd 13 00 00    	je     5ad39a <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x334a>
  5abfcd:	4c 89 fe             	mov    %r15,%rsi
  5abfd0:	48 05 48 08 00 00    	add    $0x848,%rax
  5abfd6:	48 89 44 24 60       	mov    %rax,0x60(%rsp)
  5abfdb:	45 31 f6             	xor    %r14d,%r14d
  5abfde:	48 8d 05 ab cb 50 00 	lea    0x50cbab(%rip),%rax        # ab8b90 <anon.2a25786c1a741fd89e690b6b2ddad436.26.llvm.18021777786862421399+0x228>
  5abfe5:	48 89 84 24 c0 04 00 	mov    %rax,0x4c0(%rsp)
  5abfec:	00 
  5abfed:	41 bf 01 00 00 00    	mov    $0x1,%r15d
  5abff3:	48 8d 05 c6 cc 50 00 	lea    0x50ccc6(%rip),%rax        # ab8cc0 <anon.2a25786c1a741fd89e690b6b2ddad436.63.llvm.18021777786862421399+0x88>
  5abffa:	48 89 84 24 b8 04 00 	mov    %rax,0x4b8(%rsp)
  5ac001:	00 
  5ac002:	31 c0                	xor    %eax,%eax
  5ac004:	eb 43                	jmp    5ac049 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1ff9>
  5ac006:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  5ac00d:	00 00 00 
  5ac010:	0f b6 44 24 08       	movzbl 0x8(%rsp),%eax
  5ac015:	48 8b 8c 24 d8 04 00 	mov    0x4d8(%rsp),%rcx
  5ac01c:	00 
  5ac01d:	48 01 c1             	add    %rax,%rcx
  5ac020:	48 89 c8             	mov    %rcx,%rax
  5ac023:	4c 8b 6c 24 58       	mov    0x58(%rsp),%r13
  5ac028:	4c 8b b4 24 d0 04 00 	mov    0x4d0(%rsp),%r14
  5ac02f:	00 
  5ac030:	48 8b 8c 24 f8 01 00 	mov    0x1f8(%rsp),%rcx
  5ac037:	00 
  5ac038:	48 89 ce             	mov    %rcx,%rsi
  5ac03b:	48 3b 8c 24 10 02 00 	cmp    0x210(%rsp),%rcx
  5ac042:	00 
  5ac043:	0f 84 53 13 00 00    	je     5ad39c <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x334c>
  5ac049:	48 8d 8e 98 00 00 00 	lea    0x98(%rsi),%rcx
  5ac050:	48 89 8c 24 08 04 00 	mov    %rcx,0x408(%rsp)
  5ac057:	00 
  5ac058:	48 8b 1e             	mov    (%rsi),%rbx
  5ac05b:	48 83 fb fe          	cmp    $0xfffffffffffffffe,%rbx
  5ac05f:	0f 84 37 13 00 00    	je     5ad39c <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x334c>
  5ac065:	48 89 8c 24 f8 01 00 	mov    %rcx,0x1f8(%rsp)
  5ac06c:	00 
  5ac06d:	48 89 84 24 d8 04 00 	mov    %rax,0x4d8(%rsp)
  5ac074:	00 
  5ac075:	48 83 c6 08          	add    $0x8,%rsi
  5ac079:	ba 90 00 00 00       	mov    $0x90,%edx
  5ac07e:	48 8d bc 24 a8 00 00 	lea    0xa8(%rsp),%rdi
  5ac085:	00 
  5ac086:	ff 15 74 df 53 00    	call   *0x53df74(%rip)        # aea000 <memcpy@GLIBC_2.14>
  5ac08c:	49 8d 46 01          	lea    0x1(%r14),%rax
  5ac090:	48 89 84 24 d0 04 00 	mov    %rax,0x4d0(%rsp)
  5ac097:	00 
  5ac098:	48 89 84 24 20 04 00 	mov    %rax,0x420(%rsp)
  5ac09f:	00 
  5ac0a0:	48 89 9c 24 a0 00 00 	mov    %rbx,0xa0(%rsp)
  5ac0a7:	00 
  5ac0a8:	0f b6 b4 24 b8 00 00 	movzbl 0xb8(%rsp),%esi
  5ac0af:	00 
  5ac0b0:	8b 84 24 bc 00 00 00 	mov    0xbc(%rsp),%eax
  5ac0b7:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
  5ac0bc:	48 ff c0             	inc    %rax
  5ac0bf:	40 84 f6             	test   %sil,%sil
  5ac0c2:	b9 00 00 00 00       	mov    $0x0,%ecx
  5ac0c7:	48 0f 45 c8          	cmovne %rax,%rcx
  5ac0cb:	4c 39 e1             	cmp    %r12,%rcx
  5ac0ce:	0f 87 fa 38 00 00    	ja     5af9ce <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x597e>
  5ac0d4:	48 8b 94 24 48 02 00 	mov    0x248(%rsp),%rdx
  5ac0db:	00 
  5ac0dc:	8b 04 8a             	mov    (%rdx,%rcx,4),%eax
  5ac0df:	48 89 84 24 80 02 00 	mov    %rax,0x280(%rsp)
  5ac0e6:	00 
  5ac0e7:	ff c0                	inc    %eax
  5ac0e9:	89 04 8a             	mov    %eax,(%rdx,%rcx,4)
  5ac0ec:	40 84 f6             	test   %sil,%sil
  5ac0ef:	40 88 74 24 50       	mov    %sil,0x50(%rsp)
  5ac0f4:	74 52                	je     5ac148 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x20f8>
  5ac0f6:	48 8b b4 24 28 02 00 	mov    0x228(%rsp),%rsi
  5ac0fd:	00 
  5ac0fe:	48 8b 54 24 18       	mov    0x18(%rsp),%rdx
  5ac103:	48 39 d6             	cmp    %rdx,%rsi
  5ac106:	0f 86 99 39 00 00    	jbe    5afaa5 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5a55>
  5ac10c:	48 8b 84 24 20 02 00 	mov    0x220(%rsp),%rax
  5ac113:	00 
  5ac114:	48 8d 14 92          	lea    (%rdx,%rdx,4),%rdx
  5ac118:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  5ac11c:	48 89 44 24 20       	mov    %rax,0x20(%rsp)
  5ac121:	b8 01 00 00 00       	mov    $0x1,%eax
  5ac126:	80 bc 24 98 00 00 00 	cmpb   $0x0,0x98(%rsp)
  5ac12d:	00 
  5ac12e:	75 24                	jne    5ac154 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2104>
  5ac130:	31 c9                	xor    %ecx,%ecx
  5ac132:	48 8b 94 24 c0 06 00 	mov    0x6c0(%rsp),%rdx
  5ac139:	00 
  5ac13a:	48 85 d2             	test   %rdx,%rdx
  5ac13d:	0f 85 f9 00 00 00    	jne    5ac23c <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x21ec>
  5ac143:	e9 de 01 00 00       	jmp    5ac326 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x22d6>
  5ac148:	31 c0                	xor    %eax,%eax
  5ac14a:	80 bc 24 98 00 00 00 	cmpb   $0x0,0x98(%rsp)
  5ac151:	00 
  5ac152:	74 dc                	je     5ac130 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x20e0>
  5ac154:	48 8b 94 24 10 05 00 	mov    0x510(%rsp),%rdx
  5ac15b:	00 
  5ac15c:	48 85 d2             	test   %rdx,%rdx
  5ac15f:	0f 84 a9 00 00 00    	je     5ac20e <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x21be>
  5ac165:	48 8b b4 24 18 05 00 	mov    0x518(%rsp),%rsi
  5ac16c:	00 
  5ac16d:	48 85 c0             	test   %rax,%rax
  5ac170:	74 7e                	je     5ac1f0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x21a0>
  5ac172:	44 0f b7 82 12 01 00 	movzwl 0x112(%rdx),%r8d
  5ac179:	00 
  5ac17a:	45 89 c1             	mov    %r8d,%r9d
  5ac17d:	41 c1 e1 04          	shl    $0x4,%r9d
  5ac181:	48 c7 c7 ff ff ff ff 	mov    $0xffffffffffffffff,%rdi
  5ac188:	49 89 d2             	mov    %rdx,%r10
  5ac18b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
  5ac190:	4d 85 c9             	test   %r9,%r9
  5ac193:	74 39                	je     5ac1ce <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x217e>
  5ac195:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  5ac19a:	4d 3b 5a 08          	cmp    0x8(%r10),%r11
  5ac19e:	41 0f 97 c3          	seta   %r11b
  5ac1a2:	41 80 db 00          	sbb    $0x0,%r11b
  5ac1a6:	41 f6 02 01          	testb  $0x1,(%r10)
  5ac1aa:	4d 8d 52 10          	lea    0x10(%r10),%r10
  5ac1ae:	45 0f b6 db          	movzbl %r11b,%r11d
  5ac1b2:	45 0f 44 df          	cmove  %r15d,%r11d
  5ac1b6:	48 ff c7             	inc    %rdi
  5ac1b9:	49 83 c1 f0          	add    $0xfffffffffffffff0,%r9
  5ac1bd:	41 80 fb 01          	cmp    $0x1,%r11b
  5ac1c1:	74 cd                	je     5ac190 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2140>
  5ac1c3:	45 0f b6 c3          	movzbl %r11b,%r8d
  5ac1c7:	45 85 c0             	test   %r8d,%r8d
  5ac1ca:	74 48                	je     5ac214 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x21c4>
  5ac1cc:	eb 03                	jmp    5ac1d1 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2181>
  5ac1ce:	4c 89 c7             	mov    %r8,%rdi
  5ac1d1:	48 83 ee 01          	sub    $0x1,%rsi
  5ac1d5:	72 37                	jb     5ac20e <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x21be>
  5ac1d7:	48 8b 94 fa 18 01 00 	mov    0x118(%rdx,%rdi,8),%rdx
  5ac1de:	00 
  5ac1df:	eb 91                	jmp    5ac172 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2122>
  5ac1e1:	66 66 66 66 66 66 2e 	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  5ac1e8:	0f 1f 84 00 00 00 00 
  5ac1ef:	00 
  5ac1f0:	66 83 ba 12 01 00 00 	cmpw   $0x0,0x112(%rdx)
  5ac1f7:	00 
  5ac1f8:	74 05                	je     5ac1ff <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x21af>
  5ac1fa:	f6 02 01             	testb  $0x1,(%rdx)
  5ac1fd:	74 13                	je     5ac212 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x21c2>
  5ac1ff:	48 83 ee 01          	sub    $0x1,%rsi
  5ac203:	72 09                	jb     5ac20e <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x21be>
  5ac205:	48 8b 92 18 01 00 00 	mov    0x118(%rdx),%rdx
  5ac20c:	eb e2                	jmp    5ac1f0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x21a0>
  5ac20e:	31 d2                	xor    %edx,%edx
  5ac210:	eb 0a                	jmp    5ac21c <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x21cc>
  5ac212:	31 ff                	xor    %edi,%edi
  5ac214:	48 8b 94 fa b8 00 00 	mov    0xb8(%rdx,%rdi,8),%rdx
  5ac21b:	00 
  5ac21c:	48 8b b4 24 e0 02 00 	mov    0x2e0(%rsp),%rsi
  5ac223:	00 
  5ac224:	48 3b 14 ce          	cmp    (%rsi,%rcx,8),%rdx
  5ac228:	0f 94 c1             	sete   %cl
  5ac22b:	48 8b 94 24 c0 06 00 	mov    0x6c0(%rsp),%rdx
  5ac232:	00 
  5ac233:	48 85 d2             	test   %rdx,%rdx
  5ac236:	0f 84 ea 00 00 00    	je     5ac326 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x22d6>
  5ac23c:	48 8b b4 24 c8 06 00 	mov    0x6c8(%rsp),%rsi
  5ac243:	00 
  5ac244:	44 0f b7 8a 12 01 00 	movzwl 0x112(%rdx),%r9d
  5ac24b:	00 
  5ac24c:	45 89 ca             	mov    %r9d,%r10d
  5ac24f:	41 c1 e2 04          	shl    $0x4,%r10d
  5ac253:	48 c7 c7 ff ff ff ff 	mov    $0xffffffffffffffff,%rdi
  5ac25a:	45 31 c0             	xor    %r8d,%r8d
  5ac25d:	0f 1f 00             	nopl   (%rax)
  5ac260:	4d 39 c2             	cmp    %r8,%r10
  5ac263:	74 2b                	je     5ac290 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2240>
  5ac265:	4c 3b b4 fa c0 00 00 	cmp    0xc0(%rdx,%rdi,8),%r14
  5ac26c:	00 
  5ac26d:	41 0f 97 c3          	seta   %r11b
  5ac271:	41 80 db 00          	sbb    $0x0,%r11b
  5ac275:	49 83 c0 10          	add    $0x10,%r8
  5ac279:	48 ff c7             	inc    %rdi
  5ac27c:	41 80 fb 01          	cmp    $0x1,%r11b
  5ac280:	74 de                	je     5ac260 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2210>
  5ac282:	45 0f b6 cb          	movzbl %r11b,%r9d
  5ac286:	45 85 c9             	test   %r9d,%r9d
  5ac289:	75 08                	jne    5ac293 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2243>
  5ac28b:	eb 23                	jmp    5ac2b0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2260>
  5ac28d:	0f 1f 00             	nopl   (%rax)
  5ac290:	4c 89 cf             	mov    %r9,%rdi
  5ac293:	48 83 ee 01          	sub    $0x1,%rsi
  5ac297:	0f 82 89 00 00 00    	jb     5ac326 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x22d6>
  5ac29d:	48 8b 94 fa 18 01 00 	mov    0x118(%rdx,%rdi,8),%rdx
  5ac2a4:	00 
  5ac2a5:	eb 9d                	jmp    5ac244 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x21f4>
  5ac2a7:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
  5ac2ae:	00 00 
  5ac2b0:	80 bc 24 98 00 00 00 	cmpb   $0x0,0x98(%rsp)
  5ac2b7:	00 
  5ac2b8:	0f 84 42 03 00 00    	je     5ac600 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x25b0>
  5ac2be:	4a 8b 4c 02 f8       	mov    -0x8(%rdx,%r8,1),%rcx
  5ac2c3:	48 8b 49 08          	mov    0x8(%rcx),%rcx
  5ac2c7:	0f b6 94 24 30 01 00 	movzbl 0x130(%rsp),%edx
  5ac2ce:	00 
  5ac2cf:	48 89 84 24 90 01 00 	mov    %rax,0x190(%rsp)
  5ac2d6:	00 
  5ac2d7:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  5ac2dc:	48 89 84 24 98 01 00 	mov    %rax,0x198(%rsp)
  5ac2e3:	00 
  5ac2e4:	48 89 8c 24 a0 01 00 	mov    %rcx,0x1a0(%rsp)
  5ac2eb:	00 
  5ac2ec:	88 94 24 a8 01 00 00 	mov    %dl,0x1a8(%rsp)
  5ac2f3:	48 8b b4 24 c0 05 00 	mov    0x5c0(%rsp),%rsi
  5ac2fa:	00 
  5ac2fb:	48 85 f6             	test   %rsi,%rsi
  5ac2fe:	0f 84 14 01 00 00    	je     5ac418 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x23c8>
  5ac304:	48 8b 94 24 c8 05 00 	mov    0x5c8(%rsp),%rdx
  5ac30b:	00 
  5ac30c:	48 8d bc 24 00 03 00 	lea    0x300(%rsp),%rdi
  5ac313:	00 
  5ac314:	48 8d 8c 24 90 01 00 	lea    0x190(%rsp),%rcx
  5ac31b:	00 
  5ac31c:	e8 3f b3 0c 00       	call   677660 <_RINvMs_NtNtNtCscdodAO9FK5_5alloc11collections5btree6searchINtNtB7_4node7NodeRefNtNtBX_6marker3MutTINtNtCs4NRVxsYgnAr_4core6option6OptionyENtNtCs6gaF1xUz9Bf_4gpui4list6ListIdNtNtB2g_7element8NodeKindEjNtB1h_14LeafOrInternalE11search_treeB1x_EB2g_>
  5ac321:	e9 e4 00 00 00       	jmp    5ac40a <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x23ba>
  5ac326:	48 8b 94 24 a8 06 00 	mov    0x6a8(%rsp),%rdx
  5ac32d:	00 
  5ac32e:	48 85 d2             	test   %rdx,%rdx
  5ac331:	0f 84 e8 00 00 00    	je     5ac41f <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x23cf>
  5ac337:	48 8b b4 24 b0 06 00 	mov    0x6b0(%rsp),%rsi
  5ac33e:	00 
  5ac33f:	44 0f b7 82 ba 00 00 	movzwl 0xba(%rdx),%r8d
  5ac346:	00 
  5ac347:	45 89 c1             	mov    %r8d,%r9d
  5ac34a:	41 c1 e1 03          	shl    $0x3,%r9d
  5ac34e:	48 c7 c7 ff ff ff ff 	mov    $0xffffffffffffffff,%rdi
  5ac355:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
  5ac35c:	00 00 00 00 
  5ac360:	4d 85 c9             	test   %r9,%r9
  5ac363:	74 25                	je     5ac38a <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x233a>
  5ac365:	4c 3b 74 fa 10       	cmp    0x10(%rdx,%rdi,8),%r14
  5ac36a:	41 0f 97 c2          	seta   %r10b
  5ac36e:	41 80 da 00          	sbb    $0x0,%r10b
  5ac372:	48 ff c7             	inc    %rdi
  5ac375:	49 83 c1 f8          	add    $0xfffffffffffffff8,%r9
  5ac379:	41 80 fa 01          	cmp    $0x1,%r10b
  5ac37d:	74 e1                	je     5ac360 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2310>
  5ac37f:	45 0f b6 c2          	movzbl %r10b,%r8d
  5ac383:	45 85 c0             	test   %r8d,%r8d
  5ac386:	75 05                	jne    5ac38d <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x233d>
  5ac388:	eb 17                	jmp    5ac3a1 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2351>
  5ac38a:	4c 89 c7             	mov    %r8,%rdi
  5ac38d:	48 83 ee 01          	sub    $0x1,%rsi
  5ac391:	0f 82 88 00 00 00    	jb     5ac41f <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x23cf>
  5ac397:	48 8b 94 fa c0 00 00 	mov    0xc0(%rdx,%rdi,8),%rdx
  5ac39e:	00 
  5ac39f:	eb 9e                	jmp    5ac33f <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x22ef>
  5ac3a1:	80 bc 24 98 00 00 00 	cmpb   $0x0,0x98(%rsp)
  5ac3a8:	00 
  5ac3a9:	0f 84 51 02 00 00    	je     5ac600 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x25b0>
  5ac3af:	48 8b 4c fa 60       	mov    0x60(%rdx,%rdi,8),%rcx
  5ac3b4:	0f b6 94 24 30 01 00 	movzbl 0x130(%rsp),%edx
  5ac3bb:	00 
  5ac3bc:	48 89 84 24 90 01 00 	mov    %rax,0x190(%rsp)
  5ac3c3:	00 
  5ac3c4:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  5ac3c9:	48 89 84 24 98 01 00 	mov    %rax,0x198(%rsp)
  5ac3d0:	00 
  5ac3d1:	48 89 8c 24 a0 01 00 	mov    %rcx,0x1a0(%rsp)
  5ac3d8:	00 
  5ac3d9:	88 94 24 a8 01 00 00 	mov    %dl,0x1a8(%rsp)
  5ac3e0:	48 8b b4 24 d8 05 00 	mov    0x5d8(%rsp),%rsi
  5ac3e7:	00 
  5ac3e8:	48 85 f6             	test   %rsi,%rsi
  5ac3eb:	74 2b                	je     5ac418 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x23c8>
  5ac3ed:	48 8b 94 24 e0 05 00 	mov    0x5e0(%rsp),%rdx
  5ac3f4:	00 
  5ac3f5:	48 8d bc 24 00 03 00 	lea    0x300(%rsp),%rdi
  5ac3fc:	00 
  5ac3fd:	48 8d 8c 24 90 01 00 	lea    0x190(%rsp),%rcx
  5ac404:	00 
  5ac405:	e8 56 b2 0c 00       	call   677660 <_RINvMs_NtNtNtCscdodAO9FK5_5alloc11collections5btree6searchINtNtB7_4node7NodeRefNtNtBX_6marker3MutTINtNtCs4NRVxsYgnAr_4core6option6OptionyENtNtCs6gaF1xUz9Bf_4gpui4list6ListIdNtNtB2g_7element8NodeKindEjNtB1h_14LeafOrInternalE11search_treeB1x_EB2g_>
  5ac40a:	80 bc 24 00 03 00 00 	cmpb   $0x0,0x300(%rsp)
  5ac411:	00 
  5ac412:	0f 84 92 00 00 00    	je     5ac4aa <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x245a>
  5ac418:	31 c0                	xor    %eax,%eax
  5ac41a:	e9 a5 00 00 00       	jmp    5ac4c4 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2474>
  5ac41f:	84 c9                	test   %cl,%cl
  5ac421:	0f 84 d9 01 00 00    	je     5ac600 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x25b0>
  5ac427:	0f b6 8c 24 30 01 00 	movzbl 0x130(%rsp),%ecx
  5ac42e:	00 
  5ac42f:	48 89 84 24 90 01 00 	mov    %rax,0x190(%rsp)
  5ac436:	00 
  5ac437:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  5ac43c:	48 89 84 24 98 01 00 	mov    %rax,0x198(%rsp)
  5ac443:	00 
  5ac444:	48 8b 84 24 80 02 00 	mov    0x280(%rsp),%rax
  5ac44b:	00 
  5ac44c:	89 84 24 a0 01 00 00 	mov    %eax,0x1a0(%rsp)
  5ac453:	88 8c 24 a4 01 00 00 	mov    %cl,0x1a4(%rsp)
  5ac45a:	48 8b b4 24 a8 05 00 	mov    0x5a8(%rsp),%rsi
  5ac461:	00 
  5ac462:	48 85 f6             	test   %rsi,%rsi
  5ac465:	74 b1                	je     5ac418 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x23c8>
  5ac467:	48 8b 94 24 b0 05 00 	mov    0x5b0(%rsp),%rdx
  5ac46e:	00 
  5ac46f:	48 8d bc 24 00 03 00 	lea    0x300(%rsp),%rdi
  5ac476:	00 
  5ac477:	48 8d 8c 24 90 01 00 	lea    0x190(%rsp),%rcx
  5ac47e:	00 
  5ac47f:	e8 8c b3 0c 00       	call   677810 <_RINvMs_NtNtNtCscdodAO9FK5_5alloc11collections5btree6searchINtNtB7_4node7NodeRefNtNtBX_6marker3MutTINtNtCs4NRVxsYgnAr_4core6option6OptionyEmNtNtCs6gaF1xUz9Bf_4gpui7element8NodeKindEjNtB1h_14LeafOrInternalE11search_treeB1x_EB2h_>
  5ac484:	80 bc 24 00 03 00 00 	cmpb   $0x0,0x300(%rsp)
  5ac48b:	00 
  5ac48c:	75 8a                	jne    5ac418 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x23c8>
  5ac48e:	48 8b 84 24 08 03 00 	mov    0x308(%rsp),%rax
  5ac495:	00 
  5ac496:	48 8b 8c 24 18 03 00 	mov    0x318(%rsp),%rcx
  5ac49d:	00 
  5ac49e:	48 8d 04 c8          	lea    (%rax,%rcx,8),%rax
  5ac4a2:	48 05 10 01 00 00    	add    $0x110,%rax
  5ac4a8:	eb 1a                	jmp    5ac4c4 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2474>
  5ac4aa:	48 8b 84 24 08 03 00 	mov    0x308(%rsp),%rax
  5ac4b1:	00 
  5ac4b2:	48 8b 8c 24 18 03 00 	mov    0x318(%rsp),%rcx
  5ac4b9:	00 
  5ac4ba:	48 8d 04 c8          	lea    (%rax,%rcx,8),%rax
  5ac4be:	48 05 68 01 00 00    	add    $0x168,%rax
  5ac4c4:	48 85 c0             	test   %rax,%rax
  5ac4c7:	0f 84 33 01 00 00    	je     5ac600 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x25b0>
  5ac4cd:	48 8b b4 24 98 04 00 	mov    0x498(%rsp),%rsi
  5ac4d4:	00 
  5ac4d5:	48 8b 08             	mov    (%rax),%rcx
  5ac4d8:	48 39 f1             	cmp    %rsi,%rcx
  5ac4db:	0f 83 b0 35 00 00    	jae    5afa91 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5a41>
  5ac4e1:	48 8b 94 24 90 04 00 	mov    0x490(%rsp),%rdx
  5ac4e8:	00 
  5ac4e9:	48 8d 0c 89          	lea    (%rcx,%rcx,4),%rcx
  5ac4ed:	4c 8b 04 ca          	mov    (%rdx,%rcx,8),%r8
  5ac4f1:	4c 8b 7c ca 08       	mov    0x8(%rdx,%rcx,8),%r15
  5ac4f6:	48 8b 74 ca 10       	mov    0x10(%rdx,%rcx,8),%rsi
  5ac4fb:	48 89 74 24 58       	mov    %rsi,0x58(%rsp)
  5ac500:	8b 7c ca 20          	mov    0x20(%rdx,%rcx,8),%edi
  5ac504:	8b 74 ca 24          	mov    0x24(%rdx,%rcx,8),%esi
  5ac508:	89 b4 24 90 00 00 00 	mov    %esi,0x90(%rsp)
  5ac50f:	48 c7 04 ca 00 00 00 	movq   $0x0,(%rdx,%rcx,8)
  5ac516:	00 
  5ac517:	4c 89 84 24 28 04 00 	mov    %r8,0x428(%rsp)
  5ac51e:	00 
  5ac51f:	4d 85 c0             	test   %r8,%r8
  5ac522:	0f 84 d8 00 00 00    	je     5ac600 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x25b0>
  5ac528:	48 8b b4 24 b0 02 00 	mov    0x2b0(%rsp),%rsi
  5ac52f:	00 
  5ac530:	49 39 f6             	cmp    %rsi,%r14
  5ac533:	0f 83 15 36 00 00    	jae    5afb4e <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5afe>
  5ac539:	48 8b 8c 24 a8 02 00 	mov    0x2a8(%rsp),%rcx
  5ac540:	00 
  5ac541:	8b 94 24 90 00 00 00 	mov    0x90(%rsp),%edx
  5ac548:	42 3b 14 b1          	cmp    (%rcx,%r14,4),%edx
  5ac54c:	75 74                	jne    5ac5c2 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2572>
  5ac54e:	48 8b 94 24 40 05 00 	mov    0x540(%rsp),%rdx
  5ac555:	00 
  5ac556:	48 8d 0d db f4 ac ff 	lea    -0x530b25(%rip),%rcx        # 7ba38 <anon.5f884de6e78125e25881320d811d32df.113.llvm.17146438997930651657+0x8>
  5ac55d:	48 85 d2             	test   %rdx,%rdx
  5ac560:	48 8b ac 24 38 04 00 	mov    0x438(%rsp),%rbp
  5ac567:	00 
  5ac568:	4c 89 bc 24 78 02 00 	mov    %r15,0x278(%rsp)
  5ac56f:	00 
  5ac570:	0f 84 a1 0d 00 00    	je     5ad317 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x32c7>
  5ac576:	48 8b 00             	mov    (%rax),%rax
  5ac579:	48 83 fa 02          	cmp    $0x2,%rdx
  5ac57d:	0f 85 77 0d 00 00    	jne    5ad2fa <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x32aa>
  5ac583:	48 8b b4 24 60 05 00 	mov    0x560(%rsp),%rsi
  5ac58a:	00 
  5ac58b:	48 39 f0             	cmp    %rsi,%rax
  5ac58e:	0f 83 92 36 00 00    	jae    5afc26 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5bd6>
  5ac594:	48 8b b4 24 50 05 00 	mov    0x550(%rsp),%rsi
  5ac59b:	00 
  5ac59c:	48 8b 8c 24 58 05 00 	mov    0x558(%rsp),%rcx
  5ac5a3:	00 
  5ac5a4:	0f b6 04 01          	movzbl (%rcx,%rax,1),%eax
  5ac5a8:	48 39 c6             	cmp    %rax,%rsi
  5ac5ab:	0f 86 66 36 00 00    	jbe    5afc17 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5bc7>
  5ac5b1:	48 6b c8 58          	imul   $0x58,%rax,%rcx
  5ac5b5:	48 03 8c 24 48 05 00 	add    0x548(%rsp),%rcx
  5ac5bc:	00 
  5ac5bd:	e9 55 0d 00 00       	jmp    5ad317 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x32c7>
  5ac5c2:	4d 85 ff             	test   %r15,%r15
  5ac5c5:	74 39                	je     5ac600 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x25b0>
  5ac5c7:	48 8b 44 24 58       	mov    0x58(%rsp),%rax
  5ac5cc:	48 8b 00             	mov    (%rax),%rax
  5ac5cf:	48 85 c0             	test   %rax,%rax
  5ac5d2:	74 05                	je     5ac5d9 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2589>
  5ac5d4:	4c 89 ff             	mov    %r15,%rdi
  5ac5d7:	ff d0                	call   *%rax
  5ac5d9:	48 8b 44 24 58       	mov    0x58(%rsp),%rax
  5ac5de:	48 8b 70 08          	mov    0x8(%rax),%rsi
  5ac5e2:	48 85 f6             	test   %rsi,%rsi
  5ac5e5:	74 19                	je     5ac600 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x25b0>
  5ac5e7:	48 8b 44 24 58       	mov    0x58(%rsp),%rax
  5ac5ec:	48 8b 50 10          	mov    0x10(%rax),%rdx
  5ac5f0:	4c 89 ff             	mov    %r15,%rdi
  5ac5f3:	ff 15 af d9 53 00    	call   *0x53d9af(%rip)        # ae9fa8 <_DYNAMIC+0x248>
  5ac5f9:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  5ac600:	48 8d 8c 24 c0 00 00 	lea    0xc0(%rsp),%rcx
  5ac607:	00 
  5ac608:	48 8b 41 50          	mov    0x50(%rcx),%rax
  5ac60c:	48 89 84 24 a0 06 00 	mov    %rax,0x6a0(%rsp)
  5ac613:	00 
  5ac614:	0f 10 41 40          	movups 0x40(%rcx),%xmm0
  5ac618:	0f 29 84 24 90 06 00 	movaps %xmm0,0x690(%rsp)
  5ac61f:	00 
  5ac620:	f3 0f 6f 01          	movdqu (%rcx),%xmm0
  5ac624:	f3 0f 6f 49 10       	movdqu 0x10(%rcx),%xmm1
  5ac629:	f3 0f 6f 51 20       	movdqu 0x20(%rcx),%xmm2
  5ac62e:	0f 10 59 30          	movups 0x30(%rcx),%xmm3
  5ac632:	0f 29 9c 24 80 06 00 	movaps %xmm3,0x680(%rsp)
  5ac639:	00 
  5ac63a:	66 0f 7f 94 24 70 06 	movdqa %xmm2,0x670(%rsp)
  5ac641:	00 00 
  5ac643:	66 0f 7f 8c 24 60 06 	movdqa %xmm1,0x660(%rsp)
  5ac64a:	00 00 
  5ac64c:	66 0f 7f 84 24 50 06 	movdqa %xmm0,0x650(%rsp)
  5ac653:	00 00 
  5ac655:	48 8b 4c 24 10       	mov    0x10(%rsp),%rcx
  5ac65a:	4c 8b b9 e0 07 00 00 	mov    0x7e0(%rcx),%r15
  5ac661:	49 8d 47 01          	lea    0x1(%r15),%rax
  5ac665:	48 89 81 e0 07 00 00 	mov    %rax,0x7e0(%rcx)
  5ac66c:	48 8b 7c 24 60       	mov    0x60(%rsp),%rdi
  5ac671:	4c 89 fe             	mov    %r15,%rsi
  5ac674:	e8 a7 c6 17 00       	call   728d20 <_RNvMsi_NtNtNtCscdodAO9FK5_5alloc11collections5btree3mapINtB5_8BTreeMapyNtNtB7_7set_val9SetValZSTE6insertCs6gaF1xUz9Bf_4gpui>
  5ac679:	4d 85 ff             	test   %r15,%r15
  5ac67c:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
  5ac681:	0f 84 ee 30 00 00    	je     5af775 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5725>
  5ac687:	3d a0 86 01 00       	cmp    $0x186a0,%eax
  5ac68c:	0f 93 c0             	setae  %al
  5ac68f:	22 44 24 50          	and    0x50(%rsp),%al
  5ac693:	3c 01                	cmp    $0x1,%al
  5ac695:	0f 84 ad 31 00 00    	je     5af848 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x57f8>
  5ac69b:	48 8b b4 24 b0 02 00 	mov    0x2b0(%rsp),%rsi
  5ac6a2:	00 
  5ac6a3:	49 39 f6             	cmp    %rsi,%r14
  5ac6a6:	0f 83 3b 33 00 00    	jae    5af9e7 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5997>
  5ac6ac:	0f b6 bc 24 30 01 00 	movzbl 0x130(%rsp),%edi
  5ac6b3:	00 
  5ac6b4:	48 8b 84 24 a8 02 00 	mov    0x2a8(%rsp),%rax
  5ac6bb:	00 
  5ac6bc:	42 8b 04 b0          	mov    (%rax,%r14,4),%eax
  5ac6c0:	89 84 24 90 00 00 00 	mov    %eax,0x90(%rsp)
  5ac6c7:	b0 01                	mov    $0x1,%al
  5ac6c9:	89 84 24 08 02 00 00 	mov    %eax,0x208(%rsp)
  5ac6d0:	48 c7 84 24 28 04 00 	movq   $0x0,0x428(%rsp)
  5ac6d7:	00 00 00 00 00 
  5ac6dc:	48 89 ac 24 78 02 00 	mov    %rbp,0x278(%rsp)
  5ac6e3:	00 
  5ac6e4:	4c 89 6c 24 58       	mov    %r13,0x58(%rsp)
  5ac6e9:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
  5ac6ee:	48 89 44 24 30       	mov    %rax,0x30(%rsp)
  5ac6f3:	48 c7 44 24 40 00 00 	movq   $0x0,0x40(%rsp)
  5ac6fa:	00 00 
  5ac6fc:	48 8b ac 24 38 04 00 	mov    0x438(%rsp),%rbp
  5ac703:	00 
  5ac704:	89 f8                	mov    %edi,%eax
  5ac706:	83 e0 07             	and    $0x7,%eax
  5ac709:	48 89 84 24 68 02 00 	mov    %rax,0x268(%rsp)
  5ac710:	00 
  5ac711:	83 f8 06             	cmp    $0x6,%eax
  5ac714:	0f 83 09 05 00 00    	jae    5acc23 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2bd3>
  5ac71a:	c1 ef 03             	shr    $0x3,%edi
  5ac71d:	74 76                	je     5ac795 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2745>
  5ac71f:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  5ac724:	48 8b b0 e0 02 00 00 	mov    0x2e0(%rax),%rsi
  5ac72b:	ff cf                	dec    %edi
  5ac72d:	48 39 fe             	cmp    %rdi,%rsi
  5ac730:	0f 86 f3 32 00 00    	jbe    5afa29 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x59d9>
  5ac736:	48 8b 80 d8 02 00 00 	mov    0x2d8(%rax),%rax
  5ac73d:	48 8d 0c bf          	lea    (%rdi,%rdi,4),%rcx
  5ac741:	48 c1 e1 04          	shl    $0x4,%rcx
  5ac745:	0f 10 44 08 40       	movups 0x40(%rax,%rcx,1),%xmm0
  5ac74a:	0f 29 84 24 f0 03 00 	movaps %xmm0,0x3f0(%rsp)
  5ac751:	00 
  5ac752:	f3 0f 6f 04 08       	movdqu (%rax,%rcx,1),%xmm0
  5ac757:	f3 0f 6f 4c 08 10    	movdqu 0x10(%rax,%rcx,1),%xmm1
  5ac75d:	f3 0f 6f 54 08 20    	movdqu 0x20(%rax,%rcx,1),%xmm2
  5ac763:	0f 10 5c 08 30       	movups 0x30(%rax,%rcx,1),%xmm3
  5ac768:	0f 29 9c 24 e0 03 00 	movaps %xmm3,0x3e0(%rsp)
  5ac76f:	00 
  5ac770:	66 0f 7f 94 24 d0 03 	movdqa %xmm2,0x3d0(%rsp)
  5ac777:	00 00 
  5ac779:	66 0f 7f 8c 24 c0 03 	movdqa %xmm1,0x3c0(%rsp)
  5ac780:	00 00 
  5ac782:	66 0f 7f 84 24 b0 03 	movdqa %xmm0,0x3b0(%rsp)
  5ac789:	00 00 
  5ac78b:	48 c7 04 08 fe ff ff 	movq   $0xfffffffffffffffe,(%rax,%rcx,1)
  5ac792:	ff 
  5ac793:	eb 0c                	jmp    5ac7a1 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2751>
  5ac795:	48 c7 84 24 b0 03 00 	movq   $0xfffffffffffffffe,0x3b0(%rsp)
  5ac79c:	00 fe ff ff ff 
  5ac7a1:	b0 02                	mov    $0x2,%al
  5ac7a3:	48 8b 94 24 20 06 00 	mov    0x620(%rsp),%rdx
  5ac7aa:	00 
  5ac7ab:	48 85 d2             	test   %rdx,%rdx
  5ac7ae:	0f 84 43 01 00 00    	je     5ac8f7 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x28a7>
  5ac7b4:	48 8b b4 24 28 06 00 	mov    0x628(%rsp),%rsi
  5ac7bb:	00 
  5ac7bc:	44 0f b7 82 ba 00 00 	movzwl 0xba(%rdx),%r8d
  5ac7c3:	00 
  5ac7c4:	45 89 c1             	mov    %r8d,%r9d
  5ac7c7:	41 c1 e1 03          	shl    $0x3,%r9d
  5ac7cb:	48 c7 c7 ff ff ff ff 	mov    $0xffffffffffffffff,%rdi
  5ac7d2:	66 66 66 66 66 2e 0f 	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  5ac7d9:	1f 84 00 00 00 00 00 
  5ac7e0:	4d 85 c9             	test   %r9,%r9
  5ac7e3:	74 2b                	je     5ac810 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x27c0>
  5ac7e5:	4c 3b 74 fa 10       	cmp    0x10(%rdx,%rdi,8),%r14
  5ac7ea:	41 0f 97 c2          	seta   %r10b
  5ac7ee:	41 80 da 00          	sbb    $0x0,%r10b
  5ac7f2:	48 ff c7             	inc    %rdi
  5ac7f5:	49 83 c1 f8          	add    $0xfffffffffffffff8,%r9
  5ac7f9:	41 80 fa 01          	cmp    $0x1,%r10b
  5ac7fd:	74 e1                	je     5ac7e0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2790>
  5ac7ff:	45 0f b6 c2          	movzbl %r10b,%r8d
  5ac803:	45 85 c0             	test   %r8d,%r8d
  5ac806:	75 0b                	jne    5ac813 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x27c3>
  5ac808:	eb 26                	jmp    5ac830 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x27e0>
  5ac80a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
  5ac810:	4c 89 c7             	mov    %r8,%rdi
  5ac813:	48 83 ee 01          	sub    $0x1,%rsi
  5ac817:	0f 82 da 00 00 00    	jb     5ac8f7 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x28a7>
  5ac81d:	48 8b 94 fa c0 00 00 	mov    0xc0(%rdx,%rdi,8),%rdx
  5ac824:	00 
  5ac825:	eb 95                	jmp    5ac7bc <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x276c>
  5ac827:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
  5ac82e:	00 00 
  5ac830:	44 8b 4c fa 60       	mov    0x60(%rdx,%rdi,8),%r9d
  5ac835:	48 8b b4 24 80 04 00 	mov    0x480(%rsp),%rsi
  5ac83c:	00 
  5ac83d:	4c 89 8c 24 00 02 00 	mov    %r9,0x200(%rsp)
  5ac844:	00 
  5ac845:	4c 39 ce             	cmp    %r9,%rsi
  5ac848:	0f 86 c1 31 00 00    	jbe    5afa0f <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x59bf>
  5ac84e:	0f b6 54 fa 64       	movzbl 0x64(%rdx,%rdi,8),%edx
  5ac853:	88 94 24 60 02 00 00 	mov    %dl,0x260(%rsp)
  5ac85a:	c7 84 24 70 02 00 00 	movl   $0x0,0x270(%rsp)
  5ac861:	00 00 00 00 
  5ac865:	3c 02                	cmp    $0x2,%al
  5ac867:	0f 84 b2 00 00 00    	je     5ac91f <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x28cf>
  5ac86d:	48 8b 94 24 78 04 00 	mov    0x478(%rsp),%rdx
  5ac874:	00 
  5ac875:	48 8b b4 24 00 02 00 	mov    0x200(%rsp),%rsi
  5ac87c:	00 
  5ac87d:	48 8b 14 f2          	mov    (%rdx,%rsi,8),%rdx
  5ac881:	48 3b 4a 28          	cmp    0x28(%rdx),%rcx
  5ac885:	0f 85 94 00 00 00    	jne    5ac91f <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x28cf>
  5ac88b:	32 84 24 60 02 00 00 	xor    0x260(%rsp),%al
  5ac892:	8b 8c 24 08 02 00 00 	mov    0x208(%rsp),%ecx
  5ac899:	88 4c 24 08          	mov    %cl,0x8(%rsp)
  5ac89d:	a8 01                	test   $0x1,%al
  5ac89f:	75 7e                	jne    5ac91f <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x28cf>
  5ac8a1:	48 83 fb ff          	cmp    $0xffffffffffffffff,%rbx
  5ac8a5:	0f 84 9c 00 00 00    	je     5ac947 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x28f7>
  5ac8ab:	48 89 d8             	mov    %rbx,%rax
  5ac8ae:	48 33 84 24 50 02 00 	xor    0x250(%rsp),%rax
  5ac8b5:	00 
  5ac8b6:	48 85 db             	test   %rbx,%rbx
  5ac8b9:	b9 01 00 00 00       	mov    $0x1,%ecx
  5ac8be:	48 0f 49 c1          	cmovns %rcx,%rax
  5ac8c2:	48 8b 8c 24 a8 00 00 	mov    0xa8(%rsp),%rcx
  5ac8c9:	00 
  5ac8ca:	48 89 8c 24 58 02 00 	mov    %rcx,0x258(%rsp)
  5ac8d1:	00 
  5ac8d2:	48 85 c0             	test   %rax,%rax
  5ac8d5:	74 0a                	je     5ac8e1 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2891>
  5ac8d7:	48 83 f8 01          	cmp    $0x1,%rax
  5ac8db:	0f 85 8f 00 00 00    	jne    5ac970 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2920>
  5ac8e1:	48 c7 44 24 70 ff ff 	movq   $0xffffffffffffffff,0x70(%rsp)
  5ac8e8:	ff ff 
  5ac8ea:	48 8b 9c 24 b0 00 00 	mov    0xb0(%rsp),%rbx
  5ac8f1:	00 
  5ac8f2:	e9 b9 00 00 00       	jmp    5ac9b0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2960>
  5ac8f7:	c6 84 24 60 02 00 00 	movb   $0x2,0x260(%rsp)
  5ac8fe:	02 
  5ac8ff:	b1 01                	mov    $0x1,%cl
  5ac901:	89 8c 24 70 02 00 00 	mov    %ecx,0x270(%rsp)
  5ac908:	48 89 8c 24 00 02 00 	mov    %rcx,0x200(%rsp)
  5ac90f:	00 
  5ac910:	8b 8c 24 08 02 00 00 	mov    0x208(%rsp),%ecx
  5ac917:	88 4c 24 08          	mov    %cl,0x8(%rsp)
  5ac91b:	3c 02                	cmp    $0x2,%al
  5ac91d:	74 82                	je     5ac8a1 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2851>
  5ac91f:	48 8b 7c 24 60       	mov    0x60(%rsp),%rdi
  5ac924:	4c 89 fe             	mov    %r15,%rsi
  5ac927:	e8 f4 c3 17 00       	call   728d20 <_RNvMsi_NtNtNtCscdodAO9FK5_5alloc11collections5btree3mapINtB5_8BTreeMapyNtNtB7_7set_val9SetValZSTE6insertCs6gaF1xUz9Bf_4gpui>
  5ac92c:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  5ac931:	c6 80 5b 09 00 00 01 	movb   $0x1,0x95b(%rax)
  5ac938:	c6 44 24 08 01       	movb   $0x1,0x8(%rsp)
  5ac93d:	48 83 fb ff          	cmp    $0xffffffffffffffff,%rbx
  5ac941:	0f 85 64 ff ff ff    	jne    5ac8ab <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x285b>
  5ac947:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  5ac94c:	48 ff 80 00 09 00 00 	incq   0x900(%rax)
  5ac953:	48 c7 44 24 70 fe ff 	movq   $0xfffffffffffffffe,0x70(%rsp)
  5ac95a:	ff ff 
  5ac95c:	48 83 bc 24 b0 03 00 	cmpq   $0xfffffffffffffffe,0x3b0(%rsp)
  5ac963:	00 fe 
  5ac965:	0f 85 82 00 00 00    	jne    5ac9ed <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x299d>
  5ac96b:	e9 6a 04 00 00       	jmp    5acdda <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2d8a>
  5ac970:	48 8b 84 24 b0 00 00 	mov    0xb0(%rsp),%rax
  5ac977:	00 
  5ac978:	48 8d bc 24 00 03 00 	lea    0x300(%rsp),%rdi
  5ac97f:	00 
  5ac980:	48 8b b4 24 58 02 00 	mov    0x258(%rsp),%rsi
  5ac987:	00 
  5ac988:	ff 50 28             	call   *0x28(%rax)
  5ac98b:	48 8b 84 24 00 03 00 	mov    0x300(%rsp),%rax
  5ac992:	00 
  5ac993:	48 89 44 24 70       	mov    %rax,0x70(%rsp)
  5ac998:	48 8b 84 24 08 03 00 	mov    0x308(%rsp),%rax
  5ac99f:	00 
  5ac9a0:	48 89 84 24 58 02 00 	mov    %rax,0x258(%rsp)
  5ac9a7:	00 
  5ac9a8:	48 8b 9c 24 10 03 00 	mov    0x310(%rsp),%rbx
  5ac9af:	00 
  5ac9b0:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  5ac9b5:	48 ff 80 00 09 00 00 	incq   0x900(%rax)
  5ac9bc:	4c 8b ac 24 b0 03 00 	mov    0x3b0(%rsp),%r13
  5ac9c3:	00 
  5ac9c4:	49 83 fd fe          	cmp    $0xfffffffffffffffe,%r13
  5ac9c8:	75 16                	jne    5ac9e0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2990>
  5ac9ca:	48 83 7c 24 70 fe    	cmpq   $0xfffffffffffffffe,0x70(%rsp)
  5ac9d0:	75 67                	jne    5aca39 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x29e9>
  5ac9d2:	48 c7 44 24 70 fe ff 	movq   $0xfffffffffffffffe,0x70(%rsp)
  5ac9d9:	ff ff 
  5ac9db:	e9 fa 03 00 00       	jmp    5acdda <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2d8a>
  5ac9e0:	48 83 7c 24 70 fe    	cmpq   $0xfffffffffffffffe,0x70(%rsp)
  5ac9e6:	75 21                	jne    5aca09 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x29b9>
  5ac9e8:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  5ac9ed:	c6 80 58 09 00 00 01 	movb   $0x1,0x958(%rax)
  5ac9f4:	48 c7 c3 fe ff ff ff 	mov    $0xfffffffffffffffe,%rbx
  5ac9fb:	48 c7 44 24 70 fe ff 	movq   $0xfffffffffffffffe,0x70(%rsp)
  5aca02:	ff ff 
  5aca04:	e9 62 03 00 00       	jmp    5acd6b <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2d1b>
  5aca09:	48 8b bc 24 f0 03 00 	mov    0x3f0(%rsp),%rdi
  5aca10:	00 
  5aca11:	48 8b 07             	mov    (%rdi),%rax
  5aca14:	48 d1 e8             	shr    $1,%rax
  5aca17:	48 39 d8             	cmp    %rbx,%rax
  5aca1a:	75 1d                	jne    5aca39 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x29e9>
  5aca1c:	48 83 c7 10          	add    $0x10,%rdi
  5aca20:	48 8b b4 24 58 02 00 	mov    0x258(%rsp),%rsi
  5aca27:	00 
  5aca28:	48 89 da             	mov    %rbx,%rdx
  5aca2b:	ff 15 bf d5 53 00    	call   *0x53d5bf(%rip)        # ae9ff0 <bcmp@GLIBC_2.2.5>
  5aca31:	85 c0                	test   %eax,%eax
  5aca33:	0f 84 a1 03 00 00    	je     5acdda <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2d8a>
  5aca39:	49 83 fd fe          	cmp    $0xfffffffffffffffe,%r13
  5aca3d:	0f 94 c0             	sete   %al
  5aca40:	48 8b 4c 24 10       	mov    0x10(%rsp),%rcx
  5aca45:	08 81 58 09 00 00    	or     %al,0x958(%rcx)
  5aca4b:	48 8b b4 24 98 02 00 	mov    0x298(%rsp),%rsi
  5aca52:	00 
  5aca53:	49 39 f6             	cmp    %rsi,%r14
  5aca56:	0f 83 61 30 00 00    	jae    5afabd <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5a6d>
  5aca5c:	48 8b ac 24 90 02 00 	mov    0x290(%rsp),%rbp
  5aca63:	00 
  5aca64:	4a 8b 44 f5 00       	mov    0x0(%rbp,%r14,8),%rax
  5aca69:	48 85 c0             	test   %rax,%rax
  5aca6c:	74 71                	je     5acadf <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2a8f>
  5aca6e:	48 8b 8c 24 58 04 00 	mov    0x458(%rsp),%rcx
  5aca75:	00 
  5aca76:	48 85 c9             	test   %rcx,%rcx
  5aca79:	74 64                	je     5acadf <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2a8f>
  5aca7b:	48 8b 94 24 60 04 00 	mov    0x460(%rsp),%rdx
  5aca82:	00 
  5aca83:	0f b7 b9 ba 00 00 00 	movzwl 0xba(%rcx),%edi
  5aca8a:	41 89 f8             	mov    %edi,%r8d
  5aca8d:	41 c1 e0 03          	shl    $0x3,%r8d
  5aca91:	48 c7 c6 ff ff ff ff 	mov    $0xffffffffffffffff,%rsi
  5aca98:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  5aca9f:	00 
  5acaa0:	4d 85 c0             	test   %r8,%r8
  5acaa3:	74 27                	je     5acacc <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2a7c>
  5acaa5:	48 3b 44 f1 10       	cmp    0x10(%rcx,%rsi,8),%rax
  5acaaa:	41 0f 97 c1          	seta   %r9b
  5acaae:	41 80 d9 00          	sbb    $0x0,%r9b
  5acab2:	48 ff c6             	inc    %rsi
  5acab5:	49 83 c0 f8          	add    $0xfffffffffffffff8,%r8
  5acab9:	41 80 f9 01          	cmp    $0x1,%r9b
  5acabd:	74 e1                	je     5acaa0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2a50>
  5acabf:	41 0f b6 f9          	movzbl %r9b,%edi
  5acac3:	85 ff                	test   %edi,%edi
  5acac5:	75 08                	jne    5acacf <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2a7f>
  5acac7:	e9 ba 01 00 00       	jmp    5acc86 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2c36>
  5acacc:	48 89 fe             	mov    %rdi,%rsi
  5acacf:	48 83 ea 01          	sub    $0x1,%rdx
  5acad3:	72 0a                	jb     5acadf <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2a8f>
  5acad5:	48 8b 8c f1 c0 00 00 	mov    0xc0(%rcx,%rsi,8),%rcx
  5acadc:	00 
  5acadd:	eb a4                	jmp    5aca83 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2a33>
  5acadf:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  5acae4:	f3 0f 6f 80 08 09 00 	movdqu 0x908(%rax),%xmm0
  5acaeb:	00 
  5acaec:	66 48 0f 6e cb       	movq   %rbx,%xmm1
  5acaf1:	66 0f 6f 15 d7 02 ac 	movdqa -0x53fd29(%rip),%xmm2        # 6cdd0 <anon.5f884de6e78125e25881320d811d32df.391.llvm.17146438997930651657+0xd80>
  5acaf8:	ff 
  5acaf9:	66 0f 6c d1          	punpcklqdq %xmm1,%xmm2
  5acafd:	66 0f d4 d0          	paddq  %xmm0,%xmm2
  5acb01:	f3 0f 7f 90 08 09 00 	movdqu %xmm2,0x908(%rax)
  5acb08:	00 
  5acb09:	4c 8d 2d 80 0c ac ff 	lea    -0x53f380(%rip),%r13        # 6d790 <anon.1f6b7bab1fc61e0fcd36456038a862fb.80.llvm.12454362996328431623>
  5acb10:	48 85 db             	test   %rbx,%rbx
  5acb13:	74 47                	je     5acb5c <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2b0c>
  5acb15:	48 8d bc 24 00 03 00 	lea    0x300(%rsp),%rdi
  5acb1c:	00 
  5acb1d:	48 89 de             	mov    %rbx,%rsi
  5acb20:	31 d2                	xor    %edx,%edx
  5acb22:	31 c9                	xor    %ecx,%ecx
  5acb24:	ff 15 ce d4 53 00    	call   *0x53d4ce(%rip)        # ae9ff8 <_DYNAMIC+0x298>
  5acb2a:	48 8b bc 24 00 03 00 	mov    0x300(%rsp),%rdi
  5acb31:	00 
  5acb32:	48 83 ff ff          	cmp    $0xffffffffffffffff,%rdi
  5acb36:	0f 85 27 30 00 00    	jne    5afb63 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5b13>
  5acb3c:	48 8b 84 24 08 03 00 	mov    0x308(%rsp),%rax
  5acb43:	00 
  5acb44:	49 89 c5             	mov    %rax,%r13
  5acb47:	48 8d 78 10          	lea    0x10(%rax),%rdi
  5acb4b:	48 8b b4 24 58 02 00 	mov    0x258(%rsp),%rsi
  5acb52:	00 
  5acb53:	48 89 da             	mov    %rbx,%rdx
  5acb56:	ff 15 a4 d4 53 00    	call   *0x53d4a4(%rip)        # aea000 <memcpy@GLIBC_2.14>
  5acb5c:	4a 8b 44 f5 00       	mov    0x0(%rbp,%r14,8),%rax
  5acb61:	48 85 c0             	test   %rax,%rax
  5acb64:	0f 84 df 01 00 00    	je     5acd49 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2cf9>
  5acb6a:	41 f6 45 00 01       	testb  $0x1,0x0(%r13)
  5acb6f:	75 34                	jne    5acba5 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2b55>
  5acb71:	4c 89 ee             	mov    %r13,%rsi
  5acb74:	49 8b 4d 08          	mov    0x8(%r13),%rcx
  5acb78:	f6 c1 01             	test   $0x1,%cl
  5acb7b:	75 28                	jne    5acba5 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2b55>
  5acb7d:	b9 02 00 00 00       	mov    $0x2,%ecx
  5acb82:	f0 48 0f c1 4e 08    	lock xadd %rcx,0x8(%rsi)
  5acb88:	48 ba 01 00 00 00 00 	movabs $0x8000000000000001,%rdx
  5acb8f:	00 00 80 
  5acb92:	48 21 d1             	and    %rdx,%rcx
  5acb95:	48 3b 8c 24 50 02 00 	cmp    0x250(%rsp),%rcx
  5acb9c:	00 
  5acb9d:	75 06                	jne    5acba5 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2b55>
  5acb9f:	f0 48 83 4e 08 01    	lock orq $0x1,0x8(%rsi)
  5acba5:	48 8b 8c 24 58 04 00 	mov    0x458(%rsp),%rcx
  5acbac:	00 
  5acbad:	48 85 c9             	test   %rcx,%rcx
  5acbb0:	0f 84 45 01 00 00    	je     5accfb <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2cab>
  5acbb6:	48 8b 94 24 60 04 00 	mov    0x460(%rsp),%rdx
  5acbbd:	00 
  5acbbe:	0f b7 b9 ba 00 00 00 	movzwl 0xba(%rcx),%edi
  5acbc5:	41 89 f8             	mov    %edi,%r8d
  5acbc8:	41 c1 e0 03          	shl    $0x3,%r8d
  5acbcc:	48 c7 c6 ff ff ff ff 	mov    $0xffffffffffffffff,%rsi
  5acbd3:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  5acbda:	84 00 00 00 00 00 
  5acbe0:	4d 85 c0             	test   %r8,%r8
  5acbe3:	74 27                	je     5acc0c <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2bbc>
  5acbe5:	48 3b 44 f1 10       	cmp    0x10(%rcx,%rsi,8),%rax
  5acbea:	41 0f 97 c1          	seta   %r9b
  5acbee:	41 80 d9 00          	sbb    $0x0,%r9b
  5acbf2:	48 ff c6             	inc    %rsi
  5acbf5:	49 83 c0 f8          	add    $0xfffffffffffffff8,%r8
  5acbf9:	41 80 f9 01          	cmp    $0x1,%r9b
  5acbfd:	74 e1                	je     5acbe0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2b90>
  5acbff:	41 0f b6 f9          	movzbl %r9b,%edi
  5acc03:	85 ff                	test   %edi,%edi
  5acc05:	75 08                	jne    5acc0f <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2bbf>
  5acc07:	e9 c1 00 00 00       	jmp    5acccd <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2c7d>
  5acc0c:	48 89 fe             	mov    %rdi,%rsi
  5acc0f:	48 83 ea 01          	sub    $0x1,%rdx
  5acc13:	0f 82 e4 00 00 00    	jb     5accfd <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2cad>
  5acc19:	48 8b 8c f1 c0 00 00 	mov    0xc0(%rcx,%rsi,8),%rcx
  5acc20:	00 
  5acc21:	eb 9b                	jmp    5acbbe <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2b6e>
  5acc23:	0f 85 7b 2c 00 00    	jne    5af8a4 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5854>
  5acc29:	c1 ef 03             	shr    $0x3,%edi
  5acc2c:	8d 57 ff             	lea    -0x1(%rdi),%edx
  5acc2f:	48 c7 84 24 b0 03 00 	movq   $0xfffffffffffffffe,0x3b0(%rsp)
  5acc36:	00 fe ff ff ff 
  5acc3b:	b0 02                	mov    $0x2,%al
  5acc3d:	83 ef 01             	sub    $0x1,%edi
  5acc40:	0f 82 5d fb ff ff    	jb     5ac7a3 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2753>
  5acc46:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  5acc4b:	48 8b 88 a8 07 00 00 	mov    0x7a8(%rax),%rcx
  5acc52:	48 85 c9             	test   %rcx,%rcx
  5acc55:	0f 84 7c 2c 00 00    	je     5af8d7 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5887>
  5acc5b:	d1 ea                	shr    $1,%edx
  5acc5d:	89 d0                	mov    %edx,%eax
  5acc5f:	48 8b 71 10          	mov    0x10(%rcx),%rsi
  5acc63:	48 39 c6             	cmp    %rax,%rsi
  5acc66:	0f 86 45 2f 00 00    	jbe    5afbb1 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5b61>
  5acc6c:	48 8b 49 08          	mov    0x8(%rcx),%rcx
  5acc70:	48 8b 04 c1          	mov    (%rcx,%rax,8),%rax
  5acc74:	48 8b 48 28          	mov    0x28(%rax),%rcx
  5acc78:	40 f6 d7             	not    %dil
  5acc7b:	40 80 e7 01          	and    $0x1,%dil
  5acc7f:	89 f8                	mov    %edi,%eax
  5acc81:	e9 1d fb ff ff       	jmp    5ac7a3 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2753>
  5acc86:	48 8b 54 f1 60       	mov    0x60(%rcx,%rsi,8),%rdx
  5acc8b:	f6 02 01             	testb  $0x1,(%rdx)
  5acc8e:	75 38                	jne    5accc8 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2c78>
  5acc90:	48 8b 42 08          	mov    0x8(%rdx),%rax
  5acc94:	a8 01                	test   $0x1,%al
  5acc96:	75 30                	jne    5accc8 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2c78>
  5acc98:	b8 02 00 00 00       	mov    $0x2,%eax
  5acc9d:	f0 48 0f c1 42 08    	lock xadd %rax,0x8(%rdx)
  5acca3:	48 b9 01 00 00 00 00 	movabs $0x8000000000000001,%rcx
  5accaa:	00 00 80 
  5accad:	48 21 c8             	and    %rcx,%rax
  5accb0:	48 3b 84 24 50 02 00 	cmp    0x250(%rsp),%rax
  5accb7:	00 
  5accb8:	75 0e                	jne    5accc8 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2c78>
  5accba:	49 89 d5             	mov    %rdx,%r13
  5accbd:	f0 48 83 4a 08 01    	lock orq $0x1,0x8(%rdx)
  5accc3:	e9 81 00 00 00       	jmp    5acd49 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2cf9>
  5accc8:	49 89 d5             	mov    %rdx,%r13
  5acccb:	eb 7c                	jmp    5acd49 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2cf9>
  5acccd:	48 8b 7c f1 60       	mov    0x60(%rcx,%rsi,8),%rdi
  5accd2:	4c 89 6c f1 60       	mov    %r13,0x60(%rcx,%rsi,8)
  5accd7:	f6 07 01             	testb  $0x1,(%rdi)
  5accda:	75 6d                	jne    5acd49 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2cf9>
  5accdc:	48 8b 47 08          	mov    0x8(%rdi),%rax
  5acce0:	a8 01                	test   $0x1,%al
  5acce2:	75 65                	jne    5acd49 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2cf9>
  5acce4:	48 8d 47 08          	lea    0x8(%rdi),%rax
  5acce8:	f0 48 83 28 02       	lock subq $0x2,(%rax)
  5acced:	75 5a                	jne    5acd49 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2cf9>
  5accef:	48 8b 47 08          	mov    0x8(%rdi),%rax
  5accf3:	ff 15 0f d3 53 00    	call   *0x53d30f(%rip)        # aea008 <_DYNAMIC+0x2a8>
  5accf9:	eb 4e                	jmp    5acd49 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2cf9>
  5accfb:	31 c9                	xor    %ecx,%ecx
  5accfd:	48 89 84 24 00 03 00 	mov    %rax,0x300(%rsp)
  5acd04:	00 
  5acd05:	48 8d 84 24 58 04 00 	lea    0x458(%rsp),%rax
  5acd0c:	00 
  5acd0d:	48 89 84 24 08 03 00 	mov    %rax,0x308(%rsp)
  5acd14:	00 
  5acd15:	48 89 8c 24 10 03 00 	mov    %rcx,0x310(%rsp)
  5acd1c:	00 
  5acd1d:	48 c7 84 24 18 03 00 	movq   $0x0,0x318(%rsp)
  5acd24:	00 00 00 00 00 
  5acd29:	48 89 b4 24 20 03 00 	mov    %rsi,0x320(%rsp)
  5acd30:	00 
  5acd31:	48 8d bc 24 90 01 00 	lea    0x190(%rsp),%rdi
  5acd38:	00 
  5acd39:	48 8d b4 24 00 03 00 	lea    0x300(%rsp),%rsi
  5acd40:	00 
  5acd41:	4c 89 ea             	mov    %r13,%rdx
  5acd44:	e8 07 bb 1c 00       	call   778850 <_RNvMs4_NtNtNtNtCscdodAO9FK5_5alloc11collections5btree3map5entryINtB5_11VacantEntryNtNtCs6gaF1xUz9Bf_4gpui6source7FieldIdNtNtB1m_11shared_text10SharedTextE12insert_entryB1m_>
  5acd49:	4a 8b 44 f5 00       	mov    0x0(%rbp,%r14,8),%rax
  5acd4e:	48 89 84 24 90 05 00 	mov    %rax,0x590(%rsp)
  5acd55:	00 
  5acd56:	48 c7 c3 ff ff ff ff 	mov    $0xffffffffffffffff,%rbx
  5acd5d:	48 83 bc 24 b0 03 00 	cmpq   $0xfffffffffffffffe,0x3b0(%rsp)
  5acd64:	00 fe 
  5acd66:	4c 89 ed             	mov    %r13,%rbp
  5acd69:	74 31                	je     5acd9c <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2d4c>
  5acd6b:	48 8b bc 24 f0 03 00 	mov    0x3f0(%rsp),%rdi
  5acd72:	00 
  5acd73:	f6 07 01             	testb  $0x1,(%rdi)
  5acd76:	75 17                	jne    5acd8f <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2d3f>
  5acd78:	48 8b 47 08          	mov    0x8(%rdi),%rax
  5acd7c:	a8 01                	test   $0x1,%al
  5acd7e:	75 0f                	jne    5acd8f <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2d3f>
  5acd80:	48 8d 47 08          	lea    0x8(%rdi),%rax
  5acd84:	f0 48 83 28 02       	lock subq $0x2,(%rax)
  5acd89:	0f 84 fc 05 00 00    	je     5ad38b <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x333b>
  5acd8f:	48 8d bc 24 b0 03 00 	lea    0x3b0(%rsp),%rdi
  5acd96:	00 
  5acd97:	e8 04 c9 f7 ff       	call   5296a0 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtB4_6option6OptionNtNtCs6gaF1xUz9Bf_4gpui7runtime6ShapedEEB11_.llvm.18021777786862421399>
  5acd9c:	48 89 9c 24 b0 03 00 	mov    %rbx,0x3b0(%rsp)
  5acda3:	00 
  5acda4:	48 89 ac 24 f0 03 00 	mov    %rbp,0x3f0(%rsp)
  5acdab:	00 
  5acdac:	48 8b 84 24 90 05 00 	mov    0x590(%rsp),%rax
  5acdb3:	00 
  5acdb4:	48 89 84 24 f8 03 00 	mov    %rax,0x3f8(%rsp)
  5acdbb:	00 
  5acdbc:	48 8b 7c 24 60       	mov    0x60(%rsp),%rdi
  5acdc1:	4c 89 fe             	mov    %r15,%rsi
  5acdc4:	e8 57 bf 17 00       	call   728d20 <_RNvMsi_NtNtNtCscdodAO9FK5_5alloc11collections5btree3mapINtB5_8BTreeMapyNtNtB7_7set_val9SetValZSTE6insertCs6gaF1xUz9Bf_4gpui>
  5acdc9:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  5acdce:	c6 80 5b 09 00 00 01 	movb   $0x1,0x95b(%rax)
  5acdd5:	c6 44 24 08 01       	movb   $0x1,0x8(%rsp)
  5acdda:	48 8d bc 24 48 07 00 	lea    0x748(%rsp),%rdi
  5acde1:	00 
  5acde2:	48 8b b4 24 98 05 00 	mov    0x598(%rsp),%rsi
  5acde9:	00 
  5acdea:	4c 89 fa             	mov    %r15,%rdx
  5acded:	48 8d 8c 24 c0 00 00 	lea    0xc0(%rsp),%rcx
  5acdf4:	00 
  5acdf5:	e8 36 b4 17 00       	call   728230 <_RNvMs5_NtCs6gaF1xUz9Bf_4gpui8propertyNtB5_9Overrides7resolve>
  5acdfa:	48 8d bc 24 50 06 00 	lea    0x650(%rsp),%rdi
  5ace01:	00 
  5ace02:	48 8d b4 24 48 07 00 	lea    0x748(%rsp),%rsi
  5ace09:	00 
  5ace0a:	e8 b1 18 0b 00       	call   65e6c0 <_RNvXse_NtCs6gaF1xUz9Bf_4gpui5styleNtB5_5StyleNtNtCs4NRVxsYgnAr_4core3cmp9PartialEq2eq>
  5ace0f:	84 c0                	test   %al,%al
  5ace11:	75 11                	jne    5ace24 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2dd4>
  5ace13:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  5ace18:	c6 80 5b 09 00 00 01 	movb   $0x1,0x95b(%rax)
  5ace1f:	c6 44 24 08 01       	movb   $0x1,0x8(%rsp)
  5ace24:	0f b6 84 24 48 07 00 	movzbl 0x748(%rsp),%eax
  5ace2b:	00 
  5ace2c:	83 bc 24 50 06 00 00 	cmpl   $0x1,0x650(%rsp)
  5ace33:	01 
  5ace34:	75 27                	jne    5ace5d <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2e0d>
  5ace36:	84 c0                	test   %al,%al
  5ace38:	0f 84 b2 00 00 00    	je     5acef0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2ea0>
  5ace3e:	f3 0f 10 84 24 54 06 	movss  0x654(%rsp),%xmm0
  5ace45:	00 00 
  5ace47:	0f 2e 84 24 4c 07 00 	ucomiss 0x74c(%rsp),%xmm0
  5ace4e:	00 
  5ace4f:	0f 85 9b 00 00 00    	jne    5acef0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2ea0>
  5ace55:	0f 8a 95 00 00 00    	jp     5acef0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2ea0>
  5ace5b:	eb 08                	jmp    5ace65 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2e15>
  5ace5d:	84 c0                	test   %al,%al
  5ace5f:	0f 85 8b 00 00 00    	jne    5acef0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2ea0>
  5ace65:	0f b6 84 24 50 07 00 	movzbl 0x750(%rsp),%eax
  5ace6c:	00 
  5ace6d:	83 bc 24 58 06 00 00 	cmpl   $0x1,0x658(%rsp)
  5ace74:	01 
  5ace75:	75 1b                	jne    5ace92 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2e42>
  5ace77:	84 c0                	test   %al,%al
  5ace79:	74 75                	je     5acef0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2ea0>
  5ace7b:	f3 0f 10 84 24 5c 06 	movss  0x65c(%rsp),%xmm0
  5ace82:	00 00 
  5ace84:	0f 2e 84 24 54 07 00 	ucomiss 0x754(%rsp),%xmm0
  5ace8b:	00 
  5ace8c:	75 62                	jne    5acef0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2ea0>
  5ace8e:	7a 60                	jp     5acef0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2ea0>
  5ace90:	eb 04                	jmp    5ace96 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2e46>
  5ace92:	84 c0                	test   %al,%al
  5ace94:	75 5a                	jne    5acef0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2ea0>
  5ace96:	f3 0f 10 84 24 60 06 	movss  0x660(%rsp),%xmm0
  5ace9d:	00 00 
  5ace9f:	0f 2e 84 24 58 07 00 	ucomiss 0x758(%rsp),%xmm0
  5acea6:	00 
  5acea7:	75 47                	jne    5acef0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2ea0>
  5acea9:	7a 45                	jp     5acef0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2ea0>
  5aceab:	f3 0f 10 84 24 64 06 	movss  0x664(%rsp),%xmm0
  5aceb2:	00 00 
  5aceb4:	0f 2e 84 24 5c 07 00 	ucomiss 0x75c(%rsp),%xmm0
  5acebb:	00 
  5acebc:	75 32                	jne    5acef0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2ea0>
  5acebe:	7a 30                	jp     5acef0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2ea0>
  5acec0:	f3 0f 10 84 24 68 06 	movss  0x668(%rsp),%xmm0
  5acec7:	00 00 
  5acec9:	f3 0f 10 8c 24 60 07 	movss  0x760(%rsp),%xmm1
  5aced0:	00 00 
  5aced2:	0f 2e c1             	ucomiss %xmm1,%xmm0
  5aced5:	75 19                	jne    5acef0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2ea0>
  5aced7:	7a 17                	jp     5acef0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2ea0>
  5aced9:	0f b6 84 24 a4 06 00 	movzbl 0x6a4(%rsp),%eax
  5acee0:	00 
  5acee1:	3a 84 24 9c 07 00 00 	cmp    0x79c(%rsp),%al
  5acee8:	74 25                	je     5acf0f <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2ebf>
  5aceea:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
  5acef0:	48 8b 7c 24 60       	mov    0x60(%rsp),%rdi
  5acef5:	4c 89 fe             	mov    %r15,%rsi
  5acef8:	e8 23 be 17 00       	call   728d20 <_RNvMsi_NtNtNtCscdodAO9FK5_5alloc11collections5btree3mapINtB5_8BTreeMapyNtNtB7_7set_val9SetValZSTE6insertCs6gaF1xUz9Bf_4gpui>
  5acefd:	f3 0f 10 84 24 68 06 	movss  0x668(%rsp),%xmm0
  5acf04:	00 00 
  5acf06:	f3 0f 10 8c 24 60 07 	movss  0x760(%rsp),%xmm1
  5acf0d:	00 00 
  5acf0f:	0f 2e c1             	ucomiss %xmm1,%xmm0
  5acf12:	75 02                	jne    5acf16 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2ec6>
  5acf14:	7b 24                	jnp    5acf3a <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2eea>
  5acf16:	48 83 bc 24 b0 03 00 	cmpq   $0xfffffffffffffffe,0x3b0(%rsp)
  5acf1d:	00 fe 
  5acf1f:	74 19                	je     5acf3a <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2eea>
  5acf21:	48 8d bc 24 b0 03 00 	lea    0x3b0(%rsp),%rdi
  5acf28:	00 
  5acf29:	e8 72 c7 f7 ff       	call   5296a0 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtB4_6option6OptionNtNtCs6gaF1xUz9Bf_4gpui7runtime6ShapedEEB11_.llvm.18021777786862421399>
  5acf2e:	48 c7 84 24 b0 03 00 	movq   $0xffffffffffffffff,0x3b0(%rsp)
  5acf35:	00 ff ff ff ff 
  5acf3a:	48 83 7c 24 40 00    	cmpq   $0x0,0x40(%rsp)
  5acf40:	0f 95 c0             	setne  %al
  5acf43:	48 8b 9c 24 18 01 00 	mov    0x118(%rsp),%rbx
  5acf4a:	00 
  5acf4b:	48 85 db             	test   %rbx,%rbx
  5acf4e:	0f 95 c1             	setne  %cl
  5acf51:	30 c1                	xor    %al,%cl
  5acf53:	74 11                	je     5acf66 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2f16>
  5acf55:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  5acf5a:	c6 80 5b 09 00 00 01 	movb   $0x1,0x95b(%rax)
  5acf61:	c6 44 24 08 01       	movb   $0x1,0x8(%rsp)
  5acf66:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
  5acf6c:	80 7c 24 50 00       	cmpb   $0x0,0x50(%rsp)
  5acf71:	74 13                	je     5acf86 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2f36>
  5acf73:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
  5acf78:	41 89 c5             	mov    %eax,%r13d
  5acf7b:	3d a0 86 01 00       	cmp    $0x186a0,%eax
  5acf80:	0f 83 60 28 00 00    	jae    5af7e6 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5796>
  5acf86:	48 8d bc 24 08 07 00 	lea    0x708(%rsp),%rdi
  5acf8d:	00 
  5acf8e:	48 8d b4 24 48 07 00 	lea    0x748(%rsp),%rsi
  5acf95:	00 
  5acf96:	e8 65 b4 f9 ff       	call   548400 <_RNvMs_NtNtCs6gaF1xUz9Bf_4gpui7runtime6stylesNtB4_7Builder4push>
  5acf9b:	48 8b 84 24 20 01 00 	mov    0x120(%rsp),%rax
  5acfa2:	00 
  5acfa3:	48 89 44 24 38       	mov    %rax,0x38(%rsp)
  5acfa8:	48 83 7c 24 40 00    	cmpq   $0x0,0x40(%rsp)
  5acfae:	74 36                	je     5acfe6 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2f96>
  5acfb0:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
  5acfb5:	48 8b 00             	mov    (%rax),%rax
  5acfb8:	48 85 c0             	test   %rax,%rax
  5acfbb:	74 07                	je     5acfc4 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2f74>
  5acfbd:	48 8b 7c 24 40       	mov    0x40(%rsp),%rdi
  5acfc2:	ff d0                	call   *%rax
  5acfc4:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
  5acfc9:	48 8b 70 08          	mov    0x8(%rax),%rsi
  5acfcd:	48 85 f6             	test   %rsi,%rsi
  5acfd0:	74 14                	je     5acfe6 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2f96>
  5acfd2:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
  5acfd7:	48 8b 50 10          	mov    0x10(%rax),%rdx
  5acfdb:	48 8b 7c 24 40       	mov    0x40(%rsp),%rdi
  5acfe0:	ff 15 c2 cf 53 00    	call   *0x53cfc2(%rip)        # ae9fa8 <_DYNAMIC+0x248>
  5acfe6:	48 89 ac 24 38 04 00 	mov    %rbp,0x438(%rsp)
  5acfed:	00 
  5acfee:	48 83 bc 24 b0 03 00 	cmpq   $0xfffffffffffffffe,0x3b0(%rsp)
  5acff5:	00 fe 
  5acff7:	0f 94 c0             	sete   %al
  5acffa:	89 44 24 18          	mov    %eax,0x18(%rsp)
  5acffe:	bd ff ff ff ff       	mov    $0xffffffff,%ebp
  5ad003:	0f 84 59 01 00 00    	je     5ad162 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x3112>
  5ad009:	0f 28 84 24 f0 03 00 	movaps 0x3f0(%rsp),%xmm0
  5ad010:	00 
  5ad011:	0f 29 84 24 d0 01 00 	movaps %xmm0,0x1d0(%rsp)
  5ad018:	00 
  5ad019:	0f 28 84 24 b0 03 00 	movaps 0x3b0(%rsp),%xmm0
  5ad020:	00 
  5ad021:	0f 28 8c 24 c0 03 00 	movaps 0x3c0(%rsp),%xmm1
  5ad028:	00 
  5ad029:	0f 28 94 24 d0 03 00 	movaps 0x3d0(%rsp),%xmm2
  5ad030:	00 
  5ad031:	0f 28 9c 24 e0 03 00 	movaps 0x3e0(%rsp),%xmm3
  5ad038:	00 
  5ad039:	0f 29 9c 24 c0 01 00 	movaps %xmm3,0x1c0(%rsp)
  5ad040:	00 
  5ad041:	0f 29 94 24 b0 01 00 	movaps %xmm2,0x1b0(%rsp)
  5ad048:	00 
  5ad049:	0f 29 8c 24 a0 01 00 	movaps %xmm1,0x1a0(%rsp)
  5ad050:	00 
  5ad051:	0f 29 84 24 90 01 00 	movaps %xmm0,0x190(%rsp)
  5ad058:	00 
  5ad059:	48 8b b4 24 98 02 00 	mov    0x298(%rsp),%rsi
  5ad060:	00 
  5ad061:	49 39 f6             	cmp    %rsi,%r14
  5ad064:	0f 83 e8 29 00 00    	jae    5afa52 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5a02>
  5ad06a:	48 8b 84 24 90 02 00 	mov    0x290(%rsp),%rax
  5ad071:	00 
  5ad072:	4a 8b 04 f0          	mov    (%rax,%r14,8),%rax
  5ad076:	48 89 84 24 d8 01 00 	mov    %rax,0x1d8(%rsp)
  5ad07d:	00 
  5ad07e:	48 8b ac 24 38 05 00 	mov    0x538(%rsp),%rbp
  5ad085:	00 
  5ad086:	48 8b 84 24 d0 01 00 	mov    0x1d0(%rsp),%rax
  5ad08d:	00 
  5ad08e:	48 89 84 24 40 03 00 	mov    %rax,0x340(%rsp)
  5ad095:	00 
  5ad096:	48 8b 84 24 d8 01 00 	mov    0x1d8(%rsp),%rax
  5ad09d:	00 
  5ad09e:	48 89 84 24 48 03 00 	mov    %rax,0x348(%rsp)
  5ad0a5:	00 
  5ad0a6:	0f 28 84 24 90 01 00 	movaps 0x190(%rsp),%xmm0
  5ad0ad:	00 
  5ad0ae:	0f 28 8c 24 a0 01 00 	movaps 0x1a0(%rsp),%xmm1
  5ad0b5:	00 
  5ad0b6:	0f 28 94 24 b0 01 00 	movaps 0x1b0(%rsp),%xmm2
  5ad0bd:	00 
  5ad0be:	0f 28 9c 24 c0 01 00 	movaps 0x1c0(%rsp),%xmm3
  5ad0c5:	00 
  5ad0c6:	0f 29 9c 24 30 03 00 	movaps %xmm3,0x330(%rsp)
  5ad0cd:	00 
  5ad0ce:	0f 29 94 24 20 03 00 	movaps %xmm2,0x320(%rsp)
  5ad0d5:	00 
  5ad0d6:	0f 29 8c 24 10 03 00 	movaps %xmm1,0x310(%rsp)
  5ad0dd:	00 
  5ad0de:	0f 29 84 24 00 03 00 	movaps %xmm0,0x300(%rsp)
  5ad0e5:	00 
  5ad0e6:	48 3b ac 24 28 05 00 	cmp    0x528(%rsp),%rbp
  5ad0ed:	00 
  5ad0ee:	75 0d                	jne    5ad0fd <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x30ad>
  5ad0f0:	48 8d bc 24 28 05 00 	lea    0x528(%rsp),%rdi
  5ad0f7:	00 
  5ad0f8:	e8 93 05 22 00       	call   7cd690 <_RNvMs3_NtCscdodAO9FK5_5alloc7raw_vecINtB5_6RawVecINtNtCs4NRVxsYgnAr_4core6option6OptionNtNtCs6gaF1xUz9Bf_4gpui7runtime8TextSiteEE8grow_oneB1r_>
  5ad0fd:	48 8b 84 24 30 05 00 	mov    0x530(%rsp),%rax
  5ad104:	00 
  5ad105:	48 8d 0c ad 00 00 00 	lea    0x0(,%rbp,4),%rcx
  5ad10c:	00 
  5ad10d:	48 01 e9             	add    %rbp,%rcx
  5ad110:	48 c1 e1 04          	shl    $0x4,%rcx
  5ad114:	0f 28 84 24 40 03 00 	movaps 0x340(%rsp),%xmm0
  5ad11b:	00 
  5ad11c:	0f 11 44 08 40       	movups %xmm0,0x40(%rax,%rcx,1)
  5ad121:	0f 28 84 24 00 03 00 	movaps 0x300(%rsp),%xmm0
  5ad128:	00 
  5ad129:	0f 28 8c 24 10 03 00 	movaps 0x310(%rsp),%xmm1
  5ad130:	00 
  5ad131:	66 0f 6f 94 24 20 03 	movdqa 0x320(%rsp),%xmm2
  5ad138:	00 00 
  5ad13a:	0f 28 9c 24 30 03 00 	movaps 0x330(%rsp),%xmm3
  5ad141:	00 
  5ad142:	0f 11 5c 08 30       	movups %xmm3,0x30(%rax,%rcx,1)
  5ad147:	f3 0f 7f 54 08 20    	movdqu %xmm2,0x20(%rax,%rcx,1)
  5ad14d:	0f 11 4c 08 10       	movups %xmm1,0x10(%rax,%rcx,1)
  5ad152:	0f 11 04 08          	movups %xmm0,(%rax,%rcx,1)
  5ad156:	48 8d 45 01          	lea    0x1(%rbp),%rax
  5ad15a:	48 89 84 24 38 05 00 	mov    %rax,0x538(%rsp)
  5ad161:	00 
  5ad162:	80 bc 24 70 02 00 00 	cmpb   $0x0,0x270(%rsp)
  5ad169:	00 
  5ad16a:	74 44                	je     5ad1b0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x3160>
  5ad16c:	83 bc 24 68 02 00 00 	cmpl   $0x7,0x268(%rsp)
  5ad173:	07 
  5ad174:	0f 84 48 27 00 00    	je     5af8c2 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5872>
  5ad17a:	83 fd ff             	cmp    $0xffffffff,%ebp
  5ad17d:	74 72                	je     5ad1f1 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x31a1>
  5ad17f:	81 fd 9f 86 01 00    	cmp    $0x1869f,%ebp
  5ad185:	0f 87 db 26 00 00    	ja     5af866 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5816>
  5ad18b:	48 8b 84 24 68 02 00 	mov    0x268(%rsp),%rax
  5ad192:	00 
  5ad193:	8d 04 e8             	lea    (%rax,%rbp,8),%eax
  5ad196:	83 c0 08             	add    $0x8,%eax
  5ad199:	48 89 c5             	mov    %rax,%rbp
  5ad19c:	4c 8b b4 24 28 02 00 	mov    0x228(%rsp),%r14
  5ad1a3:	00 
  5ad1a4:	4c 3b b4 24 18 02 00 	cmp    0x218(%rsp),%r14
  5ad1ab:	00 
  5ad1ac:	74 5d                	je     5ad20b <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x31bb>
  5ad1ae:	eb 68                	jmp    5ad218 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x31c8>
  5ad1b0:	48 8b 8c 24 00 02 00 	mov    0x200(%rsp),%rcx
  5ad1b7:	00 
  5ad1b8:	81 f9 a0 86 01 00    	cmp    $0x186a0,%ecx
  5ad1be:	0f 83 4b 26 00 00    	jae    5af80f <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x57bf>
  5ad1c4:	c1 e1 04             	shl    $0x4,%ecx
  5ad1c7:	0f b6 84 24 60 02 00 	movzbl 0x260(%rsp),%eax
  5ad1ce:	00 
  5ad1cf:	f6 d0                	not    %al
  5ad1d1:	0f b6 c0             	movzbl %al,%eax
  5ad1d4:	83 e0 01             	and    $0x1,%eax
  5ad1d7:	8d 2c c1             	lea    (%rcx,%rax,8),%ebp
  5ad1da:	83 c5 0e             	add    $0xe,%ebp
  5ad1dd:	4c 8b b4 24 28 02 00 	mov    0x228(%rsp),%r14
  5ad1e4:	00 
  5ad1e5:	4c 3b b4 24 18 02 00 	cmp    0x218(%rsp),%r14
  5ad1ec:	00 
  5ad1ed:	74 1c                	je     5ad20b <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x31bb>
  5ad1ef:	eb 27                	jmp    5ad218 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x31c8>
  5ad1f1:	48 8b ac 24 68 02 00 	mov    0x268(%rsp),%rbp
  5ad1f8:	00 
  5ad1f9:	4c 8b b4 24 28 02 00 	mov    0x228(%rsp),%r14
  5ad200:	00 
  5ad201:	4c 3b b4 24 18 02 00 	cmp    0x218(%rsp),%r14
  5ad208:	00 
  5ad209:	75 0d                	jne    5ad218 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x31c8>
  5ad20b:	48 8d bc 24 18 02 00 	lea    0x218(%rsp),%rdi
  5ad212:	00 
  5ad213:	e8 48 09 22 00       	call   7cdb60 <_RNvMs3_NtCscdodAO9FK5_5alloc7raw_vecINtB5_6RawVecNtNtCs6gaF1xUz9Bf_4gpui7runtime4NodeE8grow_oneBP_>
  5ad218:	48 8b 84 24 20 02 00 	mov    0x220(%rsp),%rax
  5ad21f:	00 
  5ad220:	4b 8d 0c b6          	lea    (%r14,%r14,4),%rcx
  5ad224:	4c 89 3c c8          	mov    %r15,(%rax,%rcx,8)
  5ad228:	48 89 5c c8 08       	mov    %rbx,0x8(%rax,%rcx,8)
  5ad22d:	48 8b 54 24 38       	mov    0x38(%rsp),%rdx
  5ad232:	48 89 54 c8 10       	mov    %rdx,0x10(%rax,%rcx,8)
  5ad237:	44 89 6c c8 18       	mov    %r13d,0x18(%rax,%rcx,8)
  5ad23c:	48 8b 94 24 80 02 00 	mov    0x280(%rsp),%rdx
  5ad243:	00 
  5ad244:	89 54 c8 1c          	mov    %edx,0x1c(%rax,%rcx,8)
  5ad248:	89 6c c8 20          	mov    %ebp,0x20(%rax,%rcx,8)
  5ad24c:	8b 94 24 90 00 00 00 	mov    0x90(%rsp),%edx
  5ad253:	89 54 c8 24          	mov    %edx,0x24(%rax,%rcx,8)
  5ad257:	49 ff c6             	inc    %r14
  5ad25a:	4c 89 b4 24 28 02 00 	mov    %r14,0x228(%rsp)
  5ad261:	00 
  5ad262:	48 8b 74 24 70       	mov    0x70(%rsp),%rsi
  5ad267:	48 8d 46 ff          	lea    -0x1(%rsi),%rax
  5ad26b:	48 83 f8 fc          	cmp    $0xfffffffffffffffc,%rax
  5ad26f:	77 13                	ja     5ad284 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x3234>
  5ad271:	ba 01 00 00 00       	mov    $0x1,%edx
  5ad276:	48 8b bc 24 58 02 00 	mov    0x258(%rsp),%rdi
  5ad27d:	00 
  5ad27e:	ff 15 24 cd 53 00    	call   *0x53cd24(%rip)        # ae9fa8 <_DYNAMIC+0x248>
  5ad284:	48 8b b4 24 a0 00 00 	mov    0xa0(%rsp),%rsi
  5ad28b:	00 
  5ad28c:	48 83 fe ff          	cmp    $0xffffffffffffffff,%rsi
  5ad290:	48 8b ac 24 78 02 00 	mov    0x278(%rsp),%rbp
  5ad297:	00 
  5ad298:	41 bf 01 00 00 00    	mov    $0x1,%r15d
  5ad29e:	4c 8d b4 24 00 03 00 	lea    0x300(%rsp),%r14
  5ad2a5:	00 
  5ad2a6:	74 18                	je     5ad2c0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x3270>
  5ad2a8:	48 85 f6             	test   %rsi,%rsi
  5ad2ab:	7e 13                	jle    5ad2c0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x3270>
  5ad2ad:	48 8b bc 24 a8 00 00 	mov    0xa8(%rsp),%rdi
  5ad2b4:	00 
  5ad2b5:	ba 01 00 00 00       	mov    $0x1,%edx
  5ad2ba:	ff 15 e8 cc 53 00    	call   *0x53cce8(%rip)        # ae9fa8 <_DYNAMIC+0x248>
  5ad2c0:	48 8b 9c 24 28 01 00 	mov    0x128(%rsp),%rbx
  5ad2c7:	00 
  5ad2c8:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  5ad2cf:	00 
  5ad2d0:	48 85 db             	test   %rbx,%rbx
  5ad2d3:	0f 84 37 ed ff ff    	je     5ac010 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1fc0>
  5ad2d9:	48 89 d8             	mov    %rbx,%rax
  5ad2dc:	48 89 9c 24 00 03 00 	mov    %rbx,0x300(%rsp)
  5ad2e3:	00 
  5ad2e4:	48 8b 5b 10          	mov    0x10(%rbx),%rbx
  5ad2e8:	48 c7 40 10 00 00 00 	movq   $0x0,0x10(%rax)
  5ad2ef:	00 
  5ad2f0:	4c 89 f7             	mov    %r14,%rdi
  5ad2f3:	e8 48 eb 21 00       	call   7cbe40 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtCscdodAO9FK5_5alloc5boxed3BoxNtNtCs6gaF1xUz9Bf_4gpui7element17ComponentBoundaryEEB1d_.llvm.6226793394568926217>
  5ad2f8:	eb d6                	jmp    5ad2d0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x3280>
  5ad2fa:	48 8b b4 24 58 05 00 	mov    0x558(%rsp),%rsi
  5ad301:	00 
  5ad302:	48 39 f0             	cmp    %rsi,%rax
  5ad305:	0f 83 03 29 00 00    	jae    5afc0e <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5bbe>
  5ad30b:	48 6b c8 58          	imul   $0x58,%rax,%rcx
  5ad30f:	48 03 8c 24 50 05 00 	add    0x550(%rsp),%rcx
  5ad316:	00 
  5ad317:	48 8b 41 50          	mov    0x50(%rcx),%rax
  5ad31b:	48 89 84 24 a0 06 00 	mov    %rax,0x6a0(%rsp)
  5ad322:	00 
  5ad323:	0f 10 41 40          	movups 0x40(%rcx),%xmm0
  5ad327:	0f 29 84 24 90 06 00 	movaps %xmm0,0x690(%rsp)
  5ad32e:	00 
  5ad32f:	f3 0f 6f 01          	movdqu (%rcx),%xmm0
  5ad333:	f3 0f 6f 49 10       	movdqu 0x10(%rcx),%xmm1
  5ad338:	f3 0f 6f 51 20       	movdqu 0x20(%rcx),%xmm2
  5ad33d:	0f 10 59 30          	movups 0x30(%rcx),%xmm3
  5ad341:	0f 29 9c 24 80 06 00 	movaps %xmm3,0x680(%rsp)
  5ad348:	00 
  5ad349:	66 0f 7f 94 24 70 06 	movdqa %xmm2,0x670(%rsp)
  5ad350:	00 00 
  5ad352:	66 0f 7f 8c 24 60 06 	movdqa %xmm1,0x660(%rsp)
  5ad359:	00 00 
  5ad35b:	66 0f 7f 84 24 50 06 	movdqa %xmm0,0x650(%rsp)
  5ad362:	00 00 
  5ad364:	c7 84 24 08 02 00 00 	movl   $0x0,0x208(%rsp)
  5ad36b:	00 00 00 00 
  5ad36f:	48 8b 44 24 58       	mov    0x58(%rsp),%rax
  5ad374:	48 89 44 24 30       	mov    %rax,0x30(%rsp)
  5ad379:	4c 89 7c 24 40       	mov    %r15,0x40(%rsp)
  5ad37e:	4c 8b bc 24 28 04 00 	mov    0x428(%rsp),%r15
  5ad385:	00 
  5ad386:	e9 79 f3 ff ff       	jmp    5ac704 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x26b4>
  5ad38b:	48 8b 47 08          	mov    0x8(%rdi),%rax
  5ad38f:	ff 15 73 cc 53 00    	call   *0x53cc73(%rip)        # aea008 <_DYNAMIC+0x2a8>
  5ad395:	e9 f5 f9 ff ff       	jmp    5acd8f <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x2d3f>
  5ad39a:	31 c0                	xor    %eax,%eax
  5ad39c:	48 89 84 24 d8 04 00 	mov    %rax,0x4d8(%rsp)
  5ad3a3:	00 
  5ad3a4:	40 b5 01             	mov    $0x1,%bpl
  5ad3a7:	48 8d bc 24 00 04 00 	lea    0x400(%rsp),%rdi
  5ad3ae:	00 
  5ad3af:	41 b6 01             	mov    $0x1,%r14b
  5ad3b2:	e8 39 39 1b 00       	call   760cf0 <_RNvXse_NtNtCscdodAO9FK5_5alloc3vec9into_iterINtB5_8IntoIterNtNtCs6gaF1xUz9Bf_4gpui7element9DraftNodeENtNtNtCs4NRVxsYgnAr_4core3ops4drop4Drop4dropBZ_>
  5ad3b7:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  5ad3bc:	48 8d b8 a8 07 00 00 	lea    0x7a8(%rax),%rdi
  5ad3c3:	48 8b 84 24 80 04 00 	mov    0x480(%rsp),%rax
  5ad3ca:	00 
  5ad3cb:	48 89 84 24 b0 00 00 	mov    %rax,0xb0(%rsp)
  5ad3d2:	00 
  5ad3d3:	0f 28 84 24 70 04 00 	movaps 0x470(%rsp),%xmm0
  5ad3da:	00 
  5ad3db:	0f 29 84 24 a0 00 00 	movaps %xmm0,0xa0(%rsp)
  5ad3e2:	00 
  5ad3e3:	45 31 f6             	xor    %r14d,%r14d
  5ad3e6:	48 8d b4 24 a0 00 00 	lea    0xa0(%rsp),%rsi
  5ad3ed:	00 
  5ad3ee:	e8 7d 8b 1d 00       	call   785f70 <_RNvNtNtCs6gaF1xUz9Bf_4gpui7runtime5image9reconcile>
  5ad3f3:	48 8b b4 24 98 04 00 	mov    0x498(%rsp),%rsi
  5ad3fa:	00 
  5ad3fb:	48 85 f6             	test   %rsi,%rsi
  5ad3fe:	4c 8b 8c 24 30 04 00 	mov    0x430(%rsp),%r9
  5ad405:	00 
  5ad406:	74 1f                	je     5ad427 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x33d7>
  5ad408:	48 8b 8c 24 90 04 00 	mov    0x490(%rsp),%rcx
  5ad40f:	00 
  5ad410:	89 f0                	mov    %esi,%eax
  5ad412:	83 e0 03             	and    $0x3,%eax
  5ad415:	48 83 fe 04          	cmp    $0x4,%rsi
  5ad419:	4c 8b 44 24 10       	mov    0x10(%rsp),%r8
  5ad41e:	73 11                	jae    5ad431 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x33e1>
  5ad420:	31 d2                	xor    %edx,%edx
  5ad422:	45 31 d2             	xor    %r10d,%r10d
  5ad425:	eb 51                	jmp    5ad478 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x3428>
  5ad427:	45 31 d2             	xor    %r10d,%r10d
  5ad42a:	4c 8b 44 24 10       	mov    0x10(%rsp),%r8
  5ad42f:	eb 71                	jmp    5ad4a2 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x3452>
  5ad431:	48 83 e6 fc          	and    $0xfffffffffffffffc,%rsi
  5ad435:	31 d2                	xor    %edx,%edx
  5ad437:	48 89 cf             	mov    %rcx,%rdi
  5ad43a:	45 31 d2             	xor    %r10d,%r10d
  5ad43d:	0f 1f 00             	nopl   (%rax)
  5ad440:	48 83 3f 01          	cmpq   $0x1,(%rdi)
  5ad444:	49 83 da ff          	sbb    $0xffffffffffffffff,%r10
  5ad448:	48 83 7f 28 01       	cmpq   $0x1,0x28(%rdi)
  5ad44d:	49 83 da ff          	sbb    $0xffffffffffffffff,%r10
  5ad451:	48 83 7f 50 01       	cmpq   $0x1,0x50(%rdi)
  5ad456:	49 83 da ff          	sbb    $0xffffffffffffffff,%r10
  5ad45a:	48 83 7f 78 01       	cmpq   $0x1,0x78(%rdi)
  5ad45f:	49 83 da ff          	sbb    $0xffffffffffffffff,%r10
  5ad463:	48 83 c2 04          	add    $0x4,%rdx
  5ad467:	48 81 c7 a0 00 00 00 	add    $0xa0,%rdi
  5ad46e:	48 39 d6             	cmp    %rdx,%rsi
  5ad471:	75 cd                	jne    5ad440 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x33f0>
  5ad473:	48 85 c0             	test   %rax,%rax
  5ad476:	74 2a                	je     5ad4a2 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x3452>
  5ad478:	48 8d 14 92          	lea    (%rdx,%rdx,4),%rdx
  5ad47c:	48 8d 0c d1          	lea    (%rcx,%rdx,8),%rcx
  5ad480:	c1 e0 03             	shl    $0x3,%eax
  5ad483:	48 8d 04 80          	lea    (%rax,%rax,4),%rax
  5ad487:	31 d2                	xor    %edx,%edx
  5ad489:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  5ad490:	48 83 3c 11 01       	cmpq   $0x1,(%rcx,%rdx,1)
  5ad495:	49 83 da ff          	sbb    $0xffffffffffffffff,%r10
  5ad499:	48 83 c2 28          	add    $0x28,%rdx
  5ad49d:	48 39 d0             	cmp    %rdx,%rax
  5ad4a0:	75 ee                	jne    5ad490 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x3440>
  5ad4a2:	b0 01                	mov    $0x1,%al
  5ad4a4:	48 8b 8c 24 d8 02 00 	mov    0x2d8(%rsp),%rcx
  5ad4ab:	00 
  5ad4ac:	48 3b 8c 24 28 02 00 	cmp    0x228(%rsp),%rcx
  5ad4b3:	00 
  5ad4b4:	75 3f                	jne    5ad4f5 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x34a5>
  5ad4b6:	48 83 bc 24 d8 02 00 	cmpq   $0x0,0x2d8(%rsp)
  5ad4bd:	00 00 
  5ad4bf:	74 32                	je     5ad4f3 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x34a3>
  5ad4c1:	48 8b 8c 24 20 02 00 	mov    0x220(%rsp),%rcx
  5ad4c8:	00 
  5ad4c9:	49 ff c9             	dec    %r9
  5ad4cc:	31 d2                	xor    %edx,%edx
  5ad4ce:	66 90                	xchg   %ax,%ax
  5ad4d0:	48 8b 84 24 80 00 00 	mov    0x80(%rsp),%rax
  5ad4d7:	00 
  5ad4d8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  5ad4dc:	48 3b 01             	cmp    (%rcx),%rax
  5ad4df:	0f 95 c0             	setne  %al
  5ad4e2:	75 11                	jne    5ad4f5 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x34a5>
  5ad4e4:	48 83 c1 28          	add    $0x28,%rcx
  5ad4e8:	49 39 d1             	cmp    %rdx,%r9
  5ad4eb:	48 8d 52 01          	lea    0x1(%rdx),%rdx
  5ad4ef:	75 df                	jne    5ad4d0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x3480>
  5ad4f1:	eb 02                	jmp    5ad4f5 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x34a5>
  5ad4f3:	31 c0                	xor    %eax,%eax
  5ad4f5:	41 08 80 59 09 00 00 	or     %al,0x959(%r8)
  5ad4fc:	41 08 80 5b 09 00 00 	or     %al,0x95b(%r8)
  5ad503:	48 c7 84 24 f0 05 00 	movq   $0x0,0x5f0(%rsp)
  5ad50a:	00 00 00 00 00 
  5ad50f:	48 c7 84 24 00 06 00 	movq   $0x0,0x600(%rsp)
  5ad516:	00 00 00 00 00 
  5ad51b:	48 c7 84 24 08 06 00 	movq   $0x0,0x608(%rsp)
  5ad522:	00 00 00 00 00 
  5ad527:	48 c7 84 24 18 06 00 	movq   $0x0,0x618(%rsp)
  5ad52e:	00 00 00 00 00 
  5ad533:	4c 8b bc 24 f0 04 00 	mov    0x4f0(%rsp),%r15
  5ad53a:	00 
  5ad53b:	4c 8b a4 24 f8 04 00 	mov    0x4f8(%rsp),%r12
  5ad542:	00 
  5ad543:	48 8b 84 24 00 05 00 	mov    0x500(%rsp),%rax
  5ad54a:	00 
  5ad54b:	48 69 d0 a8 00 00 00 	imul   $0xa8,%rax,%rdx
  5ad552:	4c 01 e2             	add    %r12,%rdx
  5ad555:	4c 89 a4 24 b0 03 00 	mov    %r12,0x3b0(%rsp)
  5ad55c:	00 
  5ad55d:	4c 89 a4 24 b8 03 00 	mov    %r12,0x3b8(%rsp)
  5ad564:	00 
  5ad565:	4c 89 bc 24 c0 03 00 	mov    %r15,0x3c0(%rsp)
  5ad56c:	00 
  5ad56d:	48 89 94 24 70 02 00 	mov    %rdx,0x270(%rsp)
  5ad574:	00 
  5ad575:	48 89 94 24 c8 03 00 	mov    %rdx,0x3c8(%rsp)
  5ad57c:	00 
  5ad57d:	4c 89 a4 24 10 02 00 	mov    %r12,0x210(%rsp)
  5ad584:	00 
  5ad585:	48 85 c0             	test   %rax,%rax
  5ad588:	4c 89 94 24 08 02 00 	mov    %r10,0x208(%rsp)
  5ad58f:	00 
  5ad590:	0f 84 3d 07 00 00    	je     5adcd3 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x3c83>
  5ad596:	49 8d 80 48 08 00 00 	lea    0x848(%r8),%rax
  5ad59d:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  5ad5a2:	48 8b 84 24 10 02 00 	mov    0x210(%rsp),%rax
  5ad5a9:	00 
  5ad5aa:	4c 89 bc 24 68 02 00 	mov    %r15,0x268(%rsp)
  5ad5b1:	00 
  5ad5b2:	eb 1d                	jmp    5ad5d1 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x3581>
  5ad5b4:	66 66 66 2e 0f 1f 84 	data16 data16 cs nopw 0x0(%rax,%rax,1)
  5ad5bb:	00 00 00 00 00 
  5ad5c0:	48 89 d8             	mov    %rbx,%rax
  5ad5c3:	48 3b 9c 24 70 02 00 	cmp    0x270(%rsp),%rbx
  5ad5ca:	00 
  5ad5cb:	0f 84 f2 06 00 00    	je     5adcc3 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x3c73>
  5ad5d1:	4c 8d a0 a8 00 00 00 	lea    0xa8(%rax),%r12
  5ad5d8:	48 8b 08             	mov    (%rax),%rcx
  5ad5db:	48 83 f9 02          	cmp    $0x2,%rcx
  5ad5df:	0f 84 e6 06 00 00    	je     5adccb <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x3c7b>
  5ad5e5:	48 89 8c 24 d0 04 00 	mov    %rcx,0x4d0(%rsp)
  5ad5ec:	00 
  5ad5ed:	4c 89 a4 24 f8 01 00 	mov    %r12,0x1f8(%rsp)
  5ad5f4:	00 
  5ad5f5:	48 8b 48 18          	mov    0x18(%rax),%rcx
  5ad5f9:	48 89 8c 24 00 02 00 	mov    %rcx,0x200(%rsp)
  5ad600:	00 
  5ad601:	4c 8b 58 20          	mov    0x20(%rax),%r11
  5ad605:	48 8b 48 30          	mov    0x30(%rax),%rcx
  5ad609:	48 89 4c 24 18       	mov    %rcx,0x18(%rsp)
  5ad60e:	48 8b 48 38          	mov    0x38(%rax),%rcx
  5ad612:	48 89 4c 24 50       	mov    %rcx,0x50(%rsp)
  5ad617:	48 8b 48 40          	mov    0x40(%rax),%rcx
  5ad61b:	48 89 4c 24 38       	mov    %rcx,0x38(%rsp)
  5ad620:	48 8b 48 48          	mov    0x48(%rax),%rcx
  5ad624:	48 89 4c 24 30       	mov    %rcx,0x30(%rsp)
  5ad629:	48 8b 48 50          	mov    0x50(%rax),%rcx
  5ad62d:	48 89 4c 24 60       	mov    %rcx,0x60(%rsp)
  5ad632:	0f 10 40 58          	movups 0x58(%rax),%xmm0
  5ad636:	0f 29 44 24 40       	movaps %xmm0,0x40(%rsp)
  5ad63b:	0f 10 40 68          	movups 0x68(%rax),%xmm0
  5ad63f:	0f 29 44 24 70       	movaps %xmm0,0x70(%rsp)
  5ad644:	48 8b 48 78          	mov    0x78(%rax),%rcx
  5ad648:	48 89 4c 24 58       	mov    %rcx,0x58(%rsp)
  5ad64d:	48 8b 98 80 00 00 00 	mov    0x80(%rax),%rbx
  5ad654:	48 8b 88 88 00 00 00 	mov    0x88(%rax),%rcx
  5ad65b:	48 89 8c 24 98 00 00 	mov    %rcx,0x98(%rsp)
  5ad662:	00 
  5ad663:	4c 8b b0 90 00 00 00 	mov    0x90(%rax),%r14
  5ad66a:	48 8b 88 98 00 00 00 	mov    0x98(%rax),%rcx
  5ad671:	4c 8b a8 a0 00 00 00 	mov    0xa0(%rax),%r13
  5ad678:	66 0f 10 40 08       	movupd 0x8(%rax),%xmm0
  5ad67d:	66 0f 29 84 24 00 04 	movapd %xmm0,0x400(%rsp)
  5ad684:	00 00 
  5ad686:	48 8b 94 24 28 02 00 	mov    0x228(%rsp),%rdx
  5ad68d:	00 
  5ad68e:	48 89 8c 24 80 02 00 	mov    %rcx,0x280(%rsp)
  5ad695:	00 
  5ad696:	48 89 94 24 60 02 00 	mov    %rdx,0x260(%rsp)
  5ad69d:	00 
  5ad69e:	48 39 d1             	cmp    %rdx,%rcx
  5ad6a1:	4c 89 9c 24 78 02 00 	mov    %r11,0x278(%rsp)
  5ad6a8:	00 
  5ad6a9:	48 89 9c 24 90 00 00 	mov    %rbx,0x90(%rsp)
  5ad6b0:	00 
  5ad6b1:	0f 83 e5 22 00 00    	jae    5af99c <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x594c>
  5ad6b7:	48 8b 84 24 a0 05 00 	mov    0x5a0(%rsp),%rax
  5ad6be:	00 
  5ad6bf:	48 8b 08             	mov    (%rax),%rcx
  5ad6c2:	b0 01                	mov    $0x1,%al
  5ad6c4:	48 85 c9             	test   %rcx,%rcx
  5ad6c7:	0f 84 13 01 00 00    	je     5ad7e0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x3790>
  5ad6cd:	48 8b 54 24 10       	mov    0x10(%rsp),%rdx
  5ad6d2:	48 8b b2 20 08 00 00 	mov    0x820(%rdx),%rsi
  5ad6d9:	44 0f b7 81 32 05 00 	movzwl 0x532(%rcx),%r8d
  5ad6e0:	00 
  5ad6e1:	4d 6b c8 70          	imul   $0x70,%r8,%r9
  5ad6e5:	48 c7 c7 ff ff ff ff 	mov    $0xffffffffffffffff,%rdi
  5ad6ec:	31 d2                	xor    %edx,%edx
  5ad6ee:	66 90                	xchg   %ax,%ax
  5ad6f0:	49 39 d1             	cmp    %rdx,%r9
  5ad6f3:	74 2b                	je     5ad720 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x36d0>
  5ad6f5:	4c 3b ac f9 e0 04 00 	cmp    0x4e0(%rcx,%rdi,8),%r13
  5ad6fc:	00 
  5ad6fd:	41 0f 97 c2          	seta   %r10b
  5ad701:	41 80 da 00          	sbb    $0x0,%r10b
  5ad705:	48 83 c2 70          	add    $0x70,%rdx
  5ad709:	48 ff c7             	inc    %rdi
  5ad70c:	41 80 fa 01          	cmp    $0x1,%r10b
  5ad710:	74 de                	je     5ad6f0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x36a0>
  5ad712:	45 0f b6 c2          	movzbl %r10b,%r8d
  5ad716:	45 85 c0             	test   %r8d,%r8d
  5ad719:	75 08                	jne    5ad723 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x36d3>
  5ad71b:	eb 23                	jmp    5ad740 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x36f0>
  5ad71d:	0f 1f 00             	nopl   (%rax)
  5ad720:	4c 89 c7             	mov    %r8,%rdi
  5ad723:	48 83 ee 01          	sub    $0x1,%rsi
  5ad727:	0f 82 b3 00 00 00    	jb     5ad7e0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x3790>
  5ad72d:	48 8b 8c f9 38 05 00 	mov    0x538(%rcx,%rdi,8),%rcx
  5ad734:	00 
  5ad735:	eb a2                	jmp    5ad6d9 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x3689>
  5ad737:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
  5ad73e:	00 00 
  5ad740:	f2 0f 10 44 11 d8    	movsd  -0x28(%rcx,%rdx,1),%xmm0
  5ad746:	66 0f 28 4c 24 40    	movapd 0x40(%rsp),%xmm1
  5ad74c:	66 0f 2e c1          	ucomisd %xmm1,%xmm0
  5ad750:	0f 85 8a 00 00 00    	jne    5ad7e0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x3790>
  5ad756:	0f 8a 84 00 00 00    	jp     5ad7e0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x3790>
  5ad75c:	f2 0f 10 44 11 e0    	movsd  -0x20(%rcx,%rdx,1),%xmm0
  5ad762:	66 0f 15 c9          	unpckhpd %xmm1,%xmm1
  5ad766:	66 0f 2e c1          	ucomisd %xmm1,%xmm0
  5ad76a:	75 74                	jne    5ad7e0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x3790>
  5ad76c:	7a 72                	jp     5ad7e0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x3790>
  5ad76e:	f2 0f 10 44 11 e8    	movsd  -0x18(%rcx,%rdx,1),%xmm0
  5ad774:	66 0f 28 4c 24 70    	movapd 0x70(%rsp),%xmm1
  5ad77a:	66 0f 2e c1          	ucomisd %xmm1,%xmm0
  5ad77e:	75 60                	jne    5ad7e0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x3790>
  5ad780:	7a 5e                	jp     5ad7e0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x3790>
  5ad782:	f2 0f 10 44 11 f0    	movsd  -0x10(%rcx,%rdx,1),%xmm0
  5ad788:	66 0f 15 c9          	unpckhpd %xmm1,%xmm1
  5ad78c:	66 0f 2e c1          	ucomisd %xmm1,%xmm0
  5ad790:	75 4e                	jne    5ad7e0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x3790>
  5ad792:	7a 4c                	jp     5ad7e0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x3790>
  5ad794:	48 8b 74 24 60       	mov    0x60(%rsp),%rsi
  5ad799:	48 39 74 11 d0       	cmp    %rsi,-0x30(%rcx,%rdx,1)
  5ad79e:	75 40                	jne    5ad7e0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x3790>
  5ad7a0:	48 8b 74 24 18       	mov    0x18(%rsp),%rsi
  5ad7a5:	48 39 74 11 b0       	cmp    %rsi,-0x50(%rcx,%rdx,1)
  5ad7aa:	75 34                	jne    5ad7e0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x3790>
  5ad7ac:	48 8b 74 24 50       	mov    0x50(%rsp),%rsi
  5ad7b1:	48 39 74 11 b8       	cmp    %rsi,-0x48(%rcx,%rdx,1)
  5ad7b6:	75 28                	jne    5ad7e0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x3790>
  5ad7b8:	48 8b 74 24 38       	mov    0x38(%rsp),%rsi
  5ad7bd:	48 39 74 11 c0       	cmp    %rsi,-0x40(%rcx,%rdx,1)
  5ad7c2:	75 1c                	jne    5ad7e0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x3790>
  5ad7c4:	48 8b 74 24 30       	mov    0x30(%rsp),%rsi
  5ad7c9:	48 39 74 11 c8       	cmp    %rsi,-0x38(%rcx,%rdx,1)
  5ad7ce:	75 10                	jne    5ad7e0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x3790>
  5ad7d0:	48 8b 44 24 58       	mov    0x58(%rsp),%rax
  5ad7d5:	48 39 44 11 f8       	cmp    %rax,-0x8(%rcx,%rdx,1)
  5ad7da:	0f 95 c0             	setne  %al
  5ad7dd:	0f 1f 00             	nopl   (%rax)
  5ad7e0:	48 8b 8c 24 20 02 00 	mov    0x220(%rsp),%rcx
  5ad7e7:	00 
  5ad7e8:	48 8b 94 24 80 02 00 	mov    0x280(%rsp),%rdx
  5ad7ef:	00 
  5ad7f0:	48 8d 14 92          	lea    (%rdx,%rdx,4),%rdx
  5ad7f4:	48 8b 0c d1          	mov    (%rcx,%rdx,8),%rcx
  5ad7f8:	48 89 8c 24 38 04 00 	mov    %rcx,0x438(%rsp)
  5ad7ff:	00 
  5ad800:	48 8b 4c 24 10       	mov    0x10(%rsp),%rcx
  5ad805:	08 81 5b 09 00 00    	or     %al,0x95b(%rcx)
  5ad80b:	4d 85 f6             	test   %r14,%r14
  5ad80e:	0f 84 7c 02 00 00    	je     5ada90 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x3a40>
  5ad814:	49 c1 e6 05          	shl    $0x5,%r14
  5ad818:	48 8b 9c 24 98 00 00 	mov    0x98(%rsp),%rbx
  5ad81f:	00 
  5ad820:	49 01 de             	add    %rbx,%r14
  5ad823:	eb 32                	jmp    5ad857 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x3807>
  5ad825:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
  5ad82c:	00 00 00 00 
  5ad830:	0f 10 84 24 90 01 00 	movups 0x190(%rsp),%xmm0
  5ad837:	00 
  5ad838:	0f 10 8c 24 a0 01 00 	movups 0x1a0(%rsp),%xmm1
  5ad83f:	00 
  5ad840:	0f 11 4c 38 f0       	movups %xmm1,-0x10(%rax,%rdi,1)
  5ad845:	0f 11 44 38 e0       	movups %xmm0,-0x20(%rax,%rdi,1)
  5ad84a:	48 83 c3 20          	add    $0x20,%rbx
  5ad84e:	4c 39 f3             	cmp    %r14,%rbx
  5ad851:	0f 84 39 02 00 00    	je     5ada90 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x3a40>
  5ad857:	48 8b 3b             	mov    (%rbx),%rdi
  5ad85a:	48 8b b4 24 28 02 00 	mov    0x228(%rsp),%rsi
  5ad861:	00 
  5ad862:	48 39 f7             	cmp    %rsi,%rdi
  5ad865:	0f 83 b6 20 00 00    	jae    5af921 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x58d1>
  5ad86b:	4c 8b 7b 08          	mov    0x8(%rbx),%r15
  5ad86f:	8b 6b 10             	mov    0x10(%rbx),%ebp
  5ad872:	f2 0f 10 43 14       	movsd  0x14(%rbx),%xmm0
  5ad877:	0f 29 44 24 20       	movaps %xmm0,0x20(%rsp)
  5ad87c:	48 8b 84 24 20 02 00 	mov    0x220(%rsp),%rax
  5ad883:	00 
  5ad884:	48 8d 0c bf          	lea    (%rdi,%rdi,4),%rcx
  5ad888:	4c 8b 24 c8          	mov    (%rax,%rcx,8),%r12
  5ad88c:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  5ad891:	48 8b 80 30 08 00 00 	mov    0x830(%rax),%rax
  5ad898:	48 85 c0             	test   %rax,%rax
  5ad89b:	0f 84 b4 00 00 00    	je     5ad955 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x3905>
  5ad8a1:	48 8b 4c 24 10       	mov    0x10(%rsp),%rcx
  5ad8a6:	48 8b 89 38 08 00 00 	mov    0x838(%rcx),%rcx
  5ad8ad:	0f b7 b8 c2 01 00 00 	movzwl 0x1c2(%rax),%edi
  5ad8b4:	41 89 f8             	mov    %edi,%r8d
  5ad8b7:	41 c1 e0 05          	shl    $0x5,%r8d
  5ad8bb:	48 c7 c2 ff ff ff ff 	mov    $0xffffffffffffffff,%rdx
  5ad8c2:	31 f6                	xor    %esi,%esi
  5ad8c4:	66 66 66 2e 0f 1f 84 	data16 data16 cs nopw 0x0(%rax,%rax,1)
  5ad8cb:	00 00 00 00 00 
  5ad8d0:	49 39 f0             	cmp    %rsi,%r8
  5ad8d3:	74 3b                	je     5ad910 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x38c0>
  5ad8d5:	4c 3b a4 d0 70 01 00 	cmp    0x170(%rax,%rdx,8),%r12
  5ad8dc:	00 
  5ad8dd:	41 0f 97 c1          	seta   %r9b
  5ad8e1:	41 80 d9 00          	sbb    $0x0,%r9b
  5ad8e5:	48 83 c6 20          	add    $0x20,%rsi
  5ad8e9:	48 ff c2             	inc    %rdx
  5ad8ec:	41 80 f9 01          	cmp    $0x1,%r9b
  5ad8f0:	74 de                	je     5ad8d0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x3880>
  5ad8f2:	41 0f b6 f9          	movzbl %r9b,%edi
  5ad8f6:	85 ff                	test   %edi,%edi
  5ad8f8:	74 36                	je     5ad930 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x38e0>
  5ad8fa:	48 83 e9 01          	sub    $0x1,%rcx
  5ad8fe:	73 19                	jae    5ad919 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x38c9>
  5ad900:	eb 53                	jmp    5ad955 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x3905>
  5ad902:	66 66 66 66 66 2e 0f 	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  5ad909:	1f 84 00 00 00 00 00 
  5ad910:	48 89 fa             	mov    %rdi,%rdx
  5ad913:	48 83 e9 01          	sub    $0x1,%rcx
  5ad917:	72 3c                	jb     5ad955 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x3905>
  5ad919:	48 8b 84 d0 c8 01 00 	mov    0x1c8(%rax,%rdx,8),%rax
  5ad920:	00 
  5ad921:	eb 8a                	jmp    5ad8ad <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x385d>
  5ad923:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  5ad92a:	84 00 00 00 00 00 
  5ad930:	f3 0f 10 44 30 f4    	movss  -0xc(%rax,%rsi,1),%xmm0
  5ad936:	0f 2e 44 24 20       	ucomiss 0x20(%rsp),%xmm0
  5ad93b:	75 18                	jne    5ad955 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x3905>
  5ad93d:	7a 16                	jp     5ad955 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x3905>
  5ad93f:	f3 0f 10 44 30 f8    	movss  -0x8(%rax,%rsi,1),%xmm0
  5ad945:	0f 28 4c 24 20       	movaps 0x20(%rsp),%xmm1
  5ad94a:	0f c6 c9 55          	shufps $0x55,%xmm1,%xmm1
  5ad94e:	0f 2e c1             	ucomiss %xmm1,%xmm0
  5ad951:	75 02                	jne    5ad955 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x3905>
  5ad953:	7b 19                	jnp    5ad96e <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x391e>
  5ad955:	48 8b 7c 24 08       	mov    0x8(%rsp),%rdi
  5ad95a:	4c 89 e6             	mov    %r12,%rsi
  5ad95d:	e8 be b3 17 00       	call   728d20 <_RNvMsi_NtNtNtCscdodAO9FK5_5alloc11collections5btree3mapINtB5_8BTreeMapyNtNtB7_7set_val9SetValZSTE6insertCs6gaF1xUz9Bf_4gpui>
  5ad962:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  5ad967:	c6 80 5b 09 00 00 01 	movb   $0x1,0x95b(%rax)
  5ad96e:	4c 89 ac 24 90 01 00 	mov    %r13,0x190(%rsp)
  5ad975:	00 
  5ad976:	4c 89 bc 24 98 01 00 	mov    %r15,0x198(%rsp)
  5ad97d:	00 
  5ad97e:	89 ac 24 a0 01 00 00 	mov    %ebp,0x1a0(%rsp)
  5ad985:	0f 28 44 24 20       	movaps 0x20(%rsp),%xmm0
  5ad98a:	0f 13 84 24 a4 01 00 	movlps %xmm0,0x1a4(%rsp)
  5ad991:	00 
  5ad992:	c6 84 24 ac 01 00 00 	movb   $0x1,0x1ac(%rsp)
  5ad999:	01 
  5ad99a:	48 8b 84 24 08 06 00 	mov    0x608(%rsp),%rax
  5ad9a1:	00 
  5ad9a2:	48 85 c0             	test   %rax,%rax
  5ad9a5:	0f 84 85 00 00 00    	je     5ada30 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x39e0>
  5ad9ab:	48 8b 8c 24 10 06 00 	mov    0x610(%rsp),%rcx
  5ad9b2:	00 
  5ad9b3:	0f b7 b0 c2 01 00 00 	movzwl 0x1c2(%rax),%esi
  5ad9ba:	41 89 f0             	mov    %esi,%r8d
  5ad9bd:	41 c1 e0 05          	shl    $0x5,%r8d
  5ad9c1:	48 c7 c2 ff ff ff ff 	mov    $0xffffffffffffffff,%rdx
  5ad9c8:	31 ff                	xor    %edi,%edi
  5ad9ca:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
  5ad9d0:	49 39 f8             	cmp    %rdi,%r8
  5ad9d3:	74 3b                	je     5ada10 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x39c0>
  5ad9d5:	4c 3b a4 d0 70 01 00 	cmp    0x170(%rax,%rdx,8),%r12
  5ad9dc:	00 
  5ad9dd:	41 0f 97 c1          	seta   %r9b
  5ad9e1:	41 80 d9 00          	sbb    $0x0,%r9b
  5ad9e5:	48 83 c7 20          	add    $0x20,%rdi
  5ad9e9:	48 ff c2             	inc    %rdx
  5ad9ec:	41 80 f9 01          	cmp    $0x1,%r9b
  5ad9f0:	74 de                	je     5ad9d0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x3980>
  5ad9f2:	41 0f b6 f1          	movzbl %r9b,%esi
  5ad9f6:	85 f6                	test   %esi,%esi
  5ad9f8:	0f 84 32 fe ff ff    	je     5ad830 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x37e0>
  5ad9fe:	48 83 e9 01          	sub    $0x1,%rcx
  5ada02:	73 15                	jae    5ada19 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x39c9>
  5ada04:	eb 2c                	jmp    5ada32 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x39e2>
  5ada06:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
  5ada0d:	00 00 00 
  5ada10:	48 89 f2             	mov    %rsi,%rdx
  5ada13:	48 83 e9 01          	sub    $0x1,%rcx
  5ada17:	72 19                	jb     5ada32 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x39e2>
  5ada19:	48 8b 84 d0 c8 01 00 	mov    0x1c8(%rax,%rdx,8),%rax
  5ada20:	00 
  5ada21:	eb 90                	jmp    5ad9b3 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x3963>
  5ada23:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  5ada2a:	84 00 00 00 00 00 
  5ada30:	31 c0                	xor    %eax,%eax
  5ada32:	48 8d 8c 24 08 06 00 	lea    0x608(%rsp),%rcx
  5ada39:	00 
  5ada3a:	48 89 8c 24 a0 00 00 	mov    %rcx,0xa0(%rsp)
  5ada41:	00 
  5ada42:	4c 89 a4 24 a8 00 00 	mov    %r12,0xa8(%rsp)
  5ada49:	00 
  5ada4a:	48 89 84 24 b0 00 00 	mov    %rax,0xb0(%rsp)
  5ada51:	00 
  5ada52:	48 c7 84 24 b8 00 00 	movq   $0x0,0xb8(%rsp)
  5ada59:	00 00 00 00 00 
  5ada5e:	48 89 94 24 c0 00 00 	mov    %rdx,0xc0(%rsp)
  5ada65:	00 
  5ada66:	48 8d bc 24 00 03 00 	lea    0x300(%rsp),%rdi
  5ada6d:	00 
  5ada6e:	48 8d b4 24 a0 00 00 	lea    0xa0(%rsp),%rsi
  5ada75:	00 
  5ada76:	48 8d 94 24 90 01 00 	lea    0x190(%rsp),%rdx
  5ada7d:	00 
  5ada7e:	e8 dd b6 1c 00       	call   779160 <_RNvMs4_NtNtNtNtCscdodAO9FK5_5alloc11collections5btree3map5entryINtB5_11VacantEntryyNtNtNtCs6gaF1xUz9Bf_4gpui7runtime4list7ListRowE12insert_entryB1p_>
  5ada83:	e9 c2 fd ff ff       	jmp    5ad84a <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x37fa>
  5ada88:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  5ada8f:	00 
  5ada90:	48 8b b4 24 90 00 00 	mov    0x90(%rsp),%rsi
  5ada97:	00 
  5ada98:	48 85 f6             	test   %rsi,%rsi
  5ada9b:	74 17                	je     5adab4 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x3a64>
  5ada9d:	48 c1 e6 05          	shl    $0x5,%rsi
  5adaa1:	ba 08 00 00 00       	mov    $0x8,%edx
  5adaa6:	48 8b bc 24 98 00 00 	mov    0x98(%rsp),%rdi
  5adaad:	00 
  5adaae:	ff 15 f4 c4 53 00    	call   *0x53c4f4(%rip)        # ae9fa8 <_DYNAMIC+0x248>
  5adab4:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
  5adab9:	48 89 84 24 c0 00 00 	mov    %rax,0xc0(%rsp)
  5adac0:	00 
  5adac1:	48 8b 44 24 50       	mov    0x50(%rsp),%rax
  5adac6:	48 89 84 24 c8 00 00 	mov    %rax,0xc8(%rsp)
  5adacd:	00 
  5adace:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
  5adad3:	48 89 84 24 d0 00 00 	mov    %rax,0xd0(%rsp)
  5adada:	00 
  5adadb:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
  5adae0:	48 89 84 24 d8 00 00 	mov    %rax,0xd8(%rsp)
  5adae7:	00 
  5adae8:	48 8b 44 24 60       	mov    0x60(%rsp),%rax
  5adaed:	48 89 84 24 e0 00 00 	mov    %rax,0xe0(%rsp)
  5adaf4:	00 
  5adaf5:	0f 28 44 24 40       	movaps 0x40(%rsp),%xmm0
  5adafa:	0f 11 84 24 e8 00 00 	movups %xmm0,0xe8(%rsp)
  5adb01:	00 
  5adb02:	0f 28 44 24 70       	movaps 0x70(%rsp),%xmm0
  5adb07:	0f 11 84 24 f8 00 00 	movups %xmm0,0xf8(%rsp)
  5adb0e:	00 
  5adb0f:	48 8b 44 24 58       	mov    0x58(%rsp),%rax
  5adb14:	48 89 84 24 08 01 00 	mov    %rax,0x108(%rsp)
  5adb1b:	00 
  5adb1c:	48 8b 84 24 d0 04 00 	mov    0x4d0(%rsp),%rax
  5adb23:	00 
  5adb24:	48 89 84 24 a0 00 00 	mov    %rax,0xa0(%rsp)
  5adb2b:	00 
  5adb2c:	66 0f 28 84 24 00 04 	movapd 0x400(%rsp),%xmm0
  5adb33:	00 00 
  5adb35:	48 8d 84 24 a8 00 00 	lea    0xa8(%rsp),%rax
  5adb3c:	00 
  5adb3d:	66 0f 11 00          	movupd %xmm0,(%rax)
  5adb41:	48 8b 84 24 38 04 00 	mov    0x438(%rsp),%rax
  5adb48:	00 
  5adb49:	48 89 84 24 b8 00 00 	mov    %rax,0xb8(%rsp)
  5adb50:	00 
  5adb51:	48 8b 84 24 f0 05 00 	mov    0x5f0(%rsp),%rax
  5adb58:	00 
  5adb59:	48 85 c0             	test   %rax,%rax
  5adb5c:	0f 84 d1 00 00 00    	je     5adc33 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x3be3>
  5adb62:	48 8b 94 24 f8 05 00 	mov    0x5f8(%rsp),%rdx
  5adb69:	00 
  5adb6a:	0f b7 b8 32 05 00 00 	movzwl 0x532(%rax),%edi
  5adb71:	4c 6b c7 70          	imul   $0x70,%rdi,%r8
  5adb75:	48 c7 c1 ff ff ff ff 	mov    $0xffffffffffffffff,%rcx
  5adb7c:	31 f6                	xor    %esi,%esi
  5adb7e:	66 90                	xchg   %ax,%ax
  5adb80:	49 39 f0             	cmp    %rsi,%r8
  5adb83:	74 2b                	je     5adbb0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x3b60>
  5adb85:	4c 3b ac c8 e0 04 00 	cmp    0x4e0(%rax,%rcx,8),%r13
  5adb8c:	00 
  5adb8d:	41 0f 97 c1          	seta   %r9b
  5adb91:	41 80 d9 00          	sbb    $0x0,%r9b
  5adb95:	48 83 c6 70          	add    $0x70,%rsi
  5adb99:	48 ff c1             	inc    %rcx
  5adb9c:	41 80 f9 01          	cmp    $0x1,%r9b
  5adba0:	74 de                	je     5adb80 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x3b30>
  5adba2:	41 0f b6 f9          	movzbl %r9b,%edi
  5adba6:	85 ff                	test   %edi,%edi
  5adba8:	75 09                	jne    5adbb3 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x3b63>
  5adbaa:	eb 24                	jmp    5adbd0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x3b80>
  5adbac:	0f 1f 40 00          	nopl   0x0(%rax)
  5adbb0:	48 89 f9             	mov    %rdi,%rcx
  5adbb3:	48 83 ea 01          	sub    $0x1,%rdx
  5adbb7:	72 7c                	jb     5adc35 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x3be5>
  5adbb9:	48 8b 84 c8 38 05 00 	mov    0x538(%rax,%rcx,8),%rax
  5adbc0:	00 
  5adbc1:	eb a7                	jmp    5adb6a <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x3b1a>
  5adbc3:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  5adbca:	84 00 00 00 00 00 
  5adbd0:	0f 10 84 24 00 01 00 	movups 0x100(%rsp),%xmm0
  5adbd7:	00 
  5adbd8:	0f 11 44 30 f0       	movups %xmm0,-0x10(%rax,%rsi,1)
  5adbdd:	0f 10 84 24 f0 00 00 	movups 0xf0(%rsp),%xmm0
  5adbe4:	00 
  5adbe5:	0f 11 44 30 e0       	movups %xmm0,-0x20(%rax,%rsi,1)
  5adbea:	0f 10 84 24 e0 00 00 	movups 0xe0(%rsp),%xmm0
  5adbf1:	00 
  5adbf2:	0f 11 44 30 d0       	movups %xmm0,-0x30(%rax,%rsi,1)
  5adbf7:	66 0f 10 84 24 a0 00 	movupd 0xa0(%rsp),%xmm0
  5adbfe:	00 00 
  5adc00:	66 0f 10 8c 24 b0 00 	movupd 0xb0(%rsp),%xmm1
  5adc07:	00 00 
  5adc09:	f3 0f 6f 94 24 c0 00 	movdqu 0xc0(%rsp),%xmm2
  5adc10:	00 00 
  5adc12:	0f 10 9c 24 d0 00 00 	movups 0xd0(%rsp),%xmm3
  5adc19:	00 
  5adc1a:	0f 11 5c 30 c0       	movups %xmm3,-0x40(%rax,%rsi,1)
  5adc1f:	f3 0f 7f 54 30 b0    	movdqu %xmm2,-0x50(%rax,%rsi,1)
  5adc25:	66 0f 11 4c 30 a0    	movupd %xmm1,-0x60(%rax,%rsi,1)
  5adc2b:	66 0f 11 44 30 90    	movupd %xmm0,-0x70(%rax,%rsi,1)
  5adc31:	eb 53                	jmp    5adc86 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x3c36>
  5adc33:	31 c0                	xor    %eax,%eax
  5adc35:	48 8d 94 24 f0 05 00 	lea    0x5f0(%rsp),%rdx
  5adc3c:	00 
  5adc3d:	48 89 94 24 00 03 00 	mov    %rdx,0x300(%rsp)
  5adc44:	00 
  5adc45:	4c 89 ac 24 08 03 00 	mov    %r13,0x308(%rsp)
  5adc4c:	00 
  5adc4d:	48 89 84 24 10 03 00 	mov    %rax,0x310(%rsp)
  5adc54:	00 
  5adc55:	48 c7 84 24 18 03 00 	movq   $0x0,0x318(%rsp)
  5adc5c:	00 00 00 00 00 
  5adc61:	48 89 8c 24 20 03 00 	mov    %rcx,0x320(%rsp)
  5adc68:	00 
  5adc69:	48 8d bc 24 90 01 00 	lea    0x190(%rsp),%rdi
  5adc70:	00 
  5adc71:	48 8d b4 24 00 03 00 	lea    0x300(%rsp),%rsi
  5adc78:	00 
  5adc79:	48 8d 94 24 a0 00 00 	lea    0xa0(%rsp),%rdx
  5adc80:	00 
  5adc81:	e8 aa aa 1c 00       	call   778730 <_RNvMs4_NtNtNtNtCscdodAO9FK5_5alloc11collections5btree3map5entryINtB5_11VacantEntryNtNtCs6gaF1xUz9Bf_4gpui4list6ListIdNtNtNtB1m_7runtime4list9ListStateE12insert_entryB1m_>
  5adc86:	4c 8b bc 24 68 02 00 	mov    0x268(%rsp),%r15
  5adc8d:	00 
  5adc8e:	48 8b 9c 24 f8 01 00 	mov    0x1f8(%rsp),%rbx
  5adc95:	00 
  5adc96:	48 8b b4 24 00 02 00 	mov    0x200(%rsp),%rsi
  5adc9d:	00 
  5adc9e:	48 85 f6             	test   %rsi,%rsi
  5adca1:	0f 84 19 f9 ff ff    	je     5ad5c0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x3570>
  5adca7:	48 c1 e6 03          	shl    $0x3,%rsi
  5adcab:	ba 08 00 00 00       	mov    $0x8,%edx
  5adcb0:	48 8b bc 24 78 02 00 	mov    0x278(%rsp),%rdi
  5adcb7:	00 
  5adcb8:	ff 15 ea c2 53 00    	call   *0x53c2ea(%rip)        # ae9fa8 <_DYNAMIC+0x248>
  5adcbe:	e9 fd f8 ff ff       	jmp    5ad5c0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x3570>
  5adcc3:	4c 8b a4 24 70 02 00 	mov    0x270(%rsp),%r12
  5adcca:	00 
  5adccb:	4c 89 a4 24 b8 03 00 	mov    %r12,0x3b8(%rsp)
  5adcd2:	00 
  5adcd3:	48 8b b4 24 70 02 00 	mov    0x270(%rsp),%rsi
  5adcda:	00 
  5adcdb:	48 89 f0             	mov    %rsi,%rax
  5adcde:	4c 29 e0             	sub    %r12,%rax
  5adce1:	48 c1 e8 03          	shr    $0x3,%rax
  5adce5:	48 b9 31 0c c3 30 0c 	movabs $0xc30c30c30c30c31,%rcx
  5adcec:	c3 30 0c 
  5adcef:	48 f7 e1             	mul    %rcx
  5adcf2:	4c 39 e6             	cmp    %r12,%rsi
  5adcf5:	74 5c                	je     5add53 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x3d03>
  5adcf7:	48 89 d3             	mov    %rdx,%rbx
  5adcfa:	49 81 c4 88 00 00 00 	add    $0x88,%r12
  5add01:	4c 8b 35 a0 c2 53 00 	mov    0x53c2a0(%rip),%r14        # ae9fa8 <_DYNAMIC+0x248>
  5add08:	eb 12                	jmp    5add1c <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x3ccc>
  5add0a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
  5add10:	49 81 c4 a8 00 00 00 	add    $0xa8,%r12
  5add17:	48 ff cb             	dec    %rbx
  5add1a:	74 37                	je     5add53 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x3d03>
  5add1c:	49 8b 74 24 90       	mov    -0x70(%r12),%rsi
  5add21:	48 85 f6             	test   %rsi,%rsi
  5add24:	74 11                	je     5add37 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x3ce7>
  5add26:	49 8b 7c 24 98       	mov    -0x68(%r12),%rdi
  5add2b:	48 c1 e6 03          	shl    $0x3,%rsi
  5add2f:	ba 08 00 00 00       	mov    $0x8,%edx
  5add34:	41 ff d6             	call   *%r14
  5add37:	49 8b 74 24 f8       	mov    -0x8(%r12),%rsi
  5add3c:	48 85 f6             	test   %rsi,%rsi
  5add3f:	74 cf                	je     5add10 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x3cc0>
  5add41:	49 8b 3c 24          	mov    (%r12),%rdi
  5add45:	48 c1 e6 05          	shl    $0x5,%rsi
  5add49:	ba 08 00 00 00       	mov    $0x8,%edx
  5add4e:	41 ff d6             	call   *%r14
  5add51:	eb bd                	jmp    5add10 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x3cc0>
  5add53:	4d 85 ff             	test   %r15,%r15
  5add56:	74 1a                	je     5add72 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x3d22>
  5add58:	49 69 f7 a8 00 00 00 	imul   $0xa8,%r15,%rsi
  5add5f:	ba 08 00 00 00       	mov    $0x8,%edx
  5add64:	48 8b bc 24 10 02 00 	mov    0x210(%rsp),%rdi
  5add6b:	00 
  5add6c:	ff 15 36 c2 53 00    	call   *0x53c236(%rip)        # ae9fa8 <_DYNAMIC+0x248>
  5add72:	4c 8b b4 24 50 04 00 	mov    0x450(%rsp),%r14
  5add79:	00 
  5add7a:	48 8b 8c 24 00 06 00 	mov    0x600(%rsp),%rcx
  5add81:	00 
  5add82:	4c 09 f1             	or     %r14,%rcx
  5add85:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  5add8a:	48 8b 80 10 08 00 00 	mov    0x810(%rax),%rax
  5add91:	b2 01                	mov    $0x1,%dl
  5add93:	48 09 c1             	or     %rax,%rcx
  5add96:	0f 84 70 0b 00 00    	je     5ae90c <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x48bc>
  5add9c:	48 85 c0             	test   %rax,%rax
  5add9f:	0f 85 df 00 00 00    	jne    5ade84 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x3e34>
  5adda5:	48 c7 84 24 a0 00 00 	movq   $0x0,0xa0(%rsp)
  5addac:	00 00 00 00 00 
  5addb1:	48 c7 84 24 a8 00 00 	movq   $0x8,0xa8(%rsp)
  5addb8:	00 08 00 00 00 
  5addbd:	48 c7 84 24 78 01 00 	movq   $0x0,0x178(%rsp)
  5addc4:	00 00 00 00 00 
  5addc9:	48 c7 84 24 88 01 00 	movq   $0x0,0x188(%rsp)
  5addd0:	00 00 00 00 00 
  5addd5:	0f 57 c0             	xorps  %xmm0,%xmm0
  5addd8:	0f 11 84 24 b0 00 00 	movups %xmm0,0xb0(%rsp)
  5adddf:	00 
  5adde0:	48 c7 84 24 c0 00 00 	movq   $0x8,0xc0(%rsp)
  5adde7:	00 08 00 00 00 
  5addec:	0f 11 84 24 c8 00 00 	movups %xmm0,0xc8(%rsp)
  5addf3:	00 
  5addf4:	48 c7 84 24 d8 00 00 	movq   $0x8,0xd8(%rsp)
  5addfb:	00 08 00 00 00 
  5ade00:	0f 11 84 24 e0 00 00 	movups %xmm0,0xe0(%rsp)
  5ade07:	00 
  5ade08:	48 c7 84 24 f0 00 00 	movq   $0x8,0xf0(%rsp)
  5ade0f:	00 08 00 00 00 
  5ade14:	0f 11 84 24 f8 00 00 	movups %xmm0,0xf8(%rsp)
  5ade1b:	00 
  5ade1c:	48 c7 84 24 08 01 00 	movq   $0x8,0x108(%rsp)
  5ade23:	00 08 00 00 00 
  5ade28:	48 c7 84 24 10 01 00 	movq   $0x0,0x110(%rsp)
  5ade2f:	00 00 00 00 00 
  5ade34:	48 c7 84 24 18 01 00 	movq   $0xffffffffffffffff,0x118(%rsp)
  5ade3b:	00 ff ff ff ff 
  5ade40:	ff 15 5a c2 53 00    	call   *0x53c25a(%rip)        # aea0a0 <_DYNAMIC+0x340>
  5ade46:	bf f0 00 00 00       	mov    $0xf0,%edi
  5ade4b:	be 08 00 00 00       	mov    $0x8,%esi
  5ade50:	ff 15 4a c1 53 00    	call   *0x53c14a(%rip)        # ae9fa0 <_DYNAMIC+0x240>
  5ade56:	48 85 c0             	test   %rax,%rax
  5ade59:	0f 84 e4 1a 00 00    	je     5af943 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x58f3>
  5ade5f:	48 89 c3             	mov    %rax,%rbx
  5ade62:	48 8d b4 24 a0 00 00 	lea    0xa0(%rsp),%rsi
  5ade69:	00 
  5ade6a:	ba f0 00 00 00       	mov    $0xf0,%edx
  5ade6f:	48 89 c7             	mov    %rax,%rdi
  5ade72:	ff 15 88 c1 53 00    	call   *0x53c188(%rip)        # aea000 <memcpy@GLIBC_2.14>
  5ade78:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  5ade7d:	48 89 98 10 08 00 00 	mov    %rbx,0x810(%rax)
  5ade84:	4d 85 f6             	test   %r14,%r14
  5ade87:	74 38                	je     5adec1 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x3e71>
  5ade89:	4a 8d 04 f5 00 00 00 	lea    0x0(,%r14,8),%rax
  5ade90:	00 
  5ade91:	48 8d 1c 40          	lea    (%rax,%rax,2),%rbx
  5ade95:	ff 15 05 c2 53 00    	call   *0x53c205(%rip)        # aea0a0 <_DYNAMIC+0x340>
  5ade9b:	be 08 00 00 00       	mov    $0x8,%esi
  5adea0:	48 89 df             	mov    %rbx,%rdi
  5adea3:	ff 15 f7 c0 53 00    	call   *0x53c0f7(%rip)        # ae9fa0 <_DYNAMIC+0x240>
  5adea9:	48 85 c0             	test   %rax,%rax
  5adeac:	75 18                	jne    5adec6 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x3e76>
  5adeae:	bf 08 00 00 00       	mov    $0x8,%edi
  5adeb3:	48 89 de             	mov    %rbx,%rsi
  5adeb6:	ff 15 ec c1 53 00    	call   *0x53c1ec(%rip)        # aea0a8 <_DYNAMIC+0x348>
  5adebc:	e9 85 1d 00 00       	jmp    5afc46 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5bf6>
  5adec1:	b8 08 00 00 00       	mov    $0x8,%eax
  5adec6:	48 8b bc 24 40 04 00 	mov    0x440(%rsp),%rdi
  5adecd:	00 
  5adece:	4c 8b a4 24 48 04 00 	mov    0x448(%rsp),%r12
  5aded5:	00 
  5aded6:	4d 6b c6 38          	imul   $0x38,%r14,%r8
  5adeda:	4d 01 e0             	add    %r12,%r8
  5adedd:	48 8b 8c 24 b8 02 00 	mov    0x2b8(%rsp),%rcx
  5adee4:	00 
  5adee5:	48 8b 94 24 c0 02 00 	mov    0x2c0(%rsp),%rdx
  5adeec:	00 
  5adeed:	4c 8b 8c 24 c8 02 00 	mov    0x2c8(%rsp),%r9
  5adef4:	00 
  5adef5:	49 c1 e1 04          	shl    $0x4,%r9
  5adef9:	49 01 d1             	add    %rdx,%r9
  5adefc:	4c 89 b4 24 a0 04 00 	mov    %r14,0x4a0(%rsp)
  5adf03:	00 
  5adf04:	48 89 84 24 a8 04 00 	mov    %rax,0x4a8(%rsp)
  5adf0b:	00 
  5adf0c:	48 c7 84 24 b0 04 00 	movq   $0x0,0x4b0(%rsp)
  5adf13:	00 00 00 00 00 
  5adf18:	0f 57 c0             	xorps  %xmm0,%xmm0
  5adf1b:	0f 11 84 24 e0 00 00 	movups %xmm0,0xe0(%rsp)
  5adf22:	00 
  5adf23:	4c 89 a4 24 a0 00 00 	mov    %r12,0xa0(%rsp)
  5adf2a:	00 
  5adf2b:	4c 89 a4 24 a8 00 00 	mov    %r12,0xa8(%rsp)
  5adf32:	00 
  5adf33:	48 89 7c 24 58       	mov    %rdi,0x58(%rsp)
  5adf38:	48 89 bc 24 b0 00 00 	mov    %rdi,0xb0(%rsp)
  5adf3f:	00 
  5adf40:	4c 89 44 24 60       	mov    %r8,0x60(%rsp)
  5adf45:	4c 89 84 24 b8 00 00 	mov    %r8,0xb8(%rsp)
  5adf4c:	00 
  5adf4d:	48 89 94 24 c0 00 00 	mov    %rdx,0xc0(%rsp)
  5adf54:	00 
  5adf55:	48 89 54 24 50       	mov    %rdx,0x50(%rsp)
  5adf5a:	48 89 94 24 c8 00 00 	mov    %rdx,0xc8(%rsp)
  5adf61:	00 
  5adf62:	48 89 4c 24 30       	mov    %rcx,0x30(%rsp)
  5adf67:	48 89 8c 24 d0 00 00 	mov    %rcx,0xd0(%rsp)
  5adf6e:	00 
  5adf6f:	4c 89 4c 24 18       	mov    %r9,0x18(%rsp)
  5adf74:	4c 89 8c 24 d8 00 00 	mov    %r9,0xd8(%rsp)
  5adf7b:	00 
  5adf7c:	4c 89 64 24 38       	mov    %r12,0x38(%rsp)
  5adf81:	4d 85 f6             	test   %r14,%r14
  5adf84:	0f 84 47 08 00 00    	je     5ae7d1 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4781>
  5adf8a:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
  5adf8f:	48 8b 54 24 50       	mov    0x50(%rsp),%rdx
  5adf94:	eb 40                	jmp    5adfd6 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x3f86>
  5adf96:	48 8b 84 24 a8 04 00 	mov    0x4a8(%rsp),%rax
  5adf9d:	00 
  5adf9e:	48 8d 0c 5b          	lea    (%rbx,%rbx,2),%rcx
  5adfa2:	4c 89 2c c8          	mov    %r13,(%rax,%rcx,8)
  5adfa6:	0f 28 44 24 20       	movaps 0x20(%rsp),%xmm0
  5adfab:	0f 11 44 c8 08       	movups %xmm0,0x8(%rax,%rcx,8)
  5adfb0:	48 ff c3             	inc    %rbx
  5adfb3:	48 89 9c 24 b0 04 00 	mov    %rbx,0x4b0(%rsp)
  5adfba:	00 
  5adfbb:	48 8b 4c 24 70       	mov    0x70(%rsp),%rcx
  5adfc0:	48 89 c8             	mov    %rcx,%rax
  5adfc3:	48 8b 94 24 98 00 00 	mov    0x98(%rsp),%rdx
  5adfca:	00 
  5adfcb:	48 3b 4c 24 60       	cmp    0x60(%rsp),%rcx
  5adfd0:	0f 84 82 08 00 00    	je     5ae858 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4808>
  5adfd6:	4c 8d 60 38          	lea    0x38(%rax),%r12
  5adfda:	4c 89 a4 24 a8 00 00 	mov    %r12,0xa8(%rsp)
  5adfe1:	00 
  5adfe2:	4c 8b 38             	mov    (%rax),%r15
  5adfe5:	49 83 ff fe          	cmp    $0xfffffffffffffffe,%r15
  5adfe9:	0f 84 e2 07 00 00    	je     5ae7d1 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4781>
  5adfef:	48 8b 68 08          	mov    0x8(%rax),%rbp
  5adff3:	48 8b 58 18          	mov    0x18(%rax),%rbx
  5adff7:	4c 8b 70 20          	mov    0x20(%rax),%r14
  5adffb:	48 3b 54 24 18       	cmp    0x18(%rsp),%rdx
  5ae000:	0f 84 93 07 00 00    	je     5ae799 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4749>
  5ae006:	48 8b 48 10          	mov    0x10(%rax),%rcx
  5ae00a:	48 8d 72 10          	lea    0x10(%rdx),%rsi
  5ae00e:	48 89 b4 24 98 00 00 	mov    %rsi,0x98(%rsp)
  5ae015:	00 
  5ae016:	48 89 b4 24 c8 00 00 	mov    %rsi,0xc8(%rsp)
  5ae01d:	00 
  5ae01e:	f3 0f 6f 02          	movdqu (%rdx),%xmm0
  5ae022:	66 0f 7f 84 24 a0 07 	movdqa %xmm0,0x7a0(%rsp)
  5ae029:	00 00 
  5ae02b:	8b 78 30             	mov    0x30(%rax),%edi
  5ae02e:	48 8b b4 24 28 02 00 	mov    0x228(%rsp),%rsi
  5ae035:	00 
  5ae036:	48 39 fe             	cmp    %rdi,%rsi
  5ae039:	0f 86 40 1a 00 00    	jbe    5afa7f <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5a2f>
  5ae03f:	48 8b 94 24 20 02 00 	mov    0x220(%rsp),%rdx
  5ae046:	00 
  5ae047:	48 8d 34 bf          	lea    (%rdi,%rdi,4),%rsi
  5ae04b:	48 8b 14 f2          	mov    (%rdx,%rsi,8),%rdx
  5ae04f:	48 89 54 24 08       	mov    %rdx,0x8(%rsp)
  5ae054:	48 8b 54 24 10       	mov    0x10(%rsp),%rdx
  5ae059:	48 8b b2 10 08 00 00 	mov    0x810(%rdx),%rsi
  5ae060:	48 8b 56 10          	mov    0x10(%rsi),%rdx
  5ae064:	48 85 d2             	test   %rdx,%rdx
  5ae067:	4c 89 64 24 70       	mov    %r12,0x70(%rsp)
  5ae06c:	74 53                	je     5ae0c1 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4071>
  5ae06e:	4c 8b 5e 08          	mov    0x8(%rsi),%r11
  5ae072:	48 83 fa 01          	cmp    $0x1,%rdx
  5ae076:	75 0c                	jne    5ae084 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4034>
  5ae078:	48 8b 54 24 08       	mov    0x8(%rsp),%rdx
  5ae07d:	49 39 13             	cmp    %rdx,(%r11)
  5ae080:	74 42                	je     5ae0c4 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4074>
  5ae082:	eb 3d                	jmp    5ae0c1 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4071>
  5ae084:	31 f6                	xor    %esi,%esi
  5ae086:	4c 8b 54 24 08       	mov    0x8(%rsp),%r10
  5ae08b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
  5ae090:	48 89 f7             	mov    %rsi,%rdi
  5ae093:	49 89 d0             	mov    %rdx,%r8
  5ae096:	49 d1 e8             	shr    $1,%r8
  5ae099:	4c 01 c6             	add    %r8,%rsi
  5ae09c:	4c 8d 0c 76          	lea    (%rsi,%rsi,2),%r9
  5ae0a0:	4f 39 14 cb          	cmp    %r10,(%r11,%r9,8)
  5ae0a4:	48 0f 47 f7          	cmova  %rdi,%rsi
  5ae0a8:	4c 29 c2             	sub    %r8,%rdx
  5ae0ab:	48 83 fa 01          	cmp    $0x1,%rdx
  5ae0af:	77 df                	ja     5ae090 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4040>
  5ae0b1:	48 8d 14 76          	lea    (%rsi,%rsi,2),%rdx
  5ae0b5:	4d 39 14 d3          	cmp    %r10,(%r11,%rdx,8)
  5ae0b9:	75 06                	jne    5ae0c1 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4071>
  5ae0bb:	4d 8d 1c d3          	lea    (%r11,%rdx,8),%r11
  5ae0bf:	eb 03                	jmp    5ae0c4 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4074>
  5ae0c1:	45 31 db             	xor    %r11d,%r11d
  5ae0c4:	4c 89 5c 24 40       	mov    %r11,0x40(%rsp)
  5ae0c9:	48 8b 40 28          	mov    0x28(%rax),%rax
  5ae0cd:	66 0f ef c0          	pxor   %xmm0,%xmm0
  5ae0d1:	66 0f 7f 84 24 70 05 	movdqa %xmm0,0x570(%rsp)
  5ae0d8:	00 00 
  5ae0da:	4c 89 bc 24 10 03 00 	mov    %r15,0x310(%rsp)
  5ae0e1:	00 
  5ae0e2:	48 89 ac 24 18 03 00 	mov    %rbp,0x318(%rsp)
  5ae0e9:	00 
  5ae0ea:	48 89 8c 24 20 03 00 	mov    %rcx,0x320(%rsp)
  5ae0f1:	00 
  5ae0f2:	48 89 9c 24 28 03 00 	mov    %rbx,0x328(%rsp)
  5ae0f9:	00 
  5ae0fa:	4c 89 b4 24 30 03 00 	mov    %r14,0x330(%rsp)
  5ae101:	00 
  5ae102:	48 89 84 24 38 03 00 	mov    %rax,0x338(%rsp)
  5ae109:	00 
  5ae10a:	48 c7 84 24 08 03 00 	movq   $0x2,0x308(%rsp)
  5ae111:	00 02 00 00 00 
  5ae116:	48 c7 84 24 40 03 00 	movq   $0x0,0x340(%rsp)
  5ae11d:	00 00 00 00 00 
  5ae122:	41 bf 02 00 00 00    	mov    $0x2,%r15d
  5ae128:	31 c9                	xor    %ecx,%ecx
  5ae12a:	4c 8d a4 24 10 03 00 	lea    0x310(%rsp),%r12
  5ae131:	00 
  5ae132:	4c 8b 6c 24 08       	mov    0x8(%rsp),%r13
  5ae137:	eb 23                	jmp    5ae15c <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x410c>
  5ae139:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  5ae140:	48 8b 84 24 00 03 00 	mov    0x300(%rsp),%rax
  5ae147:	00 
  5ae148:	4c 8b bc 24 08 03 00 	mov    0x308(%rsp),%r15
  5ae14f:	00 
  5ae150:	48 89 c1             	mov    %rax,%rcx
  5ae153:	49 39 c7             	cmp    %rax,%r15
  5ae156:	0f 84 41 05 00 00    	je     5ae69d <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x464d>
  5ae15c:	48 8d 41 01          	lea    0x1(%rcx),%rax
  5ae160:	48 89 84 24 00 03 00 	mov    %rax,0x300(%rsp)
  5ae167:	00 
  5ae168:	48 8d 0c 49          	lea    (%rcx,%rcx,2),%rcx
  5ae16c:	4d 8b 34 cc          	mov    (%r12,%rcx,8),%r14
  5ae170:	49 83 fe fe          	cmp    $0xfffffffffffffffe,%r14
  5ae174:	0f 84 1e 05 00 00    	je     5ae698 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4648>
  5ae17a:	48 8b 9c 24 40 03 00 	mov    0x340(%rsp),%rbx
  5ae181:	00 
  5ae182:	48 8d 53 01          	lea    0x1(%rbx),%rdx
  5ae186:	48 89 94 24 40 03 00 	mov    %rdx,0x340(%rsp)
  5ae18d:	00 
  5ae18e:	49 83 fe ff          	cmp    $0xffffffffffffffff,%r14
  5ae192:	74 bc                	je     5ae150 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4100>
  5ae194:	49 8d 04 cc          	lea    (%r12,%rcx,8),%rax
  5ae198:	48 8b 70 08          	mov    0x8(%rax),%rsi
  5ae19c:	48 8b 40 10          	mov    0x10(%rax),%rax
  5ae1a0:	48 b9 01 00 00 00 00 	movabs $0x8000000000000001,%rcx
  5ae1a7:	00 00 80 
  5ae1aa:	48 ff c1             	inc    %rcx
  5ae1ad:	49 39 ce             	cmp    %rcx,%r14
  5ae1b0:	48 89 74 24 20       	mov    %rsi,0x20(%rsp)
  5ae1b5:	0f 85 d5 00 00 00    	jne    5ae290 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4240>
  5ae1bb:	48 8d bc 24 00 04 00 	lea    0x400(%rsp),%rdi
  5ae1c2:	00 
  5ae1c3:	ff 50 28             	call   *0x28(%rax)
  5ae1c6:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  5ae1cb:	48 85 f6             	test   %rsi,%rsi
  5ae1ce:	0f 84 e6 00 00 00    	je     5ae2ba <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x426a>
  5ae1d4:	31 c9                	xor    %ecx,%ecx
  5ae1d6:	48 85 db             	test   %rbx,%rbx
  5ae1d9:	0f 95 c1             	setne  %cl
  5ae1dc:	48 83 7c ce 08 00    	cmpq   $0x0,0x8(%rsi,%rcx,8)
  5ae1e2:	48 8b 54 24 10       	mov    0x10(%rsp),%rdx
  5ae1e7:	48 8b 82 00 09 00 00 	mov    0x900(%rdx),%rax
  5ae1ee:	0f 84 d2 00 00 00    	je     5ae2c6 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4276>
  5ae1f4:	48 8d 0c cd 08 00 00 	lea    0x8(,%rcx,8),%rcx
  5ae1fb:	00 
  5ae1fc:	48 ff c0             	inc    %rax
  5ae1ff:	48 89 82 00 09 00 00 	mov    %rax,0x900(%rdx)
  5ae206:	48 8b 94 24 10 04 00 	mov    0x410(%rsp),%rdx
  5ae20d:	00 
  5ae20e:	48 8b 2c 0e          	mov    (%rsi,%rcx,1),%rbp
  5ae212:	4c 8b 7d 00          	mov    0x0(%rbp),%r15
  5ae216:	4c 89 f8             	mov    %r15,%rax
  5ae219:	48 d1 e8             	shr    $1,%rax
  5ae21c:	48 39 d0             	cmp    %rdx,%rax
  5ae21f:	0f 85 ab 00 00 00    	jne    5ae2d0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4280>
  5ae225:	48 8b b4 24 08 04 00 	mov    0x408(%rsp),%rsi
  5ae22c:	00 
  5ae22d:	48 8d 7d 10          	lea    0x10(%rbp),%rdi
  5ae231:	ff 15 b9 bd 53 00    	call   *0x53bdb9(%rip)        # ae9ff0 <bcmp@GLIBC_2.2.5>
  5ae237:	85 c0                	test   %eax,%eax
  5ae239:	0f 85 91 00 00 00    	jne    5ae2d0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4280>
  5ae23f:	41 f6 c7 01          	test   $0x1,%r15b
  5ae243:	75 30                	jne    5ae275 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4225>
  5ae245:	48 8b 45 08          	mov    0x8(%rbp),%rax
  5ae249:	a8 01                	test   $0x1,%al
  5ae24b:	75 28                	jne    5ae275 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4225>
  5ae24d:	b8 02 00 00 00       	mov    $0x2,%eax
  5ae252:	f0 48 0f c1 45 08    	lock xadd %rax,0x8(%rbp)
  5ae258:	48 b9 01 00 00 00 00 	movabs $0x8000000000000001,%rcx
  5ae25f:	00 00 80 
  5ae262:	48 21 c8             	and    %rcx,%rax
  5ae265:	48 3b 84 24 50 02 00 	cmp    0x250(%rsp),%rax
  5ae26c:	00 
  5ae26d:	75 06                	jne    5ae275 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4225>
  5ae26f:	f0 48 83 4d 08 01    	lock orq $0x1,0x8(%rbp)
  5ae275:	48 83 fb 01          	cmp    $0x1,%rbx
  5ae279:	0f 86 81 03 00 00    	jbe    5ae600 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x45b0>
  5ae27f:	e9 b0 18 00 00       	jmp    5afb34 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5ae4>
  5ae284:	66 66 66 2e 0f 1f 84 	data16 data16 cs nopw 0x0(%rax,%rax,1)
  5ae28b:	00 00 00 00 00 
  5ae290:	48 89 b4 24 08 04 00 	mov    %rsi,0x408(%rsp)
  5ae297:	00 
  5ae298:	48 89 84 24 10 04 00 	mov    %rax,0x410(%rsp)
  5ae29f:	00 
  5ae2a0:	48 c7 84 24 00 04 00 	movq   $0xffffffffffffffff,0x400(%rsp)
  5ae2a7:	00 ff ff ff ff 
  5ae2ac:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  5ae2b1:	48 85 f6             	test   %rsi,%rsi
  5ae2b4:	0f 85 1a ff ff ff    	jne    5ae1d4 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4184>
  5ae2ba:	48 8b 54 24 10       	mov    0x10(%rsp),%rdx
  5ae2bf:	48 8b 82 00 09 00 00 	mov    0x900(%rdx),%rax
  5ae2c6:	48 ff c0             	inc    %rax
  5ae2c9:	48 89 82 00 09 00 00 	mov    %rax,0x900(%rdx)
  5ae2d0:	48 83 fb 02          	cmp    $0x2,%rbx
  5ae2d4:	0f 83 7e 16 00 00    	jae    5af958 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5908>
  5ae2da:	4c 8b ac dc a0 07 00 	mov    0x7a0(%rsp,%rbx,8),%r13
  5ae2e1:	00 
  5ae2e2:	4d 85 ed             	test   %r13,%r13
  5ae2e5:	0f 84 85 00 00 00    	je     5ae370 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4320>
  5ae2eb:	48 8b 84 24 58 04 00 	mov    0x458(%rsp),%rax
  5ae2f2:	00 
  5ae2f3:	48 85 c0             	test   %rax,%rax
  5ae2f6:	0f 84 50 01 00 00    	je     5ae44c <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x43fc>
  5ae2fc:	48 8b 8c 24 60 04 00 	mov    0x460(%rsp),%rcx
  5ae303:	00 
  5ae304:	0f b7 b0 ba 00 00 00 	movzwl 0xba(%rax),%esi
  5ae30b:	89 f7                	mov    %esi,%edi
  5ae30d:	c1 e7 03             	shl    $0x3,%edi
  5ae310:	48 c7 c2 ff ff ff ff 	mov    $0xffffffffffffffff,%rdx
  5ae317:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
  5ae31e:	00 00 
  5ae320:	48 85 ff             	test   %rdi,%rdi
  5ae323:	74 2b                	je     5ae350 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4300>
  5ae325:	4c 3b 6c d0 10       	cmp    0x10(%rax,%rdx,8),%r13
  5ae32a:	41 0f 97 c0          	seta   %r8b
  5ae32e:	41 80 d8 00          	sbb    $0x0,%r8b
  5ae332:	48 ff c2             	inc    %rdx
  5ae335:	48 83 c7 f8          	add    $0xfffffffffffffff8,%rdi
  5ae339:	41 80 f8 01          	cmp    $0x1,%r8b
  5ae33d:	74 e1                	je     5ae320 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x42d0>
  5ae33f:	41 0f b6 f0          	movzbl %r8b,%esi
  5ae343:	85 f6                	test   %esi,%esi
  5ae345:	75 0c                	jne    5ae353 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4303>
  5ae347:	e9 b4 00 00 00       	jmp    5ae400 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x43b0>
  5ae34c:	0f 1f 40 00          	nopl   0x0(%rax)
  5ae350:	48 89 f2             	mov    %rsi,%rdx
  5ae353:	48 83 e9 01          	sub    $0x1,%rcx
  5ae357:	0f 82 ef 00 00 00    	jb     5ae44c <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x43fc>
  5ae35d:	48 8b 84 d0 c0 00 00 	mov    0xc0(%rax,%rdx,8),%rax
  5ae364:	00 
  5ae365:	eb 9d                	jmp    5ae304 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x42b4>
  5ae367:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
  5ae36e:	00 00 
  5ae370:	4c 8b a4 24 10 04 00 	mov    0x410(%rsp),%r12
  5ae377:	00 
  5ae378:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  5ae37d:	f3 0f 6f 80 08 09 00 	movdqu 0x908(%rax),%xmm0
  5ae384:	00 
  5ae385:	66 49 0f 6e cc       	movq   %r12,%xmm1
  5ae38a:	66 0f 6f 15 3e ea ab 	movdqa -0x5415c2(%rip),%xmm2        # 6cdd0 <anon.5f884de6e78125e25881320d811d32df.391.llvm.17146438997930651657+0xd80>
  5ae391:	ff 
  5ae392:	66 0f 6c d1          	punpcklqdq %xmm1,%xmm2
  5ae396:	66 0f d4 d0          	paddq  %xmm0,%xmm2
  5ae39a:	f3 0f 7f 90 08 09 00 	movdqu %xmm2,0x908(%rax)
  5ae3a1:	00 
  5ae3a2:	48 8d 2d e7 f3 ab ff 	lea    -0x540c19(%rip),%rbp        # 6d790 <anon.1f6b7bab1fc61e0fcd36456038a862fb.80.llvm.12454362996328431623>
  5ae3a9:	4d 85 e4             	test   %r12,%r12
  5ae3ac:	0f 84 4e 02 00 00    	je     5ae600 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x45b0>
  5ae3b2:	4c 8b bc 24 08 04 00 	mov    0x408(%rsp),%r15
  5ae3b9:	00 
  5ae3ba:	48 8d bc 24 90 01 00 	lea    0x190(%rsp),%rdi
  5ae3c1:	00 
  5ae3c2:	4c 89 e6             	mov    %r12,%rsi
  5ae3c5:	31 d2                	xor    %edx,%edx
  5ae3c7:	31 c9                	xor    %ecx,%ecx
  5ae3c9:	ff 15 29 bc 53 00    	call   *0x53bc29(%rip)        # ae9ff8 <_DYNAMIC+0x298>
  5ae3cf:	48 8b bc 24 90 01 00 	mov    0x190(%rsp),%rdi
  5ae3d6:	00 
  5ae3d7:	48 83 ff ff          	cmp    $0xffffffffffffffff,%rdi
  5ae3db:	0f 85 ab 15 00 00    	jne    5af98c <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x593c>
  5ae3e1:	48 8b ac 24 98 01 00 	mov    0x198(%rsp),%rbp
  5ae3e8:	00 
  5ae3e9:	48 8d 7d 10          	lea    0x10(%rbp),%rdi
  5ae3ed:	4c 89 fe             	mov    %r15,%rsi
  5ae3f0:	4c 89 e2             	mov    %r12,%rdx
  5ae3f3:	ff 15 07 bc 53 00    	call   *0x53bc07(%rip)        # aea000 <memcpy@GLIBC_2.14>
  5ae3f9:	e9 02 02 00 00       	jmp    5ae600 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x45b0>
  5ae3fe:	66 90                	xchg   %ax,%ax
  5ae400:	48 8b 6c d0 60       	mov    0x60(%rax,%rdx,8),%rbp
  5ae405:	f6 45 00 01          	testb  $0x1,0x0(%rbp)
  5ae409:	0f 85 f1 01 00 00    	jne    5ae600 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x45b0>
  5ae40f:	48 8b 45 08          	mov    0x8(%rbp),%rax
  5ae413:	a8 01                	test   $0x1,%al
  5ae415:	0f 85 e5 01 00 00    	jne    5ae600 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x45b0>
  5ae41b:	b8 02 00 00 00       	mov    $0x2,%eax
  5ae420:	f0 48 0f c1 45 08    	lock xadd %rax,0x8(%rbp)
  5ae426:	48 b9 01 00 00 00 00 	movabs $0x8000000000000001,%rcx
  5ae42d:	00 00 80 
  5ae430:	48 21 c8             	and    %rcx,%rax
  5ae433:	48 3b 84 24 50 02 00 	cmp    0x250(%rsp),%rax
  5ae43a:	00 
  5ae43b:	0f 85 bf 01 00 00    	jne    5ae600 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x45b0>
  5ae441:	f0 48 83 4d 08 01    	lock orq $0x1,0x8(%rbp)
  5ae447:	e9 b4 01 00 00       	jmp    5ae600 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x45b0>
  5ae44c:	4c 8b a4 24 10 04 00 	mov    0x410(%rsp),%r12
  5ae453:	00 
  5ae454:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  5ae459:	f3 0f 6f 80 08 09 00 	movdqu 0x908(%rax),%xmm0
  5ae460:	00 
  5ae461:	66 49 0f 6e cc       	movq   %r12,%xmm1
  5ae466:	66 0f 6f 15 62 e9 ab 	movdqa -0x54169e(%rip),%xmm2        # 6cdd0 <anon.5f884de6e78125e25881320d811d32df.391.llvm.17146438997930651657+0xd80>
  5ae46d:	ff 
  5ae46e:	66 0f 6c d1          	punpcklqdq %xmm1,%xmm2
  5ae472:	66 0f d4 d0          	paddq  %xmm0,%xmm2
  5ae476:	f3 0f 7f 90 08 09 00 	movdqu %xmm2,0x908(%rax)
  5ae47d:	00 
  5ae47e:	48 8d 2d 0b f3 ab ff 	lea    -0x540cf5(%rip),%rbp        # 6d790 <anon.1f6b7bab1fc61e0fcd36456038a862fb.80.llvm.12454362996328431623>
  5ae485:	4d 85 e4             	test   %r12,%r12
  5ae488:	74 47                	je     5ae4d1 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4481>
  5ae48a:	4c 8b bc 24 08 04 00 	mov    0x408(%rsp),%r15
  5ae491:	00 
  5ae492:	48 8d bc 24 90 01 00 	lea    0x190(%rsp),%rdi
  5ae499:	00 
  5ae49a:	4c 89 e6             	mov    %r12,%rsi
  5ae49d:	31 d2                	xor    %edx,%edx
  5ae49f:	31 c9                	xor    %ecx,%ecx
  5ae4a1:	ff 15 51 bb 53 00    	call   *0x53bb51(%rip)        # ae9ff8 <_DYNAMIC+0x298>
  5ae4a7:	48 8b bc 24 90 01 00 	mov    0x190(%rsp),%rdi
  5ae4ae:	00 
  5ae4af:	48 83 ff ff          	cmp    $0xffffffffffffffff,%rdi
  5ae4b3:	0f 85 d3 14 00 00    	jne    5af98c <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x593c>
  5ae4b9:	48 8b ac 24 98 01 00 	mov    0x198(%rsp),%rbp
  5ae4c0:	00 
  5ae4c1:	48 8d 7d 10          	lea    0x10(%rbp),%rdi
  5ae4c5:	4c 89 fe             	mov    %r15,%rsi
  5ae4c8:	4c 89 e2             	mov    %r12,%rdx
  5ae4cb:	ff 15 2f bb 53 00    	call   *0x53bb2f(%rip)        # aea000 <memcpy@GLIBC_2.14>
  5ae4d1:	f6 45 00 01          	testb  $0x1,0x0(%rbp)
  5ae4d5:	75 30                	jne    5ae507 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x44b7>
  5ae4d7:	48 8b 45 08          	mov    0x8(%rbp),%rax
  5ae4db:	a8 01                	test   $0x1,%al
  5ae4dd:	75 28                	jne    5ae507 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x44b7>
  5ae4df:	b8 02 00 00 00       	mov    $0x2,%eax
  5ae4e4:	f0 48 0f c1 45 08    	lock xadd %rax,0x8(%rbp)
  5ae4ea:	48 b9 01 00 00 00 00 	movabs $0x8000000000000001,%rcx
  5ae4f1:	00 00 80 
  5ae4f4:	48 21 c8             	and    %rcx,%rax
  5ae4f7:	48 3b 84 24 50 02 00 	cmp    0x250(%rsp),%rax
  5ae4fe:	00 
  5ae4ff:	75 06                	jne    5ae507 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x44b7>
  5ae501:	f0 48 83 4d 08 01    	lock orq $0x1,0x8(%rbp)
  5ae507:	48 8b 84 24 58 04 00 	mov    0x458(%rsp),%rax
  5ae50e:	00 
  5ae50f:	48 85 c0             	test   %rax,%rax
  5ae512:	0f 84 92 00 00 00    	je     5ae5aa <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x455a>
  5ae518:	48 8b 8c 24 60 04 00 	mov    0x460(%rsp),%rcx
  5ae51f:	00 
  5ae520:	0f b7 b0 ba 00 00 00 	movzwl 0xba(%rax),%esi
  5ae527:	89 f7                	mov    %esi,%edi
  5ae529:	c1 e7 03             	shl    $0x3,%edi
  5ae52c:	48 c7 c2 ff ff ff ff 	mov    $0xffffffffffffffff,%rdx
  5ae533:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  5ae53a:	84 00 00 00 00 00 
  5ae540:	48 85 ff             	test   %rdi,%rdi
  5ae543:	74 24                	je     5ae569 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4519>
  5ae545:	4c 3b 6c d0 10       	cmp    0x10(%rax,%rdx,8),%r13
  5ae54a:	41 0f 97 c0          	seta   %r8b
  5ae54e:	41 80 d8 00          	sbb    $0x0,%r8b
  5ae552:	48 ff c2             	inc    %rdx
  5ae555:	48 83 c7 f8          	add    $0xfffffffffffffff8,%rdi
  5ae559:	41 80 f8 01          	cmp    $0x1,%r8b
  5ae55d:	74 e1                	je     5ae540 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x44f0>
  5ae55f:	41 0f b6 f0          	movzbl %r8b,%esi
  5ae563:	85 f6                	test   %esi,%esi
  5ae565:	75 05                	jne    5ae56c <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x451c>
  5ae567:	eb 13                	jmp    5ae57c <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x452c>
  5ae569:	48 89 f2             	mov    %rsi,%rdx
  5ae56c:	48 83 e9 01          	sub    $0x1,%rcx
  5ae570:	72 3a                	jb     5ae5ac <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x455c>
  5ae572:	48 8b 84 d0 c0 00 00 	mov    0xc0(%rax,%rdx,8),%rax
  5ae579:	00 
  5ae57a:	eb a4                	jmp    5ae520 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x44d0>
  5ae57c:	48 8b 7c d0 60       	mov    0x60(%rax,%rdx,8),%rdi
  5ae581:	48 89 6c d0 60       	mov    %rbp,0x60(%rax,%rdx,8)
  5ae586:	f6 07 01             	testb  $0x1,(%rdi)
  5ae589:	75 75                	jne    5ae600 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x45b0>
  5ae58b:	48 8b 47 08          	mov    0x8(%rdi),%rax
  5ae58f:	a8 01                	test   $0x1,%al
  5ae591:	75 6d                	jne    5ae600 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x45b0>
  5ae593:	48 8d 47 08          	lea    0x8(%rdi),%rax
  5ae597:	f0 48 83 28 02       	lock subq $0x2,(%rax)
  5ae59c:	75 62                	jne    5ae600 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x45b0>
  5ae59e:	48 8b 47 08          	mov    0x8(%rdi),%rax
  5ae5a2:	ff 15 60 ba 53 00    	call   *0x53ba60(%rip)        # aea008 <_DYNAMIC+0x2a8>
  5ae5a8:	eb 56                	jmp    5ae600 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x45b0>
  5ae5aa:	31 c0                	xor    %eax,%eax
  5ae5ac:	4c 89 ac 24 90 01 00 	mov    %r13,0x190(%rsp)
  5ae5b3:	00 
  5ae5b4:	48 8d 8c 24 58 04 00 	lea    0x458(%rsp),%rcx
  5ae5bb:	00 
  5ae5bc:	48 89 8c 24 98 01 00 	mov    %rcx,0x198(%rsp)
  5ae5c3:	00 
  5ae5c4:	48 89 84 24 a0 01 00 	mov    %rax,0x1a0(%rsp)
  5ae5cb:	00 
  5ae5cc:	48 c7 84 24 a8 01 00 	movq   $0x0,0x1a8(%rsp)
  5ae5d3:	00 00 00 00 00 
  5ae5d8:	48 89 94 24 b0 01 00 	mov    %rdx,0x1b0(%rsp)
  5ae5df:	00 
  5ae5e0:	48 8d bc 24 b0 03 00 	lea    0x3b0(%rsp),%rdi
  5ae5e7:	00 
  5ae5e8:	48 8d b4 24 90 01 00 	lea    0x190(%rsp),%rsi
  5ae5ef:	00 
  5ae5f0:	48 89 ea             	mov    %rbp,%rdx
  5ae5f3:	e8 58 a2 1c 00       	call   778850 <_RNvMs4_NtNtNtNtCscdodAO9FK5_5alloc11collections5btree3map5entryINtB5_11VacantEntryNtNtCs6gaF1xUz9Bf_4gpui6source7FieldIdNtNtB1m_11shared_text10SharedTextE12insert_entryB1m_>
  5ae5f8:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  5ae5ff:	00 
  5ae600:	48 8b bc dc 70 05 00 	mov    0x570(%rsp,%rbx,8),%rdi
  5ae607:	00 
  5ae608:	48 85 ff             	test   %rdi,%rdi
  5ae60b:	74 23                	je     5ae630 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x45e0>
  5ae60d:	f6 07 01             	testb  $0x1,(%rdi)
  5ae610:	75 1e                	jne    5ae630 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x45e0>
  5ae612:	48 8b 47 08          	mov    0x8(%rdi),%rax
  5ae616:	a8 01                	test   $0x1,%al
  5ae618:	75 16                	jne    5ae630 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x45e0>
  5ae61a:	48 8d 47 08          	lea    0x8(%rdi),%rax
  5ae61e:	f0 48 83 28 02       	lock subq $0x2,(%rax)
  5ae623:	74 67                	je     5ae68c <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x463c>
  5ae625:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
  5ae62c:	00 00 00 00 
  5ae630:	48 89 ac dc 70 05 00 	mov    %rbp,0x570(%rsp,%rbx,8)
  5ae637:	00 
  5ae638:	48 8b b4 24 00 04 00 	mov    0x400(%rsp),%rsi
  5ae63f:	00 
  5ae640:	48 83 fe ff          	cmp    $0xffffffffffffffff,%rsi
  5ae644:	74 18                	je     5ae65e <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x460e>
  5ae646:	48 85 f6             	test   %rsi,%rsi
  5ae649:	74 13                	je     5ae65e <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x460e>
  5ae64b:	48 8b bc 24 08 04 00 	mov    0x408(%rsp),%rdi
  5ae652:	00 
  5ae653:	ba 01 00 00 00       	mov    $0x1,%edx
  5ae658:	ff 15 4a b9 53 00    	call   *0x53b94a(%rip)        # ae9fa8 <_DYNAMIC+0x248>
  5ae65e:	4d 85 f6             	test   %r14,%r14
  5ae661:	4c 8d a4 24 10 03 00 	lea    0x310(%rsp),%r12
  5ae668:	00 
  5ae669:	4c 8b 6c 24 08       	mov    0x8(%rsp),%r13
  5ae66e:	0f 8e cc fa ff ff    	jle    5ae140 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x40f0>
  5ae674:	ba 01 00 00 00       	mov    $0x1,%edx
  5ae679:	48 8b 7c 24 20       	mov    0x20(%rsp),%rdi
  5ae67e:	4c 89 f6             	mov    %r14,%rsi
  5ae681:	ff 15 21 b9 53 00    	call   *0x53b921(%rip)        # ae9fa8 <_DYNAMIC+0x248>
  5ae687:	e9 b4 fa ff ff       	jmp    5ae140 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x40f0>
  5ae68c:	48 8b 47 08          	mov    0x8(%rdi),%rax
  5ae690:	ff 15 72 b9 53 00    	call   *0x53b972(%rip)        # aea008 <_DYNAMIC+0x2a8>
  5ae696:	eb 98                	jmp    5ae630 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x45e0>
  5ae698:	49 29 c7             	sub    %rax,%r15
  5ae69b:	75 35                	jne    5ae6d2 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4682>
  5ae69d:	0f 28 84 24 70 05 00 	movaps 0x570(%rsp),%xmm0
  5ae6a4:	00 
  5ae6a5:	0f 29 44 24 20       	movaps %xmm0,0x20(%rsp)
  5ae6aa:	48 8b 9c 24 b0 04 00 	mov    0x4b0(%rsp),%rbx
  5ae6b1:	00 
  5ae6b2:	48 3b 9c 24 a0 04 00 	cmp    0x4a0(%rsp),%rbx
  5ae6b9:	00 
  5ae6ba:	0f 85 d6 f8 ff ff    	jne    5adf96 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x3f46>
  5ae6c0:	48 8d bc 24 a0 04 00 	lea    0x4a0(%rsp),%rdi
  5ae6c7:	00 
  5ae6c8:	e8 e3 f5 21 00       	call   7cdcb0 <_RNvMs3_NtCscdodAO9FK5_5alloc7raw_vecINtB5_6RawVecNtNtNtCs6gaF1xUz9Bf_4gpui7runtime8metadata3RowE8grow_oneBR_>
  5ae6cd:	e9 c4 f8 ff ff       	jmp    5adf96 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x3f46>
  5ae6d2:	49 8d 1c cc          	lea    (%r12,%rcx,8),%rbx
  5ae6d6:	48 83 c3 20          	add    $0x20,%rbx
  5ae6da:	eb 0d                	jmp    5ae6e9 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4699>
  5ae6dc:	0f 1f 40 00          	nopl   0x0(%rax)
  5ae6e0:	48 83 c3 18          	add    $0x18,%rbx
  5ae6e4:	49 ff cf             	dec    %r15
  5ae6e7:	74 b4                	je     5ae69d <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x464d>
  5ae6e9:	48 8b 73 f8          	mov    -0x8(%rbx),%rsi
  5ae6ed:	48 83 fe ff          	cmp    $0xffffffffffffffff,%rsi
  5ae6f1:	74 ed                	je     5ae6e0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4690>
  5ae6f3:	48 85 f6             	test   %rsi,%rsi
  5ae6f6:	78 e8                	js     5ae6e0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4690>
  5ae6f8:	74 e6                	je     5ae6e0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4690>
  5ae6fa:	48 8b 3b             	mov    (%rbx),%rdi
  5ae6fd:	ba 01 00 00 00       	mov    $0x1,%edx
  5ae702:	ff 15 a0 b8 53 00    	call   *0x53b8a0(%rip)        # ae9fa8 <_DYNAMIC+0x248>
  5ae708:	eb d6                	jmp    5ae6e0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4690>
  5ae70a:	4c 8b 7c 24 08       	mov    0x8(%rsp),%r15
  5ae70f:	48 8b 84 24 88 00 00 	mov    0x88(%rsp),%rax
  5ae716:	00 
  5ae717:	48 c7 00 1f 00 00 00 	movq   $0x1f,(%rax)
  5ae71e:	48 c7 40 08 0c 00 00 	movq   $0xc,0x8(%rax)
  5ae725:	00 
  5ae726:	4c 89 78 10          	mov    %r15,0x10(%rax)
  5ae72a:	48 8b b4 24 b8 02 00 	mov    0x2b8(%rsp),%rsi
  5ae731:	00 
  5ae732:	48 85 f6             	test   %rsi,%rsi
  5ae735:	0f 84 cb 0b 00 00    	je     5af306 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x52b6>
  5ae73b:	48 8b bc 24 c0 02 00 	mov    0x2c0(%rsp),%rdi
  5ae742:	00 
  5ae743:	48 c1 e6 04          	shl    $0x4,%rsi
  5ae747:	ba 08 00 00 00       	mov    $0x8,%edx
  5ae74c:	ff 15 56 b8 53 00    	call   *0x53b856(%rip)        # ae9fa8 <_DYNAMIC+0x248>
  5ae752:	48 8b 8c 24 30 02 00 	mov    0x230(%rsp),%rcx
  5ae759:	00 
  5ae75a:	48 85 c9             	test   %rcx,%rcx
  5ae75d:	0f 85 b4 0b 00 00    	jne    5af317 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x52c7>
  5ae763:	e9 79 c9 ff ff       	jmp    5ab0e1 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1091>
  5ae768:	48 8b 84 24 88 00 00 	mov    0x88(%rsp),%rax
  5ae76f:	00 
  5ae770:	48 c7 00 1f 00 00 00 	movq   $0x1f,(%rax)
  5ae777:	48 c7 40 08 0c 00 00 	movq   $0xc,0x8(%rax)
  5ae77e:	00 
  5ae77f:	4c 89 78 10          	mov    %r15,0x10(%rax)
  5ae783:	48 8b 8c 24 30 02 00 	mov    0x230(%rsp),%rcx
  5ae78a:	00 
  5ae78b:	48 85 c9             	test   %rcx,%rcx
  5ae78e:	0f 85 83 0b 00 00    	jne    5af317 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x52c7>
  5ae794:	e9 48 c9 ff ff       	jmp    5ab0e1 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1091>
  5ae799:	49 83 ff ff          	cmp    $0xffffffffffffffff,%r15
  5ae79d:	74 16                	je     5ae7b5 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4765>
  5ae79f:	4d 85 ff             	test   %r15,%r15
  5ae7a2:	7e 11                	jle    5ae7b5 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4765>
  5ae7a4:	ba 01 00 00 00       	mov    $0x1,%edx
  5ae7a9:	48 89 ef             	mov    %rbp,%rdi
  5ae7ac:	4c 89 fe             	mov    %r15,%rsi
  5ae7af:	ff 15 f3 b7 53 00    	call   *0x53b7f3(%rip)        # ae9fa8 <_DYNAMIC+0x248>
  5ae7b5:	48 83 fb ff          	cmp    $0xffffffffffffffff,%rbx
  5ae7b9:	74 16                	je     5ae7d1 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4781>
  5ae7bb:	48 85 db             	test   %rbx,%rbx
  5ae7be:	7e 11                	jle    5ae7d1 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4781>
  5ae7c0:	ba 01 00 00 00       	mov    $0x1,%edx
  5ae7c5:	4c 89 f7             	mov    %r14,%rdi
  5ae7c8:	48 89 de             	mov    %rbx,%rsi
  5ae7cb:	ff 15 d7 b7 53 00    	call   *0x53b7d7(%rip)        # ae9fa8 <_DYNAMIC+0x248>
  5ae7d1:	48 8b 74 24 60       	mov    0x60(%rsp),%rsi
  5ae7d6:	48 89 f0             	mov    %rsi,%rax
  5ae7d9:	4c 29 e0             	sub    %r12,%rax
  5ae7dc:	48 c1 e8 03          	shr    $0x3,%rax
  5ae7e0:	48 b9 93 24 49 92 24 	movabs $0x2492492492492493,%rcx
  5ae7e7:	49 92 24 
  5ae7ea:	48 f7 e1             	mul    %rcx
  5ae7ed:	4c 39 e6             	cmp    %r12,%rsi
  5ae7f0:	74 66                	je     5ae858 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4808>
  5ae7f2:	48 89 d3             	mov    %rdx,%rbx
  5ae7f5:	49 83 c4 20          	add    $0x20,%r12
  5ae7f9:	4c 8b 35 a8 b7 53 00 	mov    0x53b7a8(%rip),%r14        # ae9fa8 <_DYNAMIC+0x248>
  5ae800:	eb 17                	jmp    5ae819 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x47c9>
  5ae802:	66 66 66 66 66 2e 0f 	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  5ae809:	1f 84 00 00 00 00 00 
  5ae810:	49 83 c4 38          	add    $0x38,%r12
  5ae814:	48 ff cb             	dec    %rbx
  5ae817:	74 3f                	je     5ae858 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4808>
  5ae819:	49 8b 74 24 e0       	mov    -0x20(%r12),%rsi
  5ae81e:	48 83 fe ff          	cmp    $0xffffffffffffffff,%rsi
  5ae822:	74 14                	je     5ae838 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x47e8>
  5ae824:	48 85 f6             	test   %rsi,%rsi
  5ae827:	78 0f                	js     5ae838 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x47e8>
  5ae829:	74 0d                	je     5ae838 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x47e8>
  5ae82b:	49 8b 7c 24 e8       	mov    -0x18(%r12),%rdi
  5ae830:	ba 01 00 00 00       	mov    $0x1,%edx
  5ae835:	41 ff d6             	call   *%r14
  5ae838:	49 8b 74 24 f8       	mov    -0x8(%r12),%rsi
  5ae83d:	48 83 fe ff          	cmp    $0xffffffffffffffff,%rsi
  5ae841:	74 cd                	je     5ae810 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x47c0>
  5ae843:	48 85 f6             	test   %rsi,%rsi
  5ae846:	78 c8                	js     5ae810 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x47c0>
  5ae848:	74 c6                	je     5ae810 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x47c0>
  5ae84a:	49 8b 3c 24          	mov    (%r12),%rdi
  5ae84e:	ba 01 00 00 00       	mov    $0x1,%edx
  5ae853:	41 ff d6             	call   *%r14
  5ae856:	eb b8                	jmp    5ae810 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x47c0>
  5ae858:	48 8b 44 24 58       	mov    0x58(%rsp),%rax
  5ae85d:	48 85 c0             	test   %rax,%rax
  5ae860:	74 14                	je     5ae876 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4826>
  5ae862:	48 6b f0 38          	imul   $0x38,%rax,%rsi
  5ae866:	ba 08 00 00 00       	mov    $0x8,%edx
  5ae86b:	48 8b 7c 24 38       	mov    0x38(%rsp),%rdi
  5ae870:	ff 15 32 b7 53 00    	call   *0x53b732(%rip)        # ae9fa8 <_DYNAMIC+0x248>
  5ae876:	48 8b 74 24 30       	mov    0x30(%rsp),%rsi
  5ae87b:	48 85 f6             	test   %rsi,%rsi
  5ae87e:	48 8b 5c 24 10       	mov    0x10(%rsp),%rbx
  5ae883:	74 14                	je     5ae899 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4849>
  5ae885:	48 c1 e6 04          	shl    $0x4,%rsi
  5ae889:	ba 08 00 00 00       	mov    $0x8,%edx
  5ae88e:	48 8b 7c 24 50       	mov    0x50(%rsp),%rdi
  5ae893:	ff 15 0f b7 53 00    	call   *0x53b70f(%rip)        # ae9fa8 <_DYNAMIC+0x248>
  5ae899:	48 8b bc 24 a8 04 00 	mov    0x4a8(%rsp),%rdi
  5ae8a0:	00 
  5ae8a1:	48 8b b4 24 b0 04 00 	mov    0x4b0(%rsp),%rsi
  5ae8a8:	00 
  5ae8a9:	48 8d 44 24 6f       	lea    0x6f(%rsp),%rax
  5ae8ae:	48 89 84 24 a0 00 00 	mov    %rax,0xa0(%rsp)
  5ae8b5:	00 
  5ae8b6:	48 83 fe 02          	cmp    $0x2,%rsi
  5ae8ba:	0f 83 3b 10 00 00    	jae    5af8fb <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x58ab>
  5ae8c0:	48 8b 84 24 b0 04 00 	mov    0x4b0(%rsp),%rax
  5ae8c7:	00 
  5ae8c8:	48 89 84 24 b0 00 00 	mov    %rax,0xb0(%rsp)
  5ae8cf:	00 
  5ae8d0:	0f 10 84 24 a0 04 00 	movups 0x4a0(%rsp),%xmm0
  5ae8d7:	00 
  5ae8d8:	0f 29 84 24 a0 00 00 	movaps %xmm0,0xa0(%rsp)
  5ae8df:	00 
  5ae8e0:	48 8b bb 10 08 00 00 	mov    0x810(%rbx),%rdi
  5ae8e7:	e8 84 7c f8 ff       	call   536570 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtCscdodAO9FK5_5alloc3vec3VecNtNtNtCs6gaF1xUz9Bf_4gpui7runtime8metadata8DeclaredEEB1d_>
  5ae8ec:	48 8b 83 10 08 00 00 	mov    0x810(%rbx),%rax
  5ae8f3:	48 8b 8c 24 b0 00 00 	mov    0xb0(%rsp),%rcx
  5ae8fa:	00 
  5ae8fb:	48 89 48 10          	mov    %rcx,0x10(%rax)
  5ae8ff:	0f 28 84 24 a0 00 00 	movaps 0xa0(%rsp),%xmm0
  5ae906:	00 
  5ae907:	0f 11 00             	movups %xmm0,(%rax)
  5ae90a:	31 d2                	xor    %edx,%edx
  5ae90c:	89 54 24 20          	mov    %edx,0x20(%rsp)
  5ae910:	48 8b 84 24 00 06 00 	mov    0x600(%rsp),%rax
  5ae917:	00 
  5ae918:	48 89 84 24 b0 00 00 	mov    %rax,0xb0(%rsp)
  5ae91f:	00 
  5ae920:	0f 10 84 24 f0 05 00 	movups 0x5f0(%rsp),%xmm0
  5ae927:	00 
  5ae928:	0f 29 84 24 a0 00 00 	movaps %xmm0,0xa0(%rsp)
  5ae92f:	00 
  5ae930:	48 8b 9c 24 a0 05 00 	mov    0x5a0(%rsp),%rbx
  5ae937:	00 
  5ae938:	48 89 df             	mov    %rbx,%rdi
  5ae93b:	e8 80 fd 17 00       	call   72e6c0 <_RNvXNtNtNtCscdodAO9FK5_5alloc11collections5btree3mapINtB2_8BTreeMapNtNtCs6gaF1xUz9Bf_4gpui4list6ListIdNtNtNtB17_7runtime4list9ListStateENtNtNtCs4NRVxsYgnAr_4core3ops4drop4Drop4dropB17_>
  5ae940:	48 8b 84 24 b0 00 00 	mov    0xb0(%rsp),%rax
  5ae947:	00 
  5ae948:	48 89 43 10          	mov    %rax,0x10(%rbx)
  5ae94c:	0f 28 84 24 a0 00 00 	movaps 0xa0(%rsp),%xmm0
  5ae953:	00 
  5ae954:	0f 11 03             	movups %xmm0,(%rbx)
  5ae957:	48 8b 84 24 18 06 00 	mov    0x618(%rsp),%rax
  5ae95e:	00 
  5ae95f:	48 89 84 24 b0 00 00 	mov    %rax,0xb0(%rsp)
  5ae966:	00 
  5ae967:	0f 10 84 24 08 06 00 	movups 0x608(%rsp),%xmm0
  5ae96e:	00 
  5ae96f:	0f 29 84 24 a0 00 00 	movaps %xmm0,0xa0(%rsp)
  5ae976:	00 
  5ae977:	48 8b 5c 24 10       	mov    0x10(%rsp),%rbx
  5ae97c:	4c 8d b3 30 08 00 00 	lea    0x830(%rbx),%r14
  5ae983:	4c 89 f7             	mov    %r14,%rdi
  5ae986:	e8 25 09 18 00       	call   72f2b0 <_RNvXNtNtNtCscdodAO9FK5_5alloc11collections5btree3mapINtB2_8BTreeMapTINtNtCs4NRVxsYgnAr_4core6option6OptionyENtNtCs6gaF1xUz9Bf_4gpui4list6ListIdNtNtB1M_7element8NodeKindEjENtNtNtB19_3ops4drop4Drop4dropB1M_>
  5ae98b:	48 81 c3 b8 02 00 00 	add    $0x2b8,%rbx
  5ae992:	48 8b 84 24 b0 00 00 	mov    0xb0(%rsp),%rax
  5ae999:	00 
  5ae99a:	49 89 46 10          	mov    %rax,0x10(%r14)
  5ae99e:	0f 28 84 24 a0 00 00 	movaps 0xa0(%rsp),%xmm0
  5ae9a5:	00 
  5ae9a6:	41 0f 11 06          	movups %xmm0,(%r14)
  5ae9aa:	48 8b 84 24 28 02 00 	mov    0x228(%rsp),%rax
  5ae9b1:	00 
  5ae9b2:	48 89 84 24 b0 00 00 	mov    %rax,0xb0(%rsp)
  5ae9b9:	00 
  5ae9ba:	0f 10 84 24 18 02 00 	movups 0x218(%rsp),%xmm0
  5ae9c1:	00 
  5ae9c2:	0f 29 84 24 a0 00 00 	movaps %xmm0,0xa0(%rsp)
  5ae9c9:	00 
  5ae9ca:	48 89 df             	mov    %rbx,%rdi
  5ae9cd:	e8 2e dd 12 00       	call   6dc700 <_RNvXso_NtCscdodAO9FK5_5alloc3vecINtB5_3VecNtNtCs6gaF1xUz9Bf_4gpui7runtime4NodeENtNtNtCs4NRVxsYgnAr_4core3ops4drop4Drop4dropBI_>
  5ae9d2:	48 8b 03             	mov    (%rbx),%rax
  5ae9d5:	48 85 c0             	test   %rax,%rax
  5ae9d8:	4c 8b 74 24 10       	mov    0x10(%rsp),%r14
  5ae9dd:	74 1a                	je     5ae9f9 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x49a9>
  5ae9df:	49 8b be c0 02 00 00 	mov    0x2c0(%r14),%rdi
  5ae9e6:	48 c1 e0 03          	shl    $0x3,%rax
  5ae9ea:	48 8d 34 80          	lea    (%rax,%rax,4),%rsi
  5ae9ee:	ba 08 00 00 00       	mov    $0x8,%edx
  5ae9f3:	ff 15 af b5 53 00    	call   *0x53b5af(%rip)        # ae9fa8 <_DYNAMIC+0x248>
  5ae9f9:	48 8b 84 24 b0 00 00 	mov    0xb0(%rsp),%rax
  5aea00:	00 
  5aea01:	48 89 43 10          	mov    %rax,0x10(%rbx)
  5aea05:	0f 28 84 24 a0 00 00 	movaps 0xa0(%rsp),%xmm0
  5aea0c:	00 
  5aea0d:	0f 11 03             	movups %xmm0,(%rbx)
  5aea10:	0f 10 84 24 08 07 00 	movups 0x708(%rsp),%xmm0
  5aea17:	00 
  5aea18:	0f 10 8c 24 18 07 00 	movups 0x718(%rsp),%xmm1
  5aea1f:	00 
  5aea20:	f3 0f 6f 94 24 28 07 	movdqu 0x728(%rsp),%xmm2
  5aea27:	00 00 
  5aea29:	0f 10 9c 24 38 07 00 	movups 0x738(%rsp),%xmm3
  5aea30:	00 
  5aea31:	0f 29 9c 24 d0 00 00 	movaps %xmm3,0xd0(%rsp)
  5aea38:	00 
  5aea39:	66 0f 7f 94 24 c0 00 	movdqa %xmm2,0xc0(%rsp)
  5aea40:	00 00 
  5aea42:	0f 29 8c 24 b0 00 00 	movaps %xmm1,0xb0(%rsp)
  5aea49:	00 
  5aea4a:	0f 29 84 24 a0 00 00 	movaps %xmm0,0xa0(%rsp)
  5aea51:	00 
  5aea52:	48 8d bc 24 00 03 00 	lea    0x300(%rsp),%rdi
  5aea59:	00 
  5aea5a:	48 8d b4 24 a0 00 00 	lea    0xa0(%rsp),%rsi
  5aea61:	00 
  5aea62:	e8 59 b4 1c 00       	call   779ec0 <_RNvMs_NtNtCs6gaF1xUz9Bf_4gpui7runtime6stylesNtB4_7Builder6finish>
  5aea67:	49 8d 9e 28 02 00 00 	lea    0x228(%r14),%rbx
  5aea6e:	48 8b 03             	mov    (%rbx),%rax
  5aea71:	48 85 c0             	test   %rax,%rax
  5aea74:	74 63                	je     5aead9 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4a89>
  5aea76:	83 f8 01             	cmp    $0x1,%eax
  5aea79:	75 1e                	jne    5aea99 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4a49>
  5aea7b:	49 8b 86 30 02 00 00 	mov    0x230(%r14),%rax
  5aea82:	48 85 c0             	test   %rax,%rax
  5aea85:	74 52                	je     5aead9 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4a89>
  5aea87:	49 8b be 38 02 00 00 	mov    0x238(%r14),%rdi
  5aea8e:	48 6b f0 58          	imul   $0x58,%rax,%rsi
  5aea92:	ba 04 00 00 00       	mov    $0x4,%edx
  5aea97:	eb 3a                	jmp    5aead3 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4a83>
  5aea99:	49 8b 86 38 02 00 00 	mov    0x238(%r14),%rax
  5aeaa0:	48 85 c0             	test   %rax,%rax
  5aeaa3:	74 16                	je     5aeabb <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4a6b>
  5aeaa5:	49 8b be 30 02 00 00 	mov    0x230(%r14),%rdi
  5aeaac:	48 6b f0 58          	imul   $0x58,%rax,%rsi
  5aeab0:	ba 04 00 00 00       	mov    $0x4,%edx
  5aeab5:	ff 15 ed b4 53 00    	call   *0x53b4ed(%rip)        # ae9fa8 <_DYNAMIC+0x248>
  5aeabb:	49 8b b6 48 02 00 00 	mov    0x248(%r14),%rsi
  5aeac2:	48 85 f6             	test   %rsi,%rsi
  5aeac5:	74 12                	je     5aead9 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4a89>
  5aeac7:	49 8b be 40 02 00 00 	mov    0x240(%r14),%rdi
  5aeace:	ba 01 00 00 00       	mov    $0x1,%edx
  5aead3:	ff 15 cf b4 53 00    	call   *0x53b4cf(%rip)        # ae9fa8 <_DYNAMIC+0x248>
  5aead9:	48 8b 84 24 20 03 00 	mov    0x320(%rsp),%rax
  5aeae0:	00 
  5aeae1:	48 89 43 20          	mov    %rax,0x20(%rbx)
  5aeae5:	0f 10 84 24 00 03 00 	movups 0x300(%rsp),%xmm0
  5aeaec:	00 
  5aeaed:	0f 10 8c 24 10 03 00 	movups 0x310(%rsp),%xmm1
  5aeaf4:	00 
  5aeaf5:	0f 11 4b 10          	movups %xmm1,0x10(%rbx)
  5aeaf9:	0f 11 03             	movups %xmm0,(%rbx)
  5aeafc:	48 8b 84 24 38 05 00 	mov    0x538(%rsp),%rax
  5aeb03:	00 
  5aeb04:	48 89 84 24 b0 00 00 	mov    %rax,0xb0(%rsp)
  5aeb0b:	00 
  5aeb0c:	0f 10 84 24 28 05 00 	movups 0x528(%rsp),%xmm0
  5aeb13:	00 
  5aeb14:	0f 29 84 24 a0 00 00 	movaps %xmm0,0xa0(%rsp)
  5aeb1b:	00 
  5aeb1c:	49 8d 9e d0 02 00 00 	lea    0x2d0(%r14),%rbx
  5aeb23:	48 89 df             	mov    %rbx,%rdi
  5aeb26:	e8 a5 d9 12 00       	call   6dc4d0 <_RNvXso_NtCscdodAO9FK5_5alloc3vecINtB5_3VecINtNtCs4NRVxsYgnAr_4core6option6OptionNtNtCs6gaF1xUz9Bf_4gpui7runtime8TextSiteEENtNtNtBJ_3ops4drop4Drop4dropB1k_>
  5aeb2b:	48 8b 03             	mov    (%rbx),%rax
  5aeb2e:	48 85 c0             	test   %rax,%rax
  5aeb31:	74 1a                	je     5aeb4d <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4afd>
  5aeb33:	49 8b be d8 02 00 00 	mov    0x2d8(%r14),%rdi
  5aeb3a:	48 c1 e0 04          	shl    $0x4,%rax
  5aeb3e:	48 8d 34 80          	lea    (%rax,%rax,4),%rsi
  5aeb42:	ba 08 00 00 00       	mov    $0x8,%edx
  5aeb47:	ff 15 5b b4 53 00    	call   *0x53b45b(%rip)        # ae9fa8 <_DYNAMIC+0x248>
  5aeb4d:	48 8b 84 24 b0 00 00 	mov    0xb0(%rsp),%rax
  5aeb54:	00 
  5aeb55:	48 89 43 10          	mov    %rax,0x10(%rbx)
  5aeb59:	0f 28 84 24 a0 00 00 	movaps 0xa0(%rsp),%xmm0
  5aeb60:	00 
  5aeb61:	0f 11 03             	movups %xmm0,(%rbx)
  5aeb64:	48 8b 84 24 40 02 00 	mov    0x240(%rsp),%rax
  5aeb6b:	00 
  5aeb6c:	48 89 84 24 a0 01 00 	mov    %rax,0x1a0(%rsp)
  5aeb73:	00 
  5aeb74:	0f 10 84 24 30 02 00 	movups 0x230(%rsp),%xmm0
  5aeb7b:	00 
  5aeb7c:	0f 29 84 24 90 01 00 	movaps %xmm0,0x190(%rsp)
  5aeb83:	00 
  5aeb84:	49 8b 8e c8 07 00 00 	mov    0x7c8(%r14),%rcx
  5aeb8b:	48 85 c9             	test   %rcx,%rcx
  5aeb8e:	74 4d                	je     5aebdd <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4b8d>
  5aeb90:	49 8b 96 d0 07 00 00 	mov    0x7d0(%r14),%rdx
  5aeb97:	49 8b 86 d8 07 00 00 	mov    0x7d8(%r14),%rax
  5aeb9e:	48 c7 84 24 a8 00 00 	movq   $0x0,0xa8(%rsp)
  5aeba5:	00 00 00 00 00 
  5aebaa:	48 89 8c 24 b0 00 00 	mov    %rcx,0xb0(%rsp)
  5aebb1:	00 
  5aebb2:	48 89 94 24 b8 00 00 	mov    %rdx,0xb8(%rsp)
  5aebb9:	00 
  5aebba:	48 c7 84 24 c8 00 00 	movq   $0x0,0xc8(%rsp)
  5aebc1:	00 00 00 00 00 
  5aebc6:	48 89 8c 24 d0 00 00 	mov    %rcx,0xd0(%rsp)
  5aebcd:	00 
  5aebce:	48 89 94 24 d8 00 00 	mov    %rdx,0xd8(%rsp)
  5aebd5:	00 
  5aebd6:	b9 01 00 00 00       	mov    $0x1,%ecx
  5aebdb:	eb 04                	jmp    5aebe1 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4b91>
  5aebdd:	31 c9                	xor    %ecx,%ecx
  5aebdf:	31 c0                	xor    %eax,%eax
  5aebe1:	4d 8d be c8 07 00 00 	lea    0x7c8(%r14),%r15
  5aebe8:	48 89 8c 24 a0 00 00 	mov    %rcx,0xa0(%rsp)
  5aebef:	00 
  5aebf0:	48 89 8c 24 c0 00 00 	mov    %rcx,0xc0(%rsp)
  5aebf7:	00 
  5aebf8:	48 89 84 24 e0 00 00 	mov    %rax,0xe0(%rsp)
  5aebff:	00 
  5aec00:	48 8d bc 24 00 03 00 	lea    0x300(%rsp),%rdi
  5aec07:	00 
  5aec08:	48 8d b4 24 a0 00 00 	lea    0xa0(%rsp),%rsi
  5aec0f:	00 
  5aec10:	e8 ab a9 17 00       	call   7295c0 <_RNvMsz_NtNtNtCscdodAO9FK5_5alloc11collections5btree3mapINtB5_8IntoIterNtNtCs6gaF1xUz9Bf_4gpui6source7FieldIdNtNtB1a_7runtime6FanoutE10dying_nextB1a_.llvm.555413502705965614>
  5aec15:	48 8b 84 24 00 03 00 	mov    0x300(%rsp),%rax
  5aec1c:	00 
  5aec1d:	48 85 c0             	test   %rax,%rax
  5aec20:	74 64                	je     5aec86 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4c36>
  5aec22:	48 8d 9c 24 00 03 00 	lea    0x300(%rsp),%rbx
  5aec29:	00 
  5aec2a:	4c 8d b4 24 a0 00 00 	lea    0xa0(%rsp),%r14
  5aec31:	00 
  5aec32:	4c 8b 25 6f b3 53 00 	mov    0x53b36f(%rip),%r12        # ae9fa8 <_DYNAMIC+0x248>
  5aec39:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  5aec40:	48 8b 8c 24 10 03 00 	mov    0x310(%rsp),%rcx
  5aec47:	00 
  5aec48:	48 8d 0c 89          	lea    (%rcx,%rcx,4),%rcx
  5aec4c:	48 8b 74 c8 60       	mov    0x60(%rax,%rcx,8),%rsi
  5aec51:	48 85 f6             	test   %rsi,%rsi
  5aec54:	74 18                	je     5aec6e <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4c1e>
  5aec56:	48 8d 04 c8          	lea    (%rax,%rcx,8),%rax
  5aec5a:	48 83 c0 60          	add    $0x60,%rax
  5aec5e:	48 8b 78 08          	mov    0x8(%rax),%rdi
  5aec62:	48 c1 e6 02          	shl    $0x2,%rsi
  5aec66:	ba 04 00 00 00       	mov    $0x4,%edx
  5aec6b:	41 ff d4             	call   *%r12
  5aec6e:	48 89 df             	mov    %rbx,%rdi
  5aec71:	4c 89 f6             	mov    %r14,%rsi
  5aec74:	e8 47 a9 17 00       	call   7295c0 <_RNvMsz_NtNtNtCscdodAO9FK5_5alloc11collections5btree3mapINtB5_8IntoIterNtNtCs6gaF1xUz9Bf_4gpui6source7FieldIdNtNtB1a_7runtime6FanoutE10dying_nextB1a_.llvm.555413502705965614>
  5aec79:	48 8b 84 24 00 03 00 	mov    0x300(%rsp),%rax
  5aec80:	00 
  5aec81:	48 85 c0             	test   %rax,%rax
  5aec84:	75 ba                	jne    5aec40 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4bf0>
  5aec86:	48 8b 84 24 a0 01 00 	mov    0x1a0(%rsp),%rax
  5aec8d:	00 
  5aec8e:	49 89 47 10          	mov    %rax,0x10(%r15)
  5aec92:	0f 28 84 24 90 01 00 	movaps 0x190(%rsp),%xmm0
  5aec99:	00 
  5aec9a:	41 0f 11 07          	movups %xmm0,(%r15)
  5aec9e:	4c 8b 74 24 10       	mov    0x10(%rsp),%r14
  5aeca3:	49 8b 86 c0 02 00 00 	mov    0x2c0(%r14),%rax
  5aecaa:	49 8b 8e c8 02 00 00 	mov    0x2c8(%r14),%rcx
  5aecb1:	48 8d 0c 89          	lea    (%rcx,%rcx,4),%rcx
  5aecb5:	48 8d 0c c8          	lea    (%rax,%rcx,8),%rcx
  5aecb9:	48 89 84 24 a0 00 00 	mov    %rax,0xa0(%rsp)
  5aecc0:	00 
  5aecc1:	48 89 8c 24 a8 00 00 	mov    %rcx,0xa8(%rsp)
  5aecc8:	00 
  5aecc9:	48 c7 84 24 b0 00 00 	movq   $0x0,0xb0(%rsp)
  5aecd0:	00 00 00 00 00 
  5aecd5:	48 8d bc 24 00 03 00 	lea    0x300(%rsp),%rdi
  5aecdc:	00 
  5aecdd:	48 8d b4 24 a0 00 00 	lea    0xa0(%rsp),%rsi
  5aece4:	00 
  5aece5:	8b 6c 24 20          	mov    0x20(%rsp),%ebp
  5aece9:	e8 02 6d 17 00       	call   7259f0 <_RINvXs1o_NtNtNtCscdodAO9FK5_5alloc11collections5btree3mapINtB7_8BTreeMapyjEINtNtNtNtCs4NRVxsYgnAr_4core4iter6traits7collect12FromIteratorTyjEE9from_iterINtNtNtB1i_8adapters3map3MapINtNtB2v_9enumerate9EnumerateINtNtNtB1k_5slice4iter4IterNtNtCs6gaF1xUz9Bf_4gpui7runtime4NodeEENCNvMsq_B3O_INtB3O_7RuntimeNtNtB3O_12style_ledger9AdversaryE14describe_innersz_0EEB3Q_>
  5aecee:	49 8d 9e b0 07 00 00 	lea    0x7b0(%r14),%rbx
  5aecf5:	48 89 df             	mov    %rbx,%rdi
  5aecf8:	e8 83 0c 18 00       	call   72f980 <_RNvXNtNtNtCscdodAO9FK5_5alloc11collections5btree3mapINtB2_8BTreeMapjNtNtCs6gaF1xUz9Bf_4gpui4list6ListIdENtNtNtCs4NRVxsYgnAr_4core3ops4drop4Drop4dropB18_>
  5aecfd:	48 8b 84 24 10 03 00 	mov    0x310(%rsp),%rax
  5aed04:	00 
  5aed05:	48 89 43 10          	mov    %rax,0x10(%rbx)
  5aed09:	0f 10 84 24 00 03 00 	movups 0x300(%rsp),%xmm0
  5aed10:	00 
  5aed11:	0f 11 03             	movups %xmm0,(%rbx)
  5aed14:	48 8b bc 24 98 05 00 	mov    0x598(%rsp),%rdi
  5aed1b:	00 
  5aed1c:	48 89 de             	mov    %rbx,%rsi
  5aed1f:	e8 5c 63 16 00       	call   715080 <_RINvMs5_NtCs6gaF1xUz9Bf_4gpui8propertyNtB6_9Overrides6retainNCNvMsq_NtB8_7runtimeINtB14_7RuntimeNtNtB14_12style_ledger9AdversaryE14describe_innersA_0EB8_>
  5aed24:	49 8b 86 10 08 00 00 	mov    0x810(%r14),%rax
  5aed2b:	48 85 c0             	test   %rax,%rax
  5aed2e:	0f 84 08 01 00 00    	je     5aee3c <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4dec>
  5aed34:	48 89 9c 24 90 01 00 	mov    %rbx,0x190(%rsp)
  5aed3b:	00 
  5aed3c:	48 8b 88 d8 00 00 00 	mov    0xd8(%rax),%rcx
  5aed43:	48 85 c9             	test   %rcx,%rcx
  5aed46:	74 3e                	je     5aed86 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4d36>
  5aed48:	48 8d 90 d8 00 00 00 	lea    0xd8(%rax),%rdx
  5aed4f:	48 8b b0 e0 00 00 00 	mov    0xe0(%rax),%rsi
  5aed56:	48 85 f6             	test   %rsi,%rsi
  5aed59:	4c 8d 8c 24 90 01 00 	lea    0x190(%rsp),%r9
  5aed60:	00 
  5aed61:	74 78                	je     5aeddb <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4d8b>
  5aed63:	48 89 f7             	mov    %rsi,%rdi
  5aed66:	48 83 e7 07          	and    $0x7,%rdi
  5aed6a:	74 28                	je     5aed94 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4d44>
  5aed6c:	45 31 c0             	xor    %r8d,%r8d
  5aed6f:	48 8b 89 c8 01 00 00 	mov    0x1c8(%rcx),%rcx
  5aed76:	49 ff c0             	inc    %r8
  5aed79:	4c 39 c7             	cmp    %r8,%rdi
  5aed7c:	75 f1                	jne    5aed6f <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4d1f>
  5aed7e:	48 89 f7             	mov    %rsi,%rdi
  5aed81:	4c 29 c7             	sub    %r8,%rdi
  5aed84:	eb 11                	jmp    5aed97 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4d47>
  5aed86:	31 c9                	xor    %ecx,%ecx
  5aed88:	31 d2                	xor    %edx,%edx
  5aed8a:	4c 8d 8c 24 90 01 00 	lea    0x190(%rsp),%r9
  5aed91:	00 
  5aed92:	eb 47                	jmp    5aeddb <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4d8b>
  5aed94:	48 89 f7             	mov    %rsi,%rdi
  5aed97:	48 83 fe 08          	cmp    $0x8,%rsi
  5aed9b:	72 3e                	jb     5aeddb <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4d8b>
  5aed9d:	48 8b 89 c8 01 00 00 	mov    0x1c8(%rcx),%rcx
  5aeda4:	48 8b 89 c8 01 00 00 	mov    0x1c8(%rcx),%rcx
  5aedab:	48 8b 89 c8 01 00 00 	mov    0x1c8(%rcx),%rcx
  5aedb2:	48 8b 89 c8 01 00 00 	mov    0x1c8(%rcx),%rcx
  5aedb9:	48 8b 89 c8 01 00 00 	mov    0x1c8(%rcx),%rcx
  5aedc0:	48 8b 89 c8 01 00 00 	mov    0x1c8(%rcx),%rcx
  5aedc7:	48 8b 89 c8 01 00 00 	mov    0x1c8(%rcx),%rcx
  5aedce:	48 8b 89 c8 01 00 00 	mov    0x1c8(%rcx),%rcx
  5aedd5:	48 83 c7 f8          	add    $0xfffffffffffffff8,%rdi
  5aedd9:	75 c2                	jne    5aed9d <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4d4d>
  5aeddb:	48 05 e8 00 00 00    	add    $0xe8,%rax
  5aede1:	4c 89 8c 24 a0 00 00 	mov    %r9,0xa0(%rsp)
  5aede8:	00 
  5aede9:	48 89 84 24 a8 00 00 	mov    %rax,0xa8(%rsp)
  5aedf0:	00 
  5aedf1:	48 89 94 24 b0 00 00 	mov    %rdx,0xb0(%rsp)
  5aedf8:	00 
  5aedf9:	48 89 8c 24 b8 00 00 	mov    %rcx,0xb8(%rsp)
  5aee00:	00 
  5aee01:	0f 57 c0             	xorps  %xmm0,%xmm0
  5aee04:	0f 11 84 24 c0 00 00 	movups %xmm0,0xc0(%rsp)
  5aee0b:	00 
  5aee0c:	48 8d bc 24 00 03 00 	lea    0x300(%rsp),%rdi
  5aee13:	00 
  5aee14:	48 8d b4 24 a0 00 00 	lea    0xa0(%rsp),%rsi
  5aee1b:	00 
  5aee1c:	e8 ef 26 18 00       	call   731510 <_RNvXsU_NtNtNtCscdodAO9FK5_5alloc11collections5btree3mapINtB5_9ExtractIfyAINtNtCs6gaF1xUz9Bf_4gpui8property12ContributionINtNtCs4NRVxsYgnAr_4core6option6OptionNtNtB1e_11shared_text10SharedTextEEj2_NtNtNtB1Z_3ops5range9RangeFullNCINvMsi_B5_INtB5_8BTreeMapyB18_E6retainNCNvMsq_NtB1e_7runtimeINtB4o_7RuntimeNtNtB4o_12style_ledger9AdversaryE14describe_innersB_0E0ENtNtNtNtB1Z_4iter6traits8iterator8Iterator4nextB1e_>
  5aee21:	48 8b 84 24 08 03 00 	mov    0x308(%rsp),%rax
  5aee28:	00 
  5aee29:	48 83 f8 02          	cmp    $0x2,%rax
  5aee2d:	0f 85 96 00 00 00    	jne    5aeec9 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4e79>
  5aee33:	4c 8b 74 24 10       	mov    0x10(%rsp),%r14
  5aee38:	8b 6c 24 20          	mov    0x20(%rsp),%ebp
  5aee3c:	41 c6 86 5a 09 00 00 	movb   $0x1,0x95a(%r14)
  5aee43:	01 
  5aee44:	49 8b 96 e8 07 00 00 	mov    0x7e8(%r14),%rdx
  5aee4b:	48 85 d2             	test   %rdx,%rdx
  5aee4e:	0f 84 80 01 00 00    	je     5aefd4 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4f84>
  5aee54:	49 8b 8e f0 07 00 00 	mov    0x7f0(%r14),%rcx
  5aee5b:	48 8d bc 24 a0 00 00 	lea    0xa0(%rsp),%rdi
  5aee62:	00 
  5aee63:	4c 89 f6             	mov    %r14,%rsi
  5aee66:	e8 25 1c 00 00       	call   5b0a90 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE6locateB7_>
  5aee6b:	48 8b 84 24 a0 00 00 	mov    0xa0(%rsp),%rax
  5aee72:	00 
  5aee73:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  5aee77:	0f 85 0a 01 00 00    	jne    5aef87 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4f37>
  5aee7d:	48 8b bc 24 b0 00 00 	mov    0xb0(%rsp),%rdi
  5aee84:	00 
  5aee85:	49 8b b6 c8 02 00 00 	mov    0x2c8(%r14),%rsi
  5aee8c:	48 39 f7             	cmp    %rsi,%rdi
  5aee8f:	0f 83 a4 0d 00 00    	jae    5afc39 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5be9>
  5aee95:	49 8b 8e c0 02 00 00 	mov    0x2c0(%r14),%rcx
  5aee9c:	48 8d 14 bf          	lea    (%rdi,%rdi,4),%rdx
  5aeea0:	48 8d 04 d1          	lea    (%rcx,%rdx,8),%rax
  5aeea4:	8b 4c d1 20          	mov    0x20(%rcx,%rdx,8),%ecx
  5aeea8:	83 e1 07             	and    $0x7,%ecx
  5aeeab:	ba 73 00 00 00       	mov    $0x73,%edx
  5aeeb0:	0f a3 ca             	bt     %ecx,%edx
  5aeeb3:	0f 83 f5 03 00 00    	jae    5af2ae <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x525e>
  5aeeb9:	48 83 78 08 00       	cmpq   $0x0,0x8(%rax)
  5aeebe:	0f 85 10 01 00 00    	jne    5aefd4 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4f84>
  5aeec4:	e9 00 01 00 00       	jmp    5aefc9 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4f79>
  5aeec9:	48 8d 9c 24 00 03 00 	lea    0x300(%rsp),%rbx
  5aeed0:	00 
  5aeed1:	4c 8d b4 24 a0 00 00 	lea    0xa0(%rsp),%r14
  5aeed8:	00 
  5aeed9:	4c 8b 2d 28 b1 53 00 	mov    0x53b128(%rip),%r13        # aea008 <_DYNAMIC+0x2a8>
  5aeee0:	4c 8b a4 24 18 03 00 	mov    0x318(%rsp),%r12
  5aeee7:	00 
  5aeee8:	4c 8b bc 24 20 03 00 	mov    0x320(%rsp),%r15
  5aeeef:	00 
  5aeef0:	48 85 c0             	test   %rax,%rax
  5aeef3:	74 2b                	je     5aef20 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4ed0>
  5aeef5:	48 8b bc 24 10 03 00 	mov    0x310(%rsp),%rdi
  5aeefc:	00 
  5aeefd:	48 85 ff             	test   %rdi,%rdi
  5aef00:	74 1e                	je     5aef20 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4ed0>
  5aef02:	f6 07 01             	testb  $0x1,(%rdi)
  5aef05:	75 19                	jne    5aef20 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4ed0>
  5aef07:	48 8b 47 08          	mov    0x8(%rdi),%rax
  5aef0b:	a8 01                	test   $0x1,%al
  5aef0d:	75 11                	jne    5aef20 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4ed0>
  5aef0f:	48 8d 47 08          	lea    0x8(%rdi),%rax
  5aef13:	f0 48 83 28 02       	lock subq $0x2,(%rax)
  5aef18:	74 58                	je     5aef72 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4f22>
  5aef1a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
  5aef20:	4d 85 e4             	test   %r12,%r12
  5aef23:	74 2b                	je     5aef50 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4f00>
  5aef25:	4d 85 ff             	test   %r15,%r15
  5aef28:	74 26                	je     5aef50 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4f00>
  5aef2a:	41 f6 07 01          	testb  $0x1,(%r15)
  5aef2e:	75 20                	jne    5aef50 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4f00>
  5aef30:	49 8b 47 08          	mov    0x8(%r15),%rax
  5aef34:	a8 01                	test   $0x1,%al
  5aef36:	75 18                	jne    5aef50 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4f00>
  5aef38:	49 8d 47 08          	lea    0x8(%r15),%rax
  5aef3c:	f0 48 83 28 02       	lock subq $0x2,(%rax)
  5aef41:	74 38                	je     5aef7b <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4f2b>
  5aef43:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  5aef4a:	84 00 00 00 00 00 
  5aef50:	48 89 df             	mov    %rbx,%rdi
  5aef53:	4c 89 f6             	mov    %r14,%rsi
  5aef56:	e8 b5 25 18 00       	call   731510 <_RNvXsU_NtNtNtCscdodAO9FK5_5alloc11collections5btree3mapINtB5_9ExtractIfyAINtNtCs6gaF1xUz9Bf_4gpui8property12ContributionINtNtCs4NRVxsYgnAr_4core6option6OptionNtNtB1e_11shared_text10SharedTextEEj2_NtNtNtB1Z_3ops5range9RangeFullNCINvMsi_B5_INtB5_8BTreeMapyB18_E6retainNCNvMsq_NtB1e_7runtimeINtB4o_7RuntimeNtNtB4o_12style_ledger9AdversaryE14describe_innersB_0E0ENtNtNtNtB1Z_4iter6traits8iterator8Iterator4nextB1e_>
  5aef5b:	48 8b 84 24 08 03 00 	mov    0x308(%rsp),%rax
  5aef62:	00 
  5aef63:	48 83 f8 02          	cmp    $0x2,%rax
  5aef67:	0f 85 73 ff ff ff    	jne    5aeee0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4e90>
  5aef6d:	e9 c1 fe ff ff       	jmp    5aee33 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4de3>
  5aef72:	48 8b 47 08          	mov    0x8(%rdi),%rax
  5aef76:	41 ff d5             	call   *%r13
  5aef79:	eb a5                	jmp    5aef20 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4ed0>
  5aef7b:	49 8b 47 08          	mov    0x8(%r15),%rax
  5aef7f:	4c 89 ff             	mov    %r15,%rdi
  5aef82:	41 ff d5             	call   *%r13
  5aef85:	eb c9                	jmp    5aef50 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4f00>
  5aef87:	48 83 e8 0d          	sub    $0xd,%rax
  5aef8b:	b9 13 00 00 00       	mov    $0x13,%ecx
  5aef90:	48 0f 4d c8          	cmovge %rax,%rcx
  5aef94:	48 83 f9 17          	cmp    $0x17,%rcx
  5aef98:	74 10                	je     5aefaa <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4f5a>
  5aef9a:	48 83 f9 13          	cmp    $0x13,%rcx
  5aef9e:	75 29                	jne    5aefc9 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4f79>
  5aefa0:	48 8d 84 24 b8 00 00 	lea    0xb8(%rsp),%rax
  5aefa7:	00 
  5aefa8:	eb 08                	jmp    5aefb2 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4f62>
  5aefaa:	48 8d 84 24 a8 00 00 	lea    0xa8(%rsp),%rax
  5aefb1:	00 
  5aefb2:	48 8b 30             	mov    (%rax),%rsi
  5aefb5:	48 85 f6             	test   %rsi,%rsi
  5aefb8:	74 0f                	je     5aefc9 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4f79>
  5aefba:	48 8b 78 08          	mov    0x8(%rax),%rdi
  5aefbe:	ba 01 00 00 00       	mov    $0x1,%edx
  5aefc3:	ff 15 df af 53 00    	call   *0x53afdf(%rip)        # ae9fa8 <_DYNAMIC+0x248>
  5aefc9:	49 c7 86 e8 07 00 00 	movq   $0x0,0x7e8(%r14)
  5aefd0:	00 00 00 00 
  5aefd4:	48 8b 84 24 08 02 00 	mov    0x208(%rsp),%rax
  5aefdb:	00 
  5aefdc:	48 03 84 24 d8 04 00 	add    0x4d8(%rsp),%rax
  5aefe3:	00 
  5aefe4:	49 89 86 48 09 00 00 	mov    %rax,0x948(%r14)
  5aefeb:	48 8b 84 24 88 00 00 	mov    0x88(%rsp),%rax
  5aeff2:	00 
  5aeff3:	48 c7 00 fe ff ff ff 	movq   $0xfffffffffffffffe,(%rax)
  5aeffa:	ba 04 00 00 00       	mov    $0x4,%edx
  5aefff:	48 8b bc 24 48 02 00 	mov    0x248(%rsp),%rdi
  5af006:	00 
  5af007:	48 8b b4 24 d0 02 00 	mov    0x2d0(%rsp),%rsi
  5af00e:	00 
  5af00f:	ff 15 93 af 53 00    	call   *0x53af93(%rip)        # ae9fa8 <_DYNAMIC+0x248>
  5af015:	48 8b b4 24 d8 02 00 	mov    0x2d8(%rsp),%rsi
  5af01c:	00 
  5af01d:	48 85 f6             	test   %rsi,%rsi
  5af020:	74 17                	je     5af039 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4fe9>
  5af022:	48 c1 e6 03          	shl    $0x3,%rsi
  5af026:	ba 08 00 00 00       	mov    $0x8,%edx
  5af02b:	48 8b bc 24 80 00 00 	mov    0x80(%rsp),%rdi
  5af032:	00 
  5af033:	ff 15 6f af 53 00    	call   *0x53af6f(%rip)        # ae9fa8 <_DYNAMIC+0x248>
  5af039:	48 8d bc 24 10 05 00 	lea    0x510(%rsp),%rdi
  5af040:	00 
  5af041:	e8 ca eb 17 00       	call   72dc10 <_RNvXNtNtNtCscdodAO9FK5_5alloc11collections5btree3mapINtB2_8BTreeMapINtNtCs4NRVxsYgnAr_4core6option6OptionyEjENtNtNtB18_3ops4drop4Drop4dropCs6gaF1xUz9Bf_4gpui>
  5af046:	45 31 ed             	xor    %r13d,%r13d
  5af049:	48 8d bc 24 f0 06 00 	lea    0x6f0(%rsp),%rdi
  5af050:	00 
  5af051:	e8 2a 09 18 00       	call   72f980 <_RNvXNtNtNtCscdodAO9FK5_5alloc11collections5btree3mapINtB2_8BTreeMapjNtNtCs6gaF1xUz9Bf_4gpui4list6ListIdENtNtNtCs4NRVxsYgnAr_4core3ops4drop4Drop4dropB18_>
  5af056:	48 8d bc 24 d8 05 00 	lea    0x5d8(%rsp),%rdi
  5af05d:	00 
  5af05e:	e8 4d 02 18 00       	call   72f2b0 <_RNvXNtNtNtCscdodAO9FK5_5alloc11collections5btree3mapINtB2_8BTreeMapTINtNtCs4NRVxsYgnAr_4core6option6OptionyENtNtCs6gaF1xUz9Bf_4gpui4list6ListIdNtNtB1M_7element8NodeKindEjENtNtNtB19_3ops4drop4Drop4dropB1M_>
  5af063:	48 8d bc 24 c0 05 00 	lea    0x5c0(%rsp),%rdi
  5af06a:	00 
  5af06b:	e8 40 02 18 00       	call   72f2b0 <_RNvXNtNtNtCscdodAO9FK5_5alloc11collections5btree3mapINtB2_8BTreeMapTINtNtCs4NRVxsYgnAr_4core6option6OptionyENtNtCs6gaF1xUz9Bf_4gpui4list6ListIdNtNtB1M_7element8NodeKindEjENtNtNtB19_3ops4drop4Drop4dropB1M_>
  5af070:	48 8d bc 24 a8 05 00 	lea    0x5a8(%rsp),%rdi
  5af077:	00 
  5af078:	e8 a3 05 18 00       	call   72f620 <_RNvXNtNtNtCscdodAO9FK5_5alloc11collections5btree3mapINtB2_8BTreeMapTINtNtCs4NRVxsYgnAr_4core6option6OptionyEmNtNtCs6gaF1xUz9Bf_4gpui7element8NodeKindEjENtNtNtB19_3ops4drop4Drop4dropB1N_>
  5af07d:	48 8d bc 24 88 04 00 	lea    0x488(%rsp),%rdi
  5af084:	00 
  5af085:	e8 76 d3 12 00       	call   6dc400 <_RNvXso_NtCscdodAO9FK5_5alloc3vecINtB5_3VecINtNtCs4NRVxsYgnAr_4core6option6OptionNtNtCs6gaF1xUz9Bf_4gpui7runtime4NodeEENtNtNtBJ_3ops4drop4Drop4dropB1k_>
  5af08a:	48 8b 84 24 88 04 00 	mov    0x488(%rsp),%rax
  5af091:	00 
  5af092:	48 85 c0             	test   %rax,%rax
  5af095:	74 1b                	je     5af0b2 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5062>
  5af097:	48 8b bc 24 90 04 00 	mov    0x490(%rsp),%rdi
  5af09e:	00 
  5af09f:	48 c1 e0 03          	shl    $0x3,%rax
  5af0a3:	48 8d 34 80          	lea    (%rax,%rax,4),%rsi
  5af0a7:	ba 08 00 00 00       	mov    $0x8,%edx
  5af0ac:	ff 15 f6 ae 53 00    	call   *0x53aef6(%rip)        # ae9fa8 <_DYNAMIC+0x248>
  5af0b2:	48 8b 84 24 40 05 00 	mov    0x540(%rsp),%rax
  5af0b9:	00 
  5af0ba:	48 85 c0             	test   %rax,%rax
  5af0bd:	74 6a                	je     5af129 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x50d9>
  5af0bf:	48 83 f8 01          	cmp    $0x1,%rax
  5af0c3:	75 20                	jne    5af0e5 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5095>
  5af0c5:	48 8b 84 24 48 05 00 	mov    0x548(%rsp),%rax
  5af0cc:	00 
  5af0cd:	48 85 c0             	test   %rax,%rax
  5af0d0:	74 57                	je     5af129 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x50d9>
  5af0d2:	48 8b bc 24 50 05 00 	mov    0x550(%rsp),%rdi
  5af0d9:	00 
  5af0da:	48 6b f0 58          	imul   $0x58,%rax,%rsi
  5af0de:	ba 04 00 00 00       	mov    $0x4,%edx
  5af0e3:	eb 3e                	jmp    5af123 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x50d3>
  5af0e5:	48 8b 84 24 50 05 00 	mov    0x550(%rsp),%rax
  5af0ec:	00 
  5af0ed:	48 85 c0             	test   %rax,%rax
  5af0f0:	74 17                	je     5af109 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x50b9>
  5af0f2:	48 8b bc 24 48 05 00 	mov    0x548(%rsp),%rdi
  5af0f9:	00 
  5af0fa:	48 6b f0 58          	imul   $0x58,%rax,%rsi
  5af0fe:	ba 04 00 00 00       	mov    $0x4,%edx
  5af103:	ff 15 9f ae 53 00    	call   *0x53ae9f(%rip)        # ae9fa8 <_DYNAMIC+0x248>
  5af109:	48 8b b4 24 60 05 00 	mov    0x560(%rsp),%rsi
  5af110:	00 
  5af111:	48 85 f6             	test   %rsi,%rsi
  5af114:	74 13                	je     5af129 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x50d9>
  5af116:	48 8b bc 24 58 05 00 	mov    0x558(%rsp),%rdi
  5af11d:	00 
  5af11e:	ba 01 00 00 00       	mov    $0x1,%edx
  5af123:	ff 15 7f ae 53 00    	call   *0x53ae7f(%rip)        # ae9fa8 <_DYNAMIC+0x248>
  5af129:	48 8d bc 24 58 04 00 	lea    0x458(%rsp),%rdi
  5af130:	00 
  5af131:	e8 fa f8 17 00       	call   72ea30 <_RNvXNtNtNtCscdodAO9FK5_5alloc11collections5btree3mapINtB2_8BTreeMapNtNtCs6gaF1xUz9Bf_4gpui6source7FieldIdNtNtB17_11shared_text10SharedTextENtNtNtCs4NRVxsYgnAr_4core3ops4drop4Drop4dropB17_>
  5af136:	40 84 ed             	test   %bpl,%bpl
  5af139:	74 24                	je     5af15f <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x510f>
  5af13b:	48 8b b4 24 b8 02 00 	mov    0x2b8(%rsp),%rsi
  5af142:	00 
  5af143:	48 85 f6             	test   %rsi,%rsi
  5af146:	74 17                	je     5af15f <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x510f>
  5af148:	48 8b bc 24 c0 02 00 	mov    0x2c0(%rsp),%rdi
  5af14f:	00 
  5af150:	48 c1 e6 04          	shl    $0x4,%rsi
  5af154:	ba 08 00 00 00       	mov    $0x8,%edx
  5af159:	ff 15 49 ae 53 00    	call   *0x53ae49(%rip)        # ae9fa8 <_DYNAMIC+0x248>
  5af15f:	ba 08 00 00 00       	mov    $0x8,%edx
  5af164:	48 8b bc 24 e0 02 00 	mov    0x2e0(%rsp),%rdi
  5af16b:	00 
  5af16c:	48 8b b4 24 c8 04 00 	mov    0x4c8(%rsp),%rsi
  5af173:	00 
  5af174:	ff 15 2e ae 53 00    	call   *0x53ae2e(%rip)        # ae9fa8 <_DYNAMIC+0x248>
  5af17a:	48 8b b4 24 a0 02 00 	mov    0x2a0(%rsp),%rsi
  5af181:	00 
  5af182:	48 85 f6             	test   %rsi,%rsi
  5af185:	74 17                	je     5af19e <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x514e>
  5af187:	48 8b bc 24 a8 02 00 	mov    0x2a8(%rsp),%rdi
  5af18e:	00 
  5af18f:	48 c1 e6 02          	shl    $0x2,%rsi
  5af193:	ba 04 00 00 00       	mov    $0x4,%edx
  5af198:	ff 15 0a ae 53 00    	call   *0x53ae0a(%rip)        # ae9fa8 <_DYNAMIC+0x248>
  5af19e:	48 8b b4 24 88 02 00 	mov    0x288(%rsp),%rsi
  5af1a5:	00 
  5af1a6:	48 85 f6             	test   %rsi,%rsi
  5af1a9:	74 17                	je     5af1c2 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5172>
  5af1ab:	48 8b bc 24 90 02 00 	mov    0x290(%rsp),%rdi
  5af1b2:	00 
  5af1b3:	48 c1 e6 03          	shl    $0x3,%rsi
  5af1b7:	ba 08 00 00 00       	mov    $0x8,%edx
  5af1bc:	ff 15 e6 ad 53 00    	call   *0x53ade6(%rip)        # ae9fa8 <_DYNAMIC+0x248>
  5af1c2:	48 8b b4 24 e8 02 00 	mov    0x2e8(%rsp),%rsi
  5af1c9:	00 
  5af1ca:	48 85 f6             	test   %rsi,%rsi
  5af1cd:	74 17                	je     5af1e6 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5196>
  5af1cf:	48 8b bc 24 f0 02 00 	mov    0x2f0(%rsp),%rdi
  5af1d6:	00 
  5af1d7:	48 c1 e6 03          	shl    $0x3,%rsi
  5af1db:	ba 08 00 00 00       	mov    $0x8,%edx
  5af1e0:	ff 15 c2 ad 53 00    	call   *0x53adc2(%rip)        # ae9fa8 <_DYNAMIC+0x248>
  5af1e6:	45 31 f6             	xor    %r14d,%r14d
  5af1e9:	48 8d bc 24 20 06 00 	lea    0x620(%rsp),%rdi
  5af1f0:	00 
  5af1f1:	e8 8a 07 18 00       	call   72f980 <_RNvXNtNtNtCscdodAO9FK5_5alloc11collections5btree3mapINtB2_8BTreeMapjNtNtCs6gaF1xUz9Bf_4gpui4list6ListIdENtNtNtCs4NRVxsYgnAr_4core3ops4drop4Drop4dropB18_>
  5af1f6:	45 31 ed             	xor    %r13d,%r13d
  5af1f9:	48 8d bc 24 c0 06 00 	lea    0x6c0(%rsp),%rdi
  5af200:	00 
  5af201:	89 eb                	mov    %ebp,%ebx
  5af203:	45 31 ff             	xor    %r15d,%r15d
  5af206:	e8 05 ea 17 00       	call   72dc10 <_RNvXNtNtNtCscdodAO9FK5_5alloc11collections5btree3mapINtB2_8BTreeMapINtNtCs4NRVxsYgnAr_4core6option6OptionyEjENtNtNtB18_3ops4drop4Drop4dropCs6gaF1xUz9Bf_4gpui>
  5af20b:	45 31 ed             	xor    %r13d,%r13d
  5af20e:	48 8d bc 24 a8 06 00 	lea    0x6a8(%rsp),%rdi
  5af215:	00 
  5af216:	45 31 ff             	xor    %r15d,%r15d
  5af219:	8b 6c 24 20          	mov    0x20(%rsp),%ebp
  5af21d:	e8 5e 07 18 00       	call   72f980 <_RNvXNtNtNtCscdodAO9FK5_5alloc11collections5btree3mapINtB2_8BTreeMapjNtNtCs6gaF1xUz9Bf_4gpui4list6ListIdENtNtNtCs4NRVxsYgnAr_4core3ops4drop4Drop4dropB18_>
  5af222:	40 84 ed             	test   %bpl,%bpl
  5af225:	0f 84 9e 04 00 00    	je     5af6c9 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5679>
  5af22b:	48 8b 9c 24 48 04 00 	mov    0x448(%rsp),%rbx
  5af232:	00 
  5af233:	4c 8b b4 24 50 04 00 	mov    0x450(%rsp),%r14
  5af23a:	00 
  5af23b:	4d 85 f6             	test   %r14,%r14
  5af23e:	74 54                	je     5af294 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5244>
  5af240:	4c 8d 7b 20          	lea    0x20(%rbx),%r15
  5af244:	4c 8b 25 5d ad 53 00 	mov    0x53ad5d(%rip),%r12        # ae9fa8 <_DYNAMIC+0x248>
  5af24b:	eb 0c                	jmp    5af259 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5209>
  5af24d:	0f 1f 00             	nopl   (%rax)
  5af250:	49 83 c7 38          	add    $0x38,%r15
  5af254:	49 ff ce             	dec    %r14
  5af257:	74 3b                	je     5af294 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5244>
  5af259:	49 8b 77 e0          	mov    -0x20(%r15),%rsi
  5af25d:	48 83 fe ff          	cmp    $0xffffffffffffffff,%rsi
  5af261:	74 13                	je     5af276 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5226>
  5af263:	48 85 f6             	test   %rsi,%rsi
  5af266:	78 0e                	js     5af276 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5226>
  5af268:	74 0c                	je     5af276 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5226>
  5af26a:	49 8b 7f e8          	mov    -0x18(%r15),%rdi
  5af26e:	ba 01 00 00 00       	mov    $0x1,%edx
  5af273:	41 ff d4             	call   *%r12
  5af276:	49 8b 77 f8          	mov    -0x8(%r15),%rsi
  5af27a:	48 83 fe ff          	cmp    $0xffffffffffffffff,%rsi
  5af27e:	74 d0                	je     5af250 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5200>
  5af280:	48 85 f6             	test   %rsi,%rsi
  5af283:	78 cb                	js     5af250 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5200>
  5af285:	74 c9                	je     5af250 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5200>
  5af287:	49 8b 3f             	mov    (%r15),%rdi
  5af28a:	ba 01 00 00 00       	mov    $0x1,%edx
  5af28f:	41 ff d4             	call   *%r12
  5af292:	eb bc                	jmp    5af250 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5200>
  5af294:	48 8b 84 24 40 04 00 	mov    0x440(%rsp),%rax
  5af29b:	00 
  5af29c:	48 85 c0             	test   %rax,%rax
  5af29f:	0f 84 24 04 00 00    	je     5af6c9 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5679>
  5af2a5:	48 6b f0 38          	imul   $0x38,%rax,%rsi
  5af2a9:	e9 0d 04 00 00       	jmp    5af6bb <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x566b>
  5af2ae:	b8 0c 00 00 00       	mov    $0xc,%eax
  5af2b3:	0f a3 c8             	bt     %ecx,%eax
  5af2b6:	0f 82 18 fd ff ff    	jb     5aefd4 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4f84>
  5af2bc:	48 8d 3d f5 c7 ac ff 	lea    -0x53380b(%rip),%rdi        # 7bab8 <anon.5f884de6e78125e25881320d811d32df.113.llvm.17146438997930651657+0x88>
  5af2c3:	48 8d 15 9e 9a 50 00 	lea    0x509a9e(%rip),%rdx        # ab8d68 <anon.2a25786c1a741fd89e690b6b2ddad436.63.llvm.18021777786862421399+0x130>
  5af2ca:	be a1 00 00 00       	mov    $0xa1,%esi
  5af2cf:	ff 15 0b ad 53 00    	call   *0x53ad0b(%rip)        # ae9fe0 <_DYNAMIC+0x280>
  5af2d5:	e9 6c 09 00 00       	jmp    5afc46 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5bf6>
  5af2da:	48 8b 84 24 88 00 00 	mov    0x88(%rsp),%rax
  5af2e1:	00 
  5af2e2:	48 c7 00 1b 00 00 00 	movq   $0x1b,(%rax)
  5af2e9:	eb 0f                	jmp    5af2fa <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x52aa>
  5af2eb:	48 8b 84 24 88 00 00 	mov    0x88(%rsp),%rax
  5af2f2:	00 
  5af2f3:	48 c7 00 1c 00 00 00 	movq   $0x1c,(%rax)
  5af2fa:	48 8b 8c 24 80 00 00 	mov    0x80(%rsp),%rcx
  5af301:	00 
  5af302:	48 89 48 08          	mov    %rcx,0x8(%rax)
  5af306:	48 8b 8c 24 30 02 00 	mov    0x230(%rsp),%rcx
  5af30d:	00 
  5af30e:	48 85 c9             	test   %rcx,%rcx
  5af311:	0f 84 ca bd ff ff    	je     5ab0e1 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1091>
  5af317:	48 8b 94 24 38 02 00 	mov    0x238(%rsp),%rdx
  5af31e:	00 
  5af31f:	48 8b 84 24 40 02 00 	mov    0x240(%rsp),%rax
  5af326:	00 
  5af327:	48 c7 84 24 a8 00 00 	movq   $0x0,0xa8(%rsp)
  5af32e:	00 00 00 00 00 
  5af333:	48 89 8c 24 b0 00 00 	mov    %rcx,0xb0(%rsp)
  5af33a:	00 
  5af33b:	48 89 94 24 b8 00 00 	mov    %rdx,0xb8(%rsp)
  5af342:	00 
  5af343:	48 c7 84 24 c8 00 00 	movq   $0x0,0xc8(%rsp)
  5af34a:	00 00 00 00 00 
  5af34f:	48 89 8c 24 d0 00 00 	mov    %rcx,0xd0(%rsp)
  5af356:	00 
  5af357:	48 89 94 24 d8 00 00 	mov    %rdx,0xd8(%rsp)
  5af35e:	00 
  5af35f:	b9 01 00 00 00       	mov    $0x1,%ecx
  5af364:	48 89 8c 24 a0 00 00 	mov    %rcx,0xa0(%rsp)
  5af36b:	00 
  5af36c:	48 89 8c 24 c0 00 00 	mov    %rcx,0xc0(%rsp)
  5af373:	00 
  5af374:	48 89 84 24 e0 00 00 	mov    %rax,0xe0(%rsp)
  5af37b:	00 
  5af37c:	48 8d bc 24 00 03 00 	lea    0x300(%rsp),%rdi
  5af383:	00 
  5af384:	48 8d b4 24 a0 00 00 	lea    0xa0(%rsp),%rsi
  5af38b:	00 
  5af38c:	e8 2f a2 17 00       	call   7295c0 <_RNvMsz_NtNtNtCscdodAO9FK5_5alloc11collections5btree3mapINtB5_8IntoIterNtNtCs6gaF1xUz9Bf_4gpui6source7FieldIdNtNtB1a_7runtime6FanoutE10dying_nextB1a_.llvm.555413502705965614>
  5af391:	48 8b 84 24 00 03 00 	mov    0x300(%rsp),%rax
  5af398:	00 
  5af399:	48 85 c0             	test   %rax,%rax
  5af39c:	74 68                	je     5af406 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x53b6>
  5af39e:	48 8d 9c 24 00 03 00 	lea    0x300(%rsp),%rbx
  5af3a5:	00 
  5af3a6:	4c 8d b4 24 a0 00 00 	lea    0xa0(%rsp),%r14
  5af3ad:	00 
  5af3ae:	4c 8b 3d f3 ab 53 00 	mov    0x53abf3(%rip),%r15        # ae9fa8 <_DYNAMIC+0x248>
  5af3b5:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
  5af3bc:	00 00 00 00 
  5af3c0:	48 8b 8c 24 10 03 00 	mov    0x310(%rsp),%rcx
  5af3c7:	00 
  5af3c8:	48 8d 0c 89          	lea    (%rcx,%rcx,4),%rcx
  5af3cc:	48 8b 74 c8 60       	mov    0x60(%rax,%rcx,8),%rsi
  5af3d1:	48 85 f6             	test   %rsi,%rsi
  5af3d4:	74 18                	je     5af3ee <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x539e>
  5af3d6:	48 8d 04 c8          	lea    (%rax,%rcx,8),%rax
  5af3da:	48 83 c0 60          	add    $0x60,%rax
  5af3de:	48 8b 78 08          	mov    0x8(%rax),%rdi
  5af3e2:	48 c1 e6 02          	shl    $0x2,%rsi
  5af3e6:	ba 04 00 00 00       	mov    $0x4,%edx
  5af3eb:	41 ff d7             	call   *%r15
  5af3ee:	48 89 df             	mov    %rbx,%rdi
  5af3f1:	4c 89 f6             	mov    %r14,%rsi
  5af3f4:	e8 c7 a1 17 00       	call   7295c0 <_RNvMsz_NtNtNtCscdodAO9FK5_5alloc11collections5btree3mapINtB5_8IntoIterNtNtCs6gaF1xUz9Bf_4gpui6source7FieldIdNtNtB1a_7runtime6FanoutE10dying_nextB1a_.llvm.555413502705965614>
  5af3f9:	48 8b 84 24 00 03 00 	mov    0x300(%rsp),%rax
  5af400:	00 
  5af401:	48 85 c0             	test   %rax,%rax
  5af404:	75 ba                	jne    5af3c0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5370>
  5af406:	ba 08 00 00 00       	mov    $0x8,%edx
  5af40b:	48 8b bc 24 e0 02 00 	mov    0x2e0(%rsp),%rdi
  5af412:	00 
  5af413:	4a 8d 34 e5 08 00 00 	lea    0x8(,%r12,8),%rsi
  5af41a:	00 
  5af41b:	ff 15 87 ab 53 00    	call   *0x53ab87(%rip)        # ae9fa8 <_DYNAMIC+0x248>
  5af421:	48 8b b4 24 a0 02 00 	mov    0x2a0(%rsp),%rsi
  5af428:	00 
  5af429:	48 85 f6             	test   %rsi,%rsi
  5af42c:	74 17                	je     5af445 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x53f5>
  5af42e:	48 8b bc 24 a8 02 00 	mov    0x2a8(%rsp),%rdi
  5af435:	00 
  5af436:	48 c1 e6 02          	shl    $0x2,%rsi
  5af43a:	ba 04 00 00 00       	mov    $0x4,%edx
  5af43f:	ff 15 63 ab 53 00    	call   *0x53ab63(%rip)        # ae9fa8 <_DYNAMIC+0x248>
  5af445:	48 8b b4 24 88 02 00 	mov    0x288(%rsp),%rsi
  5af44c:	00 
  5af44d:	48 85 f6             	test   %rsi,%rsi
  5af450:	74 17                	je     5af469 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5419>
  5af452:	48 8b bc 24 90 02 00 	mov    0x290(%rsp),%rdi
  5af459:	00 
  5af45a:	48 c1 e6 03          	shl    $0x3,%rsi
  5af45e:	ba 08 00 00 00       	mov    $0x8,%edx
  5af463:	ff 15 3f ab 53 00    	call   *0x53ab3f(%rip)        # ae9fa8 <_DYNAMIC+0x248>
  5af469:	48 8b b4 24 e8 02 00 	mov    0x2e8(%rsp),%rsi
  5af470:	00 
  5af471:	48 85 f6             	test   %rsi,%rsi
  5af474:	74 17                	je     5af48d <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x543d>
  5af476:	48 8b bc 24 f0 02 00 	mov    0x2f0(%rsp),%rdi
  5af47d:	00 
  5af47e:	48 c1 e6 03          	shl    $0x3,%rsi
  5af482:	ba 08 00 00 00       	mov    $0x8,%edx
  5af487:	ff 15 1b ab 53 00    	call   *0x53ab1b(%rip)        # ae9fa8 <_DYNAMIC+0x248>
  5af48d:	40 b5 01             	mov    $0x1,%bpl
  5af490:	48 8d bc 24 20 06 00 	lea    0x620(%rsp),%rdi
  5af497:	00 
  5af498:	41 b6 01             	mov    $0x1,%r14b
  5af49b:	e8 e0 04 18 00       	call   72f980 <_RNvXNtNtNtCscdodAO9FK5_5alloc11collections5btree3mapINtB2_8BTreeMapjNtNtCs6gaF1xUz9Bf_4gpui4list6ListIdENtNtNtCs4NRVxsYgnAr_4core3ops4drop4Drop4dropB18_>
  5af4a0:	48 8b 84 24 80 04 00 	mov    0x480(%rsp),%rax
  5af4a7:	00 
  5af4a8:	48 85 c0             	test   %rax,%rax
  5af4ab:	74 41                	je     5af4ee <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x549e>
  5af4ad:	48 8b 9c 24 78 04 00 	mov    0x478(%rsp),%rbx
  5af4b4:	00 
  5af4b5:	41 be 01 00 00 00    	mov    $0x1,%r14d
  5af4bb:	49 29 c6             	sub    %rax,%r14
  5af4be:	4c 8b 3d 23 ab 53 00 	mov    0x53ab23(%rip),%r15        # ae9fe8 <_DYNAMIC+0x288>
  5af4c5:	eb 16                	jmp    5af4dd <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x548d>
  5af4c7:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
  5af4ce:	00 00 
  5af4d0:	48 83 c3 08          	add    $0x8,%rbx
  5af4d4:	49 ff c6             	inc    %r14
  5af4d7:	49 83 fe 01          	cmp    $0x1,%r14
  5af4db:	74 11                	je     5af4ee <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x549e>
  5af4dd:	48 8b 03             	mov    (%rbx),%rax
  5af4e0:	f0 48 ff 08          	lock decq (%rax)
  5af4e4:	75 ea                	jne    5af4d0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5480>
  5af4e6:	48 89 df             	mov    %rbx,%rdi
  5af4e9:	41 ff d7             	call   *%r15
  5af4ec:	eb e2                	jmp    5af4d0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5480>
  5af4ee:	48 8b b4 24 70 04 00 	mov    0x470(%rsp),%rsi
  5af4f5:	00 
  5af4f6:	48 85 f6             	test   %rsi,%rsi
  5af4f9:	74 17                	je     5af512 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x54c2>
  5af4fb:	48 8b bc 24 78 04 00 	mov    0x478(%rsp),%rdi
  5af502:	00 
  5af503:	48 c1 e6 03          	shl    $0x3,%rsi
  5af507:	ba 08 00 00 00       	mov    $0x8,%edx
  5af50c:	ff 15 96 aa 53 00    	call   *0x53aa96(%rip)        # ae9fa8 <_DYNAMIC+0x248>
  5af512:	45 31 ed             	xor    %r13d,%r13d
  5af515:	b3 01                	mov    $0x1,%bl
  5af517:	48 8d bc 24 c0 06 00 	lea    0x6c0(%rsp),%rdi
  5af51e:	00 
  5af51f:	41 b7 01             	mov    $0x1,%r15b
  5af522:	e8 e9 e6 17 00       	call   72dc10 <_RNvXNtNtNtCscdodAO9FK5_5alloc11collections5btree3mapINtB2_8BTreeMapINtNtCs4NRVxsYgnAr_4core6option6OptionyEjENtNtNtB18_3ops4drop4Drop4dropCs6gaF1xUz9Bf_4gpui>
  5af527:	40 b5 01             	mov    $0x1,%bpl
  5af52a:	48 8d bc 24 a8 06 00 	lea    0x6a8(%rsp),%rdi
  5af531:	00 
  5af532:	41 b7 01             	mov    $0x1,%r15b
  5af535:	e8 46 04 18 00       	call   72f980 <_RNvXNtNtNtCscdodAO9FK5_5alloc11collections5btree3mapINtB2_8BTreeMapjNtNtCs6gaF1xUz9Bf_4gpui4list6ListIdENtNtNtCs4NRVxsYgnAr_4core3ops4drop4Drop4dropB18_>
  5af53a:	48 8b 8c 24 e8 04 00 	mov    0x4e8(%rsp),%rcx
  5af541:	00 
  5af542:	48 85 c9             	test   %rcx,%rcx
  5af545:	0f 95 c0             	setne  %al
  5af548:	41 84 c5             	test   %al,%r13b
  5af54b:	74 1b                	je     5af568 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5518>
  5af54d:	48 c1 e1 03          	shl    $0x3,%rcx
  5af551:	48 8d 34 49          	lea    (%rcx,%rcx,2),%rsi
  5af555:	ba 08 00 00 00       	mov    $0x8,%edx
  5af55a:	48 8b bc 24 e0 04 00 	mov    0x4e0(%rsp),%rdi
  5af561:	00 
  5af562:	ff 15 40 aa 53 00    	call   *0x53aa40(%rip)        # ae9fa8 <_DYNAMIC+0x248>
  5af568:	48 8b 9c 24 48 04 00 	mov    0x448(%rsp),%rbx
  5af56f:	00 
  5af570:	4c 8b b4 24 50 04 00 	mov    0x450(%rsp),%r14
  5af577:	00 
  5af578:	4d 85 f6             	test   %r14,%r14
  5af57b:	74 57                	je     5af5d4 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5584>
  5af57d:	4c 8d 7b 20          	lea    0x20(%rbx),%r15
  5af581:	4c 8b 2d 20 aa 53 00 	mov    0x53aa20(%rip),%r13        # ae9fa8 <_DYNAMIC+0x248>
  5af588:	eb 0f                	jmp    5af599 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5549>
  5af58a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
  5af590:	49 83 c7 38          	add    $0x38,%r15
  5af594:	49 ff ce             	dec    %r14
  5af597:	74 3b                	je     5af5d4 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5584>
  5af599:	49 8b 77 e0          	mov    -0x20(%r15),%rsi
  5af59d:	48 83 fe ff          	cmp    $0xffffffffffffffff,%rsi
  5af5a1:	74 13                	je     5af5b6 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5566>
  5af5a3:	48 85 f6             	test   %rsi,%rsi
  5af5a6:	78 0e                	js     5af5b6 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5566>
  5af5a8:	74 0c                	je     5af5b6 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5566>
  5af5aa:	49 8b 7f e8          	mov    -0x18(%r15),%rdi
  5af5ae:	ba 01 00 00 00       	mov    $0x1,%edx
  5af5b3:	41 ff d5             	call   *%r13
  5af5b6:	49 8b 77 f8          	mov    -0x8(%r15),%rsi
  5af5ba:	48 83 fe ff          	cmp    $0xffffffffffffffff,%rsi
  5af5be:	74 d0                	je     5af590 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5540>
  5af5c0:	48 85 f6             	test   %rsi,%rsi
  5af5c3:	78 cb                	js     5af590 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5540>
  5af5c5:	74 c9                	je     5af590 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5540>
  5af5c7:	49 8b 3f             	mov    (%r15),%rdi
  5af5ca:	ba 01 00 00 00       	mov    $0x1,%edx
  5af5cf:	41 ff d5             	call   *%r13
  5af5d2:	eb bc                	jmp    5af590 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5540>
  5af5d4:	48 8b 84 24 40 04 00 	mov    0x440(%rsp),%rax
  5af5db:	00 
  5af5dc:	48 85 c0             	test   %rax,%rax
  5af5df:	74 12                	je     5af5f3 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x55a3>
  5af5e1:	48 6b f0 38          	imul   $0x38,%rax,%rsi
  5af5e5:	ba 08 00 00 00       	mov    $0x8,%edx
  5af5ea:	48 89 df             	mov    %rbx,%rdi
  5af5ed:	ff 15 b5 a9 53 00    	call   *0x53a9b5(%rip)        # ae9fa8 <_DYNAMIC+0x248>
  5af5f3:	48 8b 9c 24 f8 04 00 	mov    0x4f8(%rsp),%rbx
  5af5fa:	00 
  5af5fb:	4c 8b b4 24 00 05 00 	mov    0x500(%rsp),%r14
  5af602:	00 
  5af603:	4d 85 f6             	test   %r14,%r14
  5af606:	74 57                	je     5af65f <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x560f>
  5af608:	4c 8d bb 88 00 00 00 	lea    0x88(%rbx),%r15
  5af60f:	4c 8b 2d 92 a9 53 00 	mov    0x53a992(%rip),%r13        # ae9fa8 <_DYNAMIC+0x248>
  5af616:	eb 14                	jmp    5af62c <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x55dc>
  5af618:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  5af61f:	00 
  5af620:	49 81 c7 a8 00 00 00 	add    $0xa8,%r15
  5af627:	49 ff ce             	dec    %r14
  5af62a:	74 33                	je     5af65f <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x560f>
  5af62c:	49 8b 77 90          	mov    -0x70(%r15),%rsi
  5af630:	48 85 f6             	test   %rsi,%rsi
  5af633:	74 10                	je     5af645 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x55f5>
  5af635:	49 8b 7f 98          	mov    -0x68(%r15),%rdi
  5af639:	48 c1 e6 03          	shl    $0x3,%rsi
  5af63d:	ba 08 00 00 00       	mov    $0x8,%edx
  5af642:	41 ff d5             	call   *%r13
  5af645:	49 8b 77 f8          	mov    -0x8(%r15),%rsi
  5af649:	48 85 f6             	test   %rsi,%rsi
  5af64c:	74 d2                	je     5af620 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x55d0>
  5af64e:	49 8b 3f             	mov    (%r15),%rdi
  5af651:	48 c1 e6 05          	shl    $0x5,%rsi
  5af655:	ba 08 00 00 00       	mov    $0x8,%edx
  5af65a:	41 ff d5             	call   *%r13
  5af65d:	eb c1                	jmp    5af620 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x55d0>
  5af65f:	48 8b 84 24 f0 04 00 	mov    0x4f0(%rsp),%rax
  5af666:	00 
  5af667:	48 85 c0             	test   %rax,%rax
  5af66a:	74 15                	je     5af681 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5631>
  5af66c:	48 69 f0 a8 00 00 00 	imul   $0xa8,%rax,%rsi
  5af673:	ba 08 00 00 00       	mov    $0x8,%edx
  5af678:	48 89 df             	mov    %rbx,%rdi
  5af67b:	ff 15 27 a9 53 00    	call   *0x53a927(%rip)        # ae9fa8 <_DYNAMIC+0x248>
  5af681:	48 8b 9c 24 40 06 00 	mov    0x640(%rsp),%rbx
  5af688:	00 
  5af689:	49 ff c4             	inc    %r12
  5af68c:	48 89 df             	mov    %rbx,%rdi
  5af68f:	90                   	nop
  5af690:	49 83 fc 01          	cmp    $0x1,%r12
  5af694:	74 14                	je     5af6aa <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x565a>
  5af696:	4c 8d b7 98 00 00 00 	lea    0x98(%rdi),%r14
  5af69d:	49 ff cc             	dec    %r12
  5af6a0:	e8 3b 6c 12 00       	call   6d62e0 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueNtNtCs6gaF1xUz9Bf_4gpui7element9DraftNodeEBF_.llvm.6411074540271373818>
  5af6a5:	4c 89 f7             	mov    %r14,%rdi
  5af6a8:	eb e6                	jmp    5af690 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5640>
  5af6aa:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  5af6af:	48 85 c0             	test   %rax,%rax
  5af6b2:	74 15                	je     5af6c9 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5679>
  5af6b4:	48 69 f0 98 00 00 00 	imul   $0x98,%rax,%rsi
  5af6bb:	ba 08 00 00 00       	mov    $0x8,%edx
  5af6c0:	48 89 df             	mov    %rbx,%rdi
  5af6c3:	ff 15 df a8 53 00    	call   *0x53a8df(%rip)        # ae9fa8 <_DYNAMIC+0x248>
  5af6c9:	48 8d bc 24 d8 06 00 	lea    0x6d8(%rsp),%rdi
  5af6d0:	00 
  5af6d1:	e8 ea ec 17 00       	call   72e3c0 <_RNvXNtNtNtCscdodAO9FK5_5alloc11collections5btree3mapINtB2_8BTreeMapNtNtCs6gaF1xUz9Bf_4gpui4list6ListIdNtNtB4_7set_val9SetValZSTENtNtNtCs4NRVxsYgnAr_4core3ops4drop4Drop4dropB17_>
  5af6d6:	48 81 c4 b8 07 00 00 	add    $0x7b8,%rsp
  5af6dd:	5b                   	pop    %rbx
  5af6de:	41 5c                	pop    %r12
  5af6e0:	41 5d                	pop    %r13
  5af6e2:	41 5e                	pop    %r14
  5af6e4:	41 5f                	pop    %r15
  5af6e6:	5d                   	pop    %rbp
  5af6e7:	c3                   	ret
  5af6e8:	48 8b 8c 24 b0 00 00 	mov    0xb0(%rsp),%rcx
  5af6ef:	00 
  5af6f0:	48 8b 94 24 88 00 00 	mov    0x88(%rsp),%rdx
  5af6f7:	00 
  5af6f8:	48 c7 02 1f 00 00 00 	movq   $0x1f,(%rdx)
  5af6ff:	48 89 42 08          	mov    %rax,0x8(%rdx)
  5af703:	4c 89 7a 10          	mov    %r15,0x10(%rdx)
  5af707:	48 89 4a 18          	mov    %rcx,0x18(%rdx)
  5af70b:	48 8b 8c 24 30 02 00 	mov    0x230(%rsp),%rcx
  5af712:	00 
  5af713:	48 85 c9             	test   %rcx,%rcx
  5af716:	0f 85 fb fb ff ff    	jne    5af317 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x52c7>
  5af71c:	e9 c0 b9 ff ff       	jmp    5ab0e1 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x1091>
  5af721:	48 8d 3d bb c4 ac ff 	lea    -0x533b45(%rip),%rdi        # 7bbe3 <anon.2a25786c1a741fd89e690b6b2ddad436.90.llvm.18021777786862421399+0x5e>
  5af728:	48 8d 15 09 99 50 00 	lea    0x509909(%rip),%rdx        # ab9038 <anon.2a25786c1a741fd89e690b6b2ddad436.91.llvm.18021777786862421399+0x240>
  5af72f:	be 1b 00 00 00       	mov    $0x1b,%esi
  5af734:	ff 15 d6 a8 53 00    	call   *0x53a8d6(%rip)        # aea010 <_DYNAMIC+0x2b0>
  5af73a:	e9 07 05 00 00       	jmp    5afc46 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5bf6>
  5af73f:	48 8d 3d c2 98 50 00 	lea    0x5098c2(%rip),%rdi        # ab9008 <anon.2a25786c1a741fd89e690b6b2ddad436.91.llvm.18021777786862421399+0x210>
  5af746:	ff 15 cc a8 53 00    	call   *0x53a8cc(%rip)        # aea018 <_DYNAMIC+0x2b8>
  5af74c:	e9 f5 04 00 00       	jmp    5afc46 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5bf6>
  5af751:	48 8d 3d 70 d6 50 00 	lea    0x50d670(%rip),%rdi        # abcdc8 <anon.44dba9ca3a5ffd621ac1ab2f4c761e66.4.llvm.5781859365923200523>
  5af758:	ff 15 ba a8 53 00    	call   *0x53a8ba(%rip)        # aea018 <_DYNAMIC+0x2b8>
  5af75e:	e9 e3 04 00 00       	jmp    5afc46 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5bf6>
  5af763:	48 8d 3d 0e 94 50 00 	lea    0x50940e(%rip),%rdi        # ab8b78 <anon.2a25786c1a741fd89e690b6b2ddad436.26.llvm.18021777786862421399+0x210>
  5af76a:	ff 15 a8 a8 53 00    	call   *0x53a8a8(%rip)        # aea018 <_DYNAMIC+0x2b8>
  5af770:	e9 d1 04 00 00       	jmp    5afc46 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5bf6>
  5af775:	48 8d 3d 51 c4 ac ff 	lea    -0x533baf(%rip),%rdi        # 7bbcd <anon.2a25786c1a741fd89e690b6b2ddad436.90.llvm.18021777786862421399+0x48>
  5af77c:	48 8d 15 3d 98 50 00 	lea    0x50983d(%rip),%rdx        # ab8fc0 <anon.2a25786c1a741fd89e690b6b2ddad436.91.llvm.18021777786862421399+0x1c8>
  5af783:	be 16 00 00 00       	mov    $0x16,%esi
  5af788:	ff 15 82 a8 53 00    	call   *0x53a882(%rip)        # aea010 <_DYNAMIC+0x2b0>
  5af78e:	e9 b3 04 00 00       	jmp    5afc46 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5bf6>
  5af793:	48 8b 84 24 88 00 00 	mov    0x88(%rsp),%rax
  5af79a:	00 
  5af79b:	48 c7 00 1e 00 00 00 	movq   $0x1e,(%rax)
  5af7a2:	41 b5 01             	mov    $0x1,%r13b
  5af7a5:	e9 6d fd ff ff       	jmp    5af517 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x54c7>
  5af7aa:	48 8d 3d 07 c3 ac ff 	lea    -0x533cf9(%rip),%rdi        # 7bab8 <anon.5f884de6e78125e25881320d811d32df.113.llvm.17146438997930651657+0x88>
  5af7b1:	48 8d 15 b0 95 50 00 	lea    0x5095b0(%rip),%rdx        # ab8d68 <anon.2a25786c1a741fd89e690b6b2ddad436.63.llvm.18021777786862421399+0x130>
  5af7b8:	be a1 00 00 00       	mov    $0xa1,%esi
  5af7bd:	ff 15 1d a8 53 00    	call   *0x53a81d(%rip)        # ae9fe0 <_DYNAMIC+0x280>
  5af7c3:	e9 7e 04 00 00       	jmp    5afc46 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5bf6>
  5af7c8:	48 8d 3d f0 fc ac ff 	lea    -0x530310(%rip),%rdi        # 7f4bf <anon.45400ae144863d14b1a5886db4cd3638.66.llvm.11038256780392951182>
  5af7cf:	48 8d 15 0a 11 51 00 	lea    0x51110a(%rip),%rdx        # ac08e0 <anon.45400ae144863d14b1a5886db4cd3638.68.llvm.11038256780392951182>
  5af7d6:	be 22 00 00 00       	mov    $0x22,%esi
  5af7db:	ff 15 d7 a9 53 00    	call   *0x53a9d7(%rip)        # aea1b8 <_DYNAMIC+0x458>
  5af7e1:	e9 60 04 00 00       	jmp    5afc46 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5bf6>
  5af7e6:	41 b7 01             	mov    $0x1,%r15b
  5af7e9:	48 8d 3d 06 bb ac ff 	lea    -0x5344fa(%rip),%rdi        # 7b2f6 <anon.2a25786c1a741fd89e690b6b2ddad436.25.llvm.18021777786862421399>
  5af7f0:	48 8d 15 71 91 50 00 	lea    0x509171(%rip),%rdx        # ab8968 <anon.2a25786c1a741fd89e690b6b2ddad436.26.llvm.18021777786862421399>
  5af7f7:	be 55 00 00 00       	mov    $0x55,%esi
  5af7fc:	40 b5 01             	mov    $0x1,%bpl
  5af7ff:	48 8b 5c 24 70       	mov    0x70(%rsp),%rbx
  5af804:	ff 15 d6 a7 53 00    	call   *0x53a7d6(%rip)        # ae9fe0 <_DYNAMIC+0x280>
  5af80a:	e9 37 04 00 00       	jmp    5afc46 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5bf6>
  5af80f:	31 ed                	xor    %ebp,%ebp
  5af811:	48 8d 3d f0 c2 ac ff 	lea    -0x533d10(%rip),%rdi        # 7bb08 <anon.5f884de6e78125e25881320d811d32df.113.llvm.17146438997930651657+0xd8>
  5af818:	48 8d 15 61 95 50 00 	lea    0x509561(%rip),%rdx        # ab8d80 <anon.2a25786c1a741fd89e690b6b2ddad436.63.llvm.18021777786862421399+0x148>
  5af81f:	be 37 00 00 00       	mov    $0x37,%esi
  5af824:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
  5af829:	48 89 44 24 30       	mov    %rax,0x30(%rsp)
  5af82e:	48 89 5c 24 40       	mov    %rbx,0x40(%rsp)
  5af833:	48 8b 5c 24 70       	mov    0x70(%rsp),%rbx
  5af838:	44 8b 7c 24 18       	mov    0x18(%rsp),%r15d
  5af83d:	ff 15 75 a9 53 00    	call   *0x53a975(%rip)        # aea1b8 <_DYNAMIC+0x458>
  5af843:	e9 fe 03 00 00       	jmp    5afc46 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5bf6>
  5af848:	48 8d 3d a7 ba ac ff 	lea    -0x534559(%rip),%rdi        # 7b2f6 <anon.2a25786c1a741fd89e690b6b2ddad436.25.llvm.18021777786862421399>
  5af84f:	48 8d 15 12 91 50 00 	lea    0x509112(%rip),%rdx        # ab8968 <anon.2a25786c1a741fd89e690b6b2ddad436.26.llvm.18021777786862421399>
  5af856:	be 55 00 00 00       	mov    $0x55,%esi
  5af85b:	ff 15 7f a7 53 00    	call   *0x53a77f(%rip)        # ae9fe0 <_DYNAMIC+0x280>
  5af861:	e9 e0 03 00 00       	jmp    5afc46 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5bf6>
  5af866:	be 51 00 00 00       	mov    $0x51,%esi
  5af86b:	48 8d 3d 1e c2 ac ff 	lea    -0x533de2(%rip),%rdi        # 7ba90 <anon.5f884de6e78125e25881320d811d32df.113.llvm.17146438997930651657+0x60>
  5af872:	48 8d 15 d7 94 50 00 	lea    0x5094d7(%rip),%rdx        # ab8d50 <anon.2a25786c1a741fd89e690b6b2ddad436.63.llvm.18021777786862421399+0x118>
  5af879:	31 ed                	xor    %ebp,%ebp
  5af87b:	ff 15 5f a7 53 00    	call   *0x53a75f(%rip)        # ae9fe0 <_DYNAMIC+0x280>
  5af881:	e9 c0 03 00 00       	jmp    5afc46 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5bf6>
  5af886:	48 8d 3d 32 fc ac ff 	lea    -0x5303ce(%rip),%rdi        # 7f4bf <anon.45400ae144863d14b1a5886db4cd3638.66.llvm.11038256780392951182>
  5af88d:	48 8d 15 4c 10 51 00 	lea    0x51104c(%rip),%rdx        # ac08e0 <anon.45400ae144863d14b1a5886db4cd3638.68.llvm.11038256780392951182>
  5af894:	be 22 00 00 00       	mov    $0x22,%esi
  5af899:	ff 15 19 a9 53 00    	call   *0x53a919(%rip)        # aea1b8 <_DYNAMIC+0x458>
  5af89f:	e9 a2 03 00 00       	jmp    5afc46 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5bf6>
  5af8a4:	48 8d 3d 0d c2 ac ff 	lea    -0x533df3(%rip),%rdi        # 7bab8 <anon.5f884de6e78125e25881320d811d32df.113.llvm.17146438997930651657+0x88>
  5af8ab:	48 8d 15 b6 94 50 00 	lea    0x5094b6(%rip),%rdx        # ab8d68 <anon.2a25786c1a741fd89e690b6b2ddad436.63.llvm.18021777786862421399+0x130>
  5af8b2:	be a1 00 00 00       	mov    $0xa1,%esi
  5af8b7:	ff 15 23 a7 53 00    	call   *0x53a723(%rip)        # ae9fe0 <_DYNAMIC+0x280>
  5af8bd:	e9 84 03 00 00       	jmp    5afc46 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5bf6>
  5af8c2:	be a1 00 00 00       	mov    $0xa1,%esi
  5af8c7:	48 8d 15 9a 94 50 00 	lea    0x50949a(%rip),%rdx        # ab8d68 <anon.2a25786c1a741fd89e690b6b2ddad436.63.llvm.18021777786862421399+0x130>
  5af8ce:	48 8d 3d e3 c1 ac ff 	lea    -0x533e1d(%rip),%rdi        # 7bab8 <anon.5f884de6e78125e25881320d811d32df.113.llvm.17146438997930651657+0x88>
  5af8d5:	eb a2                	jmp    5af879 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5829>
  5af8d7:	48 8d 3d fa 92 50 00 	lea    0x5092fa(%rip),%rdi        # ab8bd8 <anon.2a25786c1a741fd89e690b6b2ddad436.26.llvm.18021777786862421399+0x270>
  5af8de:	ff 15 34 a7 53 00    	call   *0x53a734(%rip)        # aea018 <_DYNAMIC+0x2b8>
  5af8e4:	e9 5d 03 00 00       	jmp    5afc46 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5bf6>
  5af8e9:	48 8d 3d f0 90 50 00 	lea    0x5090f0(%rip),%rdi        # ab89e0 <anon.2a25786c1a741fd89e690b6b2ddad436.26.llvm.18021777786862421399+0x78>
  5af8f0:	ff 15 22 a7 53 00    	call   *0x53a722(%rip)        # aea018 <_DYNAMIC+0x2b8>
  5af8f6:	e9 4b 03 00 00       	jmp    5afc46 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5bf6>
  5af8fb:	48 83 fe 15          	cmp    $0x15,%rsi
  5af8ff:	0f 83 43 03 00 00    	jae    5afc48 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5bf8>
  5af905:	48 8d 8c 24 a0 00 00 	lea    0xa0(%rsp),%rcx
  5af90c:	00 
  5af90d:	ba 01 00 00 00       	mov    $0x1,%edx
  5af912:	e8 d9 31 0b 00       	call   662af0 <_RINvNtNtNtNtCs4NRVxsYgnAr_4core5slice4sort6shared9smallsort25insertion_sort_shift_leftNtNtNtCs6gaF1xUz9Bf_4gpui7runtime8metadata8DeclaredNCINvMB8_SB1m_20sort_unstable_by_keyyNCNvMsq_B1q_INtB1q_7RuntimeINtNtNtB1q_8delivery5tests5FaultKh0_EE14describe_innersy_0E0EB1s_>
  5af917:	48 8b 5c 24 10       	mov    0x10(%rsp),%rbx
  5af91c:	e9 9f ef ff ff       	jmp    5ae8c0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4870>
  5af921:	48 8b 84 24 f8 01 00 	mov    0x1f8(%rsp),%rax
  5af928:	00 
  5af929:	48 89 84 24 b8 03 00 	mov    %rax,0x3b8(%rsp)
  5af930:	00 
  5af931:	48 8d 15 58 96 50 00 	lea    0x509658(%rip),%rdx        # ab8f90 <anon.2a25786c1a741fd89e690b6b2ddad436.91.llvm.18021777786862421399+0x198>
  5af938:	ff 15 9a a6 53 00    	call   *0x53a69a(%rip)        # ae9fd8 <_DYNAMIC+0x278>
  5af93e:	e9 03 03 00 00       	jmp    5afc46 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5bf6>
  5af943:	bf 08 00 00 00       	mov    $0x8,%edi
  5af948:	be f0 00 00 00       	mov    $0xf0,%esi
  5af94d:	ff 15 d5 a6 53 00    	call   *0x53a6d5(%rip)        # aea028 <_DYNAMIC+0x2c8>
  5af953:	e9 ee 02 00 00       	jmp    5afc46 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5bf6>
  5af958:	48 8d 15 e9 95 50 00 	lea    0x5095e9(%rip),%rdx        # ab8f48 <anon.2a25786c1a741fd89e690b6b2ddad436.91.llvm.18021777786862421399+0x150>
  5af95f:	be 02 00 00 00       	mov    $0x2,%esi
  5af964:	48 89 df             	mov    %rbx,%rdi
  5af967:	ff 15 6b a6 53 00    	call   *0x53a66b(%rip)        # ae9fd8 <_DYNAMIC+0x278>
  5af96d:	e9 d4 02 00 00       	jmp    5afc46 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5bf6>
  5af972:	48 8d 15 e7 91 50 00 	lea    0x5091e7(%rip),%rdx        # ab8b60 <anon.2a25786c1a741fd89e690b6b2ddad436.26.llvm.18021777786862421399+0x1f8>
  5af979:	48 8b b4 24 30 04 00 	mov    0x430(%rsp),%rsi
  5af980:	00 
  5af981:	ff 15 51 a6 53 00    	call   *0x53a651(%rip)        # ae9fd8 <_DYNAMIC+0x278>
  5af987:	e9 ba 02 00 00       	jmp    5afc46 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5bf6>
  5af98c:	48 85 ff             	test   %rdi,%rdi
  5af98f:	75 6b                	jne    5af9fc <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x59ac>
  5af991:	ff 15 89 a6 53 00    	call   *0x53a689(%rip)        # aea020 <_DYNAMIC+0x2c0>
  5af997:	e9 aa 02 00 00       	jmp    5afc46 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5bf6>
  5af99c:	48 8b 84 24 f8 01 00 	mov    0x1f8(%rsp),%rax
  5af9a3:	00 
  5af9a4:	48 89 84 24 b8 03 00 	mov    %rax,0x3b8(%rsp)
  5af9ab:	00 
  5af9ac:	48 8d 15 c5 95 50 00 	lea    0x5095c5(%rip),%rdx        # ab8f78 <anon.2a25786c1a741fd89e690b6b2ddad436.91.llvm.18021777786862421399+0x180>
  5af9b3:	48 8b bc 24 80 02 00 	mov    0x280(%rsp),%rdi
  5af9ba:	00 
  5af9bb:	48 8b b4 24 60 02 00 	mov    0x260(%rsp),%rsi
  5af9c2:	00 
  5af9c3:	ff 15 0f a6 53 00    	call   *0x53a60f(%rip)        # ae9fd8 <_DYNAMIC+0x278>
  5af9c9:	e9 78 02 00 00       	jmp    5afc46 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5bf6>
  5af9ce:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
  5af9d3:	48 8b b4 24 88 05 00 	mov    0x588(%rsp),%rsi
  5af9da:	00 
  5af9db:	48 8d 05 c6 95 50 00 	lea    0x5095c6(%rip),%rax        # ab8fa8 <anon.2a25786c1a741fd89e690b6b2ddad436.91.llvm.18021777786862421399+0x1b0>
  5af9e2:	e9 b6 00 00 00       	jmp    5afa9d <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5a4d>
  5af9e7:	48 8d 15 ea 95 50 00 	lea    0x5095ea(%rip),%rdx        # ab8fd8 <anon.2a25786c1a741fd89e690b6b2ddad436.91.llvm.18021777786862421399+0x1e0>
  5af9ee:	4c 89 f7             	mov    %r14,%rdi
  5af9f1:	ff 15 e1 a5 53 00    	call   *0x53a5e1(%rip)        # ae9fd8 <_DYNAMIC+0x278>
  5af9f7:	e9 4a 02 00 00       	jmp    5afc46 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5bf6>
  5af9fc:	48 8b b4 24 98 01 00 	mov    0x198(%rsp),%rsi
  5afa03:	00 
  5afa04:	ff 15 1e a6 53 00    	call   *0x53a61e(%rip)        # aea028 <_DYNAMIC+0x2c8>
  5afa0a:	e9 37 02 00 00       	jmp    5afc46 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5bf6>
  5afa0f:	48 8d 15 da 91 50 00 	lea    0x5091da(%rip),%rdx        # ab8bf0 <anon.2a25786c1a741fd89e690b6b2ddad436.26.llvm.18021777786862421399+0x288>
  5afa16:	48 8b bc 24 00 02 00 	mov    0x200(%rsp),%rdi
  5afa1d:	00 
  5afa1e:	ff 15 b4 a5 53 00    	call   *0x53a5b4(%rip)        # ae9fd8 <_DYNAMIC+0x278>
  5afa24:	e9 1d 02 00 00       	jmp    5afc46 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5bf6>
  5afa29:	48 8d 15 08 93 50 00 	lea    0x509308(%rip),%rdx        # ab8d38 <anon.2a25786c1a741fd89e690b6b2ddad436.63.llvm.18021777786862421399+0x100>
  5afa30:	ff 15 a2 a5 53 00    	call   *0x53a5a2(%rip)        # ae9fd8 <_DYNAMIC+0x278>
  5afa36:	e9 0b 02 00 00       	jmp    5afc46 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5bf6>
  5afa3b:	48 89 c3             	mov    %rax,%rbx
  5afa3e:	4c 8b bc 24 88 05 00 	mov    0x588(%rsp),%r15
  5afa45:	00 
  5afa46:	48 8d 05 d3 95 50 00 	lea    0x5095d3(%rip),%rax        # ab9020 <anon.2a25786c1a741fd89e690b6b2ddad436.91.llvm.18021777786862421399+0x228>
  5afa4d:	e9 c7 00 00 00       	jmp    5afb19 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5ac9>
  5afa52:	48 8d 15 97 95 50 00 	lea    0x509597(%rip),%rdx        # ab8ff0 <anon.2a25786c1a741fd89e690b6b2ddad436.91.llvm.18021777786862421399+0x1f8>
  5afa59:	4c 89 f7             	mov    %r14,%rdi
  5afa5c:	ff 15 76 a5 53 00    	call   *0x53a576(%rip)        # ae9fd8 <_DYNAMIC+0x278>
  5afa62:	e9 df 01 00 00       	jmp    5afc46 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5bf6>
  5afa67:	bf 08 00 00 00       	mov    $0x8,%edi
  5afa6c:	48 8b b4 24 c8 04 00 	mov    0x4c8(%rsp),%rsi
  5afa73:	00 
  5afa74:	ff 15 2e a6 53 00    	call   *0x53a62e(%rip)        # aea0a8 <_DYNAMIC+0x348>
  5afa7a:	e9 c7 01 00 00       	jmp    5afc46 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5bf6>
  5afa7f:	48 8d 15 aa 94 50 00 	lea    0x5094aa(%rip),%rdx        # ab8f30 <anon.2a25786c1a741fd89e690b6b2ddad436.91.llvm.18021777786862421399+0x138>
  5afa86:	ff 15 4c a5 53 00    	call   *0x53a54c(%rip)        # ae9fd8 <_DYNAMIC+0x278>
  5afa8c:	e9 b5 01 00 00       	jmp    5afc46 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5bf6>
  5afa91:	48 89 4c 24 18       	mov    %rcx,0x18(%rsp)
  5afa96:	48 8d 05 0b 91 50 00 	lea    0x50910b(%rip),%rax        # ab8ba8 <anon.2a25786c1a741fd89e690b6b2ddad436.26.llvm.18021777786862421399+0x240>
  5afa9d:	48 89 84 24 c0 04 00 	mov    %rax,0x4c0(%rsp)
  5afaa4:	00 
  5afaa5:	48 8b 7c 24 18       	mov    0x18(%rsp),%rdi
  5afaaa:	48 8b 94 24 c0 04 00 	mov    0x4c0(%rsp),%rdx
  5afab1:	00 
  5afab2:	ff 15 20 a5 53 00    	call   *0x53a520(%rip)        # ae9fd8 <_DYNAMIC+0x278>
  5afab8:	e9 89 01 00 00       	jmp    5afc46 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5bf6>
  5afabd:	b0 01                	mov    $0x1,%al
  5afabf:	89 44 24 18          	mov    %eax,0x18(%rsp)
  5afac3:	48 8d 15 3e 91 50 00 	lea    0x50913e(%rip),%rdx        # ab8c08 <anon.2a25786c1a741fd89e690b6b2ddad436.26.llvm.18021777786862421399+0x2a0>
  5afaca:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
  5afacf:	48 89 44 24 38       	mov    %rax,0x38(%rsp)
  5afad4:	48 8b 5c 24 40       	mov    0x40(%rsp),%rbx
  5afad9:	40 b5 01             	mov    $0x1,%bpl
  5afadc:	4c 89 f7             	mov    %r14,%rdi
  5afadf:	ff 15 f3 a4 53 00    	call   *0x53a4f3(%rip)        # ae9fd8 <_DYNAMIC+0x278>
  5afae5:	e9 5c 01 00 00       	jmp    5afc46 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5bf6>
  5afaea:	bf 08 00 00 00       	mov    $0x8,%edi
  5afaef:	48 89 de             	mov    %rbx,%rsi
  5afaf2:	ff 15 b0 a5 53 00    	call   *0x53a5b0(%rip)        # aea0a8 <_DYNAMIC+0x348>
  5afaf8:	e9 49 01 00 00       	jmp    5afc46 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5bf6>
  5afafd:	bf 08 00 00 00       	mov    $0x8,%edi
  5afb02:	48 8b 74 24 38       	mov    0x38(%rsp),%rsi
  5afb07:	ff 15 9b a5 53 00    	call   *0x53a59b(%rip)        # aea0a8 <_DYNAMIC+0x348>
  5afb0d:	e9 34 01 00 00       	jmp    5afc46 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5bf6>
  5afb12:	48 8d 05 2f 90 50 00 	lea    0x50902f(%rip),%rax        # ab8b48 <anon.2a25786c1a741fd89e690b6b2ddad436.26.llvm.18021777786862421399+0x1e0>
  5afb19:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
  5afb1e:	48 89 df             	mov    %rbx,%rdi
  5afb21:	4c 89 fe             	mov    %r15,%rsi
  5afb24:	48 8b 54 24 18       	mov    0x18(%rsp),%rdx
  5afb29:	ff 15 a9 a4 53 00    	call   *0x53a4a9(%rip)        # ae9fd8 <_DYNAMIC+0x278>
  5afb2f:	e9 12 01 00 00       	jmp    5afc46 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5bf6>
  5afb34:	48 8d 15 25 94 50 00 	lea    0x509425(%rip),%rdx        # ab8f60 <anon.2a25786c1a741fd89e690b6b2ddad436.91.llvm.18021777786862421399+0x168>
  5afb3b:	be 02 00 00 00       	mov    $0x2,%esi
  5afb40:	48 89 df             	mov    %rbx,%rdi
  5afb43:	ff 15 8f a4 53 00    	call   *0x53a48f(%rip)        # ae9fd8 <_DYNAMIC+0x278>
  5afb49:	e9 f8 00 00 00       	jmp    5afc46 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5bf6>
  5afb4e:	48 8d 15 6b 90 50 00 	lea    0x50906b(%rip),%rdx        # ab8bc0 <anon.2a25786c1a741fd89e690b6b2ddad436.26.llvm.18021777786862421399+0x258>
  5afb55:	4c 89 f7             	mov    %r14,%rdi
  5afb58:	ff 15 7a a4 53 00    	call   *0x53a47a(%rip)        # ae9fd8 <_DYNAMIC+0x278>
  5afb5e:	e9 e3 00 00 00       	jmp    5afc46 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5bf6>
  5afb63:	48 85 ff             	test   %rdi,%rdi
  5afb66:	75 7e                	jne    5afbe6 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5b96>
  5afb68:	b0 01                	mov    $0x1,%al
  5afb6a:	89 44 24 18          	mov    %eax,0x18(%rsp)
  5afb6e:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
  5afb73:	48 89 44 24 38       	mov    %rax,0x38(%rsp)
  5afb78:	48 8b 5c 24 40       	mov    0x40(%rsp),%rbx
  5afb7d:	40 b5 01             	mov    $0x1,%bpl
  5afb80:	ff 15 9a a4 53 00    	call   *0x53a49a(%rip)        # aea020 <_DYNAMIC+0x2c0>
  5afb86:	e9 bb 00 00 00       	jmp    5afc46 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5bf6>
  5afb8b:	bf 08 00 00 00       	mov    $0x8,%edi
  5afb90:	48 89 de             	mov    %rbx,%rsi
  5afb93:	ff 15 0f a5 53 00    	call   *0x53a50f(%rip)        # aea0a8 <_DYNAMIC+0x348>
  5afb99:	e9 a8 00 00 00       	jmp    5afc46 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5bf6>
  5afb9e:	bf 04 00 00 00       	mov    $0x4,%edi
  5afba3:	48 89 de             	mov    %rbx,%rsi
  5afba6:	ff 15 fc a4 53 00    	call   *0x53a4fc(%rip)        # aea0a8 <_DYNAMIC+0x348>
  5afbac:	e9 95 00 00 00       	jmp    5afc46 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5bf6>
  5afbb1:	48 8d 15 b8 8e 50 00 	lea    0x508eb8(%rip),%rdx        # ab8a70 <anon.2a25786c1a741fd89e690b6b2ddad436.26.llvm.18021777786862421399+0x108>
  5afbb8:	48 89 c7             	mov    %rax,%rdi
  5afbbb:	ff 15 17 a4 53 00    	call   *0x53a417(%rip)        # ae9fd8 <_DYNAMIC+0x278>
  5afbc1:	e9 80 00 00 00       	jmp    5afc46 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5bf6>
  5afbc6:	bf 08 00 00 00       	mov    $0x8,%edi
  5afbcb:	48 89 de             	mov    %rbx,%rsi
  5afbce:	ff 15 d4 a4 53 00    	call   *0x53a4d4(%rip)        # aea0a8 <_DYNAMIC+0x348>
  5afbd4:	eb 70                	jmp    5afc46 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5bf6>
  5afbd6:	bf 08 00 00 00       	mov    $0x8,%edi
  5afbdb:	48 89 de             	mov    %rbx,%rsi
  5afbde:	ff 15 c4 a4 53 00    	call   *0x53a4c4(%rip)        # aea0a8 <_DYNAMIC+0x348>
  5afbe4:	eb 60                	jmp    5afc46 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5bf6>
  5afbe6:	48 8b b4 24 08 03 00 	mov    0x308(%rsp),%rsi
  5afbed:	00 
  5afbee:	b0 01                	mov    $0x1,%al
  5afbf0:	89 44 24 18          	mov    %eax,0x18(%rsp)
  5afbf4:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
  5afbf9:	48 89 44 24 38       	mov    %rax,0x38(%rsp)
  5afbfe:	48 8b 5c 24 40       	mov    0x40(%rsp),%rbx
  5afc03:	40 b5 01             	mov    $0x1,%bpl
  5afc06:	ff 15 1c a4 53 00    	call   *0x53a41c(%rip)        # aea028 <_DYNAMIC+0x2c8>
  5afc0c:	eb 38                	jmp    5afc46 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5bf6>
  5afc0e:	48 8d 0d 93 90 50 00 	lea    0x509093(%rip),%rcx        # ab8ca8 <anon.2a25786c1a741fd89e690b6b2ddad436.63.llvm.18021777786862421399+0x70>
  5afc15:	eb 07                	jmp    5afc1e <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5bce>
  5afc17:	48 8d 0d ba 90 50 00 	lea    0x5090ba(%rip),%rcx        # ab8cd8 <anon.2a25786c1a741fd89e690b6b2ddad436.63.llvm.18021777786862421399+0xa0>
  5afc1e:	48 89 8c 24 b8 04 00 	mov    %rcx,0x4b8(%rsp)
  5afc25:	00 
  5afc26:	48 89 c7             	mov    %rax,%rdi
  5afc29:	48 8b 94 24 b8 04 00 	mov    0x4b8(%rsp),%rdx
  5afc30:	00 
  5afc31:	ff 15 a1 a3 53 00    	call   *0x53a3a1(%rip)        # ae9fd8 <_DYNAMIC+0x278>
  5afc37:	eb 0d                	jmp    5afc46 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5bf6>
  5afc39:	48 8d 15 10 8d 50 00 	lea    0x508d10(%rip),%rdx        # ab8950 <__frame_dummy_init_array_entry+0x200>
  5afc40:	ff 15 92 a3 53 00    	call   *0x53a392(%rip)        # ae9fd8 <_DYNAMIC+0x278>
  5afc46:	0f 0b                	ud2
  5afc48:	48 8d 94 24 a0 00 00 	lea    0xa0(%rsp),%rdx
  5afc4f:	00 
  5afc50:	e8 cb 37 14 00       	call   6f3420 <_RINvNtNtNtCs4NRVxsYgnAr_4core5slice4sort8unstable7ipnsortNtNtNtCs6gaF1xUz9Bf_4gpui7runtime8metadata8DeclaredNCINvMB6_SBT_20sort_unstable_by_keyyNCNvMsq_BX_INtBX_7RuntimeNtNtBX_12style_ledger9AdversaryE14describe_innersy_0E0EBZ_>
  5afc55:	48 8b 5c 24 10       	mov    0x10(%rsp),%rbx
  5afc5a:	e9 61 ec ff ff       	jmp    5ae8c0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x4870>
  5afc5f:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  5afc64:	e9 08 08 00 00       	jmp    5b0471 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x6421>
  5afc69:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  5afc6e:	b0 01                	mov    $0x1,%al
  5afc70:	89 44 24 20          	mov    %eax,0x20(%rsp)
  5afc74:	41 b5 01             	mov    $0x1,%r13b
  5afc77:	41 b6 01             	mov    $0x1,%r14b
  5afc7a:	b0 01                	mov    $0x1,%al
  5afc7c:	89 44 24 10          	mov    %eax,0x10(%rsp)
  5afc80:	41 b7 01             	mov    $0x1,%r15b
  5afc83:	e9 55 0c 00 00       	jmp    5b08dd <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x688d>
  5afc88:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  5afc8d:	4c 89 e7             	mov    %r12,%rdi
  5afc90:	4c 89 fe             	mov    %r15,%rsi
  5afc93:	e8 98 58 f8 ff       	call   535530 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtCs6gaF1xUz9Bf_4gpui8property12ContributionINtNtB4_6option6OptionNtNtBG_11shared_text10SharedTextEEEBG_>
  5afc98:	e9 4a 06 00 00       	jmp    5b02e7 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x6297>
  5afc9d:	ff 15 25 a3 53 00    	call   *0x53a325(%rip)        # ae9fc8 <_DYNAMIC+0x268>
  5afca3:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  5afca8:	48 8d bc 24 b0 03 00 	lea    0x3b0(%rsp),%rdi
  5afcaf:	00 
  5afcb0:	e8 eb 99 f7 ff       	call   5296a0 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtB4_6option6OptionNtNtCs6gaF1xUz9Bf_4gpui7runtime6ShapedEEB11_.llvm.18021777786862421399>
  5afcb5:	e9 23 05 00 00       	jmp    5b01dd <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x618d>
  5afcba:	ff 15 08 a3 53 00    	call   *0x53a308(%rip)        # ae9fc8 <_DYNAMIC+0x268>
  5afcc0:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  5afcc5:	48 89 ac dc 70 05 00 	mov    %rbp,0x570(%rsp,%rbx,8)
  5afccc:	00 
  5afccd:	e9 23 07 00 00       	jmp    5b03f5 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x63a5>
  5afcd2:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  5afcd7:	e9 fe 07 00 00       	jmp    5b04da <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x648a>
  5afcdc:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  5afce1:	48 8b 44 24 58       	mov    0x58(%rsp),%rax
  5afce6:	48 8b 70 08          	mov    0x8(%rax),%rsi
  5afcea:	40 b5 01             	mov    $0x1,%bpl
  5afced:	48 85 f6             	test   %rsi,%rsi
  5afcf0:	0f 84 69 0a 00 00    	je     5b075f <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x670f>
  5afcf6:	48 8b 44 24 58       	mov    0x58(%rsp),%rax
  5afcfb:	48 8b 50 10          	mov    0x10(%rax),%rdx
  5afcff:	4c 89 ff             	mov    %r15,%rdi
  5afd02:	ff 15 a0 a2 53 00    	call   *0x53a2a0(%rip)        # ae9fa8 <_DYNAMIC+0x248>
  5afd08:	e9 52 0a 00 00       	jmp    5b075f <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x670f>
  5afd0d:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  5afd12:	41 b7 01             	mov    $0x1,%r15b
  5afd15:	b0 01                	mov    $0x1,%al
  5afd17:	89 44 24 10          	mov    %eax,0x10(%rsp)
  5afd1b:	41 b6 01             	mov    $0x1,%r14b
  5afd1e:	41 b4 01             	mov    $0x1,%r12b
  5afd21:	b0 01                	mov    $0x1,%al
  5afd23:	89 44 24 20          	mov    %eax,0x20(%rsp)
  5afd27:	e9 d2 0a 00 00       	jmp    5b07fe <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x67ae>
  5afd2c:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  5afd31:	4c 89 ef             	mov    %r13,%rdi
  5afd34:	e8 57 7a f8 ff       	call   537790 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueNtNtCs6gaF1xUz9Bf_4gpui11shared_text10SharedTextEBF_>
  5afd39:	e9 54 07 00 00       	jmp    5b0492 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x6442>
  5afd3e:	ff 15 84 a2 53 00    	call   *0x53a284(%rip)        # ae9fc8 <_DYNAMIC+0x268>
  5afd44:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  5afd49:	48 8b 83 10 08 00 00 	mov    0x810(%rbx),%rax
  5afd50:	48 8b 8c 24 b0 00 00 	mov    0xb0(%rsp),%rcx
  5afd57:	00 
  5afd58:	48 89 48 10          	mov    %rcx,0x10(%rax)
  5afd5c:	0f 28 84 24 a0 00 00 	movaps 0xa0(%rsp),%xmm0
  5afd63:	00 
  5afd64:	0f 11 00             	movups %xmm0,(%rax)
  5afd67:	e9 12 07 00 00       	jmp    5b047e <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x642e>
  5afd6c:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  5afd71:	41 b7 01             	mov    $0x1,%r15b
  5afd74:	b0 01                	mov    $0x1,%al
  5afd76:	89 44 24 10          	mov    %eax,0x10(%rsp)
  5afd7a:	41 b6 01             	mov    $0x1,%r14b
  5afd7d:	b0 01                	mov    $0x1,%al
  5afd7f:	89 44 24 20          	mov    %eax,0x20(%rsp)
  5afd83:	e9 8b 0a 00 00       	jmp    5b0813 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x67c3>
  5afd88:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  5afd8d:	b0 01                	mov    $0x1,%al
  5afd8f:	89 84 24 08 02 00 00 	mov    %eax,0x208(%rsp)
  5afd96:	b8 01 00 00 00       	mov    $0x1,%eax
  5afd9b:	48 89 84 24 28 04 00 	mov    %rax,0x428(%rsp)
  5afda2:	00 
  5afda3:	40 b5 01             	mov    $0x1,%bpl
  5afda6:	e9 83 09 00 00       	jmp    5b072e <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x66de>
  5afdab:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  5afdb0:	45 31 ed             	xor    %r13d,%r13d
  5afdb3:	45 31 f6             	xor    %r14d,%r14d
  5afdb6:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%rsp)
  5afdbd:	00 
  5afdbe:	45 31 ff             	xor    %r15d,%r15d
  5afdc1:	e9 24 0b 00 00       	jmp    5b08ea <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x689a>
  5afdc6:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  5afdcb:	48 8b 84 24 88 04 00 	mov    0x488(%rsp),%rax
  5afdd2:	00 
  5afdd3:	48 85 c0             	test   %rax,%rax
  5afdd6:	74 1b                	je     5afdf3 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5da3>
  5afdd8:	48 8b bc 24 90 04 00 	mov    0x490(%rsp),%rdi
  5afddf:	00 
  5afde0:	48 c1 e0 03          	shl    $0x3,%rax
  5afde4:	48 8d 34 80          	lea    (%rax,%rax,4),%rsi
  5afde8:	ba 08 00 00 00       	mov    $0x8,%edx
  5afded:	ff 15 b5 a1 53 00    	call   *0x53a1b5(%rip)        # ae9fa8 <_DYNAMIC+0x248>
  5afdf3:	45 31 ed             	xor    %r13d,%r13d
  5afdf6:	45 31 f6             	xor    %r14d,%r14d
  5afdf9:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%rsp)
  5afe00:	00 
  5afe01:	45 31 ff             	xor    %r15d,%r15d
  5afe04:	e9 c7 0a 00 00       	jmp    5b08d0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x6880>
  5afe09:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  5afe0e:	45 31 ed             	xor    %r13d,%r13d
  5afe11:	45 31 f6             	xor    %r14d,%r14d
  5afe14:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%rsp)
  5afe1b:	00 
  5afe1c:	45 31 ff             	xor    %r15d,%r15d
  5afe1f:	e9 9f 0a 00 00       	jmp    5b08c3 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x6873>
  5afe24:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  5afe29:	45 31 ed             	xor    %r13d,%r13d
  5afe2c:	45 31 f6             	xor    %r14d,%r14d
  5afe2f:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%rsp)
  5afe36:	00 
  5afe37:	45 31 ff             	xor    %r15d,%r15d
  5afe3a:	e9 77 0a 00 00       	jmp    5b08b6 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x6866>
  5afe3f:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  5afe44:	45 31 ed             	xor    %r13d,%r13d
  5afe47:	45 31 f6             	xor    %r14d,%r14d
  5afe4a:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%rsp)
  5afe51:	00 
  5afe52:	45 31 ff             	xor    %r15d,%r15d
  5afe55:	e9 4f 0a 00 00       	jmp    5b08a9 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x6859>
  5afe5a:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  5afe5f:	45 31 ed             	xor    %r13d,%r13d
  5afe62:	45 31 f6             	xor    %r14d,%r14d
  5afe65:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%rsp)
  5afe6c:	00 
  5afe6d:	45 31 ff             	xor    %r15d,%r15d
  5afe70:	e9 1a 0a 00 00       	jmp    5b088f <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x683f>
  5afe75:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  5afe7a:	48 8b 84 24 10 03 00 	mov    0x310(%rsp),%rax
  5afe81:	00 
  5afe82:	48 89 43 10          	mov    %rax,0x10(%rbx)
  5afe86:	0f 10 84 24 00 03 00 	movups 0x300(%rsp),%xmm0
  5afe8d:	00 
  5afe8e:	0f 11 03             	movups %xmm0,(%rbx)
  5afe91:	e9 51 04 00 00       	jmp    5b02e7 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x6297>
  5afe96:	e9 2f 04 00 00       	jmp    5b02ca <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x627a>
  5afe9b:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  5afea0:	48 8b 03             	mov    (%rbx),%rax
  5afea3:	48 85 c0             	test   %rax,%rax
  5afea6:	74 1f                	je     5afec7 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5e77>
  5afea8:	48 8b 4c 24 10       	mov    0x10(%rsp),%rcx
  5afead:	48 8b b9 d8 02 00 00 	mov    0x2d8(%rcx),%rdi
  5afeb4:	48 c1 e0 04          	shl    $0x4,%rax
  5afeb8:	48 8d 34 80          	lea    (%rax,%rax,4),%rsi
  5afebc:	ba 08 00 00 00       	mov    $0x8,%edx
  5afec1:	ff 15 e1 a0 53 00    	call   *0x53a0e1(%rip)        # ae9fa8 <_DYNAMIC+0x248>
  5afec7:	48 8b 84 24 b0 00 00 	mov    0xb0(%rsp),%rax
  5afece:	00 
  5afecf:	48 89 43 10          	mov    %rax,0x10(%rbx)
  5afed3:	0f 28 84 24 a0 00 00 	movaps 0xa0(%rsp),%xmm0
  5afeda:	00 
  5afedb:	0f 11 03             	movups %xmm0,(%rbx)
  5afede:	41 b5 01             	mov    $0x1,%r13b
  5afee1:	e9 04 04 00 00       	jmp    5b02ea <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x629a>
  5afee6:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  5afeeb:	ba 04 00 00 00       	mov    $0x4,%edx
  5afef0:	48 8b bc 24 48 02 00 	mov    0x248(%rsp),%rdi
  5afef7:	00 
  5afef8:	48 8b b4 24 d0 02 00 	mov    0x2d0(%rsp),%rsi
  5afeff:	00 
  5aff00:	ff 15 a2 a0 53 00    	call   *0x53a0a2(%rip)        # ae9fa8 <_DYNAMIC+0x248>
  5aff06:	45 31 ff             	xor    %r15d,%r15d
  5aff09:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%rsp)
  5aff10:	00 
  5aff11:	45 31 f6             	xor    %r14d,%r14d
  5aff14:	45 31 e4             	xor    %r12d,%r12d
  5aff17:	31 ed                	xor    %ebp,%ebp
  5aff19:	e9 ce 08 00 00       	jmp    5b07ec <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x679c>
  5aff1e:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  5aff23:	48 8b 03             	mov    (%rbx),%rax
  5aff26:	48 85 c0             	test   %rax,%rax
  5aff29:	74 1f                	je     5aff4a <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x5efa>
  5aff2b:	48 8b 4c 24 10       	mov    0x10(%rsp),%rcx
  5aff30:	48 8b b9 c0 02 00 00 	mov    0x2c0(%rcx),%rdi
  5aff37:	48 c1 e0 03          	shl    $0x3,%rax
  5aff3b:	48 8d 34 80          	lea    (%rax,%rax,4),%rsi
  5aff3f:	ba 08 00 00 00       	mov    $0x8,%edx
  5aff44:	ff 15 5e a0 53 00    	call   *0x53a05e(%rip)        # ae9fa8 <_DYNAMIC+0x248>
  5aff4a:	48 8b 84 24 b0 00 00 	mov    0xb0(%rsp),%rax
  5aff51:	00 
  5aff52:	48 89 43 10          	mov    %rax,0x10(%rbx)
  5aff56:	0f 28 84 24 a0 00 00 	movaps 0xa0(%rsp),%xmm0
  5aff5d:	00 
  5aff5e:	0f 11 03             	movups %xmm0,(%rbx)
  5aff61:	31 ed                	xor    %ebp,%ebp
  5aff63:	e9 a9 06 00 00       	jmp    5b0611 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x65c1>
  5aff68:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  5aff6d:	48 8b 84 24 b0 00 00 	mov    0xb0(%rsp),%rax
  5aff74:	00 
  5aff75:	49 89 46 10          	mov    %rax,0x10(%r14)
  5aff79:	0f 28 84 24 a0 00 00 	movaps 0xa0(%rsp),%xmm0
  5aff80:	00 
  5aff81:	41 0f 11 06          	movups %xmm0,(%r14)
  5aff85:	40 b5 01             	mov    $0x1,%bpl
  5aff88:	e9 84 06 00 00       	jmp    5b0611 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x65c1>
  5aff8d:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  5aff92:	48 8b 84 24 b0 00 00 	mov    0xb0(%rsp),%rax
  5aff99:	00 
  5aff9a:	48 89 43 10          	mov    %rax,0x10(%rbx)
  5aff9e:	0f 28 84 24 a0 00 00 	movaps 0xa0(%rsp),%xmm0
  5affa5:	00 
  5affa6:	0f 11 03             	movups %xmm0,(%rbx)
  5affa9:	31 db                	xor    %ebx,%ebx
  5affab:	e9 40 06 00 00       	jmp    5b05f0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x65a0>
  5affb0:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  5affb5:	41 b7 01             	mov    $0x1,%r15b
  5affb8:	b0 01                	mov    $0x1,%al
  5affba:	89 44 24 10          	mov    %eax,0x10(%rsp)
  5affbe:	41 b6 01             	mov    $0x1,%r14b
  5affc1:	41 b4 01             	mov    $0x1,%r12b
  5affc4:	40 b5 01             	mov    $0x1,%bpl
  5affc7:	b0 01                	mov    $0x1,%al
  5affc9:	89 44 24 20          	mov    %eax,0x20(%rsp)
  5affcd:	e9 1a 08 00 00       	jmp    5b07ec <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x679c>
  5affd2:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  5affd7:	b0 01                	mov    $0x1,%al
  5affd9:	89 44 24 20          	mov    %eax,0x20(%rsp)
  5affdd:	41 b5 01             	mov    $0x1,%r13b
  5affe0:	41 b6 01             	mov    $0x1,%r14b
  5affe3:	b0 01                	mov    $0x1,%al
  5affe5:	89 44 24 10          	mov    %eax,0x10(%rsp)
  5affe9:	41 b7 01             	mov    $0x1,%r15b
  5affec:	e9 df 08 00 00       	jmp    5b08d0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x6880>
  5afff1:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  5afff6:	66 0f 6f 44 24 20    	movdqa 0x20(%rsp),%xmm0
  5afffc:	66 48 0f 7e c7       	movq   %xmm0,%rdi
  5b0001:	66 0f 70 c0 ee       	pshufd $0xee,%xmm0,%xmm0
  5b0006:	66 48 0f 7e c6       	movq   %xmm0,%rsi
  5b000b:	e8 e0 89 f8 ff       	call   5389f0 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueNtNtNtCs6gaF1xUz9Bf_4gpui7runtime8metadata5NamesEBH_>
  5b0010:	e9 4f 04 00 00       	jmp    5b0464 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x6414>
  5b0015:	ff 15 ad 9f 53 00    	call   *0x539fad(%rip)        # ae9fc8 <_DYNAMIC+0x268>
  5b001b:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  5b0020:	4c 89 ff             	mov    %r15,%rdi
  5b0023:	48 8b 74 24 58       	mov    0x58(%rsp),%rsi
  5b0028:	e8 13 96 f7 ff       	call   529640 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtB4_6option6OptionNtNtCs6gaF1xUz9Bf_4gpui7element7HandlerEEB11_>
  5b002d:	e9 2a 07 00 00       	jmp    5b075c <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x670c>
  5b0032:	ff 15 90 9f 53 00    	call   *0x539f90(%rip)        # ae9fc8 <_DYNAMIC+0x268>
  5b0038:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  5b003d:	b0 01                	mov    $0x1,%al
  5b003f:	89 44 24 20          	mov    %eax,0x20(%rsp)
  5b0043:	b0 01                	mov    $0x1,%al
  5b0045:	89 44 24 10          	mov    %eax,0x10(%rsp)
  5b0049:	e9 7d 07 00 00       	jmp    5b07cb <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x677b>
  5b004e:	89 6c 24 20          	mov    %ebp,0x20(%rsp)
  5b0052:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  5b0057:	45 89 ee             	mov    %r13d,%r14d
  5b005a:	44 89 e8             	mov    %r13d,%eax
  5b005d:	89 44 24 10          	mov    %eax,0x10(%rsp)
  5b0061:	45 89 ef             	mov    %r13d,%r15d
  5b0064:	e9 33 08 00 00       	jmp    5b089c <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x684c>
  5b0069:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  5b006e:	48 89 ef             	mov    %rbp,%rdi
  5b0071:	e8 9a 95 f7 ff       	call   529610 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtB4_6option6OptionNtNtCs6gaF1xUz9Bf_4gpui11shared_text10SharedTextEEB11_>
  5b0076:	e9 7a 03 00 00       	jmp    5b03f5 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x63a5>
  5b007b:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  5b0080:	48 8d bc 24 00 03 00 	lea    0x300(%rsp),%rdi
  5b0087:	00 
  5b0088:	e8 e3 97 f7 ff       	call   529870 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtB4_6option6OptionNtNtCs6gaF1xUz9Bf_4gpui7runtime8TextSiteEEB11_>
  5b008d:	e9 b3 01 00 00       	jmp    5b0245 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x61f5>
  5b0092:	ff 15 30 9f 53 00    	call   *0x539f30(%rip)        # ae9fc8 <_DYNAMIC+0x268>
  5b0098:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  5b009d:	40 b5 01             	mov    $0x1,%bpl
  5b00a0:	41 b6 01             	mov    $0x1,%r14b
  5b00a3:	b0 01                	mov    $0x1,%al
  5b00a5:	89 44 24 10          	mov    %eax,0x10(%rsp)
  5b00a9:	41 b7 01             	mov    $0x1,%r15b
  5b00ac:	e9 d2 08 00 00       	jmp    5b0983 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x6933>
  5b00b1:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  5b00b6:	40 b5 01             	mov    $0x1,%bpl
  5b00b9:	41 b6 01             	mov    $0x1,%r14b
  5b00bc:	b0 01                	mov    $0x1,%al
  5b00be:	89 44 24 10          	mov    %eax,0x10(%rsp)
  5b00c2:	41 b7 01             	mov    $0x1,%r15b
  5b00c5:	e9 dd 08 00 00       	jmp    5b09a7 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x6957>
  5b00ca:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  5b00cf:	40 b5 01             	mov    $0x1,%bpl
  5b00d2:	41 b6 01             	mov    $0x1,%r14b
  5b00d5:	b0 01                	mov    $0x1,%al
  5b00d7:	89 44 24 10          	mov    %eax,0x10(%rsp)
  5b00db:	41 b7 01             	mov    $0x1,%r15b
  5b00de:	e9 e8 08 00 00       	jmp    5b09cb <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x697b>
  5b00e3:	e9 6f 06 00 00       	jmp    5b0757 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x6707>
  5b00e8:	e9 b8 03 00 00       	jmp    5b04a5 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x6455>
  5b00ed:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  5b00f2:	48 89 ef             	mov    %rbp,%rdi
  5b00f5:	e8 96 76 f8 ff       	call   537790 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueNtNtCs6gaF1xUz9Bf_4gpui11shared_text10SharedTextEBF_>
  5b00fa:	e9 f6 02 00 00       	jmp    5b03f5 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x63a5>
  5b00ff:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  5b0104:	49 83 ff ff          	cmp    $0xffffffffffffffff,%r15
  5b0108:	74 16                	je     5b0120 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x60d0>
  5b010a:	4d 85 ff             	test   %r15,%r15
  5b010d:	7e 11                	jle    5b0120 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x60d0>
  5b010f:	ba 01 00 00 00       	mov    $0x1,%edx
  5b0114:	48 89 ef             	mov    %rbp,%rdi
  5b0117:	4c 89 fe             	mov    %r15,%rsi
  5b011a:	ff 15 88 9e 53 00    	call   *0x539e88(%rip)        # ae9fa8 <_DYNAMIC+0x248>
  5b0120:	48 83 fb ff          	cmp    $0xffffffffffffffff,%rbx
  5b0124:	0f 84 3a 03 00 00    	je     5b0464 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x6414>
  5b012a:	48 85 db             	test   %rbx,%rbx
  5b012d:	0f 8e 31 03 00 00    	jle    5b0464 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x6414>
  5b0133:	ba 01 00 00 00       	mov    $0x1,%edx
  5b0138:	4c 89 f7             	mov    %r14,%rdi
  5b013b:	48 89 de             	mov    %rbx,%rsi
  5b013e:	ff 15 64 9e 53 00    	call   *0x539e64(%rip)        # ae9fa8 <_DYNAMIC+0x248>
  5b0144:	e9 1b 03 00 00       	jmp    5b0464 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x6414>
  5b0149:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  5b014e:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
  5b0153:	48 8b 70 08          	mov    0x8(%rax),%rsi
  5b0157:	48 85 f6             	test   %rsi,%rsi
  5b015a:	74 14                	je     5b0170 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x6120>
  5b015c:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
  5b0161:	48 8b 50 10          	mov    0x10(%rax),%rdx
  5b0165:	48 8b 7c 24 40       	mov    0x40(%rsp),%rdi
  5b016a:	ff 15 38 9e 53 00    	call   *0x539e38(%rip)        # ae9fa8 <_DYNAMIC+0x248>
  5b0170:	31 ed                	xor    %ebp,%ebp
  5b0172:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
  5b0177:	48 89 44 24 30       	mov    %rax,0x30(%rsp)
  5b017c:	48 89 5c 24 40       	mov    %rbx,0x40(%rsp)
  5b0181:	41 b6 01             	mov    $0x1,%r14b
  5b0184:	48 8b 5c 24 70       	mov    0x70(%rsp),%rbx
  5b0189:	41 b7 01             	mov    $0x1,%r15b
  5b018c:	e9 4c 05 00 00       	jmp    5b06dd <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x668d>
  5b0191:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  5b0196:	48 8b 84 24 f8 01 00 	mov    0x1f8(%rsp),%rax
  5b019d:	00 
  5b019e:	48 89 84 24 b8 03 00 	mov    %rax,0x3b8(%rsp)
  5b01a5:	00 
  5b01a6:	e9 c4 03 00 00       	jmp    5b056f <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x651f>
  5b01ab:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  5b01b0:	44 89 f0             	mov    %r14d,%eax
  5b01b3:	89 44 24 10          	mov    %eax,0x10(%rsp)
  5b01b7:	45 89 f7             	mov    %r14d,%r15d
  5b01ba:	e9 19 08 00 00       	jmp    5b09d8 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x6988>
  5b01bf:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  5b01c4:	40 b5 01             	mov    $0x1,%bpl
  5b01c7:	41 b6 01             	mov    $0x1,%r14b
  5b01ca:	b0 01                	mov    $0x1,%al
  5b01cc:	89 44 24 10          	mov    %eax,0x10(%rsp)
  5b01d0:	41 b7 01             	mov    $0x1,%r15b
  5b01d3:	e9 87 07 00 00       	jmp    5b095f <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x690f>
  5b01d8:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  5b01dd:	48 89 9c 24 b0 03 00 	mov    %rbx,0x3b0(%rsp)
  5b01e4:	00 
  5b01e5:	48 89 ac 24 f0 03 00 	mov    %rbp,0x3f0(%rsp)
  5b01ec:	00 
  5b01ed:	48 8b 84 24 90 05 00 	mov    0x590(%rsp),%rax
  5b01f4:	00 
  5b01f5:	48 89 84 24 f8 03 00 	mov    %rax,0x3f8(%rsp)
  5b01fc:	00 
  5b01fd:	e9 90 02 00 00       	jmp    5b0492 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x6442>
  5b0202:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  5b0207:	48 89 df             	mov    %rbx,%rdi
  5b020a:	48 8b 74 24 38       	mov    0x38(%rsp),%rsi
  5b020f:	e8 2c 94 f7 ff       	call   529640 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtB4_6option6OptionNtNtCs6gaF1xUz9Bf_4gpui7element7HandlerEEB11_>
  5b0214:	45 31 f6             	xor    %r14d,%r14d
  5b0217:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
  5b021c:	48 89 44 24 30       	mov    %rax,0x30(%rsp)
  5b0221:	48 89 5c 24 40       	mov    %rbx,0x40(%rsp)
  5b0226:	31 ed                	xor    %ebp,%ebp
  5b0228:	e9 83 04 00 00       	jmp    5b06b0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x6660>
  5b022d:	ff 15 95 9d 53 00    	call   *0x539d95(%rip)        # ae9fc8 <_DYNAMIC+0x268>
  5b0233:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  5b0238:	48 8d bc 24 90 01 00 	lea    0x190(%rsp),%rdi
  5b023f:	00 
  5b0240:	e8 8b 76 f8 ff       	call   5378d0 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueNtNtCs6gaF1xUz9Bf_4gpui7runtime8TextSiteEBF_>
  5b0245:	41 b6 01             	mov    $0x1,%r14b
  5b0248:	45 31 ff             	xor    %r15d,%r15d
  5b024b:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
  5b0250:	48 89 44 24 30       	mov    %rax,0x30(%rsp)
  5b0255:	48 89 5c 24 40       	mov    %rbx,0x40(%rsp)
  5b025a:	31 ed                	xor    %ebp,%ebp
  5b025c:	48 8b 5c 24 70       	mov    0x70(%rsp),%rbx
  5b0261:	e9 77 04 00 00       	jmp    5b06dd <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x668d>
  5b0266:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  5b026b:	48 c7 84 24 b0 03 00 	movq   $0xffffffffffffffff,0x3b0(%rsp)
  5b0272:	00 ff ff ff ff 
  5b0277:	e9 16 02 00 00       	jmp    5b0492 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x6442>
  5b027c:	e9 a2 03 00 00       	jmp    5b0623 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x65d3>
  5b0281:	e9 36 04 00 00       	jmp    5b06bc <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x666c>
  5b0286:	e9 98 03 00 00       	jmp    5b0623 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x65d3>
  5b028b:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  5b0290:	40 b5 01             	mov    $0x1,%bpl
  5b0293:	e9 fd 00 00 00       	jmp    5b0395 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x6345>
  5b0298:	e9 ba 04 00 00       	jmp    5b0757 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x6707>
  5b029d:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  5b02a2:	e9 c8 02 00 00       	jmp    5b056f <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x651f>
  5b02a7:	e9 82 00 00 00       	jmp    5b032e <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x62de>
  5b02ac:	e9 72 06 00 00       	jmp    5b0923 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x68d3>
  5b02b1:	e9 3a 01 00 00       	jmp    5b03f0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x63a0>
  5b02b6:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  5b02bb:	e9 55 01 00 00       	jmp    5b0415 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x63c5>
  5b02c0:	e9 92 04 00 00       	jmp    5b0757 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x6707>
  5b02c5:	e9 f2 03 00 00       	jmp    5b06bc <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x666c>
  5b02ca:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  5b02cf:	48 8b 84 24 a0 01 00 	mov    0x1a0(%rsp),%rax
  5b02d6:	00 
  5b02d7:	49 89 47 10          	mov    %rax,0x10(%r15)
  5b02db:	0f 28 84 24 90 01 00 	movaps 0x190(%rsp),%xmm0
  5b02e2:	00 
  5b02e3:	41 0f 11 07          	movups %xmm0,(%r15)
  5b02e7:	45 31 ed             	xor    %r13d,%r13d
  5b02ea:	ba 04 00 00 00       	mov    $0x4,%edx
  5b02ef:	48 8b bc 24 48 02 00 	mov    0x248(%rsp),%rdi
  5b02f6:	00 
  5b02f7:	48 8b b4 24 d0 02 00 	mov    0x2d0(%rsp),%rsi
  5b02fe:	00 
  5b02ff:	ff 15 a3 9c 53 00    	call   *0x539ca3(%rip)        # ae9fa8 <_DYNAMIC+0x248>
  5b0305:	eb 4a                	jmp    5b0351 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x6301>
  5b0307:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  5b030c:	e9 5c 07 00 00       	jmp    5b0a6d <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x6a1d>
  5b0311:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  5b0316:	48 8d bc 24 a0 00 00 	lea    0xa0(%rsp),%rdi
  5b031d:	00 
  5b031e:	e8 3d bf 21 00       	call   7cc260 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueNtNtCs6gaF1xUz9Bf_4gpui7element2ElEBF_.llvm.6226793394568926217>
  5b0323:	e9 45 07 00 00       	jmp    5b0a6d <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x6a1d>
  5b0328:	ff 15 9a 9c 53 00    	call   *0x539c9a(%rip)        # ae9fc8 <_DYNAMIC+0x268>
  5b032e:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  5b0333:	ba 04 00 00 00       	mov    $0x4,%edx
  5b0338:	48 8b bc 24 48 02 00 	mov    0x248(%rsp),%rdi
  5b033f:	00 
  5b0340:	48 8b b4 24 d0 02 00 	mov    0x2d0(%rsp),%rsi
  5b0347:	00 
  5b0348:	ff 15 5a 9c 53 00    	call   *0x539c5a(%rip)        # ae9fa8 <_DYNAMIC+0x248>
  5b034e:	45 31 ed             	xor    %r13d,%r13d
  5b0351:	45 31 f6             	xor    %r14d,%r14d
  5b0354:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%rsp)
  5b035b:	00 
  5b035c:	45 31 ff             	xor    %r15d,%r15d
  5b035f:	e9 bf 04 00 00       	jmp    5b0823 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x67d3>
  5b0364:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  5b0369:	4d 85 f6             	test   %r14,%r14
  5b036c:	75 35                	jne    5b03a3 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x6353>
  5b036e:	48 8b b4 24 70 04 00 	mov    0x470(%rsp),%rsi
  5b0375:	00 
  5b0376:	40 b5 01             	mov    $0x1,%bpl
  5b0379:	48 85 f6             	test   %rsi,%rsi
  5b037c:	74 17                	je     5b0395 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x6345>
  5b037e:	48 8b bc 24 78 04 00 	mov    0x478(%rsp),%rdi
  5b0385:	00 
  5b0386:	48 c1 e6 03          	shl    $0x3,%rsi
  5b038a:	ba 08 00 00 00       	mov    $0x8,%edx
  5b038f:	ff 15 13 9c 53 00    	call   *0x539c13(%rip)        # ae9fa8 <_DYNAMIC+0x248>
  5b0395:	b0 01                	mov    $0x1,%al
  5b0397:	89 44 24 10          	mov    %eax,0x10(%rsp)
  5b039b:	41 b7 01             	mov    $0x1,%r15b
  5b039e:	e9 47 06 00 00       	jmp    5b09ea <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x699a>
  5b03a3:	48 83 c3 08          	add    $0x8,%rbx
  5b03a7:	49 f7 de             	neg    %r14
  5b03aa:	eb 0d                	jmp    5b03b9 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x6369>
  5b03ac:	0f 1f 40 00          	nopl   0x0(%rax)
  5b03b0:	48 83 c3 08          	add    $0x8,%rbx
  5b03b4:	49 ff ce             	dec    %r14
  5b03b7:	74 b5                	je     5b036e <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x631e>
  5b03b9:	48 8b 03             	mov    (%rbx),%rax
  5b03bc:	f0 48 ff 08          	lock decq (%rax)
  5b03c0:	75 ee                	jne    5b03b0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x6360>
  5b03c2:	48 89 df             	mov    %rbx,%rdi
  5b03c5:	41 ff d7             	call   *%r15
  5b03c8:	eb e6                	jmp    5b03b0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x6360>
  5b03ca:	ff 15 f8 9b 53 00    	call   *0x539bf8(%rip)        # ae9fc8 <_DYNAMIC+0x268>
  5b03d0:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  5b03d5:	44 89 7c 24 10       	mov    %r15d,0x10(%rsp)
  5b03da:	e9 28 06 00 00       	jmp    5b0a07 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x69b7>
  5b03df:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  5b03e4:	89 dd                	mov    %ebx,%ebp
  5b03e6:	44 89 7c 24 10       	mov    %r15d,0x10(%rsp)
  5b03eb:	e9 0a 06 00 00       	jmp    5b09fa <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x69aa>
  5b03f0:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  5b03f5:	48 8b b4 24 00 04 00 	mov    0x400(%rsp),%rsi
  5b03fc:	00 
  5b03fd:	48 85 f6             	test   %rsi,%rsi
  5b0400:	7e 13                	jle    5b0415 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x63c5>
  5b0402:	48 8b bc 24 08 04 00 	mov    0x408(%rsp),%rdi
  5b0409:	00 
  5b040a:	ba 01 00 00 00       	mov    $0x1,%edx
  5b040f:	ff 15 93 9b 53 00    	call   *0x539b93(%rip)        # ae9fa8 <_DYNAMIC+0x248>
  5b0415:	4d 85 f6             	test   %r14,%r14
  5b0418:	7e 13                	jle    5b042d <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x63dd>
  5b041a:	ba 01 00 00 00       	mov    $0x1,%edx
  5b041f:	48 8b 7c 24 20       	mov    0x20(%rsp),%rdi
  5b0424:	4c 89 f6             	mov    %r14,%rsi
  5b0427:	ff 15 7b 9b 53 00    	call   *0x539b7b(%rip)        # ae9fa8 <_DYNAMIC+0x248>
  5b042d:	48 8b b4 24 00 03 00 	mov    0x300(%rsp),%rsi
  5b0434:	00 
  5b0435:	48 8b 94 24 08 03 00 	mov    0x308(%rsp),%rdx
  5b043c:	00 
  5b043d:	48 8d bc 24 10 03 00 	lea    0x310(%rsp),%rdi
  5b0444:	00 
  5b0445:	e8 b6 66 1e 00       	call   796b00 <_RNvXs_NtNtNtCs4NRVxsYgnAr_4core5array4iter10iter_innerAINtNtNtBa_3mem12maybe_uninit11MaybeUninitINtNtBa_6option6OptionNtNtCs6gaF1xUz9Bf_4gpui6source4TextEEj2_NtB4_11PartialDrop12partial_dropB1W_>
  5b044a:	48 8b bc 24 78 05 00 	mov    0x578(%rsp),%rdi
  5b0451:	00 
  5b0452:	e8 b9 91 f7 ff       	call   529610 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtB4_6option6OptionNtNtCs6gaF1xUz9Bf_4gpui11shared_text10SharedTextEEB11_>
  5b0457:	48 8b bc 24 70 05 00 	mov    0x570(%rsp),%rdi
  5b045e:	00 
  5b045f:	e8 ac 91 f7 ff       	call   529610 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtB4_6option6OptionNtNtCs6gaF1xUz9Bf_4gpui11shared_text10SharedTextEEB11_>
  5b0464:	48 8d bc 24 a0 00 00 	lea    0xa0(%rsp),%rdi
  5b046b:	00 
  5b046c:	e8 2f 65 f8 ff       	call   5369a0 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtNtNtB4_4iter8adapters3zip3ZipINtNtNtCscdodAO9FK5_5alloc3vec9into_iter8IntoIterNtNtCs6gaF1xUz9Bf_4gpui8semantic15AnnotationDraftEIB1a_AINtNtB4_6option6OptionNtNtB20_6source7FieldIdEj2_EEEB20_>
  5b0471:	48 8d bc 24 a0 04 00 	lea    0x4a0(%rsp),%rdi
  5b0478:	00 
  5b0479:	e8 f2 60 f8 ff       	call   536570 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtCscdodAO9FK5_5alloc3vec3VecNtNtNtCs6gaF1xUz9Bf_4gpui7runtime8metadata8DeclaredEEB1d_>
  5b047e:	b3 01                	mov    $0x1,%bl
  5b0480:	c7 44 24 20 00 00 00 	movl   $0x0,0x20(%rsp)
  5b0487:	00 
  5b0488:	e9 63 01 00 00       	jmp    5b05f0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x65a0>
  5b048d:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  5b0492:	41 b7 01             	mov    $0x1,%r15b
  5b0495:	41 b6 01             	mov    $0x1,%r14b
  5b0498:	40 b5 01             	mov    $0x1,%bpl
  5b049b:	48 8b 5c 24 70       	mov    0x70(%rsp),%rbx
  5b04a0:	e9 38 02 00 00       	jmp    5b06dd <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x668d>
  5b04a5:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  5b04aa:	41 b7 01             	mov    $0x1,%r15b
  5b04ad:	b0 01                	mov    $0x1,%al
  5b04af:	89 44 24 10          	mov    %eax,0x10(%rsp)
  5b04b3:	41 b6 01             	mov    $0x1,%r14b
  5b04b6:	40 b5 01             	mov    $0x1,%bpl
  5b04b9:	e9 86 04 00 00       	jmp    5b0944 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x68f4>
  5b04be:	e9 60 04 00 00       	jmp    5b0923 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x68d3>
  5b04c3:	e9 a0 03 00 00       	jmp    5b0868 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x6818>
  5b04c8:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  5b04cd:	48 8d bc 24 a0 00 00 	lea    0xa0(%rsp),%rdi
  5b04d4:	00 
  5b04d5:	e8 c6 87 f8 ff       	call   538ca0 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueNtNtNtCs6gaF1xUz9Bf_4gpui7runtime8metadata8MetadataEBH_>
  5b04da:	b3 01                	mov    $0x1,%bl
  5b04dc:	b0 01                	mov    $0x1,%al
  5b04de:	89 44 24 20          	mov    %eax,0x20(%rsp)
  5b04e2:	e9 09 01 00 00       	jmp    5b05f0 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x65a0>
  5b04e7:	ff 15 db 9a 53 00    	call   *0x539adb(%rip)        # ae9fc8 <_DYNAMIC+0x268>
  5b04ed:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  5b04f2:	48 89 9c 24 28 01 00 	mov    %rbx,0x128(%rsp)
  5b04f9:	00 
  5b04fa:	48 85 db             	test   %rbx,%rbx
  5b04fd:	0f 84 a9 02 00 00    	je     5b07ac <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x675c>
  5b0503:	48 8d bc 24 28 01 00 	lea    0x128(%rsp),%rdi
  5b050a:	00 
  5b050b:	e8 d0 62 f8 ff       	call   5367e0 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtCscdodAO9FK5_5alloc5boxed3BoxNtNtCs6gaF1xUz9Bf_4gpui7element17ComponentBoundaryEEB1d_>
  5b0510:	e9 97 02 00 00       	jmp    5b07ac <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x675c>
  5b0515:	ff 15 ad 9a 53 00    	call   *0x539aad(%rip)        # ae9fc8 <_DYNAMIC+0x268>
  5b051b:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  5b0520:	eb 15                	jmp    5b0537 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x64e7>
  5b0522:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  5b0527:	48 8b 84 24 f8 01 00 	mov    0x1f8(%rsp),%rax
  5b052e:	00 
  5b052f:	48 89 84 24 b8 03 00 	mov    %rax,0x3b8(%rsp)
  5b0536:	00 
  5b0537:	48 83 bc 24 90 00 00 	cmpq   $0x0,0x90(%rsp)
  5b053e:	00 00 
  5b0540:	75 0e                	jne    5b0550 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x6500>
  5b0542:	48 c7 84 24 90 00 00 	movq   $0x0,0x90(%rsp)
  5b0549:	00 00 00 00 00 
  5b054e:	eb 1f                	jmp    5b056f <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x651f>
  5b0550:	48 8b b4 24 90 00 00 	mov    0x90(%rsp),%rsi
  5b0557:	00 
  5b0558:	48 c1 e6 05          	shl    $0x5,%rsi
  5b055c:	ba 08 00 00 00       	mov    $0x8,%edx
  5b0561:	48 8b bc 24 98 00 00 	mov    0x98(%rsp),%rdi
  5b0568:	00 
  5b0569:	ff 15 39 9a 53 00    	call   *0x539a39(%rip)        # ae9fa8 <_DYNAMIC+0x248>
  5b056f:	48 83 bc 24 00 02 00 	cmpq   $0x0,0x200(%rsp)
  5b0576:	00 00 
  5b0578:	74 1f                	je     5b0599 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x6549>
  5b057a:	48 8b b4 24 00 02 00 	mov    0x200(%rsp),%rsi
  5b0581:	00 
  5b0582:	48 c1 e6 03          	shl    $0x3,%rsi
  5b0586:	ba 08 00 00 00       	mov    $0x8,%edx
  5b058b:	48 8b bc 24 78 02 00 	mov    0x278(%rsp),%rdi
  5b0592:	00 
  5b0593:	ff 15 0f 9a 53 00    	call   *0x539a0f(%rip)        # ae9fa8 <_DYNAMIC+0x248>
  5b0599:	48 8b 84 24 60 02 00 	mov    0x260(%rsp),%rax
  5b05a0:	00 
  5b05a1:	48 39 84 24 80 02 00 	cmp    %rax,0x280(%rsp)
  5b05a8:	00 
  5b05a9:	0f 92 c0             	setb   %al
  5b05ac:	48 83 bc 24 90 00 00 	cmpq   $0x0,0x90(%rsp)
  5b05b3:	00 00 
  5b05b5:	0f 94 c1             	sete   %cl
  5b05b8:	08 c1                	or     %al,%cl
  5b05ba:	75 1f                	jne    5b05db <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x658b>
  5b05bc:	48 8b b4 24 90 00 00 	mov    0x90(%rsp),%rsi
  5b05c3:	00 
  5b05c4:	48 c1 e6 05          	shl    $0x5,%rsi
  5b05c8:	ba 08 00 00 00       	mov    $0x8,%edx
  5b05cd:	48 8b bc 24 98 00 00 	mov    0x98(%rsp),%rdi
  5b05d4:	00 
  5b05d5:	ff 15 cd 99 53 00    	call   *0x5399cd(%rip)        # ae9fa8 <_DYNAMIC+0x248>
  5b05db:	b3 01                	mov    $0x1,%bl
  5b05dd:	48 8d bc 24 b0 03 00 	lea    0x3b0(%rsp),%rdi
  5b05e4:	00 
  5b05e5:	e8 66 05 1b 00       	call   760b50 <_RNvXse_NtNtCscdodAO9FK5_5alloc3vec9into_iterINtB5_8IntoIterNtNtCs6gaF1xUz9Bf_4gpui4list9ListDraftENtNtNtCs4NRVxsYgnAr_4core3ops4drop4Drop4dropBZ_>
  5b05ea:	b0 01                	mov    $0x1,%al
  5b05ec:	89 44 24 20          	mov    %eax,0x20(%rsp)
  5b05f0:	48 8d bc 24 08 06 00 	lea    0x608(%rsp),%rdi
  5b05f7:	00 
  5b05f8:	e8 b3 ec 17 00       	call   72f2b0 <_RNvXNtNtNtCscdodAO9FK5_5alloc11collections5btree3mapINtB2_8BTreeMapTINtNtCs4NRVxsYgnAr_4core6option6OptionyENtNtCs6gaF1xUz9Bf_4gpui4list6ListIdNtNtB1M_7element8NodeKindEjENtNtNtB19_3ops4drop4Drop4dropB1M_>
  5b05fd:	40 b5 01             	mov    $0x1,%bpl
  5b0600:	84 db                	test   %bl,%bl
  5b0602:	74 0d                	je     5b0611 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x65c1>
  5b0604:	48 8d bc 24 f0 05 00 	lea    0x5f0(%rsp),%rdi
  5b060b:	00 
  5b060c:	e8 af e0 17 00       	call   72e6c0 <_RNvXNtNtNtCscdodAO9FK5_5alloc11collections5btree3mapINtB2_8BTreeMapNtNtCs6gaF1xUz9Bf_4gpui4list6ListIdNtNtNtB17_7runtime4list9ListStateENtNtNtCs4NRVxsYgnAr_4core3ops4drop4Drop4dropB17_>
  5b0611:	45 31 f6             	xor    %r14d,%r14d
  5b0614:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%rsp)
  5b061b:	00 
  5b061c:	e9 aa 01 00 00       	jmp    5b07cb <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x677b>
  5b0621:	0f 0b                	ud2
  5b0623:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  5b0628:	41 b7 01             	mov    $0x1,%r15b
  5b062b:	41 b6 01             	mov    $0x1,%r14b
  5b062e:	40 b5 01             	mov    $0x1,%bpl
  5b0631:	e9 c7 00 00 00       	jmp    5b06fd <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x66ad>
  5b0636:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  5b063b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
  5b0640:	49 ff cc             	dec    %r12
  5b0643:	74 14                	je     5b0659 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x6609>
  5b0645:	4d 8d be 98 00 00 00 	lea    0x98(%r14),%r15
  5b064c:	4c 89 f7             	mov    %r14,%rdi
  5b064f:	e8 8c 5c 12 00       	call   6d62e0 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueNtNtCs6gaF1xUz9Bf_4gpui7element9DraftNodeEBF_.llvm.6411074540271373818>
  5b0654:	4d 89 fe             	mov    %r15,%r14
  5b0657:	eb e7                	jmp    5b0640 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x65f0>
  5b0659:	48 83 7c 24 70 00    	cmpq   $0x0,0x70(%rsp)
  5b065f:	0f 84 08 04 00 00    	je     5b0a6d <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x6a1d>
  5b0665:	48 69 74 24 70 98 00 	imul   $0x98,0x70(%rsp),%rsi
  5b066c:	00 00 
  5b066e:	ba 08 00 00 00       	mov    $0x8,%edx
  5b0673:	48 89 df             	mov    %rbx,%rdi
  5b0676:	ff 15 2c 99 53 00    	call   *0x53992c(%rip)        # ae9fa8 <_DYNAMIC+0x248>
  5b067c:	e9 ec 03 00 00       	jmp    5b0a6d <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x6a1d>
  5b0681:	ff 15 41 99 53 00    	call   *0x539941(%rip)        # ae9fc8 <_DYNAMIC+0x268>
  5b0687:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  5b068c:	40 b5 01             	mov    $0x1,%bpl
  5b068f:	e9 8b 00 00 00       	jmp    5b071f <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x66cf>
  5b0694:	e9 8a 02 00 00       	jmp    5b0923 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x68d3>
  5b0699:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  5b069e:	41 b6 01             	mov    $0x1,%r14b
  5b06a1:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
  5b06a6:	48 89 44 24 30       	mov    %rax,0x30(%rsp)
  5b06ab:	48 89 5c 24 40       	mov    %rbx,0x40(%rsp)
  5b06b0:	48 8b 5c 24 70       	mov    0x70(%rsp),%rbx
  5b06b5:	44 8b 7c 24 18       	mov    0x18(%rsp),%r15d
  5b06ba:	eb 21                	jmp    5b06dd <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x668d>
  5b06bc:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  5b06c1:	41 b7 01             	mov    $0x1,%r15b
  5b06c4:	b0 01                	mov    $0x1,%al
  5b06c6:	89 44 24 10          	mov    %eax,0x10(%rsp)
  5b06ca:	41 b6 01             	mov    $0x1,%r14b
  5b06cd:	41 b5 01             	mov    $0x1,%r13b
  5b06d0:	e9 1c 02 00 00       	jmp    5b08f1 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x68a1>
  5b06d5:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  5b06da:	41 b6 01             	mov    $0x1,%r14b
  5b06dd:	48 8d 43 ff          	lea    -0x1(%rbx),%rax
  5b06e1:	48 83 f8 fc          	cmp    $0xfffffffffffffffc,%rax
  5b06e5:	77 16                	ja     5b06fd <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x66ad>
  5b06e7:	ba 01 00 00 00       	mov    $0x1,%edx
  5b06ec:	48 8b bc 24 58 02 00 	mov    0x258(%rsp),%rdi
  5b06f3:	00 
  5b06f4:	48 89 de             	mov    %rbx,%rsi
  5b06f7:	ff 15 ab 98 53 00    	call   *0x5398ab(%rip)        # ae9fa8 <_DYNAMIC+0x248>
  5b06fd:	45 84 ff             	test   %r15b,%r15b
  5b0700:	74 18                	je     5b071a <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x66ca>
  5b0702:	48 83 bc 24 b0 03 00 	cmpq   $0xfffffffffffffffe,0x3b0(%rsp)
  5b0709:	00 fe 
  5b070b:	74 0d                	je     5b071a <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x66ca>
  5b070d:	48 8d bc 24 b0 03 00 	lea    0x3b0(%rsp),%rdi
  5b0714:	00 
  5b0715:	e8 b6 71 f8 ff       	call   5378d0 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueNtNtCs6gaF1xUz9Bf_4gpui7runtime8TextSiteEBF_>
  5b071a:	45 84 f6             	test   %r14b,%r14b
  5b071d:	74 0f                	je     5b072e <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x66de>
  5b071f:	48 8b 7c 24 40       	mov    0x40(%rsp),%rdi
  5b0724:	48 8b 74 24 30       	mov    0x30(%rsp),%rsi
  5b0729:	e8 12 8f f7 ff       	call   529640 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtB4_6option6OptionNtNtCs6gaF1xUz9Bf_4gpui7element7HandlerEEB11_>
  5b072e:	48 83 bc 24 28 04 00 	cmpq   $0x0,0x428(%rsp)
  5b0735:	00 00 
  5b0737:	0f 95 c0             	setne  %al
  5b073a:	84 84 24 08 02 00 00 	test   %al,0x208(%rsp)
  5b0741:	74 1c                	je     5b075f <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x670f>
  5b0743:	48 8b bc 24 78 02 00 	mov    0x278(%rsp),%rdi
  5b074a:	00 
  5b074b:	48 8b 74 24 58       	mov    0x58(%rsp),%rsi
  5b0750:	e8 eb 8e f7 ff       	call   529640 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtB4_6option6OptionNtNtCs6gaF1xUz9Bf_4gpui7element7HandlerEEB11_>
  5b0755:	eb 08                	jmp    5b075f <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x670f>
  5b0757:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  5b075c:	40 b5 01             	mov    $0x1,%bpl
  5b075f:	48 8b b4 24 a0 00 00 	mov    0xa0(%rsp),%rsi
  5b0766:	00 
  5b0767:	48 83 fe ff          	cmp    $0xffffffffffffffff,%rsi
  5b076b:	74 18                	je     5b0785 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x6735>
  5b076d:	48 85 f6             	test   %rsi,%rsi
  5b0770:	7e 13                	jle    5b0785 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x6735>
  5b0772:	48 8b bc 24 a8 00 00 	mov    0xa8(%rsp),%rdi
  5b0779:	00 
  5b077a:	ba 01 00 00 00       	mov    $0x1,%edx
  5b077f:	ff 15 23 98 53 00    	call   *0x539823(%rip)        # ae9fa8 <_DYNAMIC+0x248>
  5b0785:	40 84 ed             	test   %bpl,%bpl
  5b0788:	74 15                	je     5b079f <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x674f>
  5b078a:	48 8b bc 24 18 01 00 	mov    0x118(%rsp),%rdi
  5b0791:	00 
  5b0792:	48 8b b4 24 20 01 00 	mov    0x120(%rsp),%rsi
  5b0799:	00 
  5b079a:	e8 a1 8e f7 ff       	call   529640 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtB4_6option6OptionNtNtCs6gaF1xUz9Bf_4gpui7element7HandlerEEB11_>
  5b079f:	48 8d bc 24 28 01 00 	lea    0x128(%rsp),%rdi
  5b07a6:	00 
  5b07a7:	e8 14 70 f8 ff       	call   5377c0 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueNtNtCs6gaF1xUz9Bf_4gpui7element19ComponentBoundariesEBF_>
  5b07ac:	b0 01                	mov    $0x1,%al
  5b07ae:	89 44 24 20          	mov    %eax,0x20(%rsp)
  5b07b2:	48 8d bc 24 00 04 00 	lea    0x400(%rsp),%rdi
  5b07b9:	00 
  5b07ba:	e8 31 05 1b 00       	call   760cf0 <_RNvXse_NtNtCscdodAO9FK5_5alloc3vec9into_iterINtB5_8IntoIterNtNtCs6gaF1xUz9Bf_4gpui7element9DraftNodeENtNtNtCs4NRVxsYgnAr_4core3ops4drop4Drop4dropBZ_>
  5b07bf:	40 b5 01             	mov    $0x1,%bpl
  5b07c2:	41 b6 01             	mov    $0x1,%r14b
  5b07c5:	b0 01                	mov    $0x1,%al
  5b07c7:	89 44 24 10          	mov    %eax,0x10(%rsp)
  5b07cb:	ba 04 00 00 00       	mov    $0x4,%edx
  5b07d0:	48 8b bc 24 48 02 00 	mov    0x248(%rsp),%rdi
  5b07d7:	00 
  5b07d8:	48 8b b4 24 d0 02 00 	mov    0x2d0(%rsp),%rsi
  5b07df:	00 
  5b07e0:	ff 15 c2 97 53 00    	call   *0x5397c2(%rip)        # ae9fa8 <_DYNAMIC+0x248>
  5b07e6:	41 b4 01             	mov    $0x1,%r12b
  5b07e9:	45 31 ff             	xor    %r15d,%r15d
  5b07ec:	48 8d bc 24 28 05 00 	lea    0x528(%rsp),%rdi
  5b07f3:	00 
  5b07f4:	e8 d7 4d f8 ff       	call   5355d0 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtCscdodAO9FK5_5alloc3vec3VecINtNtB4_6option6OptionNtNtCs6gaF1xUz9Bf_4gpui7runtime8TextSiteEEEB1x_>
  5b07f9:	40 84 ed             	test   %bpl,%bpl
  5b07fc:	74 0d                	je     5b080b <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x67bb>
  5b07fe:	48 8d bc 24 18 02 00 	lea    0x218(%rsp),%rdi
  5b0805:	00 
  5b0806:	e8 f5 59 f8 ff       	call   536200 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtCscdodAO9FK5_5alloc3vec3VecNtNtCs6gaF1xUz9Bf_4gpui7runtime4NodeEEB1b_>
  5b080b:	41 b5 01             	mov    $0x1,%r13b
  5b080e:	45 84 e4             	test   %r12b,%r12b
  5b0811:	74 10                	je     5b0823 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x67d3>
  5b0813:	48 8d bc 24 08 07 00 	lea    0x708(%rsp),%rdi
  5b081a:	00 
  5b081b:	e8 40 81 f8 ff       	call   538960 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueNtNtNtCs6gaF1xUz9Bf_4gpui7runtime6styles8BuildingEBH_>
  5b0820:	41 b5 01             	mov    $0x1,%r13b
  5b0823:	48 8b b4 24 d8 02 00 	mov    0x2d8(%rsp),%rsi
  5b082a:	00 
  5b082b:	48 85 f6             	test   %rsi,%rsi
  5b082e:	74 52                	je     5b0882 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x6832>
  5b0830:	48 c1 e6 03          	shl    $0x3,%rsi
  5b0834:	ba 08 00 00 00       	mov    $0x8,%edx
  5b0839:	48 8b bc 24 80 00 00 	mov    0x80(%rsp),%rdi
  5b0840:	00 
  5b0841:	ff 15 61 97 53 00    	call   *0x539761(%rip)        # ae9fa8 <_DYNAMIC+0x248>
  5b0847:	eb 39                	jmp    5b0882 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x6832>
  5b0849:	eb 1d                	jmp    5b0868 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x6818>
  5b084b:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  5b0850:	ba 08 00 00 00       	mov    $0x8,%edx
  5b0855:	48 8b bc 24 80 00 00 	mov    0x80(%rsp),%rdi
  5b085c:	00 
  5b085d:	48 89 de             	mov    %rbx,%rsi
  5b0860:	ff 15 42 97 53 00    	call   *0x539742(%rip)        # ae9fa8 <_DYNAMIC+0x248>
  5b0866:	eb 05                	jmp    5b086d <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x681d>
  5b0868:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  5b086d:	b0 01                	mov    $0x1,%al
  5b086f:	89 44 24 20          	mov    %eax,0x20(%rsp)
  5b0873:	41 b5 01             	mov    $0x1,%r13b
  5b0876:	41 b6 01             	mov    $0x1,%r14b
  5b0879:	b0 01                	mov    $0x1,%al
  5b087b:	89 44 24 10          	mov    %eax,0x10(%rsp)
  5b087f:	41 b7 01             	mov    $0x1,%r15b
  5b0882:	48 8d bc 24 10 05 00 	lea    0x510(%rsp),%rdi
  5b0889:	00 
  5b088a:	e8 81 d3 17 00       	call   72dc10 <_RNvXNtNtNtCscdodAO9FK5_5alloc11collections5btree3mapINtB2_8BTreeMapINtNtCs4NRVxsYgnAr_4core6option6OptionyEjENtNtNtB18_3ops4drop4Drop4dropCs6gaF1xUz9Bf_4gpui>
  5b088f:	48 8d bc 24 f0 06 00 	lea    0x6f0(%rsp),%rdi
  5b0896:	00 
  5b0897:	e8 e4 f0 17 00       	call   72f980 <_RNvXNtNtNtCscdodAO9FK5_5alloc11collections5btree3mapINtB2_8BTreeMapjNtNtCs6gaF1xUz9Bf_4gpui4list6ListIdENtNtNtCs4NRVxsYgnAr_4core3ops4drop4Drop4dropB18_>
  5b089c:	48 8d bc 24 d8 05 00 	lea    0x5d8(%rsp),%rdi
  5b08a3:	00 
  5b08a4:	e8 07 ea 17 00       	call   72f2b0 <_RNvXNtNtNtCscdodAO9FK5_5alloc11collections5btree3mapINtB2_8BTreeMapTINtNtCs4NRVxsYgnAr_4core6option6OptionyENtNtCs6gaF1xUz9Bf_4gpui4list6ListIdNtNtB1M_7element8NodeKindEjENtNtNtB19_3ops4drop4Drop4dropB1M_>
  5b08a9:	48 8d bc 24 c0 05 00 	lea    0x5c0(%rsp),%rdi
  5b08b0:	00 
  5b08b1:	e8 fa e9 17 00       	call   72f2b0 <_RNvXNtNtNtCscdodAO9FK5_5alloc11collections5btree3mapINtB2_8BTreeMapTINtNtCs4NRVxsYgnAr_4core6option6OptionyENtNtCs6gaF1xUz9Bf_4gpui4list6ListIdNtNtB1M_7element8NodeKindEjENtNtNtB19_3ops4drop4Drop4dropB1M_>
  5b08b6:	48 8d bc 24 a8 05 00 	lea    0x5a8(%rsp),%rdi
  5b08bd:	00 
  5b08be:	e8 5d ed 17 00       	call   72f620 <_RNvXNtNtNtCscdodAO9FK5_5alloc11collections5btree3mapINtB2_8BTreeMapTINtNtCs4NRVxsYgnAr_4core6option6OptionyEmNtNtCs6gaF1xUz9Bf_4gpui7element8NodeKindEjENtNtNtB19_3ops4drop4Drop4dropB1N_>
  5b08c3:	48 8d bc 24 88 04 00 	lea    0x488(%rsp),%rdi
  5b08ca:	00 
  5b08cb:	e8 90 4c f8 ff       	call   535560 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtCscdodAO9FK5_5alloc3vec3VecINtNtB4_6option6OptionNtNtCs6gaF1xUz9Bf_4gpui7runtime4NodeEEEB1x_>
  5b08d0:	48 8d bc 24 40 05 00 	lea    0x540(%rsp),%rdi
  5b08d7:	00 
  5b08d8:	e8 13 80 f8 ff       	call   5388f0 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueNtNtNtCs6gaF1xUz9Bf_4gpui7runtime6styles6StylesEBH_>
  5b08dd:	48 8d bc 24 58 04 00 	lea    0x458(%rsp),%rdi
  5b08e4:	00 
  5b08e5:	e8 46 e1 17 00       	call   72ea30 <_RNvXNtNtNtCscdodAO9FK5_5alloc11collections5btree3mapINtB2_8BTreeMapNtNtCs6gaF1xUz9Bf_4gpui6source7FieldIdNtNtB17_11shared_text10SharedTextENtNtNtCs4NRVxsYgnAr_4core3ops4drop4Drop4dropB17_>
  5b08ea:	80 7c 24 20 00       	cmpb   $0x0,0x20(%rsp)
  5b08ef:	74 29                	je     5b091a <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x68ca>
  5b08f1:	48 8b b4 24 b8 02 00 	mov    0x2b8(%rsp),%rsi
  5b08f8:	00 
  5b08f9:	40 b5 01             	mov    $0x1,%bpl
  5b08fc:	48 85 f6             	test   %rsi,%rsi
  5b08ff:	74 1b                	je     5b091c <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x68cc>
  5b0901:	48 8b bc 24 c0 02 00 	mov    0x2c0(%rsp),%rdi
  5b0908:	00 
  5b0909:	48 c1 e6 04          	shl    $0x4,%rsi
  5b090d:	ba 08 00 00 00       	mov    $0x8,%edx
  5b0912:	ff 15 90 96 53 00    	call   *0x539690(%rip)        # ae9fa8 <_DYNAMIC+0x248>
  5b0918:	eb 02                	jmp    5b091c <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x68cc>
  5b091a:	31 ed                	xor    %ebp,%ebp
  5b091c:	45 84 ed             	test   %r13b,%r13b
  5b091f:	75 16                	jne    5b0937 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x68e7>
  5b0921:	eb 21                	jmp    5b0944 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x68f4>
  5b0923:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  5b0928:	41 b7 01             	mov    $0x1,%r15b
  5b092b:	b0 01                	mov    $0x1,%al
  5b092d:	89 44 24 10          	mov    %eax,0x10(%rsp)
  5b0931:	41 b6 01             	mov    $0x1,%r14b
  5b0934:	40 b5 01             	mov    $0x1,%bpl
  5b0937:	48 8d bc 24 30 02 00 	lea    0x230(%rsp),%rdi
  5b093e:	00 
  5b093f:	e8 dc e1 17 00       	call   72eb20 <_RNvXNtNtNtCscdodAO9FK5_5alloc11collections5btree3mapINtB2_8BTreeMapNtNtCs6gaF1xUz9Bf_4gpui6source7FieldIdNtNtB17_7runtime6FanoutENtNtNtCs4NRVxsYgnAr_4core3ops4drop4Drop4dropB17_>
  5b0944:	ba 08 00 00 00       	mov    $0x8,%edx
  5b0949:	48 8b bc 24 e0 02 00 	mov    0x2e0(%rsp),%rdi
  5b0950:	00 
  5b0951:	48 8b b4 24 c8 04 00 	mov    0x4c8(%rsp),%rsi
  5b0958:	00 
  5b0959:	ff 15 49 96 53 00    	call   *0x539649(%rip)        # ae9fa8 <_DYNAMIC+0x248>
  5b095f:	48 8b b4 24 a0 02 00 	mov    0x2a0(%rsp),%rsi
  5b0966:	00 
  5b0967:	48 85 f6             	test   %rsi,%rsi
  5b096a:	74 17                	je     5b0983 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x6933>
  5b096c:	48 8b bc 24 a8 02 00 	mov    0x2a8(%rsp),%rdi
  5b0973:	00 
  5b0974:	48 c1 e6 02          	shl    $0x2,%rsi
  5b0978:	ba 04 00 00 00       	mov    $0x4,%edx
  5b097d:	ff 15 25 96 53 00    	call   *0x539625(%rip)        # ae9fa8 <_DYNAMIC+0x248>
  5b0983:	48 8b b4 24 88 02 00 	mov    0x288(%rsp),%rsi
  5b098a:	00 
  5b098b:	48 85 f6             	test   %rsi,%rsi
  5b098e:	74 17                	je     5b09a7 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x6957>
  5b0990:	48 8b bc 24 90 02 00 	mov    0x290(%rsp),%rdi
  5b0997:	00 
  5b0998:	48 c1 e6 03          	shl    $0x3,%rsi
  5b099c:	ba 08 00 00 00       	mov    $0x8,%edx
  5b09a1:	ff 15 01 96 53 00    	call   *0x539601(%rip)        # ae9fa8 <_DYNAMIC+0x248>
  5b09a7:	48 8b b4 24 e8 02 00 	mov    0x2e8(%rsp),%rsi
  5b09ae:	00 
  5b09af:	48 85 f6             	test   %rsi,%rsi
  5b09b2:	74 17                	je     5b09cb <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x697b>
  5b09b4:	48 8b bc 24 f0 02 00 	mov    0x2f0(%rsp),%rdi
  5b09bb:	00 
  5b09bc:	48 c1 e6 03          	shl    $0x3,%rsi
  5b09c0:	ba 08 00 00 00       	mov    $0x8,%edx
  5b09c5:	ff 15 dd 95 53 00    	call   *0x5395dd(%rip)        # ae9fa8 <_DYNAMIC+0x248>
  5b09cb:	48 8d bc 24 20 06 00 	lea    0x620(%rsp),%rdi
  5b09d2:	00 
  5b09d3:	e8 a8 ef 17 00       	call   72f980 <_RNvXNtNtNtCscdodAO9FK5_5alloc11collections5btree3mapINtB2_8BTreeMapjNtNtCs6gaF1xUz9Bf_4gpui4list6ListIdENtNtNtCs4NRVxsYgnAr_4core3ops4drop4Drop4dropB18_>
  5b09d8:	45 84 f6             	test   %r14b,%r14b
  5b09db:	74 0d                	je     5b09ea <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x699a>
  5b09dd:	48 8d bc 24 70 04 00 	lea    0x470(%rsp),%rdi
  5b09e4:	00 
  5b09e5:	e8 16 5a f8 ff       	call   536400 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtCscdodAO9FK5_5alloc3vec3VecNtNtCs7XZEQI6Z5Ts_11gpui_canvas5image5ImageEECs6gaF1xUz9Bf_4gpui>
  5b09ea:	48 8d bc 24 c0 06 00 	lea    0x6c0(%rsp),%rdi
  5b09f1:	00 
  5b09f2:	e8 19 d2 17 00       	call   72dc10 <_RNvXNtNtNtCscdodAO9FK5_5alloc11collections5btree3mapINtB2_8BTreeMapINtNtCs4NRVxsYgnAr_4core6option6OptionyEjENtNtNtB18_3ops4drop4Drop4dropCs6gaF1xUz9Bf_4gpui>
  5b09f7:	45 31 ed             	xor    %r13d,%r13d
  5b09fa:	48 8d bc 24 a8 06 00 	lea    0x6a8(%rsp),%rdi
  5b0a01:	00 
  5b0a02:	e8 79 ef 17 00       	call   72f980 <_RNvXNtNtNtCscdodAO9FK5_5alloc11collections5btree3mapINtB2_8BTreeMapjNtNtCs6gaF1xUz9Bf_4gpui4list6ListIdENtNtNtCs4NRVxsYgnAr_4core3ops4drop4Drop4dropB18_>
  5b0a07:	48 8b 8c 24 e8 04 00 	mov    0x4e8(%rsp),%rcx
  5b0a0e:	00 
  5b0a0f:	48 85 c9             	test   %rcx,%rcx
  5b0a12:	0f 95 c0             	setne  %al
  5b0a15:	41 84 c5             	test   %al,%r13b
  5b0a18:	74 1b                	je     5b0a35 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x69e5>
  5b0a1a:	48 c1 e1 03          	shl    $0x3,%rcx
  5b0a1e:	48 8d 34 49          	lea    (%rcx,%rcx,2),%rsi
  5b0a22:	ba 08 00 00 00       	mov    $0x8,%edx
  5b0a27:	48 8b bc 24 e0 04 00 	mov    0x4e0(%rsp),%rdi
  5b0a2e:	00 
  5b0a2f:	ff 15 73 95 53 00    	call   *0x539573(%rip)        # ae9fa8 <_DYNAMIC+0x248>
  5b0a35:	40 84 ed             	test   %bpl,%bpl
  5b0a38:	74 0d                	je     5b0a47 <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x69f7>
  5b0a3a:	48 8d bc 24 40 04 00 	lea    0x440(%rsp),%rdi
  5b0a41:	00 
  5b0a42:	e8 09 59 f8 ff       	call   536350 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtCscdodAO9FK5_5alloc3vec3VecNtNtCs6gaF1xUz9Bf_4gpui8semantic15AnnotationDraftEEB1b_>
  5b0a47:	80 7c 24 10 00       	cmpb   $0x0,0x10(%rsp)
  5b0a4c:	74 0d                	je     5b0a5b <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x6a0b>
  5b0a4e:	48 8d bc 24 f0 04 00 	lea    0x4f0(%rsp),%rdi
  5b0a55:	00 
  5b0a56:	e8 75 55 f8 ff       	call   535fd0 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtCscdodAO9FK5_5alloc3vec3VecNtNtCs6gaF1xUz9Bf_4gpui4list9ListDraftEEB1b_>
  5b0a5b:	45 84 ff             	test   %r15b,%r15b
  5b0a5e:	74 0d                	je     5b0a6d <_RNvMsq_NtCs6gaF1xUz9Bf_4gpui7runtimeINtB5_7RuntimeNtNtB5_12style_ledger9AdversaryE14describe_innerB7_+0x6a1d>
  5b0a60:	48 8d bc 24 38 06 00 	lea    0x638(%rsp),%rdi
  5b0a67:	00 
  5b0a68:	e8 13 56 f8 ff       	call   536080 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtCscdodAO9FK5_5alloc3vec3VecNtNtCs6gaF1xUz9Bf_4gpui7element9DraftNodeEEB1b_>
  5b0a6d:	48 8d bc 24 d8 06 00 	lea    0x6d8(%rsp),%rdi
  5b0a74:	00 
  5b0a75:	e8 46 d9 17 00       	call   72e3c0 <_RNvXNtNtNtCscdodAO9FK5_5alloc11collections5btree3mapINtB2_8BTreeMapNtNtCs6gaF1xUz9Bf_4gpui4list6ListIdNtNtB4_7set_val9SetValZSTENtNtNtCs4NRVxsYgnAr_4core3ops4drop4Drop4dropB17_>
  5b0a7a:	48 8b 7c 24 08       	mov    0x8(%rsp),%rdi
  5b0a7f:	e8 2c 6a 50 00       	call   ab74b0 <_Unwind_Resume@plt>
  5b0a84:	ff 15 3e 95 53 00    	call   *0x53953e(%rip)        # ae9fc8 <_DYNAMIC+0x268>
