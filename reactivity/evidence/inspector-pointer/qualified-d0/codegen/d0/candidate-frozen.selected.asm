
/tmp/gpui-inspector-pointer-codegen-optin/candidate-frozen:     file format elf64-x86-64


Disassembly of section .text:

00000000006d0370 <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only>:
  6d0370:	push   %rbp
  6d0371:	push   %r15
  6d0373:	push   %r14
  6d0375:	push   %r13
  6d0377:	push   %r12
  6d0379:	push   %rbx
  6d037a:	sub    $0x58,%rsp
  6d037e:	mov    (%rsi),%rbx
  6d0381:	test   %rbx,%rbx
  6d0384:	je     6d03a9 <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x39>
  6d0386:	add    $0x8,%rsi
  6d038a:	mov    %rbx,0x48(%rsp)
  6d038f:	mov    %rsi,0x50(%rsp)
  6d0394:	cmpb   $0x1,0x746(%rbx)
  6d039b:	jne    6d03bd <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x4d>
  6d039d:	movq   $0xe,(%rdi)
  6d03a4:	jmp    6d047d <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x10d>
  6d03a9:	movq   $0xd,(%rdi)
  6d03b0:	movq   $0x0,0x8(%rdi)
  6d03b8:	jmp    6d047d <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x10d>
  6d03bd:	cmpb   $0x1,0x742(%rbx)
  6d03c4:	jne    6d0476 <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x106>
  6d03ca:	cmpb   $0x0,0x743(%rbx)
  6d03d1:	jne    6d0476 <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x106>
  6d03d7:	cmpb   $0x0,0x744(%rbx)
  6d03de:	je     6d0476 <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x106>
  6d03e4:	cmpq   $0xffffffffffffffff,0x5b0(%rbx)
  6d03ec:	jne    6d0476 <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x106>
  6d03f2:	mov    0x688(%rbx),%rax
  6d03f9:	cmp    0x690(%rbx),%rax
  6d0400:	jne    6d0476 <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x106>
  6d0402:	mov    0x6a0(%rbx),%rax
  6d0409:	cmp    0x698(%rbx),%rax
  6d0410:	jne    6d0476 <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x106>
  6d0412:	movss  0x738(%rbx),%xmm2
  6d041a:	ucomiss 0x73c(%rbx),%xmm2
  6d0421:	jne    6d0476 <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x106>
  6d0423:	jp     6d0476 <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x106>
  6d0425:	mov    %rdi,%r14
  6d0428:	mov    0x638(%rbx),%rax
  6d042f:	test   %rax,%rax
  6d0432:	je     6d048c <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x11c>
  6d0434:	mov    0xd8(%rax),%rax
  6d043b:	test   %rax,%rax
  6d043e:	je     6d048c <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x11c>
  6d0440:	cmpb   $0x0,0x12(%rax)
  6d0444:	je     6d048c <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x11c>
  6d0446:	mov    %rbx,%rdi
  6d0449:	call   6dc0d0 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE14inspector_pickB10_>
  6d044e:	test   %rax,%rax
  6d0451:	je     6d0588 <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x218>
  6d0457:	mov    %rdx,%rcx
  6d045a:	mov    %r14,%rdi
  6d045d:	mov    %rbx,%rsi
  6d0460:	mov    %rax,%rdx
  6d0463:	add    $0x58,%rsp
  6d0467:	pop    %rbx
  6d0468:	pop    %r12
  6d046a:	pop    %r13
  6d046c:	pop    %r14
  6d046e:	pop    %r15
  6d0470:	pop    %rbp
  6d0471:	jmp    6df6f0 <_RNvMs4_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_10RuntimeMutNtCs4gijoeCAvqI_25inspector_pointer_control5ModeluE16inspector_selectB14_>
  6d0476:	movq   $0x12,(%rdi)
  6d047d:	add    $0x58,%rsp
  6d0481:	pop    %rbx
  6d0482:	pop    %r12
  6d0484:	pop    %r13
  6d0486:	pop    %r14
  6d0488:	pop    %r15
  6d048a:	pop    %rbp
  6d048b:	ret
  6d048c:	mov    %rbx,%rdi
  6d048f:	movss  %xmm0,0x8(%rsp)
  6d0495:	movss  %xmm1,0xc(%rsp)
  6d049b:	call   6f8800 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_>
  6d04a0:	cmp    $0x1,%rax
  6d04a4:	jne    6d0548 <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x1d8>
  6d04aa:	lea    0x5d8(%rbx),%rdi
  6d04b1:	mov    %rdx,%rsi
  6d04b4:	call   *0x3492a6(%rip)        # a19760 <_DYNAMIC+0x460>
  6d04ba:	cmp    0x5d8(%rbx),%rax
  6d04c1:	jne    6d0594 <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x224>
  6d04c7:	mov    %rax,%r12
  6d04ca:	mov    %rdx,%r15
  6d04cd:	lea    0x10(%rsp),%rdi
  6d04d2:	mov    %rbx,%rsi
  6d04d5:	call   6f8520 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE16resolve_identityBO_>
  6d04da:	mov    0x10(%rsp),%rax
  6d04df:	mov    0x18(%rsp),%rdi
  6d04e4:	cmp    $0xfffffffffffffffe,%rax
  6d04e8:	jne    6d0599 <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x229>
  6d04ee:	mov    0x2c8(%rbx),%rsi
  6d04f5:	cmp    %rsi,%rdi
  6d04f8:	jae    6d064a <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x2da>
  6d04fe:	mov    0x2c0(%rbx),%rax
  6d0505:	lea    (%rdi,%rdi,4),%rcx
  6d0509:	mov    0x20(%rax,%rcx,8),%edi
  6d050d:	call   6e1fb0 <_RNvMsh_NtCs6ZNK6sH19NW_4gpui7runtimeNtB5_4Node4kind>
  6d0512:	cmp    $0x4,%al
  6d0514:	jne    6d05c2 <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x252>
  6d051a:	mov    %r14,%rdi
  6d051d:	mov    %rbx,%rsi
  6d0520:	mov    %r12,%rdx
  6d0523:	mov    %r15,%rcx
  6d0526:	movss  0x8(%rsp),%xmm0
  6d052c:	movss  0xc(%rsp),%xmm1
  6d0532:	xor    %r8d,%r8d
  6d0535:	add    $0x58,%rsp
  6d0539:	pop    %rbx
  6d053a:	pop    %r12
  6d053c:	pop    %r13
  6d053e:	pop    %r14
  6d0540:	pop    %r15
  6d0542:	pop    %rbp
  6d0543:	jmp    6db800 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime7editingINtB7_10RuntimeMutNtCs4gijoeCAvqI_25inspector_pointer_control5ModeluE14select_pointerB12_>
  6d0548:	mov    0x610(%rbx),%rdx
  6d054f:	mov    0x618(%rbx),%rcx
  6d0556:	movq   $0x0,0x610(%rbx)
  6d0561:	movq   $0x0,0x730(%rbx)
  6d056c:	lea    0x10(%rsp),%rdi
  6d0571:	mov    %rbx,%rsi
  6d0574:	call   6dbe20 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime7editingINtB7_10RuntimeMutNtCs4gijoeCAvqI_25inspector_pointer_control5ModeluE20publish_focus_changeB12_>
  6d0579:	mov    0x10(%rsp),%rax
  6d057e:	cmp    $0xfffffffffffffffe,%rax
  6d0582:	jne    6d060c <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x29c>
  6d0588:	movq   $0x19,(%r14)
  6d058f:	jmp    6d047d <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x10d>
  6d0594:	mov    $0x11,%eax
  6d0599:	mov    0x40(%rsp),%rcx
  6d059e:	mov    %rcx,0x30(%r14)
  6d05a2:	movups 0x20(%rsp),%xmm0
  6d05a7:	movups 0x30(%rsp),%xmm1
  6d05ac:	movups %xmm1,0x20(%r14)
  6d05b1:	movups %xmm0,0x10(%r14)
  6d05b6:	mov    %rax,(%r14)
  6d05b9:	mov    %rdi,0x8(%r14)
  6d05bd:	jmp    6d047d <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x10d>
  6d05c2:	mov    0x610(%rbx),%r13
  6d05c9:	mov    0x618(%rbx),%rbp
  6d05d0:	lea    0x10(%rsp),%rdi
  6d05d5:	mov    %rbx,%rsi
  6d05d8:	mov    %r12,%rdx
  6d05db:	mov    %r15,%rcx
  6d05de:	call   6db480 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE5focusBW_>
  6d05e3:	mov    0x10(%rsp),%rax
  6d05e8:	cmp    $0xfffffffffffffffe,%rax
  6d05ec:	jne    6d060c <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x29c>
  6d05ee:	lea    0x48(%rsp),%rsi
  6d05f3:	mov    %r14,%rdi
  6d05f6:	mov    %r12,%rdx
  6d05f9:	mov    %r15,%rcx
  6d05fc:	mov    %r13,%r8
  6d05ff:	mov    %rbp,%r9
  6d0602:	call   6d30c0 <_RNvMNtNtCs6ZNK6sH19NW_4gpui7runtime4turnINtB4_10RuntimeMutNtCs4gijoeCAvqI_25inspector_pointer_control5ModeluE16activate_focusedBW_>
  6d0607:	jmp    6d047d <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x10d>
  6d060c:	mov    0x38(%rsp),%rcx
  6d0611:	movzbl 0x40(%rsp),%edx
  6d0616:	mov    0x44(%rsp),%esi
  6d061a:	mov    %esi,0x34(%r14)
  6d061e:	mov    0x41(%rsp),%esi
  6d0622:	mov    %esi,0x31(%r14)
  6d0626:	movups 0x18(%rsp),%xmm0
  6d062b:	movups 0x28(%rsp),%xmm1
  6d0630:	mov    %rax,(%r14)
  6d0633:	movups %xmm0,0x8(%r14)
  6d0638:	movups %xmm1,0x18(%r14)
  6d063d:	mov    %rcx,0x28(%r14)
  6d0641:	mov    %dl,0x30(%r14)
  6d0645:	jmp    6d047d <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x10d>
  6d064a:	lea    0x32a6d7(%rip),%rdx        # 9fad28 <__frame_dummy_init_array_entry+0x11f8>
  6d0651:	call   *0x348f19(%rip)        # a19570 <_DYNAMIC+0x270>

/tmp/gpui-inspector-pointer-codegen-optin/candidate-frozen:     file format elf64-x86-64


Disassembly of section .text:

00000000006d0660 <_RNvCs4gijoeCAvqI_25inspector_pointer_control3ack>:
  6d0660:	push   %r14
  6d0662:	push   %rbx
  6d0663:	sub    $0x78,%rsp
  6d0667:	test   %rdi,%rdi
  6d066a:	je     6d06a5 <_RNvCs4gijoeCAvqI_25inspector_pointer_control3ack+0x45>
  6d066c:	mov    %rdi,%rsi
  6d066f:	cmpb   $0x0,0x746(%rdi)
  6d0676:	jne    6d06ac <_RNvCs4gijoeCAvqI_25inspector_pointer_control3ack+0x4c>
  6d0678:	mov    0x6a8(%rsi),%rdx
  6d067f:	test   %rdx,%rdx
  6d0682:	je     6d06b3 <_RNvCs4gijoeCAvqI_25inspector_pointer_control3ack+0x53>
  6d0684:	mov    0x6b0(%rsi),%rcx
  6d068b:	lea    0x40(%rsp),%rdi
  6d0690:	call   6e72a0 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE11acknowledgeBO_>
  6d0695:	cmpq   $0xfffffffffffffffe,0x40(%rsp)
  6d069b:	jne    6d06ed <_RNvCs4gijoeCAvqI_25inspector_pointer_control3ack+0x8d>
  6d069d:	add    $0x78,%rsp
  6d06a1:	pop    %rbx
  6d06a2:	pop    %r14
  6d06a4:	ret
  6d06a5:	mov    $0xd,%eax
  6d06aa:	jmp    6d06b8 <_RNvCs4gijoeCAvqI_25inspector_pointer_control3ack+0x58>
  6d06ac:	mov    $0xe,%eax
  6d06b1:	jmp    6d06b8 <_RNvCs4gijoeCAvqI_25inspector_pointer_control3ack+0x58>
  6d06b3:	mov    $0x14,%eax
  6d06b8:	mov    %rax,(%rsp)
  6d06bc:	movq   $0x0,0x8(%rsp)
  6d06c5:	lea    -0x685f72(%rip),%rdi        # 4a75a <GCC_except_table0+0xd026>
  6d06cc:	lea    0x329f45(%rip),%rcx        # 9fa618 <__frame_dummy_init_array_entry+0xae8>
  6d06d3:	lea    0x329d5e(%rip),%r8        # 9fa438 <__frame_dummy_init_array_entry+0x908>
  6d06da:	mov    %rsp,%rbx
  6d06dd:	mov    $0x2b,%esi
  6d06e2:	mov    %rbx,%rdx
  6d06e5:	call   *0x348f05(%rip)        # a195f0 <_DYNAMIC+0x2f0>
  6d06eb:	jmp    6d073a <_RNvCs4gijoeCAvqI_25inspector_pointer_control3ack+0xda>
  6d06ed:	mov    0x70(%rsp),%rax
  6d06f2:	mov    %rax,0x30(%rsp)
  6d06f7:	movups 0x40(%rsp),%xmm0
  6d06fc:	movups 0x50(%rsp),%xmm1
  6d0701:	movups 0x60(%rsp),%xmm2
  6d0706:	movaps %xmm2,0x20(%rsp)
  6d070b:	movaps %xmm1,0x10(%rsp)
  6d0710:	movaps %xmm0,(%rsp)
  6d0714:	lea    -0x685fc1(%rip),%rdi        # 4a75a <GCC_except_table0+0xd026>
  6d071b:	lea    0x329ef6(%rip),%rcx        # 9fa618 <__frame_dummy_init_array_entry+0xae8>
  6d0722:	lea    0x329d27(%rip),%r8        # 9fa450 <__frame_dummy_init_array_entry+0x920>
  6d0729:	mov    %rsp,%rbx
  6d072c:	mov    $0x2b,%esi
  6d0731:	mov    %rbx,%rdx
  6d0734:	call   *0x348eb6(%rip)        # a195f0 <_DYNAMIC+0x2f0>
  6d073a:	ud2
  6d073c:	jmp    6d073e <_RNvCs4gijoeCAvqI_25inspector_pointer_control3ack+0xde>
  6d073e:	mov    %rax,%r14
  6d0741:	mov    %rbx,%rdi
  6d0744:	call   6be360 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueNtNtCs6ZNK6sH19NW_4gpui7runtime5ErrorECs4gijoeCAvqI_25inspector_pointer_control>
  6d0749:	mov    %r14,%rdi
  6d074c:	call   9f8780 <_Unwind_Resume@plt>

/tmp/gpui-inspector-pointer-codegen-optin/candidate-frozen:     file format elf64-x86-64


Disassembly of section .text:

00000000006d0760 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main>:
  6d0760:	push   %rbp
  6d0761:	push   %r15
  6d0763:	push   %r14
  6d0765:	push   %r13
  6d0767:	push   %r12
  6d0769:	push   %rbx
  6d076a:	sub    $0xcf8,%rsp
  6d0771:	call   *0x348dd1(%rip)        # a19548 <_DYNAMIC+0x248>
  6d0777:	mov    $0x6,%edi
  6d077c:	mov    $0x1,%esi
  6d0781:	call   *0x348dc9(%rip)        # a19550 <_DYNAMIC+0x250>
  6d0787:	test   %rax,%rax
  6d078a:	je     6d1e76 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1716>
  6d0790:	mov    %rax,%rbx
  6d0793:	movw   $0x6863,0x4(%rax)
  6d0799:	movl   $0x72616573,(%rax)
  6d079f:	lea    0x3c0(%rsp),%rdi
  6d07a7:	movabs $0x384000002d0,%r14
  6d07b1:	movss  -0x693049(%rip),%xmm0        # 3d770 <GCC_except_table0+0x3c>
  6d07b9:	mov    %r14,%rsi
  6d07bc:	call   *0x348fa6(%rip)        # a19768 <_DYNAMIC+0x468>
  6d07c2:	mov    0x3c0(%rsp),%r13
  6d07ca:	cmp    $0xfffffffffffffffe,%r13
  6d07ce:	jne    6d1e86 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1726>
  6d07d4:	movq   $0x0,0x3d8(%rsp)
  6d07e0:	movq   $0x8,0x3e0(%rsp)
  6d07ec:	xorps  %xmm0,%xmm0
  6d07ef:	movups %xmm0,0x3e8(%rsp)
  6d07f7:	movq   $0xffffffffffffffff,0x3c0(%rsp)
  6d0803:	movq   $0x8,0x3f8(%rsp)
  6d080f:	movups %xmm0,0x400(%rsp)
  6d0817:	movq   $0x8,0x410(%rsp)
  6d0823:	movq   $0x0,0x418(%rsp)
  6d082f:	movq   $0x1,0x420(%rsp)
  6d083b:	mov    $0x1,%edi
  6d0840:	call   *0x348f2a(%rip)        # a19770 <_DYNAMIC+0x470>
  6d0846:	mov    %rax,%r13
  6d0849:	cmp    $0x1,%r13d
  6d084d:	je     6d0863 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x103>
  6d084f:	movq   $0x0,0x3c0(%rsp)
  6d085b:	mov    %r13,0x3c8(%rsp)
  6d0863:	call   *0x348cdf(%rip)        # a19548 <_DYNAMIC+0x248>
  6d0869:	mov    $0x28,%edi
  6d086e:	mov    $0x8,%esi
  6d0873:	call   *0x348cd7(%rip)        # a19550 <_DYNAMIC+0x250>
  6d0879:	test   %rax,%rax
  6d087c:	je     6d1a84 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1324>
  6d0882:	mov    %rax,%r15
  6d0885:	lea    0x3d8(%rsp),%r12
  6d088d:	mov    %r13,(%rax)
  6d0890:	lea    -0x693063(%rip),%rax        # 3d834 <GCC_except_table0+0x100>
  6d0897:	mov    %rax,0x8(%r15)
  6d089b:	movq   $0x4,0x10(%r15)
  6d08a3:	lea    0x32de6(%rip),%rax        # 703690 <_RNvYNCNvXCs4gijoeCAvqI_25inspector_pointer_controlNtB7_5ModelNtCs6ZNK6sH19NW_4gpui4View7sources0INtNtNtCs4NRVxsYgnAr_4core3ops8function6FnOnceTRBM_EE9call_onceB7_>
  6d08aa:	mov    %rax,0x18(%r15)
  6d08ae:	lea    0x32deb(%rip),%rax        # 7036a0 <_RNvYNCNvXCs4gijoeCAvqI_25inspector_pointer_controlNtB7_5ModelNtCs6ZNK6sH19NW_4gpui4View7sourcess_0INtNtNtCs4NRVxsYgnAr_4core3ops8function6FnOnceTQBM_EE9call_onceB7_>
  6d08b5:	mov    %rax,0x20(%r15)
  6d08b9:	mov    %r12,%rdi
  6d08bc:	call   6dd850 <_RNvMs3_NtCscdodAO9FK5_5alloc7raw_vecINtB5_6RawVecAINtNtCs4NRVxsYgnAr_4core6option6OptionNtNtCs6ZNK6sH19NW_4gpui6source7FieldIdEj2_E8grow_oneCs4gijoeCAvqI_25inspector_pointer_control>
  6d08c1:	mov    0x3e0(%rsp),%rax
  6d08c9:	mov    %r15,(%rax)
  6d08cc:	lea    0x329465(%rip),%rcx        # 9f9d38 <__frame_dummy_init_array_entry+0x208>
  6d08d3:	mov    %rcx,0x8(%rax)
  6d08d7:	movq   $0x1,0x3e8(%rsp)
  6d08e3:	mov    0x3c0(%rsp),%rax
  6d08eb:	movups 0x40(%r12),%xmm0
  6d08f1:	movaps %xmm0,0x160(%rsp)
  6d08f9:	movups (%r12),%xmm0
  6d08fe:	movups 0x10(%r12),%xmm1
  6d0904:	movups 0x20(%r12),%xmm2
  6d090a:	movups 0x30(%r12),%xmm3
  6d0910:	movaps %xmm3,0x150(%rsp)
  6d0918:	movaps %xmm2,0x140(%rsp)
  6d0920:	movaps %xmm1,0x130(%rsp)
  6d0928:	movups 0x3c8(%rsp),%xmm2
  6d0930:	movups %xmm0,0xb8(%rsp)
  6d0938:	movups %xmm1,0xc8(%rsp)
  6d0940:	mov    0x140(%rsp),%rcx
  6d0948:	mov    %rcx,0xd8(%rsp)
  6d0950:	movups 0x148(%rsp),%xmm0
  6d0958:	movups %xmm0,0xe0(%rsp)
  6d0960:	movups 0x158(%rsp),%xmm0
  6d0968:	movups %xmm0,0xf0(%rsp)
  6d0970:	mov    0x168(%rsp),%rcx
  6d0978:	mov    %rcx,0x100(%rsp)
  6d0980:	mov    %rax,0xa0(%rsp)
  6d0988:	movups %xmm2,0xa8(%rsp)
  6d0990:	movl   $0x0,0x120(%rsp)
  6d099b:	movl   $0x434b0000,0x128(%rsp)
  6d09a6:	movw   $0x0,0x12c(%rsp)
  6d09b0:	lea    0x3c0(%rsp),%rdi
  6d09b8:	lea    0x120(%rsp),%rcx
  6d09c0:	mov    $0x2d0,%esi
  6d09c5:	mov    $0x384,%edx
  6d09ca:	call   *0x348da8(%rip)        # a19778 <_DYNAMIC+0x478>
  6d09d0:	mov    0x3c0(%rsp),%r13
  6d09d8:	mov    0x3c8(%rsp),%r15d
  6d09e0:	mov    0x3cc(%rsp),%r12d
  6d09e8:	cmp    $0x2,%r13
  6d09ec:	je     6d1ecf <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x176f>
  6d09f2:	lea    0x3d0(%rsp),%rsi
  6d09fa:	lea    0xb20(%rsp),%rdi
  6d0a02:	mov    $0x1d8,%edx
  6d0a07:	call   *0x348b53(%rip)        # a19560 <memcpy@GLIBC_2.14>
  6d0a0d:	mov    %r13,0xb10(%rsp)
  6d0a15:	mov    %r15d,0xb18(%rsp)
  6d0a1d:	mov    %r12d,0xb1c(%rsp)
  6d0a25:	call   *0x348d55(%rip)        # a19780 <_DYNAMIC+0x480>
  6d0a2b:	mov    %rax,%r15
  6d0a2e:	lea    0x120(%rsp),%rdi
  6d0a36:	call   *0x348d4c(%rip)        # a19788 <_DYNAMIC+0x488>
  6d0a3c:	movq   $0x6,0x660(%rsp)
  6d0a48:	movl   $0x0,0x668(%rsp)
  6d0a53:	movq   $0x0,0x670(%rsp)
  6d0a5f:	movups 0xa0(%rsp),%xmm0
  6d0a67:	movups 0xb0(%rsp),%xmm1
  6d0a6f:	movups 0xc0(%rsp),%xmm2
  6d0a77:	movups 0xd0(%rsp),%xmm3
  6d0a7f:	movups %xmm0,0x5e8(%rsp)
  6d0a87:	movups %xmm1,0x5f8(%rsp)
  6d0a8f:	movups %xmm2,0x608(%rsp)
  6d0a97:	movups %xmm3,0x618(%rsp)
  6d0a9f:	movups 0xe0(%rsp),%xmm0
  6d0aa7:	movups %xmm0,0x628(%rsp)
  6d0aaf:	movups 0xf0(%rsp),%xmm0
  6d0ab7:	movups %xmm0,0x638(%rsp)
  6d0abf:	mov    0x100(%rsp),%rax
  6d0ac7:	mov    %rax,0x648(%rsp)
  6d0acf:	lea    0x6a8(%rsp),%rdi
  6d0ad7:	lea    0x120(%rsp),%rsi
  6d0adf:	mov    0x348a7a(%rip),%r12        # a19560 <memcpy@GLIBC_2.14>
  6d0ae6:	mov    $0x298,%edx
  6d0aeb:	call   *%r12
  6d0aee:	lea    0x3c0(%rsp),%rdi
  6d0af6:	lea    0xb10(%rsp),%rsi
  6d0afe:	mov    $0x1e8,%edx
  6d0b03:	call   *%r12
  6d0b06:	movq   $0x6,0x650(%rsp)
  6d0b12:	mov    %rbx,0x658(%rsp)
  6d0b1a:	movq   $0x0,0x678(%rsp)
  6d0b26:	movq   $0x8,0x680(%rsp)
  6d0b32:	xorps  %xmm0,%xmm0
  6d0b35:	movups %xmm0,0x688(%rsp)
  6d0b3d:	movq   $0x8,0x698(%rsp)
  6d0b49:	movq   $0x0,0x6a0(%rsp)
  6d0b55:	movq   $0x0,0x9c0(%rsp)
  6d0b61:	movups %xmm0,0x5a8(%rsp)
  6d0b69:	movups %xmm0,0x5b8(%rsp)
  6d0b71:	movups %xmm0,0x9a8(%rsp)
  6d0b79:	movq   $0x1,0x9c8(%rsp)
  6d0b85:	movq   $0x0,0x9d0(%rsp)
  6d0b91:	mov    %r15,0x998(%rsp)
  6d0b99:	movq   $0x0,0x9e0(%rsp)
  6d0ba5:	movq   $0x0,0xa28(%rsp)
  6d0bb1:	movups %xmm0,0x9f0(%rsp)
  6d0bb9:	movq   $0x0,0xa00(%rsp)
  6d0bc5:	movups %xmm0,0xa10(%rsp)
  6d0bcd:	movq   $0x0,0x940(%rsp)
  6d0bd9:	movq   $0x8,0x948(%rsp)
  6d0be5:	movups %xmm0,0x950(%rsp)
  6d0bed:	movq   $0x0,0xa30(%rsp)
  6d0bf9:	movq   $0x0,0xa40(%rsp)
  6d0c05:	movl   $0x1000101,0xb00(%rsp)
  6d0c10:	movw   $0x0,0xb04(%rsp)
  6d0c1a:	movups %xmm0,0xa48(%rsp)
  6d0c22:	movq   $0x0,0xa58(%rsp)
  6d0c2e:	mov    %r14,0xa60(%rsp)
  6d0c36:	movsd  -0x69296e(%rip),%xmm1        # 3e2d0 <GCC_except_table0+0xb9c>
  6d0c3e:	movsd  %xmm1,0xaf8(%rsp)
  6d0c47:	movq   $0x1,0x9a0(%rsp)
  6d0c53:	movq   $0xffffffffffffffff,0x970(%rsp)
  6d0c5f:	movq   $0x0,0xa68(%rsp)
  6d0c6b:	movq   $0x0,0xa78(%rsp)
  6d0c77:	movq   $0x8,0x960(%rsp)
  6d0c83:	movq   $0x0,0x968(%rsp)
  6d0c8f:	movb   $0x0,0xb06(%rsp)
  6d0c97:	movups %xmm0,0xae0(%rsp)
  6d0c9f:	movups %xmm0,0xad0(%rsp)
  6d0ca7:	movups %xmm0,0xac0(%rsp)
  6d0caf:	movups %xmm0,0xab0(%rsp)
  6d0cb7:	movups %xmm0,0xaa0(%rsp)
  6d0cbf:	movups %xmm0,0xa90(%rsp)
  6d0cc7:	movups %xmm0,0xa80(%rsp)
  6d0ccf:	movq   $0x0,0xaf0(%rsp)
  6d0cdb:	call   *0x348867(%rip)        # a19548 <_DYNAMIC+0x248>
  6d0ce1:	mov    $0x748,%edi
  6d0ce6:	mov    $0x8,%esi
  6d0ceb:	call   *0x34885f(%rip)        # a19550 <_DYNAMIC+0x250>
  6d0cf1:	test   %rax,%rax
  6d0cf4:	je     6d1a99 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1339>
  6d0cfa:	mov    %rax,%rbx
  6d0cfd:	lea    0x3c0(%rsp),%rsi
  6d0d05:	mov    $0x748,%edx
  6d0d0a:	mov    %rax,%rdi
  6d0d0d:	call   *0x34884d(%rip)        # a19560 <memcpy@GLIBC_2.14>
  6d0d13:	mov    %rbx,0x8(%rsp)
  6d0d18:	lea    0x10(%rsp),%rdx
  6d0d1d:	movq   $0x0,(%rsp)
  6d0d25:	lea    0x68(%rsp),%rdi
  6d0d2a:	mov    $0x8,%r8d
  6d0d30:	mov    %rbx,%rsi
  6d0d33:	mov    $0x1,%ecx
  6d0d38:	xor    %r9d,%r9d
  6d0d3b:	call   6d6580 <_RNvMNtNtCs6ZNK6sH19NW_4gpui7runtime4turnINtB4_10RuntimeMutNtCs4gijoeCAvqI_25inspector_pointer_control5ModeluE21describe_with_changedBW_>
  6d0d40:	mov    0x68(%rsp),%r13
  6d0d45:	cmp    $0xfffffffffffffffe,%r13
  6d0d49:	jne    6d1df3 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1693>
  6d0d4f:	lea    0x68(%rsp),%rdi
  6d0d54:	mov    %rbx,%rsi
  6d0d57:	call   6f8c80 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE7presentBO_>
  6d0d5c:	mov    0x68(%rsp),%r13
  6d0d61:	cmp    $0xfffffffffffffffe,%r13
  6d0d65:	jne    6d1df3 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1693>
  6d0d6b:	mov    0x8(%rsp),%rdi
  6d0d70:	mov    %rdi,0x8(%rsp)
  6d0d75:	call   6d0660 <_RNvCs4gijoeCAvqI_25inspector_pointer_control3ack>
  6d0d7a:	mov    0x8(%rsp),%rbx
  6d0d7f:	test   %rbx,%rbx
  6d0d82:	je     6d1f04 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x17a4>
  6d0d88:	cmpb   $0x0,0x746(%rbx)
  6d0d8f:	jne    6d1f0b <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x17ab>
  6d0d95:	cmpb   $0x1,0x742(%rbx)
  6d0d9c:	jne    6d1f12 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x17b2>
  6d0da2:	mov    0x5a8(%rbx),%r13
  6d0da9:	mov    $0x1a,%eax
  6d0dae:	mov    %rax,0x10(%rsp)
  6d0db3:	test   %r13,%r13
  6d0db6:	je     6d1f1c <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x17bc>
  6d0dbc:	mov    0x5a0(%rbx),%rbp
  6d0dc3:	shl    $0x6,%r13
  6d0dc7:	lea    0x1e8(%rbx),%r14
  6d0dce:	xor    %r12d,%r12d
  6d0dd1:	mov    0x3487f8(%rip),%r15        # a195d0 <_DYNAMIC+0x2d0>
  6d0dd8:	jmp    6d0ded <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x68d>
  6d0dda:	nopw   0x0(%rax,%rax,1)
  6d0de0:	add    $0x40,%r12
  6d0de4:	cmp    %r12,%r13
  6d0de7:	je     6d1f1c <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x17bc>
  6d0ded:	cmpb   $0x4,0x3d(%rbp,%r12,1)
  6d0df3:	jne    6d0de0 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x680>
  6d0df5:	mov    0x20(%rbp,%r12,1),%rsi
  6d0dfa:	mov    %r14,%rdi
  6d0dfd:	call   *%r15
  6d0e00:	test   %al,%al
  6d0e02:	je     6d0de0 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x680>
  6d0e04:	mov    0x20(%rbp,%r12,1),%rsi
  6d0e09:	add    $0x5d8,%rbx
  6d0e10:	mov    %rbx,%rdi
  6d0e13:	call   *0x348947(%rip)        # a19760 <_DYNAMIC+0x460>
  6d0e19:	mov    %rax,%r14
  6d0e1c:	lea    0x10(%rsp),%rax
  6d0e21:	mov    0x8(%rsp),%r15
  6d0e26:	test   %r15,%r15
  6d0e29:	je     6d1f62 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1802>
  6d0e2f:	mov    %r15,0xa0(%rsp)
  6d0e37:	mov    %rax,0xa8(%rsp)
  6d0e3f:	cmpb   $0x1,0x746(%r15)
  6d0e47:	je     6d1f7f <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x181f>
  6d0e4d:	cmp    0x5d8(%r15),%r14
  6d0e54:	jne    6d1f90 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1830>
  6d0e5a:	mov    %rdx,%rbx
  6d0e5d:	lea    0x3c0(%rsp),%rdi
  6d0e65:	mov    %r15,%rsi
  6d0e68:	call   6f8520 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE16resolve_identityBO_>
  6d0e6d:	mov    0x3c0(%rsp),%rax
  6d0e75:	cmp    $0xfffffffffffffffe,%rax
  6d0e79:	jne    6d1f97 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1837>
  6d0e7f:	cmpb   $0x1,0x742(%r15)
  6d0e87:	jne    6d1dd1 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1671>
  6d0e8d:	cmpb   $0x0,0x743(%r15)
  6d0e95:	jne    6d1dd1 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1671>
  6d0e9b:	cmpb   $0x0,0x744(%r15)
  6d0ea3:	je     6d1dd1 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1671>
  6d0ea9:	cmpq   $0xffffffffffffffff,0x5b0(%r15)
  6d0eb1:	jne    6d1dd1 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1671>
  6d0eb7:	mov    0x688(%r15),%rax
  6d0ebe:	cmp    0x690(%r15),%rax
  6d0ec5:	jne    6d1dd1 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1671>
  6d0ecb:	mov    0x6a0(%r15),%rax
  6d0ed2:	cmp    0x698(%r15),%rax
  6d0ed9:	jne    6d1dd1 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1671>
  6d0edf:	movss  0x738(%r15),%xmm0
  6d0ee8:	ucomiss 0x73c(%r15),%xmm0
  6d0ef0:	jne    6d1dd1 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1671>
  6d0ef6:	jp     6d1dd1 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1671>
  6d0efc:	mov    0x5a0(%r15),%r12
  6d0f03:	mov    0x5a8(%r15),%rax
  6d0f0a:	lea    -0x38(%r12),%rcx
  6d0f0f:	shl    $0x6,%rax
  6d0f13:	neg    %rax
  6d0f16:	xor    %ebp,%ebp
  6d0f18:	nopl   0x0(%rax,%rax,1)
  6d0f20:	cmp    %rbp,%rax
  6d0f23:	je     6d1d48 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x15e8>
  6d0f29:	add    $0xffffffffffffffc0,%rbp
  6d0f2d:	lea    0x40(%rcx),%r13
  6d0f31:	cmp    %rbx,0x58(%rcx)
  6d0f35:	mov    %r13,%rcx
  6d0f38:	jne    6d0f20 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x7c0>
  6d0f3a:	mov    0x638(%r15),%rax
  6d0f41:	test   %rax,%rax
  6d0f44:	je     6d0f62 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x802>
  6d0f46:	mov    0x100(%rax),%rsi
  6d0f4d:	test   %rsi,%rsi
  6d0f50:	je     6d0f62 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x802>
  6d0f52:	lea    0x120(%rsp),%rdi
  6d0f5a:	call   *0x348830(%rip)        # a19790 <_DYNAMIC+0x490>
  6d0f60:	jmp    6d0f79 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x819>
  6d0f62:	movq   $0x4,0x120(%rsp)
  6d0f6e:	xorps  %xmm0,%xmm0
  6d0f71:	movups %xmm0,0x128(%rsp)
  6d0f79:	lea    0x120(%rsp),%rdi
  6d0f81:	call   *0x348811(%rip)        # a19798 <_DYNAMIC+0x498>
  6d0f87:	mov    %rdx,%rcx
  6d0f8a:	sub    %rbp,%r12
  6d0f8d:	lea    -0x40(%r12),%rsi
  6d0f92:	lea    0x3c0(%rsp),%rdi
  6d0f9a:	mov    %rax,%rdx
  6d0f9d:	call   *0x3487fd(%rip)        # a197a0 <_DYNAMIC+0x4a0>
  6d0fa3:	cmpb   $0x0,0x3c0(%rsp)
  6d0fab:	je     6d0ff5 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x895>
  6d0fad:	lea    0x3c4(%rsp),%rsi
  6d0fb5:	movss  0x0(%r13),%xmm0
  6d0fbb:	movss  0x4(%r13),%xmm1
  6d0fc1:	lea    0x68(%rsp),%rdi
  6d0fc6:	call   6ce7f0 <_RNCNvMss_NtCs6ZNK6sH19NW_4gpui7runtimeINtB7_3WinNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE5clicks_0BM_>
  6d0fcb:	cmpl   $0x1,0x68(%rsp)
  6d0fd0:	jne    6d0ff5 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x895>
  6d0fd2:	movsd  0x6c(%rsp),%xmm0
  6d0fd8:	movaps %xmm0,%xmm1
  6d0fdb:	shufps $0x55,%xmm0,%xmm1
  6d0fdf:	add    $0xffffffffffffffd0,%r12
  6d0fe3:	mov    %r12,%rdi
  6d0fe6:	movaps %xmm0,0x10(%rsp)
  6d0feb:	call   *0x3487b7(%rip)        # a197a8 <_DYNAMIC+0x4a8>
  6d0ff1:	test   %al,%al
  6d0ff3:	jne    6d1032 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x8d2>
  6d0ff5:	movss  0x10(%r13),%xmm0
  6d0ffb:	xorps  %xmm2,%xmm2
  6d0ffe:	ucomiss %xmm2,%xmm0
  6d1001:	jne    6d1009 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x8a9>
  6d1003:	jnp    6d1de2 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1682>
  6d1009:	movss  0x14(%r13),%xmm1
  6d100f:	ucomiss %xmm2,%xmm1
  6d1012:	jne    6d101a <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x8ba>
  6d1014:	jnp    6d1de2 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1682>
  6d101a:	unpcklps %xmm1,%xmm0
  6d101d:	mulps  -0x692404(%rip),%xmm0        # 3ec20 <GCC_except_table0+0x14ec>
  6d1024:	movsd  0x8(%r13),%xmm1
  6d102a:	addps  %xmm0,%xmm1
  6d102d:	movaps %xmm1,0x10(%rsp)
  6d1032:	movq   $0x19,0x3c0(%rsp)
  6d103e:	lea    0x3c0(%rsp),%rdi
  6d1046:	call   6be360 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueNtNtCs6ZNK6sH19NW_4gpui7runtime5ErrorECs4gijoeCAvqI_25inspector_pointer_control>
  6d104b:	movaps 0x10(%rsp),%xmm0
  6d1050:	movaps %xmm0,%xmm1
  6d1053:	shufps $0x55,%xmm0,%xmm1
  6d1057:	mov    %r15,%rdi
  6d105a:	movaps %xmm1,0x30(%rsp)
  6d105f:	call   6f8800 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_>
  6d1064:	movq   $0x19,0x3c0(%rsp)
  6d1070:	test   $0x1,%al
  6d1072:	je     6d1de2 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1682>
  6d1078:	mov    %rdx,%r12
  6d107b:	lea    0x3c0(%rsp),%rdi
  6d1083:	call   6be360 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueNtNtCs6ZNK6sH19NW_4gpui7runtime5ErrorECs4gijoeCAvqI_25inspector_pointer_control>
  6d1088:	cmp    %rbx,%r12
  6d108b:	jne    6d1de2 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1682>
  6d1091:	cmp    0x5d8(%r15),%r14
  6d1098:	jne    6d2014 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x18b4>
  6d109e:	lea    0x3c0(%rsp),%rdi
  6d10a6:	mov    %r15,%rsi
  6d10a9:	mov    %rbx,%rdx
  6d10ac:	call   6f8520 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE16resolve_identityBO_>
  6d10b1:	mov    0x3c0(%rsp),%rax
  6d10b9:	mov    0x3c8(%rsp),%r12
  6d10c1:	cmp    $0xfffffffffffffffe,%rax
  6d10c5:	jne    6d2019 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x18b9>
  6d10cb:	mov    0x2c8(%r15),%rsi
  6d10d2:	cmp    %rsi,%r12
  6d10d5:	jae    6d205e <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x18fe>
  6d10db:	mov    0x2c0(%r15),%rax
  6d10e2:	lea    (%r12,%r12,4),%rcx
  6d10e6:	mov    0x20(%rax,%rcx,8),%edi
  6d10ea:	call   6e1fb0 <_RNvMsh_NtCs6ZNK6sH19NW_4gpui7runtimeNtB5_4Node4kind>
  6d10ef:	cmp    $0x4,%al
  6d10f1:	jne    6d1118 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x9b8>
  6d10f3:	lea    0x120(%rsp),%rdi
  6d10fb:	mov    %r15,%rsi
  6d10fe:	mov    %r14,%rdx
  6d1101:	mov    %rbx,%rcx
  6d1104:	movaps 0x10(%rsp),%xmm0
  6d1109:	movaps 0x30(%rsp),%xmm1
  6d110e:	xor    %r8d,%r8d
  6d1111:	call   6db800 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime7editingINtB7_10RuntimeMutNtCs4gijoeCAvqI_25inspector_pointer_control5ModeluE14select_pointerB12_>
  6d1116:	jmp    6d116b <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0xa0b>
  6d1118:	mov    0x610(%r15),%r12
  6d111f:	mov    0x618(%r15),%r13
  6d1126:	lea    0x3c0(%rsp),%rdi
  6d112e:	mov    %r15,%rsi
  6d1131:	mov    %r14,%rdx
  6d1134:	mov    %rbx,%rcx
  6d1137:	call   6db480 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE5focusBW_>
  6d113c:	mov    0x3c0(%rsp),%rax
  6d1144:	cmp    $0xfffffffffffffffe,%rax
  6d1148:	jne    6d117b <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0xa1b>
  6d114a:	lea    0x120(%rsp),%rdi
  6d1152:	lea    0xa0(%rsp),%rsi
  6d115a:	mov    %r14,%rdx
  6d115d:	mov    %rbx,%rcx
  6d1160:	mov    %r12,%r8
  6d1163:	mov    %r13,%r9
  6d1166:	call   6d30c0 <_RNvMNtNtCs6ZNK6sH19NW_4gpui7runtime4turnINtB4_10RuntimeMutNtCs4gijoeCAvqI_25inspector_pointer_control5ModeluE16activate_focusedBW_>
  6d116b:	cmpq   $0xfffffffffffffffe,0x120(%rsp)
  6d1174:	je     6d11ed <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0xa8d>
  6d1176:	jmp    6d1d54 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x15f4>
  6d117b:	mov    0x3e8(%rsp),%rcx
  6d1183:	movzbl 0x3f0(%rsp),%edx
  6d118b:	mov    0x3f1(%rsp),%esi
  6d1192:	mov    %esi,0x151(%rsp)
  6d1199:	mov    0x3f4(%rsp),%esi
  6d11a0:	mov    %esi,0x154(%rsp)
  6d11a7:	movups 0x3c8(%rsp),%xmm0
  6d11af:	movups 0x3d8(%rsp),%xmm1
  6d11b7:	mov    %rax,0x120(%rsp)
  6d11bf:	movups %xmm0,0x128(%rsp)
  6d11c7:	movups %xmm1,0x138(%rsp)
  6d11cf:	mov    %rcx,0x148(%rsp)
  6d11d7:	mov    %dl,0x150(%rsp)
  6d11de:	cmpq   $0xfffffffffffffffe,0x120(%rsp)
  6d11e7:	jne    6d1d54 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x15f4>
  6d11ed:	mov    0x8(%rsp),%rdi
  6d11f2:	call   6d0660 <_RNvCs4gijoeCAvqI_25inspector_pointer_control3ack>
  6d11f7:	movsd  -0x692e2f(%rip),%xmm0        # 3e3d0 <GCC_except_table0+0xc9c>
  6d11ff:	movsd  %xmm0,0x3c0(%rsp)
  6d1208:	lea    0x3c0(%rsp),%rax
  6d1210:	mov    0x8(%rsp),%rbp
  6d1215:	test   %rbp,%rbp
  6d1218:	je     6d206f <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x190f>
  6d121e:	cmpb   $0x0,0x746(%rbp)
  6d1225:	jne    6d2076 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1916>
  6d122b:	mov    $0x12,%eax
  6d1230:	cmpb   $0x1,0x742(%rbp)
  6d1237:	jne    6d207b <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x191b>
  6d123d:	cmpb   $0x0,0x743(%rbp)
  6d1244:	jne    6d207b <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x191b>
  6d124a:	cmpb   $0x0,0x744(%rbp)
  6d1251:	je     6d207b <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x191b>
  6d1257:	cmpq   $0xffffffffffffffff,0x5b0(%rbp)
  6d125f:	jne    6d207b <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x191b>
  6d1265:	mov    0x688(%rbp),%rcx
  6d126c:	cmp    0x690(%rbp),%rcx
  6d1273:	jne    6d207b <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x191b>
  6d1279:	mov    0x6a0(%rbp),%rbx
  6d1280:	cmp    0x698(%rbp),%rbx
  6d1287:	jne    6d207b <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x191b>
  6d128d:	movss  0x738(%rbp),%xmm0
  6d1295:	ucomiss 0x73c(%rbp),%xmm0
  6d129c:	jne    6d207b <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x191b>
  6d12a2:	jp     6d207b <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x191b>
  6d12a8:	movsd  0x3c0(%rsp),%xmm0
  6d12b1:	movaps %xmm0,0x40(%rsp)
  6d12b6:	mov    0x6c0(%rbp),%rax
  6d12bd:	mov    %rax,0x50(%rsp)
  6d12c2:	mov    0x5a0(%rbp),%rax
  6d12c9:	mov    %rax,0x10(%rsp)
  6d12ce:	mov    0x5a8(%rbp),%r12
  6d12d5:	movups 0x610(%rbp),%xmm0
  6d12dc:	movaps %xmm0,0x30(%rsp)
  6d12e1:	mov    0x638(%rbp),%r13
  6d12e8:	test   %r13,%r13
  6d12eb:	je     6d1339 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0xbd9>
  6d12ed:	mov    0xe0(%r13),%rax
  6d12f4:	test   %rax,%rax
  6d12f7:	je     6d1358 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0xbf8>
  6d12f9:	mov    0x38(%rax),%ecx
  6d12fc:	mov    %ecx,0xb20(%rsp)
  6d1303:	movups 0x28(%rax),%xmm0
  6d1307:	movaps %xmm0,0xb10(%rsp)
  6d130f:	movzbl 0x3c(%rax),%r15d
  6d1314:	movzbl 0x3f(%rax),%ecx
  6d1318:	mov    %cl,0xa2(%rsp)
  6d131f:	movzwl 0x3d(%rax),%eax
  6d1323:	mov    %ax,0xa0(%rsp)
  6d132b:	mov    0x100(%r13),%rsi
  6d1332:	test   %rsi,%rsi
  6d1335:	jne    6d1367 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0xc07>
  6d1337:	jmp    6d133c <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0xbdc>
  6d1339:	mov    $0x2,%r15b
  6d133c:	movq   $0x4,0x120(%rsp)
  6d1348:	xorps  %xmm0,%xmm0
  6d134b:	movups %xmm0,0x128(%rsp)
  6d1353:	mov    %r12,%r14
  6d1356:	jmp    6d137c <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0xc1c>
  6d1358:	mov    $0x2,%r15b
  6d135b:	mov    0x100(%r13),%rsi
  6d1362:	test   %rsi,%rsi
  6d1365:	je     6d133c <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0xbdc>
  6d1367:	lea    0x120(%rsp),%rdi
  6d136f:	call   *0x34841b(%rip)        # a19790 <_DYNAMIC+0x490>
  6d1375:	mov    0x5a8(%rbp),%r14
  6d137c:	lea    0x5d8(%rbp),%rax
  6d1383:	mov    %rax,0x108(%rsp)
  6d138b:	mov    %rax,0x410(%rsp)
  6d1393:	mov    0x50(%rsp),%rax
  6d1398:	mov    %rax,0x3e0(%rsp)
  6d13a0:	mov    %rbx,0x3e8(%rsp)
  6d13a8:	mov    0x10(%rsp),%rax
  6d13ad:	mov    %rax,0x3d0(%rsp)
  6d13b5:	mov    %r12,0x3d8(%rsp)
  6d13bd:	movaps 0x30(%rsp),%xmm0
  6d13c2:	movaps %xmm0,0x3c0(%rsp)
  6d13ca:	mov    %r13,0x3f0(%rsp)
  6d13d2:	mov    0x120(%rsp),%rax
  6d13da:	mov    %rax,0x3f8(%rsp)
  6d13e2:	mov    0x128(%rsp),%rax
  6d13ea:	mov    %rax,0x400(%rsp)
  6d13f2:	mov    0x130(%rsp),%rax
  6d13fa:	mov    %rax,0x408(%rsp)
  6d1402:	movaps 0xb10(%rsp),%xmm0
  6d140a:	movups %xmm0,0x418(%rsp)
  6d1412:	mov    0xb20(%rsp),%eax
  6d1419:	mov    %eax,0x428(%rsp)
  6d1420:	mov    %r15b,0x42c(%rsp)
  6d1428:	movzwl 0xa0(%rsp),%eax
  6d1430:	mov    %ax,0x42d(%rsp)
  6d1438:	movzbl 0xa2(%rsp),%eax
  6d1440:	mov    %al,0x42f(%rsp)
  6d1447:	test   %r14,%r14
  6d144a:	je     6d1e6c <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x170c>
  6d1450:	movaps 0x40(%rsp),%xmm0
  6d1455:	shufps $0x55,%xmm0,%xmm0
  6d1459:	movaps %xmm0,0x50(%rsp)
  6d145e:	mov    $0x20,%r13d
  6d1464:	xor    %r12d,%r12d
  6d1467:	lea    0x3c0(%rsp),%r15
  6d146f:	mov    0x34833a(%rip),%rbx        # a197b0 <_DYNAMIC+0x4b0>
  6d1476:	lea    0x32928b(%rip),%rax        # 9fa708 <__frame_dummy_init_array_entry+0xbd8>
  6d147d:	mov    %rax,0x60(%rsp)
  6d1482:	movq   $0x0,0x30(%rsp)
  6d148b:	movq   $0x0,0x10(%rsp)
  6d1494:	jmp    6d14bc <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0xd5c>
  6d1496:	mov    0x5a0(%rbp),%rax
  6d149d:	incq   0x10(%rsp)
  6d14a2:	mov    (%rax,%r13,1),%rax
  6d14a6:	mov    %rax,0x30(%rsp)
  6d14ab:	nopl   0x0(%rax,%rax,1)
  6d14b0:	inc    %r12
  6d14b3:	add    $0x40,%r13
  6d14b7:	cmp    %r12,%r14
  6d14ba:	je     6d150b <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0xdab>
  6d14bc:	mov    %r15,%rdi
  6d14bf:	mov    %r12,%rsi
  6d14c2:	call   *%rbx
  6d14c4:	test   %rax,%rax
  6d14c7:	setne  %cl
  6d14ca:	cmp    $0x5,%rdx
  6d14ce:	sete   %dl
  6d14d1:	and    %cl,%dl
  6d14d3:	cmp    $0x1,%dl
  6d14d6:	jne    6d14b0 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0xd50>
  6d14d8:	mov    (%rax),%ecx
  6d14da:	mov    $0x63656863,%edx
  6d14df:	xor    %edx,%ecx
  6d14e1:	movzbl 0x4(%rax),%eax
  6d14e5:	xor    $0x6b,%eax
  6d14e8:	or     %ecx,%eax
  6d14ea:	jne    6d14b0 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0xd50>
  6d14ec:	mov    0x5a8(%rbp),%rsi
  6d14f3:	cmp    %rsi,%r12
  6d14f6:	jb     6d1496 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0xd36>
  6d14f8:	mov    %r12,%rdi
  6d14fb:	mov    0x60(%rsp),%rdx
  6d1500:	call   *0x34806a(%rip)        # a19570 <_DYNAMIC+0x270>
  6d1506:	jmp    6d2270 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b10>
  6d150b:	mov    0x10(%rsp),%rcx
  6d1510:	cmp    $0x1,%rcx
  6d1514:	jne    6d1e5e <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x16fe>
  6d151a:	mov    0x108(%rsp),%rdi
  6d1522:	mov    0x30(%rsp),%rsi
  6d1527:	call   *0x348233(%rip)        # a19760 <_DYNAMIC+0x460>
  6d152d:	mov    %rax,%r14
  6d1530:	mov    %rdx,%rbx
  6d1533:	lea    0x8(%rsp),%rax
  6d1538:	mov    %rax,0x3c0(%rsp)
  6d1540:	lea    0x3c0(%rsp),%r12
  6d1548:	mov    0x3c0(%rsp),%rax
  6d1550:	mov    (%rax),%rsi
  6d1553:	lea    0x120(%rsp),%rdi
  6d155b:	movaps 0x40(%rsp),%xmm0
  6d1560:	movaps 0x50(%rsp),%xmm1
  6d1565:	call   6d2ff0 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8hit_only>
  6d156a:	cmpl   $0xfffffffe,0x120(%rsp)
  6d1572:	jne    6d1aae <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x134e>
  6d1578:	mov    0x128(%rsp),%rdx
  6d1580:	mov    0x130(%rsp),%rax
  6d1588:	mov    %rdx,0x3c0(%rsp)
  6d1590:	mov    %rax,0x3c8(%rsp)
  6d1598:	mov    %r14,0x110(%rsp)
  6d15a0:	mov    %rbx,0x118(%rsp)
  6d15a8:	cmp    %r14,%rdx
  6d15ab:	sete   %cl
  6d15ae:	test   %rdx,%rdx
  6d15b1:	je     6d1a24 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x12c4>
  6d15b7:	lea    0x328f22(%rip),%rdx        # 9fa4e0 <__frame_dummy_init_array_entry+0x9b0>
  6d15be:	lea    0x110(%rsp),%r15
  6d15c6:	test   %cl,%cl
  6d15c8:	je     6d1b96 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1436>
  6d15ce:	cmp    %rbx,%rax
  6d15d1:	jne    6d1b96 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1436>
  6d15d7:	movsd  -0x692c1f(%rip),%xmm0        # 3e9c0 <GCC_except_table0+0x128c>
  6d15df:	movsd  %xmm0,0x3c0(%rsp)
  6d15e8:	lea    0x3c0(%rsp),%r12
  6d15f0:	movss  0x3c0(%rsp),%xmm0
  6d15f9:	movss  0x3c4(%rsp),%xmm1
  6d1602:	mov    0x8(%rsp),%rsi
  6d1607:	lea    0x120(%rsp),%rdi
  6d160f:	call   6d2ff0 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8hit_only>
  6d1614:	cmpl   $0xfffffffe,0x120(%rsp)
  6d161c:	jne    6d1b1b <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x13bb>
  6d1622:	movups 0x128(%rsp),%xmm0
  6d162a:	movaps %xmm0,0x3c0(%rsp)
  6d1632:	cmpq   $0x0,0x128(%rsp)
  6d163b:	jne    6d1b88 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1428>
  6d1641:	mov    $0xffffffff,%eax
  6d1646:	mov    %rax,0xb10(%rsp)
  6d164e:	movq   $0x0,0xb18(%rsp)
  6d165a:	movaps 0x40(%rsp),%xmm0
  6d165f:	movlps %xmm0,0x3c4(%rsp)
  6d1667:	movl   $0x0,0x3c0(%rsp)
  6d1672:	lea    0x3c0(%rsp),%rcx
  6d167a:	lea    0x120(%rsp),%rdi
  6d1682:	lea    0x8(%rsp),%rsi
  6d1687:	lea    0xb10(%rsp),%rdx
  6d168f:	call   6d2330 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch>
  6d1694:	cmpl   $0xfffffffe,0x120(%rsp)
  6d169c:	jne    6d19b7 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1257>
  6d16a2:	movl   $0x2,0x3c0(%rsp)
  6d16ad:	lea    0x3c0(%rsp),%rcx
  6d16b5:	lea    0x120(%rsp),%rdi
  6d16bd:	lea    0x8(%rsp),%rsi
  6d16c2:	lea    0xb10(%rsp),%rdx
  6d16ca:	call   6d2330 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch>
  6d16cf:	cmpl   $0xfffffffe,0x120(%rsp)
  6d16d7:	jne    6d19b7 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1257>
  6d16dd:	movl   $0x3,0x3c0(%rsp)
  6d16e8:	lea    0x3c0(%rsp),%r15
  6d16f0:	lea    0x120(%rsp),%rdi
  6d16f8:	lea    0x8(%rsp),%rsi
  6d16fd:	lea    0xb10(%rsp),%rdx
  6d1705:	mov    %r15,%rcx
  6d1708:	call   6d2330 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch>
  6d170d:	cmpl   $0xfffffffe,0x120(%rsp)
  6d1715:	jne    6d19b7 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1257>
  6d171b:	mov    0x8(%rsp),%rsi
  6d1720:	test   %rsi,%rsi
  6d1723:	je     6d1ba6 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1446>
  6d1729:	cmpq   $0x1,0x2b0(%rsi)
  6d1731:	jne    6d1beb <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x148b>
  6d1737:	mov    %rsi,%rdi
  6d173a:	call   6d0660 <_RNvCs4gijoeCAvqI_25inspector_pointer_control3ack>
  6d173f:	mov    0x8(%rsp),%rsi
  6d1744:	lea    0x120(%rsp),%rdi
  6d174c:	movaps 0x40(%rsp),%xmm0
  6d1751:	movaps 0x50(%rsp),%xmm1
  6d1756:	call   6d2ff0 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8hit_only>
  6d175b:	cmpl   $0xfffffffe,0x120(%rsp)
  6d1763:	jne    6d1c05 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x14a5>
  6d1769:	mov    0x128(%rsp),%rdx
  6d1771:	mov    0x130(%rsp),%rax
  6d1779:	mov    %rdx,0xa0(%rsp)
  6d1781:	mov    %rax,0xa8(%rsp)
  6d1789:	mov    %r14,0x3c0(%rsp)
  6d1791:	mov    %rbx,0x3c8(%rsp)
  6d1799:	cmp    %r14,%rdx
  6d179c:	sete   %cl
  6d179f:	test   %rdx,%rdx
  6d17a2:	je     6d1a42 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x12e2>
  6d17a8:	lea    0x328d91(%rip),%rdx        # 9fa540 <__frame_dummy_init_array_entry+0xa10>
  6d17af:	lea    0xa0(%rsp),%r12
  6d17b7:	test   %cl,%cl
  6d17b9:	je     6d1b96 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1436>
  6d17bf:	cmp    %rbx,%rax
  6d17c2:	jne    6d1b96 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1436>
  6d17c8:	movaps 0x40(%rsp),%xmm0
  6d17cd:	movlps %xmm0,0x3c0(%rsp)
  6d17d5:	lea    0x3c0(%rsp),%rax
  6d17dd:	movss  0x3c0(%rsp),%xmm0
  6d17e6:	movss  0x3c4(%rsp),%xmm1
  6d17ef:	lea    0x120(%rsp),%rbx
  6d17f7:	lea    0x8(%rsp),%rsi
  6d17fc:	mov    %rbx,%rdi
  6d17ff:	call   6d0370 <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only>
  6d1804:	cmpl   $0xfffffffe,0x120(%rsp)
  6d180c:	jne    6d1c72 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1512>
  6d1812:	mov    0x8(%rsp),%rdi
  6d1817:	call   6d0660 <_RNvCs4gijoeCAvqI_25inspector_pointer_control3ack>
  6d181c:	mov    0x8(%rsp),%rsi
  6d1821:	test   %rsi,%rsi
  6d1824:	je     6d1cdf <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x157f>
  6d182a:	cmpq   $0x2,0x2b0(%rsi)
  6d1832:	jne    6d1d24 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x15c4>
  6d1838:	mov    0xb10(%rsp),%eax
  6d183f:	cmp    $0xffffffff,%eax
  6d1842:	je     6d1862 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1102>
  6d1844:	dec    %eax
  6d1846:	mov    0xb14(%rsp),%ecx
  6d184d:	mov    %eax,0x124(%rsp)
  6d1854:	mov    %ecx,0x128(%rsp)
  6d185b:	mov    $0x1,%eax
  6d1860:	jmp    6d1864 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1104>
  6d1862:	xor    %eax,%eax
  6d1864:	mov    %eax,0x120(%rsp)
  6d186b:	movl   $0x42500000,0x3c8(%rsp)
  6d1876:	movabs $0x4140000000000001,%rcx
  6d1880:	mov    %rcx,0x3c0(%rsp)
  6d1888:	movabs $0x4250000041400000,%rcx
  6d1892:	cmp    %rcx,0x124(%rsp)
  6d189a:	sete   %cl
  6d189d:	test   %eax,%eax
  6d189f:	je     6d1a60 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1300>
  6d18a5:	test   %cl,%cl
  6d18a7:	je     6d1a6a <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x130a>
  6d18ad:	movaps 0x40(%rsp),%xmm0
  6d18b2:	movss  %xmm0,0xa0(%rsp)
  6d18bb:	movaps 0x50(%rsp),%xmm0
  6d18c0:	movss  %xmm0,0x120(%rsp)
  6d18c9:	lea    0xa0(%rsp),%rax
  6d18d1:	mov    %rax,0x3c0(%rsp)
  6d18d9:	mov    0x347ed8(%rip),%rax        # a197b8 <_DYNAMIC+0x4b8>
  6d18e0:	mov    %rax,0x3c8(%rsp)
  6d18e8:	mov    %rbx,0x3d0(%rsp)
  6d18f0:	mov    %rax,0x3d8(%rsp)
  6d18f8:	lea    -0x69282f(%rip),%rax        # 3f0d0 <GCC_except_table0+0x199c>
  6d18ff:	mov    %rax,0x3e0(%rsp)
  6d1907:	mov    0x347eb2(%rip),%rcx        # a197c0 <_DYNAMIC+0x4c0>
  6d190e:	mov    %rcx,0x3e8(%rsp)
  6d1916:	mov    %rax,0x3f0(%rsp)
  6d191e:	mov    %rcx,0x3f8(%rsp)
  6d1926:	lea    -0x692795(%rip),%rax        # 3f198 <GCC_except_table0+0x1a64>
  6d192d:	mov    %rax,0x400(%rsp)
  6d1935:	mov    %rcx,0x408(%rsp)
  6d193d:	lea    -0x6929cc(%rip),%rax        # 3ef78 <GCC_except_table0+0x1844>
  6d1944:	mov    %rax,0x410(%rsp)
  6d194c:	mov    %rcx,0x418(%rsp)
  6d1954:	lea    -0x6926d3(%rip),%rax        # 3f288 <GCC_except_table0+0x1b54>
  6d195b:	mov    %rax,0x420(%rsp)
  6d1963:	mov    %rcx,0x428(%rsp)
  6d196b:	lea    -0x68958a(%rip),%rdi        # 483e8 <GCC_except_table0+0xacb4>
  6d1972:	lea    0x3c0(%rsp),%rsi
  6d197a:	call   *0x347e48(%rip)        # a197c8 <_DYNAMIC+0x4c8>
  6d1980:	mov    0x8(%rsp),%rbx
  6d1985:	test   %rbx,%rbx
  6d1988:	je     6d19a5 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1245>
  6d198a:	mov    %rbx,%rdi
  6d198d:	call   6b9750 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtCs6ZNK6sH19NW_4gpui7runtime7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelEEB1h_>
  6d1992:	mov    $0x748,%esi
  6d1997:	mov    $0x8,%edx
  6d199c:	mov    %rbx,%rdi
  6d199f:	call   *0x347b9b(%rip)        # a19540 <_DYNAMIC+0x240>
  6d19a5:	add    $0xcf8,%rsp
  6d19ac:	pop    %rbx
  6d19ad:	pop    %r12
  6d19af:	pop    %r13
  6d19b1:	pop    %r14
  6d19b3:	pop    %r15
  6d19b5:	pop    %rbp
  6d19b6:	ret
  6d19b7:	mov    0x150(%rsp),%rax
  6d19bf:	mov    %rax,0x3f0(%rsp)
  6d19c7:	movups 0x120(%rsp),%xmm0
  6d19cf:	movups 0x130(%rsp),%xmm1
  6d19d7:	movups 0x140(%rsp),%xmm2
  6d19df:	movaps %xmm2,0x3e0(%rsp)
  6d19e7:	movaps %xmm1,0x3d0(%rsp)
  6d19ef:	movaps %xmm0,0x3c0(%rsp)
  6d19f7:	lea    -0x6872a4(%rip),%rdi        # 4a75a <GCC_except_table0+0xd026>
  6d19fe:	lea    0x328c13(%rip),%rcx        # 9fa618 <__frame_dummy_init_array_entry+0xae8>
  6d1a05:	lea    0x328bc4(%rip),%r8        # 9fa5d0 <__frame_dummy_init_array_entry+0xaa0>
  6d1a0c:	lea    0x3c0(%rsp),%rdx
  6d1a14:	mov    $0x2b,%esi
  6d1a19:	call   *0x347bd1(%rip)        # a195f0 <_DYNAMIC+0x2f0>
  6d1a1f:	jmp    6d2270 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b10>
  6d1a24:	xor    %ecx,%ecx
  6d1a26:	lea    0x328ab3(%rip),%rdx        # 9fa4e0 <__frame_dummy_init_array_entry+0x9b0>
  6d1a2d:	lea    0x110(%rsp),%r15
  6d1a35:	test   %cl,%cl
  6d1a37:	jne    6d15ce <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0xe6e>
  6d1a3d:	jmp    6d1b96 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1436>
  6d1a42:	xor    %ecx,%ecx
  6d1a44:	lea    0x328af5(%rip),%rdx        # 9fa540 <__frame_dummy_init_array_entry+0xa10>
  6d1a4b:	lea    0xa0(%rsp),%r12
  6d1a53:	test   %cl,%cl
  6d1a55:	jne    6d17bf <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x105f>
  6d1a5b:	jmp    6d1b96 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1436>
  6d1a60:	xor    %ecx,%ecx
  6d1a62:	test   %cl,%cl
  6d1a64:	jne    6d18ad <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x114d>
  6d1a6a:	lea    0x120(%rsp),%rdi
  6d1a72:	lea    0x3c0(%rsp),%rsi
  6d1a7a:	call   6c152b <_RINvNtCs4NRVxsYgnAr_4core9panicking13assert_failedINtNtB4_6option6OptionAmj2_EBM_ECs4gijoeCAvqI_25inspector_pointer_control>
  6d1a7f:	jmp    6d2270 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b10>
  6d1a84:	mov    $0x8,%edi
  6d1a89:	mov    $0x28,%esi
  6d1a8e:	call   *0x347ac4(%rip)        # a19558 <_DYNAMIC+0x258>
  6d1a94:	jmp    6d2270 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b10>
  6d1a99:	mov    $0x8,%edi
  6d1a9e:	mov    $0x748,%esi
  6d1aa3:	call   *0x347aaf(%rip)        # a19558 <_DYNAMIC+0x258>
  6d1aa9:	jmp    6d2270 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b10>
  6d1aae:	mov    0x150(%rsp),%rax
  6d1ab6:	mov    %rax,0x3f0(%rsp)
  6d1abe:	movups 0x120(%rsp),%xmm0
  6d1ac6:	movups 0x130(%rsp),%xmm1
  6d1ace:	movups 0x140(%rsp),%xmm2
  6d1ad6:	movaps %xmm2,0x3e0(%rsp)
  6d1ade:	movaps %xmm1,0x3d0(%rsp)
  6d1ae6:	movaps %xmm0,0x3c0(%rsp)
  6d1aee:	lea    -0x68739b(%rip),%rdi        # 4a75a <GCC_except_table0+0xd026>
  6d1af5:	lea    0x328b1c(%rip),%rcx        # 9fa618 <__frame_dummy_init_array_entry+0xae8>
  6d1afc:	lea    0x3289c5(%rip),%r8        # 9fa4c8 <__frame_dummy_init_array_entry+0x998>
  6d1b03:	lea    0x3c0(%rsp),%rdx
  6d1b0b:	mov    $0x2b,%esi
  6d1b10:	call   *0x347ada(%rip)        # a195f0 <_DYNAMIC+0x2f0>
  6d1b16:	jmp    6d2270 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b10>
  6d1b1b:	mov    0x150(%rsp),%rax
  6d1b23:	mov    %rax,0x3f0(%rsp)
  6d1b2b:	movups 0x120(%rsp),%xmm0
  6d1b33:	movups 0x130(%rsp),%xmm1
  6d1b3b:	movups 0x140(%rsp),%xmm2
  6d1b43:	movaps %xmm2,0x3e0(%rsp)
  6d1b4b:	movaps %xmm1,0x3d0(%rsp)
  6d1b53:	movaps %xmm0,0x3c0(%rsp)
  6d1b5b:	lea    -0x687408(%rip),%rdi        # 4a75a <GCC_except_table0+0xd026>
  6d1b62:	lea    0x328aaf(%rip),%rcx        # 9fa618 <__frame_dummy_init_array_entry+0xae8>
  6d1b69:	lea    0x328988(%rip),%r8        # 9fa4f8 <__frame_dummy_init_array_entry+0x9c8>
  6d1b70:	lea    0x3c0(%rsp),%rdx
  6d1b78:	mov    $0x2b,%esi
  6d1b7d:	call   *0x347a6d(%rip)        # a195f0 <_DYNAMIC+0x2f0>
  6d1b83:	jmp    6d2270 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b10>
  6d1b88:	lea    0x328a59(%rip),%rdx        # 9fa5e8 <__frame_dummy_init_array_entry+0xab8>
  6d1b8f:	lea    -0x6931b6(%rip),%r15        # 3e9e0 <GCC_except_table0+0x12ac>
  6d1b96:	mov    %r12,%rdi
  6d1b99:	mov    %r15,%rsi
  6d1b9c:	call   6c1563 <_RINvNtCs4NRVxsYgnAr_4core9panicking13assert_failedINtNtB4_6option6OptionNtNtCs6ZNK6sH19NW_4gpui8identity6TargetEBM_ECs4gijoeCAvqI_25inspector_pointer_control>
  6d1ba1:	jmp    6d2270 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b10>
  6d1ba6:	movq   $0xd,0x3c0(%rsp)
  6d1bb2:	movq   $0x0,0x3c8(%rsp)
  6d1bbe:	lea    -0x68746b(%rip),%rdi        # 4a75a <GCC_except_table0+0xd026>
  6d1bc5:	lea    0x328a4c(%rip),%rcx        # 9fa618 <__frame_dummy_init_array_entry+0xae8>
  6d1bcc:	lea    0x32893d(%rip),%r8        # 9fa510 <__frame_dummy_init_array_entry+0x9e0>
  6d1bd3:	lea    0x3c0(%rsp),%rdx
  6d1bdb:	mov    $0x2b,%esi
  6d1be0:	call   *0x347a0a(%rip)        # a195f0 <_DYNAMIC+0x2f0>
  6d1be6:	jmp    6d2270 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b10>
  6d1beb:	add    $0x2b0,%rsi
  6d1bf2:	lea    0x3289bf(%rip),%r9        # 9fa5b8 <__frame_dummy_init_array_entry+0xa88>
  6d1bf9:	lea    -0x692b50(%rip),%rdx        # 3f0b0 <GCC_except_table0+0x197c>
  6d1c00:	jmp    6d1d39 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x15d9>
  6d1c05:	mov    0x150(%rsp),%rax
  6d1c0d:	mov    %rax,0x3f0(%rsp)
  6d1c15:	movups 0x120(%rsp),%xmm0
  6d1c1d:	movups 0x130(%rsp),%xmm1
  6d1c25:	movups 0x140(%rsp),%xmm2
  6d1c2d:	movaps %xmm2,0x3e0(%rsp)
  6d1c35:	movaps %xmm1,0x3d0(%rsp)
  6d1c3d:	movaps %xmm0,0x3c0(%rsp)
  6d1c45:	lea    -0x6874f2(%rip),%rdi        # 4a75a <GCC_except_table0+0xd026>
  6d1c4c:	lea    0x3289c5(%rip),%rcx        # 9fa618 <__frame_dummy_init_array_entry+0xae8>
  6d1c53:	lea    0x3288ce(%rip),%r8        # 9fa528 <__frame_dummy_init_array_entry+0x9f8>
  6d1c5a:	lea    0x3c0(%rsp),%rdx
  6d1c62:	mov    $0x2b,%esi
  6d1c67:	call   *0x347983(%rip)        # a195f0 <_DYNAMIC+0x2f0>
  6d1c6d:	jmp    6d2270 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b10>
  6d1c72:	mov    0x150(%rsp),%rax
  6d1c7a:	mov    %rax,0x3f0(%rsp)
  6d1c82:	movups 0x120(%rsp),%xmm0
  6d1c8a:	movups 0x130(%rsp),%xmm1
  6d1c92:	movups 0x140(%rsp),%xmm2
  6d1c9a:	movaps %xmm2,0x3e0(%rsp)
  6d1ca2:	movaps %xmm1,0x3d0(%rsp)
  6d1caa:	movaps %xmm0,0x3c0(%rsp)
  6d1cb2:	lea    -0x68755f(%rip),%rdi        # 4a75a <GCC_except_table0+0xd026>
  6d1cb9:	lea    0x328958(%rip),%rcx        # 9fa618 <__frame_dummy_init_array_entry+0xae8>
  6d1cc0:	lea    0x328891(%rip),%r8        # 9fa558 <__frame_dummy_init_array_entry+0xa28>
  6d1cc7:	lea    0x3c0(%rsp),%rdx
  6d1ccf:	mov    $0x2b,%esi
  6d1cd4:	call   *0x347916(%rip)        # a195f0 <_DYNAMIC+0x2f0>
  6d1cda:	jmp    6d2270 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b10>
  6d1cdf:	movq   $0xd,0x3c0(%rsp)
  6d1ceb:	movq   $0x0,0x3c8(%rsp)
  6d1cf7:	lea    -0x6875a4(%rip),%rdi        # 4a75a <GCC_except_table0+0xd026>
  6d1cfe:	lea    0x328913(%rip),%rcx        # 9fa618 <__frame_dummy_init_array_entry+0xae8>
  6d1d05:	lea    0x328864(%rip),%r8        # 9fa570 <__frame_dummy_init_array_entry+0xa40>
  6d1d0c:	lea    0x3c0(%rsp),%rdx
  6d1d14:	mov    $0x2b,%esi
  6d1d19:	call   *0x3478d1(%rip)        # a195f0 <_DYNAMIC+0x2f0>
  6d1d1f:	jmp    6d2270 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b10>
  6d1d24:	add    $0x2b0,%rsi
  6d1d2b:	lea    0x32886e(%rip),%r9        # 9fa5a0 <__frame_dummy_init_array_entry+0xa70>
  6d1d32:	lea    -0x692bd9(%rip),%rdx        # 3f160 <GCC_except_table0+0x1a2c>
  6d1d39:	xor    %edi,%edi
  6d1d3b:	xor    %ecx,%ecx
  6d1d3d:	call   *0x347a8d(%rip)        # a197d0 <_DYNAMIC+0x4d0>
  6d1d43:	jmp    6d2270 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b10>
  6d1d48:	movq   $0x11,0x120(%rsp)
  6d1d54:	mov    0x150(%rsp),%rax
  6d1d5c:	mov    %rax,0x3f0(%rsp)
  6d1d64:	mov    0x120(%rsp),%rax
  6d1d6c:	mov    0x128(%rsp),%rcx
  6d1d74:	movups 0x130(%rsp),%xmm0
  6d1d7c:	movups 0x140(%rsp),%xmm1
  6d1d84:	movaps %xmm1,0x3e0(%rsp)
  6d1d8c:	movaps %xmm0,0x3d0(%rsp)
  6d1d94:	mov    %rax,0x3c0(%rsp)
  6d1d9c:	mov    %rcx,0x3c8(%rsp)
  6d1da4:	lea    -0x687651(%rip),%rdi        # 4a75a <GCC_except_table0+0xd026>
  6d1dab:	lea    0x328866(%rip),%rcx        # 9fa618 <__frame_dummy_init_array_entry+0xae8>
  6d1db2:	lea    0x3286df(%rip),%r8        # 9fa498 <__frame_dummy_init_array_entry+0x968>
  6d1db9:	lea    0x3c0(%rsp),%rdx
  6d1dc1:	mov    $0x2b,%esi
  6d1dc6:	call   *0x347824(%rip)        # a195f0 <_DYNAMIC+0x2f0>
  6d1dcc:	jmp    6d2270 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b10>
  6d1dd1:	movq   $0x12,0x120(%rsp)
  6d1ddd:	jmp    6d1d54 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x15f4>
  6d1de2:	movq   $0x19,0x120(%rsp)
  6d1dee:	jmp    6d1d54 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x15f4>
  6d1df3:	mov    0x70(%rsp),%r15
  6d1df8:	movups 0x78(%rsp),%xmm0
  6d1dfd:	movaps %xmm0,0x10(%rsp)
  6d1e02:	movups 0x88(%rsp),%xmm0
  6d1e0a:	movaps %xmm0,0x30(%rsp)
  6d1e0f:	movzbl 0x98(%rsp),%ebp
  6d1e17:	mov    0x99(%rsp),%eax
  6d1e1e:	mov    %eax,0x28(%rsp)
  6d1e22:	mov    0x9c(%rsp),%eax
  6d1e29:	mov    %eax,0x2b(%rsp)
  6d1e2d:	mov    0x8(%rsp),%rbx
  6d1e32:	test   %rbx,%rbx
  6d1e35:	je     6d1e52 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x16f2>
  6d1e37:	mov    %rbx,%rdi
  6d1e3a:	call   6b9750 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtCs6ZNK6sH19NW_4gpui7runtime7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelEEB1h_>
  6d1e3f:	mov    $0x748,%esi
  6d1e44:	mov    $0x8,%edx
  6d1e49:	mov    %rbx,%rdi
  6d1e4c:	call   *0x3476ee(%rip)        # a19540 <_DYNAMIC+0x240>
  6d1e52:	mov    %r15,%r12
  6d1e55:	shr    $0x20,%r12
  6d1e59:	jmp    6d1ef5 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1795>
  6d1e5e:	mov    $0x1b,%eax
  6d1e63:	test   %rcx,%rcx
  6d1e66:	jne    6d207b <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x191b>
  6d1e6c:	mov    $0x1a,%eax
  6d1e71:	jmp    6d207b <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x191b>
  6d1e76:	mov    $0x1,%edi
  6d1e7b:	mov    $0x6,%esi
  6d1e80:	call   *0x347742(%rip)        # a195c8 <_DYNAMIC+0x2c8>
  6d1e86:	mov    0x3c8(%rsp),%r15
  6d1e8e:	mov    %r15,%r12
  6d1e91:	shr    $0x20,%r12
  6d1e95:	movups 0x3d0(%rsp),%xmm0
  6d1e9d:	movaps %xmm0,0x10(%rsp)
  6d1ea2:	movups 0x3e0(%rsp),%xmm0
  6d1eaa:	movaps %xmm0,0x30(%rsp)
  6d1eaf:	movzbl 0x3f0(%rsp),%ebp
  6d1eb7:	mov    0x3f1(%rsp),%eax
  6d1ebe:	mov    %eax,0x28(%rsp)
  6d1ec2:	mov    0x3f4(%rsp),%eax
  6d1ec9:	mov    %eax,0x2b(%rsp)
  6d1ecd:	jmp    6d1ee2 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1782>
  6d1ecf:	lea    0xa0(%rsp),%rdi
  6d1ed7:	call   6b95a0 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtCs6ZNK6sH19NW_4gpui6source7SourcesNtCs4gijoeCAvqI_25inspector_pointer_control5ModelEEB1g_>
  6d1edc:	mov    $0x23,%r13d
  6d1ee2:	mov    $0x6,%esi
  6d1ee7:	mov    $0x1,%edx
  6d1eec:	mov    %rbx,%rdi
  6d1eef:	call   *0x34764b(%rip)        # a19540 <_DYNAMIC+0x240>
  6d1ef5:	movaps 0x10(%rsp),%xmm0
  6d1efa:	movaps 0x30(%rsp),%xmm1
  6d1eff:	jmp    6d2200 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1aa0>
  6d1f04:	mov    $0xd,%eax
  6d1f09:	jmp    6d1f17 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x17b7>
  6d1f0b:	mov    $0xe,%eax
  6d1f10:	jmp    6d1f17 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x17b7>
  6d1f12:	mov    $0x12,%eax
  6d1f17:	mov    %rax,0x10(%rsp)
  6d1f1c:	mov    0x10(%rsp),%rax
  6d1f21:	mov    %rax,0x3c0(%rsp)
  6d1f29:	movq   $0x0,0x3c8(%rsp)
  6d1f35:	lea    -0x68781a(%rip),%rdi        # 4a722 <GCC_except_table0+0xcfee>
  6d1f3c:	lea    0x3286d5(%rip),%rcx        # 9fa618 <__frame_dummy_init_array_entry+0xae8>
  6d1f43:	lea    0x328536(%rip),%r8        # 9fa480 <__frame_dummy_init_array_entry+0x950>
  6d1f4a:	lea    0x3c0(%rsp),%rdx
  6d1f52:	mov    $0x2a,%esi
  6d1f57:	call   *0x347693(%rip)        # a195f0 <_DYNAMIC+0x2f0>
  6d1f5d:	jmp    6d2270 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b10>
  6d1f62:	movq   $0xd,0x120(%rsp)
  6d1f6e:	movq   $0x0,0x128(%rsp)
  6d1f7a:	jmp    6d1d54 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x15f4>
  6d1f7f:	movq   $0xe,0x120(%rsp)
  6d1f8b:	jmp    6d1d54 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x15f4>
  6d1f90:	mov    $0x11,%eax
  6d1f95:	jmp    6d1fcf <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x186f>
  6d1f97:	mov    0x3c8(%rsp),%rcx
  6d1f9f:	movups 0x3d0(%rsp),%xmm0
  6d1fa7:	movaps %xmm0,0xb10(%rsp)
  6d1faf:	movups 0x3e0(%rsp),%xmm0
  6d1fb7:	movaps %xmm0,0xb20(%rsp)
  6d1fbf:	mov    0x3f0(%rsp),%rdx
  6d1fc7:	mov    %rdx,0xb30(%rsp)
  6d1fcf:	mov    %rax,0x120(%rsp)
  6d1fd7:	mov    %rcx,0x128(%rsp)
  6d1fdf:	movaps 0xb10(%rsp),%xmm0
  6d1fe7:	movaps 0xb20(%rsp),%xmm1
  6d1fef:	movups %xmm0,0x130(%rsp)
  6d1ff7:	movups %xmm1,0x140(%rsp)
  6d1fff:	mov    0xb30(%rsp),%rax
  6d2007:	mov    %rax,0x150(%rsp)
  6d200f:	jmp    6d1d54 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x15f4>
  6d2014:	mov    $0x11,%eax
  6d2019:	mov    0x3f0(%rsp),%rcx
  6d2021:	mov    %rcx,0x150(%rsp)
  6d2029:	movups 0x3d0(%rsp),%xmm0
  6d2031:	movups 0x3e0(%rsp),%xmm1
  6d2039:	movups %xmm1,0x140(%rsp)
  6d2041:	movups %xmm0,0x130(%rsp)
  6d2049:	mov    %rax,0x120(%rsp)
  6d2051:	mov    %r12,0x128(%rsp)
  6d2059:	jmp    6d1d54 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x15f4>
  6d205e:	lea    0x328cab(%rip),%rax        # 9fad10 <__frame_dummy_init_array_entry+0x11e0>
  6d2065:	mov    %rax,0x60(%rsp)
  6d206a:	jmp    6d14f8 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0xd98>
  6d206f:	mov    $0xd,%eax
  6d2074:	jmp    6d207b <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x191b>
  6d2076:	mov    $0xe,%eax
  6d207b:	mov    %rax,0x3c0(%rsp)
  6d2083:	mov    0x10(%rsp),%rax
  6d2088:	mov    %rax,0x3c8(%rsp)
  6d2090:	lea    -0x68793d(%rip),%rdi        # 4a75a <GCC_except_table0+0xd026>
  6d2097:	lea    0x32857a(%rip),%rcx        # 9fa618 <__frame_dummy_init_array_entry+0xae8>
  6d209e:	lea    0x32840b(%rip),%r8        # 9fa4b0 <__frame_dummy_init_array_entry+0x980>
  6d20a5:	lea    0x3c0(%rsp),%rdx
  6d20ad:	mov    $0x2b,%esi
  6d20b2:	call   *0x347538(%rip)        # a195f0 <_DYNAMIC+0x2f0>
  6d20b8:	jmp    6d2270 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b10>
  6d20bd:	mov    %rax,%r14
  6d20c0:	jmp    6d22fb <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b9b>
  6d20c5:	mov    %rax,%r14
  6d20c8:	jmp    6d22fb <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b9b>
  6d20cd:	mov    %rax,%r14
  6d20d0:	jmp    6d2134 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x19d4>
  6d20d2:	mov    %rax,%r14
  6d20d5:	lea    0x327c5c(%rip),%rsi        # 9f9d38 <__frame_dummy_init_array_entry+0x208>
  6d20dc:	mov    %r15,%rdi
  6d20df:	call   6bae30 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtCscdodAO9FK5_5alloc5boxed3BoxDG0_INtNtNtB4_3ops8function2FnTQL1_INtNtCs6ZNK6sH19NW_4gpui7element2ElL0_EEEp6OutputuEL_EECs4gijoeCAvqI_25inspector_pointer_control>
  6d20e4:	jmp    6d21a6 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1a46>
  6d20e9:	call   *0x347479(%rip)        # a19568 <_DYNAMIC+0x268>
  6d20ef:	mov    %rax,%r14
  6d20f2:	lea    0x3c0(%rsp),%rdi
  6d20fa:	call   6b95a0 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtCs6ZNK6sH19NW_4gpui6source7SourcesNtCs4gijoeCAvqI_25inspector_pointer_control5ModelEEB1g_>
  6d20ff:	jmp    6d21b3 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1a53>
  6d2104:	call   *0x34745e(%rip)        # a19568 <_DYNAMIC+0x268>
  6d210a:	mov    %rax,%r14
  6d210d:	jmp    6d228d <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b2d>
  6d2112:	mov    %rax,%r14
  6d2115:	mov    0x8(%rsp),%rdi
  6d211a:	call   6b96f0 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtCs6ZNK6sH19NW_4gpui7runtime3WinNtCs4gijoeCAvqI_25inspector_pointer_control5ModelEEB1d_>
  6d211f:	jmp    6d22eb <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b8b>
  6d2124:	mov    %rax,%r14
  6d2127:	lea    0xb10(%rsp),%rdi
  6d212f:	call   6befb0 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueNtNtCshdpBObOiWw8_11gpui_canvas6canvas6CanvasECs4gijoeCAvqI_25inspector_pointer_control>
  6d2134:	lea    0xa0(%rsp),%rdi
  6d213c:	call   6b95a0 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtCs6ZNK6sH19NW_4gpui6source7SourcesNtCs4gijoeCAvqI_25inspector_pointer_control5ModelEEB1g_>
  6d2141:	jmp    6d228d <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b2d>
  6d2146:	jmp    6d22de <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b7e>
  6d214b:	call   *0x347417(%rip)        # a19568 <_DYNAMIC+0x268>
  6d2151:	jmp    6d22cc <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b6c>
  6d2156:	jmp    6d22de <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b7e>
  6d215b:	jmp    6d22de <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b7e>
  6d2160:	jmp    6d22cc <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b6c>
  6d2165:	jmp    6d22cc <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b6c>
  6d216a:	jmp    6d22cc <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b6c>
  6d216f:	jmp    6d22cc <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b6c>
  6d2174:	jmp    6d22cc <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b6c>
  6d2179:	jmp    6d22cc <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b6c>
  6d217e:	jmp    6d22cc <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b6c>
  6d2183:	jmp    6d22cc <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b6c>
  6d2188:	mov    %rax,%r14
  6d218b:	lea    0x3c0(%rsp),%rdi
  6d2193:	call   6b9750 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtCs6ZNK6sH19NW_4gpui7runtime7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelEEB1h_>
  6d2198:	jmp    6d22eb <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b8b>
  6d219d:	call   *0x3473c5(%rip)        # a19568 <_DYNAMIC+0x268>
  6d21a3:	mov    %rax,%r14
  6d21a6:	lea    0x3c0(%rsp),%rdi
  6d21ae:	call   6b95a0 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtCs6ZNK6sH19NW_4gpui6source7SourcesNtCs4gijoeCAvqI_25inspector_pointer_control5ModelEEB1g_>
  6d21b3:	mov    %r14,%rdi
  6d21b6:	call   *0x34761c(%rip)        # a197d8 <_DYNAMIC+0x4d8>
  6d21bc:	mov    %rax,%r15
  6d21bf:	mov    %rdx,%r12
  6d21c2:	mov    (%rdx),%rax
  6d21c5:	test   %rax,%rax
  6d21c8:	je     6d21cf <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1a6f>
  6d21ca:	mov    %r15,%rdi
  6d21cd:	call   *%rax
  6d21cf:	mov    0x8(%r12),%rsi
  6d21d4:	test   %rsi,%rsi
  6d21d7:	je     6d21e7 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1a87>
  6d21d9:	mov    0x10(%r12),%rdx
  6d21de:	mov    %r15,%rdi
  6d21e1:	call   *0x347359(%rip)        # a19540 <_DYNAMIC+0x240>
  6d21e7:	mov    $0x6,%esi
  6d21ec:	mov    $0x1,%edx
  6d21f1:	mov    %rbx,%rdi
  6d21f4:	call   *0x347346(%rip)        # a19540 <_DYNAMIC+0x240>
  6d21fa:	mov    $0xf,%r13d
  6d2200:	mov    %r13,0x120(%rsp)
  6d2208:	shl    $0x20,%r12
  6d220c:	mov    %r15d,%eax
  6d220f:	or     %r12,%rax
  6d2212:	mov    %rax,0x128(%rsp)
  6d221a:	movups %xmm0,0x130(%rsp)
  6d2222:	movups %xmm1,0x140(%rsp)
  6d222a:	mov    %bpl,0x150(%rsp)
  6d2232:	mov    0x28(%rsp),%eax
  6d2236:	mov    0x2b(%rsp),%ecx
  6d223a:	mov    %eax,0x151(%rsp)
  6d2241:	mov    %ecx,0x154(%rsp)
  6d2248:	lea    -0x687af5(%rip),%rdi        # 4a75a <GCC_except_table0+0xd026>
  6d224f:	lea    0x3283c2(%rip),%rcx        # 9fa618 <__frame_dummy_init_array_entry+0xae8>
  6d2256:	lea    0x32820b(%rip),%r8        # 9fa468 <__frame_dummy_init_array_entry+0x938>
  6d225d:	lea    0x120(%rsp),%rdx
  6d2265:	mov    $0x2b,%esi
  6d226a:	call   *0x347380(%rip)        # a195f0 <_DYNAMIC+0x2f0>
  6d2270:	ud2
  6d2272:	mov    %rax,%r14
  6d2275:	mov    0x8(%r12),%rsi
  6d227a:	test   %rsi,%rsi
  6d227d:	je     6d228d <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b2d>
  6d227f:	mov    0x10(%r12),%rdx
  6d2284:	mov    %r15,%rdi
  6d2287:	call   *0x3472b3(%rip)        # a19540 <_DYNAMIC+0x240>
  6d228d:	mov    $0x6,%esi
  6d2292:	mov    $0x1,%edx
  6d2297:	mov    %rbx,%rdi
  6d229a:	call   *0x3472a0(%rip)        # a19540 <_DYNAMIC+0x240>
  6d22a0:	mov    %r14,%rdi
  6d22a3:	call   9f8780 <_Unwind_Resume@plt>
  6d22a8:	mov    %rax,%r14
  6d22ab:	lea    0x120(%rsp),%rdi
  6d22b3:	call   6be360 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueNtNtCs6ZNK6sH19NW_4gpui7runtime5ErrorECs4gijoeCAvqI_25inspector_pointer_control>
  6d22b8:	mov    %r14,%rdi
  6d22bb:	call   9f8780 <_Unwind_Resume@plt>
  6d22c0:	call   *0x34751a(%rip)        # a197e0 <_DYNAMIC+0x4e0>
  6d22c6:	call   *0x34729c(%rip)        # a19568 <_DYNAMIC+0x268>
  6d22cc:	mov    %rax,%r14
  6d22cf:	lea    0x3c0(%rsp),%rdi
  6d22d7:	call   6be360 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueNtNtCs6ZNK6sH19NW_4gpui7runtime5ErrorECs4gijoeCAvqI_25inspector_pointer_control>
  6d22dc:	jmp    6d22e1 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b81>
  6d22de:	mov    %rax,%r14
  6d22e1:	mov    0x8(%rsp),%rbx
  6d22e6:	test   %rbx,%rbx
  6d22e9:	jne    6d22f3 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b93>
  6d22eb:	mov    %r14,%rdi
  6d22ee:	call   9f8780 <_Unwind_Resume@plt>
  6d22f3:	mov    %rbx,%rdi
  6d22f6:	call   6b9750 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtCs6ZNK6sH19NW_4gpui7runtime7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelEEB1h_>
  6d22fb:	mov    $0x748,%esi
  6d2300:	mov    $0x8,%edx
  6d2305:	mov    %rbx,%rdi
  6d2308:	call   *0x347232(%rip)        # a19540 <_DYNAMIC+0x240>
  6d230e:	mov    %r14,%rdi
  6d2311:	call   9f8780 <_Unwind_Resume@plt>
  6d2316:	mov    $0x748,%esi
  6d231b:	mov    $0x8,%edx
  6d2320:	mov    %rbx,%rdi
  6d2323:	call   *0x347217(%rip)        # a19540 <_DYNAMIC+0x240>
  6d2329:	call   *0x347239(%rip)        # a19568 <_DYNAMIC+0x268>

/tmp/gpui-inspector-pointer-codegen-optin/candidate-frozen:     file format elf64-x86-64


Disassembly of section .text:

00000000006d2330 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch>:
  6d2330:	push   %rbp
  6d2331:	push   %r15
  6d2333:	push   %r14
  6d2335:	push   %r13
  6d2337:	push   %r12
  6d2339:	push   %rbx
  6d233a:	sub    $0xb8,%rsp
  6d2341:	mov    %rdx,%r14
  6d2344:	mov    %rdi,%rbx
  6d2347:	mov    (%rcx),%ebp
  6d2349:	test   %ebp,%ebp
  6d234b:	je     6d2380 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x50>
  6d234d:	mov    0x8(%r14),%r12
  6d2351:	mov    0x10(%r14),%r13
  6d2355:	mov    0x18(%r14),%rax
  6d2359:	movq   $0x0,0x8(%r14)
  6d2361:	lea    -0x1(%rbp),%edx
  6d2364:	lea    -0x69301b(%rip),%rdi        # 3f350 <GCC_except_table0+0x1c1c>
  6d236b:	movslq (%rdi,%rdx,4),%rdx
  6d236f:	add    %rdi,%rdx
  6d2372:	jmp    *%rdx
  6d2374:	movl   $0xffffffff,(%r14)
  6d237b:	jmp    6d2541 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x211>
  6d2380:	movd   0x4(%rcx),%xmm1
  6d2385:	movd   0x8(%rcx),%xmm0
  6d238a:	movd   %xmm1,%eax
  6d238e:	movd   %xmm0,%ecx
  6d2392:	mov    %eax,%edx
  6d2394:	and    $0x7fffffff,%edx
  6d239a:	cmp    $0x7f800000,%edx
  6d23a0:	setge  %dl
  6d23a3:	and    $0x7fffffff,%ecx
  6d23a9:	cmp    $0x7f800000,%ecx
  6d23af:	setge  %cl
  6d23b2:	or     %dl,%cl
  6d23b4:	je     6d23cd <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x9d>
  6d23b6:	movl   $0xffffffff,(%r14)
  6d23bd:	movq   $0x0,0x8(%r14)
  6d23c5:	xor    %r12d,%r12d
  6d23c8:	jmp    6d2541 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x211>
  6d23cd:	inc    %eax
  6d23cf:	je     6d2f74 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xc44>
  6d23d5:	mov    %eax,(%r14)
  6d23d8:	movd   %xmm0,0x4(%r14)
  6d23de:	xor    %r12d,%r12d
  6d23e1:	jmp    6d2541 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x211>
  6d23e6:	mov    (%r14),%r15d
  6d23e9:	cmp    $0xffffffff,%r15d
  6d23ed:	je     6d2541 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x211>
  6d23f3:	mov    %rsi,%r13
  6d23f6:	movups 0x8(%rcx),%xmm0
  6d23fa:	movss  0x4(%r14),%xmm1
  6d2400:	movss  %xmm1,0x58(%rsp)
  6d2406:	movaps %xmm0,%xmm1
  6d2409:	unpckhpd %xmm0,%xmm1
  6d240d:	lea    0x10(%rsp),%rdi
  6d2412:	movaps %xmm0,0x60(%rsp)
  6d2417:	call   *0x3473cb(%rip)        # a197e8 <_DYNAMIC+0x4e8>
  6d241d:	cmpl   $0xfffffffe,0x10(%rsp)
  6d2422:	jne    6d279e <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x46e>
  6d2428:	mov    0x0(%r13),%r14
  6d242c:	test   %r14,%r14
  6d242f:	je     6d2573 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x243>
  6d2435:	cmpb   $0x1,0x746(%r14)
  6d243d:	je     6d2567 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x237>
  6d2443:	cmpb   $0x1,0x742(%r14)
  6d244b:	jne    6d28c1 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x591>
  6d2451:	cmpb   $0x0,0x743(%r14)
  6d2459:	jne    6d28c1 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x591>
  6d245f:	cmpb   $0x0,0x744(%r14)
  6d2467:	je     6d28c1 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x591>
  6d246d:	cmpq   $0xffffffffffffffff,0x5b0(%r14)
  6d2475:	jne    6d28c1 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x591>
  6d247b:	mov    0x688(%r14),%rax
  6d2482:	cmp    0x690(%r14),%rax
  6d2489:	jne    6d28c1 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x591>
  6d248f:	mov    0x698(%r14),%rax
  6d2496:	cmp    %rax,0x6a0(%r14)
  6d249d:	jne    6d28c1 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x591>
  6d24a3:	movss  0x738(%r14),%xmm0
  6d24ac:	ucomiss 0x73c(%r14),%xmm0
  6d24b4:	jne    6d28c1 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x591>
  6d24ba:	jp     6d28c1 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x591>
  6d24c0:	mov    %eax,%ecx
  6d24c2:	cvtsi2ss %rcx,%xmm2
  6d24c7:	dec    %r15d
  6d24ca:	shr    $0x20,%rax
  6d24ce:	mov    %eax,%eax
  6d24d0:	xorps  %xmm1,%xmm1
  6d24d3:	cvtsi2ss %rax,%xmm1
  6d24d8:	movd   %r15d,%xmm0
  6d24dd:	movq   $0x0,0x10(%rsp)
  6d24e6:	movss  %xmm2,0x18(%rsp)
  6d24ec:	movss  %xmm1,0x1c(%rsp)
  6d24f2:	lea    0x10(%rsp),%rdi
  6d24f7:	movd   %xmm0,0x54(%rsp)
  6d24fd:	movss  0x58(%rsp),%xmm1
  6d2503:	call   *0x34729f(%rip)        # a197a8 <_DYNAMIC+0x4a8>
  6d2509:	test   %al,%al
  6d250b:	je     6d2f68 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xc38>
  6d2511:	mov    0x638(%r14),%rax
  6d2518:	test   %rax,%rax
  6d251b:	je     6d2dae <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xa7e>
  6d2521:	mov    0x100(%rax),%rsi
  6d2528:	test   %rsi,%rsi
  6d252b:	je     6d2dae <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xa7e>
  6d2531:	lea    0x70(%rsp),%rdi
  6d2536:	call   *0x347254(%rip)        # a19790 <_DYNAMIC+0x490>
  6d253c:	jmp    6d2dc1 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xa91>
  6d2541:	mov    (%rsi),%r15
  6d2544:	test   %r15,%r15
  6d2547:	je     6d2573 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x243>
  6d2549:	add    $0x8,%rsi
  6d254d:	mov    %r15,0xa8(%rsp)
  6d2555:	mov    %rsi,0xb0(%rsp)
  6d255d:	cmpb   $0x1,0x746(%r15)
  6d2565:	jne    6d2587 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x257>
  6d2567:	movq   $0xe,(%rbx)
  6d256e:	jmp    6d2977 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x647>
  6d2573:	movq   $0xd,(%rbx)
  6d257a:	movq   $0x0,0x8(%rbx)
  6d2582:	jmp    6d2977 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x647>
  6d2587:	movq   $0x0,0x730(%r15)
  6d2592:	cmp    $0x3,%ebp
  6d2595:	je     6d276b <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x43b>
  6d259b:	cmp    $0x2,%ebp
  6d259e:	je     6d26b7 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x387>
  6d25a4:	test   %ebp,%ebp
  6d25a6:	jne    6d291e <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x5ee>
  6d25ac:	mov    0x638(%r15),%rax
  6d25b3:	test   %rax,%rax
  6d25b6:	je     6d25ce <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x29e>
  6d25b8:	mov    0xd8(%rax),%rax
  6d25bf:	test   %rax,%rax
  6d25c2:	je     6d25ce <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x29e>
  6d25c4:	cmpb   $0x0,0x12(%rax)
  6d25c8:	jne    6d291e <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x5ee>
  6d25ce:	mov    0x8(%r14),%r12
  6d25d2:	test   %r12,%r12
  6d25d5:	je     6d291e <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x5ee>
  6d25db:	cmp    0x5d8(%r15),%r12
  6d25e2:	jne    6d2916 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x5e6>
  6d25e8:	mov    0x10(%r14),%r13
  6d25ec:	lea    0x70(%rsp),%rdi
  6d25f1:	mov    %r15,%rsi
  6d25f4:	mov    %r13,%rdx
  6d25f7:	call   6f8520 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE16resolve_identityBO_>
  6d25fc:	mov    0x70(%rsp),%rax
  6d2601:	cmp    $0xfffffffffffffffe,%rax
  6d2605:	jne    6d28cd <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x59d>
  6d260b:	mov    0x78(%rsp),%rdi
  6d2610:	mov    0x2c8(%r15),%rsi
  6d2617:	cmp    %rsi,%rdi
  6d261a:	jae    6d2f8d <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xc5d>
  6d2620:	mov    0x2c0(%r15),%rax
  6d2627:	lea    (%rdi,%rdi,4),%rcx
  6d262b:	mov    0x20(%rax,%rcx,8),%edi
  6d262f:	call   6e1fb0 <_RNvMsh_NtCs6ZNK6sH19NW_4gpui7runtimeNtB5_4Node4kind>
  6d2634:	cmp    $0x4,%al
  6d2636:	jne    6d2989 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x659>
  6d263c:	mov    (%r14),%eax
  6d263f:	cmp    $0xffffffff,%eax
  6d2642:	je     6d2f9c <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xc6c>
  6d2648:	movd   0x4(%r14),%xmm1
  6d264e:	dec    %eax
  6d2650:	movd   %eax,%xmm0
  6d2654:	lea    0x10(%rsp),%rdi
  6d2659:	mov    %r15,%rsi
  6d265c:	mov    %r12,%rdx
  6d265f:	mov    %r13,%rcx
  6d2662:	mov    $0x1,%r8d
  6d2668:	call   6db800 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime7editingINtB7_10RuntimeMutNtCs4gijoeCAvqI_25inspector_pointer_control5ModeluE14select_pointerB12_>
  6d266d:	mov    0x10(%rsp),%rax
  6d2672:	cmp    $0xfffffffffffffffe,%rax
  6d2676:	je     6d2685 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x355>
  6d2678:	cmp    $0x11,%eax
  6d267b:	jne    6d2685 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x355>
  6d267d:	movq   $0x0,0x8(%r14)
  6d2685:	mov    0x40(%rsp),%rax
  6d268a:	mov    %rax,0x30(%rbx)
  6d268e:	movups 0x10(%rsp),%xmm0
  6d2693:	movups 0x20(%rsp),%xmm1
  6d2698:	movups 0x30(%rsp),%xmm2
  6d269d:	movups %xmm2,0x20(%rbx)
  6d26a1:	movups %xmm1,0x10(%rbx)
  6d26a5:	movups %xmm0,(%rbx)
  6d26a8:	lea    0x70(%rsp),%rdi
  6d26ad:	call   6b91e0 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtB4_6result6ResultNtNtCs6ZNK6sH19NW_4gpui7runtime6CommitNtBZ_5ErrorEECs4gijoeCAvqI_25inspector_pointer_control>
  6d26b2:	jmp    6d2977 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x647>
  6d26b7:	test   %r12,%r12
  6d26ba:	sete   %cl
  6d26bd:	cmpb   $0x1,0x742(%r15)
  6d26c5:	jne    6d28c1 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x591>
  6d26cb:	cmpb   $0x0,0x743(%r15)
  6d26d3:	jne    6d28c1 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x591>
  6d26d9:	cmpb   $0x0,0x744(%r15)
  6d26e1:	je     6d28c1 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x591>
  6d26e7:	cmpq   $0xffffffffffffffff,0x5b0(%r15)
  6d26ef:	jne    6d28c1 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x591>
  6d26f5:	mov    0x688(%r15),%rax
  6d26fc:	cmp    0x690(%r15),%rax
  6d2703:	jne    6d28c1 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x591>
  6d2709:	mov    0x6a0(%r15),%rax
  6d2710:	cmp    0x698(%r15),%rax
  6d2717:	jne    6d28c1 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x591>
  6d271d:	movss  0x738(%r15),%xmm0
  6d2726:	ucomiss 0x73c(%r15),%xmm0
  6d272e:	jne    6d28c1 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x591>
  6d2734:	jp     6d28c1 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x591>
  6d273a:	mov    (%r14),%eax
  6d273d:	cmp    $0xffffffff,%eax
  6d2740:	mov    %rax,0x58(%rsp)
  6d2745:	mov    %ecx,0x54(%rsp)
  6d2749:	je     6d2995 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x665>
  6d274f:	movss  0x4(%r14),%xmm0
  6d2755:	dec    %eax
  6d2757:	mov    %eax,0x14(%rsp)
  6d275b:	movss  %xmm0,0x18(%rsp)
  6d2761:	mov    $0x1,%eax
  6d2766:	jmp    6d2997 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x667>
  6d276b:	test   %r12,%r12
  6d276e:	je     6d291e <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x5ee>
  6d2774:	mov    (%r14),%ecx
  6d2777:	cmp    $0xffffffff,%ecx
  6d277a:	mov    %rcx,0x58(%rsp)
  6d277f:	je     6d27c6 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x496>
  6d2781:	movss  0x4(%r14),%xmm1
  6d2787:	dec    %ecx
  6d2789:	mov    %ecx,0x74(%rsp)
  6d278d:	movss  %xmm1,0x78(%rsp)
  6d2793:	movd   %ecx,%xmm0
  6d2797:	mov    $0x1,%ecx
  6d279c:	jmp    6d27c8 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x498>
  6d279e:	mov    0x40(%rsp),%rax
  6d27a3:	mov    %rax,0x30(%rbx)
  6d27a7:	movups 0x10(%rsp),%xmm0
  6d27ac:	movups 0x20(%rsp),%xmm1
  6d27b1:	movups 0x30(%rsp),%xmm2
  6d27b6:	movups %xmm2,0x20(%rbx)
  6d27ba:	movups %xmm1,0x10(%rbx)
  6d27be:	movups %xmm0,(%rbx)
  6d27c1:	jmp    6d2977 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x647>
  6d27c6:	xor    %ecx,%ecx
  6d27c8:	mov    %ecx,0x70(%rsp)
  6d27cc:	movzbl 0x743(%r15),%edx
  6d27d4:	xor    $0x1,%dl
  6d27d7:	and    0x742(%r15),%dl
  6d27de:	and    0x744(%r15),%dl
  6d27e5:	mov    0x5b0(%r15),%rsi
  6d27ec:	cmp    $0xffffffffffffffff,%rsi
  6d27f0:	sete   %dil
  6d27f4:	and    %dl,%dil
  6d27f7:	cmp    $0x1,%dil
  6d27fb:	jne    6d2881 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x551>
  6d2801:	mov    0x688(%r15),%rax
  6d2808:	cmp    0x690(%r15),%rax
  6d280f:	jne    6d28c1 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x591>
  6d2815:	mov    0x6a0(%r15),%rax
  6d281c:	cmp    0x698(%r15),%rax
  6d2823:	jne    6d28c1 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x591>
  6d2829:	movss  0x738(%r15),%xmm2
  6d2832:	ucomiss 0x73c(%r15),%xmm2
  6d283a:	jne    6d28c1 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x591>
  6d2840:	jp     6d28c1 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x591>
  6d2842:	test   %ecx,%ecx
  6d2844:	je     6d2aaf <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x77f>
  6d284a:	mov    0x638(%r15),%rax
  6d2851:	test   %rax,%rax
  6d2854:	je     6d2a87 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x757>
  6d285a:	mov    0xd8(%rax),%rax
  6d2861:	test   %rax,%rax
  6d2864:	je     6d2a87 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x757>
  6d286a:	cmpb   $0x0,0x12(%rax)
  6d286e:	je     6d2a87 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x757>
  6d2874:	mov    %r15,%rdi
  6d2877:	call   6dc0d0 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE14inspector_pickB10_>
  6d287c:	jmp    6d2aa3 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x773>
  6d2881:	cmp    $0xffffffffffffffff,%rsi
  6d2885:	sete   %cl
  6d2888:	movq   $0x12,0x10(%rsp)
  6d2891:	xor    $0x1,%dl
  6d2894:	or     %cl,%dl
  6d2896:	jne    6d28c1 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x591>
  6d2898:	mov    0x6a0(%r15),%rcx
  6d289f:	cmp    0x698(%r15),%rcx
  6d28a6:	jne    6d28c1 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x591>
  6d28a8:	movss  0x738(%r15),%xmm0
  6d28b1:	ucomiss 0x73c(%r15),%xmm0
  6d28b9:	jne    6d28c1 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x591>
  6d28bb:	jnp    6d29bb <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x68b>
  6d28c1:	movq   $0x12,(%rbx)
  6d28c8:	jmp    6d2977 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x647>
  6d28cd:	cmp    $0xd,%rax
  6d28d1:	jl     6d28f3 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x5c3>
  6d28d3:	cmp    $0x21,%rax
  6d28d7:	je     6d28f3 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x5c3>
  6d28d9:	cmp    $0x26,%rax
  6d28dd:	jne    6d2916 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x5e6>
  6d28df:	mov    0x78(%rsp),%rsi
  6d28e4:	test   %rsi,%rsi
  6d28e7:	je     6d2916 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x5e6>
  6d28e9:	lea    0x80(%rsp),%rax
  6d28f1:	jmp    6d2908 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x5d8>
  6d28f3:	mov    0x88(%rsp),%rsi
  6d28fb:	test   %rsi,%rsi
  6d28fe:	je     6d2916 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x5e6>
  6d2900:	lea    0x90(%rsp),%rax
  6d2908:	mov    (%rax),%rdi
  6d290b:	mov    $0x1,%edx
  6d2910:	call   *0x346c2a(%rip)        # a19540 <_DYNAMIC+0x240>
  6d2916:	movq   $0x0,0x8(%r14)
  6d291e:	movups 0x688(%r15),%xmm0
  6d2926:	movzbl 0x744(%r15),%eax
  6d292e:	cmpq   $0x0,0x6a8(%r15)
  6d2936:	je     6d2946 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x616>
  6d2938:	test   %al,%al
  6d293a:	je     6d294a <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x61a>
  6d293c:	cmpq   $0xffffffffffffffff,0x5b0(%r15)
  6d2944:	jne    6d294a <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x61a>
  6d2946:	xor    %ecx,%ecx
  6d2948:	jmp    6d2956 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x626>
  6d294a:	mov    0x6b8(%r15),%rdx
  6d2951:	mov    $0x1,%ecx
  6d2956:	mov    0x730(%r15),%rsi
  6d295d:	mov    %rcx,0x8(%rbx)
  6d2961:	mov    %rdx,0x10(%rbx)
  6d2965:	movups %xmm0,0x18(%rbx)
  6d2969:	mov    %rsi,0x28(%rbx)
  6d296d:	mov    %al,0x30(%rbx)
  6d2970:	movq   $0xfffffffffffffffe,(%rbx)
  6d2977:	add    $0xb8,%rsp
  6d297e:	pop    %rbx
  6d297f:	pop    %r12
  6d2981:	pop    %r13
  6d2983:	pop    %r14
  6d2985:	pop    %r15
  6d2987:	pop    %rbp
  6d2988:	ret
  6d2989:	lea    0x70(%rsp),%rdi
  6d298e:	call   6b91e0 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtB4_6result6ResultNtNtCs6ZNK6sH19NW_4gpui7runtime6CommitNtBZ_5ErrorEECs4gijoeCAvqI_25inspector_pointer_control>
  6d2993:	jmp    6d291e <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x5ee>
  6d2995:	xor    %eax,%eax
  6d2997:	mov    %eax,0x10(%rsp)
  6d299b:	lea    0x10(%rsp),%rsi
  6d29a0:	mov    %r15,%rdi
  6d29a3:	call   6daec0 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE11pointer_hitBW_>
  6d29a8:	mov    %rax,0x60(%rsp)
  6d29ad:	mov    %rdx,0x8(%rsp)
  6d29b2:	mov    0x54(%rsp),%ecx
  6d29b6:	jmp    6d2aba <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x78a>
  6d29bb:	mov    0x690(%r15),%rcx
  6d29c2:	cmp    $0xffffffffffffffff,%rcx
  6d29c6:	je     6d28c1 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x591>
  6d29cc:	inc    %rcx
  6d29cf:	mov    0x688(%r15),%rdx
  6d29d6:	cmp    %rdx,%rcx
  6d29d9:	jne    6d28c1 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x591>
  6d29df:	cmp    %rdx,0x6b8(%r15)
  6d29e6:	jne    6d28c1 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x591>
  6d29ec:	test   %rax,%rax
  6d29ef:	je     6d28c1 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x591>
  6d29f5:	cmpq   $0x0,0x6a8(%r15)
  6d29fd:	je     6d28c1 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x591>
  6d2a03:	cmp    %rax,0x6b0(%r15)
  6d2a0a:	jne    6d28c1 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x591>
  6d2a10:	cmp    0x5d8(%r15),%r12
  6d2a17:	jne    6d28c1 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x591>
  6d2a1d:	lea    0x70(%rsp),%rsi
  6d2a22:	mov    %r15,%rdi
  6d2a25:	call   6daec0 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE11pointer_hitBW_>
  6d2a2a:	mov    %rax,0x60(%rsp)
  6d2a2f:	mov    %rdx,0x8(%rsp)
  6d2a34:	mov    0x638(%r15),%rax
  6d2a3b:	test   %rax,%rax
  6d2a3e:	je     6d2a7b <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x74b>
  6d2a40:	cmpq   $0x0,0xd8(%rax)
  6d2a48:	je     6d2a7b <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x74b>
  6d2a4a:	cmp    %r12,0x60(%rsp)
  6d2a4f:	jne    6d28c1 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x591>
  6d2a55:	cmp    %r13,0x8(%rsp)
  6d2a5a:	jne    6d28c1 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x591>
  6d2a60:	lea    0x70(%rsp),%rcx
  6d2a65:	mov    %r15,%rdi
  6d2a68:	mov    %r12,%rsi
  6d2a6b:	mov    %r13,%rdx
  6d2a6e:	call   6daff0 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19inspector_focus_hitBW_>
  6d2a73:	test   %al,%al
  6d2a75:	je     6d28c1 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x591>
  6d2a7b:	lea    0x10(%rsp),%rdi
  6d2a80:	call   6be360 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueNtNtCs6ZNK6sH19NW_4gpui7runtime5ErrorECs4gijoeCAvqI_25inspector_pointer_control>
  6d2a85:	jmp    6d2ab8 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x788>
  6d2a87:	mov    %r15,%rdi
  6d2a8a:	call   6f8800 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_>
  6d2a8f:	test   $0x1,%al
  6d2a91:	je     6d2aaf <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x77f>
  6d2a93:	lea    0x5d8(%r15),%rdi
  6d2a9a:	mov    %rdx,%rsi
  6d2a9d:	call   *0x346cbd(%rip)        # a19760 <_DYNAMIC+0x460>
  6d2aa3:	mov    %rax,0x60(%rsp)
  6d2aa8:	mov    %rdx,0x8(%rsp)
  6d2aad:	jmp    6d2ab8 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x788>
  6d2aaf:	movq   $0x0,0x60(%rsp)
  6d2ab8:	xor    %ecx,%ecx
  6d2aba:	mov    0x638(%r15),%rax
  6d2ac1:	test   %rax,%rax
  6d2ac4:	je     6d2ad8 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x7a8>
  6d2ac6:	mov    0xd8(%rax),%rax
  6d2acd:	test   %rax,%rax
  6d2ad0:	je     6d2ad8 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x7a8>
  6d2ad2:	movzbl 0x12(%rax),%eax
  6d2ad6:	jmp    6d2ada <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x7aa>
  6d2ad8:	xor    %eax,%eax
  6d2ada:	cmp    $0x2,%ebp
  6d2add:	jne    6d2bc2 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x892>
  6d2ae3:	mov    0x610(%r15),%rdx
  6d2aea:	mov    0x618(%r15),%rcx
  6d2af1:	mov    0x60(%rsp),%rbp
  6d2af6:	test   %rbp,%rbp
  6d2af9:	sete   %sil
  6d2afd:	or     %al,%sil
  6d2b00:	test   $0x1,%sil
  6d2b04:	je     6d2c0a <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x8da>
  6d2b0a:	movq   $0x0,0x610(%r15)
  6d2b15:	lea    0x10(%rsp),%rdi
  6d2b1a:	mov    %r15,%rsi
  6d2b1d:	call   6dbe20 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime7editingINtB7_10RuntimeMutNtCs4gijoeCAvqI_25inspector_pointer_control5ModeluE20publish_focus_changeB12_>
  6d2b22:	mov    0x10(%rsp),%rax
  6d2b27:	movups 0x18(%rsp),%xmm0
  6d2b2c:	movaps %xmm0,0x70(%rsp)
  6d2b31:	movups 0x28(%rsp),%xmm0
  6d2b36:	movaps %xmm0,0x80(%rsp)
  6d2b3e:	movups 0x38(%rsp),%xmm0
  6d2b43:	movaps %xmm0,0x90(%rsp)
  6d2b4b:	cmp    $0xfffffffffffffffe,%rax
  6d2b4f:	jne    6d2cfb <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x9cb>
  6d2b55:	movaps 0x70(%rsp),%xmm0
  6d2b5a:	movaps 0x80(%rsp),%xmm1
  6d2b62:	movaps 0x90(%rsp),%xmm2
  6d2b6a:	movaps %xmm2,0x30(%rsp)
  6d2b6f:	movaps %xmm1,0x20(%rsp)
  6d2b74:	movaps %xmm0,0x10(%rsp)
  6d2b79:	cmpq   $0xffffffffffffffff,0x5b0(%r15)
  6d2b81:	je     6d2d50 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xa20>
  6d2b87:	mov    0x690(%r15),%rax
  6d2b8e:	cmp    $0xffffffffffffffff,%rax
  6d2b92:	je     6d2d50 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xa20>
  6d2b98:	inc    %rax
  6d2b9b:	cmp    0x688(%r15),%rax
  6d2ba2:	jne    6d2d50 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xa20>
  6d2ba8:	cmpq   $0x0,0x6a8(%r15)
  6d2bb0:	je     6d2d50 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xa20>
  6d2bb6:	mov    0x6b0(%r15),%rax
  6d2bbd:	jmp    6d2d52 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xa22>
  6d2bc2:	test   %cl,%cl
  6d2bc4:	mov    0x60(%rsp),%rcx
  6d2bc9:	jne    6d291e <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x5ee>
  6d2bcf:	test   %rcx,%rcx
  6d2bd2:	je     6d291e <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x5ee>
  6d2bd8:	cmp    %rcx,%r12
  6d2bdb:	jne    6d291e <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x5ee>
  6d2be1:	cmp    0x8(%rsp),%r13
  6d2be6:	jne    6d291e <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x5ee>
  6d2bec:	test   %al,%al
  6d2bee:	je     6d2d85 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xa55>
  6d2bf4:	mov    %rbx,%rdi
  6d2bf7:	mov    %r15,%rsi
  6d2bfa:	mov    %r12,%rdx
  6d2bfd:	mov    %r13,%rcx
  6d2c00:	call   6df6f0 <_RNvMs4_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_10RuntimeMutNtCs4gijoeCAvqI_25inspector_pointer_control5ModeluE16inspector_selectB14_>
  6d2c05:	jmp    6d2977 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x647>
  6d2c0a:	cmp    0x5d8(%r15),%rbp
  6d2c11:	jne    6d2d24 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x9f4>
  6d2c17:	mov    %rcx,%r12
  6d2c1a:	mov    %rdx,%r13
  6d2c1d:	lea    0x10(%rsp),%rdi
  6d2c22:	mov    %r15,%rsi
  6d2c25:	mov    0x8(%rsp),%rdx
  6d2c2a:	call   6f8520 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE16resolve_identityBO_>
  6d2c2f:	mov    0x10(%rsp),%rax
  6d2c34:	mov    0x18(%rsp),%rdi
  6d2c39:	cmp    $0xfffffffffffffffe,%rax
  6d2c3d:	jne    6d2d29 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x9f9>
  6d2c43:	mov    0x2c8(%r15),%rsi
  6d2c4a:	cmp    %rsi,%rdi
  6d2c4d:	jae    6d2fab <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xc7b>
  6d2c53:	mov    0x2c0(%r15),%rax
  6d2c5a:	lea    (%rdi,%rdi,4),%rcx
  6d2c5e:	mov    0x20(%rax,%rcx,8),%edi
  6d2c62:	call   6e1fb0 <_RNvMsh_NtCs6ZNK6sH19NW_4gpui7runtimeNtB5_4Node4kind>
  6d2c67:	cmp    $0x4,%al
  6d2c69:	jne    6d2e88 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xb58>
  6d2c6f:	mov    0x58(%rsp),%rax
  6d2c74:	cmp    $0xffffffff,%eax
  6d2c77:	je     6d2fb8 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xc88>
  6d2c7d:	movss  0x4(%r14),%xmm1
  6d2c83:	dec    %eax
  6d2c85:	movd   %eax,%xmm0
  6d2c89:	lea    0x10(%rsp),%rdi
  6d2c8e:	mov    %r15,%rsi
  6d2c91:	mov    %rbp,%rdx
  6d2c94:	mov    0x8(%rsp),%r15
  6d2c99:	mov    %r15,%rcx
  6d2c9c:	xor    %r8d,%r8d
  6d2c9f:	call   6db800 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime7editingINtB7_10RuntimeMutNtCs4gijoeCAvqI_25inspector_pointer_control5ModeluE14select_pointerB12_>
  6d2ca4:	mov    0x10(%rsp),%rax
  6d2ca9:	movups 0x38(%rsp),%xmm0
  6d2cae:	movaps %xmm0,0x90(%rsp)
  6d2cb6:	movdqu 0x28(%rsp),%xmm1
  6d2cbc:	movdqa %xmm1,0x80(%rsp)
  6d2cc5:	movups 0x18(%rsp),%xmm2
  6d2cca:	movaps %xmm2,0x70(%rsp)
  6d2ccf:	movups %xmm0,0x28(%rbx)
  6d2cd3:	movdqu %xmm1,0x18(%rbx)
  6d2cd8:	movups %xmm2,0x8(%rbx)
  6d2cdc:	cmp    $0xfffffffffffffffe,%rax
  6d2ce0:	jne    6d2eec <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xbbc>
  6d2ce6:	mov    %rbp,0x8(%r14)
  6d2cea:	mov    %r15,0x10(%r14)
  6d2cee:	movq   $0x0,0x18(%r14)
  6d2cf6:	jmp    6d2970 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x640>
  6d2cfb:	movaps 0x70(%rsp),%xmm0
  6d2d00:	movaps 0x80(%rsp),%xmm1
  6d2d08:	movaps 0x90(%rsp),%xmm2
  6d2d10:	movups %xmm2,0x28(%rbx)
  6d2d14:	movups %xmm1,0x18(%rbx)
  6d2d18:	movups %xmm0,0x8(%rbx)
  6d2d1c:	mov    %rax,(%rbx)
  6d2d1f:	jmp    6d2977 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x647>
  6d2d24:	mov    $0x11,%eax
  6d2d29:	mov    0x40(%rsp),%rcx
  6d2d2e:	mov    %rcx,0x30(%rbx)
  6d2d32:	movups 0x20(%rsp),%xmm0
  6d2d37:	movups 0x30(%rsp),%xmm1
  6d2d3c:	movups %xmm1,0x20(%rbx)
  6d2d40:	movups %xmm0,0x10(%rbx)
  6d2d44:	mov    %rax,(%rbx)
  6d2d47:	mov    %rdi,0x8(%rbx)
  6d2d4b:	jmp    6d2977 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x647>
  6d2d50:	xor    %eax,%eax
  6d2d52:	mov    %rbp,0x8(%r14)
  6d2d56:	mov    0x8(%rsp),%rcx
  6d2d5b:	mov    %rcx,0x10(%r14)
  6d2d5f:	mov    %rax,0x18(%r14)
  6d2d63:	movaps 0x10(%rsp),%xmm0
  6d2d68:	movdqa 0x20(%rsp),%xmm1
  6d2d6e:	movaps 0x30(%rsp),%xmm2
  6d2d73:	movups %xmm2,0x28(%rbx)
  6d2d77:	movdqu %xmm1,0x18(%rbx)
  6d2d7c:	movups %xmm0,0x8(%rbx)
  6d2d80:	jmp    6d2970 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x640>
  6d2d85:	movq   $0x0,0x10(%rsp)
  6d2d8e:	lea    0xa8(%rsp),%rsi
  6d2d96:	lea    0x10(%rsp),%r8
  6d2d9b:	mov    %rbx,%rdi
  6d2d9e:	mov    %r12,%rdx
  6d2da1:	mov    %r13,%rcx
  6d2da4:	call   6d6150 <_RNvMNtNtCs6ZNK6sH19NW_4gpui7runtime4turnINtB4_10RuntimeMutNtCs4gijoeCAvqI_25inspector_pointer_control5ModeluE21activate_with_editingBW_>
  6d2da9:	jmp    6d2977 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x647>
  6d2dae:	movq   $0x4,0x70(%rsp)
  6d2db7:	pxor   %xmm0,%xmm0
  6d2dbb:	movdqu %xmm0,0x78(%rsp)
  6d2dc1:	mov    0x5a8(%r14),%rax
  6d2dc8:	mov    %rax,0x8(%rsp)
  6d2dcd:	test   %rax,%rax
  6d2dd0:	je     6d2f68 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xc38>
  6d2dd6:	mov    0x5a0(%r14),%rbp
  6d2ddd:	mov    0x8(%rsp),%rax
  6d2de2:	mov    %rax,%r15
  6d2de5:	shl    $0x6,%r15
  6d2de9:	lea    -0x1(%rax),%r12
  6d2ded:	jmp    6d2e53 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xb23>
  6d2def:	mov    0x80(%rsp),%rax
  6d2df7:	mov    %rax,0x20(%rsp)
  6d2dfc:	movups 0x70(%rsp),%xmm0
  6d2e01:	movaps %xmm0,0x10(%rsp)
  6d2e06:	mov    0x638(%r14),%rax
  6d2e0d:	test   %rax,%rax
  6d2e10:	je     6d2e84 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xb54>
  6d2e12:	cmpq   $0x0,(%rax)
  6d2e16:	setne  %al
  6d2e19:	movzbl %al,%ecx
  6d2e1c:	mov    %rbp,%rdi
  6d2e1f:	mov    0x8(%rsp),%rsi
  6d2e24:	lea    0x10(%rsp),%rdx
  6d2e29:	mov    %r12,%r8
  6d2e2c:	movd   0x54(%rsp),%xmm0
  6d2e32:	movss  0x58(%rsp),%xmm1
  6d2e38:	call   *0x3469b2(%rip)        # a197f0 <_DYNAMIC+0x4f0>
  6d2e3e:	test   %al,%al
  6d2e40:	jne    6d2ef4 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xbc4>
  6d2e46:	dec    %r12
  6d2e49:	add    $0xffffffffffffffc0,%r15
  6d2e4d:	je     6d2f68 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xc38>
  6d2e53:	cmpb   $0x0,-0x2(%rbp,%r15,1)
  6d2e59:	jne    6d2def <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xabf>
  6d2e5b:	movzbl -0x3(%rbp,%r15,1),%eax
  6d2e61:	sub    $0x2,%al
  6d2e63:	movzbl %al,%eax
  6d2e66:	mov    $0x8,%ecx
  6d2e6b:	cmovb  %ecx,%eax
  6d2e6e:	cmp    $0x7,%al
  6d2e70:	je     6d2def <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xabf>
  6d2e76:	movzbl %al,%eax
  6d2e79:	cmp    $0x4,%eax
  6d2e7c:	je     6d2def <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xabf>
  6d2e82:	jmp    6d2e46 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xb16>
  6d2e84:	xor    %eax,%eax
  6d2e86:	jmp    6d2e19 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xae9>
  6d2e88:	lea    0x10(%rsp),%rdi
  6d2e8d:	mov    %r15,%rsi
  6d2e90:	mov    %rbp,%rdx
  6d2e93:	mov    0x8(%rsp),%rcx
  6d2e98:	call   6db480 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE5focusBW_>
  6d2e9d:	mov    0x10(%rsp),%rax
  6d2ea2:	cmp    $0xfffffffffffffffe,%rax
  6d2ea6:	jne    6d2eb3 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xb83>
  6d2ea8:	mov    %r13,%rdx
  6d2eab:	mov    %r12,%rcx
  6d2eae:	jmp    6d2b15 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x7e5>
  6d2eb3:	mov    0x38(%rsp),%rcx
  6d2eb8:	movzbl 0x40(%rsp),%edx
  6d2ebd:	mov    0x44(%rsp),%esi
  6d2ec1:	mov    %esi,0x34(%rbx)
  6d2ec4:	mov    0x41(%rsp),%esi
  6d2ec8:	mov    %esi,0x31(%rbx)
  6d2ecb:	movups 0x18(%rsp),%xmm0
  6d2ed0:	movups 0x28(%rsp),%xmm1
  6d2ed5:	mov    %rax,(%rbx)
  6d2ed8:	movups %xmm0,0x8(%rbx)
  6d2edc:	movups %xmm1,0x18(%rbx)
  6d2ee0:	mov    %rcx,0x28(%rbx)
  6d2ee4:	mov    %dl,0x30(%rbx)
  6d2ee7:	jmp    6d2977 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x647>
  6d2eec:	mov    %rax,(%rbx)
  6d2eef:	jmp    6d2977 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x647>
  6d2ef4:	movq   $0x19,0x10(%rsp)
  6d2efd:	lea    0x10(%rsp),%rdi
  6d2f02:	call   6be360 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueNtNtCs6ZNK6sH19NW_4gpui7runtime5ErrorECs4gijoeCAvqI_25inspector_pointer_control>
  6d2f07:	mov    %r12,0xb0(%rsp)
  6d2f0f:	movq   $0x1,0xa8(%rsp)
  6d2f1b:	lea    0xa8(%rsp),%rdi
  6d2f23:	mov    %r14,%rsi
  6d2f26:	mov    %r14,%rdx
  6d2f29:	call   6ce040 <_RINvYINtNtNtNtCs4NRVxsYgnAr_4core4iter7sources7from_fn6FromFnNCNvMs6_NtNtCs6ZNK6sH19NW_4gpui7runtime6scrollINtB17_3WinNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE12scroll_at_2ds0_0ENtNtNtBa_6traits8iterator8Iterator8try_folduNCINvNvB2Z_3any5checkjNCBZ_s1_0E0INtNtNtBc_3ops12control_flow11ControlFlowuEEB1U_>
  6d2f2e:	test   %al,%al
  6d2f30:	je     6d2f68 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xc38>
  6d2f32:	movq   $0x1,0x18(%rsp)
  6d2f3b:	mov    %r12,0x20(%rsp)
  6d2f40:	movaps 0x60(%rsp),%xmm0
  6d2f45:	movups %xmm0,0x28(%rsp)
  6d2f4a:	movq   $0x3,0x10(%rsp)
  6d2f53:	lea    0x10(%rsp),%rdx
  6d2f58:	mov    %rbx,%rdi
  6d2f5b:	mov    %r13,%rsi
  6d2f5e:	call   6e1010 <_RNvMs6_NtNtCs6ZNK6sH19NW_4gpui7runtime6scrollINtB7_3WinNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE17apply_scroll_planBT_>
  6d2f63:	jmp    6d2977 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x647>
  6d2f68:	movq   $0x19,(%rbx)
  6d2f6f:	jmp    6d2977 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x647>
  6d2f74:	lea    -0x685dd2(%rip),%rdi        # 4d1a9 <GCC_except_table0+0xfa75>
  6d2f7b:	lea    0x327a46(%rip),%rdx        # 9fa9c8 <__frame_dummy_init_array_entry+0xe98>
  6d2f82:	mov    $0x22,%esi
  6d2f87:	call   *0x34675b(%rip)        # a196e8 <_DYNAMIC+0x3e8>
  6d2f8d:	lea    0x327a4c(%rip),%rdx        # 9fa9e0 <__frame_dummy_init_array_entry+0xeb0>
  6d2f94:	call   *0x3465d6(%rip)        # a19570 <_DYNAMIC+0x270>
  6d2f9a:	jmp    6d2fa9 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xc79>
  6d2f9c:	lea    0x327a55(%rip),%rdi        # 9fa9f8 <__frame_dummy_init_array_entry+0xec8>
  6d2fa3:	call   *0x34662f(%rip)        # a195d8 <_DYNAMIC+0x2d8>
  6d2fa9:	ud2
  6d2fab:	lea    0x327a5e(%rip),%rdx        # 9faa10 <__frame_dummy_init_array_entry+0xee0>
  6d2fb2:	call   *0x3465b8(%rip)        # a19570 <_DYNAMIC+0x270>
  6d2fb8:	lea    0x327a69(%rip),%rdi        # 9faa28 <__frame_dummy_init_array_entry+0xef8>
  6d2fbf:	call   *0x346613(%rip)        # a195d8 <_DYNAMIC+0x2d8>
  6d2fc5:	mov    %rax,%rbx
  6d2fc8:	lea    0x10(%rsp),%rdi
  6d2fcd:	call   6be360 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueNtNtCs6ZNK6sH19NW_4gpui7runtime5ErrorECs4gijoeCAvqI_25inspector_pointer_control>
  6d2fd2:	mov    %rbx,%rdi
  6d2fd5:	call   9f8780 <_Unwind_Resume@plt>
  6d2fda:	mov    %rax,%rbx
  6d2fdd:	lea    0x70(%rsp),%rdi
  6d2fe2:	call   6b91e0 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtB4_6result6ResultNtNtCs6ZNK6sH19NW_4gpui7runtime6CommitNtBZ_5ErrorEECs4gijoeCAvqI_25inspector_pointer_control>
  6d2fe7:	mov    %rbx,%rdi
  6d2fea:	call   9f8780 <_Unwind_Resume@plt>

/tmp/gpui-inspector-pointer-codegen-optin/candidate-frozen:     file format elf64-x86-64


Disassembly of section .text:

00000000006d2ff0 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8hit_only>:
  6d2ff0:	test   %rsi,%rsi
  6d2ff3:	je     6d3006 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8hit_only+0x16>
  6d2ff5:	cmpb   $0x0,0x746(%rsi)
  6d2ffc:	je     6d3016 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8hit_only+0x26>
  6d2ffe:	movq   $0xe,(%rdi)
  6d3005:	ret
  6d3006:	movq   $0xd,(%rdi)
  6d300d:	movq   $0x0,0x8(%rdi)
  6d3015:	ret
  6d3016:	cmpb   $0x1,0x742(%rsi)
  6d301d:	jne    6d309b <_RNvCs4gijoeCAvqI_25inspector_pointer_control8hit_only+0xab>
  6d301f:	cmpb   $0x0,0x743(%rsi)
  6d3026:	jne    6d309b <_RNvCs4gijoeCAvqI_25inspector_pointer_control8hit_only+0xab>
  6d3028:	cmpb   $0x0,0x744(%rsi)
  6d302f:	je     6d309b <_RNvCs4gijoeCAvqI_25inspector_pointer_control8hit_only+0xab>
  6d3031:	cmpq   $0xffffffffffffffff,0x5b0(%rsi)
  6d3039:	jne    6d309b <_RNvCs4gijoeCAvqI_25inspector_pointer_control8hit_only+0xab>
  6d303b:	mov    0x688(%rsi),%rax
  6d3042:	cmp    0x690(%rsi),%rax
  6d3049:	jne    6d309b <_RNvCs4gijoeCAvqI_25inspector_pointer_control8hit_only+0xab>
  6d304b:	mov    0x6a0(%rsi),%rax
  6d3052:	cmp    0x698(%rsi),%rax
  6d3059:	jne    6d309b <_RNvCs4gijoeCAvqI_25inspector_pointer_control8hit_only+0xab>
  6d305b:	movss  0x738(%rsi),%xmm2
  6d3063:	ucomiss 0x73c(%rsi),%xmm2
  6d306a:	jne    6d309b <_RNvCs4gijoeCAvqI_25inspector_pointer_control8hit_only+0xab>
  6d306c:	jp     6d309b <_RNvCs4gijoeCAvqI_25inspector_pointer_control8hit_only+0xab>
  6d306e:	push   %r14
  6d3070:	push   %rbx
  6d3071:	push   %rax
  6d3072:	mov    %rdi,%rbx
  6d3075:	mov    %rsi,%r14
  6d3078:	mov    %rsi,%rdi
  6d307b:	call   6f8800 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_>
  6d3080:	cmp    $0x1,%rax
  6d3084:	jne    6d30a3 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8hit_only+0xb3>
  6d3086:	mov    %r14,%rdi
  6d3089:	add    $0x5d8,%rdi
  6d3090:	mov    %rdx,%rsi
  6d3093:	call   *0x3466c7(%rip)        # a19760 <_DYNAMIC+0x460>
  6d3099:	jmp    6d30a5 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8hit_only+0xb5>
  6d309b:	movq   $0x12,(%rdi)
  6d30a2:	ret
  6d30a3:	xor    %eax,%eax
  6d30a5:	mov    %rax,0x8(%rbx)
  6d30a9:	mov    %rdx,0x10(%rbx)
  6d30ad:	movq   $0xfffffffffffffffe,(%rbx)
  6d30b4:	add    $0x8,%rsp
  6d30b8:	pop    %rbx
  6d30b9:	pop    %r14
  6d30bb:	ret

/tmp/gpui-inspector-pointer-codegen-optin/candidate-frozen:     file format elf64-x86-64


Disassembly of section .text:

00000000006daec0 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE11pointer_hitBW_>:
  6daec0:	cmpl   $0x1,(%rsi)
  6daec3:	jne    6daef5 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE11pointer_hitBW_+0x35>
  6daec5:	push   %rbx
  6daec6:	movss  0x4(%rsi),%xmm0
  6daecb:	movss  0x8(%rsi),%xmm1
  6daed0:	mov    0x638(%rdi),%rax
  6daed7:	test   %rax,%rax
  6daeda:	je     6daef8 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE11pointer_hitBW_+0x38>
  6daedc:	mov    0xd8(%rax),%rax
  6daee3:	test   %rax,%rax
  6daee6:	je     6daef8 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE11pointer_hitBW_+0x38>
  6daee8:	cmpb   $0x0,0x12(%rax)
  6daeec:	je     6daef8 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE11pointer_hitBW_+0x38>
  6daeee:	call   6dc0d0 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE14inspector_pickB10_>
  6daef3:	pop    %rbx
  6daef4:	ret
  6daef5:	xor    %eax,%eax
  6daef7:	ret
  6daef8:	mov    %rdi,%rbx
  6daefb:	call   6f8800 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_>
  6daf00:	test   $0x1,%al
  6daf02:	je     6daf19 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE11pointer_hitBW_+0x59>
  6daf04:	mov    %rbx,%rdi
  6daf07:	add    $0x5d8,%rdi
  6daf0e:	mov    %rdx,%rsi
  6daf11:	call   *0x33e849(%rip)        # a19760 <_DYNAMIC+0x460>
  6daf17:	pop    %rbx
  6daf18:	ret
  6daf19:	xor    %eax,%eax
  6daf1b:	pop    %rbx
  6daf1c:	ret

/tmp/gpui-inspector-pointer-codegen-optin/candidate-frozen:     file format elf64-x86-64


Disassembly of section .text:

00000000006daff0 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19inspector_focus_hitBW_>:
  6daff0:	push   %rbp
  6daff1:	push   %r15
  6daff3:	push   %r14
  6daff5:	push   %r13
  6daff7:	push   %r12
  6daff9:	push   %rbx
  6daffa:	sub    $0x78,%rsp
  6daffe:	cmpl   $0x1,(%rcx)
  6db001:	jne    6db445 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19inspector_focus_hitBW_+0x455>
  6db007:	mov    %rdi,%rbx
  6db00a:	mov    %rsi,%r12
  6db00d:	mov    %rdx,0x38(%rsp)
  6db012:	movss  0x4(%rcx),%xmm0
  6db017:	movss  0x8(%rcx),%xmm1
  6db01c:	movq   $0x0,0x40(%rsp)
  6db025:	movsd  0x698(%rdi),%xmm2
  6db02d:	xorpd  %xmm3,%xmm3
  6db031:	unpcklps %xmm3,%xmm2
  6db034:	movapd -0x69c7dc(%rip),%xmm3        # 3e860 <GCC_except_table0+0x112c>
  6db03c:	orpd   %xmm3,%xmm2
  6db040:	subpd  %xmm3,%xmm2
  6db044:	cvtpd2ps %xmm2,%xmm2
  6db048:	movlpd %xmm2,0x48(%rsp)
  6db04e:	lea    0x40(%rsp),%rdi
  6db053:	movss  %xmm0,0xc(%rsp)
  6db059:	movss  %xmm1,0x8(%rsp)
  6db05f:	call   *0x33e743(%rip)        # a197a8 <_DYNAMIC+0x4a8>
  6db065:	test   %al,%al
  6db067:	je     6db445 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19inspector_focus_hitBW_+0x455>
  6db06d:	cmpq   $0xffffffffffffffff,0x5b0(%rbx)
  6db075:	setne  %al
  6db078:	movzwl 0x5d0(%rbx),%ebp
  6db07f:	test   %bp,%bp
  6db082:	setns  %cl
  6db085:	and    %al,%cl
  6db087:	cmp    $0x1,%cl
  6db08a:	jne    6db445 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19inspector_focus_hitBW_+0x455>
  6db090:	mov    0x638(%rbx),%r13
  6db097:	test   %r13,%r13
  6db09a:	je     6db445 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19inspector_focus_hitBW_+0x455>
  6db0a0:	mov    0x60(%r13),%r14
  6db0a4:	cmp    $0xffffffffffffffff,%r14
  6db0a8:	je     6db445 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19inspector_focus_hitBW_+0x455>
  6db0ae:	mov    0x100(%r13),%rsi
  6db0b5:	test   %rsi,%rsi
  6db0b8:	je     6db0de <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19inspector_focus_hitBW_+0xee>
  6db0ba:	lea    0x40(%rsp),%rdi
  6db0bf:	call   *0x33e84b(%rip)        # a19910 <_DYNAMIC+0x610>
  6db0c5:	mov    0x40(%rsp),%rax
  6db0ca:	test   %rax,%rax
  6db0cd:	je     6db445 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19inspector_focus_hitBW_+0x455>
  6db0d3:	movups 0x48(%rsp),%xmm0
  6db0d8:	mov    0x60(%r13),%r14
  6db0dc:	jmp    6db0e6 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19inspector_focus_hitBW_+0xf6>
  6db0de:	xorps  %xmm0,%xmm0
  6db0e1:	mov    $0x4,%eax
  6db0e6:	movzwl %bp,%ecx
  6db0e9:	mov    0x5b8(%rbx),%r15
  6db0f0:	mov    0x5c0(%rbx),%rsi
  6db0f7:	movzwl 0x5d2(%rbx),%edx
  6db0fe:	xorps  %xmm1,%xmm1
  6db101:	cvtsi2ss %edx,%xmm1
  6db105:	shl    $0x20,%rdx
  6db109:	or     %rcx,%rdx
  6db10c:	test   %r14,%r14
  6db10f:	mov    %r15,0x40(%rsp)
  6db114:	mov    %rsi,0x10(%rsp)
  6db119:	mov    %rsi,0x48(%rsp)
  6db11e:	mov    %rax,0x50(%rsp)
  6db123:	movups %xmm0,0x58(%rsp)
  6db128:	mov    %rdx,0x68(%rsp)
  6db12d:	setne  0x70(%rsp)
  6db132:	movswl %cx,%eax
  6db135:	xorps  %xmm0,%xmm0
  6db138:	cvtsi2ss %eax,%xmm0
  6db13c:	movq   $0x0,0x20(%rsp)
  6db145:	movss  %xmm0,0x18(%rsp)
  6db14b:	movss  %xmm0,0x28(%rsp)
  6db151:	movss  %xmm1,0x1c(%rsp)
  6db157:	movss  %xmm1,0x2c(%rsp)
  6db15d:	lea    0x20(%rsp),%rdi
  6db162:	movss  0xc(%rsp),%xmm0
  6db168:	movss  0x8(%rsp),%xmm1
  6db16e:	call   *0x33e634(%rip)        # a197a8 <_DYNAMIC+0x4a8>
  6db174:	test   %al,%al
  6db176:	je     6db445 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19inspector_focus_hitBW_+0x455>
  6db17c:	mov    0xd8(%r13),%rax
  6db183:	test   %rax,%rax
  6db186:	je     6db1c9 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19inspector_focus_hitBW_+0x1d9>
  6db188:	cmpb   $0x0,0x12(%rax)
  6db18c:	je     6db1c9 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19inspector_focus_hitBW_+0x1d9>
  6db18e:	lea    0x40(%rsp),%rsi
  6db193:	mov    %rbx,%rdi
  6db196:	movss  0xc(%rsp),%xmm0
  6db19c:	movss  0x8(%rsp),%xmm1
  6db1a2:	call   6dd630 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE23inspector_pick_in_sheetB10_>
  6db1a7:	test   %rax,%rax
  6db1aa:	je     6db445 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19inspector_focus_hitBW_+0x455>
  6db1b0:	cmp    %r12,%rax
  6db1b3:	mov    0x38(%rsp),%rax
  6db1b8:	jne    6db445 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19inspector_focus_hitBW_+0x455>
  6db1be:	cmp    %rax,%rdx
  6db1c1:	sete   %al
  6db1c4:	jmp    6db447 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19inspector_focus_hitBW_+0x457>
  6db1c9:	movq   $0x0,0x20(%rsp)
  6db1d2:	movss  0x18(%rsp),%xmm0
  6db1d8:	movss  %xmm0,0x28(%rsp)
  6db1de:	movss  0x1c(%rsp),%xmm0
  6db1e4:	movss  %xmm0,0x2c(%rsp)
  6db1ea:	lea    0x20(%rsp),%rdi
  6db1ef:	movss  0xc(%rsp),%xmm0
  6db1f5:	movss  0x8(%rsp),%xmm1
  6db1fb:	call   *0x33e5a7(%rip)        # a197a8 <_DYNAMIC+0x4a8>
  6db201:	mov    %eax,%ecx
  6db203:	xor    %eax,%eax
  6db205:	cmpq   $0x0,0x10(%rsp)
  6db20b:	je     6db447 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19inspector_focus_hitBW_+0x457>
  6db211:	test   %cl,%cl
  6db213:	je     6db447 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19inspector_focus_hitBW_+0x457>
  6db219:	mov    0x10(%rsp),%rax
  6db21e:	shl    $0x6,%rax
  6db222:	add    %r15,%rax
  6db225:	jmp    6db281 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19inspector_focus_hitBW_+0x291>
  6db227:	xor    %ecx,%ecx
  6db229:	test   %r14,%r14
  6db22c:	setne  %cl
  6db22f:	mov    %rbp,%r13
  6db232:	sub    %r15,%r13
  6db235:	shr    $0x6,%r13
  6db239:	lea    0x50(%rsp),%rdx
  6db23e:	mov    0x10(%rdx),%rax
  6db242:	mov    %rax,0x30(%rsp)
  6db247:	movups (%rdx),%xmm0
  6db24a:	movaps %xmm0,0x20(%rsp)
  6db24f:	mov    %r15,%rdi
  6db252:	mov    0x10(%rsp),%rsi
  6db257:	lea    0x20(%rsp),%rdx
  6db25c:	mov    %r13,%r8
  6db25f:	movss  0xc(%rsp),%xmm0
  6db265:	movss  0x8(%rsp),%xmm1
  6db26b:	call   *0x33e57f(%rip)        # a197f0 <_DYNAMIC+0x4f0>
  6db271:	test   %al,%al
  6db273:	jne    6db2c1 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19inspector_focus_hitBW_+0x2d1>
  6db275:	mov    %rbp,%rax
  6db278:	cmp    %rbp,%r15
  6db27b:	je     6db445 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19inspector_focus_hitBW_+0x455>
  6db281:	lea    -0x40(%rax),%rbp
  6db285:	cmpb   $0x0,-0x2(%rax)
  6db289:	jne    6db227 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19inspector_focus_hitBW_+0x237>
  6db28b:	mov    -0x8(%rax),%eax
  6db28e:	cmp    $0x3ffff,%rax
  6db294:	jbe    6db275 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19inspector_focus_hitBW_+0x285>
  6db296:	shr    $0x11,%eax
  6db299:	mov    %rbp,%rcx
  6db29c:	sub    %r15,%rcx
  6db29f:	shr    $0x6,%rcx
  6db2a3:	mov    $0x2,%edx
  6db2a8:	sub    %rax,%rdx
  6db2ab:	add    $0xfffffffffffffffe,%rax
  6db2af:	shl    $0x6,%rdx
  6db2b3:	cmp    %rcx,%rax
  6db2b6:	lea    -0x40(%rbp,%rdx,1),%rbp
  6db2bb:	cmovae %r15,%rbp
  6db2bf:	jmp    6db275 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19inspector_focus_hitBW_+0x285>
  6db2c1:	mov    0x1e8(%rbx),%rcx
  6db2c8:	mov    0x1f0(%rbx),%rdx
  6db2cf:	mov    0x1f8(%rbx),%r8
  6db2d6:	mov    0x2c8(%rbx),%rsi
  6db2dd:	mov    0x2c0(%rbx),%r9
  6db2e4:	jmp    6db2fe <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19inspector_focus_hitBW_+0x30e>
  6db2e6:	mov    0x38(%r10),%r13d
  6db2ea:	and    $0x1ffff,%r13d
  6db2f1:	cmp    $0x1ffff,%r13
  6db2f8:	je     6db445 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19inspector_focus_hitBW_+0x455>
  6db2fe:	cmp    0x10(%rsp),%r13
  6db303:	jae    6db456 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19inspector_focus_hitBW_+0x466>
  6db309:	shl    $0x6,%r13
  6db30d:	lea    (%r15,%r13,1),%r10
  6db311:	mov    0x20(%r15,%r13,1),%rax
  6db316:	test   %rcx,%rcx
  6db319:	je     6db32f <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19inspector_focus_hitBW_+0x33f>
  6db31b:	cmp    $0x1,%ecx
  6db31e:	jne    6db34a <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19inspector_focus_hitBW_+0x35a>
  6db320:	test   %r8,%r8
  6db323:	je     6db2e6 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19inspector_focus_hitBW_+0x2f6>
  6db325:	cmp    $0x1,%r8
  6db329:	jne    6db362 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19inspector_focus_hitBW_+0x372>
  6db32b:	xor    %edi,%edi
  6db32d:	jmp    6db38b <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19inspector_focus_hitBW_+0x39b>
  6db32f:	mov    %rax,%rdi
  6db332:	sub    %rdx,%rdi
  6db335:	setae  %r11b
  6db339:	cmp    %r8,%rdi
  6db33c:	setb   %bpl
  6db340:	test   %bpl,%r11b
  6db343:	je     6db2e6 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19inspector_focus_hitBW_+0x2f6>
  6db345:	jmp    6db408 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19inspector_focus_hitBW_+0x418>
  6db34a:	test   %r8,%r8
  6db34d:	je     6db2e6 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19inspector_focus_hitBW_+0x2f6>
  6db34f:	cmp    $0x1,%r8
  6db353:	jne    6db3cc <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19inspector_focus_hitBW_+0x3dc>
  6db355:	mov    %rdx,%rdi
  6db358:	cmp    %rax,(%rdx)
  6db35b:	jne    6db2e6 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19inspector_focus_hitBW_+0x2f6>
  6db35d:	jmp    6db405 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19inspector_focus_hitBW_+0x415>
  6db362:	mov    %r8,%r11
  6db365:	xor    %edi,%edi
  6db367:	mov    %rdi,%r14
  6db36a:	mov    %r11,%r13
  6db36d:	shr    $1,%r13
  6db370:	add    %r13,%rdi
  6db373:	mov    %rdi,%rbp
  6db376:	shl    $0x4,%rbp
  6db37a:	cmp    %rax,(%rdx,%rbp,1)
  6db37e:	cmova  %r14,%rdi
  6db382:	sub    %r13,%r11
  6db385:	cmp    $0x1,%r11
  6db389:	ja     6db367 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19inspector_focus_hitBW_+0x377>
  6db38b:	mov    %rdi,%r14
  6db38e:	shl    $0x4,%r14
  6db392:	xor    %r11d,%r11d
  6db395:	cmp    %rax,(%rdx,%r14,1)
  6db399:	setbe  %r11b
  6db39d:	add    %rdi,%r11
  6db3a0:	je     6db2e6 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19inspector_focus_hitBW_+0x2f6>
  6db3a6:	shl    $0x4,%r11
  6db3aa:	mov    %rax,%rdi
  6db3ad:	sub    -0x10(%rdx,%r11,1),%rdi
  6db3b2:	mov    -0x4(%rdx,%r11,1),%r14d
  6db3b7:	cmp    %r14,%rdi
  6db3ba:	jae    6db2e6 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19inspector_focus_hitBW_+0x2f6>
  6db3c0:	add    %rdx,%r11
  6db3c3:	mov    -0x8(%r11),%r11d
  6db3c7:	add    %r11,%rdi
  6db3ca:	jmp    6db408 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19inspector_focus_hitBW_+0x418>
  6db3cc:	mov    %r8,%rdi
  6db3cf:	xor    %r11d,%r11d
  6db3d2:	mov    %r11,%r14
  6db3d5:	mov    %rdi,%r13
  6db3d8:	shr    $1,%r13
  6db3db:	add    %r13,%r11
  6db3de:	lea    (%r11,%r11,2),%rbp
  6db3e2:	cmp    %rax,(%rdx,%rbp,4)
  6db3e6:	cmova  %r14,%r11
  6db3ea:	sub    %r13,%rdi
  6db3ed:	cmp    $0x1,%rdi
  6db3f1:	ja     6db3d2 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19inspector_focus_hitBW_+0x3e2>
  6db3f3:	lea    (%r11,%r11,2),%rdi
  6db3f7:	cmp    %rax,(%rdx,%rdi,4)
  6db3fb:	jne    6db2e6 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19inspector_focus_hitBW_+0x2f6>
  6db401:	lea    (%rdx,%rdi,4),%rdi
  6db405:	mov    0x8(%rdi),%edi
  6db408:	cmp    %rsi,%rdi
  6db40b:	jae    6db46b <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19inspector_focus_hitBW_+0x47b>
  6db40d:	lea    (%rdi,%rdi,4),%rdi
  6db411:	cmpq   $0x0,0x8(%r9,%rdi,8)
  6db417:	jne    6db424 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19inspector_focus_hitBW_+0x434>
  6db419:	cmpb   $0x4,0x3d(%r10)
  6db41e:	jne    6db2e6 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19inspector_focus_hitBW_+0x2f6>
  6db424:	add    $0x5d8,%rbx
  6db42b:	mov    %rbx,%rdi
  6db42e:	mov    %rax,%rsi
  6db431:	call   *0x33e329(%rip)        # a19760 <_DYNAMIC+0x460>
  6db437:	cmp    %r12,%rax
  6db43a:	mov    0x38(%rsp),%rax
  6db43f:	je     6db1be <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19inspector_focus_hitBW_+0x1ce>
  6db445:	xor    %eax,%eax
  6db447:	add    $0x78,%rsp
  6db44b:	pop    %rbx
  6db44c:	pop    %r12
  6db44e:	pop    %r13
  6db450:	pop    %r14
  6db452:	pop    %r15
  6db454:	pop    %rbp
  6db455:	ret
  6db456:	lea    0x31f8fb(%rip),%rdx        # 9fad58 <__frame_dummy_init_array_entry+0x1228>
  6db45d:	mov    %r13,%rdi
  6db460:	mov    0x10(%rsp),%rsi
  6db465:	call   *0x33e105(%rip)        # a19570 <_DYNAMIC+0x270>
  6db46b:	lea    0x31f8fe(%rip),%rdx        # 9fad70 <__frame_dummy_init_array_entry+0x1240>
  6db472:	call   *0x33e0f8(%rip)        # a19570 <_DYNAMIC+0x270>

/tmp/gpui-inspector-pointer-codegen-optin/candidate-frozen:     file format elf64-x86-64


Disassembly of section .text:

00000000006dc0d0 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE14inspector_pickB10_>:
  6dc0d0:	push   %r15
  6dc0d2:	push   %r14
  6dc0d4:	push   %r12
  6dc0d6:	push   %rbx
  6dc0d7:	sub    $0x58,%rsp
  6dc0db:	mov    0x5a0(%rdi),%rbx
  6dc0e2:	mov    0x5a8(%rdi),%r14
  6dc0e9:	mov    0x638(%rdi),%r15
  6dc0f0:	test   %r15,%r15
  6dc0f3:	je     6dc12d <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE14inspector_pickB10_+0x5d>
  6dc0f5:	mov    0x100(%r15),%rsi
  6dc0fc:	test   %rsi,%rsi
  6dc0ff:	je     6dc142 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE14inspector_pickB10_+0x72>
  6dc101:	lea    0x8(%rsp),%rax
  6dc106:	mov    %rdi,%r12
  6dc109:	mov    %rax,%rdi
  6dc10c:	movss  %xmm1,0x4(%rsp)
  6dc112:	movss  %xmm0,(%rsp)
  6dc117:	call   *0x33d673(%rip)        # a19790 <_DYNAMIC+0x490>
  6dc11d:	movss  (%rsp),%xmm0
  6dc122:	movss  0x4(%rsp),%xmm1
  6dc128:	mov    %r12,%rdi
  6dc12b:	jmp    6dc153 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE14inspector_pickB10_+0x83>
  6dc12d:	movq   $0x4,0x8(%rsp)
  6dc136:	xorps  %xmm2,%xmm2
  6dc139:	movups %xmm2,0x10(%rsp)
  6dc13e:	xor    %eax,%eax
  6dc140:	jmp    6dc15a <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE14inspector_pickB10_+0x8a>
  6dc142:	movq   $0x4,0x8(%rsp)
  6dc14b:	xorps  %xmm2,%xmm2
  6dc14e:	movups %xmm2,0x10(%rsp)
  6dc153:	cmpq   $0x0,(%r15)
  6dc157:	setne  %al
  6dc15a:	mov    0x698(%rdi),%rcx
  6dc161:	mov    %rbx,0x20(%rsp)
  6dc166:	mov    %r14,0x28(%rsp)
  6dc16b:	mov    0x8(%rsp),%rdx
  6dc170:	mov    %rdx,0x30(%rsp)
  6dc175:	mov    0x10(%rsp),%rdx
  6dc17a:	mov    %rdx,0x38(%rsp)
  6dc17f:	mov    0x18(%rsp),%rdx
  6dc184:	mov    %rdx,0x40(%rsp)
  6dc189:	mov    %rcx,0x48(%rsp)
  6dc18e:	mov    %al,0x50(%rsp)
  6dc192:	lea    0x20(%rsp),%rsi
  6dc197:	call   6dd630 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE23inspector_pick_in_sheetB10_>
  6dc19c:	add    $0x58,%rsp
  6dc1a0:	pop    %rbx
  6dc1a1:	pop    %r12
  6dc1a3:	pop    %r14
  6dc1a5:	pop    %r15
  6dc1a7:	ret

/tmp/gpui-inspector-pointer-codegen-optin/candidate-frozen:     file format elf64-x86-64


Disassembly of section .text:

00000000006dd630 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE23inspector_pick_in_sheetB10_>:
  6dd630:	push   %rbp
  6dd631:	push   %r15
  6dd633:	push   %r14
  6dd635:	push   %r13
  6dd637:	push   %r12
  6dd639:	push   %rbx
  6dd63a:	sub    $0x68,%rsp
  6dd63e:	movss  %xmm1,0x14(%rsp)
  6dd644:	movss  %xmm0,0x10(%rsp)
  6dd64a:	mov    0x638(%rdi),%rcx
  6dd651:	test   %rcx,%rcx
  6dd654:	je     6dd74f <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE23inspector_pick_in_sheetB10_+0x11f>
  6dd65a:	cmpq   $0x0,0xd8(%rcx)
  6dd662:	je     6dd74f <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE23inspector_pick_in_sheetB10_+0x11f>
  6dd668:	mov    0x2c8(%rdi),%rax
  6dd66f:	cmp    $0x1c,%rax
  6dd673:	jb     6dd74f <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE23inspector_pick_in_sheetB10_+0x11f>
  6dd679:	mov    %rsi,%r14
  6dd67c:	mov    0x8(%rsi),%r15
  6dd680:	test   %r15,%r15
  6dd683:	je     6dd74f <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE23inspector_pick_in_sheetB10_+0x11f>
  6dd689:	mov    %rdi,0x28(%rsp)
  6dd68e:	mov    %rcx,0x20(%rsp)
  6dd693:	mov    %rax,0x18(%rsp)
  6dd698:	mov    (%r14),%r13
  6dd69b:	mov    %r15,%rax
  6dd69e:	shl    $0x6,%rax
  6dd6a2:	add    %r13,%rax
  6dd6a5:	movzbl 0x30(%r14),%ecx
  6dd6aa:	mov    %ecx,0xc(%rsp)
  6dd6ae:	add    $0x10,%r14
  6dd6b2:	jmp    6dd70f <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE23inspector_pick_in_sheetB10_+0xdf>
  6dd6b4:	data16 data16 cs nopw 0x0(%rax,%rax,1)
  6dd6c0:	mov    %rbp,%r12
  6dd6c3:	sub    %r13,%r12
  6dd6c6:	mov    %r12,%rbx
  6dd6c9:	shr    $0x6,%rbx
  6dd6cd:	mov    0x10(%r14),%rax
  6dd6d1:	mov    %rax,0x40(%rsp)
  6dd6d6:	movups (%r14),%xmm0
  6dd6da:	movaps %xmm0,0x30(%rsp)
  6dd6df:	mov    %r13,%rdi
  6dd6e2:	mov    %r15,%rsi
  6dd6e5:	lea    0x30(%rsp),%rdx
  6dd6ea:	mov    0xc(%rsp),%ecx
  6dd6ee:	mov    %rbx,%r8
  6dd6f1:	movss  0x10(%rsp),%xmm0
  6dd6f7:	movss  0x14(%rsp),%xmm1
  6dd6fd:	call   *0x33c0ed(%rip)        # a197f0 <_DYNAMIC+0x4f0>
  6dd703:	test   %al,%al
  6dd705:	jne    6dd768 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE23inspector_pick_in_sheetB10_+0x138>
  6dd707:	mov    %rbp,%rax
  6dd70a:	cmp    %rbp,%r13
  6dd70d:	je     6dd763 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE23inspector_pick_in_sheetB10_+0x133>
  6dd70f:	lea    -0x40(%rax),%rbp
  6dd713:	cmpb   $0x0,-0x2(%rax)
  6dd717:	jne    6dd6c0 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE23inspector_pick_in_sheetB10_+0x90>
  6dd719:	mov    -0x8(%rax),%eax
  6dd71c:	cmp    $0x3ffff,%rax
  6dd722:	jbe    6dd707 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE23inspector_pick_in_sheetB10_+0xd7>
  6dd724:	shr    $0x11,%eax
  6dd727:	mov    %rbp,%rcx
  6dd72a:	sub    %r13,%rcx
  6dd72d:	shr    $0x6,%rcx
  6dd731:	mov    $0x2,%edx
  6dd736:	sub    %rax,%rdx
  6dd739:	add    $0xfffffffffffffffe,%rax
  6dd73d:	shl    $0x6,%rdx
  6dd741:	cmp    %rcx,%rax
  6dd744:	lea    -0x40(%rbp,%rdx,1),%rbp
  6dd749:	cmovae %r13,%rbp
  6dd74d:	jmp    6dd707 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE23inspector_pick_in_sheetB10_+0xd7>
  6dd74f:	xor    %eax,%eax
  6dd751:	mov    %r14,%rdx
  6dd754:	add    $0x68,%rsp
  6dd758:	pop    %rbx
  6dd759:	pop    %r12
  6dd75b:	pop    %r13
  6dd75d:	pop    %r14
  6dd75f:	pop    %r15
  6dd761:	pop    %rbp
  6dd762:	ret
  6dd763:	jmp    6dd827 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE23inspector_pick_in_sheetB10_+0x1f7>
  6dd768:	cmp    %r15,%rbx
  6dd76b:	jae    6dd82e <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE23inspector_pick_in_sheetB10_+0x1fe>
  6dd771:	mov    0x28(%rsp),%r15
  6dd776:	lea    0x5d8(%r15),%rdi
  6dd77d:	mov    0x20(%r13,%r12,1),%rsi
  6dd782:	call   *0x33bfd8(%rip)        # a19760 <_DYNAMIC+0x460>
  6dd788:	mov    %rdx,%r14
  6dd78b:	cmp    0x5d8(%r15),%rax
  6dd792:	jne    6dd827 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE23inspector_pick_in_sheetB10_+0x1f7>
  6dd798:	mov    %rax,%rbx
  6dd79b:	lea    0x30(%rsp),%rdi
  6dd7a0:	mov    %r15,%rsi
  6dd7a3:	mov    %r14,%rdx
  6dd7a6:	call   6f8520 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE16resolve_identityBO_>
  6dd7ab:	mov    0x30(%rsp),%rcx
  6dd7b0:	mov    0x38(%rsp),%rax
  6dd7b5:	cmp    $0xfffffffffffffffe,%rcx
  6dd7b9:	jne    6dd7ec <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE23inspector_pick_in_sheetB10_+0x1bc>
  6dd7bb:	mov    0x20(%rsp),%rcx
  6dd7c0:	cmpq   $0x0,0xd8(%rcx)
  6dd7c8:	je     6dd827 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE23inspector_pick_in_sheetB10_+0x1f7>
  6dd7ca:	mov    0x18(%rsp),%rdx
  6dd7cf:	add    $0xffffffffffffffe4,%rdx
  6dd7d3:	cmp    $0x2,%rax
  6dd7d7:	setae  %cl
  6dd7da:	cmp    %rdx,%rax
  6dd7dd:	setb   %al
  6dd7e0:	test   %al,%cl
  6dd7e2:	je     6dd827 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE23inspector_pick_in_sheetB10_+0x1f7>
  6dd7e4:	mov    %rbx,%rax
  6dd7e7:	jmp    6dd751 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE23inspector_pick_in_sheetB10_+0x121>
  6dd7ec:	mov    0x48(%rsp),%rsi
  6dd7f1:	mov    0x50(%rsp),%rdi
  6dd7f6:	cmp    $0xc,%rcx
  6dd7fa:	jle    6dd817 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE23inspector_pick_in_sheetB10_+0x1e7>
  6dd7fc:	cmp    $0x21,%rcx
  6dd800:	je     6dd817 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE23inspector_pick_in_sheetB10_+0x1e7>
  6dd802:	cmp    $0x26,%rcx
  6dd806:	jne    6dd827 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE23inspector_pick_in_sheetB10_+0x1f7>
  6dd808:	test   %rax,%rax
  6dd80b:	je     6dd827 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE23inspector_pick_in_sheetB10_+0x1f7>
  6dd80d:	mov    0x40(%rsp),%rdi
  6dd812:	mov    %rax,%rsi
  6dd815:	jmp    6dd81c <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE23inspector_pick_in_sheetB10_+0x1ec>
  6dd817:	test   %rsi,%rsi
  6dd81a:	je     6dd827 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE23inspector_pick_in_sheetB10_+0x1f7>
  6dd81c:	mov    $0x1,%edx
  6dd821:	call   *0x33bd19(%rip)        # a19540 <_DYNAMIC+0x240>
  6dd827:	xor    %eax,%eax
  6dd829:	jmp    6dd751 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE23inspector_pick_in_sheetB10_+0x121>
  6dd82e:	lea    0x31d343(%rip),%rdx        # 9fab78 <__frame_dummy_init_array_entry+0x1048>
  6dd835:	mov    %rbx,%rdi
  6dd838:	mov    %r15,%rsi
  6dd83b:	call   *0x33bd2f(%rip)        # a19570 <_DYNAMIC+0x270>

/tmp/gpui-inspector-pointer-codegen-optin/candidate-frozen:     file format elf64-x86-64


Disassembly of section .text:

00000000006f8800 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_>:
  6f8800:	push   %rbp
  6f8801:	push   %r15
  6f8803:	push   %r14
  6f8805:	push   %r13
  6f8807:	push   %r12
  6f8809:	push   %rbx
  6f880a:	sub    $0x48,%rsp
  6f880e:	movss  %xmm1,0xc(%rsp)
  6f8814:	movss  %xmm0,0x8(%rsp)
  6f881a:	mov    %rdi,%r15
  6f881d:	mov    0x5a0(%rdi),%r14
  6f8824:	mov    0x5a8(%rdi),%rax
  6f882b:	mov    %rax,(%rsp)
  6f882f:	mov    0x638(%rdi),%rbx
  6f8836:	test   %rbx,%rbx
  6f8839:	je     6f8854 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x54>
  6f883b:	mov    0x100(%rbx),%rsi
  6f8842:	test   %rsi,%rsi
  6f8845:	je     6f8869 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x69>
  6f8847:	lea    0x30(%rsp),%rdi
  6f884c:	call   *0x320f3e(%rip)        # a19790 <_DYNAMIC+0x490>
  6f8852:	jmp    6f887a <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x7a>
  6f8854:	movq   $0x4,0x30(%rsp)
  6f885d:	xorps  %xmm0,%xmm0
  6f8860:	movups %xmm0,0x38(%rsp)
  6f8865:	xor    %ebx,%ebx
  6f8867:	jmp    6f8881 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x81>
  6f8869:	movq   $0x4,0x30(%rsp)
  6f8872:	xorps  %xmm0,%xmm0
  6f8875:	movups %xmm0,0x38(%rsp)
  6f887a:	cmpq   $0x0,(%rbx)
  6f887e:	setne  %bl
  6f8881:	mov    0x698(%r15),%rax
  6f8888:	mov    %eax,%ecx
  6f888a:	xorps  %xmm0,%xmm0
  6f888d:	cvtsi2ss %rcx,%xmm0
  6f8892:	shr    $0x20,%rax
  6f8896:	xorps  %xmm1,%xmm1
  6f8899:	cvtsi2ss %rax,%xmm1
  6f889e:	movq   $0x0,0x10(%rsp)
  6f88a7:	movss  %xmm0,0x18(%rsp)
  6f88ad:	movss  %xmm1,0x1c(%rsp)
  6f88b3:	lea    0x10(%rsp),%rdi
  6f88b8:	movss  0x8(%rsp),%xmm0
  6f88be:	movss  0xc(%rsp),%xmm1
  6f88c4:	call   *0x320ede(%rip)        # a197a8 <_DYNAMIC+0x4a8>
  6f88ca:	xor    %r12d,%r12d
  6f88cd:	cmpq   $0x0,(%rsp)
  6f88d2:	je     6f898d <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x18d>
  6f88d8:	test   %al,%al
  6f88da:	je     6f898d <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x18d>
  6f88e0:	mov    (%rsp),%rax
  6f88e4:	shl    $0x6,%rax
  6f88e8:	add    %r14,%rax
  6f88eb:	movzbl %bl,%ebp
  6f88ee:	xor    %r12d,%r12d
  6f88f1:	jmp    6f894d <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x14d>
  6f88f3:	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  6f8900:	mov    %rbx,%r13
  6f8903:	sub    %r14,%r13
  6f8906:	shr    $0x6,%r13
  6f890a:	mov    0x40(%rsp),%rax
  6f890f:	mov    %rax,0x20(%rsp)
  6f8914:	movups 0x30(%rsp),%xmm0
  6f8919:	movaps %xmm0,0x10(%rsp)
  6f891e:	mov    %r14,%rdi
  6f8921:	mov    (%rsp),%rsi
  6f8925:	lea    0x10(%rsp),%rdx
  6f892a:	mov    %ebp,%ecx
  6f892c:	mov    %r13,%r8
  6f892f:	movss  0x8(%rsp),%xmm0
  6f8935:	movss  0xc(%rsp),%xmm1
  6f893b:	call   *0x320eaf(%rip)        # a197f0 <_DYNAMIC+0x4f0>
  6f8941:	test   %al,%al
  6f8943:	jne    6f899f <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x19f>
  6f8945:	mov    %rbx,%rax
  6f8948:	cmp    %rbx,%r14
  6f894b:	je     6f898d <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x18d>
  6f894d:	lea    -0x40(%rax),%rbx
  6f8951:	cmpb   $0x0,-0x2(%rax)
  6f8955:	jne    6f8900 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x100>
  6f8957:	mov    -0x8(%rax),%eax
  6f895a:	cmp    $0x3ffff,%rax
  6f8960:	jbe    6f8945 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x145>
  6f8962:	shr    $0x11,%eax
  6f8965:	mov    %rbx,%rcx
  6f8968:	sub    %r14,%rcx
  6f896b:	shr    $0x6,%rcx
  6f896f:	mov    $0x2,%edx
  6f8974:	sub    %rax,%rdx
  6f8977:	add    $0xfffffffffffffffe,%rax
  6f897b:	shl    $0x6,%rdx
  6f897f:	cmp    %rcx,%rax
  6f8982:	lea    -0x40(%rbx,%rdx,1),%rbx
  6f8987:	cmovae %r14,%rbx
  6f898b:	jmp    6f8945 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x145>
  6f898d:	mov    %r12,%rax
  6f8990:	add    $0x48,%rsp
  6f8994:	pop    %rbx
  6f8995:	pop    %r12
  6f8997:	pop    %r13
  6f8999:	pop    %r14
  6f899b:	pop    %r15
  6f899d:	pop    %rbp
  6f899e:	ret
  6f899f:	mov    0x1e8(%r15),%rax
  6f89a6:	mov    0x1f0(%r15),%rcx
  6f89ad:	mov    0x1f8(%r15),%r8
  6f89b4:	mov    0x2c8(%r15),%rsi
  6f89bb:	mov    0x2c0(%r15),%r9
  6f89c2:	jmp    6f89e8 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x1e8>
  6f89c4:	data16 data16 cs nopw 0x0(%rax,%rax,1)
  6f89d0:	mov    0x38(%r10),%r13d
  6f89d4:	and    $0x1ffff,%r13d
  6f89db:	cmp    $0x1ffff,%r13
  6f89e2:	je     6f8b41 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x341>
  6f89e8:	cmp    (%rsp),%r13
  6f89ec:	jae    6f8b49 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x349>
  6f89f2:	shl    $0x6,%r13
  6f89f6:	lea    (%r14,%r13,1),%r10
  6f89fa:	mov    0x20(%r14,%r13,1),%rdx
  6f89ff:	test   %rax,%rax
  6f8a02:	je     6f8a20 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x220>
  6f8a04:	cmp    $0x1,%eax
  6f8a07:	jne    6f8a40 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x240>
  6f8a09:	test   %r8,%r8
  6f8a0c:	je     6f89d0 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x1d0>
  6f8a0e:	cmp    $0x1,%r8
  6f8a12:	jne    6f8a60 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x260>
  6f8a14:	xor    %edi,%edi
  6f8a16:	jmp    6f8a94 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x294>
  6f8a18:	nopl   0x0(%rax,%rax,1)
  6f8a20:	mov    %rdx,%rdi
  6f8a23:	sub    %rcx,%rdi
  6f8a26:	setae  %r11b
  6f8a2a:	cmp    %r8,%rdi
  6f8a2d:	setb   %bl
  6f8a30:	test   %bl,%r11b
  6f8a33:	je     6f89d0 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x1d0>
  6f8a35:	jmp    6f8b16 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x316>
  6f8a3a:	nopw   0x0(%rax,%rax,1)
  6f8a40:	test   %r8,%r8
  6f8a43:	je     6f89d0 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x1d0>
  6f8a45:	cmp    $0x1,%r8
  6f8a49:	jne    6f8ad5 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x2d5>
  6f8a4f:	mov    %rcx,%rdi
  6f8a52:	cmp    %rdx,(%rcx)
  6f8a55:	jne    6f89d0 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x1d0>
  6f8a5b:	jmp    6f8b13 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x313>
  6f8a60:	mov    %r8,%r11
  6f8a63:	xor    %edi,%edi
  6f8a65:	data16 cs nopw 0x0(%rax,%rax,1)
  6f8a70:	mov    %rdi,%rbx
  6f8a73:	mov    %r11,%r15
  6f8a76:	shr    $1,%r15
  6f8a79:	add    %r15,%rdi
  6f8a7c:	mov    %rdi,%r12
  6f8a7f:	shl    $0x4,%r12
  6f8a83:	cmp    %rdx,(%rcx,%r12,1)
  6f8a87:	cmova  %rbx,%rdi
  6f8a8b:	sub    %r15,%r11
  6f8a8e:	cmp    $0x1,%r11
  6f8a92:	ja     6f8a70 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x270>
  6f8a94:	mov    %rdi,%rbx
  6f8a97:	shl    $0x4,%rbx
  6f8a9b:	xor    %r11d,%r11d
  6f8a9e:	cmp    %rdx,(%rcx,%rbx,1)
  6f8aa2:	setbe  %r11b
  6f8aa6:	add    %rdi,%r11
  6f8aa9:	je     6f89d0 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x1d0>
  6f8aaf:	shl    $0x4,%r11
  6f8ab3:	mov    %rdx,%rdi
  6f8ab6:	sub    -0x10(%rcx,%r11,1),%rdi
  6f8abb:	mov    -0x4(%rcx,%r11,1),%ebx
  6f8ac0:	cmp    %rbx,%rdi
  6f8ac3:	jae    6f89d0 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x1d0>
  6f8ac9:	add    %rcx,%r11
  6f8acc:	mov    -0x8(%r11),%r11d
  6f8ad0:	add    %r11,%rdi
  6f8ad3:	jmp    6f8b16 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x316>
  6f8ad5:	mov    %r8,%rdi
  6f8ad8:	xor    %r11d,%r11d
  6f8adb:	nopl   0x0(%rax,%rax,1)
  6f8ae0:	mov    %r11,%rbx
  6f8ae3:	mov    %rdi,%r15
  6f8ae6:	shr    $1,%r15
  6f8ae9:	add    %r15,%r11
  6f8aec:	lea    (%r11,%r11,2),%r12
  6f8af0:	cmp    %rdx,(%rcx,%r12,4)
  6f8af4:	cmova  %rbx,%r11
  6f8af8:	sub    %r15,%rdi
  6f8afb:	cmp    $0x1,%rdi
  6f8aff:	ja     6f8ae0 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x2e0>
  6f8b01:	lea    (%r11,%r11,2),%rdi
  6f8b05:	cmp    %rdx,(%rcx,%rdi,4)
  6f8b09:	jne    6f89d0 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x1d0>
  6f8b0f:	lea    (%rcx,%rdi,4),%rdi
  6f8b13:	mov    0x8(%rdi),%edi
  6f8b16:	cmp    %rsi,%rdi
  6f8b19:	jae    6f8b5d <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x35d>
  6f8b1b:	lea    (%rdi,%rdi,4),%rdi
  6f8b1f:	mov    $0x1,%r12d
  6f8b25:	cmpq   $0x0,0x8(%r9,%rdi,8)
  6f8b2b:	jne    6f898d <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x18d>
  6f8b31:	cmpb   $0x4,0x3d(%r10)
  6f8b36:	jne    6f89d0 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x1d0>
  6f8b3c:	jmp    6f898d <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x18d>
  6f8b41:	xor    %r12d,%r12d
  6f8b44:	jmp    6f898d <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x18d>
  6f8b49:	lea    0x302208(%rip),%rdx        # 9fad58 <__frame_dummy_init_array_entry+0x1228>
  6f8b50:	mov    %r13,%rdi
  6f8b53:	mov    (%rsp),%rsi
  6f8b57:	call   *0x320a13(%rip)        # a19570 <_DYNAMIC+0x270>
  6f8b5d:	lea    0x30220c(%rip),%rdx        # 9fad70 <__frame_dummy_init_array_entry+0x1240>
  6f8b64:	call   *0x320a06(%rip)        # a19570 <_DYNAMIC+0x270>

inspector_pointer_control::click_only bytes=743 stack=136

inspector_pointer_control::ack bytes=241 stack=136

inspector_pointer_control::main bytes=7119 stack=3368

inspector_pointer_control::dispatch bytes=3263 stack=232

inspector_pointer_control::hit_only bytes=204 stack=24

<gpui::runtime::Runtime<inspector_pointer_control::Model>>::pointer_hit bytes=93 stack=8

<gpui::runtime::Runtime<inspector_pointer_control::Model>>::inspector_focus_hit bytes=1160 stack=168

<gpui::runtime::Runtime<inspector_pointer_control::Model>>::inspector_pick bytes=216 stack=120

<gpui::runtime::Runtime<inspector_pointer_control::Model>>::inspector_pick_in_sheet bytes=529 stack=152

<gpui::runtime::Runtime<inspector_pointer_control::Model>>::hit bytes=874 stack=120
