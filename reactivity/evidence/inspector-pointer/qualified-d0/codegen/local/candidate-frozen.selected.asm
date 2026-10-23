
/tmp/gpui-inspector-pointer-codegen-local/candidate-frozen:     file format elf64-x86-64


Disassembly of section .text:

00000000006d0340 <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only>:
  6d0340:	push   %rbp
  6d0341:	push   %r15
  6d0343:	push   %r14
  6d0345:	push   %r13
  6d0347:	push   %r12
  6d0349:	push   %rbx
  6d034a:	sub    $0x68,%rsp
  6d034e:	mov    (%rsi),%rbx
  6d0351:	test   %rbx,%rbx
  6d0354:	je     6d0379 <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x39>
  6d0356:	add    $0x8,%rsi
  6d035a:	mov    %rbx,0x58(%rsp)
  6d035f:	mov    %rsi,0x60(%rsp)
  6d0364:	cmpb   $0x1,0x746(%rbx)
  6d036b:	jne    6d038d <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x4d>
  6d036d:	movq   $0xe,(%rdi)
  6d0374:	jmp    6d046c <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x12c>
  6d0379:	movq   $0xd,(%rdi)
  6d0380:	movq   $0x0,0x8(%rdi)
  6d0388:	jmp    6d046c <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x12c>
  6d038d:	cmpb   $0x1,0x742(%rbx)
  6d0394:	jne    6d0465 <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x125>
  6d039a:	cmpb   $0x0,0x743(%rbx)
  6d03a1:	jne    6d0465 <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x125>
  6d03a7:	cmpb   $0x0,0x744(%rbx)
  6d03ae:	je     6d0465 <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x125>
  6d03b4:	cmpq   $0xffffffffffffffff,0x5b0(%rbx)
  6d03bc:	jne    6d0465 <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x125>
  6d03c2:	mov    0x688(%rbx),%rax
  6d03c9:	cmp    0x690(%rbx),%rax
  6d03d0:	jne    6d0465 <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x125>
  6d03d6:	mov    0x6a0(%rbx),%rax
  6d03dd:	cmp    0x698(%rbx),%rax
  6d03e4:	jne    6d0465 <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x125>
  6d03e6:	movss  0x738(%rbx),%xmm2
  6d03ee:	ucomiss 0x73c(%rbx),%xmm2
  6d03f5:	jne    6d0465 <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x125>
  6d03f7:	jp     6d0465 <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x125>
  6d03f9:	mov    0x638(%rbx),%r15
  6d0400:	test   %r15,%r15
  6d0403:	movss  %xmm1,0x4(%rsp)
  6d0409:	movss  %xmm0,(%rsp)
  6d040e:	je     6d047b <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x13b>
  6d0410:	mov    0xd8(%r15),%rcx
  6d0417:	test   %rcx,%rcx
  6d041a:	je     6d047b <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x13b>
  6d041c:	cmpb   $0x0,0x12(%rcx)
  6d0420:	je     6d047b <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x13b>
  6d0422:	mov    %rdi,%r14
  6d0425:	mov    0x5a0(%rbx),%r12
  6d042c:	mov    0x5a8(%rbx),%r13
  6d0433:	mov    0x100(%r15),%rsi
  6d043a:	test   %rsi,%rsi
  6d043d:	je     6d05d9 <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x299>
  6d0443:	lea    0x40(%rsp),%rdi
  6d0448:	call   *0x349302(%rip)        # a19750 <_DYNAMIC+0x460>
  6d044e:	movss  (%rsp),%xmm0
  6d0453:	movss  0x4(%rsp),%xmm1
  6d0459:	mov    0x698(%rbx),%rax
  6d0460:	jmp    6d05ea <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x2aa>
  6d0465:	movq   $0x12,(%rdi)
  6d046c:	add    $0x68,%rsp
  6d0470:	pop    %rbx
  6d0471:	pop    %r12
  6d0473:	pop    %r13
  6d0475:	pop    %r14
  6d0477:	pop    %r15
  6d0479:	pop    %rbp
  6d047a:	ret
  6d047b:	mov    %rdi,%r14
  6d047e:	mov    %rbx,%rdi
  6d0481:	call   6f87f0 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_>
  6d0486:	cmp    $0x1,%rax
  6d048a:	jne    6d052d <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x1ed>
  6d0490:	lea    0x5d8(%rbx),%rdi
  6d0497:	mov    %rdx,%rsi
  6d049a:	call   *0x3492b8(%rip)        # a19758 <_DYNAMIC+0x468>
  6d04a0:	cmp    0x5d8(%rbx),%rax
  6d04a7:	jne    6d05ab <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x26b>
  6d04ad:	mov    %rax,%r12
  6d04b0:	mov    %rdx,%r15
  6d04b3:	lea    0x8(%rsp),%rdi
  6d04b8:	mov    %rbx,%rsi
  6d04bb:	call   6f8510 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE16resolve_identityBO_>
  6d04c0:	mov    0x8(%rsp),%rax
  6d04c5:	mov    0x10(%rsp),%rdi
  6d04ca:	cmp    $0xfffffffffffffffe,%rax
  6d04ce:	jne    6d05b0 <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x270>
  6d04d4:	mov    0x2c8(%rbx),%rsi
  6d04db:	cmp    %rsi,%rdi
  6d04de:	jae    6d06a2 <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x362>
  6d04e4:	mov    0x2c0(%rbx),%rax
  6d04eb:	lea    (%rdi,%rdi,4),%rcx
  6d04ef:	mov    0x20(%rax,%rcx,8),%edi
  6d04f3:	call   6e1fa0 <_RNvMsh_NtCs6ZNK6sH19NW_4gpui7runtimeNtB5_4Node4kind>
  6d04f8:	cmp    $0x4,%al
  6d04fa:	jne    6d0654 <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x314>
  6d0500:	mov    %r14,%rdi
  6d0503:	mov    %rbx,%rsi
  6d0506:	mov    %r12,%rdx
  6d0509:	mov    %r15,%rcx
  6d050c:	movss  (%rsp),%xmm0
  6d0511:	movss  0x4(%rsp),%xmm1
  6d0517:	xor    %r8d,%r8d
  6d051a:	add    $0x68,%rsp
  6d051e:	pop    %rbx
  6d051f:	pop    %r12
  6d0521:	pop    %r13
  6d0523:	pop    %r14
  6d0525:	pop    %r15
  6d0527:	pop    %rbp
  6d0528:	jmp    6db8d0 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime7editingINtB7_10RuntimeMutNtCs4gijoeCAvqI_25inspector_pointer_control5ModeluE14select_pointerB12_>
  6d052d:	mov    0x610(%rbx),%rdx
  6d0534:	mov    0x618(%rbx),%rcx
  6d053b:	movq   $0x0,0x610(%rbx)
  6d0546:	movq   $0x0,0x730(%rbx)
  6d0551:	lea    0x8(%rsp),%rdi
  6d0556:	mov    %rbx,%rsi
  6d0559:	call   6dbef0 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime7editingINtB7_10RuntimeMutNtCs4gijoeCAvqI_25inspector_pointer_control5ModeluE20publish_focus_changeB12_>
  6d055e:	mov    0x8(%rsp),%rax
  6d0563:	cmp    $0xfffffffffffffffe,%rax
  6d0567:	je     6d0648 <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x308>
  6d056d:	mov    0x30(%rsp),%rcx
  6d0572:	movzbl 0x38(%rsp),%edx
  6d0577:	mov    0x3c(%rsp),%esi
  6d057b:	mov    %esi,0x34(%r14)
  6d057f:	mov    0x39(%rsp),%esi
  6d0583:	mov    %esi,0x31(%r14)
  6d0587:	movups 0x10(%rsp),%xmm0
  6d058c:	movups 0x20(%rsp),%xmm1
  6d0591:	mov    %rax,(%r14)
  6d0594:	movups %xmm0,0x8(%r14)
  6d0599:	movups %xmm1,0x18(%r14)
  6d059e:	mov    %rcx,0x28(%r14)
  6d05a2:	mov    %dl,0x30(%r14)
  6d05a6:	jmp    6d046c <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x12c>
  6d05ab:	mov    $0x11,%eax
  6d05b0:	mov    0x38(%rsp),%rcx
  6d05b5:	mov    %rcx,0x30(%r14)
  6d05b9:	movups 0x18(%rsp),%xmm0
  6d05be:	movups 0x28(%rsp),%xmm1
  6d05c3:	movups %xmm1,0x20(%r14)
  6d05c8:	movups %xmm0,0x10(%r14)
  6d05cd:	mov    %rax,(%r14)
  6d05d0:	mov    %rdi,0x8(%r14)
  6d05d4:	jmp    6d046c <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x12c>
  6d05d9:	movq   $0x4,0x40(%rsp)
  6d05e2:	xorps  %xmm2,%xmm2
  6d05e5:	movups %xmm2,0x48(%rsp)
  6d05ea:	cmpq   $0x0,(%r15)
  6d05ee:	mov    %r12,0x8(%rsp)
  6d05f3:	mov    %r13,0x10(%rsp)
  6d05f8:	mov    0x40(%rsp),%rcx
  6d05fd:	mov    %rcx,0x18(%rsp)
  6d0602:	mov    0x48(%rsp),%rcx
  6d0607:	mov    %rcx,0x20(%rsp)
  6d060c:	mov    0x50(%rsp),%rcx
  6d0611:	mov    %rcx,0x28(%rsp)
  6d0616:	mov    %rax,0x30(%rsp)
  6d061b:	setne  0x38(%rsp)
  6d0620:	lea    0x8(%rsp),%rsi
  6d0625:	mov    %rbx,%rdi
  6d0628:	call   6dd620 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE23inspector_pick_in_sheetB10_>
  6d062d:	test   %rax,%rax
  6d0630:	je     6d0648 <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x308>
  6d0632:	mov    %rdx,%rcx
  6d0635:	mov    %r14,%rdi
  6d0638:	mov    %rbx,%rsi
  6d063b:	mov    %rax,%rdx
  6d063e:	call   6df6e0 <_RNvMs4_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_10RuntimeMutNtCs4gijoeCAvqI_25inspector_pointer_control5ModeluE16inspector_selectB14_>
  6d0643:	jmp    6d046c <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x12c>
  6d0648:	movq   $0x19,(%r14)
  6d064f:	jmp    6d046c <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x12c>
  6d0654:	mov    0x610(%rbx),%r13
  6d065b:	mov    0x618(%rbx),%rbp
  6d0662:	lea    0x8(%rsp),%rdi
  6d0667:	mov    %rbx,%rsi
  6d066a:	mov    %r12,%rdx
  6d066d:	mov    %r15,%rcx
  6d0670:	call   6db550 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE5focusBW_>
  6d0675:	mov    0x8(%rsp),%rax
  6d067a:	cmp    $0xfffffffffffffffe,%rax
  6d067e:	jne    6d056d <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x22d>
  6d0684:	lea    0x58(%rsp),%rsi
  6d0689:	mov    %r14,%rdi
  6d068c:	mov    %r12,%rdx
  6d068f:	mov    %r15,%rcx
  6d0692:	mov    %r13,%r8
  6d0695:	mov    %rbp,%r9
  6d0698:	call   6d30e0 <_RNvMNtNtCs6ZNK6sH19NW_4gpui7runtime4turnINtB4_10RuntimeMutNtCs4gijoeCAvqI_25inspector_pointer_control5ModeluE16activate_focusedBW_>
  6d069d:	jmp    6d046c <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x12c>
  6d06a2:	lea    0x32a66f(%rip),%rdx        # 9fad18 <__frame_dummy_init_array_entry+0x11f8>
  6d06a9:	call   *0x348eb1(%rip)        # a19560 <_DYNAMIC+0x270>

/tmp/gpui-inspector-pointer-codegen-local/candidate-frozen:     file format elf64-x86-64


Disassembly of section .text:

00000000006d06b0 <_RNvCs4gijoeCAvqI_25inspector_pointer_control3ack>:
  6d06b0:	push   %r14
  6d06b2:	push   %rbx
  6d06b3:	sub    $0x78,%rsp
  6d06b7:	test   %rdi,%rdi
  6d06ba:	je     6d06f5 <_RNvCs4gijoeCAvqI_25inspector_pointer_control3ack+0x45>
  6d06bc:	mov    %rdi,%rsi
  6d06bf:	cmpb   $0x0,0x746(%rdi)
  6d06c6:	jne    6d06fc <_RNvCs4gijoeCAvqI_25inspector_pointer_control3ack+0x4c>
  6d06c8:	mov    0x6a8(%rsi),%rdx
  6d06cf:	test   %rdx,%rdx
  6d06d2:	je     6d0703 <_RNvCs4gijoeCAvqI_25inspector_pointer_control3ack+0x53>
  6d06d4:	mov    0x6b0(%rsi),%rcx
  6d06db:	lea    0x40(%rsp),%rdi
  6d06e0:	call   6e7290 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE11acknowledgeBO_>
  6d06e5:	cmpq   $0xfffffffffffffffe,0x40(%rsp)
  6d06eb:	jne    6d073d <_RNvCs4gijoeCAvqI_25inspector_pointer_control3ack+0x8d>
  6d06ed:	add    $0x78,%rsp
  6d06f1:	pop    %rbx
  6d06f2:	pop    %r14
  6d06f4:	ret
  6d06f5:	mov    $0xd,%eax
  6d06fa:	jmp    6d0708 <_RNvCs4gijoeCAvqI_25inspector_pointer_control3ack+0x58>
  6d06fc:	mov    $0xe,%eax
  6d0701:	jmp    6d0708 <_RNvCs4gijoeCAvqI_25inspector_pointer_control3ack+0x58>
  6d0703:	mov    $0x14,%eax
  6d0708:	mov    %rax,(%rsp)
  6d070c:	movq   $0x0,0x8(%rsp)
  6d0715:	lea    -0x685fc2(%rip),%rdi        # 4a75a <GCC_except_table0+0xd026>
  6d071c:	lea    0x329ee5(%rip),%rcx        # 9fa608 <__frame_dummy_init_array_entry+0xae8>
  6d0723:	lea    0x329cfe(%rip),%r8        # 9fa428 <__frame_dummy_init_array_entry+0x908>
  6d072a:	mov    %rsp,%rbx
  6d072d:	mov    $0x2b,%esi
  6d0732:	mov    %rbx,%rdx
  6d0735:	call   *0x348ea5(%rip)        # a195e0 <_DYNAMIC+0x2f0>
  6d073b:	jmp    6d078a <_RNvCs4gijoeCAvqI_25inspector_pointer_control3ack+0xda>
  6d073d:	mov    0x70(%rsp),%rax
  6d0742:	mov    %rax,0x30(%rsp)
  6d0747:	movups 0x40(%rsp),%xmm0
  6d074c:	movups 0x50(%rsp),%xmm1
  6d0751:	movups 0x60(%rsp),%xmm2
  6d0756:	movaps %xmm2,0x20(%rsp)
  6d075b:	movaps %xmm1,0x10(%rsp)
  6d0760:	movaps %xmm0,(%rsp)
  6d0764:	lea    -0x686011(%rip),%rdi        # 4a75a <GCC_except_table0+0xd026>
  6d076b:	lea    0x329e96(%rip),%rcx        # 9fa608 <__frame_dummy_init_array_entry+0xae8>
  6d0772:	lea    0x329cc7(%rip),%r8        # 9fa440 <__frame_dummy_init_array_entry+0x920>
  6d0779:	mov    %rsp,%rbx
  6d077c:	mov    $0x2b,%esi
  6d0781:	mov    %rbx,%rdx
  6d0784:	call   *0x348e56(%rip)        # a195e0 <_DYNAMIC+0x2f0>
  6d078a:	ud2
  6d078c:	jmp    6d078e <_RNvCs4gijoeCAvqI_25inspector_pointer_control3ack+0xde>
  6d078e:	mov    %rax,%r14
  6d0791:	mov    %rbx,%rdi
  6d0794:	call   6be330 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueNtNtCs6ZNK6sH19NW_4gpui7runtime5ErrorECs4gijoeCAvqI_25inspector_pointer_control>
  6d0799:	mov    %r14,%rdi
  6d079c:	call   9f8770 <_Unwind_Resume@plt>

/tmp/gpui-inspector-pointer-codegen-local/candidate-frozen:     file format elf64-x86-64


Disassembly of section .text:

00000000006d07b0 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main>:
  6d07b0:	push   %rbp
  6d07b1:	push   %r15
  6d07b3:	push   %r14
  6d07b5:	push   %r13
  6d07b7:	push   %r12
  6d07b9:	push   %rbx
  6d07ba:	sub    $0xcf8,%rsp
  6d07c1:	call   *0x348d71(%rip)        # a19538 <_DYNAMIC+0x248>
  6d07c7:	mov    $0x6,%edi
  6d07cc:	mov    $0x1,%esi
  6d07d1:	call   *0x348d69(%rip)        # a19540 <_DYNAMIC+0x250>
  6d07d7:	test   %rax,%rax
  6d07da:	je     6d1ec6 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1716>
  6d07e0:	mov    %rax,%rbx
  6d07e3:	movw   $0x6863,0x4(%rax)
  6d07e9:	movl   $0x72616573,(%rax)
  6d07ef:	lea    0x3c0(%rsp),%rdi
  6d07f7:	movabs $0x384000002d0,%r14
  6d0801:	movss  -0x693099(%rip),%xmm0        # 3d770 <GCC_except_table0+0x3c>
  6d0809:	mov    %r14,%rsi
  6d080c:	call   *0x348f4e(%rip)        # a19760 <_DYNAMIC+0x470>
  6d0812:	mov    0x3c0(%rsp),%r13
  6d081a:	cmp    $0xfffffffffffffffe,%r13
  6d081e:	jne    6d1ed6 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1726>
  6d0824:	movq   $0x0,0x3d8(%rsp)
  6d0830:	movq   $0x8,0x3e0(%rsp)
  6d083c:	xorps  %xmm0,%xmm0
  6d083f:	movups %xmm0,0x3e8(%rsp)
  6d0847:	movq   $0xffffffffffffffff,0x3c0(%rsp)
  6d0853:	movq   $0x8,0x3f8(%rsp)
  6d085f:	movups %xmm0,0x400(%rsp)
  6d0867:	movq   $0x8,0x410(%rsp)
  6d0873:	movq   $0x0,0x418(%rsp)
  6d087f:	movq   $0x1,0x420(%rsp)
  6d088b:	mov    $0x1,%edi
  6d0890:	call   *0x348ed2(%rip)        # a19768 <_DYNAMIC+0x478>
  6d0896:	mov    %rax,%r13
  6d0899:	cmp    $0x1,%r13d
  6d089d:	je     6d08b3 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x103>
  6d089f:	movq   $0x0,0x3c0(%rsp)
  6d08ab:	mov    %r13,0x3c8(%rsp)
  6d08b3:	call   *0x348c7f(%rip)        # a19538 <_DYNAMIC+0x248>
  6d08b9:	mov    $0x28,%edi
  6d08be:	mov    $0x8,%esi
  6d08c3:	call   *0x348c77(%rip)        # a19540 <_DYNAMIC+0x250>
  6d08c9:	test   %rax,%rax
  6d08cc:	je     6d1ad4 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1324>
  6d08d2:	mov    %rax,%r15
  6d08d5:	lea    0x3d8(%rsp),%r12
  6d08dd:	mov    %r13,(%rax)
  6d08e0:	lea    -0x6930b3(%rip),%rax        # 3d834 <GCC_except_table0+0x100>
  6d08e7:	mov    %rax,0x8(%r15)
  6d08eb:	movq   $0x4,0x10(%r15)
  6d08f3:	lea    0x32d86(%rip),%rax        # 703680 <_RNvYNCNvXCs4gijoeCAvqI_25inspector_pointer_controlNtB7_5ModelNtCs6ZNK6sH19NW_4gpui4View7sources0INtNtNtCs4NRVxsYgnAr_4core3ops8function6FnOnceTRBM_EE9call_onceB7_>
  6d08fa:	mov    %rax,0x18(%r15)
  6d08fe:	lea    0x32d8b(%rip),%rax        # 703690 <_RNvYNCNvXCs4gijoeCAvqI_25inspector_pointer_controlNtB7_5ModelNtCs6ZNK6sH19NW_4gpui4View7sourcess_0INtNtNtCs4NRVxsYgnAr_4core3ops8function6FnOnceTQBM_EE9call_onceB7_>
  6d0905:	mov    %rax,0x20(%r15)
  6d0909:	mov    %r12,%rdi
  6d090c:	call   6dd840 <_RNvMs3_NtCscdodAO9FK5_5alloc7raw_vecINtB5_6RawVecAINtNtCs4NRVxsYgnAr_4core6option6OptionNtNtCs6ZNK6sH19NW_4gpui6source7FieldIdEj2_E8grow_oneCs4gijoeCAvqI_25inspector_pointer_control>
  6d0911:	mov    0x3e0(%rsp),%rax
  6d0919:	mov    %r15,(%rax)
  6d091c:	lea    0x329405(%rip),%rcx        # 9f9d28 <__frame_dummy_init_array_entry+0x208>
  6d0923:	mov    %rcx,0x8(%rax)
  6d0927:	movq   $0x1,0x3e8(%rsp)
  6d0933:	mov    0x3c0(%rsp),%rax
  6d093b:	movups 0x40(%r12),%xmm0
  6d0941:	movaps %xmm0,0x160(%rsp)
  6d0949:	movups (%r12),%xmm0
  6d094e:	movups 0x10(%r12),%xmm1
  6d0954:	movups 0x20(%r12),%xmm2
  6d095a:	movups 0x30(%r12),%xmm3
  6d0960:	movaps %xmm3,0x150(%rsp)
  6d0968:	movaps %xmm2,0x140(%rsp)
  6d0970:	movaps %xmm1,0x130(%rsp)
  6d0978:	movups 0x3c8(%rsp),%xmm2
  6d0980:	movups %xmm0,0xb8(%rsp)
  6d0988:	movups %xmm1,0xc8(%rsp)
  6d0990:	mov    0x140(%rsp),%rcx
  6d0998:	mov    %rcx,0xd8(%rsp)
  6d09a0:	movups 0x148(%rsp),%xmm0
  6d09a8:	movups %xmm0,0xe0(%rsp)
  6d09b0:	movups 0x158(%rsp),%xmm0
  6d09b8:	movups %xmm0,0xf0(%rsp)
  6d09c0:	mov    0x168(%rsp),%rcx
  6d09c8:	mov    %rcx,0x100(%rsp)
  6d09d0:	mov    %rax,0xa0(%rsp)
  6d09d8:	movups %xmm2,0xa8(%rsp)
  6d09e0:	movl   $0x0,0x120(%rsp)
  6d09eb:	movl   $0x434b0000,0x128(%rsp)
  6d09f6:	movw   $0x0,0x12c(%rsp)
  6d0a00:	lea    0x3c0(%rsp),%rdi
  6d0a08:	lea    0x120(%rsp),%rcx
  6d0a10:	mov    $0x2d0,%esi
  6d0a15:	mov    $0x384,%edx
  6d0a1a:	call   *0x348d50(%rip)        # a19770 <_DYNAMIC+0x480>
  6d0a20:	mov    0x3c0(%rsp),%r13
  6d0a28:	mov    0x3c8(%rsp),%r15d
  6d0a30:	mov    0x3cc(%rsp),%r12d
  6d0a38:	cmp    $0x2,%r13
  6d0a3c:	je     6d1f1f <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x176f>
  6d0a42:	lea    0x3d0(%rsp),%rsi
  6d0a4a:	lea    0xb20(%rsp),%rdi
  6d0a52:	mov    $0x1d8,%edx
  6d0a57:	call   *0x348af3(%rip)        # a19550 <memcpy@GLIBC_2.14>
  6d0a5d:	mov    %r13,0xb10(%rsp)
  6d0a65:	mov    %r15d,0xb18(%rsp)
  6d0a6d:	mov    %r12d,0xb1c(%rsp)
  6d0a75:	call   *0x348cfd(%rip)        # a19778 <_DYNAMIC+0x488>
  6d0a7b:	mov    %rax,%r15
  6d0a7e:	lea    0x120(%rsp),%rdi
  6d0a86:	call   *0x348cf4(%rip)        # a19780 <_DYNAMIC+0x490>
  6d0a8c:	movq   $0x6,0x660(%rsp)
  6d0a98:	movl   $0x0,0x668(%rsp)
  6d0aa3:	movq   $0x0,0x670(%rsp)
  6d0aaf:	movups 0xa0(%rsp),%xmm0
  6d0ab7:	movups 0xb0(%rsp),%xmm1
  6d0abf:	movups 0xc0(%rsp),%xmm2
  6d0ac7:	movups 0xd0(%rsp),%xmm3
  6d0acf:	movups %xmm0,0x5e8(%rsp)
  6d0ad7:	movups %xmm1,0x5f8(%rsp)
  6d0adf:	movups %xmm2,0x608(%rsp)
  6d0ae7:	movups %xmm3,0x618(%rsp)
  6d0aef:	movups 0xe0(%rsp),%xmm0
  6d0af7:	movups %xmm0,0x628(%rsp)
  6d0aff:	movups 0xf0(%rsp),%xmm0
  6d0b07:	movups %xmm0,0x638(%rsp)
  6d0b0f:	mov    0x100(%rsp),%rax
  6d0b17:	mov    %rax,0x648(%rsp)
  6d0b1f:	lea    0x6a8(%rsp),%rdi
  6d0b27:	lea    0x120(%rsp),%rsi
  6d0b2f:	mov    0x348a1a(%rip),%r12        # a19550 <memcpy@GLIBC_2.14>
  6d0b36:	mov    $0x298,%edx
  6d0b3b:	call   *%r12
  6d0b3e:	lea    0x3c0(%rsp),%rdi
  6d0b46:	lea    0xb10(%rsp),%rsi
  6d0b4e:	mov    $0x1e8,%edx
  6d0b53:	call   *%r12
  6d0b56:	movq   $0x6,0x650(%rsp)
  6d0b62:	mov    %rbx,0x658(%rsp)
  6d0b6a:	movq   $0x0,0x678(%rsp)
  6d0b76:	movq   $0x8,0x680(%rsp)
  6d0b82:	xorps  %xmm0,%xmm0
  6d0b85:	movups %xmm0,0x688(%rsp)
  6d0b8d:	movq   $0x8,0x698(%rsp)
  6d0b99:	movq   $0x0,0x6a0(%rsp)
  6d0ba5:	movq   $0x0,0x9c0(%rsp)
  6d0bb1:	movups %xmm0,0x5a8(%rsp)
  6d0bb9:	movups %xmm0,0x5b8(%rsp)
  6d0bc1:	movups %xmm0,0x9a8(%rsp)
  6d0bc9:	movq   $0x1,0x9c8(%rsp)
  6d0bd5:	movq   $0x0,0x9d0(%rsp)
  6d0be1:	mov    %r15,0x998(%rsp)
  6d0be9:	movq   $0x0,0x9e0(%rsp)
  6d0bf5:	movq   $0x0,0xa28(%rsp)
  6d0c01:	movups %xmm0,0x9f0(%rsp)
  6d0c09:	movq   $0x0,0xa00(%rsp)
  6d0c15:	movups %xmm0,0xa10(%rsp)
  6d0c1d:	movq   $0x0,0x940(%rsp)
  6d0c29:	movq   $0x8,0x948(%rsp)
  6d0c35:	movups %xmm0,0x950(%rsp)
  6d0c3d:	movq   $0x0,0xa30(%rsp)
  6d0c49:	movq   $0x0,0xa40(%rsp)
  6d0c55:	movl   $0x1000101,0xb00(%rsp)
  6d0c60:	movw   $0x0,0xb04(%rsp)
  6d0c6a:	movups %xmm0,0xa48(%rsp)
  6d0c72:	movq   $0x0,0xa58(%rsp)
  6d0c7e:	mov    %r14,0xa60(%rsp)
  6d0c86:	movsd  -0x6929be(%rip),%xmm1        # 3e2d0 <GCC_except_table0+0xb9c>
  6d0c8e:	movsd  %xmm1,0xaf8(%rsp)
  6d0c97:	movq   $0x1,0x9a0(%rsp)
  6d0ca3:	movq   $0xffffffffffffffff,0x970(%rsp)
  6d0caf:	movq   $0x0,0xa68(%rsp)
  6d0cbb:	movq   $0x0,0xa78(%rsp)
  6d0cc7:	movq   $0x8,0x960(%rsp)
  6d0cd3:	movq   $0x0,0x968(%rsp)
  6d0cdf:	movb   $0x0,0xb06(%rsp)
  6d0ce7:	movups %xmm0,0xae0(%rsp)
  6d0cef:	movups %xmm0,0xad0(%rsp)
  6d0cf7:	movups %xmm0,0xac0(%rsp)
  6d0cff:	movups %xmm0,0xab0(%rsp)
  6d0d07:	movups %xmm0,0xaa0(%rsp)
  6d0d0f:	movups %xmm0,0xa90(%rsp)
  6d0d17:	movups %xmm0,0xa80(%rsp)
  6d0d1f:	movq   $0x0,0xaf0(%rsp)
  6d0d2b:	call   *0x348807(%rip)        # a19538 <_DYNAMIC+0x248>
  6d0d31:	mov    $0x748,%edi
  6d0d36:	mov    $0x8,%esi
  6d0d3b:	call   *0x3487ff(%rip)        # a19540 <_DYNAMIC+0x250>
  6d0d41:	test   %rax,%rax
  6d0d44:	je     6d1ae9 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1339>
  6d0d4a:	mov    %rax,%rbx
  6d0d4d:	lea    0x3c0(%rsp),%rsi
  6d0d55:	mov    $0x748,%edx
  6d0d5a:	mov    %rax,%rdi
  6d0d5d:	call   *0x3487ed(%rip)        # a19550 <memcpy@GLIBC_2.14>
  6d0d63:	mov    %rbx,0x8(%rsp)
  6d0d68:	lea    0x10(%rsp),%rdx
  6d0d6d:	movq   $0x0,(%rsp)
  6d0d75:	lea    0x68(%rsp),%rdi
  6d0d7a:	mov    $0x8,%r8d
  6d0d80:	mov    %rbx,%rsi
  6d0d83:	mov    $0x1,%ecx
  6d0d88:	xor    %r9d,%r9d
  6d0d8b:	call   6d65a0 <_RNvMNtNtCs6ZNK6sH19NW_4gpui7runtime4turnINtB4_10RuntimeMutNtCs4gijoeCAvqI_25inspector_pointer_control5ModeluE21describe_with_changedBW_>
  6d0d90:	mov    0x68(%rsp),%r13
  6d0d95:	cmp    $0xfffffffffffffffe,%r13
  6d0d99:	jne    6d1e43 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1693>
  6d0d9f:	lea    0x68(%rsp),%rdi
  6d0da4:	mov    %rbx,%rsi
  6d0da7:	call   6f8c70 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE7presentBO_>
  6d0dac:	mov    0x68(%rsp),%r13
  6d0db1:	cmp    $0xfffffffffffffffe,%r13
  6d0db5:	jne    6d1e43 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1693>
  6d0dbb:	mov    0x8(%rsp),%rdi
  6d0dc0:	mov    %rdi,0x8(%rsp)
  6d0dc5:	call   6d06b0 <_RNvCs4gijoeCAvqI_25inspector_pointer_control3ack>
  6d0dca:	mov    0x8(%rsp),%rbx
  6d0dcf:	test   %rbx,%rbx
  6d0dd2:	je     6d1f54 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x17a4>
  6d0dd8:	cmpb   $0x0,0x746(%rbx)
  6d0ddf:	jne    6d1f5b <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x17ab>
  6d0de5:	cmpb   $0x1,0x742(%rbx)
  6d0dec:	jne    6d1f62 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x17b2>
  6d0df2:	mov    0x5a8(%rbx),%r13
  6d0df9:	mov    $0x1a,%eax
  6d0dfe:	mov    %rax,0x10(%rsp)
  6d0e03:	test   %r13,%r13
  6d0e06:	je     6d1f6c <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x17bc>
  6d0e0c:	mov    0x5a0(%rbx),%rbp
  6d0e13:	shl    $0x6,%r13
  6d0e17:	lea    0x1e8(%rbx),%r14
  6d0e1e:	xor    %r12d,%r12d
  6d0e21:	mov    0x348798(%rip),%r15        # a195c0 <_DYNAMIC+0x2d0>
  6d0e28:	jmp    6d0e3d <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x68d>
  6d0e2a:	nopw   0x0(%rax,%rax,1)
  6d0e30:	add    $0x40,%r12
  6d0e34:	cmp    %r12,%r13
  6d0e37:	je     6d1f6c <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x17bc>
  6d0e3d:	cmpb   $0x4,0x3d(%rbp,%r12,1)
  6d0e43:	jne    6d0e30 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x680>
  6d0e45:	mov    0x20(%rbp,%r12,1),%rsi
  6d0e4a:	mov    %r14,%rdi
  6d0e4d:	call   *%r15
  6d0e50:	test   %al,%al
  6d0e52:	je     6d0e30 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x680>
  6d0e54:	mov    0x20(%rbp,%r12,1),%rsi
  6d0e59:	add    $0x5d8,%rbx
  6d0e60:	mov    %rbx,%rdi
  6d0e63:	call   *0x3488ef(%rip)        # a19758 <_DYNAMIC+0x468>
  6d0e69:	mov    %rax,%r14
  6d0e6c:	lea    0x10(%rsp),%rax
  6d0e71:	mov    0x8(%rsp),%r15
  6d0e76:	test   %r15,%r15
  6d0e79:	je     6d1fb2 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1802>
  6d0e7f:	mov    %r15,0xa0(%rsp)
  6d0e87:	mov    %rax,0xa8(%rsp)
  6d0e8f:	cmpb   $0x1,0x746(%r15)
  6d0e97:	je     6d1fcf <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x181f>
  6d0e9d:	cmp    0x5d8(%r15),%r14
  6d0ea4:	jne    6d1fe0 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1830>
  6d0eaa:	mov    %rdx,%rbx
  6d0ead:	lea    0x3c0(%rsp),%rdi
  6d0eb5:	mov    %r15,%rsi
  6d0eb8:	call   6f8510 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE16resolve_identityBO_>
  6d0ebd:	mov    0x3c0(%rsp),%rax
  6d0ec5:	cmp    $0xfffffffffffffffe,%rax
  6d0ec9:	jne    6d1fe7 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1837>
  6d0ecf:	cmpb   $0x1,0x742(%r15)
  6d0ed7:	jne    6d1e21 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1671>
  6d0edd:	cmpb   $0x0,0x743(%r15)
  6d0ee5:	jne    6d1e21 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1671>
  6d0eeb:	cmpb   $0x0,0x744(%r15)
  6d0ef3:	je     6d1e21 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1671>
  6d0ef9:	cmpq   $0xffffffffffffffff,0x5b0(%r15)
  6d0f01:	jne    6d1e21 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1671>
  6d0f07:	mov    0x688(%r15),%rax
  6d0f0e:	cmp    0x690(%r15),%rax
  6d0f15:	jne    6d1e21 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1671>
  6d0f1b:	mov    0x6a0(%r15),%rax
  6d0f22:	cmp    0x698(%r15),%rax
  6d0f29:	jne    6d1e21 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1671>
  6d0f2f:	movss  0x738(%r15),%xmm0
  6d0f38:	ucomiss 0x73c(%r15),%xmm0
  6d0f40:	jne    6d1e21 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1671>
  6d0f46:	jp     6d1e21 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1671>
  6d0f4c:	mov    0x5a0(%r15),%r12
  6d0f53:	mov    0x5a8(%r15),%rax
  6d0f5a:	lea    -0x38(%r12),%rcx
  6d0f5f:	shl    $0x6,%rax
  6d0f63:	neg    %rax
  6d0f66:	xor    %ebp,%ebp
  6d0f68:	nopl   0x0(%rax,%rax,1)
  6d0f70:	cmp    %rbp,%rax
  6d0f73:	je     6d1d98 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x15e8>
  6d0f79:	add    $0xffffffffffffffc0,%rbp
  6d0f7d:	lea    0x40(%rcx),%r13
  6d0f81:	cmp    %rbx,0x58(%rcx)
  6d0f85:	mov    %r13,%rcx
  6d0f88:	jne    6d0f70 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x7c0>
  6d0f8a:	mov    0x638(%r15),%rax
  6d0f91:	test   %rax,%rax
  6d0f94:	je     6d0fb2 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x802>
  6d0f96:	mov    0x100(%rax),%rsi
  6d0f9d:	test   %rsi,%rsi
  6d0fa0:	je     6d0fb2 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x802>
  6d0fa2:	lea    0x120(%rsp),%rdi
  6d0faa:	call   *0x3487a0(%rip)        # a19750 <_DYNAMIC+0x460>
  6d0fb0:	jmp    6d0fc9 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x819>
  6d0fb2:	movq   $0x4,0x120(%rsp)
  6d0fbe:	xorps  %xmm0,%xmm0
  6d0fc1:	movups %xmm0,0x128(%rsp)
  6d0fc9:	lea    0x120(%rsp),%rdi
  6d0fd1:	call   *0x3487b1(%rip)        # a19788 <_DYNAMIC+0x498>
  6d0fd7:	mov    %rdx,%rcx
  6d0fda:	sub    %rbp,%r12
  6d0fdd:	lea    -0x40(%r12),%rsi
  6d0fe2:	lea    0x3c0(%rsp),%rdi
  6d0fea:	mov    %rax,%rdx
  6d0fed:	call   *0x34879d(%rip)        # a19790 <_DYNAMIC+0x4a0>
  6d0ff3:	cmpb   $0x0,0x3c0(%rsp)
  6d0ffb:	je     6d1045 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x895>
  6d0ffd:	lea    0x3c4(%rsp),%rsi
  6d1005:	movss  0x0(%r13),%xmm0
  6d100b:	movss  0x4(%r13),%xmm1
  6d1011:	lea    0x68(%rsp),%rdi
  6d1016:	call   6ce7c0 <_RNCNvMss_NtCs6ZNK6sH19NW_4gpui7runtimeINtB7_3WinNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE5clicks_0BM_>
  6d101b:	cmpl   $0x1,0x68(%rsp)
  6d1020:	jne    6d1045 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x895>
  6d1022:	movsd  0x6c(%rsp),%xmm0
  6d1028:	movaps %xmm0,%xmm1
  6d102b:	shufps $0x55,%xmm0,%xmm1
  6d102f:	add    $0xffffffffffffffd0,%r12
  6d1033:	mov    %r12,%rdi
  6d1036:	movaps %xmm0,0x10(%rsp)
  6d103b:	call   *0x348757(%rip)        # a19798 <_DYNAMIC+0x4a8>
  6d1041:	test   %al,%al
  6d1043:	jne    6d1082 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x8d2>
  6d1045:	movss  0x10(%r13),%xmm0
  6d104b:	xorps  %xmm2,%xmm2
  6d104e:	ucomiss %xmm2,%xmm0
  6d1051:	jne    6d1059 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x8a9>
  6d1053:	jnp    6d1e32 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1682>
  6d1059:	movss  0x14(%r13),%xmm1
  6d105f:	ucomiss %xmm2,%xmm1
  6d1062:	jne    6d106a <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x8ba>
  6d1064:	jnp    6d1e32 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1682>
  6d106a:	unpcklps %xmm1,%xmm0
  6d106d:	mulps  -0x692454(%rip),%xmm0        # 3ec20 <GCC_except_table0+0x14ec>
  6d1074:	movsd  0x8(%r13),%xmm1
  6d107a:	addps  %xmm0,%xmm1
  6d107d:	movaps %xmm1,0x10(%rsp)
  6d1082:	movq   $0x19,0x3c0(%rsp)
  6d108e:	lea    0x3c0(%rsp),%rdi
  6d1096:	call   6be330 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueNtNtCs6ZNK6sH19NW_4gpui7runtime5ErrorECs4gijoeCAvqI_25inspector_pointer_control>
  6d109b:	movaps 0x10(%rsp),%xmm0
  6d10a0:	movaps %xmm0,%xmm1
  6d10a3:	shufps $0x55,%xmm0,%xmm1
  6d10a7:	mov    %r15,%rdi
  6d10aa:	movaps %xmm1,0x30(%rsp)
  6d10af:	call   6f87f0 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_>
  6d10b4:	movq   $0x19,0x3c0(%rsp)
  6d10c0:	test   $0x1,%al
  6d10c2:	je     6d1e32 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1682>
  6d10c8:	mov    %rdx,%r12
  6d10cb:	lea    0x3c0(%rsp),%rdi
  6d10d3:	call   6be330 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueNtNtCs6ZNK6sH19NW_4gpui7runtime5ErrorECs4gijoeCAvqI_25inspector_pointer_control>
  6d10d8:	cmp    %rbx,%r12
  6d10db:	jne    6d1e32 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1682>
  6d10e1:	cmp    0x5d8(%r15),%r14
  6d10e8:	jne    6d2064 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x18b4>
  6d10ee:	lea    0x3c0(%rsp),%rdi
  6d10f6:	mov    %r15,%rsi
  6d10f9:	mov    %rbx,%rdx
  6d10fc:	call   6f8510 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE16resolve_identityBO_>
  6d1101:	mov    0x3c0(%rsp),%rax
  6d1109:	mov    0x3c8(%rsp),%r12
  6d1111:	cmp    $0xfffffffffffffffe,%rax
  6d1115:	jne    6d2069 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x18b9>
  6d111b:	mov    0x2c8(%r15),%rsi
  6d1122:	cmp    %rsi,%r12
  6d1125:	jae    6d20ae <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x18fe>
  6d112b:	mov    0x2c0(%r15),%rax
  6d1132:	lea    (%r12,%r12,4),%rcx
  6d1136:	mov    0x20(%rax,%rcx,8),%edi
  6d113a:	call   6e1fa0 <_RNvMsh_NtCs6ZNK6sH19NW_4gpui7runtimeNtB5_4Node4kind>
  6d113f:	cmp    $0x4,%al
  6d1141:	jne    6d1168 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x9b8>
  6d1143:	lea    0x120(%rsp),%rdi
  6d114b:	mov    %r15,%rsi
  6d114e:	mov    %r14,%rdx
  6d1151:	mov    %rbx,%rcx
  6d1154:	movaps 0x10(%rsp),%xmm0
  6d1159:	movaps 0x30(%rsp),%xmm1
  6d115e:	xor    %r8d,%r8d
  6d1161:	call   6db8d0 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime7editingINtB7_10RuntimeMutNtCs4gijoeCAvqI_25inspector_pointer_control5ModeluE14select_pointerB12_>
  6d1166:	jmp    6d11bb <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0xa0b>
  6d1168:	mov    0x610(%r15),%r12
  6d116f:	mov    0x618(%r15),%r13
  6d1176:	lea    0x3c0(%rsp),%rdi
  6d117e:	mov    %r15,%rsi
  6d1181:	mov    %r14,%rdx
  6d1184:	mov    %rbx,%rcx
  6d1187:	call   6db550 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE5focusBW_>
  6d118c:	mov    0x3c0(%rsp),%rax
  6d1194:	cmp    $0xfffffffffffffffe,%rax
  6d1198:	jne    6d11cb <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0xa1b>
  6d119a:	lea    0x120(%rsp),%rdi
  6d11a2:	lea    0xa0(%rsp),%rsi
  6d11aa:	mov    %r14,%rdx
  6d11ad:	mov    %rbx,%rcx
  6d11b0:	mov    %r12,%r8
  6d11b3:	mov    %r13,%r9
  6d11b6:	call   6d30e0 <_RNvMNtNtCs6ZNK6sH19NW_4gpui7runtime4turnINtB4_10RuntimeMutNtCs4gijoeCAvqI_25inspector_pointer_control5ModeluE16activate_focusedBW_>
  6d11bb:	cmpq   $0xfffffffffffffffe,0x120(%rsp)
  6d11c4:	je     6d123d <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0xa8d>
  6d11c6:	jmp    6d1da4 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x15f4>
  6d11cb:	mov    0x3e8(%rsp),%rcx
  6d11d3:	movzbl 0x3f0(%rsp),%edx
  6d11db:	mov    0x3f1(%rsp),%esi
  6d11e2:	mov    %esi,0x151(%rsp)
  6d11e9:	mov    0x3f4(%rsp),%esi
  6d11f0:	mov    %esi,0x154(%rsp)
  6d11f7:	movups 0x3c8(%rsp),%xmm0
  6d11ff:	movups 0x3d8(%rsp),%xmm1
  6d1207:	mov    %rax,0x120(%rsp)
  6d120f:	movups %xmm0,0x128(%rsp)
  6d1217:	movups %xmm1,0x138(%rsp)
  6d121f:	mov    %rcx,0x148(%rsp)
  6d1227:	mov    %dl,0x150(%rsp)
  6d122e:	cmpq   $0xfffffffffffffffe,0x120(%rsp)
  6d1237:	jne    6d1da4 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x15f4>
  6d123d:	mov    0x8(%rsp),%rdi
  6d1242:	call   6d06b0 <_RNvCs4gijoeCAvqI_25inspector_pointer_control3ack>
  6d1247:	movsd  -0x692e7f(%rip),%xmm0        # 3e3d0 <GCC_except_table0+0xc9c>
  6d124f:	movsd  %xmm0,0x3c0(%rsp)
  6d1258:	lea    0x3c0(%rsp),%rax
  6d1260:	mov    0x8(%rsp),%rbp
  6d1265:	test   %rbp,%rbp
  6d1268:	je     6d20bf <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x190f>
  6d126e:	cmpb   $0x0,0x746(%rbp)
  6d1275:	jne    6d20c6 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1916>
  6d127b:	mov    $0x12,%eax
  6d1280:	cmpb   $0x1,0x742(%rbp)
  6d1287:	jne    6d20cb <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x191b>
  6d128d:	cmpb   $0x0,0x743(%rbp)
  6d1294:	jne    6d20cb <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x191b>
  6d129a:	cmpb   $0x0,0x744(%rbp)
  6d12a1:	je     6d20cb <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x191b>
  6d12a7:	cmpq   $0xffffffffffffffff,0x5b0(%rbp)
  6d12af:	jne    6d20cb <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x191b>
  6d12b5:	mov    0x688(%rbp),%rcx
  6d12bc:	cmp    0x690(%rbp),%rcx
  6d12c3:	jne    6d20cb <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x191b>
  6d12c9:	mov    0x6a0(%rbp),%rbx
  6d12d0:	cmp    0x698(%rbp),%rbx
  6d12d7:	jne    6d20cb <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x191b>
  6d12dd:	movss  0x738(%rbp),%xmm0
  6d12e5:	ucomiss 0x73c(%rbp),%xmm0
  6d12ec:	jne    6d20cb <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x191b>
  6d12f2:	jp     6d20cb <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x191b>
  6d12f8:	movsd  0x3c0(%rsp),%xmm0
  6d1301:	movaps %xmm0,0x40(%rsp)
  6d1306:	mov    0x6c0(%rbp),%rax
  6d130d:	mov    %rax,0x50(%rsp)
  6d1312:	mov    0x5a0(%rbp),%rax
  6d1319:	mov    %rax,0x10(%rsp)
  6d131e:	mov    0x5a8(%rbp),%r12
  6d1325:	movups 0x610(%rbp),%xmm0
  6d132c:	movaps %xmm0,0x30(%rsp)
  6d1331:	mov    0x638(%rbp),%r13
  6d1338:	test   %r13,%r13
  6d133b:	je     6d1389 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0xbd9>
  6d133d:	mov    0xe0(%r13),%rax
  6d1344:	test   %rax,%rax
  6d1347:	je     6d13a8 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0xbf8>
  6d1349:	mov    0x38(%rax),%ecx
  6d134c:	mov    %ecx,0xb20(%rsp)
  6d1353:	movups 0x28(%rax),%xmm0
  6d1357:	movaps %xmm0,0xb10(%rsp)
  6d135f:	movzbl 0x3c(%rax),%r15d
  6d1364:	movzbl 0x3f(%rax),%ecx
  6d1368:	mov    %cl,0xa2(%rsp)
  6d136f:	movzwl 0x3d(%rax),%eax
  6d1373:	mov    %ax,0xa0(%rsp)
  6d137b:	mov    0x100(%r13),%rsi
  6d1382:	test   %rsi,%rsi
  6d1385:	jne    6d13b7 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0xc07>
  6d1387:	jmp    6d138c <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0xbdc>
  6d1389:	mov    $0x2,%r15b
  6d138c:	movq   $0x4,0x120(%rsp)
  6d1398:	xorps  %xmm0,%xmm0
  6d139b:	movups %xmm0,0x128(%rsp)
  6d13a3:	mov    %r12,%r14
  6d13a6:	jmp    6d13cc <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0xc1c>
  6d13a8:	mov    $0x2,%r15b
  6d13ab:	mov    0x100(%r13),%rsi
  6d13b2:	test   %rsi,%rsi
  6d13b5:	je     6d138c <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0xbdc>
  6d13b7:	lea    0x120(%rsp),%rdi
  6d13bf:	call   *0x34838b(%rip)        # a19750 <_DYNAMIC+0x460>
  6d13c5:	mov    0x5a8(%rbp),%r14
  6d13cc:	lea    0x5d8(%rbp),%rax
  6d13d3:	mov    %rax,0x108(%rsp)
  6d13db:	mov    %rax,0x410(%rsp)
  6d13e3:	mov    0x50(%rsp),%rax
  6d13e8:	mov    %rax,0x3e0(%rsp)
  6d13f0:	mov    %rbx,0x3e8(%rsp)
  6d13f8:	mov    0x10(%rsp),%rax
  6d13fd:	mov    %rax,0x3d0(%rsp)
  6d1405:	mov    %r12,0x3d8(%rsp)
  6d140d:	movaps 0x30(%rsp),%xmm0
  6d1412:	movaps %xmm0,0x3c0(%rsp)
  6d141a:	mov    %r13,0x3f0(%rsp)
  6d1422:	mov    0x120(%rsp),%rax
  6d142a:	mov    %rax,0x3f8(%rsp)
  6d1432:	mov    0x128(%rsp),%rax
  6d143a:	mov    %rax,0x400(%rsp)
  6d1442:	mov    0x130(%rsp),%rax
  6d144a:	mov    %rax,0x408(%rsp)
  6d1452:	movaps 0xb10(%rsp),%xmm0
  6d145a:	movups %xmm0,0x418(%rsp)
  6d1462:	mov    0xb20(%rsp),%eax
  6d1469:	mov    %eax,0x428(%rsp)
  6d1470:	mov    %r15b,0x42c(%rsp)
  6d1478:	movzwl 0xa0(%rsp),%eax
  6d1480:	mov    %ax,0x42d(%rsp)
  6d1488:	movzbl 0xa2(%rsp),%eax
  6d1490:	mov    %al,0x42f(%rsp)
  6d1497:	test   %r14,%r14
  6d149a:	je     6d1ebc <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x170c>
  6d14a0:	movaps 0x40(%rsp),%xmm0
  6d14a5:	shufps $0x55,%xmm0,%xmm0
  6d14a9:	movaps %xmm0,0x50(%rsp)
  6d14ae:	mov    $0x20,%r13d
  6d14b4:	xor    %r12d,%r12d
  6d14b7:	lea    0x3c0(%rsp),%r15
  6d14bf:	mov    0x3482da(%rip),%rbx        # a197a0 <_DYNAMIC+0x4b0>
  6d14c6:	lea    0x32922b(%rip),%rax        # 9fa6f8 <__frame_dummy_init_array_entry+0xbd8>
  6d14cd:	mov    %rax,0x60(%rsp)
  6d14d2:	movq   $0x0,0x30(%rsp)
  6d14db:	movq   $0x0,0x10(%rsp)
  6d14e4:	jmp    6d150c <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0xd5c>
  6d14e6:	mov    0x5a0(%rbp),%rax
  6d14ed:	incq   0x10(%rsp)
  6d14f2:	mov    (%rax,%r13,1),%rax
  6d14f6:	mov    %rax,0x30(%rsp)
  6d14fb:	nopl   0x0(%rax,%rax,1)
  6d1500:	inc    %r12
  6d1503:	add    $0x40,%r13
  6d1507:	cmp    %r12,%r14
  6d150a:	je     6d155b <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0xdab>
  6d150c:	mov    %r15,%rdi
  6d150f:	mov    %r12,%rsi
  6d1512:	call   *%rbx
  6d1514:	test   %rax,%rax
  6d1517:	setne  %cl
  6d151a:	cmp    $0x5,%rdx
  6d151e:	sete   %dl
  6d1521:	and    %cl,%dl
  6d1523:	cmp    $0x1,%dl
  6d1526:	jne    6d1500 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0xd50>
  6d1528:	mov    (%rax),%ecx
  6d152a:	mov    $0x63656863,%edx
  6d152f:	xor    %edx,%ecx
  6d1531:	movzbl 0x4(%rax),%eax
  6d1535:	xor    $0x6b,%eax
  6d1538:	or     %ecx,%eax
  6d153a:	jne    6d1500 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0xd50>
  6d153c:	mov    0x5a8(%rbp),%rsi
  6d1543:	cmp    %rsi,%r12
  6d1546:	jb     6d14e6 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0xd36>
  6d1548:	mov    %r12,%rdi
  6d154b:	mov    0x60(%rsp),%rdx
  6d1550:	call   *0x34800a(%rip)        # a19560 <_DYNAMIC+0x270>
  6d1556:	jmp    6d22c0 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b10>
  6d155b:	mov    0x10(%rsp),%rcx
  6d1560:	cmp    $0x1,%rcx
  6d1564:	jne    6d1eae <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x16fe>
  6d156a:	mov    0x108(%rsp),%rdi
  6d1572:	mov    0x30(%rsp),%rsi
  6d1577:	call   *0x3481db(%rip)        # a19758 <_DYNAMIC+0x468>
  6d157d:	mov    %rax,%r14
  6d1580:	mov    %rdx,%rbx
  6d1583:	lea    0x8(%rsp),%rax
  6d1588:	mov    %rax,0x3c0(%rsp)
  6d1590:	lea    0x3c0(%rsp),%r12
  6d1598:	mov    0x3c0(%rsp),%rax
  6d15a0:	mov    (%rax),%rsi
  6d15a3:	lea    0x120(%rsp),%rdi
  6d15ab:	movaps 0x40(%rsp),%xmm0
  6d15b0:	movaps 0x50(%rsp),%xmm1
  6d15b5:	call   6d3010 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8hit_only>
  6d15ba:	cmpl   $0xfffffffe,0x120(%rsp)
  6d15c2:	jne    6d1afe <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x134e>
  6d15c8:	mov    0x128(%rsp),%rdx
  6d15d0:	mov    0x130(%rsp),%rax
  6d15d8:	mov    %rdx,0x3c0(%rsp)
  6d15e0:	mov    %rax,0x3c8(%rsp)
  6d15e8:	mov    %r14,0x110(%rsp)
  6d15f0:	mov    %rbx,0x118(%rsp)
  6d15f8:	cmp    %r14,%rdx
  6d15fb:	sete   %cl
  6d15fe:	test   %rdx,%rdx
  6d1601:	je     6d1a74 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x12c4>
  6d1607:	lea    0x328ec2(%rip),%rdx        # 9fa4d0 <__frame_dummy_init_array_entry+0x9b0>
  6d160e:	lea    0x110(%rsp),%r15
  6d1616:	test   %cl,%cl
  6d1618:	je     6d1be6 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1436>
  6d161e:	cmp    %rbx,%rax
  6d1621:	jne    6d1be6 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1436>
  6d1627:	movsd  -0x692c6f(%rip),%xmm0        # 3e9c0 <GCC_except_table0+0x128c>
  6d162f:	movsd  %xmm0,0x3c0(%rsp)
  6d1638:	lea    0x3c0(%rsp),%r12
  6d1640:	movss  0x3c0(%rsp),%xmm0
  6d1649:	movss  0x3c4(%rsp),%xmm1
  6d1652:	mov    0x8(%rsp),%rsi
  6d1657:	lea    0x120(%rsp),%rdi
  6d165f:	call   6d3010 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8hit_only>
  6d1664:	cmpl   $0xfffffffe,0x120(%rsp)
  6d166c:	jne    6d1b6b <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x13bb>
  6d1672:	movups 0x128(%rsp),%xmm0
  6d167a:	movaps %xmm0,0x3c0(%rsp)
  6d1682:	cmpq   $0x0,0x128(%rsp)
  6d168b:	jne    6d1bd8 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1428>
  6d1691:	mov    $0xffffffff,%eax
  6d1696:	mov    %rax,0xb10(%rsp)
  6d169e:	movq   $0x0,0xb18(%rsp)
  6d16aa:	movaps 0x40(%rsp),%xmm0
  6d16af:	movlps %xmm0,0x3c4(%rsp)
  6d16b7:	movl   $0x0,0x3c0(%rsp)
  6d16c2:	lea    0x3c0(%rsp),%rcx
  6d16ca:	lea    0x120(%rsp),%rdi
  6d16d2:	lea    0x8(%rsp),%rsi
  6d16d7:	lea    0xb10(%rsp),%rdx
  6d16df:	call   6d2380 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch>
  6d16e4:	cmpl   $0xfffffffe,0x120(%rsp)
  6d16ec:	jne    6d1a07 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1257>
  6d16f2:	movl   $0x2,0x3c0(%rsp)
  6d16fd:	lea    0x3c0(%rsp),%rcx
  6d1705:	lea    0x120(%rsp),%rdi
  6d170d:	lea    0x8(%rsp),%rsi
  6d1712:	lea    0xb10(%rsp),%rdx
  6d171a:	call   6d2380 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch>
  6d171f:	cmpl   $0xfffffffe,0x120(%rsp)
  6d1727:	jne    6d1a07 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1257>
  6d172d:	movl   $0x3,0x3c0(%rsp)
  6d1738:	lea    0x3c0(%rsp),%r15
  6d1740:	lea    0x120(%rsp),%rdi
  6d1748:	lea    0x8(%rsp),%rsi
  6d174d:	lea    0xb10(%rsp),%rdx
  6d1755:	mov    %r15,%rcx
  6d1758:	call   6d2380 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch>
  6d175d:	cmpl   $0xfffffffe,0x120(%rsp)
  6d1765:	jne    6d1a07 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1257>
  6d176b:	mov    0x8(%rsp),%rsi
  6d1770:	test   %rsi,%rsi
  6d1773:	je     6d1bf6 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1446>
  6d1779:	cmpq   $0x1,0x2b0(%rsi)
  6d1781:	jne    6d1c3b <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x148b>
  6d1787:	mov    %rsi,%rdi
  6d178a:	call   6d06b0 <_RNvCs4gijoeCAvqI_25inspector_pointer_control3ack>
  6d178f:	mov    0x8(%rsp),%rsi
  6d1794:	lea    0x120(%rsp),%rdi
  6d179c:	movaps 0x40(%rsp),%xmm0
  6d17a1:	movaps 0x50(%rsp),%xmm1
  6d17a6:	call   6d3010 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8hit_only>
  6d17ab:	cmpl   $0xfffffffe,0x120(%rsp)
  6d17b3:	jne    6d1c55 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x14a5>
  6d17b9:	mov    0x128(%rsp),%rdx
  6d17c1:	mov    0x130(%rsp),%rax
  6d17c9:	mov    %rdx,0xa0(%rsp)
  6d17d1:	mov    %rax,0xa8(%rsp)
  6d17d9:	mov    %r14,0x3c0(%rsp)
  6d17e1:	mov    %rbx,0x3c8(%rsp)
  6d17e9:	cmp    %r14,%rdx
  6d17ec:	sete   %cl
  6d17ef:	test   %rdx,%rdx
  6d17f2:	je     6d1a92 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x12e2>
  6d17f8:	lea    0x328d31(%rip),%rdx        # 9fa530 <__frame_dummy_init_array_entry+0xa10>
  6d17ff:	lea    0xa0(%rsp),%r12
  6d1807:	test   %cl,%cl
  6d1809:	je     6d1be6 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1436>
  6d180f:	cmp    %rbx,%rax
  6d1812:	jne    6d1be6 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1436>
  6d1818:	movaps 0x40(%rsp),%xmm0
  6d181d:	movlps %xmm0,0x3c0(%rsp)
  6d1825:	lea    0x3c0(%rsp),%rax
  6d182d:	movss  0x3c0(%rsp),%xmm0
  6d1836:	movss  0x3c4(%rsp),%xmm1
  6d183f:	lea    0x120(%rsp),%rbx
  6d1847:	lea    0x8(%rsp),%rsi
  6d184c:	mov    %rbx,%rdi
  6d184f:	call   6d0340 <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only>
  6d1854:	cmpl   $0xfffffffe,0x120(%rsp)
  6d185c:	jne    6d1cc2 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1512>
  6d1862:	mov    0x8(%rsp),%rdi
  6d1867:	call   6d06b0 <_RNvCs4gijoeCAvqI_25inspector_pointer_control3ack>
  6d186c:	mov    0x8(%rsp),%rsi
  6d1871:	test   %rsi,%rsi
  6d1874:	je     6d1d2f <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x157f>
  6d187a:	cmpq   $0x2,0x2b0(%rsi)
  6d1882:	jne    6d1d74 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x15c4>
  6d1888:	mov    0xb10(%rsp),%eax
  6d188f:	cmp    $0xffffffff,%eax
  6d1892:	je     6d18b2 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1102>
  6d1894:	dec    %eax
  6d1896:	mov    0xb14(%rsp),%ecx
  6d189d:	mov    %eax,0x124(%rsp)
  6d18a4:	mov    %ecx,0x128(%rsp)
  6d18ab:	mov    $0x1,%eax
  6d18b0:	jmp    6d18b4 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1104>
  6d18b2:	xor    %eax,%eax
  6d18b4:	mov    %eax,0x120(%rsp)
  6d18bb:	movl   $0x42500000,0x3c8(%rsp)
  6d18c6:	movabs $0x4140000000000001,%rcx
  6d18d0:	mov    %rcx,0x3c0(%rsp)
  6d18d8:	movabs $0x4250000041400000,%rcx
  6d18e2:	cmp    %rcx,0x124(%rsp)
  6d18ea:	sete   %cl
  6d18ed:	test   %eax,%eax
  6d18ef:	je     6d1ab0 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1300>
  6d18f5:	test   %cl,%cl
  6d18f7:	je     6d1aba <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x130a>
  6d18fd:	movaps 0x40(%rsp),%xmm0
  6d1902:	movss  %xmm0,0xa0(%rsp)
  6d190b:	movaps 0x50(%rsp),%xmm0
  6d1910:	movss  %xmm0,0x120(%rsp)
  6d1919:	lea    0xa0(%rsp),%rax
  6d1921:	mov    %rax,0x3c0(%rsp)
  6d1929:	mov    0x347e78(%rip),%rax        # a197a8 <_DYNAMIC+0x4b8>
  6d1930:	mov    %rax,0x3c8(%rsp)
  6d1938:	mov    %rbx,0x3d0(%rsp)
  6d1940:	mov    %rax,0x3d8(%rsp)
  6d1948:	lea    -0x69287f(%rip),%rax        # 3f0d0 <GCC_except_table0+0x199c>
  6d194f:	mov    %rax,0x3e0(%rsp)
  6d1957:	mov    0x347e52(%rip),%rcx        # a197b0 <_DYNAMIC+0x4c0>
  6d195e:	mov    %rcx,0x3e8(%rsp)
  6d1966:	mov    %rax,0x3f0(%rsp)
  6d196e:	mov    %rcx,0x3f8(%rsp)
  6d1976:	lea    -0x6927e5(%rip),%rax        # 3f198 <GCC_except_table0+0x1a64>
  6d197d:	mov    %rax,0x400(%rsp)
  6d1985:	mov    %rcx,0x408(%rsp)
  6d198d:	lea    -0x692a1c(%rip),%rax        # 3ef78 <GCC_except_table0+0x1844>
  6d1994:	mov    %rax,0x410(%rsp)
  6d199c:	mov    %rcx,0x418(%rsp)
  6d19a4:	lea    -0x692723(%rip),%rax        # 3f288 <GCC_except_table0+0x1b54>
  6d19ab:	mov    %rax,0x420(%rsp)
  6d19b3:	mov    %rcx,0x428(%rsp)
  6d19bb:	lea    -0x6895da(%rip),%rdi        # 483e8 <GCC_except_table0+0xacb4>
  6d19c2:	lea    0x3c0(%rsp),%rsi
  6d19ca:	call   *0x347de8(%rip)        # a197b8 <_DYNAMIC+0x4c8>
  6d19d0:	mov    0x8(%rsp),%rbx
  6d19d5:	test   %rbx,%rbx
  6d19d8:	je     6d19f5 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1245>
  6d19da:	mov    %rbx,%rdi
  6d19dd:	call   6b9720 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtCs6ZNK6sH19NW_4gpui7runtime7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelEEB1h_>
  6d19e2:	mov    $0x748,%esi
  6d19e7:	mov    $0x8,%edx
  6d19ec:	mov    %rbx,%rdi
  6d19ef:	call   *0x347b3b(%rip)        # a19530 <_DYNAMIC+0x240>
  6d19f5:	add    $0xcf8,%rsp
  6d19fc:	pop    %rbx
  6d19fd:	pop    %r12
  6d19ff:	pop    %r13
  6d1a01:	pop    %r14
  6d1a03:	pop    %r15
  6d1a05:	pop    %rbp
  6d1a06:	ret
  6d1a07:	mov    0x150(%rsp),%rax
  6d1a0f:	mov    %rax,0x3f0(%rsp)
  6d1a17:	movups 0x120(%rsp),%xmm0
  6d1a1f:	movups 0x130(%rsp),%xmm1
  6d1a27:	movups 0x140(%rsp),%xmm2
  6d1a2f:	movaps %xmm2,0x3e0(%rsp)
  6d1a37:	movaps %xmm1,0x3d0(%rsp)
  6d1a3f:	movaps %xmm0,0x3c0(%rsp)
  6d1a47:	lea    -0x6872f4(%rip),%rdi        # 4a75a <GCC_except_table0+0xd026>
  6d1a4e:	lea    0x328bb3(%rip),%rcx        # 9fa608 <__frame_dummy_init_array_entry+0xae8>
  6d1a55:	lea    0x328b64(%rip),%r8        # 9fa5c0 <__frame_dummy_init_array_entry+0xaa0>
  6d1a5c:	lea    0x3c0(%rsp),%rdx
  6d1a64:	mov    $0x2b,%esi
  6d1a69:	call   *0x347b71(%rip)        # a195e0 <_DYNAMIC+0x2f0>
  6d1a6f:	jmp    6d22c0 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b10>
  6d1a74:	xor    %ecx,%ecx
  6d1a76:	lea    0x328a53(%rip),%rdx        # 9fa4d0 <__frame_dummy_init_array_entry+0x9b0>
  6d1a7d:	lea    0x110(%rsp),%r15
  6d1a85:	test   %cl,%cl
  6d1a87:	jne    6d161e <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0xe6e>
  6d1a8d:	jmp    6d1be6 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1436>
  6d1a92:	xor    %ecx,%ecx
  6d1a94:	lea    0x328a95(%rip),%rdx        # 9fa530 <__frame_dummy_init_array_entry+0xa10>
  6d1a9b:	lea    0xa0(%rsp),%r12
  6d1aa3:	test   %cl,%cl
  6d1aa5:	jne    6d180f <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x105f>
  6d1aab:	jmp    6d1be6 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1436>
  6d1ab0:	xor    %ecx,%ecx
  6d1ab2:	test   %cl,%cl
  6d1ab4:	jne    6d18fd <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x114d>
  6d1aba:	lea    0x120(%rsp),%rdi
  6d1ac2:	lea    0x3c0(%rsp),%rsi
  6d1aca:	call   6c14fb <_RINvNtCs4NRVxsYgnAr_4core9panicking13assert_failedINtNtB4_6option6OptionAmj2_EBM_ECs4gijoeCAvqI_25inspector_pointer_control>
  6d1acf:	jmp    6d22c0 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b10>
  6d1ad4:	mov    $0x8,%edi
  6d1ad9:	mov    $0x28,%esi
  6d1ade:	call   *0x347a64(%rip)        # a19548 <_DYNAMIC+0x258>
  6d1ae4:	jmp    6d22c0 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b10>
  6d1ae9:	mov    $0x8,%edi
  6d1aee:	mov    $0x748,%esi
  6d1af3:	call   *0x347a4f(%rip)        # a19548 <_DYNAMIC+0x258>
  6d1af9:	jmp    6d22c0 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b10>
  6d1afe:	mov    0x150(%rsp),%rax
  6d1b06:	mov    %rax,0x3f0(%rsp)
  6d1b0e:	movups 0x120(%rsp),%xmm0
  6d1b16:	movups 0x130(%rsp),%xmm1
  6d1b1e:	movups 0x140(%rsp),%xmm2
  6d1b26:	movaps %xmm2,0x3e0(%rsp)
  6d1b2e:	movaps %xmm1,0x3d0(%rsp)
  6d1b36:	movaps %xmm0,0x3c0(%rsp)
  6d1b3e:	lea    -0x6873eb(%rip),%rdi        # 4a75a <GCC_except_table0+0xd026>
  6d1b45:	lea    0x328abc(%rip),%rcx        # 9fa608 <__frame_dummy_init_array_entry+0xae8>
  6d1b4c:	lea    0x328965(%rip),%r8        # 9fa4b8 <__frame_dummy_init_array_entry+0x998>
  6d1b53:	lea    0x3c0(%rsp),%rdx
  6d1b5b:	mov    $0x2b,%esi
  6d1b60:	call   *0x347a7a(%rip)        # a195e0 <_DYNAMIC+0x2f0>
  6d1b66:	jmp    6d22c0 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b10>
  6d1b6b:	mov    0x150(%rsp),%rax
  6d1b73:	mov    %rax,0x3f0(%rsp)
  6d1b7b:	movups 0x120(%rsp),%xmm0
  6d1b83:	movups 0x130(%rsp),%xmm1
  6d1b8b:	movups 0x140(%rsp),%xmm2
  6d1b93:	movaps %xmm2,0x3e0(%rsp)
  6d1b9b:	movaps %xmm1,0x3d0(%rsp)
  6d1ba3:	movaps %xmm0,0x3c0(%rsp)
  6d1bab:	lea    -0x687458(%rip),%rdi        # 4a75a <GCC_except_table0+0xd026>
  6d1bb2:	lea    0x328a4f(%rip),%rcx        # 9fa608 <__frame_dummy_init_array_entry+0xae8>
  6d1bb9:	lea    0x328928(%rip),%r8        # 9fa4e8 <__frame_dummy_init_array_entry+0x9c8>
  6d1bc0:	lea    0x3c0(%rsp),%rdx
  6d1bc8:	mov    $0x2b,%esi
  6d1bcd:	call   *0x347a0d(%rip)        # a195e0 <_DYNAMIC+0x2f0>
  6d1bd3:	jmp    6d22c0 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b10>
  6d1bd8:	lea    0x3289f9(%rip),%rdx        # 9fa5d8 <__frame_dummy_init_array_entry+0xab8>
  6d1bdf:	lea    -0x693206(%rip),%r15        # 3e9e0 <GCC_except_table0+0x12ac>
  6d1be6:	mov    %r12,%rdi
  6d1be9:	mov    %r15,%rsi
  6d1bec:	call   6c1533 <_RINvNtCs4NRVxsYgnAr_4core9panicking13assert_failedINtNtB4_6option6OptionNtNtCs6ZNK6sH19NW_4gpui8identity6TargetEBM_ECs4gijoeCAvqI_25inspector_pointer_control>
  6d1bf1:	jmp    6d22c0 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b10>
  6d1bf6:	movq   $0xd,0x3c0(%rsp)
  6d1c02:	movq   $0x0,0x3c8(%rsp)
  6d1c0e:	lea    -0x6874bb(%rip),%rdi        # 4a75a <GCC_except_table0+0xd026>
  6d1c15:	lea    0x3289ec(%rip),%rcx        # 9fa608 <__frame_dummy_init_array_entry+0xae8>
  6d1c1c:	lea    0x3288dd(%rip),%r8        # 9fa500 <__frame_dummy_init_array_entry+0x9e0>
  6d1c23:	lea    0x3c0(%rsp),%rdx
  6d1c2b:	mov    $0x2b,%esi
  6d1c30:	call   *0x3479aa(%rip)        # a195e0 <_DYNAMIC+0x2f0>
  6d1c36:	jmp    6d22c0 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b10>
  6d1c3b:	add    $0x2b0,%rsi
  6d1c42:	lea    0x32895f(%rip),%r9        # 9fa5a8 <__frame_dummy_init_array_entry+0xa88>
  6d1c49:	lea    -0x692ba0(%rip),%rdx        # 3f0b0 <GCC_except_table0+0x197c>
  6d1c50:	jmp    6d1d89 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x15d9>
  6d1c55:	mov    0x150(%rsp),%rax
  6d1c5d:	mov    %rax,0x3f0(%rsp)
  6d1c65:	movups 0x120(%rsp),%xmm0
  6d1c6d:	movups 0x130(%rsp),%xmm1
  6d1c75:	movups 0x140(%rsp),%xmm2
  6d1c7d:	movaps %xmm2,0x3e0(%rsp)
  6d1c85:	movaps %xmm1,0x3d0(%rsp)
  6d1c8d:	movaps %xmm0,0x3c0(%rsp)
  6d1c95:	lea    -0x687542(%rip),%rdi        # 4a75a <GCC_except_table0+0xd026>
  6d1c9c:	lea    0x328965(%rip),%rcx        # 9fa608 <__frame_dummy_init_array_entry+0xae8>
  6d1ca3:	lea    0x32886e(%rip),%r8        # 9fa518 <__frame_dummy_init_array_entry+0x9f8>
  6d1caa:	lea    0x3c0(%rsp),%rdx
  6d1cb2:	mov    $0x2b,%esi
  6d1cb7:	call   *0x347923(%rip)        # a195e0 <_DYNAMIC+0x2f0>
  6d1cbd:	jmp    6d22c0 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b10>
  6d1cc2:	mov    0x150(%rsp),%rax
  6d1cca:	mov    %rax,0x3f0(%rsp)
  6d1cd2:	movups 0x120(%rsp),%xmm0
  6d1cda:	movups 0x130(%rsp),%xmm1
  6d1ce2:	movups 0x140(%rsp),%xmm2
  6d1cea:	movaps %xmm2,0x3e0(%rsp)
  6d1cf2:	movaps %xmm1,0x3d0(%rsp)
  6d1cfa:	movaps %xmm0,0x3c0(%rsp)
  6d1d02:	lea    -0x6875af(%rip),%rdi        # 4a75a <GCC_except_table0+0xd026>
  6d1d09:	lea    0x3288f8(%rip),%rcx        # 9fa608 <__frame_dummy_init_array_entry+0xae8>
  6d1d10:	lea    0x328831(%rip),%r8        # 9fa548 <__frame_dummy_init_array_entry+0xa28>
  6d1d17:	lea    0x3c0(%rsp),%rdx
  6d1d1f:	mov    $0x2b,%esi
  6d1d24:	call   *0x3478b6(%rip)        # a195e0 <_DYNAMIC+0x2f0>
  6d1d2a:	jmp    6d22c0 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b10>
  6d1d2f:	movq   $0xd,0x3c0(%rsp)
  6d1d3b:	movq   $0x0,0x3c8(%rsp)
  6d1d47:	lea    -0x6875f4(%rip),%rdi        # 4a75a <GCC_except_table0+0xd026>
  6d1d4e:	lea    0x3288b3(%rip),%rcx        # 9fa608 <__frame_dummy_init_array_entry+0xae8>
  6d1d55:	lea    0x328804(%rip),%r8        # 9fa560 <__frame_dummy_init_array_entry+0xa40>
  6d1d5c:	lea    0x3c0(%rsp),%rdx
  6d1d64:	mov    $0x2b,%esi
  6d1d69:	call   *0x347871(%rip)        # a195e0 <_DYNAMIC+0x2f0>
  6d1d6f:	jmp    6d22c0 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b10>
  6d1d74:	add    $0x2b0,%rsi
  6d1d7b:	lea    0x32880e(%rip),%r9        # 9fa590 <__frame_dummy_init_array_entry+0xa70>
  6d1d82:	lea    -0x692c29(%rip),%rdx        # 3f160 <GCC_except_table0+0x1a2c>
  6d1d89:	xor    %edi,%edi
  6d1d8b:	xor    %ecx,%ecx
  6d1d8d:	call   *0x347a2d(%rip)        # a197c0 <_DYNAMIC+0x4d0>
  6d1d93:	jmp    6d22c0 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b10>
  6d1d98:	movq   $0x11,0x120(%rsp)
  6d1da4:	mov    0x150(%rsp),%rax
  6d1dac:	mov    %rax,0x3f0(%rsp)
  6d1db4:	mov    0x120(%rsp),%rax
  6d1dbc:	mov    0x128(%rsp),%rcx
  6d1dc4:	movups 0x130(%rsp),%xmm0
  6d1dcc:	movups 0x140(%rsp),%xmm1
  6d1dd4:	movaps %xmm1,0x3e0(%rsp)
  6d1ddc:	movaps %xmm0,0x3d0(%rsp)
  6d1de4:	mov    %rax,0x3c0(%rsp)
  6d1dec:	mov    %rcx,0x3c8(%rsp)
  6d1df4:	lea    -0x6876a1(%rip),%rdi        # 4a75a <GCC_except_table0+0xd026>
  6d1dfb:	lea    0x328806(%rip),%rcx        # 9fa608 <__frame_dummy_init_array_entry+0xae8>
  6d1e02:	lea    0x32867f(%rip),%r8        # 9fa488 <__frame_dummy_init_array_entry+0x968>
  6d1e09:	lea    0x3c0(%rsp),%rdx
  6d1e11:	mov    $0x2b,%esi
  6d1e16:	call   *0x3477c4(%rip)        # a195e0 <_DYNAMIC+0x2f0>
  6d1e1c:	jmp    6d22c0 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b10>
  6d1e21:	movq   $0x12,0x120(%rsp)
  6d1e2d:	jmp    6d1da4 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x15f4>
  6d1e32:	movq   $0x19,0x120(%rsp)
  6d1e3e:	jmp    6d1da4 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x15f4>
  6d1e43:	mov    0x70(%rsp),%r15
  6d1e48:	movups 0x78(%rsp),%xmm0
  6d1e4d:	movaps %xmm0,0x10(%rsp)
  6d1e52:	movups 0x88(%rsp),%xmm0
  6d1e5a:	movaps %xmm0,0x30(%rsp)
  6d1e5f:	movzbl 0x98(%rsp),%ebp
  6d1e67:	mov    0x99(%rsp),%eax
  6d1e6e:	mov    %eax,0x28(%rsp)
  6d1e72:	mov    0x9c(%rsp),%eax
  6d1e79:	mov    %eax,0x2b(%rsp)
  6d1e7d:	mov    0x8(%rsp),%rbx
  6d1e82:	test   %rbx,%rbx
  6d1e85:	je     6d1ea2 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x16f2>
  6d1e87:	mov    %rbx,%rdi
  6d1e8a:	call   6b9720 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtCs6ZNK6sH19NW_4gpui7runtime7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelEEB1h_>
  6d1e8f:	mov    $0x748,%esi
  6d1e94:	mov    $0x8,%edx
  6d1e99:	mov    %rbx,%rdi
  6d1e9c:	call   *0x34768e(%rip)        # a19530 <_DYNAMIC+0x240>
  6d1ea2:	mov    %r15,%r12
  6d1ea5:	shr    $0x20,%r12
  6d1ea9:	jmp    6d1f45 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1795>
  6d1eae:	mov    $0x1b,%eax
  6d1eb3:	test   %rcx,%rcx
  6d1eb6:	jne    6d20cb <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x191b>
  6d1ebc:	mov    $0x1a,%eax
  6d1ec1:	jmp    6d20cb <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x191b>
  6d1ec6:	mov    $0x1,%edi
  6d1ecb:	mov    $0x6,%esi
  6d1ed0:	call   *0x3476e2(%rip)        # a195b8 <_DYNAMIC+0x2c8>
  6d1ed6:	mov    0x3c8(%rsp),%r15
  6d1ede:	mov    %r15,%r12
  6d1ee1:	shr    $0x20,%r12
  6d1ee5:	movups 0x3d0(%rsp),%xmm0
  6d1eed:	movaps %xmm0,0x10(%rsp)
  6d1ef2:	movups 0x3e0(%rsp),%xmm0
  6d1efa:	movaps %xmm0,0x30(%rsp)
  6d1eff:	movzbl 0x3f0(%rsp),%ebp
  6d1f07:	mov    0x3f1(%rsp),%eax
  6d1f0e:	mov    %eax,0x28(%rsp)
  6d1f12:	mov    0x3f4(%rsp),%eax
  6d1f19:	mov    %eax,0x2b(%rsp)
  6d1f1d:	jmp    6d1f32 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1782>
  6d1f1f:	lea    0xa0(%rsp),%rdi
  6d1f27:	call   6b9570 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtCs6ZNK6sH19NW_4gpui6source7SourcesNtCs4gijoeCAvqI_25inspector_pointer_control5ModelEEB1g_>
  6d1f2c:	mov    $0x23,%r13d
  6d1f32:	mov    $0x6,%esi
  6d1f37:	mov    $0x1,%edx
  6d1f3c:	mov    %rbx,%rdi
  6d1f3f:	call   *0x3475eb(%rip)        # a19530 <_DYNAMIC+0x240>
  6d1f45:	movaps 0x10(%rsp),%xmm0
  6d1f4a:	movaps 0x30(%rsp),%xmm1
  6d1f4f:	jmp    6d2250 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1aa0>
  6d1f54:	mov    $0xd,%eax
  6d1f59:	jmp    6d1f67 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x17b7>
  6d1f5b:	mov    $0xe,%eax
  6d1f60:	jmp    6d1f67 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x17b7>
  6d1f62:	mov    $0x12,%eax
  6d1f67:	mov    %rax,0x10(%rsp)
  6d1f6c:	mov    0x10(%rsp),%rax
  6d1f71:	mov    %rax,0x3c0(%rsp)
  6d1f79:	movq   $0x0,0x3c8(%rsp)
  6d1f85:	lea    -0x68786a(%rip),%rdi        # 4a722 <GCC_except_table0+0xcfee>
  6d1f8c:	lea    0x328675(%rip),%rcx        # 9fa608 <__frame_dummy_init_array_entry+0xae8>
  6d1f93:	lea    0x3284d6(%rip),%r8        # 9fa470 <__frame_dummy_init_array_entry+0x950>
  6d1f9a:	lea    0x3c0(%rsp),%rdx
  6d1fa2:	mov    $0x2a,%esi
  6d1fa7:	call   *0x347633(%rip)        # a195e0 <_DYNAMIC+0x2f0>
  6d1fad:	jmp    6d22c0 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b10>
  6d1fb2:	movq   $0xd,0x120(%rsp)
  6d1fbe:	movq   $0x0,0x128(%rsp)
  6d1fca:	jmp    6d1da4 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x15f4>
  6d1fcf:	movq   $0xe,0x120(%rsp)
  6d1fdb:	jmp    6d1da4 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x15f4>
  6d1fe0:	mov    $0x11,%eax
  6d1fe5:	jmp    6d201f <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x186f>
  6d1fe7:	mov    0x3c8(%rsp),%rcx
  6d1fef:	movups 0x3d0(%rsp),%xmm0
  6d1ff7:	movaps %xmm0,0xb10(%rsp)
  6d1fff:	movups 0x3e0(%rsp),%xmm0
  6d2007:	movaps %xmm0,0xb20(%rsp)
  6d200f:	mov    0x3f0(%rsp),%rdx
  6d2017:	mov    %rdx,0xb30(%rsp)
  6d201f:	mov    %rax,0x120(%rsp)
  6d2027:	mov    %rcx,0x128(%rsp)
  6d202f:	movaps 0xb10(%rsp),%xmm0
  6d2037:	movaps 0xb20(%rsp),%xmm1
  6d203f:	movups %xmm0,0x130(%rsp)
  6d2047:	movups %xmm1,0x140(%rsp)
  6d204f:	mov    0xb30(%rsp),%rax
  6d2057:	mov    %rax,0x150(%rsp)
  6d205f:	jmp    6d1da4 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x15f4>
  6d2064:	mov    $0x11,%eax
  6d2069:	mov    0x3f0(%rsp),%rcx
  6d2071:	mov    %rcx,0x150(%rsp)
  6d2079:	movups 0x3d0(%rsp),%xmm0
  6d2081:	movups 0x3e0(%rsp),%xmm1
  6d2089:	movups %xmm1,0x140(%rsp)
  6d2091:	movups %xmm0,0x130(%rsp)
  6d2099:	mov    %rax,0x120(%rsp)
  6d20a1:	mov    %r12,0x128(%rsp)
  6d20a9:	jmp    6d1da4 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x15f4>
  6d20ae:	lea    0x328c4b(%rip),%rax        # 9fad00 <__frame_dummy_init_array_entry+0x11e0>
  6d20b5:	mov    %rax,0x60(%rsp)
  6d20ba:	jmp    6d1548 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0xd98>
  6d20bf:	mov    $0xd,%eax
  6d20c4:	jmp    6d20cb <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x191b>
  6d20c6:	mov    $0xe,%eax
  6d20cb:	mov    %rax,0x3c0(%rsp)
  6d20d3:	mov    0x10(%rsp),%rax
  6d20d8:	mov    %rax,0x3c8(%rsp)
  6d20e0:	lea    -0x68798d(%rip),%rdi        # 4a75a <GCC_except_table0+0xd026>
  6d20e7:	lea    0x32851a(%rip),%rcx        # 9fa608 <__frame_dummy_init_array_entry+0xae8>
  6d20ee:	lea    0x3283ab(%rip),%r8        # 9fa4a0 <__frame_dummy_init_array_entry+0x980>
  6d20f5:	lea    0x3c0(%rsp),%rdx
  6d20fd:	mov    $0x2b,%esi
  6d2102:	call   *0x3474d8(%rip)        # a195e0 <_DYNAMIC+0x2f0>
  6d2108:	jmp    6d22c0 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b10>
  6d210d:	mov    %rax,%r14
  6d2110:	jmp    6d234b <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b9b>
  6d2115:	mov    %rax,%r14
  6d2118:	jmp    6d234b <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b9b>
  6d211d:	mov    %rax,%r14
  6d2120:	jmp    6d2184 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x19d4>
  6d2122:	mov    %rax,%r14
  6d2125:	lea    0x327bfc(%rip),%rsi        # 9f9d28 <__frame_dummy_init_array_entry+0x208>
  6d212c:	mov    %r15,%rdi
  6d212f:	call   6bae00 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtCscdodAO9FK5_5alloc5boxed3BoxDG0_INtNtNtB4_3ops8function2FnTQL1_INtNtCs6ZNK6sH19NW_4gpui7element2ElL0_EEEp6OutputuEL_EECs4gijoeCAvqI_25inspector_pointer_control>
  6d2134:	jmp    6d21f6 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1a46>
  6d2139:	call   *0x347419(%rip)        # a19558 <_DYNAMIC+0x268>
  6d213f:	mov    %rax,%r14
  6d2142:	lea    0x3c0(%rsp),%rdi
  6d214a:	call   6b9570 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtCs6ZNK6sH19NW_4gpui6source7SourcesNtCs4gijoeCAvqI_25inspector_pointer_control5ModelEEB1g_>
  6d214f:	jmp    6d2203 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1a53>
  6d2154:	call   *0x3473fe(%rip)        # a19558 <_DYNAMIC+0x268>
  6d215a:	mov    %rax,%r14
  6d215d:	jmp    6d22dd <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b2d>
  6d2162:	mov    %rax,%r14
  6d2165:	mov    0x8(%rsp),%rdi
  6d216a:	call   6b96c0 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtCs6ZNK6sH19NW_4gpui7runtime3WinNtCs4gijoeCAvqI_25inspector_pointer_control5ModelEEB1d_>
  6d216f:	jmp    6d233b <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b8b>
  6d2174:	mov    %rax,%r14
  6d2177:	lea    0xb10(%rsp),%rdi
  6d217f:	call   6bef80 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueNtNtCshdpBObOiWw8_11gpui_canvas6canvas6CanvasECs4gijoeCAvqI_25inspector_pointer_control>
  6d2184:	lea    0xa0(%rsp),%rdi
  6d218c:	call   6b9570 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtCs6ZNK6sH19NW_4gpui6source7SourcesNtCs4gijoeCAvqI_25inspector_pointer_control5ModelEEB1g_>
  6d2191:	jmp    6d22dd <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b2d>
  6d2196:	jmp    6d232e <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b7e>
  6d219b:	call   *0x3473b7(%rip)        # a19558 <_DYNAMIC+0x268>
  6d21a1:	jmp    6d231c <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b6c>
  6d21a6:	jmp    6d232e <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b7e>
  6d21ab:	jmp    6d232e <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b7e>
  6d21b0:	jmp    6d231c <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b6c>
  6d21b5:	jmp    6d231c <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b6c>
  6d21ba:	jmp    6d231c <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b6c>
  6d21bf:	jmp    6d231c <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b6c>
  6d21c4:	jmp    6d231c <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b6c>
  6d21c9:	jmp    6d231c <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b6c>
  6d21ce:	jmp    6d231c <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b6c>
  6d21d3:	jmp    6d231c <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b6c>
  6d21d8:	mov    %rax,%r14
  6d21db:	lea    0x3c0(%rsp),%rdi
  6d21e3:	call   6b9720 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtCs6ZNK6sH19NW_4gpui7runtime7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelEEB1h_>
  6d21e8:	jmp    6d233b <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b8b>
  6d21ed:	call   *0x347365(%rip)        # a19558 <_DYNAMIC+0x268>
  6d21f3:	mov    %rax,%r14
  6d21f6:	lea    0x3c0(%rsp),%rdi
  6d21fe:	call   6b9570 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtCs6ZNK6sH19NW_4gpui6source7SourcesNtCs4gijoeCAvqI_25inspector_pointer_control5ModelEEB1g_>
  6d2203:	mov    %r14,%rdi
  6d2206:	call   *0x3475bc(%rip)        # a197c8 <_DYNAMIC+0x4d8>
  6d220c:	mov    %rax,%r15
  6d220f:	mov    %rdx,%r12
  6d2212:	mov    (%rdx),%rax
  6d2215:	test   %rax,%rax
  6d2218:	je     6d221f <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1a6f>
  6d221a:	mov    %r15,%rdi
  6d221d:	call   *%rax
  6d221f:	mov    0x8(%r12),%rsi
  6d2224:	test   %rsi,%rsi
  6d2227:	je     6d2237 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1a87>
  6d2229:	mov    0x10(%r12),%rdx
  6d222e:	mov    %r15,%rdi
  6d2231:	call   *0x3472f9(%rip)        # a19530 <_DYNAMIC+0x240>
  6d2237:	mov    $0x6,%esi
  6d223c:	mov    $0x1,%edx
  6d2241:	mov    %rbx,%rdi
  6d2244:	call   *0x3472e6(%rip)        # a19530 <_DYNAMIC+0x240>
  6d224a:	mov    $0xf,%r13d
  6d2250:	mov    %r13,0x120(%rsp)
  6d2258:	shl    $0x20,%r12
  6d225c:	mov    %r15d,%eax
  6d225f:	or     %r12,%rax
  6d2262:	mov    %rax,0x128(%rsp)
  6d226a:	movups %xmm0,0x130(%rsp)
  6d2272:	movups %xmm1,0x140(%rsp)
  6d227a:	mov    %bpl,0x150(%rsp)
  6d2282:	mov    0x28(%rsp),%eax
  6d2286:	mov    0x2b(%rsp),%ecx
  6d228a:	mov    %eax,0x151(%rsp)
  6d2291:	mov    %ecx,0x154(%rsp)
  6d2298:	lea    -0x687b45(%rip),%rdi        # 4a75a <GCC_except_table0+0xd026>
  6d229f:	lea    0x328362(%rip),%rcx        # 9fa608 <__frame_dummy_init_array_entry+0xae8>
  6d22a6:	lea    0x3281ab(%rip),%r8        # 9fa458 <__frame_dummy_init_array_entry+0x938>
  6d22ad:	lea    0x120(%rsp),%rdx
  6d22b5:	mov    $0x2b,%esi
  6d22ba:	call   *0x347320(%rip)        # a195e0 <_DYNAMIC+0x2f0>
  6d22c0:	ud2
  6d22c2:	mov    %rax,%r14
  6d22c5:	mov    0x8(%r12),%rsi
  6d22ca:	test   %rsi,%rsi
  6d22cd:	je     6d22dd <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b2d>
  6d22cf:	mov    0x10(%r12),%rdx
  6d22d4:	mov    %r15,%rdi
  6d22d7:	call   *0x347253(%rip)        # a19530 <_DYNAMIC+0x240>
  6d22dd:	mov    $0x6,%esi
  6d22e2:	mov    $0x1,%edx
  6d22e7:	mov    %rbx,%rdi
  6d22ea:	call   *0x347240(%rip)        # a19530 <_DYNAMIC+0x240>
  6d22f0:	mov    %r14,%rdi
  6d22f3:	call   9f8770 <_Unwind_Resume@plt>
  6d22f8:	mov    %rax,%r14
  6d22fb:	lea    0x120(%rsp),%rdi
  6d2303:	call   6be330 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueNtNtCs6ZNK6sH19NW_4gpui7runtime5ErrorECs4gijoeCAvqI_25inspector_pointer_control>
  6d2308:	mov    %r14,%rdi
  6d230b:	call   9f8770 <_Unwind_Resume@plt>
  6d2310:	call   *0x3474ba(%rip)        # a197d0 <_DYNAMIC+0x4e0>
  6d2316:	call   *0x34723c(%rip)        # a19558 <_DYNAMIC+0x268>
  6d231c:	mov    %rax,%r14
  6d231f:	lea    0x3c0(%rsp),%rdi
  6d2327:	call   6be330 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueNtNtCs6ZNK6sH19NW_4gpui7runtime5ErrorECs4gijoeCAvqI_25inspector_pointer_control>
  6d232c:	jmp    6d2331 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b81>
  6d232e:	mov    %rax,%r14
  6d2331:	mov    0x8(%rsp),%rbx
  6d2336:	test   %rbx,%rbx
  6d2339:	jne    6d2343 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b93>
  6d233b:	mov    %r14,%rdi
  6d233e:	call   9f8770 <_Unwind_Resume@plt>
  6d2343:	mov    %rbx,%rdi
  6d2346:	call   6b9720 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtCs6ZNK6sH19NW_4gpui7runtime7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelEEB1h_>
  6d234b:	mov    $0x748,%esi
  6d2350:	mov    $0x8,%edx
  6d2355:	mov    %rbx,%rdi
  6d2358:	call   *0x3471d2(%rip)        # a19530 <_DYNAMIC+0x240>
  6d235e:	mov    %r14,%rdi
  6d2361:	call   9f8770 <_Unwind_Resume@plt>
  6d2366:	mov    $0x748,%esi
  6d236b:	mov    $0x8,%edx
  6d2370:	mov    %rbx,%rdi
  6d2373:	call   *0x3471b7(%rip)        # a19530 <_DYNAMIC+0x240>
  6d2379:	call   *0x3471d9(%rip)        # a19558 <_DYNAMIC+0x268>

/tmp/gpui-inspector-pointer-codegen-local/candidate-frozen:     file format elf64-x86-64


Disassembly of section .text:

00000000006d2380 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch>:
  6d2380:	push   %rbp
  6d2381:	push   %r15
  6d2383:	push   %r14
  6d2385:	push   %r13
  6d2387:	push   %r12
  6d2389:	push   %rbx
  6d238a:	sub    $0xc8,%rsp
  6d2391:	mov    %rdx,%r14
  6d2394:	mov    %rdi,%rbx
  6d2397:	mov    (%rcx),%ebp
  6d2399:	test   %ebp,%ebp
  6d239b:	je     6d23d0 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x50>
  6d239d:	mov    0x8(%r14),%r12
  6d23a1:	mov    0x10(%r14),%r13
  6d23a5:	mov    0x18(%r14),%rax
  6d23a9:	movq   $0x0,0x8(%r14)
  6d23b1:	lea    -0x1(%rbp),%edx
  6d23b4:	lea    -0x69306b(%rip),%rdi        # 3f350 <GCC_except_table0+0x1c1c>
  6d23bb:	movslq (%rdi,%rdx,4),%rdx
  6d23bf:	add    %rdi,%rdx
  6d23c2:	jmp    *%rdx
  6d23c4:	movl   $0xffffffff,(%r14)
  6d23cb:	jmp    6d2594 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x214>
  6d23d0:	movd   0x4(%rcx),%xmm1
  6d23d5:	movd   0x8(%rcx),%xmm0
  6d23da:	movd   %xmm1,%eax
  6d23de:	movd   %xmm0,%ecx
  6d23e2:	mov    %eax,%edx
  6d23e4:	and    $0x7fffffff,%edx
  6d23ea:	cmp    $0x7f800000,%edx
  6d23f0:	setge  %dl
  6d23f3:	and    $0x7fffffff,%ecx
  6d23f9:	cmp    $0x7f800000,%ecx
  6d23ff:	setge  %cl
  6d2402:	or     %dl,%cl
  6d2404:	je     6d241d <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x9d>
  6d2406:	movl   $0xffffffff,(%r14)
  6d240d:	movq   $0x0,0x8(%r14)
  6d2415:	xor    %r12d,%r12d
  6d2418:	jmp    6d2594 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x214>
  6d241d:	inc    %eax
  6d241f:	je     6d2f89 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xc09>
  6d2425:	mov    %eax,(%r14)
  6d2428:	movd   %xmm0,0x4(%r14)
  6d242e:	xor    %r12d,%r12d
  6d2431:	jmp    6d2594 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x214>
  6d2436:	mov    (%r14),%r15d
  6d2439:	cmp    $0xffffffff,%r15d
  6d243d:	je     6d2594 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x214>
  6d2443:	mov    %rsi,%r13
  6d2446:	movups 0x8(%rcx),%xmm0
  6d244a:	movss  0x4(%r14),%xmm1
  6d2450:	movss  %xmm1,0x50(%rsp)
  6d2456:	movaps %xmm0,%xmm1
  6d2459:	unpckhpd %xmm0,%xmm1
  6d245d:	lea    0x10(%rsp),%rdi
  6d2462:	movaps %xmm0,0xa0(%rsp)
  6d246a:	call   *0x347368(%rip)        # a197d8 <_DYNAMIC+0x4e8>
  6d2470:	cmpl   $0xfffffffe,0x10(%rsp)
  6d2475:	jne    6d27ed <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x46d>
  6d247b:	mov    0x0(%r13),%r14
  6d247f:	test   %r14,%r14
  6d2482:	je     6d25c6 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x246>
  6d2488:	cmpb   $0x1,0x746(%r14)
  6d2490:	je     6d25ba <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x23a>
  6d2496:	cmpb   $0x1,0x742(%r14)
  6d249e:	jne    6d28fa <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x57a>
  6d24a4:	cmpb   $0x0,0x743(%r14)
  6d24ac:	jne    6d28fa <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x57a>
  6d24b2:	cmpb   $0x0,0x744(%r14)
  6d24ba:	je     6d28fa <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x57a>
  6d24c0:	cmpq   $0xffffffffffffffff,0x5b0(%r14)
  6d24c8:	jne    6d28fa <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x57a>
  6d24ce:	mov    0x688(%r14),%rax
  6d24d5:	cmp    0x690(%r14),%rax
  6d24dc:	jne    6d28fa <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x57a>
  6d24e2:	mov    0x698(%r14),%rax
  6d24e9:	cmp    %rax,0x6a0(%r14)
  6d24f0:	jne    6d28fa <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x57a>
  6d24f6:	movss  0x738(%r14),%xmm0
  6d24ff:	ucomiss 0x73c(%r14),%xmm0
  6d2507:	jne    6d28fa <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x57a>
  6d250d:	jp     6d28fa <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x57a>
  6d2513:	mov    %eax,%ecx
  6d2515:	cvtsi2ss %rcx,%xmm2
  6d251a:	dec    %r15d
  6d251d:	shr    $0x20,%rax
  6d2521:	mov    %eax,%eax
  6d2523:	xorps  %xmm1,%xmm1
  6d2526:	cvtsi2ss %rax,%xmm1
  6d252b:	movd   %r15d,%xmm0
  6d2530:	movq   $0x0,0x10(%rsp)
  6d2539:	movss  %xmm2,0x18(%rsp)
  6d253f:	movss  %xmm1,0x1c(%rsp)
  6d2545:	lea    0x10(%rsp),%rdi
  6d254a:	movd   %xmm0,0x8(%rsp)
  6d2550:	movss  0x50(%rsp),%xmm1
  6d2556:	call   *0x34723c(%rip)        # a19798 <_DYNAMIC+0x4a8>
  6d255c:	test   %al,%al
  6d255e:	je     6d2f7d <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xbfd>
  6d2564:	mov    0x638(%r14),%rax
  6d256b:	test   %rax,%rax
  6d256e:	je     6d2dc7 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xa47>
  6d2574:	mov    0x100(%rax),%rsi
  6d257b:	test   %rsi,%rsi
  6d257e:	je     6d2dc7 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xa47>
  6d2584:	lea    0x60(%rsp),%rdi
  6d2589:	call   *0x3471c1(%rip)        # a19750 <_DYNAMIC+0x460>
  6d258f:	jmp    6d2dda <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xa5a>
  6d2594:	mov    (%rsi),%r15
  6d2597:	test   %r15,%r15
  6d259a:	je     6d25c6 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x246>
  6d259c:	add    $0x8,%rsi
  6d25a0:	mov    %r15,0xb8(%rsp)
  6d25a8:	mov    %rsi,0xc0(%rsp)
  6d25b0:	cmpb   $0x1,0x746(%r15)
  6d25b8:	jne    6d25da <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x25a>
  6d25ba:	movq   $0xe,(%rbx)
  6d25c1:	jmp    6d29aa <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x62a>
  6d25c6:	movq   $0xd,(%rbx)
  6d25cd:	movq   $0x0,0x8(%rbx)
  6d25d5:	jmp    6d29aa <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x62a>
  6d25da:	movq   $0x0,0x730(%r15)
  6d25e5:	cmp    $0x3,%ebp
  6d25e8:	je     6d27be <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x43e>
  6d25ee:	cmp    $0x2,%ebp
  6d25f1:	je     6d270a <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x38a>
  6d25f7:	test   %ebp,%ebp
  6d25f9:	jne    6d2951 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x5d1>
  6d25ff:	mov    0x638(%r15),%rax
  6d2606:	test   %rax,%rax
  6d2609:	je     6d2621 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x2a1>
  6d260b:	mov    0xd8(%rax),%rax
  6d2612:	test   %rax,%rax
  6d2615:	je     6d2621 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x2a1>
  6d2617:	cmpb   $0x0,0x12(%rax)
  6d261b:	jne    6d2951 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x5d1>
  6d2621:	mov    0x8(%r14),%r12
  6d2625:	test   %r12,%r12
  6d2628:	je     6d2951 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x5d1>
  6d262e:	cmp    0x5d8(%r15),%r12
  6d2635:	jne    6d2949 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x5c9>
  6d263b:	mov    0x10(%r14),%r13
  6d263f:	lea    0x60(%rsp),%rdi
  6d2644:	mov    %r15,%rsi
  6d2647:	mov    %r13,%rdx
  6d264a:	call   6f8510 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE16resolve_identityBO_>
  6d264f:	mov    0x60(%rsp),%rax
  6d2654:	cmp    $0xfffffffffffffffe,%rax
  6d2658:	jne    6d2906 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x586>
  6d265e:	mov    0x68(%rsp),%rdi
  6d2663:	mov    0x2c8(%r15),%rsi
  6d266a:	cmp    %rsi,%rdi
  6d266d:	jae    6d2fa2 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xc22>
  6d2673:	mov    0x2c0(%r15),%rax
  6d267a:	lea    (%rdi,%rdi,4),%rcx
  6d267e:	mov    0x20(%rax,%rcx,8),%edi
  6d2682:	call   6e1fa0 <_RNvMsh_NtCs6ZNK6sH19NW_4gpui7runtimeNtB5_4Node4kind>
  6d2687:	cmp    $0x4,%al
  6d2689:	jne    6d29bc <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x63c>
  6d268f:	mov    (%r14),%eax
  6d2692:	cmp    $0xffffffff,%eax
  6d2695:	je     6d2fb1 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xc31>
  6d269b:	movd   0x4(%r14),%xmm1
  6d26a1:	dec    %eax
  6d26a3:	movd   %eax,%xmm0
  6d26a7:	lea    0x10(%rsp),%rdi
  6d26ac:	mov    %r15,%rsi
  6d26af:	mov    %r12,%rdx
  6d26b2:	mov    %r13,%rcx
  6d26b5:	mov    $0x1,%r8d
  6d26bb:	call   6db8d0 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime7editingINtB7_10RuntimeMutNtCs4gijoeCAvqI_25inspector_pointer_control5ModeluE14select_pointerB12_>
  6d26c0:	mov    0x10(%rsp),%rax
  6d26c5:	cmp    $0xfffffffffffffffe,%rax
  6d26c9:	je     6d26d8 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x358>
  6d26cb:	cmp    $0x11,%eax
  6d26ce:	jne    6d26d8 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x358>
  6d26d0:	movq   $0x0,0x8(%r14)
  6d26d8:	mov    0x40(%rsp),%rax
  6d26dd:	mov    %rax,0x30(%rbx)
  6d26e1:	movups 0x10(%rsp),%xmm0
  6d26e6:	movups 0x20(%rsp),%xmm1
  6d26eb:	movups 0x30(%rsp),%xmm2
  6d26f0:	movups %xmm2,0x20(%rbx)
  6d26f4:	movups %xmm1,0x10(%rbx)
  6d26f8:	movups %xmm0,(%rbx)
  6d26fb:	lea    0x60(%rsp),%rdi
  6d2700:	call   6b91b0 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtB4_6result6ResultNtNtCs6ZNK6sH19NW_4gpui7runtime6CommitNtBZ_5ErrorEECs4gijoeCAvqI_25inspector_pointer_control>
  6d2705:	jmp    6d29aa <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x62a>
  6d270a:	test   %r12,%r12
  6d270d:	sete   %cl
  6d2710:	cmpb   $0x1,0x742(%r15)
  6d2718:	jne    6d28fa <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x57a>
  6d271e:	cmpb   $0x0,0x743(%r15)
  6d2726:	jne    6d28fa <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x57a>
  6d272c:	cmpb   $0x0,0x744(%r15)
  6d2734:	je     6d28fa <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x57a>
  6d273a:	cmpq   $0xffffffffffffffff,0x5b0(%r15)
  6d2742:	jne    6d28fa <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x57a>
  6d2748:	mov    0x688(%r15),%rax
  6d274f:	cmp    0x690(%r15),%rax
  6d2756:	jne    6d28fa <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x57a>
  6d275c:	mov    0x6a0(%r15),%rax
  6d2763:	cmp    0x698(%r15),%rax
  6d276a:	jne    6d28fa <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x57a>
  6d2770:	movss  0x738(%r15),%xmm0
  6d2779:	ucomiss 0x73c(%r15),%xmm0
  6d2781:	jne    6d28fa <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x57a>
  6d2787:	jp     6d28fa <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x57a>
  6d278d:	mov    (%r14),%eax
  6d2790:	cmp    $0xffffffff,%eax
  6d2793:	mov    %rax,0x50(%rsp)
  6d2798:	mov    %ecx,0x58(%rsp)
  6d279c:	je     6d29c8 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x648>
  6d27a2:	movss  0x4(%r14),%xmm0
  6d27a8:	dec    %eax
  6d27aa:	mov    %eax,0x14(%rsp)
  6d27ae:	movss  %xmm0,0x18(%rsp)
  6d27b4:	mov    $0x1,%eax
  6d27b9:	jmp    6d29ca <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x64a>
  6d27be:	test   %r12,%r12
  6d27c1:	je     6d2951 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x5d1>
  6d27c7:	mov    (%r14),%ecx
  6d27ca:	cmp    $0xffffffff,%ecx
  6d27cd:	mov    %rcx,0x50(%rsp)
  6d27d2:	je     6d2815 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x495>
  6d27d4:	movd   0x4(%r14),%xmm0
  6d27da:	dec    %ecx
  6d27dc:	mov    %ecx,0x64(%rsp)
  6d27e0:	movd   %xmm0,0x68(%rsp)
  6d27e6:	mov    $0x1,%ecx
  6d27eb:	jmp    6d2817 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x497>
  6d27ed:	mov    0x40(%rsp),%rax
  6d27f2:	mov    %rax,0x30(%rbx)
  6d27f6:	movups 0x10(%rsp),%xmm0
  6d27fb:	movups 0x20(%rsp),%xmm1
  6d2800:	movups 0x30(%rsp),%xmm2
  6d2805:	movups %xmm2,0x20(%rbx)
  6d2809:	movups %xmm1,0x10(%rbx)
  6d280d:	movups %xmm0,(%rbx)
  6d2810:	jmp    6d29aa <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x62a>
  6d2815:	xor    %ecx,%ecx
  6d2817:	mov    %ecx,0x60(%rsp)
  6d281b:	movzbl 0x743(%r15),%ecx
  6d2823:	xor    $0x1,%cl
  6d2826:	and    0x742(%r15),%cl
  6d282d:	and    0x744(%r15),%cl
  6d2834:	mov    0x5b0(%r15),%rdx
  6d283b:	cmp    $0xffffffffffffffff,%rdx
  6d283f:	sete   %sil
  6d2843:	and    %cl,%sil
  6d2846:	cmp    $0x1,%sil
  6d284a:	jne    6d28ba <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x53a>
  6d284c:	mov    0x688(%r15),%rax
  6d2853:	cmp    0x690(%r15),%rax
  6d285a:	jne    6d28fa <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x57a>
  6d2860:	mov    0x6a0(%r15),%rax
  6d2867:	cmp    0x698(%r15),%rax
  6d286e:	jne    6d28fa <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x57a>
  6d2874:	movss  0x738(%r15),%xmm0
  6d287d:	ucomiss 0x73c(%r15),%xmm0
  6d2885:	jne    6d28fa <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x57a>
  6d2887:	jp     6d28fa <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x57a>
  6d2889:	lea    0x60(%rsp),%rsi
  6d288e:	mov    %r15,%rdi
  6d2891:	call   6daee0 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE11pointer_hitBW_>
  6d2896:	mov    %rax,0xa0(%rsp)
  6d289e:	mov    %rdx,0x8(%rsp)
  6d28a3:	xor    %ecx,%ecx
  6d28a5:	mov    0x638(%r15),%rax
  6d28ac:	test   %rax,%rax
  6d28af:	jne    6d29fc <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x67c>
  6d28b5:	jmp    6d2af7 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x777>
  6d28ba:	cmp    $0xffffffffffffffff,%rdx
  6d28be:	sete   %dl
  6d28c1:	movq   $0x12,0x10(%rsp)
  6d28ca:	xor    $0x1,%cl
  6d28cd:	or     %dl,%cl
  6d28cf:	jne    6d28fa <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x57a>
  6d28d1:	mov    0x6a0(%r15),%rcx
  6d28d8:	cmp    0x698(%r15),%rcx
  6d28df:	jne    6d28fa <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x57a>
  6d28e1:	movss  0x738(%r15),%xmm0
  6d28ea:	ucomiss 0x73c(%r15),%xmm0
  6d28f2:	jne    6d28fa <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x57a>
  6d28f4:	jnp    6d2a15 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x695>
  6d28fa:	movq   $0x12,(%rbx)
  6d2901:	jmp    6d29aa <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x62a>
  6d2906:	cmp    $0xd,%rax
  6d290a:	jl     6d2929 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x5a9>
  6d290c:	cmp    $0x21,%rax
  6d2910:	je     6d2929 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x5a9>
  6d2912:	cmp    $0x26,%rax
  6d2916:	jne    6d2949 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x5c9>
  6d2918:	mov    0x68(%rsp),%rsi
  6d291d:	test   %rsi,%rsi
  6d2920:	je     6d2949 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x5c9>
  6d2922:	lea    0x70(%rsp),%rax
  6d2927:	jmp    6d293b <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x5bb>
  6d2929:	mov    0x78(%rsp),%rsi
  6d292e:	test   %rsi,%rsi
  6d2931:	je     6d2949 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x5c9>
  6d2933:	lea    0x80(%rsp),%rax
  6d293b:	mov    (%rax),%rdi
  6d293e:	mov    $0x1,%edx
  6d2943:	call   *0x346be7(%rip)        # a19530 <_DYNAMIC+0x240>
  6d2949:	movq   $0x0,0x8(%r14)
  6d2951:	movups 0x688(%r15),%xmm0
  6d2959:	movzbl 0x744(%r15),%eax
  6d2961:	cmpq   $0x0,0x6a8(%r15)
  6d2969:	je     6d2979 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x5f9>
  6d296b:	test   %al,%al
  6d296d:	je     6d297d <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x5fd>
  6d296f:	cmpq   $0xffffffffffffffff,0x5b0(%r15)
  6d2977:	jne    6d297d <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x5fd>
  6d2979:	xor    %ecx,%ecx
  6d297b:	jmp    6d2989 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x609>
  6d297d:	mov    0x6b8(%r15),%rdx
  6d2984:	mov    $0x1,%ecx
  6d2989:	mov    0x730(%r15),%rsi
  6d2990:	mov    %rcx,0x8(%rbx)
  6d2994:	mov    %rdx,0x10(%rbx)
  6d2998:	movups %xmm0,0x18(%rbx)
  6d299c:	mov    %rsi,0x28(%rbx)
  6d29a0:	mov    %al,0x30(%rbx)
  6d29a3:	movq   $0xfffffffffffffffe,(%rbx)
  6d29aa:	add    $0xc8,%rsp
  6d29b1:	pop    %rbx
  6d29b2:	pop    %r12
  6d29b4:	pop    %r13
  6d29b6:	pop    %r14
  6d29b8:	pop    %r15
  6d29ba:	pop    %rbp
  6d29bb:	ret
  6d29bc:	lea    0x60(%rsp),%rdi
  6d29c1:	call   6b91b0 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtB4_6result6ResultNtNtCs6ZNK6sH19NW_4gpui7runtime6CommitNtBZ_5ErrorEECs4gijoeCAvqI_25inspector_pointer_control>
  6d29c6:	jmp    6d2951 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x5d1>
  6d29c8:	xor    %eax,%eax
  6d29ca:	mov    %eax,0x10(%rsp)
  6d29ce:	lea    0x10(%rsp),%rsi
  6d29d3:	mov    %r15,%rdi
  6d29d6:	call   6daee0 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE11pointer_hitBW_>
  6d29db:	mov    %rax,0xa0(%rsp)
  6d29e3:	mov    %rdx,0x8(%rsp)
  6d29e8:	mov    0x58(%rsp),%ecx
  6d29ec:	mov    0x638(%r15),%rax
  6d29f3:	test   %rax,%rax
  6d29f6:	je     6d2af7 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x777>
  6d29fc:	mov    0xd8(%rax),%rax
  6d2a03:	test   %rax,%rax
  6d2a06:	je     6d2af7 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x777>
  6d2a0c:	movzbl 0x12(%rax),%eax
  6d2a10:	jmp    6d2af9 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x779>
  6d2a15:	mov    0x690(%r15),%rcx
  6d2a1c:	cmp    $0xffffffffffffffff,%rcx
  6d2a20:	je     6d28fa <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x57a>
  6d2a26:	inc    %rcx
  6d2a29:	mov    0x688(%r15),%rdx
  6d2a30:	cmp    %rdx,%rcx
  6d2a33:	jne    6d28fa <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x57a>
  6d2a39:	cmp    %rdx,0x6b8(%r15)
  6d2a40:	jne    6d28fa <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x57a>
  6d2a46:	test   %rax,%rax
  6d2a49:	je     6d28fa <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x57a>
  6d2a4f:	cmpq   $0x0,0x6a8(%r15)
  6d2a57:	je     6d28fa <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x57a>
  6d2a5d:	cmp    %rax,0x6b0(%r15)
  6d2a64:	jne    6d28fa <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x57a>
  6d2a6a:	cmp    0x5d8(%r15),%r12
  6d2a71:	jne    6d28fa <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x57a>
  6d2a77:	lea    0x60(%rsp),%rsi
  6d2a7c:	mov    %r15,%rdi
  6d2a7f:	call   6daee0 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE11pointer_hitBW_>
  6d2a84:	mov    %rax,0xa0(%rsp)
  6d2a8c:	mov    %rdx,0x8(%rsp)
  6d2a91:	mov    0x638(%r15),%rax
  6d2a98:	test   %rax,%rax
  6d2a9b:	je     6d2adb <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x75b>
  6d2a9d:	cmpq   $0x0,0xd8(%rax)
  6d2aa5:	je     6d2adb <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x75b>
  6d2aa7:	cmp    %r12,0xa0(%rsp)
  6d2aaf:	jne    6d28fa <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x57a>
  6d2ab5:	cmp    %r13,0x8(%rsp)
  6d2aba:	jne    6d28fa <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x57a>
  6d2ac0:	lea    0x60(%rsp),%rcx
  6d2ac5:	mov    %r15,%rdi
  6d2ac8:	mov    %r12,%rsi
  6d2acb:	mov    %r13,%rdx
  6d2ace:	call   6db0c0 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19inspector_focus_hitBW_>
  6d2ad3:	test   %al,%al
  6d2ad5:	je     6d28fa <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x57a>
  6d2adb:	lea    0x10(%rsp),%rdi
  6d2ae0:	call   6be330 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueNtNtCs6ZNK6sH19NW_4gpui7runtime5ErrorECs4gijoeCAvqI_25inspector_pointer_control>
  6d2ae5:	xor    %ecx,%ecx
  6d2ae7:	mov    0x638(%r15),%rax
  6d2aee:	test   %rax,%rax
  6d2af1:	jne    6d29fc <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x67c>
  6d2af7:	xor    %eax,%eax
  6d2af9:	cmp    $0x2,%ebp
  6d2afc:	jne    6d2bde <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x85e>
  6d2b02:	mov    0x610(%r15),%rdx
  6d2b09:	mov    0x618(%r15),%rcx
  6d2b10:	mov    0xa0(%rsp),%rbp
  6d2b18:	test   %rbp,%rbp
  6d2b1b:	sete   %sil
  6d2b1f:	or     %al,%sil
  6d2b22:	test   $0x1,%sil
  6d2b26:	je     6d2c29 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x8a9>
  6d2b2c:	movq   $0x0,0x610(%r15)
  6d2b37:	lea    0x10(%rsp),%rdi
  6d2b3c:	mov    %r15,%rsi
  6d2b3f:	call   6dbef0 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime7editingINtB7_10RuntimeMutNtCs4gijoeCAvqI_25inspector_pointer_control5ModeluE20publish_focus_changeB12_>
  6d2b44:	mov    0x10(%rsp),%rax
  6d2b49:	movups 0x18(%rsp),%xmm0
  6d2b4e:	movaps %xmm0,0x60(%rsp)
  6d2b53:	movups 0x28(%rsp),%xmm0
  6d2b58:	movaps %xmm0,0x70(%rsp)
  6d2b5d:	movups 0x38(%rsp),%xmm0
  6d2b62:	movaps %xmm0,0x80(%rsp)
  6d2b6a:	cmp    $0xfffffffffffffffe,%rax
  6d2b6e:	jne    6d2d17 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x997>
  6d2b74:	movaps 0x60(%rsp),%xmm0
  6d2b79:	movaps 0x70(%rsp),%xmm1
  6d2b7e:	movaps 0x80(%rsp),%xmm2
  6d2b86:	movaps %xmm2,0x30(%rsp)
  6d2b8b:	movaps %xmm1,0x20(%rsp)
  6d2b90:	movaps %xmm0,0x10(%rsp)
  6d2b95:	cmpq   $0xffffffffffffffff,0x5b0(%r15)
  6d2b9d:	je     6d2d69 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x9e9>
  6d2ba3:	mov    0x690(%r15),%rax
  6d2baa:	cmp    $0xffffffffffffffff,%rax
  6d2bae:	je     6d2d69 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x9e9>
  6d2bb4:	inc    %rax
  6d2bb7:	cmp    0x688(%r15),%rax
  6d2bbe:	jne    6d2d69 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x9e9>
  6d2bc4:	cmpq   $0x0,0x6a8(%r15)
  6d2bcc:	je     6d2d69 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x9e9>
  6d2bd2:	mov    0x6b0(%r15),%rax
  6d2bd9:	jmp    6d2d6b <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x9eb>
  6d2bde:	test   %cl,%cl
  6d2be0:	mov    0xa0(%rsp),%rcx
  6d2be8:	jne    6d2951 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x5d1>
  6d2bee:	test   %rcx,%rcx
  6d2bf1:	je     6d2951 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x5d1>
  6d2bf7:	cmp    %rcx,%r12
  6d2bfa:	jne    6d2951 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x5d1>
  6d2c00:	cmp    0x8(%rsp),%r13
  6d2c05:	jne    6d2951 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x5d1>
  6d2c0b:	test   %al,%al
  6d2c0d:	je     6d2d9e <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xa1e>
  6d2c13:	mov    %rbx,%rdi
  6d2c16:	mov    %r15,%rsi
  6d2c19:	mov    %r12,%rdx
  6d2c1c:	mov    %r13,%rcx
  6d2c1f:	call   6df6e0 <_RNvMs4_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_10RuntimeMutNtCs4gijoeCAvqI_25inspector_pointer_control5ModeluE16inspector_selectB14_>
  6d2c24:	jmp    6d29aa <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x62a>
  6d2c29:	cmp    0x5d8(%r15),%rbp
  6d2c30:	jne    6d2d3d <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x9bd>
  6d2c36:	mov    %rcx,%r12
  6d2c39:	mov    %rdx,%r13
  6d2c3c:	lea    0x10(%rsp),%rdi
  6d2c41:	mov    %r15,%rsi
  6d2c44:	mov    0x8(%rsp),%rdx
  6d2c49:	call   6f8510 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE16resolve_identityBO_>
  6d2c4e:	mov    0x10(%rsp),%rax
  6d2c53:	mov    0x18(%rsp),%rdi
  6d2c58:	cmp    $0xfffffffffffffffe,%rax
  6d2c5c:	jne    6d2d42 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x9c2>
  6d2c62:	mov    0x2c8(%r15),%rsi
  6d2c69:	cmp    %rsi,%rdi
  6d2c6c:	jae    6d2fc0 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xc40>
  6d2c72:	mov    0x2c0(%r15),%rax
  6d2c79:	lea    (%rdi,%rdi,4),%rcx
  6d2c7d:	mov    0x20(%rax,%rcx,8),%edi
  6d2c81:	call   6e1fa0 <_RNvMsh_NtCs6ZNK6sH19NW_4gpui7runtimeNtB5_4Node4kind>
  6d2c86:	cmp    $0x4,%al
  6d2c88:	jne    6d2e9a <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xb1a>
  6d2c8e:	mov    0x50(%rsp),%rax
  6d2c93:	cmp    $0xffffffff,%eax
  6d2c96:	je     6d2fcd <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xc4d>
  6d2c9c:	movss  0x4(%r14),%xmm1
  6d2ca2:	dec    %eax
  6d2ca4:	movd   %eax,%xmm0
  6d2ca8:	lea    0x10(%rsp),%rdi
  6d2cad:	mov    %r15,%rsi
  6d2cb0:	mov    %rbp,%rdx
  6d2cb3:	mov    0x8(%rsp),%r15
  6d2cb8:	mov    %r15,%rcx
  6d2cbb:	xor    %r8d,%r8d
  6d2cbe:	call   6db8d0 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime7editingINtB7_10RuntimeMutNtCs4gijoeCAvqI_25inspector_pointer_control5ModeluE14select_pointerB12_>
  6d2cc3:	mov    0x10(%rsp),%rax
  6d2cc8:	movups 0x38(%rsp),%xmm0
  6d2ccd:	movaps %xmm0,0x80(%rsp)
  6d2cd5:	movdqu 0x28(%rsp),%xmm1
  6d2cdb:	movdqa %xmm1,0x70(%rsp)
  6d2ce1:	movups 0x18(%rsp),%xmm2
  6d2ce6:	movaps %xmm2,0x60(%rsp)
  6d2ceb:	movups %xmm0,0x28(%rbx)
  6d2cef:	movdqu %xmm1,0x18(%rbx)
  6d2cf4:	movups %xmm2,0x8(%rbx)
  6d2cf8:	cmp    $0xfffffffffffffffe,%rax
  6d2cfc:	jne    6d2efe <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xb7e>
  6d2d02:	mov    %rbp,0x8(%r14)
  6d2d06:	mov    %r15,0x10(%r14)
  6d2d0a:	movq   $0x0,0x18(%r14)
  6d2d12:	jmp    6d29a3 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x623>
  6d2d17:	movaps 0x60(%rsp),%xmm0
  6d2d1c:	movaps 0x70(%rsp),%xmm1
  6d2d21:	movaps 0x80(%rsp),%xmm2
  6d2d29:	movups %xmm2,0x28(%rbx)
  6d2d2d:	movups %xmm1,0x18(%rbx)
  6d2d31:	movups %xmm0,0x8(%rbx)
  6d2d35:	mov    %rax,(%rbx)
  6d2d38:	jmp    6d29aa <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x62a>
  6d2d3d:	mov    $0x11,%eax
  6d2d42:	mov    0x40(%rsp),%rcx
  6d2d47:	mov    %rcx,0x30(%rbx)
  6d2d4b:	movups 0x20(%rsp),%xmm0
  6d2d50:	movups 0x30(%rsp),%xmm1
  6d2d55:	movups %xmm1,0x20(%rbx)
  6d2d59:	movups %xmm0,0x10(%rbx)
  6d2d5d:	mov    %rax,(%rbx)
  6d2d60:	mov    %rdi,0x8(%rbx)
  6d2d64:	jmp    6d29aa <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x62a>
  6d2d69:	xor    %eax,%eax
  6d2d6b:	mov    %rbp,0x8(%r14)
  6d2d6f:	mov    0x8(%rsp),%rcx
  6d2d74:	mov    %rcx,0x10(%r14)
  6d2d78:	mov    %rax,0x18(%r14)
  6d2d7c:	movaps 0x10(%rsp),%xmm0
  6d2d81:	movdqa 0x20(%rsp),%xmm1
  6d2d87:	movaps 0x30(%rsp),%xmm2
  6d2d8c:	movups %xmm2,0x28(%rbx)
  6d2d90:	movdqu %xmm1,0x18(%rbx)
  6d2d95:	movups %xmm0,0x8(%rbx)
  6d2d99:	jmp    6d29a3 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x623>
  6d2d9e:	movq   $0x0,0x10(%rsp)
  6d2da7:	lea    0xb8(%rsp),%rsi
  6d2daf:	lea    0x10(%rsp),%r8
  6d2db4:	mov    %rbx,%rdi
  6d2db7:	mov    %r12,%rdx
  6d2dba:	mov    %r13,%rcx
  6d2dbd:	call   6d6170 <_RNvMNtNtCs6ZNK6sH19NW_4gpui7runtime4turnINtB4_10RuntimeMutNtCs4gijoeCAvqI_25inspector_pointer_control5ModeluE21activate_with_editingBW_>
  6d2dc2:	jmp    6d29aa <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x62a>
  6d2dc7:	movq   $0x4,0x60(%rsp)
  6d2dd0:	pxor   %xmm0,%xmm0
  6d2dd4:	movdqu %xmm0,0x68(%rsp)
  6d2dda:	mov    0x5a8(%r14),%rax
  6d2de1:	mov    %rax,0x58(%rsp)
  6d2de6:	test   %rax,%rax
  6d2de9:	je     6d2f7d <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xbfd>
  6d2def:	mov    0x5a0(%r14),%rbp
  6d2df6:	mov    0x58(%rsp),%rax
  6d2dfb:	mov    %rax,%r15
  6d2dfe:	shl    $0x6,%r15
  6d2e02:	lea    -0x1(%rax),%r12
  6d2e06:	jmp    6d2e69 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xae9>
  6d2e08:	mov    0x70(%rsp),%rax
  6d2e0d:	mov    %rax,0x20(%rsp)
  6d2e12:	movups 0x60(%rsp),%xmm0
  6d2e17:	movaps %xmm0,0x10(%rsp)
  6d2e1c:	mov    0x638(%r14),%rax
  6d2e23:	test   %rax,%rax
  6d2e26:	je     6d2e96 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xb16>
  6d2e28:	cmpq   $0x0,(%rax)
  6d2e2c:	setne  %al
  6d2e2f:	movzbl %al,%ecx
  6d2e32:	mov    %rbp,%rdi
  6d2e35:	mov    0x58(%rsp),%rsi
  6d2e3a:	lea    0x10(%rsp),%rdx
  6d2e3f:	mov    %r12,%r8
  6d2e42:	movd   0x8(%rsp),%xmm0
  6d2e48:	movss  0x50(%rsp),%xmm1
  6d2e4e:	call   *0x34698c(%rip)        # a197e0 <_DYNAMIC+0x4f0>
  6d2e54:	test   %al,%al
  6d2e56:	jne    6d2f06 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xb86>
  6d2e5c:	dec    %r12
  6d2e5f:	add    $0xffffffffffffffc0,%r15
  6d2e63:	je     6d2f7d <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xbfd>
  6d2e69:	cmpb   $0x0,-0x2(%rbp,%r15,1)
  6d2e6f:	jne    6d2e08 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xa88>
  6d2e71:	movzbl -0x3(%rbp,%r15,1),%eax
  6d2e77:	sub    $0x2,%al
  6d2e79:	movzbl %al,%eax
  6d2e7c:	mov    $0x8,%ecx
  6d2e81:	cmovb  %ecx,%eax
  6d2e84:	cmp    $0x7,%al
  6d2e86:	je     6d2e08 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xa88>
  6d2e88:	movzbl %al,%eax
  6d2e8b:	cmp    $0x4,%eax
  6d2e8e:	je     6d2e08 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xa88>
  6d2e94:	jmp    6d2e5c <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xadc>
  6d2e96:	xor    %eax,%eax
  6d2e98:	jmp    6d2e2f <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xaaf>
  6d2e9a:	lea    0x10(%rsp),%rdi
  6d2e9f:	mov    %r15,%rsi
  6d2ea2:	mov    %rbp,%rdx
  6d2ea5:	mov    0x8(%rsp),%rcx
  6d2eaa:	call   6db550 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE5focusBW_>
  6d2eaf:	mov    0x10(%rsp),%rax
  6d2eb4:	cmp    $0xfffffffffffffffe,%rax
  6d2eb8:	jne    6d2ec5 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xb45>
  6d2eba:	mov    %r13,%rdx
  6d2ebd:	mov    %r12,%rcx
  6d2ec0:	jmp    6d2b37 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x7b7>
  6d2ec5:	mov    0x38(%rsp),%rcx
  6d2eca:	movzbl 0x40(%rsp),%edx
  6d2ecf:	mov    0x44(%rsp),%esi
  6d2ed3:	mov    %esi,0x34(%rbx)
  6d2ed6:	mov    0x41(%rsp),%esi
  6d2eda:	mov    %esi,0x31(%rbx)
  6d2edd:	movups 0x18(%rsp),%xmm0
  6d2ee2:	movups 0x28(%rsp),%xmm1
  6d2ee7:	mov    %rax,(%rbx)
  6d2eea:	movups %xmm0,0x8(%rbx)
  6d2eee:	movups %xmm1,0x18(%rbx)
  6d2ef2:	mov    %rcx,0x28(%rbx)
  6d2ef6:	mov    %dl,0x30(%rbx)
  6d2ef9:	jmp    6d29aa <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x62a>
  6d2efe:	mov    %rax,(%rbx)
  6d2f01:	jmp    6d29aa <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x62a>
  6d2f06:	movq   $0x19,0x10(%rsp)
  6d2f0f:	lea    0x10(%rsp),%rdi
  6d2f14:	call   6be330 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueNtNtCs6ZNK6sH19NW_4gpui7runtime5ErrorECs4gijoeCAvqI_25inspector_pointer_control>
  6d2f19:	mov    %r12,0xc0(%rsp)
  6d2f21:	movq   $0x1,0xb8(%rsp)
  6d2f2d:	lea    0xb8(%rsp),%rdi
  6d2f35:	mov    %r14,%rsi
  6d2f38:	mov    %r14,%rdx
  6d2f3b:	call   6ce010 <_RINvYINtNtNtNtCs4NRVxsYgnAr_4core4iter7sources7from_fn6FromFnNCNvMs6_NtNtCs6ZNK6sH19NW_4gpui7runtime6scrollINtB17_3WinNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE12scroll_at_2ds0_0ENtNtNtBa_6traits8iterator8Iterator8try_folduNCINvNvB2Z_3any5checkjNCBZ_s1_0E0INtNtNtBc_3ops12control_flow11ControlFlowuEEB1U_>
  6d2f40:	test   %al,%al
  6d2f42:	je     6d2f7d <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xbfd>
  6d2f44:	movq   $0x1,0x18(%rsp)
  6d2f4d:	mov    %r12,0x20(%rsp)
  6d2f52:	movaps 0xa0(%rsp),%xmm0
  6d2f5a:	movups %xmm0,0x28(%rsp)
  6d2f5f:	movq   $0x3,0x10(%rsp)
  6d2f68:	lea    0x10(%rsp),%rdx
  6d2f6d:	mov    %rbx,%rdi
  6d2f70:	mov    %r13,%rsi
  6d2f73:	call   6e1000 <_RNvMs6_NtNtCs6ZNK6sH19NW_4gpui7runtime6scrollINtB7_3WinNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE17apply_scroll_planBT_>
  6d2f78:	jmp    6d29aa <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x62a>
  6d2f7d:	movq   $0x19,(%rbx)
  6d2f84:	jmp    6d29aa <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x62a>
  6d2f89:	lea    -0x685de7(%rip),%rdi        # 4d1a9 <GCC_except_table0+0xfa75>
  6d2f90:	lea    0x327a21(%rip),%rdx        # 9fa9b8 <__frame_dummy_init_array_entry+0xe98>
  6d2f97:	mov    $0x22,%esi
  6d2f9c:	call   *0x346736(%rip)        # a196d8 <_DYNAMIC+0x3e8>
  6d2fa2:	lea    0x327a27(%rip),%rdx        # 9fa9d0 <__frame_dummy_init_array_entry+0xeb0>
  6d2fa9:	call   *0x3465b1(%rip)        # a19560 <_DYNAMIC+0x270>
  6d2faf:	jmp    6d2fbe <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xc3e>
  6d2fb1:	lea    0x327a30(%rip),%rdi        # 9fa9e8 <__frame_dummy_init_array_entry+0xec8>
  6d2fb8:	call   *0x34660a(%rip)        # a195c8 <_DYNAMIC+0x2d8>
  6d2fbe:	ud2
  6d2fc0:	lea    0x327a39(%rip),%rdx        # 9faa00 <__frame_dummy_init_array_entry+0xee0>
  6d2fc7:	call   *0x346593(%rip)        # a19560 <_DYNAMIC+0x270>
  6d2fcd:	lea    0x327a44(%rip),%rdi        # 9faa18 <__frame_dummy_init_array_entry+0xef8>
  6d2fd4:	call   *0x3465ee(%rip)        # a195c8 <_DYNAMIC+0x2d8>
  6d2fda:	mov    %rax,%rbx
  6d2fdd:	lea    0x10(%rsp),%rdi
  6d2fe2:	call   6be330 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueNtNtCs6ZNK6sH19NW_4gpui7runtime5ErrorECs4gijoeCAvqI_25inspector_pointer_control>
  6d2fe7:	mov    %rbx,%rdi
  6d2fea:	call   9f8770 <_Unwind_Resume@plt>
  6d2fef:	mov    %rax,%rbx
  6d2ff2:	lea    0x60(%rsp),%rdi
  6d2ff7:	call   6b91b0 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtB4_6result6ResultNtNtCs6ZNK6sH19NW_4gpui7runtime6CommitNtBZ_5ErrorEECs4gijoeCAvqI_25inspector_pointer_control>
  6d2ffc:	mov    %rbx,%rdi
  6d2fff:	call   9f8770 <_Unwind_Resume@plt>

/tmp/gpui-inspector-pointer-codegen-local/candidate-frozen:     file format elf64-x86-64


Disassembly of section .text:

00000000006d3010 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8hit_only>:
  6d3010:	test   %rsi,%rsi
  6d3013:	je     6d3026 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8hit_only+0x16>
  6d3015:	cmpb   $0x0,0x746(%rsi)
  6d301c:	je     6d3036 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8hit_only+0x26>
  6d301e:	movq   $0xe,(%rdi)
  6d3025:	ret
  6d3026:	movq   $0xd,(%rdi)
  6d302d:	movq   $0x0,0x8(%rdi)
  6d3035:	ret
  6d3036:	cmpb   $0x1,0x742(%rsi)
  6d303d:	jne    6d30bb <_RNvCs4gijoeCAvqI_25inspector_pointer_control8hit_only+0xab>
  6d303f:	cmpb   $0x0,0x743(%rsi)
  6d3046:	jne    6d30bb <_RNvCs4gijoeCAvqI_25inspector_pointer_control8hit_only+0xab>
  6d3048:	cmpb   $0x0,0x744(%rsi)
  6d304f:	je     6d30bb <_RNvCs4gijoeCAvqI_25inspector_pointer_control8hit_only+0xab>
  6d3051:	cmpq   $0xffffffffffffffff,0x5b0(%rsi)
  6d3059:	jne    6d30bb <_RNvCs4gijoeCAvqI_25inspector_pointer_control8hit_only+0xab>
  6d305b:	mov    0x688(%rsi),%rax
  6d3062:	cmp    0x690(%rsi),%rax
  6d3069:	jne    6d30bb <_RNvCs4gijoeCAvqI_25inspector_pointer_control8hit_only+0xab>
  6d306b:	mov    0x6a0(%rsi),%rax
  6d3072:	cmp    0x698(%rsi),%rax
  6d3079:	jne    6d30bb <_RNvCs4gijoeCAvqI_25inspector_pointer_control8hit_only+0xab>
  6d307b:	movss  0x738(%rsi),%xmm2
  6d3083:	ucomiss 0x73c(%rsi),%xmm2
  6d308a:	jne    6d30bb <_RNvCs4gijoeCAvqI_25inspector_pointer_control8hit_only+0xab>
  6d308c:	jp     6d30bb <_RNvCs4gijoeCAvqI_25inspector_pointer_control8hit_only+0xab>
  6d308e:	push   %r14
  6d3090:	push   %rbx
  6d3091:	push   %rax
  6d3092:	mov    %rdi,%rbx
  6d3095:	mov    %rsi,%r14
  6d3098:	mov    %rsi,%rdi
  6d309b:	call   6f87f0 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_>
  6d30a0:	cmp    $0x1,%rax
  6d30a4:	jne    6d30c3 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8hit_only+0xb3>
  6d30a6:	mov    %r14,%rdi
  6d30a9:	add    $0x5d8,%rdi
  6d30b0:	mov    %rdx,%rsi
  6d30b3:	call   *0x34669f(%rip)        # a19758 <_DYNAMIC+0x468>
  6d30b9:	jmp    6d30c5 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8hit_only+0xb5>
  6d30bb:	movq   $0x12,(%rdi)
  6d30c2:	ret
  6d30c3:	xor    %eax,%eax
  6d30c5:	mov    %rax,0x8(%rbx)
  6d30c9:	mov    %rdx,0x10(%rbx)
  6d30cd:	movq   $0xfffffffffffffffe,(%rbx)
  6d30d4:	add    $0x8,%rsp
  6d30d8:	pop    %rbx
  6d30d9:	pop    %r14
  6d30db:	ret

/tmp/gpui-inspector-pointer-codegen-local/candidate-frozen:     file format elf64-x86-64


Disassembly of section .text:

00000000006daee0 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE11pointer_hitBW_>:
  6daee0:	cmpl   $0x1,(%rsi)
  6daee3:	jne    6daf5e <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE11pointer_hitBW_+0x7e>
  6daee5:	push   %r15
  6daee7:	push   %r14
  6daee9:	push   %r12
  6daeeb:	push   %rbx
  6daeec:	sub    $0x58,%rsp
  6daef0:	movss  0x4(%rsi),%xmm0
  6daef5:	movss  0x8(%rsi),%xmm1
  6daefa:	mov    0x638(%rdi),%rbx
  6daf01:	test   %rbx,%rbx
  6daf04:	je     6daf61 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE11pointer_hitBW_+0x81>
  6daf06:	mov    0xd8(%rbx),%rax
  6daf0d:	test   %rax,%rax
  6daf10:	je     6daf61 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE11pointer_hitBW_+0x81>
  6daf12:	cmpb   $0x0,0x12(%rax)
  6daf16:	je     6daf61 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE11pointer_hitBW_+0x81>
  6daf18:	mov    0x5a0(%rdi),%r14
  6daf1f:	mov    0x5a8(%rdi),%r15
  6daf26:	mov    0x100(%rbx),%rsi
  6daf2d:	test   %rsi,%rsi
  6daf30:	je     6daf86 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE11pointer_hitBW_+0xa6>
  6daf32:	lea    0x8(%rsp),%rax
  6daf37:	mov    %rdi,%r12
  6daf3a:	mov    %rax,%rdi
  6daf3d:	movss  %xmm1,0x4(%rsp)
  6daf43:	movss  %xmm0,(%rsp)
  6daf48:	call   *0x33e802(%rip)        # a19750 <_DYNAMIC+0x460>
  6daf4e:	movss  (%rsp),%xmm0
  6daf53:	movss  0x4(%rsp),%xmm1
  6daf59:	mov    %r12,%rdi
  6daf5c:	jmp    6daf97 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE11pointer_hitBW_+0xb7>
  6daf5e:	xor    %eax,%eax
  6daf60:	ret
  6daf61:	mov    %rdi,%rbx
  6daf64:	call   6f87f0 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_>
  6daf69:	test   $0x1,%al
  6daf6b:	je     6daf82 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE11pointer_hitBW_+0xa2>
  6daf6d:	mov    %rbx,%rdi
  6daf70:	add    $0x5d8,%rdi
  6daf77:	mov    %rdx,%rsi
  6daf7a:	call   *0x33e7d8(%rip)        # a19758 <_DYNAMIC+0x468>
  6daf80:	jmp    6dafde <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE11pointer_hitBW_+0xfe>
  6daf82:	xor    %eax,%eax
  6daf84:	jmp    6dafde <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE11pointer_hitBW_+0xfe>
  6daf86:	movq   $0x4,0x8(%rsp)
  6daf8f:	xorps  %xmm2,%xmm2
  6daf92:	movups %xmm2,0x10(%rsp)
  6daf97:	cmpq   $0x0,(%rbx)
  6daf9b:	mov    0x698(%rdi),%rax
  6dafa2:	mov    %r14,0x20(%rsp)
  6dafa7:	mov    %r15,0x28(%rsp)
  6dafac:	mov    0x8(%rsp),%rcx
  6dafb1:	mov    %rcx,0x30(%rsp)
  6dafb6:	mov    0x10(%rsp),%rcx
  6dafbb:	mov    %rcx,0x38(%rsp)
  6dafc0:	mov    0x18(%rsp),%rcx
  6dafc5:	mov    %rcx,0x40(%rsp)
  6dafca:	mov    %rax,0x48(%rsp)
  6dafcf:	setne  0x50(%rsp)
  6dafd4:	lea    0x20(%rsp),%rsi
  6dafd9:	call   6dd620 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE23inspector_pick_in_sheetB10_>
  6dafde:	add    $0x58,%rsp
  6dafe2:	pop    %rbx
  6dafe3:	pop    %r12
  6dafe5:	pop    %r14
  6dafe7:	pop    %r15
  6dafe9:	ret

/tmp/gpui-inspector-pointer-codegen-local/candidate-frozen:     file format elf64-x86-64


Disassembly of section .text:

00000000006db0c0 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19inspector_focus_hitBW_>:
  6db0c0:	push   %rbp
  6db0c1:	push   %r15
  6db0c3:	push   %r14
  6db0c5:	push   %r13
  6db0c7:	push   %r12
  6db0c9:	push   %rbx
  6db0ca:	sub    $0x78,%rsp
  6db0ce:	cmpl   $0x1,(%rcx)
  6db0d1:	jne    6db515 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19inspector_focus_hitBW_+0x455>
  6db0d7:	mov    %rdi,%rbx
  6db0da:	mov    %rsi,%r12
  6db0dd:	mov    %rdx,0x38(%rsp)
  6db0e2:	movss  0x4(%rcx),%xmm0
  6db0e7:	movss  0x8(%rcx),%xmm1
  6db0ec:	movq   $0x0,0x40(%rsp)
  6db0f5:	movsd  0x698(%rdi),%xmm2
  6db0fd:	xorpd  %xmm3,%xmm3
  6db101:	unpcklps %xmm3,%xmm2
  6db104:	movapd -0x69c8ac(%rip),%xmm3        # 3e860 <GCC_except_table0+0x112c>
  6db10c:	orpd   %xmm3,%xmm2
  6db110:	subpd  %xmm3,%xmm2
  6db114:	cvtpd2ps %xmm2,%xmm2
  6db118:	movlpd %xmm2,0x48(%rsp)
  6db11e:	lea    0x40(%rsp),%rdi
  6db123:	movss  %xmm0,0xc(%rsp)
  6db129:	movss  %xmm1,0x8(%rsp)
  6db12f:	call   *0x33e663(%rip)        # a19798 <_DYNAMIC+0x4a8>
  6db135:	test   %al,%al
  6db137:	je     6db515 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19inspector_focus_hitBW_+0x455>
  6db13d:	cmpq   $0xffffffffffffffff,0x5b0(%rbx)
  6db145:	setne  %al
  6db148:	movzwl 0x5d0(%rbx),%ebp
  6db14f:	test   %bp,%bp
  6db152:	setns  %cl
  6db155:	and    %al,%cl
  6db157:	cmp    $0x1,%cl
  6db15a:	jne    6db515 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19inspector_focus_hitBW_+0x455>
  6db160:	mov    0x638(%rbx),%r13
  6db167:	test   %r13,%r13
  6db16a:	je     6db515 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19inspector_focus_hitBW_+0x455>
  6db170:	mov    0x60(%r13),%r14
  6db174:	cmp    $0xffffffffffffffff,%r14
  6db178:	je     6db515 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19inspector_focus_hitBW_+0x455>
  6db17e:	mov    0x100(%r13),%rsi
  6db185:	test   %rsi,%rsi
  6db188:	je     6db1ae <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19inspector_focus_hitBW_+0xee>
  6db18a:	lea    0x40(%rsp),%rdi
  6db18f:	call   *0x33e76b(%rip)        # a19900 <_DYNAMIC+0x610>
  6db195:	mov    0x40(%rsp),%rax
  6db19a:	test   %rax,%rax
  6db19d:	je     6db515 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19inspector_focus_hitBW_+0x455>
  6db1a3:	movups 0x48(%rsp),%xmm0
  6db1a8:	mov    0x60(%r13),%r14
  6db1ac:	jmp    6db1b6 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19inspector_focus_hitBW_+0xf6>
  6db1ae:	xorps  %xmm0,%xmm0
  6db1b1:	mov    $0x4,%eax
  6db1b6:	movzwl %bp,%ecx
  6db1b9:	mov    0x5b8(%rbx),%r15
  6db1c0:	mov    0x5c0(%rbx),%rsi
  6db1c7:	movzwl 0x5d2(%rbx),%edx
  6db1ce:	xorps  %xmm1,%xmm1
  6db1d1:	cvtsi2ss %edx,%xmm1
  6db1d5:	shl    $0x20,%rdx
  6db1d9:	or     %rcx,%rdx
  6db1dc:	test   %r14,%r14
  6db1df:	mov    %r15,0x40(%rsp)
  6db1e4:	mov    %rsi,0x10(%rsp)
  6db1e9:	mov    %rsi,0x48(%rsp)
  6db1ee:	mov    %rax,0x50(%rsp)
  6db1f3:	movups %xmm0,0x58(%rsp)
  6db1f8:	mov    %rdx,0x68(%rsp)
  6db1fd:	setne  0x70(%rsp)
  6db202:	movswl %cx,%eax
  6db205:	xorps  %xmm0,%xmm0
  6db208:	cvtsi2ss %eax,%xmm0
  6db20c:	movq   $0x0,0x20(%rsp)
  6db215:	movss  %xmm0,0x18(%rsp)
  6db21b:	movss  %xmm0,0x28(%rsp)
  6db221:	movss  %xmm1,0x1c(%rsp)
  6db227:	movss  %xmm1,0x2c(%rsp)
  6db22d:	lea    0x20(%rsp),%rdi
  6db232:	movss  0xc(%rsp),%xmm0
  6db238:	movss  0x8(%rsp),%xmm1
  6db23e:	call   *0x33e554(%rip)        # a19798 <_DYNAMIC+0x4a8>
  6db244:	test   %al,%al
  6db246:	je     6db515 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19inspector_focus_hitBW_+0x455>
  6db24c:	mov    0xd8(%r13),%rax
  6db253:	test   %rax,%rax
  6db256:	je     6db299 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19inspector_focus_hitBW_+0x1d9>
  6db258:	cmpb   $0x0,0x12(%rax)
  6db25c:	je     6db299 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19inspector_focus_hitBW_+0x1d9>
  6db25e:	lea    0x40(%rsp),%rsi
  6db263:	mov    %rbx,%rdi
  6db266:	movss  0xc(%rsp),%xmm0
  6db26c:	movss  0x8(%rsp),%xmm1
  6db272:	call   6dd620 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE23inspector_pick_in_sheetB10_>
  6db277:	test   %rax,%rax
  6db27a:	je     6db515 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19inspector_focus_hitBW_+0x455>
  6db280:	cmp    %r12,%rax
  6db283:	mov    0x38(%rsp),%rax
  6db288:	jne    6db515 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19inspector_focus_hitBW_+0x455>
  6db28e:	cmp    %rax,%rdx
  6db291:	sete   %al
  6db294:	jmp    6db517 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19inspector_focus_hitBW_+0x457>
  6db299:	movq   $0x0,0x20(%rsp)
  6db2a2:	movss  0x18(%rsp),%xmm0
  6db2a8:	movss  %xmm0,0x28(%rsp)
  6db2ae:	movss  0x1c(%rsp),%xmm0
  6db2b4:	movss  %xmm0,0x2c(%rsp)
  6db2ba:	lea    0x20(%rsp),%rdi
  6db2bf:	movss  0xc(%rsp),%xmm0
  6db2c5:	movss  0x8(%rsp),%xmm1
  6db2cb:	call   *0x33e4c7(%rip)        # a19798 <_DYNAMIC+0x4a8>
  6db2d1:	mov    %eax,%ecx
  6db2d3:	xor    %eax,%eax
  6db2d5:	cmpq   $0x0,0x10(%rsp)
  6db2db:	je     6db517 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19inspector_focus_hitBW_+0x457>
  6db2e1:	test   %cl,%cl
  6db2e3:	je     6db517 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19inspector_focus_hitBW_+0x457>
  6db2e9:	mov    0x10(%rsp),%rax
  6db2ee:	shl    $0x6,%rax
  6db2f2:	add    %r15,%rax
  6db2f5:	jmp    6db351 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19inspector_focus_hitBW_+0x291>
  6db2f7:	xor    %ecx,%ecx
  6db2f9:	test   %r14,%r14
  6db2fc:	setne  %cl
  6db2ff:	mov    %rbp,%r13
  6db302:	sub    %r15,%r13
  6db305:	shr    $0x6,%r13
  6db309:	lea    0x50(%rsp),%rdx
  6db30e:	mov    0x10(%rdx),%rax
  6db312:	mov    %rax,0x30(%rsp)
  6db317:	movups (%rdx),%xmm0
  6db31a:	movaps %xmm0,0x20(%rsp)
  6db31f:	mov    %r15,%rdi
  6db322:	mov    0x10(%rsp),%rsi
  6db327:	lea    0x20(%rsp),%rdx
  6db32c:	mov    %r13,%r8
  6db32f:	movss  0xc(%rsp),%xmm0
  6db335:	movss  0x8(%rsp),%xmm1
  6db33b:	call   *0x33e49f(%rip)        # a197e0 <_DYNAMIC+0x4f0>
  6db341:	test   %al,%al
  6db343:	jne    6db391 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19inspector_focus_hitBW_+0x2d1>
  6db345:	mov    %rbp,%rax
  6db348:	cmp    %rbp,%r15
  6db34b:	je     6db515 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19inspector_focus_hitBW_+0x455>
  6db351:	lea    -0x40(%rax),%rbp
  6db355:	cmpb   $0x0,-0x2(%rax)
  6db359:	jne    6db2f7 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19inspector_focus_hitBW_+0x237>
  6db35b:	mov    -0x8(%rax),%eax
  6db35e:	cmp    $0x3ffff,%rax
  6db364:	jbe    6db345 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19inspector_focus_hitBW_+0x285>
  6db366:	shr    $0x11,%eax
  6db369:	mov    %rbp,%rcx
  6db36c:	sub    %r15,%rcx
  6db36f:	shr    $0x6,%rcx
  6db373:	mov    $0x2,%edx
  6db378:	sub    %rax,%rdx
  6db37b:	add    $0xfffffffffffffffe,%rax
  6db37f:	shl    $0x6,%rdx
  6db383:	cmp    %rcx,%rax
  6db386:	lea    -0x40(%rbp,%rdx,1),%rbp
  6db38b:	cmovae %r15,%rbp
  6db38f:	jmp    6db345 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19inspector_focus_hitBW_+0x285>
  6db391:	mov    0x1e8(%rbx),%rcx
  6db398:	mov    0x1f0(%rbx),%rdx
  6db39f:	mov    0x1f8(%rbx),%r8
  6db3a6:	mov    0x2c8(%rbx),%rsi
  6db3ad:	mov    0x2c0(%rbx),%r9
  6db3b4:	jmp    6db3ce <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19inspector_focus_hitBW_+0x30e>
  6db3b6:	mov    0x38(%r10),%r13d
  6db3ba:	and    $0x1ffff,%r13d
  6db3c1:	cmp    $0x1ffff,%r13
  6db3c8:	je     6db515 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19inspector_focus_hitBW_+0x455>
  6db3ce:	cmp    0x10(%rsp),%r13
  6db3d3:	jae    6db526 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19inspector_focus_hitBW_+0x466>
  6db3d9:	shl    $0x6,%r13
  6db3dd:	lea    (%r15,%r13,1),%r10
  6db3e1:	mov    0x20(%r15,%r13,1),%rax
  6db3e6:	test   %rcx,%rcx
  6db3e9:	je     6db3ff <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19inspector_focus_hitBW_+0x33f>
  6db3eb:	cmp    $0x1,%ecx
  6db3ee:	jne    6db41a <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19inspector_focus_hitBW_+0x35a>
  6db3f0:	test   %r8,%r8
  6db3f3:	je     6db3b6 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19inspector_focus_hitBW_+0x2f6>
  6db3f5:	cmp    $0x1,%r8
  6db3f9:	jne    6db432 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19inspector_focus_hitBW_+0x372>
  6db3fb:	xor    %edi,%edi
  6db3fd:	jmp    6db45b <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19inspector_focus_hitBW_+0x39b>
  6db3ff:	mov    %rax,%rdi
  6db402:	sub    %rdx,%rdi
  6db405:	setae  %r11b
  6db409:	cmp    %r8,%rdi
  6db40c:	setb   %bpl
  6db410:	test   %bpl,%r11b
  6db413:	je     6db3b6 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19inspector_focus_hitBW_+0x2f6>
  6db415:	jmp    6db4d8 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19inspector_focus_hitBW_+0x418>
  6db41a:	test   %r8,%r8
  6db41d:	je     6db3b6 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19inspector_focus_hitBW_+0x2f6>
  6db41f:	cmp    $0x1,%r8
  6db423:	jne    6db49c <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19inspector_focus_hitBW_+0x3dc>
  6db425:	mov    %rdx,%rdi
  6db428:	cmp    %rax,(%rdx)
  6db42b:	jne    6db3b6 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19inspector_focus_hitBW_+0x2f6>
  6db42d:	jmp    6db4d5 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19inspector_focus_hitBW_+0x415>
  6db432:	mov    %r8,%r11
  6db435:	xor    %edi,%edi
  6db437:	mov    %rdi,%r14
  6db43a:	mov    %r11,%r13
  6db43d:	shr    $1,%r13
  6db440:	add    %r13,%rdi
  6db443:	mov    %rdi,%rbp
  6db446:	shl    $0x4,%rbp
  6db44a:	cmp    %rax,(%rdx,%rbp,1)
  6db44e:	cmova  %r14,%rdi
  6db452:	sub    %r13,%r11
  6db455:	cmp    $0x1,%r11
  6db459:	ja     6db437 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19inspector_focus_hitBW_+0x377>
  6db45b:	mov    %rdi,%r14
  6db45e:	shl    $0x4,%r14
  6db462:	xor    %r11d,%r11d
  6db465:	cmp    %rax,(%rdx,%r14,1)
  6db469:	setbe  %r11b
  6db46d:	add    %rdi,%r11
  6db470:	je     6db3b6 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19inspector_focus_hitBW_+0x2f6>
  6db476:	shl    $0x4,%r11
  6db47a:	mov    %rax,%rdi
  6db47d:	sub    -0x10(%rdx,%r11,1),%rdi
  6db482:	mov    -0x4(%rdx,%r11,1),%r14d
  6db487:	cmp    %r14,%rdi
  6db48a:	jae    6db3b6 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19inspector_focus_hitBW_+0x2f6>
  6db490:	add    %rdx,%r11
  6db493:	mov    -0x8(%r11),%r11d
  6db497:	add    %r11,%rdi
  6db49a:	jmp    6db4d8 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19inspector_focus_hitBW_+0x418>
  6db49c:	mov    %r8,%rdi
  6db49f:	xor    %r11d,%r11d
  6db4a2:	mov    %r11,%r14
  6db4a5:	mov    %rdi,%r13
  6db4a8:	shr    $1,%r13
  6db4ab:	add    %r13,%r11
  6db4ae:	lea    (%r11,%r11,2),%rbp
  6db4b2:	cmp    %rax,(%rdx,%rbp,4)
  6db4b6:	cmova  %r14,%r11
  6db4ba:	sub    %r13,%rdi
  6db4bd:	cmp    $0x1,%rdi
  6db4c1:	ja     6db4a2 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19inspector_focus_hitBW_+0x3e2>
  6db4c3:	lea    (%r11,%r11,2),%rdi
  6db4c7:	cmp    %rax,(%rdx,%rdi,4)
  6db4cb:	jne    6db3b6 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19inspector_focus_hitBW_+0x2f6>
  6db4d1:	lea    (%rdx,%rdi,4),%rdi
  6db4d5:	mov    0x8(%rdi),%edi
  6db4d8:	cmp    %rsi,%rdi
  6db4db:	jae    6db53b <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19inspector_focus_hitBW_+0x47b>
  6db4dd:	lea    (%rdi,%rdi,4),%rdi
  6db4e1:	cmpq   $0x0,0x8(%r9,%rdi,8)
  6db4e7:	jne    6db4f4 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19inspector_focus_hitBW_+0x434>
  6db4e9:	cmpb   $0x4,0x3d(%r10)
  6db4ee:	jne    6db3b6 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19inspector_focus_hitBW_+0x2f6>
  6db4f4:	add    $0x5d8,%rbx
  6db4fb:	mov    %rbx,%rdi
  6db4fe:	mov    %rax,%rsi
  6db501:	call   *0x33e251(%rip)        # a19758 <_DYNAMIC+0x468>
  6db507:	cmp    %r12,%rax
  6db50a:	mov    0x38(%rsp),%rax
  6db50f:	je     6db28e <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19inspector_focus_hitBW_+0x1ce>
  6db515:	xor    %eax,%eax
  6db517:	add    $0x78,%rsp
  6db51b:	pop    %rbx
  6db51c:	pop    %r12
  6db51e:	pop    %r13
  6db520:	pop    %r14
  6db522:	pop    %r15
  6db524:	pop    %rbp
  6db525:	ret
  6db526:	lea    0x31f81b(%rip),%rdx        # 9fad48 <__frame_dummy_init_array_entry+0x1228>
  6db52d:	mov    %r13,%rdi
  6db530:	mov    0x10(%rsp),%rsi
  6db535:	call   *0x33e025(%rip)        # a19560 <_DYNAMIC+0x270>
  6db53b:	lea    0x31f81e(%rip),%rdx        # 9fad60 <__frame_dummy_init_array_entry+0x1240>
  6db542:	call   *0x33e018(%rip)        # a19560 <_DYNAMIC+0x270>

/tmp/gpui-inspector-pointer-codegen-local/candidate-frozen:     file format elf64-x86-64


Disassembly of section .text:

00000000006dd620 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE23inspector_pick_in_sheetB10_>:
  6dd620:	push   %rbp
  6dd621:	push   %r15
  6dd623:	push   %r14
  6dd625:	push   %r13
  6dd627:	push   %r12
  6dd629:	push   %rbx
  6dd62a:	sub    $0x68,%rsp
  6dd62e:	movss  %xmm1,0x14(%rsp)
  6dd634:	movss  %xmm0,0x10(%rsp)
  6dd63a:	mov    0x638(%rdi),%rcx
  6dd641:	test   %rcx,%rcx
  6dd644:	je     6dd73f <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE23inspector_pick_in_sheetB10_+0x11f>
  6dd64a:	cmpq   $0x0,0xd8(%rcx)
  6dd652:	je     6dd73f <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE23inspector_pick_in_sheetB10_+0x11f>
  6dd658:	mov    0x2c8(%rdi),%rax
  6dd65f:	cmp    $0x1c,%rax
  6dd663:	jb     6dd73f <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE23inspector_pick_in_sheetB10_+0x11f>
  6dd669:	mov    %rsi,%r14
  6dd66c:	mov    0x8(%rsi),%r15
  6dd670:	test   %r15,%r15
  6dd673:	je     6dd73f <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE23inspector_pick_in_sheetB10_+0x11f>
  6dd679:	mov    %rdi,0x28(%rsp)
  6dd67e:	mov    %rcx,0x20(%rsp)
  6dd683:	mov    %rax,0x18(%rsp)
  6dd688:	mov    (%r14),%r13
  6dd68b:	mov    %r15,%rax
  6dd68e:	shl    $0x6,%rax
  6dd692:	add    %r13,%rax
  6dd695:	movzbl 0x30(%r14),%ecx
  6dd69a:	mov    %ecx,0xc(%rsp)
  6dd69e:	add    $0x10,%r14
  6dd6a2:	jmp    6dd6ff <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE23inspector_pick_in_sheetB10_+0xdf>
  6dd6a4:	data16 data16 cs nopw 0x0(%rax,%rax,1)
  6dd6b0:	mov    %rbp,%r12
  6dd6b3:	sub    %r13,%r12
  6dd6b6:	mov    %r12,%rbx
  6dd6b9:	shr    $0x6,%rbx
  6dd6bd:	mov    0x10(%r14),%rax
  6dd6c1:	mov    %rax,0x40(%rsp)
  6dd6c6:	movups (%r14),%xmm0
  6dd6ca:	movaps %xmm0,0x30(%rsp)
  6dd6cf:	mov    %r13,%rdi
  6dd6d2:	mov    %r15,%rsi
  6dd6d5:	lea    0x30(%rsp),%rdx
  6dd6da:	mov    0xc(%rsp),%ecx
  6dd6de:	mov    %rbx,%r8
  6dd6e1:	movss  0x10(%rsp),%xmm0
  6dd6e7:	movss  0x14(%rsp),%xmm1
  6dd6ed:	call   *0x33c0ed(%rip)        # a197e0 <_DYNAMIC+0x4f0>
  6dd6f3:	test   %al,%al
  6dd6f5:	jne    6dd758 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE23inspector_pick_in_sheetB10_+0x138>
  6dd6f7:	mov    %rbp,%rax
  6dd6fa:	cmp    %rbp,%r13
  6dd6fd:	je     6dd753 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE23inspector_pick_in_sheetB10_+0x133>
  6dd6ff:	lea    -0x40(%rax),%rbp
  6dd703:	cmpb   $0x0,-0x2(%rax)
  6dd707:	jne    6dd6b0 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE23inspector_pick_in_sheetB10_+0x90>
  6dd709:	mov    -0x8(%rax),%eax
  6dd70c:	cmp    $0x3ffff,%rax
  6dd712:	jbe    6dd6f7 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE23inspector_pick_in_sheetB10_+0xd7>
  6dd714:	shr    $0x11,%eax
  6dd717:	mov    %rbp,%rcx
  6dd71a:	sub    %r13,%rcx
  6dd71d:	shr    $0x6,%rcx
  6dd721:	mov    $0x2,%edx
  6dd726:	sub    %rax,%rdx
  6dd729:	add    $0xfffffffffffffffe,%rax
  6dd72d:	shl    $0x6,%rdx
  6dd731:	cmp    %rcx,%rax
  6dd734:	lea    -0x40(%rbp,%rdx,1),%rbp
  6dd739:	cmovae %r13,%rbp
  6dd73d:	jmp    6dd6f7 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE23inspector_pick_in_sheetB10_+0xd7>
  6dd73f:	xor    %eax,%eax
  6dd741:	mov    %r14,%rdx
  6dd744:	add    $0x68,%rsp
  6dd748:	pop    %rbx
  6dd749:	pop    %r12
  6dd74b:	pop    %r13
  6dd74d:	pop    %r14
  6dd74f:	pop    %r15
  6dd751:	pop    %rbp
  6dd752:	ret
  6dd753:	jmp    6dd817 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE23inspector_pick_in_sheetB10_+0x1f7>
  6dd758:	cmp    %r15,%rbx
  6dd75b:	jae    6dd81e <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE23inspector_pick_in_sheetB10_+0x1fe>
  6dd761:	mov    0x28(%rsp),%r15
  6dd766:	lea    0x5d8(%r15),%rdi
  6dd76d:	mov    0x20(%r13,%r12,1),%rsi
  6dd772:	call   *0x33bfe0(%rip)        # a19758 <_DYNAMIC+0x468>
  6dd778:	mov    %rdx,%r14
  6dd77b:	cmp    0x5d8(%r15),%rax
  6dd782:	jne    6dd817 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE23inspector_pick_in_sheetB10_+0x1f7>
  6dd788:	mov    %rax,%rbx
  6dd78b:	lea    0x30(%rsp),%rdi
  6dd790:	mov    %r15,%rsi
  6dd793:	mov    %r14,%rdx
  6dd796:	call   6f8510 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE16resolve_identityBO_>
  6dd79b:	mov    0x30(%rsp),%rcx
  6dd7a0:	mov    0x38(%rsp),%rax
  6dd7a5:	cmp    $0xfffffffffffffffe,%rcx
  6dd7a9:	jne    6dd7dc <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE23inspector_pick_in_sheetB10_+0x1bc>
  6dd7ab:	mov    0x20(%rsp),%rcx
  6dd7b0:	cmpq   $0x0,0xd8(%rcx)
  6dd7b8:	je     6dd817 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE23inspector_pick_in_sheetB10_+0x1f7>
  6dd7ba:	mov    0x18(%rsp),%rdx
  6dd7bf:	add    $0xffffffffffffffe4,%rdx
  6dd7c3:	cmp    $0x2,%rax
  6dd7c7:	setae  %cl
  6dd7ca:	cmp    %rdx,%rax
  6dd7cd:	setb   %al
  6dd7d0:	test   %al,%cl
  6dd7d2:	je     6dd817 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE23inspector_pick_in_sheetB10_+0x1f7>
  6dd7d4:	mov    %rbx,%rax
  6dd7d7:	jmp    6dd741 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE23inspector_pick_in_sheetB10_+0x121>
  6dd7dc:	mov    0x48(%rsp),%rsi
  6dd7e1:	mov    0x50(%rsp),%rdi
  6dd7e6:	cmp    $0xc,%rcx
  6dd7ea:	jle    6dd807 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE23inspector_pick_in_sheetB10_+0x1e7>
  6dd7ec:	cmp    $0x21,%rcx
  6dd7f0:	je     6dd807 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE23inspector_pick_in_sheetB10_+0x1e7>
  6dd7f2:	cmp    $0x26,%rcx
  6dd7f6:	jne    6dd817 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE23inspector_pick_in_sheetB10_+0x1f7>
  6dd7f8:	test   %rax,%rax
  6dd7fb:	je     6dd817 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE23inspector_pick_in_sheetB10_+0x1f7>
  6dd7fd:	mov    0x40(%rsp),%rdi
  6dd802:	mov    %rax,%rsi
  6dd805:	jmp    6dd80c <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE23inspector_pick_in_sheetB10_+0x1ec>
  6dd807:	test   %rsi,%rsi
  6dd80a:	je     6dd817 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE23inspector_pick_in_sheetB10_+0x1f7>
  6dd80c:	mov    $0x1,%edx
  6dd811:	call   *0x33bd19(%rip)        # a19530 <_DYNAMIC+0x240>
  6dd817:	xor    %eax,%eax
  6dd819:	jmp    6dd741 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE23inspector_pick_in_sheetB10_+0x121>
  6dd81e:	lea    0x31d343(%rip),%rdx        # 9fab68 <__frame_dummy_init_array_entry+0x1048>
  6dd825:	mov    %rbx,%rdi
  6dd828:	mov    %r15,%rsi
  6dd82b:	call   *0x33bd2f(%rip)        # a19560 <_DYNAMIC+0x270>

/tmp/gpui-inspector-pointer-codegen-local/candidate-frozen:     file format elf64-x86-64


Disassembly of section .text:

00000000006f87f0 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_>:
  6f87f0:	push   %rbp
  6f87f1:	push   %r15
  6f87f3:	push   %r14
  6f87f5:	push   %r13
  6f87f7:	push   %r12
  6f87f9:	push   %rbx
  6f87fa:	sub    $0x48,%rsp
  6f87fe:	movss  %xmm1,0xc(%rsp)
  6f8804:	movss  %xmm0,0x8(%rsp)
  6f880a:	mov    %rdi,%r15
  6f880d:	mov    0x5a0(%rdi),%r14
  6f8814:	mov    0x5a8(%rdi),%rax
  6f881b:	mov    %rax,(%rsp)
  6f881f:	mov    0x638(%rdi),%rbx
  6f8826:	test   %rbx,%rbx
  6f8829:	je     6f8844 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x54>
  6f882b:	mov    0x100(%rbx),%rsi
  6f8832:	test   %rsi,%rsi
  6f8835:	je     6f8859 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x69>
  6f8837:	lea    0x30(%rsp),%rdi
  6f883c:	call   *0x320f0e(%rip)        # a19750 <_DYNAMIC+0x460>
  6f8842:	jmp    6f886a <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x7a>
  6f8844:	movq   $0x4,0x30(%rsp)
  6f884d:	xorps  %xmm0,%xmm0
  6f8850:	movups %xmm0,0x38(%rsp)
  6f8855:	xor    %ebx,%ebx
  6f8857:	jmp    6f8871 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x81>
  6f8859:	movq   $0x4,0x30(%rsp)
  6f8862:	xorps  %xmm0,%xmm0
  6f8865:	movups %xmm0,0x38(%rsp)
  6f886a:	cmpq   $0x0,(%rbx)
  6f886e:	setne  %bl
  6f8871:	mov    0x698(%r15),%rax
  6f8878:	mov    %eax,%ecx
  6f887a:	xorps  %xmm0,%xmm0
  6f887d:	cvtsi2ss %rcx,%xmm0
  6f8882:	shr    $0x20,%rax
  6f8886:	xorps  %xmm1,%xmm1
  6f8889:	cvtsi2ss %rax,%xmm1
  6f888e:	movq   $0x0,0x10(%rsp)
  6f8897:	movss  %xmm0,0x18(%rsp)
  6f889d:	movss  %xmm1,0x1c(%rsp)
  6f88a3:	lea    0x10(%rsp),%rdi
  6f88a8:	movss  0x8(%rsp),%xmm0
  6f88ae:	movss  0xc(%rsp),%xmm1
  6f88b4:	call   *0x320ede(%rip)        # a19798 <_DYNAMIC+0x4a8>
  6f88ba:	xor    %r12d,%r12d
  6f88bd:	cmpq   $0x0,(%rsp)
  6f88c2:	je     6f897d <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x18d>
  6f88c8:	test   %al,%al
  6f88ca:	je     6f897d <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x18d>
  6f88d0:	mov    (%rsp),%rax
  6f88d4:	shl    $0x6,%rax
  6f88d8:	add    %r14,%rax
  6f88db:	movzbl %bl,%ebp
  6f88de:	xor    %r12d,%r12d
  6f88e1:	jmp    6f893d <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x14d>
  6f88e3:	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  6f88f0:	mov    %rbx,%r13
  6f88f3:	sub    %r14,%r13
  6f88f6:	shr    $0x6,%r13
  6f88fa:	mov    0x40(%rsp),%rax
  6f88ff:	mov    %rax,0x20(%rsp)
  6f8904:	movups 0x30(%rsp),%xmm0
  6f8909:	movaps %xmm0,0x10(%rsp)
  6f890e:	mov    %r14,%rdi
  6f8911:	mov    (%rsp),%rsi
  6f8915:	lea    0x10(%rsp),%rdx
  6f891a:	mov    %ebp,%ecx
  6f891c:	mov    %r13,%r8
  6f891f:	movss  0x8(%rsp),%xmm0
  6f8925:	movss  0xc(%rsp),%xmm1
  6f892b:	call   *0x320eaf(%rip)        # a197e0 <_DYNAMIC+0x4f0>
  6f8931:	test   %al,%al
  6f8933:	jne    6f898f <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x19f>
  6f8935:	mov    %rbx,%rax
  6f8938:	cmp    %rbx,%r14
  6f893b:	je     6f897d <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x18d>
  6f893d:	lea    -0x40(%rax),%rbx
  6f8941:	cmpb   $0x0,-0x2(%rax)
  6f8945:	jne    6f88f0 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x100>
  6f8947:	mov    -0x8(%rax),%eax
  6f894a:	cmp    $0x3ffff,%rax
  6f8950:	jbe    6f8935 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x145>
  6f8952:	shr    $0x11,%eax
  6f8955:	mov    %rbx,%rcx
  6f8958:	sub    %r14,%rcx
  6f895b:	shr    $0x6,%rcx
  6f895f:	mov    $0x2,%edx
  6f8964:	sub    %rax,%rdx
  6f8967:	add    $0xfffffffffffffffe,%rax
  6f896b:	shl    $0x6,%rdx
  6f896f:	cmp    %rcx,%rax
  6f8972:	lea    -0x40(%rbx,%rdx,1),%rbx
  6f8977:	cmovae %r14,%rbx
  6f897b:	jmp    6f8935 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x145>
  6f897d:	mov    %r12,%rax
  6f8980:	add    $0x48,%rsp
  6f8984:	pop    %rbx
  6f8985:	pop    %r12
  6f8987:	pop    %r13
  6f8989:	pop    %r14
  6f898b:	pop    %r15
  6f898d:	pop    %rbp
  6f898e:	ret
  6f898f:	mov    0x1e8(%r15),%rax
  6f8996:	mov    0x1f0(%r15),%rcx
  6f899d:	mov    0x1f8(%r15),%r8
  6f89a4:	mov    0x2c8(%r15),%rsi
  6f89ab:	mov    0x2c0(%r15),%r9
  6f89b2:	jmp    6f89d8 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x1e8>
  6f89b4:	data16 data16 cs nopw 0x0(%rax,%rax,1)
  6f89c0:	mov    0x38(%r10),%r13d
  6f89c4:	and    $0x1ffff,%r13d
  6f89cb:	cmp    $0x1ffff,%r13
  6f89d2:	je     6f8b31 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x341>
  6f89d8:	cmp    (%rsp),%r13
  6f89dc:	jae    6f8b39 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x349>
  6f89e2:	shl    $0x6,%r13
  6f89e6:	lea    (%r14,%r13,1),%r10
  6f89ea:	mov    0x20(%r14,%r13,1),%rdx
  6f89ef:	test   %rax,%rax
  6f89f2:	je     6f8a10 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x220>
  6f89f4:	cmp    $0x1,%eax
  6f89f7:	jne    6f8a30 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x240>
  6f89f9:	test   %r8,%r8
  6f89fc:	je     6f89c0 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x1d0>
  6f89fe:	cmp    $0x1,%r8
  6f8a02:	jne    6f8a50 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x260>
  6f8a04:	xor    %edi,%edi
  6f8a06:	jmp    6f8a84 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x294>
  6f8a08:	nopl   0x0(%rax,%rax,1)
  6f8a10:	mov    %rdx,%rdi
  6f8a13:	sub    %rcx,%rdi
  6f8a16:	setae  %r11b
  6f8a1a:	cmp    %r8,%rdi
  6f8a1d:	setb   %bl
  6f8a20:	test   %bl,%r11b
  6f8a23:	je     6f89c0 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x1d0>
  6f8a25:	jmp    6f8b06 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x316>
  6f8a2a:	nopw   0x0(%rax,%rax,1)
  6f8a30:	test   %r8,%r8
  6f8a33:	je     6f89c0 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x1d0>
  6f8a35:	cmp    $0x1,%r8
  6f8a39:	jne    6f8ac5 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x2d5>
  6f8a3f:	mov    %rcx,%rdi
  6f8a42:	cmp    %rdx,(%rcx)
  6f8a45:	jne    6f89c0 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x1d0>
  6f8a4b:	jmp    6f8b03 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x313>
  6f8a50:	mov    %r8,%r11
  6f8a53:	xor    %edi,%edi
  6f8a55:	data16 cs nopw 0x0(%rax,%rax,1)
  6f8a60:	mov    %rdi,%rbx
  6f8a63:	mov    %r11,%r15
  6f8a66:	shr    $1,%r15
  6f8a69:	add    %r15,%rdi
  6f8a6c:	mov    %rdi,%r12
  6f8a6f:	shl    $0x4,%r12
  6f8a73:	cmp    %rdx,(%rcx,%r12,1)
  6f8a77:	cmova  %rbx,%rdi
  6f8a7b:	sub    %r15,%r11
  6f8a7e:	cmp    $0x1,%r11
  6f8a82:	ja     6f8a60 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x270>
  6f8a84:	mov    %rdi,%rbx
  6f8a87:	shl    $0x4,%rbx
  6f8a8b:	xor    %r11d,%r11d
  6f8a8e:	cmp    %rdx,(%rcx,%rbx,1)
  6f8a92:	setbe  %r11b
  6f8a96:	add    %rdi,%r11
  6f8a99:	je     6f89c0 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x1d0>
  6f8a9f:	shl    $0x4,%r11
  6f8aa3:	mov    %rdx,%rdi
  6f8aa6:	sub    -0x10(%rcx,%r11,1),%rdi
  6f8aab:	mov    -0x4(%rcx,%r11,1),%ebx
  6f8ab0:	cmp    %rbx,%rdi
  6f8ab3:	jae    6f89c0 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x1d0>
  6f8ab9:	add    %rcx,%r11
  6f8abc:	mov    -0x8(%r11),%r11d
  6f8ac0:	add    %r11,%rdi
  6f8ac3:	jmp    6f8b06 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x316>
  6f8ac5:	mov    %r8,%rdi
  6f8ac8:	xor    %r11d,%r11d
  6f8acb:	nopl   0x0(%rax,%rax,1)
  6f8ad0:	mov    %r11,%rbx
  6f8ad3:	mov    %rdi,%r15
  6f8ad6:	shr    $1,%r15
  6f8ad9:	add    %r15,%r11
  6f8adc:	lea    (%r11,%r11,2),%r12
  6f8ae0:	cmp    %rdx,(%rcx,%r12,4)
  6f8ae4:	cmova  %rbx,%r11
  6f8ae8:	sub    %r15,%rdi
  6f8aeb:	cmp    $0x1,%rdi
  6f8aef:	ja     6f8ad0 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x2e0>
  6f8af1:	lea    (%r11,%r11,2),%rdi
  6f8af5:	cmp    %rdx,(%rcx,%rdi,4)
  6f8af9:	jne    6f89c0 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x1d0>
  6f8aff:	lea    (%rcx,%rdi,4),%rdi
  6f8b03:	mov    0x8(%rdi),%edi
  6f8b06:	cmp    %rsi,%rdi
  6f8b09:	jae    6f8b4d <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x35d>
  6f8b0b:	lea    (%rdi,%rdi,4),%rdi
  6f8b0f:	mov    $0x1,%r12d
  6f8b15:	cmpq   $0x0,0x8(%r9,%rdi,8)
  6f8b1b:	jne    6f897d <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x18d>
  6f8b21:	cmpb   $0x4,0x3d(%r10)
  6f8b26:	jne    6f89c0 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x1d0>
  6f8b2c:	jmp    6f897d <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x18d>
  6f8b31:	xor    %r12d,%r12d
  6f8b34:	jmp    6f897d <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x18d>
  6f8b39:	lea    0x302208(%rip),%rdx        # 9fad48 <__frame_dummy_init_array_entry+0x1228>
  6f8b40:	mov    %r13,%rdi
  6f8b43:	mov    (%rsp),%rsi
  6f8b47:	call   *0x320a13(%rip)        # a19560 <_DYNAMIC+0x270>
  6f8b4d:	lea    0x30220c(%rip),%rdx        # 9fad60 <__frame_dummy_init_array_entry+0x1240>
  6f8b54:	call   *0x320a06(%rip)        # a19560 <_DYNAMIC+0x270>

inspector_pointer_control::click_only bytes=879 stack=152

inspector_pointer_control::ack bytes=241 stack=136

inspector_pointer_control::main bytes=7119 stack=3368

inspector_pointer_control::dispatch bytes=3204 stack=248

inspector_pointer_control::hit_only bytes=204 stack=24

<gpui::runtime::Runtime<inspector_pointer_control::Model>>::pointer_hit bytes=266 stack=120

<gpui::runtime::Runtime<inspector_pointer_control::Model>>::inspector_focus_hit bytes=1160 stack=168

<gpui::runtime::Runtime<inspector_pointer_control::Model>>::inspector_pick_in_sheet bytes=529 stack=152

<gpui::runtime::Runtime<inspector_pointer_control::Model>>::hit bytes=874 stack=120
