
/tmp/gpui-inspector-pointer-codegen/baseline-frozen:     file format elf64-x86-64


Disassembly of section .text:

00000000006d0250 <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only>:
  6d0250:	push   %rbp
  6d0251:	push   %r15
  6d0253:	push   %r14
  6d0255:	push   %r13
  6d0257:	push   %r12
  6d0259:	push   %rbx
  6d025a:	sub    $0x58,%rsp
  6d025e:	mov    (%rsi),%rbx
  6d0261:	test   %rbx,%rbx
  6d0264:	je     6d0289 <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x39>
  6d0266:	add    $0x8,%rsi
  6d026a:	mov    %rbx,0x48(%rsp)
  6d026f:	mov    %rsi,0x50(%rsp)
  6d0274:	cmpb   $0x1,0x746(%rbx)
  6d027b:	jne    6d029d <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x4d>
  6d027d:	movq   $0xe,(%rdi)
  6d0284:	jmp    6d035d <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x10d>
  6d0289:	movq   $0xd,(%rdi)
  6d0290:	movq   $0x0,0x8(%rdi)
  6d0298:	jmp    6d035d <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x10d>
  6d029d:	cmpb   $0x1,0x742(%rbx)
  6d02a4:	jne    6d0356 <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x106>
  6d02aa:	cmpb   $0x0,0x743(%rbx)
  6d02b1:	jne    6d0356 <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x106>
  6d02b7:	cmpb   $0x0,0x744(%rbx)
  6d02be:	je     6d0356 <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x106>
  6d02c4:	cmpq   $0xffffffffffffffff,0x5b0(%rbx)
  6d02cc:	jne    6d0356 <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x106>
  6d02d2:	mov    0x688(%rbx),%rax
  6d02d9:	cmp    0x690(%rbx),%rax
  6d02e0:	jne    6d0356 <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x106>
  6d02e2:	mov    0x6a0(%rbx),%rax
  6d02e9:	cmp    0x698(%rbx),%rax
  6d02f0:	jne    6d0356 <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x106>
  6d02f2:	movss  0x738(%rbx),%xmm2
  6d02fa:	ucomiss 0x73c(%rbx),%xmm2
  6d0301:	jne    6d0356 <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x106>
  6d0303:	jp     6d0356 <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x106>
  6d0305:	mov    %rdi,%r14
  6d0308:	mov    0x638(%rbx),%rax
  6d030f:	test   %rax,%rax
  6d0312:	je     6d036c <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x11c>
  6d0314:	mov    0xd8(%rax),%rax
  6d031b:	test   %rax,%rax
  6d031e:	je     6d036c <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x11c>
  6d0320:	cmpb   $0x0,0x12(%rax)
  6d0324:	je     6d036c <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x11c>
  6d0326:	mov    %rbx,%rdi
  6d0329:	call   6db880 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE14inspector_pickB10_>
  6d032e:	test   %rax,%rax
  6d0331:	je     6d0468 <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x218>
  6d0337:	mov    %rdx,%rcx
  6d033a:	mov    %r14,%rdi
  6d033d:	mov    %rbx,%rsi
  6d0340:	mov    %rax,%rdx
  6d0343:	add    $0x58,%rsp
  6d0347:	pop    %rbx
  6d0348:	pop    %r12
  6d034a:	pop    %r13
  6d034c:	pop    %r14
  6d034e:	pop    %r15
  6d0350:	pop    %rbp
  6d0351:	jmp    6defb0 <_RNvMs4_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_10RuntimeMutNtCs4gijoeCAvqI_25inspector_pointer_control5ModeluE16inspector_selectB14_>
  6d0356:	movq   $0x12,(%rdi)
  6d035d:	add    $0x58,%rsp
  6d0361:	pop    %rbx
  6d0362:	pop    %r12
  6d0364:	pop    %r13
  6d0366:	pop    %r14
  6d0368:	pop    %r15
  6d036a:	pop    %rbp
  6d036b:	ret
  6d036c:	mov    %rbx,%rdi
  6d036f:	movss  %xmm0,0x8(%rsp)
  6d0375:	movss  %xmm1,0xc(%rsp)
  6d037b:	call   6f80c0 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_>
  6d0380:	cmp    $0x1,%rax
  6d0384:	jne    6d0428 <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x1d8>
  6d038a:	lea    0x5d8(%rbx),%rdi
  6d0391:	mov    %rdx,%rsi
  6d0394:	call   *0x348c8e(%rip)        # a19028 <_DYNAMIC+0x460>
  6d039a:	cmp    0x5d8(%rbx),%rax
  6d03a1:	jne    6d0474 <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x224>
  6d03a7:	mov    %rax,%r12
  6d03aa:	mov    %rdx,%r15
  6d03ad:	lea    0x10(%rsp),%rdi
  6d03b2:	mov    %rbx,%rsi
  6d03b5:	call   6f7de0 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE16resolve_identityBO_>
  6d03ba:	mov    0x10(%rsp),%rax
  6d03bf:	mov    0x18(%rsp),%rdi
  6d03c4:	cmp    $0xfffffffffffffffe,%rax
  6d03c8:	jne    6d0479 <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x229>
  6d03ce:	mov    0x2c8(%rbx),%rsi
  6d03d5:	cmp    %rsi,%rdi
  6d03d8:	jae    6d052a <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x2da>
  6d03de:	mov    0x2c0(%rbx),%rax
  6d03e5:	lea    (%rdi,%rdi,4),%rcx
  6d03e9:	mov    0x20(%rax,%rcx,8),%edi
  6d03ed:	call   6e1870 <_RNvMsh_NtCs6ZNK6sH19NW_4gpui7runtimeNtB5_4Node4kind>
  6d03f2:	cmp    $0x4,%al
  6d03f4:	jne    6d04a2 <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x252>
  6d03fa:	mov    %r14,%rdi
  6d03fd:	mov    %rbx,%rsi
  6d0400:	mov    %r12,%rdx
  6d0403:	mov    %r15,%rcx
  6d0406:	movss  0x8(%rsp),%xmm0
  6d040c:	movss  0xc(%rsp),%xmm1
  6d0412:	xor    %r8d,%r8d
  6d0415:	add    $0x58,%rsp
  6d0419:	pop    %rbx
  6d041a:	pop    %r12
  6d041c:	pop    %r13
  6d041e:	pop    %r14
  6d0420:	pop    %r15
  6d0422:	pop    %rbp
  6d0423:	jmp    6dafb0 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime7editingINtB7_10RuntimeMutNtCs4gijoeCAvqI_25inspector_pointer_control5ModeluE14select_pointerB12_>
  6d0428:	mov    0x610(%rbx),%rdx
  6d042f:	mov    0x618(%rbx),%rcx
  6d0436:	movq   $0x0,0x610(%rbx)
  6d0441:	movq   $0x0,0x730(%rbx)
  6d044c:	lea    0x10(%rsp),%rdi
  6d0451:	mov    %rbx,%rsi
  6d0454:	call   6db5d0 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime7editingINtB7_10RuntimeMutNtCs4gijoeCAvqI_25inspector_pointer_control5ModeluE20publish_focus_changeB12_>
  6d0459:	mov    0x10(%rsp),%rax
  6d045e:	cmp    $0xfffffffffffffffe,%rax
  6d0462:	jne    6d04ec <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x29c>
  6d0468:	movq   $0x19,(%r14)
  6d046f:	jmp    6d035d <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x10d>
  6d0474:	mov    $0x11,%eax
  6d0479:	mov    0x40(%rsp),%rcx
  6d047e:	mov    %rcx,0x30(%r14)
  6d0482:	movups 0x20(%rsp),%xmm0
  6d0487:	movups 0x30(%rsp),%xmm1
  6d048c:	movups %xmm1,0x20(%r14)
  6d0491:	movups %xmm0,0x10(%r14)
  6d0496:	mov    %rax,(%r14)
  6d0499:	mov    %rdi,0x8(%r14)
  6d049d:	jmp    6d035d <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x10d>
  6d04a2:	mov    0x610(%rbx),%r13
  6d04a9:	mov    0x618(%rbx),%rbp
  6d04b0:	lea    0x10(%rsp),%rdi
  6d04b5:	mov    %rbx,%rsi
  6d04b8:	mov    %r12,%rdx
  6d04bb:	mov    %r15,%rcx
  6d04be:	call   6dd570 <_RNvMs3_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE5focusBW_>
  6d04c3:	mov    0x10(%rsp),%rax
  6d04c8:	cmp    $0xfffffffffffffffe,%rax
  6d04cc:	jne    6d04ec <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x29c>
  6d04ce:	lea    0x48(%rsp),%rsi
  6d04d3:	mov    %r14,%rdi
  6d04d6:	mov    %r12,%rdx
  6d04d9:	mov    %r15,%rcx
  6d04dc:	mov    %r13,%r8
  6d04df:	mov    %rbp,%r9
  6d04e2:	call   6d2f80 <_RNvMNtNtCs6ZNK6sH19NW_4gpui7runtime4turnINtB4_10RuntimeMutNtCs4gijoeCAvqI_25inspector_pointer_control5ModeluE16activate_focusedBW_>
  6d04e7:	jmp    6d035d <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x10d>
  6d04ec:	mov    0x38(%rsp),%rcx
  6d04f1:	movzbl 0x40(%rsp),%edx
  6d04f6:	mov    0x44(%rsp),%esi
  6d04fa:	mov    %esi,0x34(%r14)
  6d04fe:	mov    0x41(%rsp),%esi
  6d0502:	mov    %esi,0x31(%r14)
  6d0506:	movups 0x18(%rsp),%xmm0
  6d050b:	movups 0x28(%rsp),%xmm1
  6d0510:	mov    %rax,(%r14)
  6d0513:	movups %xmm0,0x8(%r14)
  6d0518:	movups %xmm1,0x18(%r14)
  6d051d:	mov    %rcx,0x28(%r14)
  6d0521:	mov    %dl,0x30(%r14)
  6d0525:	jmp    6d035d <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x10d>
  6d052a:	lea    0x32a0bf(%rip),%rdx        # 9fa5f0 <__frame_dummy_init_array_entry+0x11e0>
  6d0531:	call   *0x348901(%rip)        # a18e38 <_DYNAMIC+0x270>

/tmp/gpui-inspector-pointer-codegen/baseline-frozen:     file format elf64-x86-64


Disassembly of section .text:

00000000006d0540 <_RNvCs4gijoeCAvqI_25inspector_pointer_control3ack>:
  6d0540:	push   %r14
  6d0542:	push   %rbx
  6d0543:	sub    $0x78,%rsp
  6d0547:	test   %rdi,%rdi
  6d054a:	je     6d0585 <_RNvCs4gijoeCAvqI_25inspector_pointer_control3ack+0x45>
  6d054c:	mov    %rdi,%rsi
  6d054f:	cmpb   $0x0,0x746(%rdi)
  6d0556:	jne    6d058c <_RNvCs4gijoeCAvqI_25inspector_pointer_control3ack+0x4c>
  6d0558:	mov    0x6a8(%rsi),%rdx
  6d055f:	test   %rdx,%rdx
  6d0562:	je     6d0593 <_RNvCs4gijoeCAvqI_25inspector_pointer_control3ack+0x53>
  6d0564:	mov    0x6b0(%rsi),%rcx
  6d056b:	lea    0x40(%rsp),%rdi
  6d0570:	call   6e6b60 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE11acknowledgeBO_>
  6d0575:	cmpq   $0xfffffffffffffffe,0x40(%rsp)
  6d057b:	jne    6d05cd <_RNvCs4gijoeCAvqI_25inspector_pointer_control3ack+0x8d>
  6d057d:	add    $0x78,%rsp
  6d0581:	pop    %rbx
  6d0582:	pop    %r14
  6d0584:	ret
  6d0585:	mov    $0xd,%eax
  6d058a:	jmp    6d0598 <_RNvCs4gijoeCAvqI_25inspector_pointer_control3ack+0x58>
  6d058c:	mov    $0xe,%eax
  6d0591:	jmp    6d0598 <_RNvCs4gijoeCAvqI_25inspector_pointer_control3ack+0x58>
  6d0593:	mov    $0x14,%eax
  6d0598:	mov    %rax,(%rsp)
  6d059c:	movq   $0x0,0x8(%rsp)
  6d05a5:	lea    -0x685e92(%rip),%rdi        # 4a71a <GCC_except_table0+0xd022>
  6d05ac:	lea    0x329945(%rip),%rcx        # 9f9ef8 <__frame_dummy_init_array_entry+0xae8>
  6d05b3:	lea    0x32975e(%rip),%r8        # 9f9d18 <__frame_dummy_init_array_entry+0x908>
  6d05ba:	mov    %rsp,%rbx
  6d05bd:	mov    $0x2b,%esi
  6d05c2:	mov    %rbx,%rdx
  6d05c5:	call   *0x3488ed(%rip)        # a18eb8 <_DYNAMIC+0x2f0>
  6d05cb:	jmp    6d061a <_RNvCs4gijoeCAvqI_25inspector_pointer_control3ack+0xda>
  6d05cd:	mov    0x70(%rsp),%rax
  6d05d2:	mov    %rax,0x30(%rsp)
  6d05d7:	movups 0x40(%rsp),%xmm0
  6d05dc:	movups 0x50(%rsp),%xmm1
  6d05e1:	movups 0x60(%rsp),%xmm2
  6d05e6:	movaps %xmm2,0x20(%rsp)
  6d05eb:	movaps %xmm1,0x10(%rsp)
  6d05f0:	movaps %xmm0,(%rsp)
  6d05f4:	lea    -0x685ee1(%rip),%rdi        # 4a71a <GCC_except_table0+0xd022>
  6d05fb:	lea    0x3298f6(%rip),%rcx        # 9f9ef8 <__frame_dummy_init_array_entry+0xae8>
  6d0602:	lea    0x329727(%rip),%r8        # 9f9d30 <__frame_dummy_init_array_entry+0x920>
  6d0609:	mov    %rsp,%rbx
  6d060c:	mov    $0x2b,%esi
  6d0611:	mov    %rbx,%rdx
  6d0614:	call   *0x34889e(%rip)        # a18eb8 <_DYNAMIC+0x2f0>
  6d061a:	ud2
  6d061c:	jmp    6d061e <_RNvCs4gijoeCAvqI_25inspector_pointer_control3ack+0xde>
  6d061e:	mov    %rax,%r14
  6d0621:	mov    %rbx,%rdi
  6d0624:	call   6be240 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueNtNtCs6ZNK6sH19NW_4gpui7runtime5ErrorECs4gijoeCAvqI_25inspector_pointer_control>
  6d0629:	mov    %r14,%rdi
  6d062c:	call   9f8060 <_Unwind_Resume@plt>

/tmp/gpui-inspector-pointer-codegen/baseline-frozen:     file format elf64-x86-64


Disassembly of section .text:

00000000006d0640 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main>:
  6d0640:	push   %rbp
  6d0641:	push   %r15
  6d0643:	push   %r14
  6d0645:	push   %r13
  6d0647:	push   %r12
  6d0649:	push   %rbx
  6d064a:	sub    $0xcf8,%rsp
  6d0651:	call   *0x3487b9(%rip)        # a18e10 <_DYNAMIC+0x248>
  6d0657:	mov    $0x6,%edi
  6d065c:	mov    $0x1,%esi
  6d0661:	call   *0x3487b1(%rip)        # a18e18 <_DYNAMIC+0x250>
  6d0667:	test   %rax,%rax
  6d066a:	je     6d1d56 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1716>
  6d0670:	mov    %rax,%rbx
  6d0673:	movw   $0x6863,0x4(%rax)
  6d0679:	movl   $0x72616573,(%rax)
  6d067f:	lea    0x3c0(%rsp),%rdi
  6d0687:	movabs $0x384000002d0,%r14
  6d0691:	movss  -0x692f69(%rip),%xmm0        # 3d730 <GCC_except_table0+0x38>
  6d0699:	mov    %r14,%rsi
  6d069c:	call   *0x34898e(%rip)        # a19030 <_DYNAMIC+0x468>
  6d06a2:	mov    0x3c0(%rsp),%r13
  6d06aa:	cmp    $0xfffffffffffffffe,%r13
  6d06ae:	jne    6d1d66 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1726>
  6d06b4:	movq   $0x0,0x3d8(%rsp)
  6d06c0:	movq   $0x8,0x3e0(%rsp)
  6d06cc:	xorps  %xmm0,%xmm0
  6d06cf:	movups %xmm0,0x3e8(%rsp)
  6d06d7:	movq   $0xffffffffffffffff,0x3c0(%rsp)
  6d06e3:	movq   $0x8,0x3f8(%rsp)
  6d06ef:	movups %xmm0,0x400(%rsp)
  6d06f7:	movq   $0x8,0x410(%rsp)
  6d0703:	movq   $0x0,0x418(%rsp)
  6d070f:	movq   $0x1,0x420(%rsp)
  6d071b:	mov    $0x1,%edi
  6d0720:	call   *0x348912(%rip)        # a19038 <_DYNAMIC+0x470>
  6d0726:	mov    %rax,%r13
  6d0729:	cmp    $0x1,%r13d
  6d072d:	je     6d0743 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x103>
  6d072f:	movq   $0x0,0x3c0(%rsp)
  6d073b:	mov    %r13,0x3c8(%rsp)
  6d0743:	call   *0x3486c7(%rip)        # a18e10 <_DYNAMIC+0x248>
  6d0749:	mov    $0x28,%edi
  6d074e:	mov    $0x8,%esi
  6d0753:	call   *0x3486bf(%rip)        # a18e18 <_DYNAMIC+0x250>
  6d0759:	test   %rax,%rax
  6d075c:	je     6d1964 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1324>
  6d0762:	mov    %rax,%r15
  6d0765:	lea    0x3d8(%rsp),%r12
  6d076d:	mov    %r13,(%rax)
  6d0770:	lea    -0x692f83(%rip),%rax        # 3d7f4 <GCC_except_table0+0xfc>
  6d0777:	mov    %rax,0x8(%r15)
  6d077b:	movq   $0x4,0x10(%r15)
  6d0783:	lea    0x32876(%rip),%rax        # 703000 <_RNvYNCNvXCs4gijoeCAvqI_25inspector_pointer_controlNtB7_5ModelNtCs6ZNK6sH19NW_4gpui4View7sources0INtNtNtCs4NRVxsYgnAr_4core3ops8function6FnOnceTRBM_EE9call_onceB7_>
  6d078a:	mov    %rax,0x18(%r15)
  6d078e:	lea    0x3287b(%rip),%rax        # 703010 <_RNvYNCNvXCs4gijoeCAvqI_25inspector_pointer_controlNtB7_5ModelNtCs6ZNK6sH19NW_4gpui4View7sourcess_0INtNtNtCs4NRVxsYgnAr_4core3ops8function6FnOnceTQBM_EE9call_onceB7_>
  6d0795:	mov    %rax,0x20(%r15)
  6d0799:	mov    %r12,%rdi
  6d079c:	call   6dcef0 <_RNvMs3_NtCscdodAO9FK5_5alloc7raw_vecINtB5_6RawVecAINtNtCs4NRVxsYgnAr_4core6option6OptionNtNtCs6ZNK6sH19NW_4gpui6source7FieldIdEj2_E8grow_oneCs4gijoeCAvqI_25inspector_pointer_control>
  6d07a1:	mov    0x3e0(%rsp),%rax
  6d07a9:	mov    %r15,(%rax)
  6d07ac:	lea    0x328e65(%rip),%rcx        # 9f9618 <__frame_dummy_init_array_entry+0x208>
  6d07b3:	mov    %rcx,0x8(%rax)
  6d07b7:	movq   $0x1,0x3e8(%rsp)
  6d07c3:	mov    0x3c0(%rsp),%rax
  6d07cb:	movups 0x40(%r12),%xmm0
  6d07d1:	movaps %xmm0,0x160(%rsp)
  6d07d9:	movups (%r12),%xmm0
  6d07de:	movups 0x10(%r12),%xmm1
  6d07e4:	movups 0x20(%r12),%xmm2
  6d07ea:	movups 0x30(%r12),%xmm3
  6d07f0:	movaps %xmm3,0x150(%rsp)
  6d07f8:	movaps %xmm2,0x140(%rsp)
  6d0800:	movaps %xmm1,0x130(%rsp)
  6d0808:	movups 0x3c8(%rsp),%xmm2
  6d0810:	movups %xmm0,0xb8(%rsp)
  6d0818:	movups %xmm1,0xc8(%rsp)
  6d0820:	mov    0x140(%rsp),%rcx
  6d0828:	mov    %rcx,0xd8(%rsp)
  6d0830:	movups 0x148(%rsp),%xmm0
  6d0838:	movups %xmm0,0xe0(%rsp)
  6d0840:	movups 0x158(%rsp),%xmm0
  6d0848:	movups %xmm0,0xf0(%rsp)
  6d0850:	mov    0x168(%rsp),%rcx
  6d0858:	mov    %rcx,0x100(%rsp)
  6d0860:	mov    %rax,0xa0(%rsp)
  6d0868:	movups %xmm2,0xa8(%rsp)
  6d0870:	movl   $0x0,0x120(%rsp)
  6d087b:	movl   $0x434b0000,0x128(%rsp)
  6d0886:	movw   $0x0,0x12c(%rsp)
  6d0890:	lea    0x3c0(%rsp),%rdi
  6d0898:	lea    0x120(%rsp),%rcx
  6d08a0:	mov    $0x2d0,%esi
  6d08a5:	mov    $0x384,%edx
  6d08aa:	call   *0x348790(%rip)        # a19040 <_DYNAMIC+0x478>
  6d08b0:	mov    0x3c0(%rsp),%r13
  6d08b8:	mov    0x3c8(%rsp),%r15d
  6d08c0:	mov    0x3cc(%rsp),%r12d
  6d08c8:	cmp    $0x2,%r13
  6d08cc:	je     6d1daf <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x176f>
  6d08d2:	lea    0x3d0(%rsp),%rsi
  6d08da:	lea    0xb20(%rsp),%rdi
  6d08e2:	mov    $0x1d8,%edx
  6d08e7:	call   *0x34853b(%rip)        # a18e28 <memcpy@GLIBC_2.14>
  6d08ed:	mov    %r13,0xb10(%rsp)
  6d08f5:	mov    %r15d,0xb18(%rsp)
  6d08fd:	mov    %r12d,0xb1c(%rsp)
  6d0905:	call   *0x34873d(%rip)        # a19048 <_DYNAMIC+0x480>
  6d090b:	mov    %rax,%r15
  6d090e:	lea    0x120(%rsp),%rdi
  6d0916:	call   *0x348734(%rip)        # a19050 <_DYNAMIC+0x488>
  6d091c:	movq   $0x6,0x660(%rsp)
  6d0928:	movl   $0x0,0x668(%rsp)
  6d0933:	movq   $0x0,0x670(%rsp)
  6d093f:	movups 0xa0(%rsp),%xmm0
  6d0947:	movups 0xb0(%rsp),%xmm1
  6d094f:	movups 0xc0(%rsp),%xmm2
  6d0957:	movups 0xd0(%rsp),%xmm3
  6d095f:	movups %xmm0,0x5e8(%rsp)
  6d0967:	movups %xmm1,0x5f8(%rsp)
  6d096f:	movups %xmm2,0x608(%rsp)
  6d0977:	movups %xmm3,0x618(%rsp)
  6d097f:	movups 0xe0(%rsp),%xmm0
  6d0987:	movups %xmm0,0x628(%rsp)
  6d098f:	movups 0xf0(%rsp),%xmm0
  6d0997:	movups %xmm0,0x638(%rsp)
  6d099f:	mov    0x100(%rsp),%rax
  6d09a7:	mov    %rax,0x648(%rsp)
  6d09af:	lea    0x6a8(%rsp),%rdi
  6d09b7:	lea    0x120(%rsp),%rsi
  6d09bf:	mov    0x348462(%rip),%r12        # a18e28 <memcpy@GLIBC_2.14>
  6d09c6:	mov    $0x298,%edx
  6d09cb:	call   *%r12
  6d09ce:	lea    0x3c0(%rsp),%rdi
  6d09d6:	lea    0xb10(%rsp),%rsi
  6d09de:	mov    $0x1e8,%edx
  6d09e3:	call   *%r12
  6d09e6:	movq   $0x6,0x650(%rsp)
  6d09f2:	mov    %rbx,0x658(%rsp)
  6d09fa:	movq   $0x0,0x678(%rsp)
  6d0a06:	movq   $0x8,0x680(%rsp)
  6d0a12:	xorps  %xmm0,%xmm0
  6d0a15:	movups %xmm0,0x688(%rsp)
  6d0a1d:	movq   $0x8,0x698(%rsp)
  6d0a29:	movq   $0x0,0x6a0(%rsp)
  6d0a35:	movq   $0x0,0x9c0(%rsp)
  6d0a41:	movups %xmm0,0x5a8(%rsp)
  6d0a49:	movups %xmm0,0x5b8(%rsp)
  6d0a51:	movups %xmm0,0x9a8(%rsp)
  6d0a59:	movq   $0x1,0x9c8(%rsp)
  6d0a65:	movq   $0x0,0x9d0(%rsp)
  6d0a71:	mov    %r15,0x998(%rsp)
  6d0a79:	movq   $0x0,0x9e0(%rsp)
  6d0a85:	movq   $0x0,0xa28(%rsp)
  6d0a91:	movups %xmm0,0x9f0(%rsp)
  6d0a99:	movq   $0x0,0xa00(%rsp)
  6d0aa5:	movups %xmm0,0xa10(%rsp)
  6d0aad:	movq   $0x0,0x940(%rsp)
  6d0ab9:	movq   $0x8,0x948(%rsp)
  6d0ac5:	movups %xmm0,0x950(%rsp)
  6d0acd:	movq   $0x0,0xa30(%rsp)
  6d0ad9:	movq   $0x0,0xa40(%rsp)
  6d0ae5:	movl   $0x1000101,0xb00(%rsp)
  6d0af0:	movw   $0x0,0xb04(%rsp)
  6d0afa:	movups %xmm0,0xa48(%rsp)
  6d0b02:	movq   $0x0,0xa58(%rsp)
  6d0b0e:	mov    %r14,0xa60(%rsp)
  6d0b16:	movsd  -0x69288e(%rip),%xmm1        # 3e290 <GCC_except_table0+0xb98>
  6d0b1e:	movsd  %xmm1,0xaf8(%rsp)
  6d0b27:	movq   $0x1,0x9a0(%rsp)
  6d0b33:	movq   $0xffffffffffffffff,0x970(%rsp)
  6d0b3f:	movq   $0x0,0xa68(%rsp)
  6d0b4b:	movq   $0x0,0xa78(%rsp)
  6d0b57:	movq   $0x8,0x960(%rsp)
  6d0b63:	movq   $0x0,0x968(%rsp)
  6d0b6f:	movb   $0x0,0xb06(%rsp)
  6d0b77:	movups %xmm0,0xae0(%rsp)
  6d0b7f:	movups %xmm0,0xad0(%rsp)
  6d0b87:	movups %xmm0,0xac0(%rsp)
  6d0b8f:	movups %xmm0,0xab0(%rsp)
  6d0b97:	movups %xmm0,0xaa0(%rsp)
  6d0b9f:	movups %xmm0,0xa90(%rsp)
  6d0ba7:	movups %xmm0,0xa80(%rsp)
  6d0baf:	movq   $0x0,0xaf0(%rsp)
  6d0bbb:	call   *0x34824f(%rip)        # a18e10 <_DYNAMIC+0x248>
  6d0bc1:	mov    $0x748,%edi
  6d0bc6:	mov    $0x8,%esi
  6d0bcb:	call   *0x348247(%rip)        # a18e18 <_DYNAMIC+0x250>
  6d0bd1:	test   %rax,%rax
  6d0bd4:	je     6d1979 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1339>
  6d0bda:	mov    %rax,%rbx
  6d0bdd:	lea    0x3c0(%rsp),%rsi
  6d0be5:	mov    $0x748,%edx
  6d0bea:	mov    %rax,%rdi
  6d0bed:	call   *0x348235(%rip)        # a18e28 <memcpy@GLIBC_2.14>
  6d0bf3:	mov    %rbx,0x8(%rsp)
  6d0bf8:	lea    0x10(%rsp),%rdx
  6d0bfd:	movq   $0x0,(%rsp)
  6d0c05:	lea    0x68(%rsp),%rdi
  6d0c0a:	mov    $0x8,%r8d
  6d0c10:	mov    %rbx,%rsi
  6d0c13:	mov    $0x1,%ecx
  6d0c18:	xor    %r9d,%r9d
  6d0c1b:	call   6d6440 <_RNvMNtNtCs6ZNK6sH19NW_4gpui7runtime4turnINtB4_10RuntimeMutNtCs4gijoeCAvqI_25inspector_pointer_control5ModeluE21describe_with_changedBW_>
  6d0c20:	mov    0x68(%rsp),%r13
  6d0c25:	cmp    $0xfffffffffffffffe,%r13
  6d0c29:	jne    6d1cd3 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1693>
  6d0c2f:	lea    0x68(%rsp),%rdi
  6d0c34:	mov    %rbx,%rsi
  6d0c37:	call   6f85f0 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE7presentBO_>
  6d0c3c:	mov    0x68(%rsp),%r13
  6d0c41:	cmp    $0xfffffffffffffffe,%r13
  6d0c45:	jne    6d1cd3 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1693>
  6d0c4b:	mov    0x8(%rsp),%rdi
  6d0c50:	mov    %rdi,0x8(%rsp)
  6d0c55:	call   6d0540 <_RNvCs4gijoeCAvqI_25inspector_pointer_control3ack>
  6d0c5a:	mov    0x8(%rsp),%rbx
  6d0c5f:	test   %rbx,%rbx
  6d0c62:	je     6d1de4 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x17a4>
  6d0c68:	cmpb   $0x0,0x746(%rbx)
  6d0c6f:	jne    6d1deb <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x17ab>
  6d0c75:	cmpb   $0x1,0x742(%rbx)
  6d0c7c:	jne    6d1df2 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x17b2>
  6d0c82:	mov    0x5a8(%rbx),%r13
  6d0c89:	mov    $0x1a,%eax
  6d0c8e:	mov    %rax,0x10(%rsp)
  6d0c93:	test   %r13,%r13
  6d0c96:	je     6d1dfc <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x17bc>
  6d0c9c:	mov    0x5a0(%rbx),%rbp
  6d0ca3:	shl    $0x6,%r13
  6d0ca7:	lea    0x1e8(%rbx),%r14
  6d0cae:	xor    %r12d,%r12d
  6d0cb1:	mov    0x3481e0(%rip),%r15        # a18e98 <_DYNAMIC+0x2d0>
  6d0cb8:	jmp    6d0ccd <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x68d>
  6d0cba:	nopw   0x0(%rax,%rax,1)
  6d0cc0:	add    $0x40,%r12
  6d0cc4:	cmp    %r12,%r13
  6d0cc7:	je     6d1dfc <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x17bc>
  6d0ccd:	cmpb   $0x4,0x3d(%rbp,%r12,1)
  6d0cd3:	jne    6d0cc0 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x680>
  6d0cd5:	mov    0x20(%rbp,%r12,1),%rsi
  6d0cda:	mov    %r14,%rdi
  6d0cdd:	call   *%r15
  6d0ce0:	test   %al,%al
  6d0ce2:	je     6d0cc0 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x680>
  6d0ce4:	mov    0x20(%rbp,%r12,1),%rsi
  6d0ce9:	add    $0x5d8,%rbx
  6d0cf0:	mov    %rbx,%rdi
  6d0cf3:	call   *0x34832f(%rip)        # a19028 <_DYNAMIC+0x460>
  6d0cf9:	mov    %rax,%r14
  6d0cfc:	lea    0x10(%rsp),%rax
  6d0d01:	mov    0x8(%rsp),%r15
  6d0d06:	test   %r15,%r15
  6d0d09:	je     6d1e42 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1802>
  6d0d0f:	mov    %r15,0xa0(%rsp)
  6d0d17:	mov    %rax,0xa8(%rsp)
  6d0d1f:	cmpb   $0x1,0x746(%r15)
  6d0d27:	je     6d1e5f <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x181f>
  6d0d2d:	cmp    0x5d8(%r15),%r14
  6d0d34:	jne    6d1e70 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1830>
  6d0d3a:	mov    %rdx,%rbx
  6d0d3d:	lea    0x3c0(%rsp),%rdi
  6d0d45:	mov    %r15,%rsi
  6d0d48:	call   6f7de0 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE16resolve_identityBO_>
  6d0d4d:	mov    0x3c0(%rsp),%rax
  6d0d55:	cmp    $0xfffffffffffffffe,%rax
  6d0d59:	jne    6d1e77 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1837>
  6d0d5f:	cmpb   $0x1,0x742(%r15)
  6d0d67:	jne    6d1cb1 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1671>
  6d0d6d:	cmpb   $0x0,0x743(%r15)
  6d0d75:	jne    6d1cb1 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1671>
  6d0d7b:	cmpb   $0x0,0x744(%r15)
  6d0d83:	je     6d1cb1 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1671>
  6d0d89:	cmpq   $0xffffffffffffffff,0x5b0(%r15)
  6d0d91:	jne    6d1cb1 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1671>
  6d0d97:	mov    0x688(%r15),%rax
  6d0d9e:	cmp    0x690(%r15),%rax
  6d0da5:	jne    6d1cb1 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1671>
  6d0dab:	mov    0x6a0(%r15),%rax
  6d0db2:	cmp    0x698(%r15),%rax
  6d0db9:	jne    6d1cb1 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1671>
  6d0dbf:	movss  0x738(%r15),%xmm0
  6d0dc8:	ucomiss 0x73c(%r15),%xmm0
  6d0dd0:	jne    6d1cb1 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1671>
  6d0dd6:	jp     6d1cb1 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1671>
  6d0ddc:	mov    0x5a0(%r15),%r12
  6d0de3:	mov    0x5a8(%r15),%rax
  6d0dea:	lea    -0x38(%r12),%rcx
  6d0def:	shl    $0x6,%rax
  6d0df3:	neg    %rax
  6d0df6:	xor    %ebp,%ebp
  6d0df8:	nopl   0x0(%rax,%rax,1)
  6d0e00:	cmp    %rbp,%rax
  6d0e03:	je     6d1c28 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x15e8>
  6d0e09:	add    $0xffffffffffffffc0,%rbp
  6d0e0d:	lea    0x40(%rcx),%r13
  6d0e11:	cmp    %rbx,0x58(%rcx)
  6d0e15:	mov    %r13,%rcx
  6d0e18:	jne    6d0e00 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x7c0>
  6d0e1a:	mov    0x638(%r15),%rax
  6d0e21:	test   %rax,%rax
  6d0e24:	je     6d0e42 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x802>
  6d0e26:	mov    0x100(%rax),%rsi
  6d0e2d:	test   %rsi,%rsi
  6d0e30:	je     6d0e42 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x802>
  6d0e32:	lea    0x120(%rsp),%rdi
  6d0e3a:	call   *0x348218(%rip)        # a19058 <_DYNAMIC+0x490>
  6d0e40:	jmp    6d0e59 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x819>
  6d0e42:	movq   $0x4,0x120(%rsp)
  6d0e4e:	xorps  %xmm0,%xmm0
  6d0e51:	movups %xmm0,0x128(%rsp)
  6d0e59:	lea    0x120(%rsp),%rdi
  6d0e61:	call   *0x3481f9(%rip)        # a19060 <_DYNAMIC+0x498>
  6d0e67:	mov    %rdx,%rcx
  6d0e6a:	sub    %rbp,%r12
  6d0e6d:	lea    -0x40(%r12),%rsi
  6d0e72:	lea    0x3c0(%rsp),%rdi
  6d0e7a:	mov    %rax,%rdx
  6d0e7d:	call   *0x3481e5(%rip)        # a19068 <_DYNAMIC+0x4a0>
  6d0e83:	cmpb   $0x0,0x3c0(%rsp)
  6d0e8b:	je     6d0ed5 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x895>
  6d0e8d:	lea    0x3c4(%rsp),%rsi
  6d0e95:	movss  0x0(%r13),%xmm0
  6d0e9b:	movss  0x4(%r13),%xmm1
  6d0ea1:	lea    0x68(%rsp),%rdi
  6d0ea6:	call   6ce6d0 <_RNCNvMss_NtCs6ZNK6sH19NW_4gpui7runtimeINtB7_3WinNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE5clicks_0BM_>
  6d0eab:	cmpl   $0x1,0x68(%rsp)
  6d0eb0:	jne    6d0ed5 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x895>
  6d0eb2:	movsd  0x6c(%rsp),%xmm0
  6d0eb8:	movaps %xmm0,%xmm1
  6d0ebb:	shufps $0x55,%xmm0,%xmm1
  6d0ebf:	add    $0xffffffffffffffd0,%r12
  6d0ec3:	mov    %r12,%rdi
  6d0ec6:	movaps %xmm0,0x10(%rsp)
  6d0ecb:	call   *0x34819f(%rip)        # a19070 <_DYNAMIC+0x4a8>
  6d0ed1:	test   %al,%al
  6d0ed3:	jne    6d0f12 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x8d2>
  6d0ed5:	movss  0x10(%r13),%xmm0
  6d0edb:	xorps  %xmm2,%xmm2
  6d0ede:	ucomiss %xmm2,%xmm0
  6d0ee1:	jne    6d0ee9 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x8a9>
  6d0ee3:	jnp    6d1cc2 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1682>
  6d0ee9:	movss  0x14(%r13),%xmm1
  6d0eef:	ucomiss %xmm2,%xmm1
  6d0ef2:	jne    6d0efa <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x8ba>
  6d0ef4:	jnp    6d1cc2 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1682>
  6d0efa:	unpcklps %xmm1,%xmm0
  6d0efd:	mulps  -0x692324(%rip),%xmm0        # 3ebe0 <GCC_except_table0+0x14e8>
  6d0f04:	movsd  0x8(%r13),%xmm1
  6d0f0a:	addps  %xmm0,%xmm1
  6d0f0d:	movaps %xmm1,0x10(%rsp)
  6d0f12:	movq   $0x19,0x3c0(%rsp)
  6d0f1e:	lea    0x3c0(%rsp),%rdi
  6d0f26:	call   6be240 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueNtNtCs6ZNK6sH19NW_4gpui7runtime5ErrorECs4gijoeCAvqI_25inspector_pointer_control>
  6d0f2b:	movaps 0x10(%rsp),%xmm0
  6d0f30:	movaps %xmm0,%xmm1
  6d0f33:	shufps $0x55,%xmm0,%xmm1
  6d0f37:	mov    %r15,%rdi
  6d0f3a:	movaps %xmm1,0x30(%rsp)
  6d0f3f:	call   6f80c0 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_>
  6d0f44:	movq   $0x19,0x3c0(%rsp)
  6d0f50:	test   $0x1,%al
  6d0f52:	je     6d1cc2 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1682>
  6d0f58:	mov    %rdx,%r12
  6d0f5b:	lea    0x3c0(%rsp),%rdi
  6d0f63:	call   6be240 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueNtNtCs6ZNK6sH19NW_4gpui7runtime5ErrorECs4gijoeCAvqI_25inspector_pointer_control>
  6d0f68:	cmp    %rbx,%r12
  6d0f6b:	jne    6d1cc2 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1682>
  6d0f71:	cmp    0x5d8(%r15),%r14
  6d0f78:	jne    6d1ef4 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x18b4>
  6d0f7e:	lea    0x3c0(%rsp),%rdi
  6d0f86:	mov    %r15,%rsi
  6d0f89:	mov    %rbx,%rdx
  6d0f8c:	call   6f7de0 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE16resolve_identityBO_>
  6d0f91:	mov    0x3c0(%rsp),%rax
  6d0f99:	mov    0x3c8(%rsp),%r12
  6d0fa1:	cmp    $0xfffffffffffffffe,%rax
  6d0fa5:	jne    6d1ef9 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x18b9>
  6d0fab:	mov    0x2c8(%r15),%rsi
  6d0fb2:	cmp    %rsi,%r12
  6d0fb5:	jae    6d1f3e <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x18fe>
  6d0fbb:	mov    0x2c0(%r15),%rax
  6d0fc2:	lea    (%r12,%r12,4),%rcx
  6d0fc6:	mov    0x20(%rax,%rcx,8),%edi
  6d0fca:	call   6e1870 <_RNvMsh_NtCs6ZNK6sH19NW_4gpui7runtimeNtB5_4Node4kind>
  6d0fcf:	cmp    $0x4,%al
  6d0fd1:	jne    6d0ff8 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x9b8>
  6d0fd3:	lea    0x120(%rsp),%rdi
  6d0fdb:	mov    %r15,%rsi
  6d0fde:	mov    %r14,%rdx
  6d0fe1:	mov    %rbx,%rcx
  6d0fe4:	movaps 0x10(%rsp),%xmm0
  6d0fe9:	movaps 0x30(%rsp),%xmm1
  6d0fee:	xor    %r8d,%r8d
  6d0ff1:	call   6dafb0 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime7editingINtB7_10RuntimeMutNtCs4gijoeCAvqI_25inspector_pointer_control5ModeluE14select_pointerB12_>
  6d0ff6:	jmp    6d104b <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0xa0b>
  6d0ff8:	mov    0x610(%r15),%r12
  6d0fff:	mov    0x618(%r15),%r13
  6d1006:	lea    0x3c0(%rsp),%rdi
  6d100e:	mov    %r15,%rsi
  6d1011:	mov    %r14,%rdx
  6d1014:	mov    %rbx,%rcx
  6d1017:	call   6dd570 <_RNvMs3_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE5focusBW_>
  6d101c:	mov    0x3c0(%rsp),%rax
  6d1024:	cmp    $0xfffffffffffffffe,%rax
  6d1028:	jne    6d105b <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0xa1b>
  6d102a:	lea    0x120(%rsp),%rdi
  6d1032:	lea    0xa0(%rsp),%rsi
  6d103a:	mov    %r14,%rdx
  6d103d:	mov    %rbx,%rcx
  6d1040:	mov    %r12,%r8
  6d1043:	mov    %r13,%r9
  6d1046:	call   6d2f80 <_RNvMNtNtCs6ZNK6sH19NW_4gpui7runtime4turnINtB4_10RuntimeMutNtCs4gijoeCAvqI_25inspector_pointer_control5ModeluE16activate_focusedBW_>
  6d104b:	cmpq   $0xfffffffffffffffe,0x120(%rsp)
  6d1054:	je     6d10cd <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0xa8d>
  6d1056:	jmp    6d1c34 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x15f4>
  6d105b:	mov    0x3e8(%rsp),%rcx
  6d1063:	movzbl 0x3f0(%rsp),%edx
  6d106b:	mov    0x3f1(%rsp),%esi
  6d1072:	mov    %esi,0x151(%rsp)
  6d1079:	mov    0x3f4(%rsp),%esi
  6d1080:	mov    %esi,0x154(%rsp)
  6d1087:	movups 0x3c8(%rsp),%xmm0
  6d108f:	movups 0x3d8(%rsp),%xmm1
  6d1097:	mov    %rax,0x120(%rsp)
  6d109f:	movups %xmm0,0x128(%rsp)
  6d10a7:	movups %xmm1,0x138(%rsp)
  6d10af:	mov    %rcx,0x148(%rsp)
  6d10b7:	mov    %dl,0x150(%rsp)
  6d10be:	cmpq   $0xfffffffffffffffe,0x120(%rsp)
  6d10c7:	jne    6d1c34 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x15f4>
  6d10cd:	mov    0x8(%rsp),%rdi
  6d10d2:	call   6d0540 <_RNvCs4gijoeCAvqI_25inspector_pointer_control3ack>
  6d10d7:	movsd  -0x692d4f(%rip),%xmm0        # 3e390 <GCC_except_table0+0xc98>
  6d10df:	movsd  %xmm0,0x3c0(%rsp)
  6d10e8:	lea    0x3c0(%rsp),%rax
  6d10f0:	mov    0x8(%rsp),%rbp
  6d10f5:	test   %rbp,%rbp
  6d10f8:	je     6d1f4f <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x190f>
  6d10fe:	cmpb   $0x0,0x746(%rbp)
  6d1105:	jne    6d1f56 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1916>
  6d110b:	mov    $0x12,%eax
  6d1110:	cmpb   $0x1,0x742(%rbp)
  6d1117:	jne    6d1f5b <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x191b>
  6d111d:	cmpb   $0x0,0x743(%rbp)
  6d1124:	jne    6d1f5b <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x191b>
  6d112a:	cmpb   $0x0,0x744(%rbp)
  6d1131:	je     6d1f5b <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x191b>
  6d1137:	cmpq   $0xffffffffffffffff,0x5b0(%rbp)
  6d113f:	jne    6d1f5b <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x191b>
  6d1145:	mov    0x688(%rbp),%rcx
  6d114c:	cmp    0x690(%rbp),%rcx
  6d1153:	jne    6d1f5b <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x191b>
  6d1159:	mov    0x6a0(%rbp),%rbx
  6d1160:	cmp    0x698(%rbp),%rbx
  6d1167:	jne    6d1f5b <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x191b>
  6d116d:	movss  0x738(%rbp),%xmm0
  6d1175:	ucomiss 0x73c(%rbp),%xmm0
  6d117c:	jne    6d1f5b <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x191b>
  6d1182:	jp     6d1f5b <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x191b>
  6d1188:	movsd  0x3c0(%rsp),%xmm0
  6d1191:	movaps %xmm0,0x40(%rsp)
  6d1196:	mov    0x6c0(%rbp),%rax
  6d119d:	mov    %rax,0x50(%rsp)
  6d11a2:	mov    0x5a0(%rbp),%rax
  6d11a9:	mov    %rax,0x10(%rsp)
  6d11ae:	mov    0x5a8(%rbp),%r12
  6d11b5:	movups 0x610(%rbp),%xmm0
  6d11bc:	movaps %xmm0,0x30(%rsp)
  6d11c1:	mov    0x638(%rbp),%r13
  6d11c8:	test   %r13,%r13
  6d11cb:	je     6d1219 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0xbd9>
  6d11cd:	mov    0xe0(%r13),%rax
  6d11d4:	test   %rax,%rax
  6d11d7:	je     6d1238 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0xbf8>
  6d11d9:	mov    0x38(%rax),%ecx
  6d11dc:	mov    %ecx,0xb20(%rsp)
  6d11e3:	movups 0x28(%rax),%xmm0
  6d11e7:	movaps %xmm0,0xb10(%rsp)
  6d11ef:	movzbl 0x3c(%rax),%r15d
  6d11f4:	movzbl 0x3f(%rax),%ecx
  6d11f8:	mov    %cl,0xa2(%rsp)
  6d11ff:	movzwl 0x3d(%rax),%eax
  6d1203:	mov    %ax,0xa0(%rsp)
  6d120b:	mov    0x100(%r13),%rsi
  6d1212:	test   %rsi,%rsi
  6d1215:	jne    6d1247 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0xc07>
  6d1217:	jmp    6d121c <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0xbdc>
  6d1219:	mov    $0x2,%r15b
  6d121c:	movq   $0x4,0x120(%rsp)
  6d1228:	xorps  %xmm0,%xmm0
  6d122b:	movups %xmm0,0x128(%rsp)
  6d1233:	mov    %r12,%r14
  6d1236:	jmp    6d125c <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0xc1c>
  6d1238:	mov    $0x2,%r15b
  6d123b:	mov    0x100(%r13),%rsi
  6d1242:	test   %rsi,%rsi
  6d1245:	je     6d121c <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0xbdc>
  6d1247:	lea    0x120(%rsp),%rdi
  6d124f:	call   *0x347e03(%rip)        # a19058 <_DYNAMIC+0x490>
  6d1255:	mov    0x5a8(%rbp),%r14
  6d125c:	lea    0x5d8(%rbp),%rax
  6d1263:	mov    %rax,0x108(%rsp)
  6d126b:	mov    %rax,0x410(%rsp)
  6d1273:	mov    0x50(%rsp),%rax
  6d1278:	mov    %rax,0x3e0(%rsp)
  6d1280:	mov    %rbx,0x3e8(%rsp)
  6d1288:	mov    0x10(%rsp),%rax
  6d128d:	mov    %rax,0x3d0(%rsp)
  6d1295:	mov    %r12,0x3d8(%rsp)
  6d129d:	movaps 0x30(%rsp),%xmm0
  6d12a2:	movaps %xmm0,0x3c0(%rsp)
  6d12aa:	mov    %r13,0x3f0(%rsp)
  6d12b2:	mov    0x120(%rsp),%rax
  6d12ba:	mov    %rax,0x3f8(%rsp)
  6d12c2:	mov    0x128(%rsp),%rax
  6d12ca:	mov    %rax,0x400(%rsp)
  6d12d2:	mov    0x130(%rsp),%rax
  6d12da:	mov    %rax,0x408(%rsp)
  6d12e2:	movaps 0xb10(%rsp),%xmm0
  6d12ea:	movups %xmm0,0x418(%rsp)
  6d12f2:	mov    0xb20(%rsp),%eax
  6d12f9:	mov    %eax,0x428(%rsp)
  6d1300:	mov    %r15b,0x42c(%rsp)
  6d1308:	movzwl 0xa0(%rsp),%eax
  6d1310:	mov    %ax,0x42d(%rsp)
  6d1318:	movzbl 0xa2(%rsp),%eax
  6d1320:	mov    %al,0x42f(%rsp)
  6d1327:	test   %r14,%r14
  6d132a:	je     6d1d4c <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x170c>
  6d1330:	movaps 0x40(%rsp),%xmm0
  6d1335:	shufps $0x55,%xmm0,%xmm0
  6d1339:	movaps %xmm0,0x50(%rsp)
  6d133e:	mov    $0x20,%r13d
  6d1344:	xor    %r12d,%r12d
  6d1347:	lea    0x3c0(%rsp),%r15
  6d134f:	mov    0x347d22(%rip),%rbx        # a19078 <_DYNAMIC+0x4b0>
  6d1356:	lea    0x328c8b(%rip),%rax        # 9f9fe8 <__frame_dummy_init_array_entry+0xbd8>
  6d135d:	mov    %rax,0x60(%rsp)
  6d1362:	movq   $0x0,0x30(%rsp)
  6d136b:	movq   $0x0,0x10(%rsp)
  6d1374:	jmp    6d139c <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0xd5c>
  6d1376:	mov    0x5a0(%rbp),%rax
  6d137d:	incq   0x10(%rsp)
  6d1382:	mov    (%rax,%r13,1),%rax
  6d1386:	mov    %rax,0x30(%rsp)
  6d138b:	nopl   0x0(%rax,%rax,1)
  6d1390:	inc    %r12
  6d1393:	add    $0x40,%r13
  6d1397:	cmp    %r12,%r14
  6d139a:	je     6d13eb <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0xdab>
  6d139c:	mov    %r15,%rdi
  6d139f:	mov    %r12,%rsi
  6d13a2:	call   *%rbx
  6d13a4:	test   %rax,%rax
  6d13a7:	setne  %cl
  6d13aa:	cmp    $0x5,%rdx
  6d13ae:	sete   %dl
  6d13b1:	and    %cl,%dl
  6d13b3:	cmp    $0x1,%dl
  6d13b6:	jne    6d1390 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0xd50>
  6d13b8:	mov    (%rax),%ecx
  6d13ba:	mov    $0x63656863,%edx
  6d13bf:	xor    %edx,%ecx
  6d13c1:	movzbl 0x4(%rax),%eax
  6d13c5:	xor    $0x6b,%eax
  6d13c8:	or     %ecx,%eax
  6d13ca:	jne    6d1390 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0xd50>
  6d13cc:	mov    0x5a8(%rbp),%rsi
  6d13d3:	cmp    %rsi,%r12
  6d13d6:	jb     6d1376 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0xd36>
  6d13d8:	mov    %r12,%rdi
  6d13db:	mov    0x60(%rsp),%rdx
  6d13e0:	call   *0x347a52(%rip)        # a18e38 <_DYNAMIC+0x270>
  6d13e6:	jmp    6d2150 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b10>
  6d13eb:	mov    0x10(%rsp),%rcx
  6d13f0:	cmp    $0x1,%rcx
  6d13f4:	jne    6d1d3e <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x16fe>
  6d13fa:	mov    0x108(%rsp),%rdi
  6d1402:	mov    0x30(%rsp),%rsi
  6d1407:	call   *0x347c1b(%rip)        # a19028 <_DYNAMIC+0x460>
  6d140d:	mov    %rax,%r14
  6d1410:	mov    %rdx,%rbx
  6d1413:	lea    0x8(%rsp),%rax
  6d1418:	mov    %rax,0x3c0(%rsp)
  6d1420:	lea    0x3c0(%rsp),%r12
  6d1428:	mov    0x3c0(%rsp),%rax
  6d1430:	mov    (%rax),%rsi
  6d1433:	lea    0x120(%rsp),%rdi
  6d143b:	movaps 0x40(%rsp),%xmm0
  6d1440:	movaps 0x50(%rsp),%xmm1
  6d1445:	call   6d2eb0 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8hit_only>
  6d144a:	cmpl   $0xfffffffe,0x120(%rsp)
  6d1452:	jne    6d198e <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x134e>
  6d1458:	mov    0x128(%rsp),%rdx
  6d1460:	mov    0x130(%rsp),%rax
  6d1468:	mov    %rdx,0x3c0(%rsp)
  6d1470:	mov    %rax,0x3c8(%rsp)
  6d1478:	mov    %r14,0x110(%rsp)
  6d1480:	mov    %rbx,0x118(%rsp)
  6d1488:	cmp    %r14,%rdx
  6d148b:	sete   %cl
  6d148e:	test   %rdx,%rdx
  6d1491:	je     6d1904 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x12c4>
  6d1497:	lea    0x328922(%rip),%rdx        # 9f9dc0 <__frame_dummy_init_array_entry+0x9b0>
  6d149e:	lea    0x110(%rsp),%r15
  6d14a6:	test   %cl,%cl
  6d14a8:	je     6d1a76 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1436>
  6d14ae:	cmp    %rbx,%rax
  6d14b1:	jne    6d1a76 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1436>
  6d14b7:	movsd  -0x692b3f(%rip),%xmm0        # 3e980 <GCC_except_table0+0x1288>
  6d14bf:	movsd  %xmm0,0x3c0(%rsp)
  6d14c8:	lea    0x3c0(%rsp),%r12
  6d14d0:	movss  0x3c0(%rsp),%xmm0
  6d14d9:	movss  0x3c4(%rsp),%xmm1
  6d14e2:	mov    0x8(%rsp),%rsi
  6d14e7:	lea    0x120(%rsp),%rdi
  6d14ef:	call   6d2eb0 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8hit_only>
  6d14f4:	cmpl   $0xfffffffe,0x120(%rsp)
  6d14fc:	jne    6d19fb <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x13bb>
  6d1502:	movups 0x128(%rsp),%xmm0
  6d150a:	movaps %xmm0,0x3c0(%rsp)
  6d1512:	cmpq   $0x0,0x128(%rsp)
  6d151b:	jne    6d1a68 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1428>
  6d1521:	mov    $0xffffffff,%eax
  6d1526:	mov    %rax,0xb10(%rsp)
  6d152e:	movq   $0x0,0xb18(%rsp)
  6d153a:	movaps 0x40(%rsp),%xmm0
  6d153f:	movlps %xmm0,0x3c4(%rsp)
  6d1547:	movl   $0x0,0x3c0(%rsp)
  6d1552:	lea    0x3c0(%rsp),%rcx
  6d155a:	lea    0x120(%rsp),%rdi
  6d1562:	lea    0x8(%rsp),%rsi
  6d1567:	lea    0xb10(%rsp),%rdx
  6d156f:	call   6d2210 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch>
  6d1574:	cmpl   $0xfffffffe,0x120(%rsp)
  6d157c:	jne    6d1897 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1257>
  6d1582:	movl   $0x2,0x3c0(%rsp)
  6d158d:	lea    0x3c0(%rsp),%rcx
  6d1595:	lea    0x120(%rsp),%rdi
  6d159d:	lea    0x8(%rsp),%rsi
  6d15a2:	lea    0xb10(%rsp),%rdx
  6d15aa:	call   6d2210 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch>
  6d15af:	cmpl   $0xfffffffe,0x120(%rsp)
  6d15b7:	jne    6d1897 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1257>
  6d15bd:	movl   $0x3,0x3c0(%rsp)
  6d15c8:	lea    0x3c0(%rsp),%r15
  6d15d0:	lea    0x120(%rsp),%rdi
  6d15d8:	lea    0x8(%rsp),%rsi
  6d15dd:	lea    0xb10(%rsp),%rdx
  6d15e5:	mov    %r15,%rcx
  6d15e8:	call   6d2210 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch>
  6d15ed:	cmpl   $0xfffffffe,0x120(%rsp)
  6d15f5:	jne    6d1897 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1257>
  6d15fb:	mov    0x8(%rsp),%rsi
  6d1600:	test   %rsi,%rsi
  6d1603:	je     6d1a86 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1446>
  6d1609:	cmpq   $0x1,0x2b0(%rsi)
  6d1611:	jne    6d1acb <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x148b>
  6d1617:	mov    %rsi,%rdi
  6d161a:	call   6d0540 <_RNvCs4gijoeCAvqI_25inspector_pointer_control3ack>
  6d161f:	mov    0x8(%rsp),%rsi
  6d1624:	lea    0x120(%rsp),%rdi
  6d162c:	movaps 0x40(%rsp),%xmm0
  6d1631:	movaps 0x50(%rsp),%xmm1
  6d1636:	call   6d2eb0 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8hit_only>
  6d163b:	cmpl   $0xfffffffe,0x120(%rsp)
  6d1643:	jne    6d1ae5 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x14a5>
  6d1649:	mov    0x128(%rsp),%rdx
  6d1651:	mov    0x130(%rsp),%rax
  6d1659:	mov    %rdx,0xa0(%rsp)
  6d1661:	mov    %rax,0xa8(%rsp)
  6d1669:	mov    %r14,0x3c0(%rsp)
  6d1671:	mov    %rbx,0x3c8(%rsp)
  6d1679:	cmp    %r14,%rdx
  6d167c:	sete   %cl
  6d167f:	test   %rdx,%rdx
  6d1682:	je     6d1922 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x12e2>
  6d1688:	lea    0x328791(%rip),%rdx        # 9f9e20 <__frame_dummy_init_array_entry+0xa10>
  6d168f:	lea    0xa0(%rsp),%r12
  6d1697:	test   %cl,%cl
  6d1699:	je     6d1a76 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1436>
  6d169f:	cmp    %rbx,%rax
  6d16a2:	jne    6d1a76 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1436>
  6d16a8:	movaps 0x40(%rsp),%xmm0
  6d16ad:	movlps %xmm0,0x3c0(%rsp)
  6d16b5:	lea    0x3c0(%rsp),%rax
  6d16bd:	movss  0x3c0(%rsp),%xmm0
  6d16c6:	movss  0x3c4(%rsp),%xmm1
  6d16cf:	lea    0x120(%rsp),%rbx
  6d16d7:	lea    0x8(%rsp),%rsi
  6d16dc:	mov    %rbx,%rdi
  6d16df:	call   6d0250 <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only>
  6d16e4:	cmpl   $0xfffffffe,0x120(%rsp)
  6d16ec:	jne    6d1b52 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1512>
  6d16f2:	mov    0x8(%rsp),%rdi
  6d16f7:	call   6d0540 <_RNvCs4gijoeCAvqI_25inspector_pointer_control3ack>
  6d16fc:	mov    0x8(%rsp),%rsi
  6d1701:	test   %rsi,%rsi
  6d1704:	je     6d1bbf <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x157f>
  6d170a:	cmpq   $0x2,0x2b0(%rsi)
  6d1712:	jne    6d1c04 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x15c4>
  6d1718:	mov    0xb10(%rsp),%eax
  6d171f:	cmp    $0xffffffff,%eax
  6d1722:	je     6d1742 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1102>
  6d1724:	dec    %eax
  6d1726:	mov    0xb14(%rsp),%ecx
  6d172d:	mov    %eax,0x124(%rsp)
  6d1734:	mov    %ecx,0x128(%rsp)
  6d173b:	mov    $0x1,%eax
  6d1740:	jmp    6d1744 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1104>
  6d1742:	xor    %eax,%eax
  6d1744:	mov    %eax,0x120(%rsp)
  6d174b:	movl   $0x42500000,0x3c8(%rsp)
  6d1756:	movabs $0x4140000000000001,%rcx
  6d1760:	mov    %rcx,0x3c0(%rsp)
  6d1768:	movabs $0x4250000041400000,%rcx
  6d1772:	cmp    %rcx,0x124(%rsp)
  6d177a:	sete   %cl
  6d177d:	test   %eax,%eax
  6d177f:	je     6d1940 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1300>
  6d1785:	test   %cl,%cl
  6d1787:	je     6d194a <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x130a>
  6d178d:	movaps 0x40(%rsp),%xmm0
  6d1792:	movss  %xmm0,0xa0(%rsp)
  6d179b:	movaps 0x50(%rsp),%xmm0
  6d17a0:	movss  %xmm0,0x120(%rsp)
  6d17a9:	lea    0xa0(%rsp),%rax
  6d17b1:	mov    %rax,0x3c0(%rsp)
  6d17b9:	mov    0x3478c0(%rip),%rax        # a19080 <_DYNAMIC+0x4b8>
  6d17c0:	mov    %rax,0x3c8(%rsp)
  6d17c8:	mov    %rbx,0x3d0(%rsp)
  6d17d0:	mov    %rax,0x3d8(%rsp)
  6d17d8:	lea    -0x69274f(%rip),%rax        # 3f090 <GCC_except_table0+0x1998>
  6d17df:	mov    %rax,0x3e0(%rsp)
  6d17e7:	mov    0x34789a(%rip),%rcx        # a19088 <_DYNAMIC+0x4c0>
  6d17ee:	mov    %rcx,0x3e8(%rsp)
  6d17f6:	mov    %rax,0x3f0(%rsp)
  6d17fe:	mov    %rcx,0x3f8(%rsp)
  6d1806:	lea    -0x6926b5(%rip),%rax        # 3f158 <GCC_except_table0+0x1a60>
  6d180d:	mov    %rax,0x400(%rsp)
  6d1815:	mov    %rcx,0x408(%rsp)
  6d181d:	lea    -0x6928ec(%rip),%rax        # 3ef38 <GCC_except_table0+0x1840>
  6d1824:	mov    %rax,0x410(%rsp)
  6d182c:	mov    %rcx,0x418(%rsp)
  6d1834:	lea    -0x6925f3(%rip),%rax        # 3f248 <GCC_except_table0+0x1b50>
  6d183b:	mov    %rax,0x420(%rsp)
  6d1843:	mov    %rcx,0x428(%rsp)
  6d184b:	lea    -0x6894aa(%rip),%rdi        # 483a8 <GCC_except_table0+0xacb0>
  6d1852:	lea    0x3c0(%rsp),%rsi
  6d185a:	call   *0x347830(%rip)        # a19090 <_DYNAMIC+0x4c8>
  6d1860:	mov    0x8(%rsp),%rbx
  6d1865:	test   %rbx,%rbx
  6d1868:	je     6d1885 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1245>
  6d186a:	mov    %rbx,%rdi
  6d186d:	call   6b9630 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtCs6ZNK6sH19NW_4gpui7runtime7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelEEB1h_>
  6d1872:	mov    $0x748,%esi
  6d1877:	mov    $0x8,%edx
  6d187c:	mov    %rbx,%rdi
  6d187f:	call   *0x347583(%rip)        # a18e08 <_DYNAMIC+0x240>
  6d1885:	add    $0xcf8,%rsp
  6d188c:	pop    %rbx
  6d188d:	pop    %r12
  6d188f:	pop    %r13
  6d1891:	pop    %r14
  6d1893:	pop    %r15
  6d1895:	pop    %rbp
  6d1896:	ret
  6d1897:	mov    0x150(%rsp),%rax
  6d189f:	mov    %rax,0x3f0(%rsp)
  6d18a7:	movups 0x120(%rsp),%xmm0
  6d18af:	movups 0x130(%rsp),%xmm1
  6d18b7:	movups 0x140(%rsp),%xmm2
  6d18bf:	movaps %xmm2,0x3e0(%rsp)
  6d18c7:	movaps %xmm1,0x3d0(%rsp)
  6d18cf:	movaps %xmm0,0x3c0(%rsp)
  6d18d7:	lea    -0x6871c4(%rip),%rdi        # 4a71a <GCC_except_table0+0xd022>
  6d18de:	lea    0x328613(%rip),%rcx        # 9f9ef8 <__frame_dummy_init_array_entry+0xae8>
  6d18e5:	lea    0x3285c4(%rip),%r8        # 9f9eb0 <__frame_dummy_init_array_entry+0xaa0>
  6d18ec:	lea    0x3c0(%rsp),%rdx
  6d18f4:	mov    $0x2b,%esi
  6d18f9:	call   *0x3475b9(%rip)        # a18eb8 <_DYNAMIC+0x2f0>
  6d18ff:	jmp    6d2150 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b10>
  6d1904:	xor    %ecx,%ecx
  6d1906:	lea    0x3284b3(%rip),%rdx        # 9f9dc0 <__frame_dummy_init_array_entry+0x9b0>
  6d190d:	lea    0x110(%rsp),%r15
  6d1915:	test   %cl,%cl
  6d1917:	jne    6d14ae <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0xe6e>
  6d191d:	jmp    6d1a76 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1436>
  6d1922:	xor    %ecx,%ecx
  6d1924:	lea    0x3284f5(%rip),%rdx        # 9f9e20 <__frame_dummy_init_array_entry+0xa10>
  6d192b:	lea    0xa0(%rsp),%r12
  6d1933:	test   %cl,%cl
  6d1935:	jne    6d169f <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x105f>
  6d193b:	jmp    6d1a76 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1436>
  6d1940:	xor    %ecx,%ecx
  6d1942:	test   %cl,%cl
  6d1944:	jne    6d178d <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x114d>
  6d194a:	lea    0x120(%rsp),%rdi
  6d1952:	lea    0x3c0(%rsp),%rsi
  6d195a:	call   6c140b <_RINvNtCs4NRVxsYgnAr_4core9panicking13assert_failedINtNtB4_6option6OptionAmj2_EBM_ECs4gijoeCAvqI_25inspector_pointer_control>
  6d195f:	jmp    6d2150 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b10>
  6d1964:	mov    $0x8,%edi
  6d1969:	mov    $0x28,%esi
  6d196e:	call   *0x3474ac(%rip)        # a18e20 <_DYNAMIC+0x258>
  6d1974:	jmp    6d2150 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b10>
  6d1979:	mov    $0x8,%edi
  6d197e:	mov    $0x748,%esi
  6d1983:	call   *0x347497(%rip)        # a18e20 <_DYNAMIC+0x258>
  6d1989:	jmp    6d2150 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b10>
  6d198e:	mov    0x150(%rsp),%rax
  6d1996:	mov    %rax,0x3f0(%rsp)
  6d199e:	movups 0x120(%rsp),%xmm0
  6d19a6:	movups 0x130(%rsp),%xmm1
  6d19ae:	movups 0x140(%rsp),%xmm2
  6d19b6:	movaps %xmm2,0x3e0(%rsp)
  6d19be:	movaps %xmm1,0x3d0(%rsp)
  6d19c6:	movaps %xmm0,0x3c0(%rsp)
  6d19ce:	lea    -0x6872bb(%rip),%rdi        # 4a71a <GCC_except_table0+0xd022>
  6d19d5:	lea    0x32851c(%rip),%rcx        # 9f9ef8 <__frame_dummy_init_array_entry+0xae8>
  6d19dc:	lea    0x3283c5(%rip),%r8        # 9f9da8 <__frame_dummy_init_array_entry+0x998>
  6d19e3:	lea    0x3c0(%rsp),%rdx
  6d19eb:	mov    $0x2b,%esi
  6d19f0:	call   *0x3474c2(%rip)        # a18eb8 <_DYNAMIC+0x2f0>
  6d19f6:	jmp    6d2150 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b10>
  6d19fb:	mov    0x150(%rsp),%rax
  6d1a03:	mov    %rax,0x3f0(%rsp)
  6d1a0b:	movups 0x120(%rsp),%xmm0
  6d1a13:	movups 0x130(%rsp),%xmm1
  6d1a1b:	movups 0x140(%rsp),%xmm2
  6d1a23:	movaps %xmm2,0x3e0(%rsp)
  6d1a2b:	movaps %xmm1,0x3d0(%rsp)
  6d1a33:	movaps %xmm0,0x3c0(%rsp)
  6d1a3b:	lea    -0x687328(%rip),%rdi        # 4a71a <GCC_except_table0+0xd022>
  6d1a42:	lea    0x3284af(%rip),%rcx        # 9f9ef8 <__frame_dummy_init_array_entry+0xae8>
  6d1a49:	lea    0x328388(%rip),%r8        # 9f9dd8 <__frame_dummy_init_array_entry+0x9c8>
  6d1a50:	lea    0x3c0(%rsp),%rdx
  6d1a58:	mov    $0x2b,%esi
  6d1a5d:	call   *0x347455(%rip)        # a18eb8 <_DYNAMIC+0x2f0>
  6d1a63:	jmp    6d2150 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b10>
  6d1a68:	lea    0x328459(%rip),%rdx        # 9f9ec8 <__frame_dummy_init_array_entry+0xab8>
  6d1a6f:	lea    -0x6930d6(%rip),%r15        # 3e9a0 <GCC_except_table0+0x12a8>
  6d1a76:	mov    %r12,%rdi
  6d1a79:	mov    %r15,%rsi
  6d1a7c:	call   6c1443 <_RINvNtCs4NRVxsYgnAr_4core9panicking13assert_failedINtNtB4_6option6OptionNtNtCs6ZNK6sH19NW_4gpui8identity6TargetEBM_ECs4gijoeCAvqI_25inspector_pointer_control>
  6d1a81:	jmp    6d2150 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b10>
  6d1a86:	movq   $0xd,0x3c0(%rsp)
  6d1a92:	movq   $0x0,0x3c8(%rsp)
  6d1a9e:	lea    -0x68738b(%rip),%rdi        # 4a71a <GCC_except_table0+0xd022>
  6d1aa5:	lea    0x32844c(%rip),%rcx        # 9f9ef8 <__frame_dummy_init_array_entry+0xae8>
  6d1aac:	lea    0x32833d(%rip),%r8        # 9f9df0 <__frame_dummy_init_array_entry+0x9e0>
  6d1ab3:	lea    0x3c0(%rsp),%rdx
  6d1abb:	mov    $0x2b,%esi
  6d1ac0:	call   *0x3473f2(%rip)        # a18eb8 <_DYNAMIC+0x2f0>
  6d1ac6:	jmp    6d2150 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b10>
  6d1acb:	add    $0x2b0,%rsi
  6d1ad2:	lea    0x3283bf(%rip),%r9        # 9f9e98 <__frame_dummy_init_array_entry+0xa88>
  6d1ad9:	lea    -0x692a70(%rip),%rdx        # 3f070 <GCC_except_table0+0x1978>
  6d1ae0:	jmp    6d1c19 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x15d9>
  6d1ae5:	mov    0x150(%rsp),%rax
  6d1aed:	mov    %rax,0x3f0(%rsp)
  6d1af5:	movups 0x120(%rsp),%xmm0
  6d1afd:	movups 0x130(%rsp),%xmm1
  6d1b05:	movups 0x140(%rsp),%xmm2
  6d1b0d:	movaps %xmm2,0x3e0(%rsp)
  6d1b15:	movaps %xmm1,0x3d0(%rsp)
  6d1b1d:	movaps %xmm0,0x3c0(%rsp)
  6d1b25:	lea    -0x687412(%rip),%rdi        # 4a71a <GCC_except_table0+0xd022>
  6d1b2c:	lea    0x3283c5(%rip),%rcx        # 9f9ef8 <__frame_dummy_init_array_entry+0xae8>
  6d1b33:	lea    0x3282ce(%rip),%r8        # 9f9e08 <__frame_dummy_init_array_entry+0x9f8>
  6d1b3a:	lea    0x3c0(%rsp),%rdx
  6d1b42:	mov    $0x2b,%esi
  6d1b47:	call   *0x34736b(%rip)        # a18eb8 <_DYNAMIC+0x2f0>
  6d1b4d:	jmp    6d2150 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b10>
  6d1b52:	mov    0x150(%rsp),%rax
  6d1b5a:	mov    %rax,0x3f0(%rsp)
  6d1b62:	movups 0x120(%rsp),%xmm0
  6d1b6a:	movups 0x130(%rsp),%xmm1
  6d1b72:	movups 0x140(%rsp),%xmm2
  6d1b7a:	movaps %xmm2,0x3e0(%rsp)
  6d1b82:	movaps %xmm1,0x3d0(%rsp)
  6d1b8a:	movaps %xmm0,0x3c0(%rsp)
  6d1b92:	lea    -0x68747f(%rip),%rdi        # 4a71a <GCC_except_table0+0xd022>
  6d1b99:	lea    0x328358(%rip),%rcx        # 9f9ef8 <__frame_dummy_init_array_entry+0xae8>
  6d1ba0:	lea    0x328291(%rip),%r8        # 9f9e38 <__frame_dummy_init_array_entry+0xa28>
  6d1ba7:	lea    0x3c0(%rsp),%rdx
  6d1baf:	mov    $0x2b,%esi
  6d1bb4:	call   *0x3472fe(%rip)        # a18eb8 <_DYNAMIC+0x2f0>
  6d1bba:	jmp    6d2150 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b10>
  6d1bbf:	movq   $0xd,0x3c0(%rsp)
  6d1bcb:	movq   $0x0,0x3c8(%rsp)
  6d1bd7:	lea    -0x6874c4(%rip),%rdi        # 4a71a <GCC_except_table0+0xd022>
  6d1bde:	lea    0x328313(%rip),%rcx        # 9f9ef8 <__frame_dummy_init_array_entry+0xae8>
  6d1be5:	lea    0x328264(%rip),%r8        # 9f9e50 <__frame_dummy_init_array_entry+0xa40>
  6d1bec:	lea    0x3c0(%rsp),%rdx
  6d1bf4:	mov    $0x2b,%esi
  6d1bf9:	call   *0x3472b9(%rip)        # a18eb8 <_DYNAMIC+0x2f0>
  6d1bff:	jmp    6d2150 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b10>
  6d1c04:	add    $0x2b0,%rsi
  6d1c0b:	lea    0x32826e(%rip),%r9        # 9f9e80 <__frame_dummy_init_array_entry+0xa70>
  6d1c12:	lea    -0x692af9(%rip),%rdx        # 3f120 <GCC_except_table0+0x1a28>
  6d1c19:	xor    %edi,%edi
  6d1c1b:	xor    %ecx,%ecx
  6d1c1d:	call   *0x347475(%rip)        # a19098 <_DYNAMIC+0x4d0>
  6d1c23:	jmp    6d2150 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b10>
  6d1c28:	movq   $0x11,0x120(%rsp)
  6d1c34:	mov    0x150(%rsp),%rax
  6d1c3c:	mov    %rax,0x3f0(%rsp)
  6d1c44:	mov    0x120(%rsp),%rax
  6d1c4c:	mov    0x128(%rsp),%rcx
  6d1c54:	movups 0x130(%rsp),%xmm0
  6d1c5c:	movups 0x140(%rsp),%xmm1
  6d1c64:	movaps %xmm1,0x3e0(%rsp)
  6d1c6c:	movaps %xmm0,0x3d0(%rsp)
  6d1c74:	mov    %rax,0x3c0(%rsp)
  6d1c7c:	mov    %rcx,0x3c8(%rsp)
  6d1c84:	lea    -0x687571(%rip),%rdi        # 4a71a <GCC_except_table0+0xd022>
  6d1c8b:	lea    0x328266(%rip),%rcx        # 9f9ef8 <__frame_dummy_init_array_entry+0xae8>
  6d1c92:	lea    0x3280df(%rip),%r8        # 9f9d78 <__frame_dummy_init_array_entry+0x968>
  6d1c99:	lea    0x3c0(%rsp),%rdx
  6d1ca1:	mov    $0x2b,%esi
  6d1ca6:	call   *0x34720c(%rip)        # a18eb8 <_DYNAMIC+0x2f0>
  6d1cac:	jmp    6d2150 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b10>
  6d1cb1:	movq   $0x12,0x120(%rsp)
  6d1cbd:	jmp    6d1c34 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x15f4>
  6d1cc2:	movq   $0x19,0x120(%rsp)
  6d1cce:	jmp    6d1c34 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x15f4>
  6d1cd3:	mov    0x70(%rsp),%r15
  6d1cd8:	movups 0x78(%rsp),%xmm0
  6d1cdd:	movaps %xmm0,0x10(%rsp)
  6d1ce2:	movups 0x88(%rsp),%xmm0
  6d1cea:	movaps %xmm0,0x30(%rsp)
  6d1cef:	movzbl 0x98(%rsp),%ebp
  6d1cf7:	mov    0x99(%rsp),%eax
  6d1cfe:	mov    %eax,0x28(%rsp)
  6d1d02:	mov    0x9c(%rsp),%eax
  6d1d09:	mov    %eax,0x2b(%rsp)
  6d1d0d:	mov    0x8(%rsp),%rbx
  6d1d12:	test   %rbx,%rbx
  6d1d15:	je     6d1d32 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x16f2>
  6d1d17:	mov    %rbx,%rdi
  6d1d1a:	call   6b9630 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtCs6ZNK6sH19NW_4gpui7runtime7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelEEB1h_>
  6d1d1f:	mov    $0x748,%esi
  6d1d24:	mov    $0x8,%edx
  6d1d29:	mov    %rbx,%rdi
  6d1d2c:	call   *0x3470d6(%rip)        # a18e08 <_DYNAMIC+0x240>
  6d1d32:	mov    %r15,%r12
  6d1d35:	shr    $0x20,%r12
  6d1d39:	jmp    6d1dd5 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1795>
  6d1d3e:	mov    $0x1b,%eax
  6d1d43:	test   %rcx,%rcx
  6d1d46:	jne    6d1f5b <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x191b>
  6d1d4c:	mov    $0x1a,%eax
  6d1d51:	jmp    6d1f5b <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x191b>
  6d1d56:	mov    $0x1,%edi
  6d1d5b:	mov    $0x6,%esi
  6d1d60:	call   *0x34712a(%rip)        # a18e90 <_DYNAMIC+0x2c8>
  6d1d66:	mov    0x3c8(%rsp),%r15
  6d1d6e:	mov    %r15,%r12
  6d1d71:	shr    $0x20,%r12
  6d1d75:	movups 0x3d0(%rsp),%xmm0
  6d1d7d:	movaps %xmm0,0x10(%rsp)
  6d1d82:	movups 0x3e0(%rsp),%xmm0
  6d1d8a:	movaps %xmm0,0x30(%rsp)
  6d1d8f:	movzbl 0x3f0(%rsp),%ebp
  6d1d97:	mov    0x3f1(%rsp),%eax
  6d1d9e:	mov    %eax,0x28(%rsp)
  6d1da2:	mov    0x3f4(%rsp),%eax
  6d1da9:	mov    %eax,0x2b(%rsp)
  6d1dad:	jmp    6d1dc2 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1782>
  6d1daf:	lea    0xa0(%rsp),%rdi
  6d1db7:	call   6b9480 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtCs6ZNK6sH19NW_4gpui6source7SourcesNtCs4gijoeCAvqI_25inspector_pointer_control5ModelEEB1g_>
  6d1dbc:	mov    $0x23,%r13d
  6d1dc2:	mov    $0x6,%esi
  6d1dc7:	mov    $0x1,%edx
  6d1dcc:	mov    %rbx,%rdi
  6d1dcf:	call   *0x347033(%rip)        # a18e08 <_DYNAMIC+0x240>
  6d1dd5:	movaps 0x10(%rsp),%xmm0
  6d1dda:	movaps 0x30(%rsp),%xmm1
  6d1ddf:	jmp    6d20e0 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1aa0>
  6d1de4:	mov    $0xd,%eax
  6d1de9:	jmp    6d1df7 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x17b7>
  6d1deb:	mov    $0xe,%eax
  6d1df0:	jmp    6d1df7 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x17b7>
  6d1df2:	mov    $0x12,%eax
  6d1df7:	mov    %rax,0x10(%rsp)
  6d1dfc:	mov    0x10(%rsp),%rax
  6d1e01:	mov    %rax,0x3c0(%rsp)
  6d1e09:	movq   $0x0,0x3c8(%rsp)
  6d1e15:	lea    -0x68773a(%rip),%rdi        # 4a6e2 <GCC_except_table0+0xcfea>
  6d1e1c:	lea    0x3280d5(%rip),%rcx        # 9f9ef8 <__frame_dummy_init_array_entry+0xae8>
  6d1e23:	lea    0x327f36(%rip),%r8        # 9f9d60 <__frame_dummy_init_array_entry+0x950>
  6d1e2a:	lea    0x3c0(%rsp),%rdx
  6d1e32:	mov    $0x2a,%esi
  6d1e37:	call   *0x34707b(%rip)        # a18eb8 <_DYNAMIC+0x2f0>
  6d1e3d:	jmp    6d2150 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b10>
  6d1e42:	movq   $0xd,0x120(%rsp)
  6d1e4e:	movq   $0x0,0x128(%rsp)
  6d1e5a:	jmp    6d1c34 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x15f4>
  6d1e5f:	movq   $0xe,0x120(%rsp)
  6d1e6b:	jmp    6d1c34 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x15f4>
  6d1e70:	mov    $0x11,%eax
  6d1e75:	jmp    6d1eaf <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x186f>
  6d1e77:	mov    0x3c8(%rsp),%rcx
  6d1e7f:	movups 0x3d0(%rsp),%xmm0
  6d1e87:	movaps %xmm0,0xb10(%rsp)
  6d1e8f:	movups 0x3e0(%rsp),%xmm0
  6d1e97:	movaps %xmm0,0xb20(%rsp)
  6d1e9f:	mov    0x3f0(%rsp),%rdx
  6d1ea7:	mov    %rdx,0xb30(%rsp)
  6d1eaf:	mov    %rax,0x120(%rsp)
  6d1eb7:	mov    %rcx,0x128(%rsp)
  6d1ebf:	movaps 0xb10(%rsp),%xmm0
  6d1ec7:	movaps 0xb20(%rsp),%xmm1
  6d1ecf:	movups %xmm0,0x130(%rsp)
  6d1ed7:	movups %xmm1,0x140(%rsp)
  6d1edf:	mov    0xb30(%rsp),%rax
  6d1ee7:	mov    %rax,0x150(%rsp)
  6d1eef:	jmp    6d1c34 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x15f4>
  6d1ef4:	mov    $0x11,%eax
  6d1ef9:	mov    0x3f0(%rsp),%rcx
  6d1f01:	mov    %rcx,0x150(%rsp)
  6d1f09:	movups 0x3d0(%rsp),%xmm0
  6d1f11:	movups 0x3e0(%rsp),%xmm1
  6d1f19:	movups %xmm1,0x140(%rsp)
  6d1f21:	movups %xmm0,0x130(%rsp)
  6d1f29:	mov    %rax,0x120(%rsp)
  6d1f31:	mov    %r12,0x128(%rsp)
  6d1f39:	jmp    6d1c34 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x15f4>
  6d1f3e:	lea    0x328693(%rip),%rax        # 9fa5d8 <__frame_dummy_init_array_entry+0x11c8>
  6d1f45:	mov    %rax,0x60(%rsp)
  6d1f4a:	jmp    6d13d8 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0xd98>
  6d1f4f:	mov    $0xd,%eax
  6d1f54:	jmp    6d1f5b <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x191b>
  6d1f56:	mov    $0xe,%eax
  6d1f5b:	mov    %rax,0x3c0(%rsp)
  6d1f63:	mov    0x10(%rsp),%rax
  6d1f68:	mov    %rax,0x3c8(%rsp)
  6d1f70:	lea    -0x68785d(%rip),%rdi        # 4a71a <GCC_except_table0+0xd022>
  6d1f77:	lea    0x327f7a(%rip),%rcx        # 9f9ef8 <__frame_dummy_init_array_entry+0xae8>
  6d1f7e:	lea    0x327e0b(%rip),%r8        # 9f9d90 <__frame_dummy_init_array_entry+0x980>
  6d1f85:	lea    0x3c0(%rsp),%rdx
  6d1f8d:	mov    $0x2b,%esi
  6d1f92:	call   *0x346f20(%rip)        # a18eb8 <_DYNAMIC+0x2f0>
  6d1f98:	jmp    6d2150 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b10>
  6d1f9d:	mov    %rax,%r14
  6d1fa0:	jmp    6d21db <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b9b>
  6d1fa5:	mov    %rax,%r14
  6d1fa8:	jmp    6d21db <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b9b>
  6d1fad:	mov    %rax,%r14
  6d1fb0:	jmp    6d2014 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x19d4>
  6d1fb2:	mov    %rax,%r14
  6d1fb5:	lea    0x32765c(%rip),%rsi        # 9f9618 <__frame_dummy_init_array_entry+0x208>
  6d1fbc:	mov    %r15,%rdi
  6d1fbf:	call   6bad10 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtCscdodAO9FK5_5alloc5boxed3BoxDG0_INtNtNtB4_3ops8function2FnTQL1_INtNtCs6ZNK6sH19NW_4gpui7element2ElL0_EEEp6OutputuEL_EECs4gijoeCAvqI_25inspector_pointer_control>
  6d1fc4:	jmp    6d2086 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1a46>
  6d1fc9:	call   *0x346e61(%rip)        # a18e30 <_DYNAMIC+0x268>
  6d1fcf:	mov    %rax,%r14
  6d1fd2:	lea    0x3c0(%rsp),%rdi
  6d1fda:	call   6b9480 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtCs6ZNK6sH19NW_4gpui6source7SourcesNtCs4gijoeCAvqI_25inspector_pointer_control5ModelEEB1g_>
  6d1fdf:	jmp    6d2093 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1a53>
  6d1fe4:	call   *0x346e46(%rip)        # a18e30 <_DYNAMIC+0x268>
  6d1fea:	mov    %rax,%r14
  6d1fed:	jmp    6d216d <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b2d>
  6d1ff2:	mov    %rax,%r14
  6d1ff5:	mov    0x8(%rsp),%rdi
  6d1ffa:	call   6b95d0 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtCs6ZNK6sH19NW_4gpui7runtime3WinNtCs4gijoeCAvqI_25inspector_pointer_control5ModelEEB1d_>
  6d1fff:	jmp    6d21cb <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b8b>
  6d2004:	mov    %rax,%r14
  6d2007:	lea    0xb10(%rsp),%rdi
  6d200f:	call   6bee90 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueNtNtCshdpBObOiWw8_11gpui_canvas6canvas6CanvasECs4gijoeCAvqI_25inspector_pointer_control>
  6d2014:	lea    0xa0(%rsp),%rdi
  6d201c:	call   6b9480 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtCs6ZNK6sH19NW_4gpui6source7SourcesNtCs4gijoeCAvqI_25inspector_pointer_control5ModelEEB1g_>
  6d2021:	jmp    6d216d <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b2d>
  6d2026:	jmp    6d21be <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b7e>
  6d202b:	call   *0x346dff(%rip)        # a18e30 <_DYNAMIC+0x268>
  6d2031:	jmp    6d21ac <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b6c>
  6d2036:	jmp    6d21be <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b7e>
  6d203b:	jmp    6d21be <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b7e>
  6d2040:	jmp    6d21ac <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b6c>
  6d2045:	jmp    6d21ac <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b6c>
  6d204a:	jmp    6d21ac <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b6c>
  6d204f:	jmp    6d21ac <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b6c>
  6d2054:	jmp    6d21ac <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b6c>
  6d2059:	jmp    6d21ac <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b6c>
  6d205e:	jmp    6d21ac <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b6c>
  6d2063:	jmp    6d21ac <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b6c>
  6d2068:	mov    %rax,%r14
  6d206b:	lea    0x3c0(%rsp),%rdi
  6d2073:	call   6b9630 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtCs6ZNK6sH19NW_4gpui7runtime7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelEEB1h_>
  6d2078:	jmp    6d21cb <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b8b>
  6d207d:	call   *0x346dad(%rip)        # a18e30 <_DYNAMIC+0x268>
  6d2083:	mov    %rax,%r14
  6d2086:	lea    0x3c0(%rsp),%rdi
  6d208e:	call   6b9480 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtCs6ZNK6sH19NW_4gpui6source7SourcesNtCs4gijoeCAvqI_25inspector_pointer_control5ModelEEB1g_>
  6d2093:	mov    %r14,%rdi
  6d2096:	call   *0x347004(%rip)        # a190a0 <_DYNAMIC+0x4d8>
  6d209c:	mov    %rax,%r15
  6d209f:	mov    %rdx,%r12
  6d20a2:	mov    (%rdx),%rax
  6d20a5:	test   %rax,%rax
  6d20a8:	je     6d20af <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1a6f>
  6d20aa:	mov    %r15,%rdi
  6d20ad:	call   *%rax
  6d20af:	mov    0x8(%r12),%rsi
  6d20b4:	test   %rsi,%rsi
  6d20b7:	je     6d20c7 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1a87>
  6d20b9:	mov    0x10(%r12),%rdx
  6d20be:	mov    %r15,%rdi
  6d20c1:	call   *0x346d41(%rip)        # a18e08 <_DYNAMIC+0x240>
  6d20c7:	mov    $0x6,%esi
  6d20cc:	mov    $0x1,%edx
  6d20d1:	mov    %rbx,%rdi
  6d20d4:	call   *0x346d2e(%rip)        # a18e08 <_DYNAMIC+0x240>
  6d20da:	mov    $0xf,%r13d
  6d20e0:	mov    %r13,0x120(%rsp)
  6d20e8:	shl    $0x20,%r12
  6d20ec:	mov    %r15d,%eax
  6d20ef:	or     %r12,%rax
  6d20f2:	mov    %rax,0x128(%rsp)
  6d20fa:	movups %xmm0,0x130(%rsp)
  6d2102:	movups %xmm1,0x140(%rsp)
  6d210a:	mov    %bpl,0x150(%rsp)
  6d2112:	mov    0x28(%rsp),%eax
  6d2116:	mov    0x2b(%rsp),%ecx
  6d211a:	mov    %eax,0x151(%rsp)
  6d2121:	mov    %ecx,0x154(%rsp)
  6d2128:	lea    -0x687a15(%rip),%rdi        # 4a71a <GCC_except_table0+0xd022>
  6d212f:	lea    0x327dc2(%rip),%rcx        # 9f9ef8 <__frame_dummy_init_array_entry+0xae8>
  6d2136:	lea    0x327c0b(%rip),%r8        # 9f9d48 <__frame_dummy_init_array_entry+0x938>
  6d213d:	lea    0x120(%rsp),%rdx
  6d2145:	mov    $0x2b,%esi
  6d214a:	call   *0x346d68(%rip)        # a18eb8 <_DYNAMIC+0x2f0>
  6d2150:	ud2
  6d2152:	mov    %rax,%r14
  6d2155:	mov    0x8(%r12),%rsi
  6d215a:	test   %rsi,%rsi
  6d215d:	je     6d216d <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b2d>
  6d215f:	mov    0x10(%r12),%rdx
  6d2164:	mov    %r15,%rdi
  6d2167:	call   *0x346c9b(%rip)        # a18e08 <_DYNAMIC+0x240>
  6d216d:	mov    $0x6,%esi
  6d2172:	mov    $0x1,%edx
  6d2177:	mov    %rbx,%rdi
  6d217a:	call   *0x346c88(%rip)        # a18e08 <_DYNAMIC+0x240>
  6d2180:	mov    %r14,%rdi
  6d2183:	call   9f8060 <_Unwind_Resume@plt>
  6d2188:	mov    %rax,%r14
  6d218b:	lea    0x120(%rsp),%rdi
  6d2193:	call   6be240 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueNtNtCs6ZNK6sH19NW_4gpui7runtime5ErrorECs4gijoeCAvqI_25inspector_pointer_control>
  6d2198:	mov    %r14,%rdi
  6d219b:	call   9f8060 <_Unwind_Resume@plt>
  6d21a0:	call   *0x346f02(%rip)        # a190a8 <_DYNAMIC+0x4e0>
  6d21a6:	call   *0x346c84(%rip)        # a18e30 <_DYNAMIC+0x268>
  6d21ac:	mov    %rax,%r14
  6d21af:	lea    0x3c0(%rsp),%rdi
  6d21b7:	call   6be240 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueNtNtCs6ZNK6sH19NW_4gpui7runtime5ErrorECs4gijoeCAvqI_25inspector_pointer_control>
  6d21bc:	jmp    6d21c1 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b81>
  6d21be:	mov    %rax,%r14
  6d21c1:	mov    0x8(%rsp),%rbx
  6d21c6:	test   %rbx,%rbx
  6d21c9:	jne    6d21d3 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b93>
  6d21cb:	mov    %r14,%rdi
  6d21ce:	call   9f8060 <_Unwind_Resume@plt>
  6d21d3:	mov    %rbx,%rdi
  6d21d6:	call   6b9630 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtCs6ZNK6sH19NW_4gpui7runtime7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelEEB1h_>
  6d21db:	mov    $0x748,%esi
  6d21e0:	mov    $0x8,%edx
  6d21e5:	mov    %rbx,%rdi
  6d21e8:	call   *0x346c1a(%rip)        # a18e08 <_DYNAMIC+0x240>
  6d21ee:	mov    %r14,%rdi
  6d21f1:	call   9f8060 <_Unwind_Resume@plt>
  6d21f6:	mov    $0x748,%esi
  6d21fb:	mov    $0x8,%edx
  6d2200:	mov    %rbx,%rdi
  6d2203:	call   *0x346bff(%rip)        # a18e08 <_DYNAMIC+0x240>
  6d2209:	call   *0x346c21(%rip)        # a18e30 <_DYNAMIC+0x268>

/tmp/gpui-inspector-pointer-codegen/baseline-frozen:     file format elf64-x86-64


Disassembly of section .text:

00000000006d2210 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch>:
  6d2210:	push   %rbp
  6d2211:	push   %r15
  6d2213:	push   %r14
  6d2215:	push   %r13
  6d2217:	push   %r12
  6d2219:	push   %rbx
  6d221a:	sub    $0xb8,%rsp
  6d2221:	mov    (%rcx),%ebp
  6d2223:	test   %ebp,%ebp
  6d2225:	je     6d225b <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x4b>
  6d2227:	mov    0x8(%rdx),%r14
  6d222b:	mov    0x10(%rdx),%r15
  6d222f:	mov    0x18(%rdx),%rax
  6d2233:	movq   $0x0,0x8(%rdx)
  6d223b:	lea    -0x1(%rbp),%r8d
  6d223f:	lea    -0x692f36(%rip),%r9        # 3f310 <GCC_except_table0+0x1c18>
  6d2246:	movslq (%r9,%r8,4),%r8
  6d224a:	add    %r9,%r8
  6d224d:	jmp    *%r8
  6d2250:	movl   $0xffffffff,(%rdx)
  6d2256:	jmp    6d232c <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x11c>
  6d225b:	movd   0x4(%rcx),%xmm1
  6d2260:	movd   0x8(%rcx),%xmm0
  6d2265:	movd   %xmm1,%eax
  6d2269:	movd   %xmm0,%ecx
  6d226d:	mov    %eax,%r8d
  6d2270:	and    $0x7fffffff,%r8d
  6d2277:	cmp    $0x7f800000,%r8d
  6d227e:	setge  %r8b
  6d2282:	and    $0x7fffffff,%ecx
  6d2288:	cmp    $0x7f800000,%ecx
  6d228e:	setge  %cl
  6d2291:	or     %r8b,%cl
  6d2294:	je     6d22ac <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x9c>
  6d2296:	movl   $0xffffffff,(%rdx)
  6d229c:	movq   $0x0,0x8(%rdx)
  6d22a4:	xor    %r14d,%r14d
  6d22a7:	jmp    6d232c <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x11c>
  6d22ac:	inc    %eax
  6d22ae:	je     6d2e39 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xc29>
  6d22b4:	mov    %eax,(%rdx)
  6d22b6:	movd   %xmm0,0x4(%rdx)
  6d22bb:	xor    %r14d,%r14d
  6d22be:	jmp    6d232c <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x11c>
  6d22c0:	mov    (%rdx),%r12d
  6d22c3:	cmp    $0xffffffff,%r12d
  6d22c7:	je     6d232c <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x11c>
  6d22c9:	mov    %rsi,%r14
  6d22cc:	mov    %rdi,%rbx
  6d22cf:	movups 0x8(%rcx),%xmm0
  6d22d3:	movss  0x4(%rdx),%xmm1
  6d22d8:	movss  %xmm1,0x8(%rsp)
  6d22de:	movaps %xmm0,%xmm1
  6d22e1:	unpckhpd %xmm0,%xmm1
  6d22e5:	lea    0x10(%rsp),%rdi
  6d22ea:	movaps %xmm0,0x90(%rsp)
  6d22f2:	call   *0x346db8(%rip)        # a190b0 <_DYNAMIC+0x4e8>
  6d22f8:	cmpl   $0xfffffffe,0x10(%rsp)
  6d22fd:	jne    6d25d8 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x3c8>
  6d2303:	mov    (%r14),%r15
  6d2306:	test   %r15,%r15
  6d2309:	mov    %rbx,%rax
  6d230c:	je     6d26d4 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x4c4>
  6d2312:	cmpb   $0x1,0x746(%r15)
  6d231a:	jne    6d26e8 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x4d8>
  6d2320:	movq   $0xe,(%rax)
  6d2327:	jmp    6d28a3 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x693>
  6d232c:	mov    (%rsi),%rbx
  6d232f:	test   %rbx,%rbx
  6d2332:	je     6d235d <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x14d>
  6d2334:	add    $0x8,%rsi
  6d2338:	mov    %rbx,0xa8(%rsp)
  6d2340:	mov    %rsi,0xb0(%rsp)
  6d2348:	cmpb   $0x1,0x746(%rbx)
  6d234f:	jne    6d2371 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x161>
  6d2351:	movq   $0xe,(%rdi)
  6d2358:	jmp    6d28a3 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x693>
  6d235d:	movq   $0xd,(%rdi)
  6d2364:	movq   $0x0,0x8(%rdi)
  6d236c:	jmp    6d28a3 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x693>
  6d2371:	movq   $0x0,0x730(%rbx)
  6d237c:	cmp    $0x3,%ebp
  6d237f:	je     6d251e <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x30e>
  6d2385:	cmp    $0x2,%ebp
  6d2388:	je     6d24af <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x29f>
  6d238e:	test   %ebp,%ebp
  6d2390:	jne    6d284c <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x63c>
  6d2396:	mov    0x638(%rbx),%rax
  6d239d:	test   %rax,%rax
  6d23a0:	je     6d23b8 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x1a8>
  6d23a2:	mov    0xd8(%rax),%rax
  6d23a9:	test   %rax,%rax
  6d23ac:	je     6d23b8 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x1a8>
  6d23ae:	cmpb   $0x0,0x12(%rax)
  6d23b2:	jne    6d284c <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x63c>
  6d23b8:	mov    0x8(%rdx),%r14
  6d23bc:	test   %r14,%r14
  6d23bf:	je     6d284c <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x63c>
  6d23c5:	cmp    0x5d8(%rbx),%r14
  6d23cc:	jne    6d2844 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x634>
  6d23d2:	mov    %rdi,%r13
  6d23d5:	mov    %rdx,%r12
  6d23d8:	mov    0x10(%rdx),%r15
  6d23dc:	lea    0x50(%rsp),%rdi
  6d23e1:	mov    %rbx,%rsi
  6d23e4:	mov    %r15,%rdx
  6d23e7:	call   6f7de0 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE16resolve_identityBO_>
  6d23ec:	mov    0x50(%rsp),%rax
  6d23f1:	cmp    $0xfffffffffffffffe,%rax
  6d23f5:	jne    6d27f2 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x5e2>
  6d23fb:	mov    0x58(%rsp),%rdi
  6d2400:	mov    0x2c8(%rbx),%rsi
  6d2407:	cmp    %rsi,%rdi
  6d240a:	jae    6d2e52 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xc42>
  6d2410:	mov    0x2c0(%rbx),%rax
  6d2417:	lea    (%rdi,%rdi,4),%rcx
  6d241b:	mov    0x20(%rax,%rcx,8),%edi
  6d241f:	call   6e1870 <_RNvMsh_NtCs6ZNK6sH19NW_4gpui7runtimeNtB5_4Node4kind>
  6d2424:	cmp    $0x4,%al
  6d2426:	jne    6d290d <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x6fd>
  6d242c:	mov    %r12,%rax
  6d242f:	mov    (%r12),%ecx
  6d2433:	cmp    $0xffffffff,%ecx
  6d2436:	je     6d2e61 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xc51>
  6d243c:	movd   0x4(%rax),%xmm1
  6d2441:	dec    %ecx
  6d2443:	movd   %ecx,%xmm0
  6d2447:	lea    0x10(%rsp),%rdi
  6d244c:	mov    %rbx,%rsi
  6d244f:	mov    %r14,%rdx
  6d2452:	mov    %r15,%rcx
  6d2455:	mov    $0x1,%r8d
  6d245b:	call   6dafb0 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime7editingINtB7_10RuntimeMutNtCs4gijoeCAvqI_25inspector_pointer_control5ModeluE14select_pointerB12_>
  6d2460:	mov    0x10(%rsp),%rax
  6d2465:	cmp    $0xfffffffffffffffe,%rax
  6d2469:	je     6d2479 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x269>
  6d246b:	cmp    $0x11,%eax
  6d246e:	jne    6d2479 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x269>
  6d2470:	movq   $0x0,0x8(%r12)
  6d2479:	mov    0x40(%rsp),%rax
  6d247e:	mov    %rax,0x30(%r13)
  6d2482:	movups 0x10(%rsp),%xmm0
  6d2487:	movups 0x20(%rsp),%xmm1
  6d248c:	movups 0x30(%rsp),%xmm2
  6d2491:	movups %xmm2,0x20(%r13)
  6d2496:	movups %xmm1,0x10(%r13)
  6d249b:	movups %xmm0,0x0(%r13)
  6d24a0:	lea    0x50(%rsp),%rdi
  6d24a5:	call   6b90c0 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtB4_6result6ResultNtNtCs6ZNK6sH19NW_4gpui7runtime6CommitNtBZ_5ErrorEECs4gijoeCAvqI_25inspector_pointer_control>
  6d24aa:	jmp    6d28a3 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x693>
  6d24af:	test   %r14,%r14
  6d24b2:	sete   %r13b
  6d24b6:	cmpb   $0x1,0x742(%rbx)
  6d24bd:	jne    6d2512 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x302>
  6d24bf:	cmpb   $0x0,0x743(%rbx)
  6d24c6:	jne    6d2512 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x302>
  6d24c8:	cmpb   $0x0,0x744(%rbx)
  6d24cf:	je     6d2512 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x302>
  6d24d1:	cmpq   $0xffffffffffffffff,0x5b0(%rbx)
  6d24d9:	jne    6d2512 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x302>
  6d24db:	mov    0x688(%rbx),%rax
  6d24e2:	cmp    0x690(%rbx),%rax
  6d24e9:	jne    6d2512 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x302>
  6d24eb:	mov    0x6a0(%rbx),%rax
  6d24f2:	cmp    0x698(%rbx),%rax
  6d24f9:	jne    6d2512 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x302>
  6d24fb:	movss  0x738(%rbx),%xmm0
  6d2503:	ucomiss 0x73c(%rbx),%xmm0
  6d250a:	jne    6d2512 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x302>
  6d250c:	jnp    6d25ae <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x39e>
  6d2512:	movq   $0x12,(%rdi)
  6d2519:	jmp    6d28a3 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x693>
  6d251e:	test   %r14,%r14
  6d2521:	je     6d284c <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x63c>
  6d2527:	movzbl 0x742(%rbx),%ecx
  6d252e:	movzbl 0x743(%rbx),%r8d
  6d2536:	mov    %r8d,%r9d
  6d2539:	not    %r9b
  6d253c:	movzbl 0x744(%rbx),%esi
  6d2543:	mov    %ecx,%r10d
  6d2546:	and    %sil,%r10b
  6d2549:	and    %r9b,%r10b
  6d254c:	mov    0x5b0(%rbx),%r9
  6d2553:	cmp    $0xffffffffffffffff,%r9
  6d2557:	sete   %r11b
  6d255b:	and    %r10b,%r11b
  6d255e:	cmp    $0x1,%r11b
  6d2562:	jne    6d2600 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x3f0>
  6d2568:	mov    0x688(%rbx),%rax
  6d256f:	cmp    0x690(%rbx),%rax
  6d2576:	jne    6d26ad <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x49d>
  6d257c:	mov    0x6a0(%rbx),%rax
  6d2583:	cmp    0x698(%rbx),%rax
  6d258a:	jne    6d26ad <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x49d>
  6d2590:	movss  0x738(%rbx),%xmm0
  6d2598:	ucomiss 0x73c(%rbx),%xmm0
  6d259f:	jne    6d26ad <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x49d>
  6d25a5:	jp     6d26ad <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x49d>
  6d25ab:	xor    %r13d,%r13d
  6d25ae:	mov    0x638(%rbx),%rax
  6d25b5:	test   %rax,%rax
  6d25b8:	je     6d28b5 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x6a5>
  6d25be:	mov    0xd8(%rax),%rax
  6d25c5:	test   %rax,%rax
  6d25c8:	je     6d28b5 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x6a5>
  6d25ce:	movzbl 0x12(%rax),%r9d
  6d25d3:	jmp    6d28b8 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x6a8>
  6d25d8:	mov    0x40(%rsp),%rax
  6d25dd:	mov    %rax,0x30(%rbx)
  6d25e1:	movups 0x10(%rsp),%xmm0
  6d25e6:	movups 0x20(%rsp),%xmm1
  6d25eb:	movups 0x30(%rsp),%xmm2
  6d25f0:	movups %xmm2,0x20(%rbx)
  6d25f4:	movups %xmm1,0x10(%rbx)
  6d25f8:	movups %xmm0,(%rbx)
  6d25fb:	jmp    6d28a3 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x693>
  6d2600:	cmp    $0xffffffffffffffff,%r9
  6d2604:	sete   %r9b
  6d2608:	movq   $0x12,0x10(%rsp)
  6d2611:	not    %cl
  6d2613:	or     %r8b,%cl
  6d2616:	not    %sil
  6d2619:	or     %cl,%sil
  6d261c:	or     %r9b,%sil
  6d261f:	test   $0x1,%sil
  6d2623:	jne    6d26ad <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x49d>
  6d2629:	mov    0x6a0(%rbx),%rcx
  6d2630:	cmp    0x698(%rbx),%rcx
  6d2637:	jne    6d26ad <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x49d>
  6d2639:	movss  0x738(%rbx),%xmm0
  6d2641:	ucomiss 0x73c(%rbx),%xmm0
  6d2648:	jne    6d26ad <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x49d>
  6d264a:	jp     6d26ad <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x49d>
  6d264c:	mov    0x690(%rbx),%rcx
  6d2653:	cmp    $0xffffffffffffffff,%rcx
  6d2657:	je     6d26ad <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x49d>
  6d2659:	inc    %rcx
  6d265c:	cmp    0x688(%rbx),%rcx
  6d2663:	jne    6d26ad <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x49d>
  6d2665:	cmp    %rcx,0x6b8(%rbx)
  6d266c:	jne    6d26ad <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x49d>
  6d266e:	test   %rax,%rax
  6d2671:	je     6d26ad <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x49d>
  6d2673:	cmpq   $0x0,0x6a8(%rbx)
  6d267b:	je     6d26ad <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x49d>
  6d267d:	cmp    %rax,0x6b0(%rbx)
  6d2684:	jne    6d26ad <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x49d>
  6d2686:	cmp    0x5d8(%rbx),%r14
  6d268d:	jne    6d26ad <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x49d>
  6d268f:	lea    0x10(%rsp),%rax
  6d2694:	mov    %rdi,%r12
  6d2697:	mov    %rax,%rdi
  6d269a:	mov    %rdx,%r13
  6d269d:	call   6be240 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueNtNtCs6ZNK6sH19NW_4gpui7runtime5ErrorECs4gijoeCAvqI_25inspector_pointer_control>
  6d26a2:	mov    %r13,%rdx
  6d26a5:	mov    %r12,%rdi
  6d26a8:	jmp    6d25ab <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x39b>
  6d26ad:	movups 0x18(%rsp),%xmm0
  6d26b2:	movups 0x28(%rsp),%xmm1
  6d26b7:	movups 0x38(%rsp),%xmm2
  6d26bc:	movups %xmm2,0x28(%rdi)
  6d26c0:	movups %xmm1,0x18(%rdi)
  6d26c4:	movups %xmm0,0x8(%rdi)
  6d26c8:	movq   $0x12,(%rdi)
  6d26cf:	jmp    6d28a3 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x693>
  6d26d4:	movq   $0xd,(%rax)
  6d26db:	movq   $0x0,0x8(%rax)
  6d26e3:	jmp    6d28a3 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x693>
  6d26e8:	cmpb   $0x1,0x742(%r15)
  6d26f0:	jne    6d27e6 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x5d6>
  6d26f6:	cmpb   $0x0,0x743(%r15)
  6d26fe:	jne    6d27e6 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x5d6>
  6d2704:	cmpb   $0x0,0x744(%r15)
  6d270c:	je     6d27e6 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x5d6>
  6d2712:	cmpq   $0xffffffffffffffff,0x5b0(%r15)
  6d271a:	jne    6d27e6 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x5d6>
  6d2720:	mov    0x688(%r15),%rcx
  6d2727:	cmp    0x690(%r15),%rcx
  6d272e:	jne    6d27e6 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x5d6>
  6d2734:	mov    0x698(%r15),%rcx
  6d273b:	cmp    %rcx,0x6a0(%r15)
  6d2742:	jne    6d27e6 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x5d6>
  6d2748:	movss  0x738(%r15),%xmm0
  6d2751:	ucomiss 0x73c(%r15),%xmm0
  6d2759:	jne    6d27e6 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x5d6>
  6d275f:	jp     6d27e6 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x5d6>
  6d2765:	mov    %ecx,%eax
  6d2767:	cvtsi2ss %rax,%xmm2
  6d276c:	dec    %r12d
  6d276f:	shr    $0x20,%rcx
  6d2773:	mov    %ecx,%eax
  6d2775:	xorps  %xmm1,%xmm1
  6d2778:	cvtsi2ss %rax,%xmm1
  6d277d:	movd   %r12d,%xmm0
  6d2782:	movq   $0x0,0x10(%rsp)
  6d278b:	movss  %xmm2,0x18(%rsp)
  6d2791:	movss  %xmm1,0x1c(%rsp)
  6d2797:	lea    0x10(%rsp),%rdi
  6d279c:	movd   %xmm0,0xc(%rsp)
  6d27a2:	movss  0x8(%rsp),%xmm1
  6d27a8:	call   *0x3468c2(%rip)        # a19070 <_DYNAMIC+0x4a8>
  6d27ae:	test   %al,%al
  6d27b0:	je     6d2e2d <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xc1d>
  6d27b6:	mov    0x638(%r15),%rax
  6d27bd:	test   %rax,%rax
  6d27c0:	je     6d2c87 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xa77>
  6d27c6:	mov    0x100(%rax),%rsi
  6d27cd:	test   %rsi,%rsi
  6d27d0:	je     6d2c87 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xa77>
  6d27d6:	lea    0x50(%rsp),%rdi
  6d27db:	call   *0x346877(%rip)        # a19058 <_DYNAMIC+0x490>
  6d27e1:	jmp    6d2c9a <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xa8a>
  6d27e6:	movq   $0x12,(%rax)
  6d27ed:	jmp    6d28a3 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x693>
  6d27f2:	cmp    $0xd,%rax
  6d27f6:	jl     6d281b <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x60b>
  6d27f8:	cmp    $0x21,%rax
  6d27fc:	je     6d281b <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x60b>
  6d27fe:	cmp    $0x26,%rax
  6d2802:	mov    %r13,%rdi
  6d2805:	mov    %r12,%rdx
  6d2808:	jne    6d2844 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x634>
  6d280a:	mov    0x58(%rsp),%rsi
  6d280f:	test   %rsi,%rsi
  6d2812:	je     6d2844 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x634>
  6d2814:	lea    0x60(%rsp),%rax
  6d2819:	jmp    6d2830 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x620>
  6d281b:	mov    0x68(%rsp),%rsi
  6d2820:	test   %rsi,%rsi
  6d2823:	mov    %r13,%rdi
  6d2826:	mov    %r12,%rdx
  6d2829:	je     6d2844 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x634>
  6d282b:	lea    0x70(%rsp),%rax
  6d2830:	mov    (%rax),%rdi
  6d2833:	mov    $0x1,%edx
  6d2838:	call   *0x3465ca(%rip)        # a18e08 <_DYNAMIC+0x240>
  6d283e:	mov    %r13,%rdi
  6d2841:	mov    %r12,%rdx
  6d2844:	movq   $0x0,0x8(%rdx)
  6d284c:	movups 0x688(%rbx),%xmm0
  6d2853:	movzbl 0x744(%rbx),%eax
  6d285a:	cmpq   $0x0,0x6a8(%rbx)
  6d2862:	je     6d2872 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x662>
  6d2864:	test   %al,%al
  6d2866:	je     6d2876 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x666>
  6d2868:	cmpq   $0xffffffffffffffff,0x5b0(%rbx)
  6d2870:	jne    6d2876 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x666>
  6d2872:	xor    %ecx,%ecx
  6d2874:	jmp    6d2882 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x672>
  6d2876:	mov    0x6b8(%rbx),%rdx
  6d287d:	mov    $0x1,%ecx
  6d2882:	mov    0x730(%rbx),%rsi
  6d2889:	mov    %rcx,0x8(%rdi)
  6d288d:	mov    %rdx,0x10(%rdi)
  6d2891:	movups %xmm0,0x18(%rdi)
  6d2895:	mov    %rsi,0x28(%rdi)
  6d2899:	mov    %al,0x30(%rdi)
  6d289c:	movq   $0xfffffffffffffffe,(%rdi)
  6d28a3:	add    $0xb8,%rsp
  6d28aa:	pop    %rbx
  6d28ab:	pop    %r12
  6d28ad:	pop    %r13
  6d28af:	pop    %r14
  6d28b1:	pop    %r15
  6d28b3:	pop    %rbp
  6d28b4:	ret
  6d28b5:	xor    %r9d,%r9d
  6d28b8:	mov    (%rdx),%r12d
  6d28bb:	movd   0x4(%rdx),%xmm1
  6d28c0:	cmp    $0xffffffff,%r12d
  6d28c4:	mov    %rdx,0x48(%rsp)
  6d28c9:	je     6d291f <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x70f>
  6d28cb:	mov    %rdi,0x90(%rsp)
  6d28d3:	lea    -0x1(%r12),%eax
  6d28d8:	movd   %eax,%xmm0
  6d28dc:	mov    %r9d,0xc(%rsp)
  6d28e1:	test   %r9b,%r9b
  6d28e4:	movd   %xmm1,0x8(%rsp)
  6d28ea:	mov    %rbx,%rdi
  6d28ed:	je     6d2923 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x713>
  6d28ef:	movss  0x8(%rsp),%xmm1
  6d28f5:	call   6db880 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE14inspector_pickB10_>
  6d28fa:	movd   0x8(%rsp),%xmm1
  6d2900:	mov    %rdx,%r8
  6d2903:	mov    0x90(%rsp),%rdi
  6d290b:	jmp    6d2951 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x741>
  6d290d:	lea    0x50(%rsp),%rdi
  6d2912:	call   6b90c0 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtB4_6result6ResultNtNtCs6ZNK6sH19NW_4gpui7runtime6CommitNtBZ_5ErrorEECs4gijoeCAvqI_25inspector_pointer_control>
  6d2917:	mov    %r13,%rdi
  6d291a:	jmp    6d284c <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x63c>
  6d291f:	xor    %eax,%eax
  6d2921:	jmp    6d2956 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x746>
  6d2923:	call   6f80c0 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_>
  6d2928:	test   $0x1,%al
  6d292a:	je     6d2941 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x731>
  6d292c:	lea    0x5d8(%rbx),%rdi
  6d2933:	mov    %rdx,%rsi
  6d2936:	call   *0x3466ec(%rip)        # a19028 <_DYNAMIC+0x460>
  6d293c:	mov    %rdx,%r8
  6d293f:	jmp    6d2943 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x733>
  6d2941:	xor    %eax,%eax
  6d2943:	mov    0x90(%rsp),%rdi
  6d294b:	movd   0x8(%rsp),%xmm1
  6d2951:	mov    0xc(%rsp),%r9d
  6d2956:	cmp    $0x2,%ebp
  6d2959:	jne    6d2a1d <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x80d>
  6d295f:	mov    0x610(%rbx),%r14
  6d2966:	mov    0x618(%rbx),%rcx
  6d296d:	test   %rax,%rax
  6d2970:	sete   %sil
  6d2974:	or     %r9b,%sil
  6d2977:	test   $0x1,%sil
  6d297b:	je     6d2a5d <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x84d>
  6d2981:	mov    %r8,%rbp
  6d2984:	mov    %rax,%r15
  6d2987:	mov    %rdi,%r13
  6d298a:	movq   $0x0,0x610(%rbx)
  6d2995:	lea    0x10(%rsp),%rdi
  6d299a:	mov    %rbx,%rsi
  6d299d:	mov    %r14,%rdx
  6d29a0:	call   6db5d0 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime7editingINtB7_10RuntimeMutNtCs4gijoeCAvqI_25inspector_pointer_control5ModeluE20publish_focus_changeB12_>
  6d29a5:	mov    0x10(%rsp),%rax
  6d29aa:	movups 0x18(%rsp),%xmm0
  6d29af:	movaps %xmm0,0x50(%rsp)
  6d29b4:	movups 0x28(%rsp),%xmm0
  6d29b9:	movaps %xmm0,0x60(%rsp)
  6d29be:	movups 0x38(%rsp),%xmm0
  6d29c3:	movaps %xmm0,0x70(%rsp)
  6d29c8:	cmp    $0xfffffffffffffffe,%rax
  6d29cc:	jne    6d2b63 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x953>
  6d29d2:	movaps 0x50(%rsp),%xmm0
  6d29d7:	movaps 0x60(%rsp),%xmm1
  6d29dc:	movaps 0x70(%rsp),%xmm2
  6d29e1:	movaps %xmm2,0x30(%rsp)
  6d29e6:	movaps %xmm1,0x20(%rsp)
  6d29eb:	movaps %xmm0,0x10(%rsp)
  6d29f0:	mov    0x638(%rbx),%rax
  6d29f7:	test   %rax,%rax
  6d29fa:	mov    %r15,%rcx
  6d29fd:	je     6d2b94 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x984>
  6d2a03:	cmpq   $0x0,0xd8(%rax)
  6d2a0b:	je     6d2b94 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x984>
  6d2a11:	xor    %eax,%eax
  6d2a13:	mov    0x48(%rsp),%r15
  6d2a18:	jmp    6d2bd1 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x9c1>
  6d2a1d:	test   %r13b,%r13b
  6d2a20:	jne    6d284c <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x63c>
  6d2a26:	test   %rax,%rax
  6d2a29:	je     6d284c <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x63c>
  6d2a2f:	cmp    %rax,%r14
  6d2a32:	jne    6d284c <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x63c>
  6d2a38:	cmp    %r8,%r15
  6d2a3b:	jne    6d284c <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x63c>
  6d2a41:	test   %r9b,%r9b
  6d2a44:	je     6d2c08 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x9f8>
  6d2a4a:	mov    %rbx,%rsi
  6d2a4d:	mov    %r14,%rdx
  6d2a50:	mov    %r15,%rcx
  6d2a53:	call   6defb0 <_RNvMs4_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_10RuntimeMutNtCs4gijoeCAvqI_25inspector_pointer_control5ModeluE16inspector_selectB14_>
  6d2a58:	jmp    6d28a3 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x693>
  6d2a5d:	cmp    0x5d8(%rbx),%rax
  6d2a64:	jne    6d2b8a <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x97a>
  6d2a6a:	movd   %xmm1,0x8(%rsp)
  6d2a70:	mov    %rax,%r15
  6d2a73:	mov    %rcx,0x90(%rsp)
  6d2a7b:	mov    %rdi,%r13
  6d2a7e:	lea    0x10(%rsp),%rdi
  6d2a83:	mov    %rbx,%rsi
  6d2a86:	mov    %r8,%rbp
  6d2a89:	mov    %r8,%rdx
  6d2a8c:	call   6f7de0 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE16resolve_identityBO_>
  6d2a91:	mov    0x10(%rsp),%rcx
  6d2a96:	mov    0x18(%rsp),%rax
  6d2a9b:	cmp    $0xfffffffffffffffe,%rcx
  6d2a9f:	jne    6d2c2e <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xa1e>
  6d2aa5:	mov    0x2c8(%rbx),%rsi
  6d2aac:	cmp    %rsi,%rax
  6d2aaf:	jae    6d2e70 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xc60>
  6d2ab5:	mov    0x2c0(%rbx),%rcx
  6d2abc:	lea    (%rax,%rax,4),%rax
  6d2ac0:	mov    0x20(%rcx,%rax,8),%edi
  6d2ac4:	call   6e1870 <_RNvMsh_NtCs6ZNK6sH19NW_4gpui7runtimeNtB5_4Node4kind>
  6d2ac9:	cmp    $0x4,%al
  6d2acb:	jne    6d2c58 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xa48>
  6d2ad1:	cmp    $0xffffffff,%r12d
  6d2ad5:	je     6d2e80 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xc70>
  6d2adb:	mov    %rbp,%rcx
  6d2ade:	dec    %r12d
  6d2ae1:	movd   %r12d,%xmm0
  6d2ae6:	lea    0x10(%rsp),%rdi
  6d2aeb:	mov    %rbx,%rsi
  6d2aee:	mov    %r15,%rbp
  6d2af1:	mov    %r15,%rdx
  6d2af4:	movss  0x8(%rsp),%xmm1
  6d2afa:	mov    %rcx,%rbx
  6d2afd:	xor    %r8d,%r8d
  6d2b00:	call   6dafb0 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime7editingINtB7_10RuntimeMutNtCs4gijoeCAvqI_25inspector_pointer_control5ModeluE14select_pointerB12_>
  6d2b05:	mov    0x10(%rsp),%rax
  6d2b0a:	movups 0x38(%rsp),%xmm0
  6d2b0f:	movaps %xmm0,0x70(%rsp)
  6d2b14:	movups 0x28(%rsp),%xmm1
  6d2b19:	movaps %xmm1,0x60(%rsp)
  6d2b1e:	movups 0x18(%rsp),%xmm2
  6d2b23:	movaps %xmm2,0x50(%rsp)
  6d2b28:	movups %xmm0,0x28(%r13)
  6d2b2d:	movups %xmm1,0x18(%r13)
  6d2b32:	movups %xmm2,0x8(%r13)
  6d2b37:	cmp    $0xfffffffffffffffe,%rax
  6d2b3b:	jne    6d2dad <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xb9d>
  6d2b41:	mov    0x48(%rsp),%r15
  6d2b46:	mov    %rbp,0x8(%r15)
  6d2b4a:	mov    %rbx,0x10(%r15)
  6d2b4e:	movq   $0x0,0x18(%r15)
  6d2b56:	movq   $0xfffffffffffffffe,0x0(%r13)
  6d2b5e:	jmp    6d28a3 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x693>
  6d2b63:	movaps 0x50(%rsp),%xmm0
  6d2b68:	movaps 0x60(%rsp),%xmm1
  6d2b6d:	movaps 0x70(%rsp),%xmm2
  6d2b72:	movups %xmm2,0x28(%r13)
  6d2b77:	movups %xmm1,0x18(%r13)
  6d2b7c:	movups %xmm0,0x8(%r13)
  6d2b81:	mov    %rax,0x0(%r13)
  6d2b85:	jmp    6d28a3 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x693>
  6d2b8a:	mov    $0x11,%ecx
  6d2b8f:	jmp    6d2c31 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xa21>
  6d2b94:	cmpq   $0xffffffffffffffff,0x5b0(%rbx)
  6d2b9c:	mov    0x48(%rsp),%r15
  6d2ba1:	je     6d2bcf <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x9bf>
  6d2ba3:	mov    0x690(%rbx),%rax
  6d2baa:	cmp    $0xffffffffffffffff,%rax
  6d2bae:	je     6d2bcf <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x9bf>
  6d2bb0:	inc    %rax
  6d2bb3:	cmp    0x688(%rbx),%rax
  6d2bba:	jne    6d2bcf <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x9bf>
  6d2bbc:	cmpq   $0x0,0x6a8(%rbx)
  6d2bc4:	je     6d2bcf <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x9bf>
  6d2bc6:	mov    0x6b0(%rbx),%rax
  6d2bcd:	jmp    6d2bd1 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x9c1>
  6d2bcf:	xor    %eax,%eax
  6d2bd1:	mov    %rcx,0x8(%r15)
  6d2bd5:	mov    %rbp,0x10(%r15)
  6d2bd9:	mov    %rax,0x18(%r15)
  6d2bdd:	movaps 0x10(%rsp),%xmm0
  6d2be2:	movaps 0x20(%rsp),%xmm1
  6d2be7:	movaps 0x30(%rsp),%xmm2
  6d2bec:	movups %xmm2,0x28(%r13)
  6d2bf1:	movups %xmm1,0x18(%r13)
  6d2bf6:	movups %xmm0,0x8(%r13)
  6d2bfb:	movq   $0xfffffffffffffffe,0x0(%r13)
  6d2c03:	jmp    6d28a3 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x693>
  6d2c08:	movq   $0x0,0x10(%rsp)
  6d2c11:	lea    0xa8(%rsp),%rsi
  6d2c19:	lea    0x10(%rsp),%r8
  6d2c1e:	mov    %r14,%rdx
  6d2c21:	mov    %r15,%rcx
  6d2c24:	call   6d6010 <_RNvMNtNtCs6ZNK6sH19NW_4gpui7runtime4turnINtB4_10RuntimeMutNtCs4gijoeCAvqI_25inspector_pointer_control5ModeluE21activate_with_editingBW_>
  6d2c29:	jmp    6d28a3 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x693>
  6d2c2e:	mov    %r13,%rdi
  6d2c31:	mov    0x40(%rsp),%rdx
  6d2c36:	mov    %rdx,0x30(%rdi)
  6d2c3a:	movups 0x20(%rsp),%xmm0
  6d2c3f:	movups 0x30(%rsp),%xmm1
  6d2c44:	movups %xmm1,0x20(%rdi)
  6d2c48:	movups %xmm0,0x10(%rdi)
  6d2c4c:	mov    %rcx,(%rdi)
  6d2c4f:	mov    %rax,0x8(%rdi)
  6d2c53:	jmp    6d28a3 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x693>
  6d2c58:	lea    0x10(%rsp),%rdi
  6d2c5d:	mov    %rbx,%rsi
  6d2c60:	mov    %r15,%rdx
  6d2c63:	mov    %rbp,%rcx
  6d2c66:	call   6dd570 <_RNvMs3_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE5focusBW_>
  6d2c6b:	mov    0x10(%rsp),%rax
  6d2c70:	cmp    $0xfffffffffffffffe,%rax
  6d2c74:	jne    6d2d6e <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xb5e>
  6d2c7a:	mov    0x90(%rsp),%rcx
  6d2c82:	jmp    6d2995 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x785>
  6d2c87:	movq   $0x4,0x50(%rsp)
  6d2c90:	pxor   %xmm0,%xmm0
  6d2c94:	movdqu %xmm0,0x58(%rsp)
  6d2c9a:	mov    %rbx,%rax
  6d2c9d:	mov    0x5a8(%r15),%rcx
  6d2ca4:	mov    %rcx,0x48(%rsp)
  6d2ca9:	test   %rcx,%rcx
  6d2cac:	je     6d2d62 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xb52>
  6d2cb2:	mov    0x5a0(%r15),%rbp
  6d2cb9:	mov    0x48(%rsp),%rcx
  6d2cbe:	mov    %rcx,%r13
  6d2cc1:	shl    $0x6,%r13
  6d2cc5:	lea    -0x1(%rcx),%r12
  6d2cc9:	jmp    6d2d2b <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xb1b>
  6d2ccb:	mov    0x60(%rsp),%rax
  6d2cd0:	mov    %rax,0x20(%rsp)
  6d2cd5:	movups 0x50(%rsp),%xmm0
  6d2cda:	movaps %xmm0,0x10(%rsp)
  6d2cdf:	mov    0x638(%r15),%rax
  6d2ce6:	test   %rax,%rax
  6d2ce9:	je     6d2d5e <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xb4e>
  6d2ceb:	cmpq   $0x0,(%rax)
  6d2cef:	setne  %al
  6d2cf2:	movzbl %al,%ecx
  6d2cf5:	mov    %rbp,%rdi
  6d2cf8:	mov    0x48(%rsp),%rsi
  6d2cfd:	lea    0x10(%rsp),%rdx
  6d2d02:	mov    %r12,%r8
  6d2d05:	movd   0xc(%rsp),%xmm0
  6d2d0b:	movss  0x8(%rsp),%xmm1
  6d2d11:	call   *0x3463a1(%rip)        # a190b8 <_DYNAMIC+0x4f0>
  6d2d17:	test   %al,%al
  6d2d19:	mov    %rbx,%rax
  6d2d1c:	jne    6d2db6 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xba6>
  6d2d22:	dec    %r12
  6d2d25:	add    $0xffffffffffffffc0,%r13
  6d2d29:	je     6d2d62 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xb52>
  6d2d2b:	cmpb   $0x0,-0x2(%rbp,%r13,1)
  6d2d31:	jne    6d2ccb <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xabb>
  6d2d33:	movzbl -0x3(%rbp,%r13,1),%ecx
  6d2d39:	sub    $0x2,%cl
  6d2d3c:	movzbl %cl,%ecx
  6d2d3f:	mov    $0x8,%edx
  6d2d44:	cmovb  %edx,%ecx
  6d2d47:	cmp    $0x7,%cl
  6d2d4a:	je     6d2ccb <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xabb>
  6d2d50:	movzbl %cl,%ecx
  6d2d53:	cmp    $0x4,%ecx
  6d2d56:	je     6d2ccb <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xabb>
  6d2d5c:	jmp    6d2d22 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xb12>
  6d2d5e:	xor    %eax,%eax
  6d2d60:	jmp    6d2cf2 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xae2>
  6d2d62:	movq   $0x19,(%rax)
  6d2d69:	jmp    6d28a3 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x693>
  6d2d6e:	mov    0x38(%rsp),%rcx
  6d2d73:	movzbl 0x40(%rsp),%edx
  6d2d78:	mov    0x44(%rsp),%esi
  6d2d7c:	mov    %esi,0x34(%r13)
  6d2d80:	mov    0x41(%rsp),%esi
  6d2d84:	mov    %esi,0x31(%r13)
  6d2d88:	movups 0x18(%rsp),%xmm0
  6d2d8d:	movups 0x28(%rsp),%xmm1
  6d2d92:	mov    %rax,0x0(%r13)
  6d2d96:	movups %xmm0,0x8(%r13)
  6d2d9b:	movups %xmm1,0x18(%r13)
  6d2da0:	mov    %rcx,0x28(%r13)
  6d2da4:	mov    %dl,0x30(%r13)
  6d2da8:	jmp    6d28a3 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x693>
  6d2dad:	mov    %rax,0x0(%r13)
  6d2db1:	jmp    6d28a3 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x693>
  6d2db6:	movq   $0x19,0x10(%rsp)
  6d2dbf:	lea    0x10(%rsp),%rdi
  6d2dc4:	call   6be240 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueNtNtCs6ZNK6sH19NW_4gpui7runtime5ErrorECs4gijoeCAvqI_25inspector_pointer_control>
  6d2dc9:	mov    %r12,0xb0(%rsp)
  6d2dd1:	movq   $0x1,0xa8(%rsp)
  6d2ddd:	lea    0xa8(%rsp),%rdi
  6d2de5:	mov    %r15,%rsi
  6d2de8:	mov    %r15,%rdx
  6d2deb:	call   6cdf20 <_RINvYINtNtNtNtCs4NRVxsYgnAr_4core4iter7sources7from_fn6FromFnNCNvMs6_NtNtCs6ZNK6sH19NW_4gpui7runtime6scrollINtB17_3WinNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE12scroll_at_2ds0_0ENtNtNtBa_6traits8iterator8Iterator8try_folduNCINvNvB2Z_3any5checkjNCBZ_s1_0E0INtNtNtBc_3ops12control_flow11ControlFlowuEEB1U_>
  6d2df0:	test   %al,%al
  6d2df2:	je     6d2e2d <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xc1d>
  6d2df4:	movq   $0x1,0x18(%rsp)
  6d2dfd:	mov    %r12,0x20(%rsp)
  6d2e02:	movaps 0x90(%rsp),%xmm0
  6d2e0a:	movups %xmm0,0x28(%rsp)
  6d2e0f:	movq   $0x3,0x10(%rsp)
  6d2e18:	lea    0x10(%rsp),%rdx
  6d2e1d:	mov    %rbx,%rdi
  6d2e20:	mov    %r14,%rsi
  6d2e23:	call   6e08d0 <_RNvMs6_NtNtCs6ZNK6sH19NW_4gpui7runtime6scrollINtB7_3WinNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE17apply_scroll_planBT_>
  6d2e28:	jmp    6d28a3 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x693>
  6d2e2d:	movq   $0x19,(%rbx)
  6d2e34:	jmp    6d28a3 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x693>
  6d2e39:	lea    -0x685cd7(%rip),%rdi        # 4d169 <GCC_except_table0+0xfa71>
  6d2e40:	lea    0x327461(%rip),%rdx        # 9fa2a8 <__frame_dummy_init_array_entry+0xe98>
  6d2e47:	mov    $0x22,%esi
  6d2e4c:	call   *0x34615e(%rip)        # a18fb0 <_DYNAMIC+0x3e8>
  6d2e52:	lea    0x327467(%rip),%rdx        # 9fa2c0 <__frame_dummy_init_array_entry+0xeb0>
  6d2e59:	call   *0x345fd9(%rip)        # a18e38 <_DYNAMIC+0x270>
  6d2e5f:	jmp    6d2e6e <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xc5e>
  6d2e61:	lea    0x327470(%rip),%rdi        # 9fa2d8 <__frame_dummy_init_array_entry+0xec8>
  6d2e68:	call   *0x346032(%rip)        # a18ea0 <_DYNAMIC+0x2d8>
  6d2e6e:	ud2
  6d2e70:	lea    0x327479(%rip),%rdx        # 9fa2f0 <__frame_dummy_init_array_entry+0xee0>
  6d2e77:	mov    %rax,%rdi
  6d2e7a:	call   *0x345fb8(%rip)        # a18e38 <_DYNAMIC+0x270>
  6d2e80:	lea    0x327481(%rip),%rdi        # 9fa308 <__frame_dummy_init_array_entry+0xef8>
  6d2e87:	call   *0x346013(%rip)        # a18ea0 <_DYNAMIC+0x2d8>
  6d2e8d:	mov    %rax,%rbx
  6d2e90:	lea    0x50(%rsp),%rdi
  6d2e95:	call   6b90c0 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtB4_6result6ResultNtNtCs6ZNK6sH19NW_4gpui7runtime6CommitNtBZ_5ErrorEECs4gijoeCAvqI_25inspector_pointer_control>
  6d2e9a:	mov    %rbx,%rdi
  6d2e9d:	call   9f8060 <_Unwind_Resume@plt>

/tmp/gpui-inspector-pointer-codegen/baseline-frozen:     file format elf64-x86-64


Disassembly of section .text:

00000000006d2eb0 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8hit_only>:
  6d2eb0:	test   %rsi,%rsi
  6d2eb3:	je     6d2ec6 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8hit_only+0x16>
  6d2eb5:	cmpb   $0x0,0x746(%rsi)
  6d2ebc:	je     6d2ed6 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8hit_only+0x26>
  6d2ebe:	movq   $0xe,(%rdi)
  6d2ec5:	ret
  6d2ec6:	movq   $0xd,(%rdi)
  6d2ecd:	movq   $0x0,0x8(%rdi)
  6d2ed5:	ret
  6d2ed6:	cmpb   $0x1,0x742(%rsi)
  6d2edd:	jne    6d2f5b <_RNvCs4gijoeCAvqI_25inspector_pointer_control8hit_only+0xab>
  6d2edf:	cmpb   $0x0,0x743(%rsi)
  6d2ee6:	jne    6d2f5b <_RNvCs4gijoeCAvqI_25inspector_pointer_control8hit_only+0xab>
  6d2ee8:	cmpb   $0x0,0x744(%rsi)
  6d2eef:	je     6d2f5b <_RNvCs4gijoeCAvqI_25inspector_pointer_control8hit_only+0xab>
  6d2ef1:	cmpq   $0xffffffffffffffff,0x5b0(%rsi)
  6d2ef9:	jne    6d2f5b <_RNvCs4gijoeCAvqI_25inspector_pointer_control8hit_only+0xab>
  6d2efb:	mov    0x688(%rsi),%rax
  6d2f02:	cmp    0x690(%rsi),%rax
  6d2f09:	jne    6d2f5b <_RNvCs4gijoeCAvqI_25inspector_pointer_control8hit_only+0xab>
  6d2f0b:	mov    0x6a0(%rsi),%rax
  6d2f12:	cmp    0x698(%rsi),%rax
  6d2f19:	jne    6d2f5b <_RNvCs4gijoeCAvqI_25inspector_pointer_control8hit_only+0xab>
  6d2f1b:	movss  0x738(%rsi),%xmm2
  6d2f23:	ucomiss 0x73c(%rsi),%xmm2
  6d2f2a:	jne    6d2f5b <_RNvCs4gijoeCAvqI_25inspector_pointer_control8hit_only+0xab>
  6d2f2c:	jp     6d2f5b <_RNvCs4gijoeCAvqI_25inspector_pointer_control8hit_only+0xab>
  6d2f2e:	push   %r14
  6d2f30:	push   %rbx
  6d2f31:	push   %rax
  6d2f32:	mov    %rdi,%rbx
  6d2f35:	mov    %rsi,%r14
  6d2f38:	mov    %rsi,%rdi
  6d2f3b:	call   6f80c0 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_>
  6d2f40:	cmp    $0x1,%rax
  6d2f44:	jne    6d2f63 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8hit_only+0xb3>
  6d2f46:	mov    %r14,%rdi
  6d2f49:	add    $0x5d8,%rdi
  6d2f50:	mov    %rdx,%rsi
  6d2f53:	call   *0x3460cf(%rip)        # a19028 <_DYNAMIC+0x460>
  6d2f59:	jmp    6d2f65 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8hit_only+0xb5>
  6d2f5b:	movq   $0x12,(%rdi)
  6d2f62:	ret
  6d2f63:	xor    %eax,%eax
  6d2f65:	mov    %rax,0x8(%rbx)
  6d2f69:	mov    %rdx,0x10(%rbx)
  6d2f6d:	movq   $0xfffffffffffffffe,(%rbx)
  6d2f74:	add    $0x8,%rsp
  6d2f78:	pop    %rbx
  6d2f79:	pop    %r14
  6d2f7b:	ret

/tmp/gpui-inspector-pointer-codegen/baseline-frozen:     file format elf64-x86-64


Disassembly of section .text:

00000000006db880 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE14inspector_pickB10_>:
  6db880:	push   %rbp
  6db881:	push   %r15
  6db883:	push   %r14
  6db885:	push   %r13
  6db887:	push   %r12
  6db889:	push   %rbx
  6db88a:	sub    $0x68,%rsp
  6db88e:	movss  %xmm1,0xc(%rsp)
  6db894:	movss  %xmm0,0x8(%rsp)
  6db89a:	mov    0x638(%rdi),%rbp
  6db8a1:	test   %rbp,%rbp
  6db8a4:	je     6dba0c <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE14inspector_pickB10_+0x18c>
  6db8aa:	cmpq   $0x0,0xd8(%rbp)
  6db8b2:	je     6dba0c <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE14inspector_pickB10_+0x18c>
  6db8b8:	mov    %rdi,%r15
  6db8bb:	mov    0x2c8(%rdi),%rbx
  6db8c2:	cmp    $0x1c,%rbx
  6db8c6:	jb     6dba0c <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE14inspector_pickB10_+0x18c>
  6db8cc:	mov    0x100(%rbp),%rsi
  6db8d3:	test   %rsi,%rsi
  6db8d6:	je     6db9eb <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE14inspector_pickB10_+0x16b>
  6db8dc:	lea    0x18(%rsp),%rdi
  6db8e1:	call   *0x33d771(%rip)        # a19058 <_DYNAMIC+0x490>
  6db8e7:	mov    0x5a8(%r15),%r13
  6db8ee:	test   %r13,%r13
  6db8f1:	je     6dba0c <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE14inspector_pickB10_+0x18c>
  6db8f7:	mov    %rbx,0x10(%rsp)
  6db8fc:	mov    0x5a0(%r15),%r12
  6db903:	mov    %r13,%r14
  6db906:	shl    $0x6,%r14
  6db90a:	add    $0xffffffffffffffc0,%r14
  6db90e:	xor    %ebx,%ebx
  6db910:	jmp    6db92e <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE14inspector_pickB10_+0xae>
  6db912:	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  6db920:	add    $0xffffffffffffffc0,%r14
  6db924:	cmp    $0xffffffffffffffc0,%r14
  6db928:	je     6dba0e <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE14inspector_pickB10_+0x18e>
  6db92e:	cmpb   $0x0,0x3e(%r12,%r14,1)
  6db934:	je     6db920 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE14inspector_pickB10_+0xa0>
  6db936:	mov    %r14,%r8
  6db939:	shr    $0x6,%r8
  6db93d:	mov    0x28(%rsp),%rax
  6db942:	mov    %rax,0x40(%rsp)
  6db947:	movups 0x18(%rsp),%xmm0
  6db94c:	movaps %xmm0,0x30(%rsp)
  6db951:	xor    %ecx,%ecx
  6db953:	cmpq   $0x0,0x0(%rbp)
  6db958:	setne  %cl
  6db95b:	mov    %r12,%rdi
  6db95e:	mov    %r13,%rsi
  6db961:	lea    0x30(%rsp),%rdx
  6db966:	movss  0x8(%rsp),%xmm0
  6db96c:	movss  0xc(%rsp),%xmm1
  6db972:	call   *0x33d740(%rip)        # a190b8 <_DYNAMIC+0x4f0>
  6db978:	test   %al,%al
  6db97a:	je     6db920 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE14inspector_pickB10_+0xa0>
  6db97c:	lea    0x5d8(%r15),%rdi
  6db983:	mov    0x20(%r12,%r14,1),%rsi
  6db988:	call   *0x33d69a(%rip)        # a19028 <_DYNAMIC+0x460>
  6db98e:	mov    %rdx,%r14
  6db991:	cmp    0x5d8(%r15),%rax
  6db998:	jne    6dba5e <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE14inspector_pickB10_+0x1de>
  6db99e:	mov    %rax,%rbx
  6db9a1:	lea    0x30(%rsp),%rdi
  6db9a6:	mov    %r15,%rsi
  6db9a9:	mov    %r14,%rdx
  6db9ac:	call   6f7de0 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE16resolve_identityBO_>
  6db9b1:	mov    0x30(%rsp),%rcx
  6db9b6:	mov    0x38(%rsp),%rax
  6db9bb:	cmp    $0xfffffffffffffffe,%rcx
  6db9bf:	jne    6dba23 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE14inspector_pickB10_+0x1a3>
  6db9c1:	cmpq   $0x0,0xd8(%rbp)
  6db9c9:	je     6dba5e <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE14inspector_pickB10_+0x1de>
  6db9cf:	mov    0x10(%rsp),%rdx
  6db9d4:	add    $0xffffffffffffffe4,%rdx
  6db9d8:	cmp    $0x2,%rax
  6db9dc:	setae  %cl
  6db9df:	cmp    %rdx,%rax
  6db9e2:	setb   %al
  6db9e5:	test   %al,%cl
  6db9e7:	jne    6dba0e <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE14inspector_pickB10_+0x18e>
  6db9e9:	jmp    6dba5e <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE14inspector_pickB10_+0x1de>
  6db9eb:	movq   $0x4,0x18(%rsp)
  6db9f4:	xorps  %xmm0,%xmm0
  6db9f7:	movups %xmm0,0x20(%rsp)
  6db9fc:	mov    0x5a8(%r15),%r13
  6dba03:	test   %r13,%r13
  6dba06:	jne    6db8f7 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE14inspector_pickB10_+0x77>
  6dba0c:	xor    %ebx,%ebx
  6dba0e:	mov    %rbx,%rax
  6dba11:	mov    %r14,%rdx
  6dba14:	add    $0x68,%rsp
  6dba18:	pop    %rbx
  6dba19:	pop    %r12
  6dba1b:	pop    %r13
  6dba1d:	pop    %r14
  6dba1f:	pop    %r15
  6dba21:	pop    %rbp
  6dba22:	ret
  6dba23:	mov    0x48(%rsp),%rsi
  6dba28:	mov    0x50(%rsp),%rdi
  6dba2d:	cmp    $0xc,%rcx
  6dba31:	jle    6dba4e <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE14inspector_pickB10_+0x1ce>
  6dba33:	cmp    $0x21,%rcx
  6dba37:	je     6dba4e <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE14inspector_pickB10_+0x1ce>
  6dba39:	cmp    $0x26,%rcx
  6dba3d:	jne    6dba5e <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE14inspector_pickB10_+0x1de>
  6dba3f:	test   %rax,%rax
  6dba42:	je     6dba5e <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE14inspector_pickB10_+0x1de>
  6dba44:	mov    0x40(%rsp),%rdi
  6dba49:	mov    %rax,%rsi
  6dba4c:	jmp    6dba53 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE14inspector_pickB10_+0x1d3>
  6dba4e:	test   %rsi,%rsi
  6dba51:	je     6dba5e <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE14inspector_pickB10_+0x1de>
  6dba53:	mov    $0x1,%edx
  6dba58:	call   *0x33d3aa(%rip)        # a18e08 <_DYNAMIC+0x240>
  6dba5e:	xor    %ebx,%ebx
  6dba60:	jmp    6dba0e <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE14inspector_pickB10_+0x18e>

/tmp/gpui-inspector-pointer-codegen/baseline-frozen:     file format elf64-x86-64


Disassembly of section .text:

00000000006f80c0 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_>:
  6f80c0:	push   %rbp
  6f80c1:	push   %r15
  6f80c3:	push   %r14
  6f80c5:	push   %r13
  6f80c7:	push   %r12
  6f80c9:	push   %rbx
  6f80ca:	sub    $0x48,%rsp
  6f80ce:	mov    %rdi,%r15
  6f80d1:	movq   $0x0,0x10(%rsp)
  6f80da:	movsd  0x698(%rdi),%xmm3
  6f80e2:	xorpd  %xmm2,%xmm2
  6f80e6:	unpcklps %xmm2,%xmm3
  6f80e9:	movapd -0x6b98d1(%rip),%xmm2        # 3e820 <GCC_except_table0+0x1128>
  6f80f1:	orpd   %xmm2,%xmm3
  6f80f5:	subpd  %xmm2,%xmm3
  6f80f9:	cvtpd2ps %xmm3,%xmm2
  6f80fd:	movlpd %xmm2,0x18(%rsp)
  6f8103:	lea    0x10(%rsp),%rdi
  6f8108:	movss  %xmm0,0x8(%rsp)
  6f810e:	movss  %xmm1,0xc(%rsp)
  6f8114:	call   *0x320f56(%rip)        # a19070 <_DYNAMIC+0x4a8>
  6f811a:	test   %al,%al
  6f811c:	je     6f8258 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x198>
  6f8122:	mov    0x638(%r15),%rbp
  6f8129:	test   %rbp,%rbp
  6f812c:	je     6f816d <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0xad>
  6f812e:	mov    0x100(%rbp),%rsi
  6f8135:	test   %rsi,%rsi
  6f8138:	je     6f816d <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0xad>
  6f813a:	lea    0x30(%rsp),%rdi
  6f813f:	call   *0x320f13(%rip)        # a19058 <_DYNAMIC+0x490>
  6f8145:	mov    0x5a8(%r15),%rbx
  6f814c:	test   %rbx,%rbx
  6f814f:	je     6f8258 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x198>
  6f8155:	mov    %r15,0x28(%rsp)
  6f815a:	mov    0x5a0(%r15),%r14
  6f8161:	mov    %rbx,%rax
  6f8164:	shl    $0x6,%rax
  6f8168:	add    %r14,%rax
  6f816b:	jmp    6f81ad <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0xed>
  6f816d:	movq   $0x4,0x30(%rsp)
  6f8176:	xorps  %xmm0,%xmm0
  6f8179:	movups %xmm0,0x38(%rsp)
  6f817e:	mov    0x5a8(%r15),%rbx
  6f8185:	test   %rbx,%rbx
  6f8188:	je     6f8258 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x198>
  6f818e:	mov    0x5a0(%r15),%r14
  6f8195:	mov    %rbx,%rax
  6f8198:	shl    $0x6,%rax
  6f819c:	add    %r14,%rax
  6f819f:	test   %rbp,%rbp
  6f81a2:	mov    %r15,0x28(%rsp)
  6f81a7:	je     6f826d <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x1ad>
  6f81ad:	xor    %r12d,%r12d
  6f81b0:	jmp    6f8218 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x158>
  6f81b2:	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  6f81c0:	mov    %r15,%r13
  6f81c3:	sub    %r14,%r13
  6f81c6:	shr    $0x6,%r13
  6f81ca:	mov    0x40(%rsp),%rax
  6f81cf:	mov    %rax,0x20(%rsp)
  6f81d4:	movups 0x30(%rsp),%xmm0
  6f81d9:	movaps %xmm0,0x10(%rsp)
  6f81de:	xor    %ecx,%ecx
  6f81e0:	cmpq   $0x0,0x0(%rbp)
  6f81e5:	setne  %cl
  6f81e8:	mov    %r14,%rdi
  6f81eb:	mov    %rbx,%rsi
  6f81ee:	lea    0x10(%rsp),%rdx
  6f81f3:	mov    %r13,%r8
  6f81f6:	movss  0x8(%rsp),%xmm0
  6f81fc:	movss  0xc(%rsp),%xmm1
  6f8202:	call   *0x320eb0(%rip)        # a190b8 <_DYNAMIC+0x4f0>
  6f8208:	test   %al,%al
  6f820a:	jne    6f8309 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x249>
  6f8210:	mov    %r15,%rax
  6f8213:	cmp    %r15,%r14
  6f8216:	je     6f825b <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x19b>
  6f8218:	lea    -0x40(%rax),%r15
  6f821c:	cmpb   $0x0,-0x2(%rax)
  6f8220:	jne    6f81c0 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x100>
  6f8222:	mov    -0x8(%rax),%eax
  6f8225:	cmp    $0x3ffff,%rax
  6f822b:	jbe    6f8210 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x150>
  6f822d:	shr    $0x11,%eax
  6f8230:	mov    %r15,%rcx
  6f8233:	sub    %r14,%rcx
  6f8236:	shr    $0x6,%rcx
  6f823a:	mov    $0x2,%edx
  6f823f:	sub    %rax,%rdx
  6f8242:	add    $0xfffffffffffffffe,%rax
  6f8246:	shl    $0x6,%rdx
  6f824a:	cmp    %rcx,%rax
  6f824d:	lea    -0x40(%r15,%rdx,1),%r15
  6f8252:	cmovae %r14,%r15
  6f8256:	jmp    6f8210 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x150>
  6f8258:	xor    %r12d,%r12d
  6f825b:	mov    %r12,%rax
  6f825e:	add    $0x48,%rsp
  6f8262:	pop    %rbx
  6f8263:	pop    %r12
  6f8265:	pop    %r13
  6f8267:	pop    %r14
  6f8269:	pop    %r15
  6f826b:	pop    %rbp
  6f826c:	ret
  6f826d:	xor    %r12d,%r12d
  6f8270:	mov    0x320e41(%rip),%r15        # a190b8 <_DYNAMIC+0x4f0>
  6f8277:	jmp    6f82c9 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x209>
  6f8279:	nopl   0x0(%rax)
  6f8280:	mov    %rbp,%r13
  6f8283:	sub    %r14,%r13
  6f8286:	shr    $0x6,%r13
  6f828a:	mov    0x40(%rsp),%rax
  6f828f:	mov    %rax,0x20(%rsp)
  6f8294:	movups 0x30(%rsp),%xmm0
  6f8299:	movaps %xmm0,0x10(%rsp)
  6f829e:	mov    %r14,%rdi
  6f82a1:	mov    %rbx,%rsi
  6f82a4:	lea    0x10(%rsp),%rdx
  6f82a9:	xor    %ecx,%ecx
  6f82ab:	mov    %r13,%r8
  6f82ae:	movss  0x8(%rsp),%xmm0
  6f82b4:	movss  0xc(%rsp),%xmm1
  6f82ba:	call   *%r15
  6f82bd:	test   %al,%al
  6f82bf:	jne    6f8309 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x249>
  6f82c1:	mov    %rbp,%rax
  6f82c4:	cmp    %rbp,%r14
  6f82c7:	je     6f825b <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x19b>
  6f82c9:	lea    -0x40(%rax),%rbp
  6f82cd:	cmpb   $0x0,-0x2(%rax)
  6f82d1:	jne    6f8280 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x1c0>
  6f82d3:	mov    -0x8(%rax),%eax
  6f82d6:	cmp    $0x40000,%rax
  6f82dc:	jb     6f82c1 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x201>
  6f82de:	shr    $0x11,%eax
  6f82e1:	mov    %rbp,%rcx
  6f82e4:	sub    %r14,%rcx
  6f82e7:	shr    $0x6,%rcx
  6f82eb:	mov    $0x2,%edx
  6f82f0:	sub    %rax,%rdx
  6f82f3:	add    $0xfffffffffffffffe,%rax
  6f82f7:	shl    $0x6,%rdx
  6f82fb:	cmp    %rcx,%rax
  6f82fe:	lea    -0x40(%rbp,%rdx,1),%rbp
  6f8303:	cmovae %r14,%rbp
  6f8307:	jmp    6f82c1 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x201>
  6f8309:	mov    0x28(%rsp),%rdx
  6f830e:	mov    0x1e8(%rdx),%rax
  6f8315:	mov    0x1f0(%rdx),%rcx
  6f831c:	mov    0x1f8(%rdx),%r8
  6f8323:	mov    0x2c8(%rdx),%rsi
  6f832a:	mov    0x2c0(%rdx),%r9
  6f8331:	jmp    6f8358 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x298>
  6f8333:	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  6f8340:	mov    0x38(%r10),%r13d
  6f8344:	and    $0x1ffff,%r13d
  6f834b:	cmp    $0x1ffff,%r13
  6f8352:	je     6f84b1 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x3f1>
  6f8358:	cmp    %rbx,%r13
  6f835b:	jae    6f84b9 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x3f9>
  6f8361:	shl    $0x6,%r13
  6f8365:	lea    (%r14,%r13,1),%r10
  6f8369:	mov    0x20(%r14,%r13,1),%rdx
  6f836e:	test   %rax,%rax
  6f8371:	je     6f8390 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x2d0>
  6f8373:	cmp    $0x1,%eax
  6f8376:	jne    6f83b0 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x2f0>
  6f8378:	test   %r8,%r8
  6f837b:	je     6f8340 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x280>
  6f837d:	cmp    $0x1,%r8
  6f8381:	jne    6f83d0 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x310>
  6f8383:	xor    %edi,%edi
  6f8385:	jmp    6f8404 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x344>
  6f8387:	nopw   0x0(%rax,%rax,1)
  6f8390:	mov    %rdx,%rdi
  6f8393:	sub    %rcx,%rdi
  6f8396:	setae  %r11b
  6f839a:	cmp    %r8,%rdi
  6f839d:	setb   %bpl
  6f83a1:	test   %bpl,%r11b
  6f83a4:	jne    6f8486 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x3c6>
  6f83aa:	jmp    6f8340 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x280>
  6f83ac:	nopl   0x0(%rax)
  6f83b0:	test   %r8,%r8
  6f83b3:	je     6f8340 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x280>
  6f83b5:	cmp    $0x1,%r8
  6f83b9:	jne    6f8445 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x385>
  6f83bf:	mov    %rcx,%rdi
  6f83c2:	cmp    %rdx,(%rcx)
  6f83c5:	jne    6f8340 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x280>
  6f83cb:	jmp    6f8483 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x3c3>
  6f83d0:	mov    %r8,%r11
  6f83d3:	xor    %edi,%edi
  6f83d5:	data16 cs nopw 0x0(%rax,%rax,1)
  6f83e0:	mov    %rdi,%r15
  6f83e3:	mov    %r11,%r12
  6f83e6:	shr    $1,%r12
  6f83e9:	add    %r12,%rdi
  6f83ec:	mov    %rdi,%r13
  6f83ef:	shl    $0x4,%r13
  6f83f3:	cmp    %rdx,(%rcx,%r13,1)
  6f83f7:	cmova  %r15,%rdi
  6f83fb:	sub    %r12,%r11
  6f83fe:	cmp    $0x1,%r11
  6f8402:	ja     6f83e0 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x320>
  6f8404:	mov    %rdi,%r15
  6f8407:	shl    $0x4,%r15
  6f840b:	xor    %r11d,%r11d
  6f840e:	cmp    %rdx,(%rcx,%r15,1)
  6f8412:	setbe  %r11b
  6f8416:	add    %rdi,%r11
  6f8419:	je     6f8340 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x280>
  6f841f:	shl    $0x4,%r11
  6f8423:	mov    %rdx,%rdi
  6f8426:	sub    -0x10(%rcx,%r11,1),%rdi
  6f842b:	mov    -0x4(%rcx,%r11,1),%r15d
  6f8430:	cmp    %r15,%rdi
  6f8433:	jae    6f8340 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x280>
  6f8439:	add    %rcx,%r11
  6f843c:	mov    -0x8(%r11),%r11d
  6f8440:	add    %r11,%rdi
  6f8443:	jmp    6f8486 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x3c6>
  6f8445:	mov    %r8,%rdi
  6f8448:	xor    %r11d,%r11d
  6f844b:	nopl   0x0(%rax,%rax,1)
  6f8450:	mov    %r11,%r15
  6f8453:	mov    %rdi,%r12
  6f8456:	shr    $1,%r12
  6f8459:	add    %r12,%r11
  6f845c:	lea    (%r11,%r11,2),%r13
  6f8460:	cmp    %rdx,(%rcx,%r13,4)
  6f8464:	cmova  %r15,%r11
  6f8468:	sub    %r12,%rdi
  6f846b:	cmp    $0x1,%rdi
  6f846f:	ja     6f8450 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x390>
  6f8471:	lea    (%r11,%r11,2),%rdi
  6f8475:	cmp    %rdx,(%rcx,%rdi,4)
  6f8479:	jne    6f8340 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x280>
  6f847f:	lea    (%rcx,%rdi,4),%rdi
  6f8483:	mov    0x8(%rdi),%edi
  6f8486:	cmp    %rsi,%rdi
  6f8489:	jae    6f84cc <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x40c>
  6f848b:	lea    (%rdi,%rdi,4),%rdi
  6f848f:	mov    $0x1,%r12d
  6f8495:	cmpq   $0x0,0x8(%r9,%rdi,8)
  6f849b:	jne    6f825b <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x19b>
  6f84a1:	cmpb   $0x4,0x3d(%r10)
  6f84a6:	jne    6f8340 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x280>
  6f84ac:	jmp    6f825b <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x19b>
  6f84b1:	xor    %r12d,%r12d
  6f84b4:	jmp    6f825b <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x19b>
  6f84b9:	lea    0x302488(%rip),%rdx        # 9fa948 <__frame_dummy_init_array_entry+0x1538>
  6f84c0:	mov    %r13,%rdi
  6f84c3:	mov    %rbx,%rsi
  6f84c6:	call   *0x32096c(%rip)        # a18e38 <_DYNAMIC+0x270>
  6f84cc:	lea    0x30248d(%rip),%rdx        # 9fa960 <__frame_dummy_init_array_entry+0x1550>
  6f84d3:	call   *0x32095f(%rip)        # a18e38 <_DYNAMIC+0x270>

inspector_pointer_control::click_only bytes=743 stack=136

inspector_pointer_control::ack bytes=241 stack=136

inspector_pointer_control::main bytes=7119 stack=3368

inspector_pointer_control::dispatch bytes=3218 stack=232

inspector_pointer_control::hit_only bytes=204 stack=24

<gpui::runtime::Runtime<inspector_pointer_control::Model>>::inspector_pick bytes=482 stack=152

<gpui::runtime::Runtime<inspector_pointer_control::Model>>::hit bytes=1049 stack=120
