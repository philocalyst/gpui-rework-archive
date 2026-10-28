
/tmp/gpui-inspector-pointer-codegen-split/candidate-frozen:     file format elf64-x86-64


Disassembly of section .text:

00000000006d0380 <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only>:
  6d0380:	push   %rbp
  6d0381:	push   %r15
  6d0383:	push   %r14
  6d0385:	push   %r13
  6d0387:	push   %r12
  6d0389:	push   %rbx
  6d038a:	sub    $0x68,%rsp
  6d038e:	mov    (%rsi),%rbx
  6d0391:	test   %rbx,%rbx
  6d0394:	je     6d03b9 <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x39>
  6d0396:	add    $0x8,%rsi
  6d039a:	mov    %rbx,0x58(%rsp)
  6d039f:	mov    %rsi,0x60(%rsp)
  6d03a4:	cmpb   $0x1,0x746(%rbx)
  6d03ab:	jne    6d03cd <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x4d>
  6d03ad:	movq   $0xe,(%rdi)
  6d03b4:	jmp    6d04ac <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x12c>
  6d03b9:	movq   $0xd,(%rdi)
  6d03c0:	movq   $0x0,0x8(%rdi)
  6d03c8:	jmp    6d04ac <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x12c>
  6d03cd:	cmpb   $0x1,0x742(%rbx)
  6d03d4:	jne    6d04a5 <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x125>
  6d03da:	cmpb   $0x0,0x743(%rbx)
  6d03e1:	jne    6d04a5 <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x125>
  6d03e7:	cmpb   $0x0,0x744(%rbx)
  6d03ee:	je     6d04a5 <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x125>
  6d03f4:	cmpq   $0xffffffffffffffff,0x5b0(%rbx)
  6d03fc:	jne    6d04a5 <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x125>
  6d0402:	mov    0x688(%rbx),%rax
  6d0409:	cmp    0x690(%rbx),%rax
  6d0410:	jne    6d04a5 <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x125>
  6d0416:	mov    0x6a0(%rbx),%rax
  6d041d:	cmp    0x698(%rbx),%rax
  6d0424:	jne    6d04a5 <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x125>
  6d0426:	movss  0x738(%rbx),%xmm2
  6d042e:	ucomiss 0x73c(%rbx),%xmm2
  6d0435:	jne    6d04a5 <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x125>
  6d0437:	jp     6d04a5 <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x125>
  6d0439:	mov    0x638(%rbx),%r15
  6d0440:	test   %r15,%r15
  6d0443:	movss  %xmm1,0x4(%rsp)
  6d0449:	movss  %xmm0,(%rsp)
  6d044e:	je     6d04bb <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x13b>
  6d0450:	mov    0xd8(%r15),%rcx
  6d0457:	test   %rcx,%rcx
  6d045a:	je     6d04bb <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x13b>
  6d045c:	cmpb   $0x0,0x12(%rcx)
  6d0460:	je     6d04bb <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x13b>
  6d0462:	mov    %rdi,%r14
  6d0465:	mov    0x5a0(%rbx),%r12
  6d046c:	mov    0x5a8(%rbx),%r13
  6d0473:	mov    0x100(%r15),%rsi
  6d047a:	test   %rsi,%rsi
  6d047d:	je     6d0619 <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x299>
  6d0483:	lea    0x40(%rsp),%rdi
  6d0488:	call   *0x3499e2(%rip)        # a19e70 <_DYNAMIC+0x460>
  6d048e:	movss  (%rsp),%xmm0
  6d0493:	movss  0x4(%rsp),%xmm1
  6d0499:	mov    0x698(%rbx),%rax
  6d04a0:	jmp    6d062a <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x2aa>
  6d04a5:	movq   $0x12,(%rdi)
  6d04ac:	add    $0x68,%rsp
  6d04b0:	pop    %rbx
  6d04b1:	pop    %r12
  6d04b3:	pop    %r13
  6d04b5:	pop    %r14
  6d04b7:	pop    %r15
  6d04b9:	pop    %rbp
  6d04ba:	ret
  6d04bb:	mov    %rdi,%r14
  6d04be:	mov    %rbx,%rdi
  6d04c1:	call   6f8ec0 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_>
  6d04c6:	cmp    $0x1,%rax
  6d04ca:	jne    6d056d <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x1ed>
  6d04d0:	lea    0x5d8(%rbx),%rdi
  6d04d7:	mov    %rdx,%rsi
  6d04da:	call   *0x349998(%rip)        # a19e78 <_DYNAMIC+0x468>
  6d04e0:	cmp    0x5d8(%rbx),%rax
  6d04e7:	jne    6d05eb <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x26b>
  6d04ed:	mov    %rax,%r12
  6d04f0:	mov    %rdx,%r15
  6d04f3:	lea    0x8(%rsp),%rdi
  6d04f8:	mov    %rbx,%rsi
  6d04fb:	call   6f8be0 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE16resolve_identityBO_>
  6d0500:	mov    0x8(%rsp),%rax
  6d0505:	mov    0x10(%rsp),%rdi
  6d050a:	cmp    $0xfffffffffffffffe,%rax
  6d050e:	jne    6d05f0 <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x270>
  6d0514:	mov    0x2c8(%rbx),%rsi
  6d051b:	cmp    %rsi,%rdi
  6d051e:	jae    6d06e2 <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x362>
  6d0524:	mov    0x2c0(%rbx),%rax
  6d052b:	lea    (%rdi,%rdi,4),%rcx
  6d052f:	mov    0x20(%rax,%rcx,8),%edi
  6d0533:	call   6e2670 <_RNvMsh_NtCs6ZNK6sH19NW_4gpui7runtimeNtB5_4Node4kind>
  6d0538:	cmp    $0x4,%al
  6d053a:	jne    6d0694 <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x314>
  6d0540:	mov    %r14,%rdi
  6d0543:	mov    %rbx,%rsi
  6d0546:	mov    %r12,%rdx
  6d0549:	mov    %r15,%rcx
  6d054c:	movss  (%rsp),%xmm0
  6d0551:	movss  0x4(%rsp),%xmm1
  6d0557:	xor    %r8d,%r8d
  6d055a:	add    $0x68,%rsp
  6d055e:	pop    %rbx
  6d055f:	pop    %r12
  6d0561:	pop    %r13
  6d0563:	pop    %r14
  6d0565:	pop    %r15
  6d0567:	pop    %rbp
  6d0568:	jmp    6dbfa0 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime7editingINtB7_10RuntimeMutNtCs4gijoeCAvqI_25inspector_pointer_control5ModeluE14select_pointerB12_>
  6d056d:	mov    0x610(%rbx),%rdx
  6d0574:	mov    0x618(%rbx),%rcx
  6d057b:	movq   $0x0,0x610(%rbx)
  6d0586:	movq   $0x0,0x730(%rbx)
  6d0591:	lea    0x8(%rsp),%rdi
  6d0596:	mov    %rbx,%rsi
  6d0599:	call   6dc5c0 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime7editingINtB7_10RuntimeMutNtCs4gijoeCAvqI_25inspector_pointer_control5ModeluE20publish_focus_changeB12_>
  6d059e:	mov    0x8(%rsp),%rax
  6d05a3:	cmp    $0xfffffffffffffffe,%rax
  6d05a7:	je     6d0688 <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x308>
  6d05ad:	mov    0x30(%rsp),%rcx
  6d05b2:	movzbl 0x38(%rsp),%edx
  6d05b7:	mov    0x3c(%rsp),%esi
  6d05bb:	mov    %esi,0x34(%r14)
  6d05bf:	mov    0x39(%rsp),%esi
  6d05c3:	mov    %esi,0x31(%r14)
  6d05c7:	movups 0x10(%rsp),%xmm0
  6d05cc:	movups 0x20(%rsp),%xmm1
  6d05d1:	mov    %rax,(%r14)
  6d05d4:	movups %xmm0,0x8(%r14)
  6d05d9:	movups %xmm1,0x18(%r14)
  6d05de:	mov    %rcx,0x28(%r14)
  6d05e2:	mov    %dl,0x30(%r14)
  6d05e6:	jmp    6d04ac <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x12c>
  6d05eb:	mov    $0x11,%eax
  6d05f0:	mov    0x38(%rsp),%rcx
  6d05f5:	mov    %rcx,0x30(%r14)
  6d05f9:	movups 0x18(%rsp),%xmm0
  6d05fe:	movups 0x28(%rsp),%xmm1
  6d0603:	movups %xmm1,0x20(%r14)
  6d0608:	movups %xmm0,0x10(%r14)
  6d060d:	mov    %rax,(%r14)
  6d0610:	mov    %rdi,0x8(%r14)
  6d0614:	jmp    6d04ac <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x12c>
  6d0619:	movq   $0x4,0x40(%rsp)
  6d0622:	xorps  %xmm2,%xmm2
  6d0625:	movups %xmm2,0x48(%rsp)
  6d062a:	cmpq   $0x0,(%r15)
  6d062e:	mov    %r12,0x8(%rsp)
  6d0633:	mov    %r13,0x10(%rsp)
  6d0638:	mov    0x40(%rsp),%rcx
  6d063d:	mov    %rcx,0x18(%rsp)
  6d0642:	mov    0x48(%rsp),%rcx
  6d0647:	mov    %rcx,0x20(%rsp)
  6d064c:	mov    0x50(%rsp),%rcx
  6d0651:	mov    %rcx,0x28(%rsp)
  6d0656:	mov    %rax,0x30(%rsp)
  6d065b:	setne  0x38(%rsp)
  6d0660:	lea    0x8(%rsp),%rsi
  6d0665:	mov    %rbx,%rdi
  6d0668:	call   6ddcf0 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE23inspector_pick_in_sheetB10_>
  6d066d:	test   %rax,%rax
  6d0670:	je     6d0688 <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x308>
  6d0672:	mov    %rdx,%rcx
  6d0675:	mov    %r14,%rdi
  6d0678:	mov    %rbx,%rsi
  6d067b:	mov    %rax,%rdx
  6d067e:	call   6dfdb0 <_RNvMs4_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_10RuntimeMutNtCs4gijoeCAvqI_25inspector_pointer_control5ModeluE16inspector_selectB14_>
  6d0683:	jmp    6d04ac <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x12c>
  6d0688:	movq   $0x19,(%r14)
  6d068f:	jmp    6d04ac <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x12c>
  6d0694:	mov    0x610(%rbx),%r13
  6d069b:	mov    0x618(%rbx),%rbp
  6d06a2:	lea    0x8(%rsp),%rdi
  6d06a7:	mov    %rbx,%rsi
  6d06aa:	mov    %r12,%rdx
  6d06ad:	mov    %r15,%rcx
  6d06b0:	call   6dbc20 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE5focusBW_>
  6d06b5:	mov    0x8(%rsp),%rax
  6d06ba:	cmp    $0xfffffffffffffffe,%rax
  6d06be:	jne    6d05ad <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x22d>
  6d06c4:	lea    0x58(%rsp),%rsi
  6d06c9:	mov    %r14,%rdi
  6d06cc:	mov    %r12,%rdx
  6d06cf:	mov    %r15,%rcx
  6d06d2:	mov    %r13,%r8
  6d06d5:	mov    %rbp,%r9
  6d06d8:	call   6d3480 <_RNvMNtNtCs6ZNK6sH19NW_4gpui7runtime4turnINtB4_10RuntimeMutNtCs4gijoeCAvqI_25inspector_pointer_control5ModeluE16activate_focusedBW_>
  6d06dd:	jmp    6d04ac <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x12c>
  6d06e2:	lea    0x32ad4f(%rip),%rdx        # 9fb438 <__frame_dummy_init_array_entry+0x11f8>
  6d06e9:	call   *0x349591(%rip)        # a19c80 <_DYNAMIC+0x270>

/tmp/gpui-inspector-pointer-codegen-split/candidate-frozen:     file format elf64-x86-64


Disassembly of section .text:

00000000006d06f0 <_RNvCs4gijoeCAvqI_25inspector_pointer_control3ack>:
  6d06f0:	push   %r14
  6d06f2:	push   %rbx
  6d06f3:	sub    $0x78,%rsp
  6d06f7:	test   %rdi,%rdi
  6d06fa:	je     6d0735 <_RNvCs4gijoeCAvqI_25inspector_pointer_control3ack+0x45>
  6d06fc:	mov    %rdi,%rsi
  6d06ff:	cmpb   $0x0,0x746(%rdi)
  6d0706:	jne    6d073c <_RNvCs4gijoeCAvqI_25inspector_pointer_control3ack+0x4c>
  6d0708:	mov    0x6a8(%rsi),%rdx
  6d070f:	test   %rdx,%rdx
  6d0712:	je     6d0743 <_RNvCs4gijoeCAvqI_25inspector_pointer_control3ack+0x53>
  6d0714:	mov    0x6b0(%rsi),%rcx
  6d071b:	lea    0x40(%rsp),%rdi
  6d0720:	call   6e7960 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE11acknowledgeBO_>
  6d0725:	cmpq   $0xfffffffffffffffe,0x40(%rsp)
  6d072b:	jne    6d077d <_RNvCs4gijoeCAvqI_25inspector_pointer_control3ack+0x8d>
  6d072d:	add    $0x78,%rsp
  6d0731:	pop    %rbx
  6d0732:	pop    %r14
  6d0734:	ret
  6d0735:	mov    $0xd,%eax
  6d073a:	jmp    6d0748 <_RNvCs4gijoeCAvqI_25inspector_pointer_control3ack+0x58>
  6d073c:	mov    $0xe,%eax
  6d0741:	jmp    6d0748 <_RNvCs4gijoeCAvqI_25inspector_pointer_control3ack+0x58>
  6d0743:	mov    $0x14,%eax
  6d0748:	mov    %rax,(%rsp)
  6d074c:	movq   $0x0,0x8(%rsp)
  6d0755:	lea    -0x685ff2(%rip),%rdi        # 4a76a <GCC_except_table0+0xd01e>
  6d075c:	lea    0x32a5c5(%rip),%rcx        # 9fad28 <__frame_dummy_init_array_entry+0xae8>
  6d0763:	lea    0x32a3de(%rip),%r8        # 9fab48 <__frame_dummy_init_array_entry+0x908>
  6d076a:	mov    %rsp,%rbx
  6d076d:	mov    $0x2b,%esi
  6d0772:	mov    %rbx,%rdx
  6d0775:	call   *0x349585(%rip)        # a19d00 <_DYNAMIC+0x2f0>
  6d077b:	jmp    6d07ca <_RNvCs4gijoeCAvqI_25inspector_pointer_control3ack+0xda>
  6d077d:	mov    0x70(%rsp),%rax
  6d0782:	mov    %rax,0x30(%rsp)
  6d0787:	movups 0x40(%rsp),%xmm0
  6d078c:	movups 0x50(%rsp),%xmm1
  6d0791:	movups 0x60(%rsp),%xmm2
  6d0796:	movaps %xmm2,0x20(%rsp)
  6d079b:	movaps %xmm1,0x10(%rsp)
  6d07a0:	movaps %xmm0,(%rsp)
  6d07a4:	lea    -0x686041(%rip),%rdi        # 4a76a <GCC_except_table0+0xd01e>
  6d07ab:	lea    0x32a576(%rip),%rcx        # 9fad28 <__frame_dummy_init_array_entry+0xae8>
  6d07b2:	lea    0x32a3a7(%rip),%r8        # 9fab60 <__frame_dummy_init_array_entry+0x920>
  6d07b9:	mov    %rsp,%rbx
  6d07bc:	mov    $0x2b,%esi
  6d07c1:	mov    %rbx,%rdx
  6d07c4:	call   *0x349536(%rip)        # a19d00 <_DYNAMIC+0x2f0>
  6d07ca:	ud2
  6d07cc:	jmp    6d07ce <_RNvCs4gijoeCAvqI_25inspector_pointer_control3ack+0xde>
  6d07ce:	mov    %rax,%r14
  6d07d1:	mov    %rbx,%rdi
  6d07d4:	call   6be370 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueNtNtCs6ZNK6sH19NW_4gpui7runtime5ErrorECs4gijoeCAvqI_25inspector_pointer_control>
  6d07d9:	mov    %r14,%rdi
  6d07dc:	call   9f8e90 <_Unwind_Resume@plt>

/tmp/gpui-inspector-pointer-codegen-split/candidate-frozen:     file format elf64-x86-64


Disassembly of section .text:

00000000006d07f0 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main>:
  6d07f0:	push   %rbp
  6d07f1:	push   %r15
  6d07f3:	push   %r14
  6d07f5:	push   %r13
  6d07f7:	push   %r12
  6d07f9:	push   %rbx
  6d07fa:	sub    $0xcf8,%rsp
  6d0801:	call   *0x349451(%rip)        # a19c58 <_DYNAMIC+0x248>
  6d0807:	mov    $0x6,%edi
  6d080c:	mov    $0x1,%esi
  6d0811:	call   *0x349449(%rip)        # a19c60 <_DYNAMIC+0x250>
  6d0817:	test   %rax,%rax
  6d081a:	je     6d1f06 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1716>
  6d0820:	mov    %rax,%rbx
  6d0823:	movw   $0x6863,0x4(%rax)
  6d0829:	movl   $0x72616573,(%rax)
  6d082f:	lea    0x3c0(%rsp),%rdi
  6d0837:	movabs $0x384000002d0,%r14
  6d0841:	movss  -0x6930c9(%rip),%xmm0        # 3d780 <GCC_except_table0+0x34>
  6d0849:	mov    %r14,%rsi
  6d084c:	call   *0x34962e(%rip)        # a19e80 <_DYNAMIC+0x470>
  6d0852:	mov    0x3c0(%rsp),%r13
  6d085a:	cmp    $0xfffffffffffffffe,%r13
  6d085e:	jne    6d1f16 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1726>
  6d0864:	movq   $0x0,0x3d8(%rsp)
  6d0870:	movq   $0x8,0x3e0(%rsp)
  6d087c:	xorps  %xmm0,%xmm0
  6d087f:	movups %xmm0,0x3e8(%rsp)
  6d0887:	movq   $0xffffffffffffffff,0x3c0(%rsp)
  6d0893:	movq   $0x8,0x3f8(%rsp)
  6d089f:	movups %xmm0,0x400(%rsp)
  6d08a7:	movq   $0x8,0x410(%rsp)
  6d08b3:	movq   $0x0,0x418(%rsp)
  6d08bf:	movq   $0x1,0x420(%rsp)
  6d08cb:	mov    $0x1,%edi
  6d08d0:	call   *0x3495b2(%rip)        # a19e88 <_DYNAMIC+0x478>
  6d08d6:	mov    %rax,%r13
  6d08d9:	cmp    $0x1,%r13d
  6d08dd:	je     6d08f3 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x103>
  6d08df:	movq   $0x0,0x3c0(%rsp)
  6d08eb:	mov    %r13,0x3c8(%rsp)
  6d08f3:	call   *0x34935f(%rip)        # a19c58 <_DYNAMIC+0x248>
  6d08f9:	mov    $0x28,%edi
  6d08fe:	mov    $0x8,%esi
  6d0903:	call   *0x349357(%rip)        # a19c60 <_DYNAMIC+0x250>
  6d0909:	test   %rax,%rax
  6d090c:	je     6d1b14 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1324>
  6d0912:	mov    %rax,%r15
  6d0915:	lea    0x3d8(%rsp),%r12
  6d091d:	mov    %r13,(%rax)
  6d0920:	lea    -0x6930e3(%rip),%rax        # 3d844 <GCC_except_table0+0xf8>
  6d0927:	mov    %rax,0x8(%r15)
  6d092b:	movq   $0x4,0x10(%r15)
  6d0933:	lea    0x33416(%rip),%rax        # 703d50 <_RNvYNCNvXCs4gijoeCAvqI_25inspector_pointer_controlNtB7_5ModelNtCs6ZNK6sH19NW_4gpui4View7sources0INtNtNtCs4NRVxsYgnAr_4core3ops8function6FnOnceTRBM_EE9call_onceB7_>
  6d093a:	mov    %rax,0x18(%r15)
  6d093e:	lea    0x3341b(%rip),%rax        # 703d60 <_RNvYNCNvXCs4gijoeCAvqI_25inspector_pointer_controlNtB7_5ModelNtCs6ZNK6sH19NW_4gpui4View7sourcess_0INtNtNtCs4NRVxsYgnAr_4core3ops8function6FnOnceTQBM_EE9call_onceB7_>
  6d0945:	mov    %rax,0x20(%r15)
  6d0949:	mov    %r12,%rdi
  6d094c:	call   6ddf10 <_RNvMs3_NtCscdodAO9FK5_5alloc7raw_vecINtB5_6RawVecAINtNtCs4NRVxsYgnAr_4core6option6OptionNtNtCs6ZNK6sH19NW_4gpui6source7FieldIdEj2_E8grow_oneCs4gijoeCAvqI_25inspector_pointer_control>
  6d0951:	mov    0x3e0(%rsp),%rax
  6d0959:	mov    %r15,(%rax)
  6d095c:	lea    0x329ae5(%rip),%rcx        # 9fa448 <__frame_dummy_init_array_entry+0x208>
  6d0963:	mov    %rcx,0x8(%rax)
  6d0967:	movq   $0x1,0x3e8(%rsp)
  6d0973:	mov    0x3c0(%rsp),%rax
  6d097b:	movups 0x40(%r12),%xmm0
  6d0981:	movaps %xmm0,0x160(%rsp)
  6d0989:	movups (%r12),%xmm0
  6d098e:	movups 0x10(%r12),%xmm1
  6d0994:	movups 0x20(%r12),%xmm2
  6d099a:	movups 0x30(%r12),%xmm3
  6d09a0:	movaps %xmm3,0x150(%rsp)
  6d09a8:	movaps %xmm2,0x140(%rsp)
  6d09b0:	movaps %xmm1,0x130(%rsp)
  6d09b8:	movups 0x3c8(%rsp),%xmm2
  6d09c0:	movups %xmm0,0xb8(%rsp)
  6d09c8:	movups %xmm1,0xc8(%rsp)
  6d09d0:	mov    0x140(%rsp),%rcx
  6d09d8:	mov    %rcx,0xd8(%rsp)
  6d09e0:	movups 0x148(%rsp),%xmm0
  6d09e8:	movups %xmm0,0xe0(%rsp)
  6d09f0:	movups 0x158(%rsp),%xmm0
  6d09f8:	movups %xmm0,0xf0(%rsp)
  6d0a00:	mov    0x168(%rsp),%rcx
  6d0a08:	mov    %rcx,0x100(%rsp)
  6d0a10:	mov    %rax,0xa0(%rsp)
  6d0a18:	movups %xmm2,0xa8(%rsp)
  6d0a20:	movl   $0x0,0x120(%rsp)
  6d0a2b:	movl   $0x434b0000,0x128(%rsp)
  6d0a36:	movw   $0x0,0x12c(%rsp)
  6d0a40:	lea    0x3c0(%rsp),%rdi
  6d0a48:	lea    0x120(%rsp),%rcx
  6d0a50:	mov    $0x2d0,%esi
  6d0a55:	mov    $0x384,%edx
  6d0a5a:	call   *0x349430(%rip)        # a19e90 <_DYNAMIC+0x480>
  6d0a60:	mov    0x3c0(%rsp),%r13
  6d0a68:	mov    0x3c8(%rsp),%r15d
  6d0a70:	mov    0x3cc(%rsp),%r12d
  6d0a78:	cmp    $0x2,%r13
  6d0a7c:	je     6d1f5f <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x176f>
  6d0a82:	lea    0x3d0(%rsp),%rsi
  6d0a8a:	lea    0xb20(%rsp),%rdi
  6d0a92:	mov    $0x1d8,%edx
  6d0a97:	call   *0x3491d3(%rip)        # a19c70 <memcpy@GLIBC_2.14>
  6d0a9d:	mov    %r13,0xb10(%rsp)
  6d0aa5:	mov    %r15d,0xb18(%rsp)
  6d0aad:	mov    %r12d,0xb1c(%rsp)
  6d0ab5:	call   *0x3493dd(%rip)        # a19e98 <_DYNAMIC+0x488>
  6d0abb:	mov    %rax,%r15
  6d0abe:	lea    0x120(%rsp),%rdi
  6d0ac6:	call   *0x3493d4(%rip)        # a19ea0 <_DYNAMIC+0x490>
  6d0acc:	movq   $0x6,0x660(%rsp)
  6d0ad8:	movl   $0x0,0x668(%rsp)
  6d0ae3:	movq   $0x0,0x670(%rsp)
  6d0aef:	movups 0xa0(%rsp),%xmm0
  6d0af7:	movups 0xb0(%rsp),%xmm1
  6d0aff:	movups 0xc0(%rsp),%xmm2
  6d0b07:	movups 0xd0(%rsp),%xmm3
  6d0b0f:	movups %xmm0,0x5e8(%rsp)
  6d0b17:	movups %xmm1,0x5f8(%rsp)
  6d0b1f:	movups %xmm2,0x608(%rsp)
  6d0b27:	movups %xmm3,0x618(%rsp)
  6d0b2f:	movups 0xe0(%rsp),%xmm0
  6d0b37:	movups %xmm0,0x628(%rsp)
  6d0b3f:	movups 0xf0(%rsp),%xmm0
  6d0b47:	movups %xmm0,0x638(%rsp)
  6d0b4f:	mov    0x100(%rsp),%rax
  6d0b57:	mov    %rax,0x648(%rsp)
  6d0b5f:	lea    0x6a8(%rsp),%rdi
  6d0b67:	lea    0x120(%rsp),%rsi
  6d0b6f:	mov    0x3490fa(%rip),%r12        # a19c70 <memcpy@GLIBC_2.14>
  6d0b76:	mov    $0x298,%edx
  6d0b7b:	call   *%r12
  6d0b7e:	lea    0x3c0(%rsp),%rdi
  6d0b86:	lea    0xb10(%rsp),%rsi
  6d0b8e:	mov    $0x1e8,%edx
  6d0b93:	call   *%r12
  6d0b96:	movq   $0x6,0x650(%rsp)
  6d0ba2:	mov    %rbx,0x658(%rsp)
  6d0baa:	movq   $0x0,0x678(%rsp)
  6d0bb6:	movq   $0x8,0x680(%rsp)
  6d0bc2:	xorps  %xmm0,%xmm0
  6d0bc5:	movups %xmm0,0x688(%rsp)
  6d0bcd:	movq   $0x8,0x698(%rsp)
  6d0bd9:	movq   $0x0,0x6a0(%rsp)
  6d0be5:	movq   $0x0,0x9c0(%rsp)
  6d0bf1:	movups %xmm0,0x5a8(%rsp)
  6d0bf9:	movups %xmm0,0x5b8(%rsp)
  6d0c01:	movups %xmm0,0x9a8(%rsp)
  6d0c09:	movq   $0x1,0x9c8(%rsp)
  6d0c15:	movq   $0x0,0x9d0(%rsp)
  6d0c21:	mov    %r15,0x998(%rsp)
  6d0c29:	movq   $0x0,0x9e0(%rsp)
  6d0c35:	movq   $0x0,0xa28(%rsp)
  6d0c41:	movups %xmm0,0x9f0(%rsp)
  6d0c49:	movq   $0x0,0xa00(%rsp)
  6d0c55:	movups %xmm0,0xa10(%rsp)
  6d0c5d:	movq   $0x0,0x940(%rsp)
  6d0c69:	movq   $0x8,0x948(%rsp)
  6d0c75:	movups %xmm0,0x950(%rsp)
  6d0c7d:	movq   $0x0,0xa30(%rsp)
  6d0c89:	movq   $0x0,0xa40(%rsp)
  6d0c95:	movl   $0x1000101,0xb00(%rsp)
  6d0ca0:	movw   $0x0,0xb04(%rsp)
  6d0caa:	movups %xmm0,0xa48(%rsp)
  6d0cb2:	movq   $0x0,0xa58(%rsp)
  6d0cbe:	mov    %r14,0xa60(%rsp)
  6d0cc6:	movsd  -0x6929ee(%rip),%xmm1        # 3e2e0 <GCC_except_table0+0xb94>
  6d0cce:	movsd  %xmm1,0xaf8(%rsp)
  6d0cd7:	movq   $0x1,0x9a0(%rsp)
  6d0ce3:	movq   $0xffffffffffffffff,0x970(%rsp)
  6d0cef:	movq   $0x0,0xa68(%rsp)
  6d0cfb:	movq   $0x0,0xa78(%rsp)
  6d0d07:	movq   $0x8,0x960(%rsp)
  6d0d13:	movq   $0x0,0x968(%rsp)
  6d0d1f:	movb   $0x0,0xb06(%rsp)
  6d0d27:	movups %xmm0,0xae0(%rsp)
  6d0d2f:	movups %xmm0,0xad0(%rsp)
  6d0d37:	movups %xmm0,0xac0(%rsp)
  6d0d3f:	movups %xmm0,0xab0(%rsp)
  6d0d47:	movups %xmm0,0xaa0(%rsp)
  6d0d4f:	movups %xmm0,0xa90(%rsp)
  6d0d57:	movups %xmm0,0xa80(%rsp)
  6d0d5f:	movq   $0x0,0xaf0(%rsp)
  6d0d6b:	call   *0x348ee7(%rip)        # a19c58 <_DYNAMIC+0x248>
  6d0d71:	mov    $0x748,%edi
  6d0d76:	mov    $0x8,%esi
  6d0d7b:	call   *0x348edf(%rip)        # a19c60 <_DYNAMIC+0x250>
  6d0d81:	test   %rax,%rax
  6d0d84:	je     6d1b29 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1339>
  6d0d8a:	mov    %rax,%rbx
  6d0d8d:	lea    0x3c0(%rsp),%rsi
  6d0d95:	mov    $0x748,%edx
  6d0d9a:	mov    %rax,%rdi
  6d0d9d:	call   *0x348ecd(%rip)        # a19c70 <memcpy@GLIBC_2.14>
  6d0da3:	mov    %rbx,0x8(%rsp)
  6d0da8:	lea    0x10(%rsp),%rdx
  6d0dad:	movq   $0x0,(%rsp)
  6d0db5:	lea    0x68(%rsp),%rdi
  6d0dba:	mov    $0x8,%r8d
  6d0dc0:	mov    %rbx,%rsi
  6d0dc3:	mov    $0x1,%ecx
  6d0dc8:	xor    %r9d,%r9d
  6d0dcb:	call   6d6940 <_RNvMNtNtCs6ZNK6sH19NW_4gpui7runtime4turnINtB4_10RuntimeMutNtCs4gijoeCAvqI_25inspector_pointer_control5ModeluE21describe_with_changedBW_>
  6d0dd0:	mov    0x68(%rsp),%r13
  6d0dd5:	cmp    $0xfffffffffffffffe,%r13
  6d0dd9:	jne    6d1e83 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1693>
  6d0ddf:	lea    0x68(%rsp),%rdi
  6d0de4:	mov    %rbx,%rsi
  6d0de7:	call   6f9340 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE7presentBO_>
  6d0dec:	mov    0x68(%rsp),%r13
  6d0df1:	cmp    $0xfffffffffffffffe,%r13
  6d0df5:	jne    6d1e83 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1693>
  6d0dfb:	mov    0x8(%rsp),%rdi
  6d0e00:	mov    %rdi,0x8(%rsp)
  6d0e05:	call   6d06f0 <_RNvCs4gijoeCAvqI_25inspector_pointer_control3ack>
  6d0e0a:	mov    0x8(%rsp),%rbx
  6d0e0f:	test   %rbx,%rbx
  6d0e12:	je     6d1f94 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x17a4>
  6d0e18:	cmpb   $0x0,0x746(%rbx)
  6d0e1f:	jne    6d1f9b <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x17ab>
  6d0e25:	cmpb   $0x1,0x742(%rbx)
  6d0e2c:	jne    6d1fa2 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x17b2>
  6d0e32:	mov    0x5a8(%rbx),%r13
  6d0e39:	mov    $0x1a,%eax
  6d0e3e:	mov    %rax,0x10(%rsp)
  6d0e43:	test   %r13,%r13
  6d0e46:	je     6d1fac <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x17bc>
  6d0e4c:	mov    0x5a0(%rbx),%rbp
  6d0e53:	shl    $0x6,%r13
  6d0e57:	lea    0x1e8(%rbx),%r14
  6d0e5e:	xor    %r12d,%r12d
  6d0e61:	mov    0x348e78(%rip),%r15        # a19ce0 <_DYNAMIC+0x2d0>
  6d0e68:	jmp    6d0e7d <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x68d>
  6d0e6a:	nopw   0x0(%rax,%rax,1)
  6d0e70:	add    $0x40,%r12
  6d0e74:	cmp    %r12,%r13
  6d0e77:	je     6d1fac <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x17bc>
  6d0e7d:	cmpb   $0x4,0x3d(%rbp,%r12,1)
  6d0e83:	jne    6d0e70 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x680>
  6d0e85:	mov    0x20(%rbp,%r12,1),%rsi
  6d0e8a:	mov    %r14,%rdi
  6d0e8d:	call   *%r15
  6d0e90:	test   %al,%al
  6d0e92:	je     6d0e70 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x680>
  6d0e94:	mov    0x20(%rbp,%r12,1),%rsi
  6d0e99:	add    $0x5d8,%rbx
  6d0ea0:	mov    %rbx,%rdi
  6d0ea3:	call   *0x348fcf(%rip)        # a19e78 <_DYNAMIC+0x468>
  6d0ea9:	mov    %rax,%r14
  6d0eac:	lea    0x10(%rsp),%rax
  6d0eb1:	mov    0x8(%rsp),%r15
  6d0eb6:	test   %r15,%r15
  6d0eb9:	je     6d1ff2 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1802>
  6d0ebf:	mov    %r15,0xa0(%rsp)
  6d0ec7:	mov    %rax,0xa8(%rsp)
  6d0ecf:	cmpb   $0x1,0x746(%r15)
  6d0ed7:	je     6d200f <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x181f>
  6d0edd:	cmp    0x5d8(%r15),%r14
  6d0ee4:	jne    6d2020 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1830>
  6d0eea:	mov    %rdx,%rbx
  6d0eed:	lea    0x3c0(%rsp),%rdi
  6d0ef5:	mov    %r15,%rsi
  6d0ef8:	call   6f8be0 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE16resolve_identityBO_>
  6d0efd:	mov    0x3c0(%rsp),%rax
  6d0f05:	cmp    $0xfffffffffffffffe,%rax
  6d0f09:	jne    6d2027 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1837>
  6d0f0f:	cmpb   $0x1,0x742(%r15)
  6d0f17:	jne    6d1e61 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1671>
  6d0f1d:	cmpb   $0x0,0x743(%r15)
  6d0f25:	jne    6d1e61 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1671>
  6d0f2b:	cmpb   $0x0,0x744(%r15)
  6d0f33:	je     6d1e61 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1671>
  6d0f39:	cmpq   $0xffffffffffffffff,0x5b0(%r15)
  6d0f41:	jne    6d1e61 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1671>
  6d0f47:	mov    0x688(%r15),%rax
  6d0f4e:	cmp    0x690(%r15),%rax
  6d0f55:	jne    6d1e61 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1671>
  6d0f5b:	mov    0x6a0(%r15),%rax
  6d0f62:	cmp    0x698(%r15),%rax
  6d0f69:	jne    6d1e61 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1671>
  6d0f6f:	movss  0x738(%r15),%xmm0
  6d0f78:	ucomiss 0x73c(%r15),%xmm0
  6d0f80:	jne    6d1e61 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1671>
  6d0f86:	jp     6d1e61 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1671>
  6d0f8c:	mov    0x5a0(%r15),%r12
  6d0f93:	mov    0x5a8(%r15),%rax
  6d0f9a:	lea    -0x38(%r12),%rcx
  6d0f9f:	shl    $0x6,%rax
  6d0fa3:	neg    %rax
  6d0fa6:	xor    %ebp,%ebp
  6d0fa8:	nopl   0x0(%rax,%rax,1)
  6d0fb0:	cmp    %rbp,%rax
  6d0fb3:	je     6d1dd8 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x15e8>
  6d0fb9:	add    $0xffffffffffffffc0,%rbp
  6d0fbd:	lea    0x40(%rcx),%r13
  6d0fc1:	cmp    %rbx,0x58(%rcx)
  6d0fc5:	mov    %r13,%rcx
  6d0fc8:	jne    6d0fb0 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x7c0>
  6d0fca:	mov    0x638(%r15),%rax
  6d0fd1:	test   %rax,%rax
  6d0fd4:	je     6d0ff2 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x802>
  6d0fd6:	mov    0x100(%rax),%rsi
  6d0fdd:	test   %rsi,%rsi
  6d0fe0:	je     6d0ff2 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x802>
  6d0fe2:	lea    0x120(%rsp),%rdi
  6d0fea:	call   *0x348e80(%rip)        # a19e70 <_DYNAMIC+0x460>
  6d0ff0:	jmp    6d1009 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x819>
  6d0ff2:	movq   $0x4,0x120(%rsp)
  6d0ffe:	xorps  %xmm0,%xmm0
  6d1001:	movups %xmm0,0x128(%rsp)
  6d1009:	lea    0x120(%rsp),%rdi
  6d1011:	call   *0x348e91(%rip)        # a19ea8 <_DYNAMIC+0x498>
  6d1017:	mov    %rdx,%rcx
  6d101a:	sub    %rbp,%r12
  6d101d:	lea    -0x40(%r12),%rsi
  6d1022:	lea    0x3c0(%rsp),%rdi
  6d102a:	mov    %rax,%rdx
  6d102d:	call   *0x348e7d(%rip)        # a19eb0 <_DYNAMIC+0x4a0>
  6d1033:	cmpb   $0x0,0x3c0(%rsp)
  6d103b:	je     6d1085 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x895>
  6d103d:	lea    0x3c4(%rsp),%rsi
  6d1045:	movss  0x0(%r13),%xmm0
  6d104b:	movss  0x4(%r13),%xmm1
  6d1051:	lea    0x68(%rsp),%rdi
  6d1056:	call   6ce800 <_RNCNvMss_NtCs6ZNK6sH19NW_4gpui7runtimeINtB7_3WinNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE5clicks_0BM_>
  6d105b:	cmpl   $0x1,0x68(%rsp)
  6d1060:	jne    6d1085 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x895>
  6d1062:	movsd  0x6c(%rsp),%xmm0
  6d1068:	movaps %xmm0,%xmm1
  6d106b:	shufps $0x55,%xmm0,%xmm1
  6d106f:	add    $0xffffffffffffffd0,%r12
  6d1073:	mov    %r12,%rdi
  6d1076:	movaps %xmm0,0x10(%rsp)
  6d107b:	call   *0x348e37(%rip)        # a19eb8 <_DYNAMIC+0x4a8>
  6d1081:	test   %al,%al
  6d1083:	jne    6d10c2 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x8d2>
  6d1085:	movss  0x10(%r13),%xmm0
  6d108b:	xorps  %xmm2,%xmm2
  6d108e:	ucomiss %xmm2,%xmm0
  6d1091:	jne    6d1099 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x8a9>
  6d1093:	jnp    6d1e72 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1682>
  6d1099:	movss  0x14(%r13),%xmm1
  6d109f:	ucomiss %xmm2,%xmm1
  6d10a2:	jne    6d10aa <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x8ba>
  6d10a4:	jnp    6d1e72 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1682>
  6d10aa:	unpcklps %xmm1,%xmm0
  6d10ad:	mulps  -0x692484(%rip),%xmm0        # 3ec30 <GCC_except_table0+0x14e4>
  6d10b4:	movsd  0x8(%r13),%xmm1
  6d10ba:	addps  %xmm0,%xmm1
  6d10bd:	movaps %xmm1,0x10(%rsp)
  6d10c2:	movq   $0x19,0x3c0(%rsp)
  6d10ce:	lea    0x3c0(%rsp),%rdi
  6d10d6:	call   6be370 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueNtNtCs6ZNK6sH19NW_4gpui7runtime5ErrorECs4gijoeCAvqI_25inspector_pointer_control>
  6d10db:	movaps 0x10(%rsp),%xmm0
  6d10e0:	movaps %xmm0,%xmm1
  6d10e3:	shufps $0x55,%xmm0,%xmm1
  6d10e7:	mov    %r15,%rdi
  6d10ea:	movaps %xmm1,0x30(%rsp)
  6d10ef:	call   6f8ec0 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_>
  6d10f4:	movq   $0x19,0x3c0(%rsp)
  6d1100:	test   $0x1,%al
  6d1102:	je     6d1e72 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1682>
  6d1108:	mov    %rdx,%r12
  6d110b:	lea    0x3c0(%rsp),%rdi
  6d1113:	call   6be370 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueNtNtCs6ZNK6sH19NW_4gpui7runtime5ErrorECs4gijoeCAvqI_25inspector_pointer_control>
  6d1118:	cmp    %rbx,%r12
  6d111b:	jne    6d1e72 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1682>
  6d1121:	cmp    0x5d8(%r15),%r14
  6d1128:	jne    6d20a4 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x18b4>
  6d112e:	lea    0x3c0(%rsp),%rdi
  6d1136:	mov    %r15,%rsi
  6d1139:	mov    %rbx,%rdx
  6d113c:	call   6f8be0 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE16resolve_identityBO_>
  6d1141:	mov    0x3c0(%rsp),%rax
  6d1149:	mov    0x3c8(%rsp),%r12
  6d1151:	cmp    $0xfffffffffffffffe,%rax
  6d1155:	jne    6d20a9 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x18b9>
  6d115b:	mov    0x2c8(%r15),%rsi
  6d1162:	cmp    %rsi,%r12
  6d1165:	jae    6d20ee <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x18fe>
  6d116b:	mov    0x2c0(%r15),%rax
  6d1172:	lea    (%r12,%r12,4),%rcx
  6d1176:	mov    0x20(%rax,%rcx,8),%edi
  6d117a:	call   6e2670 <_RNvMsh_NtCs6ZNK6sH19NW_4gpui7runtimeNtB5_4Node4kind>
  6d117f:	cmp    $0x4,%al
  6d1181:	jne    6d11a8 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x9b8>
  6d1183:	lea    0x120(%rsp),%rdi
  6d118b:	mov    %r15,%rsi
  6d118e:	mov    %r14,%rdx
  6d1191:	mov    %rbx,%rcx
  6d1194:	movaps 0x10(%rsp),%xmm0
  6d1199:	movaps 0x30(%rsp),%xmm1
  6d119e:	xor    %r8d,%r8d
  6d11a1:	call   6dbfa0 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime7editingINtB7_10RuntimeMutNtCs4gijoeCAvqI_25inspector_pointer_control5ModeluE14select_pointerB12_>
  6d11a6:	jmp    6d11fb <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0xa0b>
  6d11a8:	mov    0x610(%r15),%r12
  6d11af:	mov    0x618(%r15),%r13
  6d11b6:	lea    0x3c0(%rsp),%rdi
  6d11be:	mov    %r15,%rsi
  6d11c1:	mov    %r14,%rdx
  6d11c4:	mov    %rbx,%rcx
  6d11c7:	call   6dbc20 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE5focusBW_>
  6d11cc:	mov    0x3c0(%rsp),%rax
  6d11d4:	cmp    $0xfffffffffffffffe,%rax
  6d11d8:	jne    6d120b <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0xa1b>
  6d11da:	lea    0x120(%rsp),%rdi
  6d11e2:	lea    0xa0(%rsp),%rsi
  6d11ea:	mov    %r14,%rdx
  6d11ed:	mov    %rbx,%rcx
  6d11f0:	mov    %r12,%r8
  6d11f3:	mov    %r13,%r9
  6d11f6:	call   6d3480 <_RNvMNtNtCs6ZNK6sH19NW_4gpui7runtime4turnINtB4_10RuntimeMutNtCs4gijoeCAvqI_25inspector_pointer_control5ModeluE16activate_focusedBW_>
  6d11fb:	cmpq   $0xfffffffffffffffe,0x120(%rsp)
  6d1204:	je     6d127d <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0xa8d>
  6d1206:	jmp    6d1de4 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x15f4>
  6d120b:	mov    0x3e8(%rsp),%rcx
  6d1213:	movzbl 0x3f0(%rsp),%edx
  6d121b:	mov    0x3f1(%rsp),%esi
  6d1222:	mov    %esi,0x151(%rsp)
  6d1229:	mov    0x3f4(%rsp),%esi
  6d1230:	mov    %esi,0x154(%rsp)
  6d1237:	movups 0x3c8(%rsp),%xmm0
  6d123f:	movups 0x3d8(%rsp),%xmm1
  6d1247:	mov    %rax,0x120(%rsp)
  6d124f:	movups %xmm0,0x128(%rsp)
  6d1257:	movups %xmm1,0x138(%rsp)
  6d125f:	mov    %rcx,0x148(%rsp)
  6d1267:	mov    %dl,0x150(%rsp)
  6d126e:	cmpq   $0xfffffffffffffffe,0x120(%rsp)
  6d1277:	jne    6d1de4 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x15f4>
  6d127d:	mov    0x8(%rsp),%rdi
  6d1282:	call   6d06f0 <_RNvCs4gijoeCAvqI_25inspector_pointer_control3ack>
  6d1287:	movsd  -0x692eaf(%rip),%xmm0        # 3e3e0 <GCC_except_table0+0xc94>
  6d128f:	movsd  %xmm0,0x3c0(%rsp)
  6d1298:	lea    0x3c0(%rsp),%rax
  6d12a0:	mov    0x8(%rsp),%rbp
  6d12a5:	test   %rbp,%rbp
  6d12a8:	je     6d20ff <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x190f>
  6d12ae:	cmpb   $0x0,0x746(%rbp)
  6d12b5:	jne    6d2106 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1916>
  6d12bb:	mov    $0x12,%eax
  6d12c0:	cmpb   $0x1,0x742(%rbp)
  6d12c7:	jne    6d210b <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x191b>
  6d12cd:	cmpb   $0x0,0x743(%rbp)
  6d12d4:	jne    6d210b <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x191b>
  6d12da:	cmpb   $0x0,0x744(%rbp)
  6d12e1:	je     6d210b <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x191b>
  6d12e7:	cmpq   $0xffffffffffffffff,0x5b0(%rbp)
  6d12ef:	jne    6d210b <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x191b>
  6d12f5:	mov    0x688(%rbp),%rcx
  6d12fc:	cmp    0x690(%rbp),%rcx
  6d1303:	jne    6d210b <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x191b>
  6d1309:	mov    0x6a0(%rbp),%rbx
  6d1310:	cmp    0x698(%rbp),%rbx
  6d1317:	jne    6d210b <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x191b>
  6d131d:	movss  0x738(%rbp),%xmm0
  6d1325:	ucomiss 0x73c(%rbp),%xmm0
  6d132c:	jne    6d210b <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x191b>
  6d1332:	jp     6d210b <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x191b>
  6d1338:	movsd  0x3c0(%rsp),%xmm0
  6d1341:	movaps %xmm0,0x40(%rsp)
  6d1346:	mov    0x6c0(%rbp),%rax
  6d134d:	mov    %rax,0x50(%rsp)
  6d1352:	mov    0x5a0(%rbp),%rax
  6d1359:	mov    %rax,0x10(%rsp)
  6d135e:	mov    0x5a8(%rbp),%r12
  6d1365:	movups 0x610(%rbp),%xmm0
  6d136c:	movaps %xmm0,0x30(%rsp)
  6d1371:	mov    0x638(%rbp),%r13
  6d1378:	test   %r13,%r13
  6d137b:	je     6d13c9 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0xbd9>
  6d137d:	mov    0xe0(%r13),%rax
  6d1384:	test   %rax,%rax
  6d1387:	je     6d13e8 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0xbf8>
  6d1389:	mov    0x38(%rax),%ecx
  6d138c:	mov    %ecx,0xb20(%rsp)
  6d1393:	movups 0x28(%rax),%xmm0
  6d1397:	movaps %xmm0,0xb10(%rsp)
  6d139f:	movzbl 0x3c(%rax),%r15d
  6d13a4:	movzbl 0x3f(%rax),%ecx
  6d13a8:	mov    %cl,0xa2(%rsp)
  6d13af:	movzwl 0x3d(%rax),%eax
  6d13b3:	mov    %ax,0xa0(%rsp)
  6d13bb:	mov    0x100(%r13),%rsi
  6d13c2:	test   %rsi,%rsi
  6d13c5:	jne    6d13f7 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0xc07>
  6d13c7:	jmp    6d13cc <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0xbdc>
  6d13c9:	mov    $0x2,%r15b
  6d13cc:	movq   $0x4,0x120(%rsp)
  6d13d8:	xorps  %xmm0,%xmm0
  6d13db:	movups %xmm0,0x128(%rsp)
  6d13e3:	mov    %r12,%r14
  6d13e6:	jmp    6d140c <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0xc1c>
  6d13e8:	mov    $0x2,%r15b
  6d13eb:	mov    0x100(%r13),%rsi
  6d13f2:	test   %rsi,%rsi
  6d13f5:	je     6d13cc <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0xbdc>
  6d13f7:	lea    0x120(%rsp),%rdi
  6d13ff:	call   *0x348a6b(%rip)        # a19e70 <_DYNAMIC+0x460>
  6d1405:	mov    0x5a8(%rbp),%r14
  6d140c:	lea    0x5d8(%rbp),%rax
  6d1413:	mov    %rax,0x108(%rsp)
  6d141b:	mov    %rax,0x410(%rsp)
  6d1423:	mov    0x50(%rsp),%rax
  6d1428:	mov    %rax,0x3e0(%rsp)
  6d1430:	mov    %rbx,0x3e8(%rsp)
  6d1438:	mov    0x10(%rsp),%rax
  6d143d:	mov    %rax,0x3d0(%rsp)
  6d1445:	mov    %r12,0x3d8(%rsp)
  6d144d:	movaps 0x30(%rsp),%xmm0
  6d1452:	movaps %xmm0,0x3c0(%rsp)
  6d145a:	mov    %r13,0x3f0(%rsp)
  6d1462:	mov    0x120(%rsp),%rax
  6d146a:	mov    %rax,0x3f8(%rsp)
  6d1472:	mov    0x128(%rsp),%rax
  6d147a:	mov    %rax,0x400(%rsp)
  6d1482:	mov    0x130(%rsp),%rax
  6d148a:	mov    %rax,0x408(%rsp)
  6d1492:	movaps 0xb10(%rsp),%xmm0
  6d149a:	movups %xmm0,0x418(%rsp)
  6d14a2:	mov    0xb20(%rsp),%eax
  6d14a9:	mov    %eax,0x428(%rsp)
  6d14b0:	mov    %r15b,0x42c(%rsp)
  6d14b8:	movzwl 0xa0(%rsp),%eax
  6d14c0:	mov    %ax,0x42d(%rsp)
  6d14c8:	movzbl 0xa2(%rsp),%eax
  6d14d0:	mov    %al,0x42f(%rsp)
  6d14d7:	test   %r14,%r14
  6d14da:	je     6d1efc <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x170c>
  6d14e0:	movaps 0x40(%rsp),%xmm0
  6d14e5:	shufps $0x55,%xmm0,%xmm0
  6d14e9:	movaps %xmm0,0x50(%rsp)
  6d14ee:	mov    $0x20,%r13d
  6d14f4:	xor    %r12d,%r12d
  6d14f7:	lea    0x3c0(%rsp),%r15
  6d14ff:	mov    0x3489ba(%rip),%rbx        # a19ec0 <_DYNAMIC+0x4b0>
  6d1506:	lea    0x32990b(%rip),%rax        # 9fae18 <__frame_dummy_init_array_entry+0xbd8>
  6d150d:	mov    %rax,0x60(%rsp)
  6d1512:	movq   $0x0,0x30(%rsp)
  6d151b:	movq   $0x0,0x10(%rsp)
  6d1524:	jmp    6d154c <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0xd5c>
  6d1526:	mov    0x5a0(%rbp),%rax
  6d152d:	incq   0x10(%rsp)
  6d1532:	mov    (%rax,%r13,1),%rax
  6d1536:	mov    %rax,0x30(%rsp)
  6d153b:	nopl   0x0(%rax,%rax,1)
  6d1540:	inc    %r12
  6d1543:	add    $0x40,%r13
  6d1547:	cmp    %r12,%r14
  6d154a:	je     6d159b <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0xdab>
  6d154c:	mov    %r15,%rdi
  6d154f:	mov    %r12,%rsi
  6d1552:	call   *%rbx
  6d1554:	test   %rax,%rax
  6d1557:	setne  %cl
  6d155a:	cmp    $0x5,%rdx
  6d155e:	sete   %dl
  6d1561:	and    %cl,%dl
  6d1563:	cmp    $0x1,%dl
  6d1566:	jne    6d1540 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0xd50>
  6d1568:	mov    (%rax),%ecx
  6d156a:	mov    $0x63656863,%edx
  6d156f:	xor    %edx,%ecx
  6d1571:	movzbl 0x4(%rax),%eax
  6d1575:	xor    $0x6b,%eax
  6d1578:	or     %ecx,%eax
  6d157a:	jne    6d1540 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0xd50>
  6d157c:	mov    0x5a8(%rbp),%rsi
  6d1583:	cmp    %rsi,%r12
  6d1586:	jb     6d1526 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0xd36>
  6d1588:	mov    %r12,%rdi
  6d158b:	mov    0x60(%rsp),%rdx
  6d1590:	call   *0x3486ea(%rip)        # a19c80 <_DYNAMIC+0x270>
  6d1596:	jmp    6d2300 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b10>
  6d159b:	mov    0x10(%rsp),%rcx
  6d15a0:	cmp    $0x1,%rcx
  6d15a4:	jne    6d1eee <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x16fe>
  6d15aa:	mov    0x108(%rsp),%rdi
  6d15b2:	mov    0x30(%rsp),%rsi
  6d15b7:	call   *0x3488bb(%rip)        # a19e78 <_DYNAMIC+0x468>
  6d15bd:	mov    %rax,%r14
  6d15c0:	mov    %rdx,%rbx
  6d15c3:	lea    0x8(%rsp),%rax
  6d15c8:	mov    %rax,0x3c0(%rsp)
  6d15d0:	lea    0x3c0(%rsp),%r12
  6d15d8:	mov    0x3c0(%rsp),%rax
  6d15e0:	mov    (%rax),%rsi
  6d15e3:	lea    0x120(%rsp),%rdi
  6d15eb:	movaps 0x40(%rsp),%xmm0
  6d15f0:	movaps 0x50(%rsp),%xmm1
  6d15f5:	call   6d3050 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8hit_only>
  6d15fa:	cmpl   $0xfffffffe,0x120(%rsp)
  6d1602:	jne    6d1b3e <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x134e>
  6d1608:	mov    0x128(%rsp),%rdx
  6d1610:	mov    0x130(%rsp),%rax
  6d1618:	mov    %rdx,0x3c0(%rsp)
  6d1620:	mov    %rax,0x3c8(%rsp)
  6d1628:	mov    %r14,0x110(%rsp)
  6d1630:	mov    %rbx,0x118(%rsp)
  6d1638:	cmp    %r14,%rdx
  6d163b:	sete   %cl
  6d163e:	test   %rdx,%rdx
  6d1641:	je     6d1ab4 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x12c4>
  6d1647:	lea    0x3295a2(%rip),%rdx        # 9fabf0 <__frame_dummy_init_array_entry+0x9b0>
  6d164e:	lea    0x110(%rsp),%r15
  6d1656:	test   %cl,%cl
  6d1658:	je     6d1c26 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1436>
  6d165e:	cmp    %rbx,%rax
  6d1661:	jne    6d1c26 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1436>
  6d1667:	movsd  -0x692c9f(%rip),%xmm0        # 3e9d0 <GCC_except_table0+0x1284>
  6d166f:	movsd  %xmm0,0x3c0(%rsp)
  6d1678:	lea    0x3c0(%rsp),%r12
  6d1680:	movss  0x3c0(%rsp),%xmm0
  6d1689:	movss  0x3c4(%rsp),%xmm1
  6d1692:	mov    0x8(%rsp),%rsi
  6d1697:	lea    0x120(%rsp),%rdi
  6d169f:	call   6d3050 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8hit_only>
  6d16a4:	cmpl   $0xfffffffe,0x120(%rsp)
  6d16ac:	jne    6d1bab <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x13bb>
  6d16b2:	movups 0x128(%rsp),%xmm0
  6d16ba:	movaps %xmm0,0x3c0(%rsp)
  6d16c2:	cmpq   $0x0,0x128(%rsp)
  6d16cb:	jne    6d1c18 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1428>
  6d16d1:	mov    $0xffffffff,%eax
  6d16d6:	mov    %rax,0xb10(%rsp)
  6d16de:	movq   $0x0,0xb18(%rsp)
  6d16ea:	movaps 0x40(%rsp),%xmm0
  6d16ef:	movlps %xmm0,0x3c4(%rsp)
  6d16f7:	movl   $0x0,0x3c0(%rsp)
  6d1702:	lea    0x3c0(%rsp),%rcx
  6d170a:	lea    0x120(%rsp),%rdi
  6d1712:	lea    0x8(%rsp),%rsi
  6d1717:	lea    0xb10(%rsp),%rdx
  6d171f:	call   6d23c0 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch>
  6d1724:	cmpl   $0xfffffffe,0x120(%rsp)
  6d172c:	jne    6d1a47 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1257>
  6d1732:	movl   $0x2,0x3c0(%rsp)
  6d173d:	lea    0x3c0(%rsp),%rcx
  6d1745:	lea    0x120(%rsp),%rdi
  6d174d:	lea    0x8(%rsp),%rsi
  6d1752:	lea    0xb10(%rsp),%rdx
  6d175a:	call   6d23c0 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch>
  6d175f:	cmpl   $0xfffffffe,0x120(%rsp)
  6d1767:	jne    6d1a47 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1257>
  6d176d:	movl   $0x3,0x3c0(%rsp)
  6d1778:	lea    0x3c0(%rsp),%r15
  6d1780:	lea    0x120(%rsp),%rdi
  6d1788:	lea    0x8(%rsp),%rsi
  6d178d:	lea    0xb10(%rsp),%rdx
  6d1795:	mov    %r15,%rcx
  6d1798:	call   6d23c0 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch>
  6d179d:	cmpl   $0xfffffffe,0x120(%rsp)
  6d17a5:	jne    6d1a47 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1257>
  6d17ab:	mov    0x8(%rsp),%rsi
  6d17b0:	test   %rsi,%rsi
  6d17b3:	je     6d1c36 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1446>
  6d17b9:	cmpq   $0x1,0x2b0(%rsi)
  6d17c1:	jne    6d1c7b <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x148b>
  6d17c7:	mov    %rsi,%rdi
  6d17ca:	call   6d06f0 <_RNvCs4gijoeCAvqI_25inspector_pointer_control3ack>
  6d17cf:	mov    0x8(%rsp),%rsi
  6d17d4:	lea    0x120(%rsp),%rdi
  6d17dc:	movaps 0x40(%rsp),%xmm0
  6d17e1:	movaps 0x50(%rsp),%xmm1
  6d17e6:	call   6d3050 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8hit_only>
  6d17eb:	cmpl   $0xfffffffe,0x120(%rsp)
  6d17f3:	jne    6d1c95 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x14a5>
  6d17f9:	mov    0x128(%rsp),%rdx
  6d1801:	mov    0x130(%rsp),%rax
  6d1809:	mov    %rdx,0xa0(%rsp)
  6d1811:	mov    %rax,0xa8(%rsp)
  6d1819:	mov    %r14,0x3c0(%rsp)
  6d1821:	mov    %rbx,0x3c8(%rsp)
  6d1829:	cmp    %r14,%rdx
  6d182c:	sete   %cl
  6d182f:	test   %rdx,%rdx
  6d1832:	je     6d1ad2 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x12e2>
  6d1838:	lea    0x329411(%rip),%rdx        # 9fac50 <__frame_dummy_init_array_entry+0xa10>
  6d183f:	lea    0xa0(%rsp),%r12
  6d1847:	test   %cl,%cl
  6d1849:	je     6d1c26 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1436>
  6d184f:	cmp    %rbx,%rax
  6d1852:	jne    6d1c26 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1436>
  6d1858:	movaps 0x40(%rsp),%xmm0
  6d185d:	movlps %xmm0,0x3c0(%rsp)
  6d1865:	lea    0x3c0(%rsp),%rax
  6d186d:	movss  0x3c0(%rsp),%xmm0
  6d1876:	movss  0x3c4(%rsp),%xmm1
  6d187f:	lea    0x120(%rsp),%rbx
  6d1887:	lea    0x8(%rsp),%rsi
  6d188c:	mov    %rbx,%rdi
  6d188f:	call   6d0380 <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only>
  6d1894:	cmpl   $0xfffffffe,0x120(%rsp)
  6d189c:	jne    6d1d02 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1512>
  6d18a2:	mov    0x8(%rsp),%rdi
  6d18a7:	call   6d06f0 <_RNvCs4gijoeCAvqI_25inspector_pointer_control3ack>
  6d18ac:	mov    0x8(%rsp),%rsi
  6d18b1:	test   %rsi,%rsi
  6d18b4:	je     6d1d6f <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x157f>
  6d18ba:	cmpq   $0x2,0x2b0(%rsi)
  6d18c2:	jne    6d1db4 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x15c4>
  6d18c8:	mov    0xb10(%rsp),%eax
  6d18cf:	cmp    $0xffffffff,%eax
  6d18d2:	je     6d18f2 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1102>
  6d18d4:	dec    %eax
  6d18d6:	mov    0xb14(%rsp),%ecx
  6d18dd:	mov    %eax,0x124(%rsp)
  6d18e4:	mov    %ecx,0x128(%rsp)
  6d18eb:	mov    $0x1,%eax
  6d18f0:	jmp    6d18f4 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1104>
  6d18f2:	xor    %eax,%eax
  6d18f4:	mov    %eax,0x120(%rsp)
  6d18fb:	movl   $0x42500000,0x3c8(%rsp)
  6d1906:	movabs $0x4140000000000001,%rcx
  6d1910:	mov    %rcx,0x3c0(%rsp)
  6d1918:	movabs $0x4250000041400000,%rcx
  6d1922:	cmp    %rcx,0x124(%rsp)
  6d192a:	sete   %cl
  6d192d:	test   %eax,%eax
  6d192f:	je     6d1af0 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1300>
  6d1935:	test   %cl,%cl
  6d1937:	je     6d1afa <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x130a>
  6d193d:	movaps 0x40(%rsp),%xmm0
  6d1942:	movss  %xmm0,0xa0(%rsp)
  6d194b:	movaps 0x50(%rsp),%xmm0
  6d1950:	movss  %xmm0,0x120(%rsp)
  6d1959:	lea    0xa0(%rsp),%rax
  6d1961:	mov    %rax,0x3c0(%rsp)
  6d1969:	mov    0x348558(%rip),%rax        # a19ec8 <_DYNAMIC+0x4b8>
  6d1970:	mov    %rax,0x3c8(%rsp)
  6d1978:	mov    %rbx,0x3d0(%rsp)
  6d1980:	mov    %rax,0x3d8(%rsp)
  6d1988:	lea    -0x6928af(%rip),%rax        # 3f0e0 <GCC_except_table0+0x1994>
  6d198f:	mov    %rax,0x3e0(%rsp)
  6d1997:	mov    0x348532(%rip),%rcx        # a19ed0 <_DYNAMIC+0x4c0>
  6d199e:	mov    %rcx,0x3e8(%rsp)
  6d19a6:	mov    %rax,0x3f0(%rsp)
  6d19ae:	mov    %rcx,0x3f8(%rsp)
  6d19b6:	lea    -0x692815(%rip),%rax        # 3f1a8 <GCC_except_table0+0x1a5c>
  6d19bd:	mov    %rax,0x400(%rsp)
  6d19c5:	mov    %rcx,0x408(%rsp)
  6d19cd:	lea    -0x692a4c(%rip),%rax        # 3ef88 <GCC_except_table0+0x183c>
  6d19d4:	mov    %rax,0x410(%rsp)
  6d19dc:	mov    %rcx,0x418(%rsp)
  6d19e4:	lea    -0x692753(%rip),%rax        # 3f298 <GCC_except_table0+0x1b4c>
  6d19eb:	mov    %rax,0x420(%rsp)
  6d19f3:	mov    %rcx,0x428(%rsp)
  6d19fb:	lea    -0x68960a(%rip),%rdi        # 483f8 <GCC_except_table0+0xacac>
  6d1a02:	lea    0x3c0(%rsp),%rsi
  6d1a0a:	call   *0x3484c8(%rip)        # a19ed8 <_DYNAMIC+0x4c8>
  6d1a10:	mov    0x8(%rsp),%rbx
  6d1a15:	test   %rbx,%rbx
  6d1a18:	je     6d1a35 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1245>
  6d1a1a:	mov    %rbx,%rdi
  6d1a1d:	call   6b9760 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtCs6ZNK6sH19NW_4gpui7runtime7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelEEB1h_>
  6d1a22:	mov    $0x748,%esi
  6d1a27:	mov    $0x8,%edx
  6d1a2c:	mov    %rbx,%rdi
  6d1a2f:	call   *0x34821b(%rip)        # a19c50 <_DYNAMIC+0x240>
  6d1a35:	add    $0xcf8,%rsp
  6d1a3c:	pop    %rbx
  6d1a3d:	pop    %r12
  6d1a3f:	pop    %r13
  6d1a41:	pop    %r14
  6d1a43:	pop    %r15
  6d1a45:	pop    %rbp
  6d1a46:	ret
  6d1a47:	mov    0x150(%rsp),%rax
  6d1a4f:	mov    %rax,0x3f0(%rsp)
  6d1a57:	movups 0x120(%rsp),%xmm0
  6d1a5f:	movups 0x130(%rsp),%xmm1
  6d1a67:	movups 0x140(%rsp),%xmm2
  6d1a6f:	movaps %xmm2,0x3e0(%rsp)
  6d1a77:	movaps %xmm1,0x3d0(%rsp)
  6d1a7f:	movaps %xmm0,0x3c0(%rsp)
  6d1a87:	lea    -0x687324(%rip),%rdi        # 4a76a <GCC_except_table0+0xd01e>
  6d1a8e:	lea    0x329293(%rip),%rcx        # 9fad28 <__frame_dummy_init_array_entry+0xae8>
  6d1a95:	lea    0x329244(%rip),%r8        # 9face0 <__frame_dummy_init_array_entry+0xaa0>
  6d1a9c:	lea    0x3c0(%rsp),%rdx
  6d1aa4:	mov    $0x2b,%esi
  6d1aa9:	call   *0x348251(%rip)        # a19d00 <_DYNAMIC+0x2f0>
  6d1aaf:	jmp    6d2300 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b10>
  6d1ab4:	xor    %ecx,%ecx
  6d1ab6:	lea    0x329133(%rip),%rdx        # 9fabf0 <__frame_dummy_init_array_entry+0x9b0>
  6d1abd:	lea    0x110(%rsp),%r15
  6d1ac5:	test   %cl,%cl
  6d1ac7:	jne    6d165e <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0xe6e>
  6d1acd:	jmp    6d1c26 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1436>
  6d1ad2:	xor    %ecx,%ecx
  6d1ad4:	lea    0x329175(%rip),%rdx        # 9fac50 <__frame_dummy_init_array_entry+0xa10>
  6d1adb:	lea    0xa0(%rsp),%r12
  6d1ae3:	test   %cl,%cl
  6d1ae5:	jne    6d184f <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x105f>
  6d1aeb:	jmp    6d1c26 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1436>
  6d1af0:	xor    %ecx,%ecx
  6d1af2:	test   %cl,%cl
  6d1af4:	jne    6d193d <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x114d>
  6d1afa:	lea    0x120(%rsp),%rdi
  6d1b02:	lea    0x3c0(%rsp),%rsi
  6d1b0a:	call   6c153b <_RINvNtCs4NRVxsYgnAr_4core9panicking13assert_failedINtNtB4_6option6OptionAmj2_EBM_ECs4gijoeCAvqI_25inspector_pointer_control>
  6d1b0f:	jmp    6d2300 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b10>
  6d1b14:	mov    $0x8,%edi
  6d1b19:	mov    $0x28,%esi
  6d1b1e:	call   *0x348144(%rip)        # a19c68 <_DYNAMIC+0x258>
  6d1b24:	jmp    6d2300 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b10>
  6d1b29:	mov    $0x8,%edi
  6d1b2e:	mov    $0x748,%esi
  6d1b33:	call   *0x34812f(%rip)        # a19c68 <_DYNAMIC+0x258>
  6d1b39:	jmp    6d2300 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b10>
  6d1b3e:	mov    0x150(%rsp),%rax
  6d1b46:	mov    %rax,0x3f0(%rsp)
  6d1b4e:	movups 0x120(%rsp),%xmm0
  6d1b56:	movups 0x130(%rsp),%xmm1
  6d1b5e:	movups 0x140(%rsp),%xmm2
  6d1b66:	movaps %xmm2,0x3e0(%rsp)
  6d1b6e:	movaps %xmm1,0x3d0(%rsp)
  6d1b76:	movaps %xmm0,0x3c0(%rsp)
  6d1b7e:	lea    -0x68741b(%rip),%rdi        # 4a76a <GCC_except_table0+0xd01e>
  6d1b85:	lea    0x32919c(%rip),%rcx        # 9fad28 <__frame_dummy_init_array_entry+0xae8>
  6d1b8c:	lea    0x329045(%rip),%r8        # 9fabd8 <__frame_dummy_init_array_entry+0x998>
  6d1b93:	lea    0x3c0(%rsp),%rdx
  6d1b9b:	mov    $0x2b,%esi
  6d1ba0:	call   *0x34815a(%rip)        # a19d00 <_DYNAMIC+0x2f0>
  6d1ba6:	jmp    6d2300 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b10>
  6d1bab:	mov    0x150(%rsp),%rax
  6d1bb3:	mov    %rax,0x3f0(%rsp)
  6d1bbb:	movups 0x120(%rsp),%xmm0
  6d1bc3:	movups 0x130(%rsp),%xmm1
  6d1bcb:	movups 0x140(%rsp),%xmm2
  6d1bd3:	movaps %xmm2,0x3e0(%rsp)
  6d1bdb:	movaps %xmm1,0x3d0(%rsp)
  6d1be3:	movaps %xmm0,0x3c0(%rsp)
  6d1beb:	lea    -0x687488(%rip),%rdi        # 4a76a <GCC_except_table0+0xd01e>
  6d1bf2:	lea    0x32912f(%rip),%rcx        # 9fad28 <__frame_dummy_init_array_entry+0xae8>
  6d1bf9:	lea    0x329008(%rip),%r8        # 9fac08 <__frame_dummy_init_array_entry+0x9c8>
  6d1c00:	lea    0x3c0(%rsp),%rdx
  6d1c08:	mov    $0x2b,%esi
  6d1c0d:	call   *0x3480ed(%rip)        # a19d00 <_DYNAMIC+0x2f0>
  6d1c13:	jmp    6d2300 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b10>
  6d1c18:	lea    0x3290d9(%rip),%rdx        # 9facf8 <__frame_dummy_init_array_entry+0xab8>
  6d1c1f:	lea    -0x693236(%rip),%r15        # 3e9f0 <GCC_except_table0+0x12a4>
  6d1c26:	mov    %r12,%rdi
  6d1c29:	mov    %r15,%rsi
  6d1c2c:	call   6c1573 <_RINvNtCs4NRVxsYgnAr_4core9panicking13assert_failedINtNtB4_6option6OptionNtNtCs6ZNK6sH19NW_4gpui8identity6TargetEBM_ECs4gijoeCAvqI_25inspector_pointer_control>
  6d1c31:	jmp    6d2300 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b10>
  6d1c36:	movq   $0xd,0x3c0(%rsp)
  6d1c42:	movq   $0x0,0x3c8(%rsp)
  6d1c4e:	lea    -0x6874eb(%rip),%rdi        # 4a76a <GCC_except_table0+0xd01e>
  6d1c55:	lea    0x3290cc(%rip),%rcx        # 9fad28 <__frame_dummy_init_array_entry+0xae8>
  6d1c5c:	lea    0x328fbd(%rip),%r8        # 9fac20 <__frame_dummy_init_array_entry+0x9e0>
  6d1c63:	lea    0x3c0(%rsp),%rdx
  6d1c6b:	mov    $0x2b,%esi
  6d1c70:	call   *0x34808a(%rip)        # a19d00 <_DYNAMIC+0x2f0>
  6d1c76:	jmp    6d2300 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b10>
  6d1c7b:	add    $0x2b0,%rsi
  6d1c82:	lea    0x32903f(%rip),%r9        # 9facc8 <__frame_dummy_init_array_entry+0xa88>
  6d1c89:	lea    -0x692bd0(%rip),%rdx        # 3f0c0 <GCC_except_table0+0x1974>
  6d1c90:	jmp    6d1dc9 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x15d9>
  6d1c95:	mov    0x150(%rsp),%rax
  6d1c9d:	mov    %rax,0x3f0(%rsp)
  6d1ca5:	movups 0x120(%rsp),%xmm0
  6d1cad:	movups 0x130(%rsp),%xmm1
  6d1cb5:	movups 0x140(%rsp),%xmm2
  6d1cbd:	movaps %xmm2,0x3e0(%rsp)
  6d1cc5:	movaps %xmm1,0x3d0(%rsp)
  6d1ccd:	movaps %xmm0,0x3c0(%rsp)
  6d1cd5:	lea    -0x687572(%rip),%rdi        # 4a76a <GCC_except_table0+0xd01e>
  6d1cdc:	lea    0x329045(%rip),%rcx        # 9fad28 <__frame_dummy_init_array_entry+0xae8>
  6d1ce3:	lea    0x328f4e(%rip),%r8        # 9fac38 <__frame_dummy_init_array_entry+0x9f8>
  6d1cea:	lea    0x3c0(%rsp),%rdx
  6d1cf2:	mov    $0x2b,%esi
  6d1cf7:	call   *0x348003(%rip)        # a19d00 <_DYNAMIC+0x2f0>
  6d1cfd:	jmp    6d2300 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b10>
  6d1d02:	mov    0x150(%rsp),%rax
  6d1d0a:	mov    %rax,0x3f0(%rsp)
  6d1d12:	movups 0x120(%rsp),%xmm0
  6d1d1a:	movups 0x130(%rsp),%xmm1
  6d1d22:	movups 0x140(%rsp),%xmm2
  6d1d2a:	movaps %xmm2,0x3e0(%rsp)
  6d1d32:	movaps %xmm1,0x3d0(%rsp)
  6d1d3a:	movaps %xmm0,0x3c0(%rsp)
  6d1d42:	lea    -0x6875df(%rip),%rdi        # 4a76a <GCC_except_table0+0xd01e>
  6d1d49:	lea    0x328fd8(%rip),%rcx        # 9fad28 <__frame_dummy_init_array_entry+0xae8>
  6d1d50:	lea    0x328f11(%rip),%r8        # 9fac68 <__frame_dummy_init_array_entry+0xa28>
  6d1d57:	lea    0x3c0(%rsp),%rdx
  6d1d5f:	mov    $0x2b,%esi
  6d1d64:	call   *0x347f96(%rip)        # a19d00 <_DYNAMIC+0x2f0>
  6d1d6a:	jmp    6d2300 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b10>
  6d1d6f:	movq   $0xd,0x3c0(%rsp)
  6d1d7b:	movq   $0x0,0x3c8(%rsp)
  6d1d87:	lea    -0x687624(%rip),%rdi        # 4a76a <GCC_except_table0+0xd01e>
  6d1d8e:	lea    0x328f93(%rip),%rcx        # 9fad28 <__frame_dummy_init_array_entry+0xae8>
  6d1d95:	lea    0x328ee4(%rip),%r8        # 9fac80 <__frame_dummy_init_array_entry+0xa40>
  6d1d9c:	lea    0x3c0(%rsp),%rdx
  6d1da4:	mov    $0x2b,%esi
  6d1da9:	call   *0x347f51(%rip)        # a19d00 <_DYNAMIC+0x2f0>
  6d1daf:	jmp    6d2300 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b10>
  6d1db4:	add    $0x2b0,%rsi
  6d1dbb:	lea    0x328eee(%rip),%r9        # 9facb0 <__frame_dummy_init_array_entry+0xa70>
  6d1dc2:	lea    -0x692c59(%rip),%rdx        # 3f170 <GCC_except_table0+0x1a24>
  6d1dc9:	xor    %edi,%edi
  6d1dcb:	xor    %ecx,%ecx
  6d1dcd:	call   *0x34810d(%rip)        # a19ee0 <_DYNAMIC+0x4d0>
  6d1dd3:	jmp    6d2300 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b10>
  6d1dd8:	movq   $0x11,0x120(%rsp)
  6d1de4:	mov    0x150(%rsp),%rax
  6d1dec:	mov    %rax,0x3f0(%rsp)
  6d1df4:	mov    0x120(%rsp),%rax
  6d1dfc:	mov    0x128(%rsp),%rcx
  6d1e04:	movups 0x130(%rsp),%xmm0
  6d1e0c:	movups 0x140(%rsp),%xmm1
  6d1e14:	movaps %xmm1,0x3e0(%rsp)
  6d1e1c:	movaps %xmm0,0x3d0(%rsp)
  6d1e24:	mov    %rax,0x3c0(%rsp)
  6d1e2c:	mov    %rcx,0x3c8(%rsp)
  6d1e34:	lea    -0x6876d1(%rip),%rdi        # 4a76a <GCC_except_table0+0xd01e>
  6d1e3b:	lea    0x328ee6(%rip),%rcx        # 9fad28 <__frame_dummy_init_array_entry+0xae8>
  6d1e42:	lea    0x328d5f(%rip),%r8        # 9faba8 <__frame_dummy_init_array_entry+0x968>
  6d1e49:	lea    0x3c0(%rsp),%rdx
  6d1e51:	mov    $0x2b,%esi
  6d1e56:	call   *0x347ea4(%rip)        # a19d00 <_DYNAMIC+0x2f0>
  6d1e5c:	jmp    6d2300 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b10>
  6d1e61:	movq   $0x12,0x120(%rsp)
  6d1e6d:	jmp    6d1de4 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x15f4>
  6d1e72:	movq   $0x19,0x120(%rsp)
  6d1e7e:	jmp    6d1de4 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x15f4>
  6d1e83:	mov    0x70(%rsp),%r15
  6d1e88:	movups 0x78(%rsp),%xmm0
  6d1e8d:	movaps %xmm0,0x10(%rsp)
  6d1e92:	movups 0x88(%rsp),%xmm0
  6d1e9a:	movaps %xmm0,0x30(%rsp)
  6d1e9f:	movzbl 0x98(%rsp),%ebp
  6d1ea7:	mov    0x99(%rsp),%eax
  6d1eae:	mov    %eax,0x28(%rsp)
  6d1eb2:	mov    0x9c(%rsp),%eax
  6d1eb9:	mov    %eax,0x2b(%rsp)
  6d1ebd:	mov    0x8(%rsp),%rbx
  6d1ec2:	test   %rbx,%rbx
  6d1ec5:	je     6d1ee2 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x16f2>
  6d1ec7:	mov    %rbx,%rdi
  6d1eca:	call   6b9760 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtCs6ZNK6sH19NW_4gpui7runtime7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelEEB1h_>
  6d1ecf:	mov    $0x748,%esi
  6d1ed4:	mov    $0x8,%edx
  6d1ed9:	mov    %rbx,%rdi
  6d1edc:	call   *0x347d6e(%rip)        # a19c50 <_DYNAMIC+0x240>
  6d1ee2:	mov    %r15,%r12
  6d1ee5:	shr    $0x20,%r12
  6d1ee9:	jmp    6d1f85 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1795>
  6d1eee:	mov    $0x1b,%eax
  6d1ef3:	test   %rcx,%rcx
  6d1ef6:	jne    6d210b <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x191b>
  6d1efc:	mov    $0x1a,%eax
  6d1f01:	jmp    6d210b <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x191b>
  6d1f06:	mov    $0x1,%edi
  6d1f0b:	mov    $0x6,%esi
  6d1f10:	call   *0x347dc2(%rip)        # a19cd8 <_DYNAMIC+0x2c8>
  6d1f16:	mov    0x3c8(%rsp),%r15
  6d1f1e:	mov    %r15,%r12
  6d1f21:	shr    $0x20,%r12
  6d1f25:	movups 0x3d0(%rsp),%xmm0
  6d1f2d:	movaps %xmm0,0x10(%rsp)
  6d1f32:	movups 0x3e0(%rsp),%xmm0
  6d1f3a:	movaps %xmm0,0x30(%rsp)
  6d1f3f:	movzbl 0x3f0(%rsp),%ebp
  6d1f47:	mov    0x3f1(%rsp),%eax
  6d1f4e:	mov    %eax,0x28(%rsp)
  6d1f52:	mov    0x3f4(%rsp),%eax
  6d1f59:	mov    %eax,0x2b(%rsp)
  6d1f5d:	jmp    6d1f72 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1782>
  6d1f5f:	lea    0xa0(%rsp),%rdi
  6d1f67:	call   6b95b0 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtCs6ZNK6sH19NW_4gpui6source7SourcesNtCs4gijoeCAvqI_25inspector_pointer_control5ModelEEB1g_>
  6d1f6c:	mov    $0x23,%r13d
  6d1f72:	mov    $0x6,%esi
  6d1f77:	mov    $0x1,%edx
  6d1f7c:	mov    %rbx,%rdi
  6d1f7f:	call   *0x347ccb(%rip)        # a19c50 <_DYNAMIC+0x240>
  6d1f85:	movaps 0x10(%rsp),%xmm0
  6d1f8a:	movaps 0x30(%rsp),%xmm1
  6d1f8f:	jmp    6d2290 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1aa0>
  6d1f94:	mov    $0xd,%eax
  6d1f99:	jmp    6d1fa7 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x17b7>
  6d1f9b:	mov    $0xe,%eax
  6d1fa0:	jmp    6d1fa7 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x17b7>
  6d1fa2:	mov    $0x12,%eax
  6d1fa7:	mov    %rax,0x10(%rsp)
  6d1fac:	mov    0x10(%rsp),%rax
  6d1fb1:	mov    %rax,0x3c0(%rsp)
  6d1fb9:	movq   $0x0,0x3c8(%rsp)
  6d1fc5:	lea    -0x68789a(%rip),%rdi        # 4a732 <GCC_except_table0+0xcfe6>
  6d1fcc:	lea    0x328d55(%rip),%rcx        # 9fad28 <__frame_dummy_init_array_entry+0xae8>
  6d1fd3:	lea    0x328bb6(%rip),%r8        # 9fab90 <__frame_dummy_init_array_entry+0x950>
  6d1fda:	lea    0x3c0(%rsp),%rdx
  6d1fe2:	mov    $0x2a,%esi
  6d1fe7:	call   *0x347d13(%rip)        # a19d00 <_DYNAMIC+0x2f0>
  6d1fed:	jmp    6d2300 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b10>
  6d1ff2:	movq   $0xd,0x120(%rsp)
  6d1ffe:	movq   $0x0,0x128(%rsp)
  6d200a:	jmp    6d1de4 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x15f4>
  6d200f:	movq   $0xe,0x120(%rsp)
  6d201b:	jmp    6d1de4 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x15f4>
  6d2020:	mov    $0x11,%eax
  6d2025:	jmp    6d205f <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x186f>
  6d2027:	mov    0x3c8(%rsp),%rcx
  6d202f:	movups 0x3d0(%rsp),%xmm0
  6d2037:	movaps %xmm0,0xb10(%rsp)
  6d203f:	movups 0x3e0(%rsp),%xmm0
  6d2047:	movaps %xmm0,0xb20(%rsp)
  6d204f:	mov    0x3f0(%rsp),%rdx
  6d2057:	mov    %rdx,0xb30(%rsp)
  6d205f:	mov    %rax,0x120(%rsp)
  6d2067:	mov    %rcx,0x128(%rsp)
  6d206f:	movaps 0xb10(%rsp),%xmm0
  6d2077:	movaps 0xb20(%rsp),%xmm1
  6d207f:	movups %xmm0,0x130(%rsp)
  6d2087:	movups %xmm1,0x140(%rsp)
  6d208f:	mov    0xb30(%rsp),%rax
  6d2097:	mov    %rax,0x150(%rsp)
  6d209f:	jmp    6d1de4 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x15f4>
  6d20a4:	mov    $0x11,%eax
  6d20a9:	mov    0x3f0(%rsp),%rcx
  6d20b1:	mov    %rcx,0x150(%rsp)
  6d20b9:	movups 0x3d0(%rsp),%xmm0
  6d20c1:	movups 0x3e0(%rsp),%xmm1
  6d20c9:	movups %xmm1,0x140(%rsp)
  6d20d1:	movups %xmm0,0x130(%rsp)
  6d20d9:	mov    %rax,0x120(%rsp)
  6d20e1:	mov    %r12,0x128(%rsp)
  6d20e9:	jmp    6d1de4 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x15f4>
  6d20ee:	lea    0x32932b(%rip),%rax        # 9fb420 <__frame_dummy_init_array_entry+0x11e0>
  6d20f5:	mov    %rax,0x60(%rsp)
  6d20fa:	jmp    6d1588 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0xd98>
  6d20ff:	mov    $0xd,%eax
  6d2104:	jmp    6d210b <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x191b>
  6d2106:	mov    $0xe,%eax
  6d210b:	mov    %rax,0x3c0(%rsp)
  6d2113:	mov    0x10(%rsp),%rax
  6d2118:	mov    %rax,0x3c8(%rsp)
  6d2120:	lea    -0x6879bd(%rip),%rdi        # 4a76a <GCC_except_table0+0xd01e>
  6d2127:	lea    0x328bfa(%rip),%rcx        # 9fad28 <__frame_dummy_init_array_entry+0xae8>
  6d212e:	lea    0x328a8b(%rip),%r8        # 9fabc0 <__frame_dummy_init_array_entry+0x980>
  6d2135:	lea    0x3c0(%rsp),%rdx
  6d213d:	mov    $0x2b,%esi
  6d2142:	call   *0x347bb8(%rip)        # a19d00 <_DYNAMIC+0x2f0>
  6d2148:	jmp    6d2300 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b10>
  6d214d:	mov    %rax,%r14
  6d2150:	jmp    6d238b <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b9b>
  6d2155:	mov    %rax,%r14
  6d2158:	jmp    6d238b <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b9b>
  6d215d:	mov    %rax,%r14
  6d2160:	jmp    6d21c4 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x19d4>
  6d2162:	mov    %rax,%r14
  6d2165:	lea    0x3282dc(%rip),%rsi        # 9fa448 <__frame_dummy_init_array_entry+0x208>
  6d216c:	mov    %r15,%rdi
  6d216f:	call   6bae40 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtCscdodAO9FK5_5alloc5boxed3BoxDG0_INtNtNtB4_3ops8function2FnTQL1_INtNtCs6ZNK6sH19NW_4gpui7element2ElL0_EEEp6OutputuEL_EECs4gijoeCAvqI_25inspector_pointer_control>
  6d2174:	jmp    6d2236 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1a46>
  6d2179:	call   *0x347af9(%rip)        # a19c78 <_DYNAMIC+0x268>
  6d217f:	mov    %rax,%r14
  6d2182:	lea    0x3c0(%rsp),%rdi
  6d218a:	call   6b95b0 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtCs6ZNK6sH19NW_4gpui6source7SourcesNtCs4gijoeCAvqI_25inspector_pointer_control5ModelEEB1g_>
  6d218f:	jmp    6d2243 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1a53>
  6d2194:	call   *0x347ade(%rip)        # a19c78 <_DYNAMIC+0x268>
  6d219a:	mov    %rax,%r14
  6d219d:	jmp    6d231d <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b2d>
  6d21a2:	mov    %rax,%r14
  6d21a5:	mov    0x8(%rsp),%rdi
  6d21aa:	call   6b9700 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtCs6ZNK6sH19NW_4gpui7runtime3WinNtCs4gijoeCAvqI_25inspector_pointer_control5ModelEEB1d_>
  6d21af:	jmp    6d237b <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b8b>
  6d21b4:	mov    %rax,%r14
  6d21b7:	lea    0xb10(%rsp),%rdi
  6d21bf:	call   6befc0 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueNtNtCshdpBObOiWw8_11gpui_canvas6canvas6CanvasECs4gijoeCAvqI_25inspector_pointer_control>
  6d21c4:	lea    0xa0(%rsp),%rdi
  6d21cc:	call   6b95b0 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtCs6ZNK6sH19NW_4gpui6source7SourcesNtCs4gijoeCAvqI_25inspector_pointer_control5ModelEEB1g_>
  6d21d1:	jmp    6d231d <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b2d>
  6d21d6:	jmp    6d236e <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b7e>
  6d21db:	call   *0x347a97(%rip)        # a19c78 <_DYNAMIC+0x268>
  6d21e1:	jmp    6d235c <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b6c>
  6d21e6:	jmp    6d236e <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b7e>
  6d21eb:	jmp    6d236e <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b7e>
  6d21f0:	jmp    6d235c <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b6c>
  6d21f5:	jmp    6d235c <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b6c>
  6d21fa:	jmp    6d235c <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b6c>
  6d21ff:	jmp    6d235c <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b6c>
  6d2204:	jmp    6d235c <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b6c>
  6d2209:	jmp    6d235c <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b6c>
  6d220e:	jmp    6d235c <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b6c>
  6d2213:	jmp    6d235c <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b6c>
  6d2218:	mov    %rax,%r14
  6d221b:	lea    0x3c0(%rsp),%rdi
  6d2223:	call   6b9760 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtCs6ZNK6sH19NW_4gpui7runtime7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelEEB1h_>
  6d2228:	jmp    6d237b <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b8b>
  6d222d:	call   *0x347a45(%rip)        # a19c78 <_DYNAMIC+0x268>
  6d2233:	mov    %rax,%r14
  6d2236:	lea    0x3c0(%rsp),%rdi
  6d223e:	call   6b95b0 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtCs6ZNK6sH19NW_4gpui6source7SourcesNtCs4gijoeCAvqI_25inspector_pointer_control5ModelEEB1g_>
  6d2243:	mov    %r14,%rdi
  6d2246:	call   *0x347c9c(%rip)        # a19ee8 <_DYNAMIC+0x4d8>
  6d224c:	mov    %rax,%r15
  6d224f:	mov    %rdx,%r12
  6d2252:	mov    (%rdx),%rax
  6d2255:	test   %rax,%rax
  6d2258:	je     6d225f <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1a6f>
  6d225a:	mov    %r15,%rdi
  6d225d:	call   *%rax
  6d225f:	mov    0x8(%r12),%rsi
  6d2264:	test   %rsi,%rsi
  6d2267:	je     6d2277 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1a87>
  6d2269:	mov    0x10(%r12),%rdx
  6d226e:	mov    %r15,%rdi
  6d2271:	call   *0x3479d9(%rip)        # a19c50 <_DYNAMIC+0x240>
  6d2277:	mov    $0x6,%esi
  6d227c:	mov    $0x1,%edx
  6d2281:	mov    %rbx,%rdi
  6d2284:	call   *0x3479c6(%rip)        # a19c50 <_DYNAMIC+0x240>
  6d228a:	mov    $0xf,%r13d
  6d2290:	mov    %r13,0x120(%rsp)
  6d2298:	shl    $0x20,%r12
  6d229c:	mov    %r15d,%eax
  6d229f:	or     %r12,%rax
  6d22a2:	mov    %rax,0x128(%rsp)
  6d22aa:	movups %xmm0,0x130(%rsp)
  6d22b2:	movups %xmm1,0x140(%rsp)
  6d22ba:	mov    %bpl,0x150(%rsp)
  6d22c2:	mov    0x28(%rsp),%eax
  6d22c6:	mov    0x2b(%rsp),%ecx
  6d22ca:	mov    %eax,0x151(%rsp)
  6d22d1:	mov    %ecx,0x154(%rsp)
  6d22d8:	lea    -0x687b75(%rip),%rdi        # 4a76a <GCC_except_table0+0xd01e>
  6d22df:	lea    0x328a42(%rip),%rcx        # 9fad28 <__frame_dummy_init_array_entry+0xae8>
  6d22e6:	lea    0x32888b(%rip),%r8        # 9fab78 <__frame_dummy_init_array_entry+0x938>
  6d22ed:	lea    0x120(%rsp),%rdx
  6d22f5:	mov    $0x2b,%esi
  6d22fa:	call   *0x347a00(%rip)        # a19d00 <_DYNAMIC+0x2f0>
  6d2300:	ud2
  6d2302:	mov    %rax,%r14
  6d2305:	mov    0x8(%r12),%rsi
  6d230a:	test   %rsi,%rsi
  6d230d:	je     6d231d <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b2d>
  6d230f:	mov    0x10(%r12),%rdx
  6d2314:	mov    %r15,%rdi
  6d2317:	call   *0x347933(%rip)        # a19c50 <_DYNAMIC+0x240>
  6d231d:	mov    $0x6,%esi
  6d2322:	mov    $0x1,%edx
  6d2327:	mov    %rbx,%rdi
  6d232a:	call   *0x347920(%rip)        # a19c50 <_DYNAMIC+0x240>
  6d2330:	mov    %r14,%rdi
  6d2333:	call   9f8e90 <_Unwind_Resume@plt>
  6d2338:	mov    %rax,%r14
  6d233b:	lea    0x120(%rsp),%rdi
  6d2343:	call   6be370 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueNtNtCs6ZNK6sH19NW_4gpui7runtime5ErrorECs4gijoeCAvqI_25inspector_pointer_control>
  6d2348:	mov    %r14,%rdi
  6d234b:	call   9f8e90 <_Unwind_Resume@plt>
  6d2350:	call   *0x347b9a(%rip)        # a19ef0 <_DYNAMIC+0x4e0>
  6d2356:	call   *0x34791c(%rip)        # a19c78 <_DYNAMIC+0x268>
  6d235c:	mov    %rax,%r14
  6d235f:	lea    0x3c0(%rsp),%rdi
  6d2367:	call   6be370 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueNtNtCs6ZNK6sH19NW_4gpui7runtime5ErrorECs4gijoeCAvqI_25inspector_pointer_control>
  6d236c:	jmp    6d2371 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b81>
  6d236e:	mov    %rax,%r14
  6d2371:	mov    0x8(%rsp),%rbx
  6d2376:	test   %rbx,%rbx
  6d2379:	jne    6d2383 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b93>
  6d237b:	mov    %r14,%rdi
  6d237e:	call   9f8e90 <_Unwind_Resume@plt>
  6d2383:	mov    %rbx,%rdi
  6d2386:	call   6b9760 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtCs6ZNK6sH19NW_4gpui7runtime7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelEEB1h_>
  6d238b:	mov    $0x748,%esi
  6d2390:	mov    $0x8,%edx
  6d2395:	mov    %rbx,%rdi
  6d2398:	call   *0x3478b2(%rip)        # a19c50 <_DYNAMIC+0x240>
  6d239e:	mov    %r14,%rdi
  6d23a1:	call   9f8e90 <_Unwind_Resume@plt>
  6d23a6:	mov    $0x748,%esi
  6d23ab:	mov    $0x8,%edx
  6d23b0:	mov    %rbx,%rdi
  6d23b3:	call   *0x347897(%rip)        # a19c50 <_DYNAMIC+0x240>
  6d23b9:	call   *0x3478b9(%rip)        # a19c78 <_DYNAMIC+0x268>

/tmp/gpui-inspector-pointer-codegen-split/candidate-frozen:     file format elf64-x86-64


Disassembly of section .text:

00000000006d23c0 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch>:
  6d23c0:	push   %rbp
  6d23c1:	push   %r15
  6d23c3:	push   %r14
  6d23c5:	push   %r13
  6d23c7:	push   %r12
  6d23c9:	push   %rbx
  6d23ca:	sub    $0xc8,%rsp
  6d23d1:	mov    %rdx,%r14
  6d23d4:	mov    %rdi,%rbx
  6d23d7:	mov    (%rcx),%ebp
  6d23d9:	test   %ebp,%ebp
  6d23db:	je     6d2410 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x50>
  6d23dd:	mov    0x8(%r14),%r12
  6d23e1:	mov    0x10(%r14),%r13
  6d23e5:	mov    0x18(%r14),%rax
  6d23e9:	movq   $0x0,0x8(%r14)
  6d23f1:	lea    -0x1(%rbp),%edx
  6d23f4:	lea    -0x69309b(%rip),%rdi        # 3f360 <GCC_except_table0+0x1c14>
  6d23fb:	movslq (%rdi,%rdx,4),%rdx
  6d23ff:	add    %rdi,%rdx
  6d2402:	jmp    *%rdx
  6d2404:	movl   $0xffffffff,(%r14)
  6d240b:	jmp    6d25d4 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x214>
  6d2410:	movd   0x4(%rcx),%xmm1
  6d2415:	movd   0x8(%rcx),%xmm0
  6d241a:	movd   %xmm1,%eax
  6d241e:	movd   %xmm0,%ecx
  6d2422:	mov    %eax,%edx
  6d2424:	and    $0x7fffffff,%edx
  6d242a:	cmp    $0x7f800000,%edx
  6d2430:	setge  %dl
  6d2433:	and    $0x7fffffff,%ecx
  6d2439:	cmp    $0x7f800000,%ecx
  6d243f:	setge  %cl
  6d2442:	or     %dl,%cl
  6d2444:	je     6d245d <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x9d>
  6d2446:	movl   $0xffffffff,(%r14)
  6d244d:	movq   $0x0,0x8(%r14)
  6d2455:	xor    %r12d,%r12d
  6d2458:	jmp    6d25d4 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x214>
  6d245d:	inc    %eax
  6d245f:	je     6d2fc9 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xc09>
  6d2465:	mov    %eax,(%r14)
  6d2468:	movd   %xmm0,0x4(%r14)
  6d246e:	xor    %r12d,%r12d
  6d2471:	jmp    6d25d4 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x214>
  6d2476:	mov    (%r14),%r15d
  6d2479:	cmp    $0xffffffff,%r15d
  6d247d:	je     6d25d4 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x214>
  6d2483:	mov    %rsi,%r13
  6d2486:	movups 0x8(%rcx),%xmm0
  6d248a:	movss  0x4(%r14),%xmm1
  6d2490:	movss  %xmm1,0x50(%rsp)
  6d2496:	movaps %xmm0,%xmm1
  6d2499:	unpckhpd %xmm0,%xmm1
  6d249d:	lea    0x10(%rsp),%rdi
  6d24a2:	movaps %xmm0,0xa0(%rsp)
  6d24aa:	call   *0x347a48(%rip)        # a19ef8 <_DYNAMIC+0x4e8>
  6d24b0:	cmpl   $0xfffffffe,0x10(%rsp)
  6d24b5:	jne    6d282d <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x46d>
  6d24bb:	mov    0x0(%r13),%r14
  6d24bf:	test   %r14,%r14
  6d24c2:	je     6d2606 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x246>
  6d24c8:	cmpb   $0x1,0x746(%r14)
  6d24d0:	je     6d25fa <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x23a>
  6d24d6:	cmpb   $0x1,0x742(%r14)
  6d24de:	jne    6d293a <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x57a>
  6d24e4:	cmpb   $0x0,0x743(%r14)
  6d24ec:	jne    6d293a <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x57a>
  6d24f2:	cmpb   $0x0,0x744(%r14)
  6d24fa:	je     6d293a <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x57a>
  6d2500:	cmpq   $0xffffffffffffffff,0x5b0(%r14)
  6d2508:	jne    6d293a <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x57a>
  6d250e:	mov    0x688(%r14),%rax
  6d2515:	cmp    0x690(%r14),%rax
  6d251c:	jne    6d293a <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x57a>
  6d2522:	mov    0x698(%r14),%rax
  6d2529:	cmp    %rax,0x6a0(%r14)
  6d2530:	jne    6d293a <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x57a>
  6d2536:	movss  0x738(%r14),%xmm0
  6d253f:	ucomiss 0x73c(%r14),%xmm0
  6d2547:	jne    6d293a <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x57a>
  6d254d:	jp     6d293a <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x57a>
  6d2553:	mov    %eax,%ecx
  6d2555:	cvtsi2ss %rcx,%xmm2
  6d255a:	dec    %r15d
  6d255d:	shr    $0x20,%rax
  6d2561:	mov    %eax,%eax
  6d2563:	xorps  %xmm1,%xmm1
  6d2566:	cvtsi2ss %rax,%xmm1
  6d256b:	movd   %r15d,%xmm0
  6d2570:	movq   $0x0,0x10(%rsp)
  6d2579:	movss  %xmm2,0x18(%rsp)
  6d257f:	movss  %xmm1,0x1c(%rsp)
  6d2585:	lea    0x10(%rsp),%rdi
  6d258a:	movd   %xmm0,0x8(%rsp)
  6d2590:	movss  0x50(%rsp),%xmm1
  6d2596:	call   *0x34791c(%rip)        # a19eb8 <_DYNAMIC+0x4a8>
  6d259c:	test   %al,%al
  6d259e:	je     6d2fbd <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xbfd>
  6d25a4:	mov    0x638(%r14),%rax
  6d25ab:	test   %rax,%rax
  6d25ae:	je     6d2e07 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xa47>
  6d25b4:	mov    0x100(%rax),%rsi
  6d25bb:	test   %rsi,%rsi
  6d25be:	je     6d2e07 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xa47>
  6d25c4:	lea    0x60(%rsp),%rdi
  6d25c9:	call   *0x3478a1(%rip)        # a19e70 <_DYNAMIC+0x460>
  6d25cf:	jmp    6d2e1a <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xa5a>
  6d25d4:	mov    (%rsi),%r15
  6d25d7:	test   %r15,%r15
  6d25da:	je     6d2606 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x246>
  6d25dc:	add    $0x8,%rsi
  6d25e0:	mov    %r15,0xb8(%rsp)
  6d25e8:	mov    %rsi,0xc0(%rsp)
  6d25f0:	cmpb   $0x1,0x746(%r15)
  6d25f8:	jne    6d261a <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x25a>
  6d25fa:	movq   $0xe,(%rbx)
  6d2601:	jmp    6d29ea <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x62a>
  6d2606:	movq   $0xd,(%rbx)
  6d260d:	movq   $0x0,0x8(%rbx)
  6d2615:	jmp    6d29ea <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x62a>
  6d261a:	movq   $0x0,0x730(%r15)
  6d2625:	cmp    $0x3,%ebp
  6d2628:	je     6d27fe <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x43e>
  6d262e:	cmp    $0x2,%ebp
  6d2631:	je     6d274a <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x38a>
  6d2637:	test   %ebp,%ebp
  6d2639:	jne    6d2991 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x5d1>
  6d263f:	mov    0x638(%r15),%rax
  6d2646:	test   %rax,%rax
  6d2649:	je     6d2661 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x2a1>
  6d264b:	mov    0xd8(%rax),%rax
  6d2652:	test   %rax,%rax
  6d2655:	je     6d2661 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x2a1>
  6d2657:	cmpb   $0x0,0x12(%rax)
  6d265b:	jne    6d2991 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x5d1>
  6d2661:	mov    0x8(%r14),%r12
  6d2665:	test   %r12,%r12
  6d2668:	je     6d2991 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x5d1>
  6d266e:	cmp    0x5d8(%r15),%r12
  6d2675:	jne    6d2989 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x5c9>
  6d267b:	mov    0x10(%r14),%r13
  6d267f:	lea    0x60(%rsp),%rdi
  6d2684:	mov    %r15,%rsi
  6d2687:	mov    %r13,%rdx
  6d268a:	call   6f8be0 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE16resolve_identityBO_>
  6d268f:	mov    0x60(%rsp),%rax
  6d2694:	cmp    $0xfffffffffffffffe,%rax
  6d2698:	jne    6d2946 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x586>
  6d269e:	mov    0x68(%rsp),%rdi
  6d26a3:	mov    0x2c8(%r15),%rsi
  6d26aa:	cmp    %rsi,%rdi
  6d26ad:	jae    6d2fe2 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xc22>
  6d26b3:	mov    0x2c0(%r15),%rax
  6d26ba:	lea    (%rdi,%rdi,4),%rcx
  6d26be:	mov    0x20(%rax,%rcx,8),%edi
  6d26c2:	call   6e2670 <_RNvMsh_NtCs6ZNK6sH19NW_4gpui7runtimeNtB5_4Node4kind>
  6d26c7:	cmp    $0x4,%al
  6d26c9:	jne    6d29fc <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x63c>
  6d26cf:	mov    (%r14),%eax
  6d26d2:	cmp    $0xffffffff,%eax
  6d26d5:	je     6d2ff1 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xc31>
  6d26db:	movd   0x4(%r14),%xmm1
  6d26e1:	dec    %eax
  6d26e3:	movd   %eax,%xmm0
  6d26e7:	lea    0x10(%rsp),%rdi
  6d26ec:	mov    %r15,%rsi
  6d26ef:	mov    %r12,%rdx
  6d26f2:	mov    %r13,%rcx
  6d26f5:	mov    $0x1,%r8d
  6d26fb:	call   6dbfa0 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime7editingINtB7_10RuntimeMutNtCs4gijoeCAvqI_25inspector_pointer_control5ModeluE14select_pointerB12_>
  6d2700:	mov    0x10(%rsp),%rax
  6d2705:	cmp    $0xfffffffffffffffe,%rax
  6d2709:	je     6d2718 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x358>
  6d270b:	cmp    $0x11,%eax
  6d270e:	jne    6d2718 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x358>
  6d2710:	movq   $0x0,0x8(%r14)
  6d2718:	mov    0x40(%rsp),%rax
  6d271d:	mov    %rax,0x30(%rbx)
  6d2721:	movups 0x10(%rsp),%xmm0
  6d2726:	movups 0x20(%rsp),%xmm1
  6d272b:	movups 0x30(%rsp),%xmm2
  6d2730:	movups %xmm2,0x20(%rbx)
  6d2734:	movups %xmm1,0x10(%rbx)
  6d2738:	movups %xmm0,(%rbx)
  6d273b:	lea    0x60(%rsp),%rdi
  6d2740:	call   6b91f0 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtB4_6result6ResultNtNtCs6ZNK6sH19NW_4gpui7runtime6CommitNtBZ_5ErrorEECs4gijoeCAvqI_25inspector_pointer_control>
  6d2745:	jmp    6d29ea <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x62a>
  6d274a:	test   %r12,%r12
  6d274d:	sete   %cl
  6d2750:	cmpb   $0x1,0x742(%r15)
  6d2758:	jne    6d293a <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x57a>
  6d275e:	cmpb   $0x0,0x743(%r15)
  6d2766:	jne    6d293a <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x57a>
  6d276c:	cmpb   $0x0,0x744(%r15)
  6d2774:	je     6d293a <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x57a>
  6d277a:	cmpq   $0xffffffffffffffff,0x5b0(%r15)
  6d2782:	jne    6d293a <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x57a>
  6d2788:	mov    0x688(%r15),%rax
  6d278f:	cmp    0x690(%r15),%rax
  6d2796:	jne    6d293a <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x57a>
  6d279c:	mov    0x6a0(%r15),%rax
  6d27a3:	cmp    0x698(%r15),%rax
  6d27aa:	jne    6d293a <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x57a>
  6d27b0:	movss  0x738(%r15),%xmm0
  6d27b9:	ucomiss 0x73c(%r15),%xmm0
  6d27c1:	jne    6d293a <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x57a>
  6d27c7:	jp     6d293a <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x57a>
  6d27cd:	mov    (%r14),%eax
  6d27d0:	cmp    $0xffffffff,%eax
  6d27d3:	mov    %rax,0x50(%rsp)
  6d27d8:	mov    %ecx,0x58(%rsp)
  6d27dc:	je     6d2a08 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x648>
  6d27e2:	movss  0x4(%r14),%xmm0
  6d27e8:	dec    %eax
  6d27ea:	mov    %eax,0x14(%rsp)
  6d27ee:	movss  %xmm0,0x18(%rsp)
  6d27f4:	mov    $0x1,%eax
  6d27f9:	jmp    6d2a0a <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x64a>
  6d27fe:	test   %r12,%r12
  6d2801:	je     6d2991 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x5d1>
  6d2807:	mov    (%r14),%ecx
  6d280a:	cmp    $0xffffffff,%ecx
  6d280d:	mov    %rcx,0x50(%rsp)
  6d2812:	je     6d2855 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x495>
  6d2814:	movd   0x4(%r14),%xmm0
  6d281a:	dec    %ecx
  6d281c:	mov    %ecx,0x64(%rsp)
  6d2820:	movd   %xmm0,0x68(%rsp)
  6d2826:	mov    $0x1,%ecx
  6d282b:	jmp    6d2857 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x497>
  6d282d:	mov    0x40(%rsp),%rax
  6d2832:	mov    %rax,0x30(%rbx)
  6d2836:	movups 0x10(%rsp),%xmm0
  6d283b:	movups 0x20(%rsp),%xmm1
  6d2840:	movups 0x30(%rsp),%xmm2
  6d2845:	movups %xmm2,0x20(%rbx)
  6d2849:	movups %xmm1,0x10(%rbx)
  6d284d:	movups %xmm0,(%rbx)
  6d2850:	jmp    6d29ea <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x62a>
  6d2855:	xor    %ecx,%ecx
  6d2857:	mov    %ecx,0x60(%rsp)
  6d285b:	movzbl 0x743(%r15),%ecx
  6d2863:	xor    $0x1,%cl
  6d2866:	and    0x742(%r15),%cl
  6d286d:	and    0x744(%r15),%cl
  6d2874:	mov    0x5b0(%r15),%rdx
  6d287b:	cmp    $0xffffffffffffffff,%rdx
  6d287f:	sete   %sil
  6d2883:	and    %cl,%sil
  6d2886:	cmp    $0x1,%sil
  6d288a:	jne    6d28fa <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x53a>
  6d288c:	mov    0x688(%r15),%rax
  6d2893:	cmp    0x690(%r15),%rax
  6d289a:	jne    6d293a <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x57a>
  6d28a0:	mov    0x6a0(%r15),%rax
  6d28a7:	cmp    0x698(%r15),%rax
  6d28ae:	jne    6d293a <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x57a>
  6d28b4:	movss  0x738(%r15),%xmm0
  6d28bd:	ucomiss 0x73c(%r15),%xmm0
  6d28c5:	jne    6d293a <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x57a>
  6d28c7:	jp     6d293a <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x57a>
  6d28c9:	lea    0x60(%rsp),%rsi
  6d28ce:	mov    %r15,%rdi
  6d28d1:	call   6db280 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE11pointer_hitBW_>
  6d28d6:	mov    %rax,0xa0(%rsp)
  6d28de:	mov    %rdx,0x8(%rsp)
  6d28e3:	xor    %ecx,%ecx
  6d28e5:	mov    0x638(%r15),%rax
  6d28ec:	test   %rax,%rax
  6d28ef:	jne    6d2a3c <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x67c>
  6d28f5:	jmp    6d2b37 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x777>
  6d28fa:	cmp    $0xffffffffffffffff,%rdx
  6d28fe:	sete   %dl
  6d2901:	movq   $0x12,0x10(%rsp)
  6d290a:	xor    $0x1,%cl
  6d290d:	or     %dl,%cl
  6d290f:	jne    6d293a <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x57a>
  6d2911:	mov    0x6a0(%r15),%rcx
  6d2918:	cmp    0x698(%r15),%rcx
  6d291f:	jne    6d293a <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x57a>
  6d2921:	movss  0x738(%r15),%xmm0
  6d292a:	ucomiss 0x73c(%r15),%xmm0
  6d2932:	jne    6d293a <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x57a>
  6d2934:	jnp    6d2a55 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x695>
  6d293a:	movq   $0x12,(%rbx)
  6d2941:	jmp    6d29ea <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x62a>
  6d2946:	cmp    $0xd,%rax
  6d294a:	jl     6d2969 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x5a9>
  6d294c:	cmp    $0x21,%rax
  6d2950:	je     6d2969 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x5a9>
  6d2952:	cmp    $0x26,%rax
  6d2956:	jne    6d2989 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x5c9>
  6d2958:	mov    0x68(%rsp),%rsi
  6d295d:	test   %rsi,%rsi
  6d2960:	je     6d2989 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x5c9>
  6d2962:	lea    0x70(%rsp),%rax
  6d2967:	jmp    6d297b <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x5bb>
  6d2969:	mov    0x78(%rsp),%rsi
  6d296e:	test   %rsi,%rsi
  6d2971:	je     6d2989 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x5c9>
  6d2973:	lea    0x80(%rsp),%rax
  6d297b:	mov    (%rax),%rdi
  6d297e:	mov    $0x1,%edx
  6d2983:	call   *0x3472c7(%rip)        # a19c50 <_DYNAMIC+0x240>
  6d2989:	movq   $0x0,0x8(%r14)
  6d2991:	movups 0x688(%r15),%xmm0
  6d2999:	movzbl 0x744(%r15),%eax
  6d29a1:	cmpq   $0x0,0x6a8(%r15)
  6d29a9:	je     6d29b9 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x5f9>
  6d29ab:	test   %al,%al
  6d29ad:	je     6d29bd <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x5fd>
  6d29af:	cmpq   $0xffffffffffffffff,0x5b0(%r15)
  6d29b7:	jne    6d29bd <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x5fd>
  6d29b9:	xor    %ecx,%ecx
  6d29bb:	jmp    6d29c9 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x609>
  6d29bd:	mov    0x6b8(%r15),%rdx
  6d29c4:	mov    $0x1,%ecx
  6d29c9:	mov    0x730(%r15),%rsi
  6d29d0:	mov    %rcx,0x8(%rbx)
  6d29d4:	mov    %rdx,0x10(%rbx)
  6d29d8:	movups %xmm0,0x18(%rbx)
  6d29dc:	mov    %rsi,0x28(%rbx)
  6d29e0:	mov    %al,0x30(%rbx)
  6d29e3:	movq   $0xfffffffffffffffe,(%rbx)
  6d29ea:	add    $0xc8,%rsp
  6d29f1:	pop    %rbx
  6d29f2:	pop    %r12
  6d29f4:	pop    %r13
  6d29f6:	pop    %r14
  6d29f8:	pop    %r15
  6d29fa:	pop    %rbp
  6d29fb:	ret
  6d29fc:	lea    0x60(%rsp),%rdi
  6d2a01:	call   6b91f0 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtB4_6result6ResultNtNtCs6ZNK6sH19NW_4gpui7runtime6CommitNtBZ_5ErrorEECs4gijoeCAvqI_25inspector_pointer_control>
  6d2a06:	jmp    6d2991 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x5d1>
  6d2a08:	xor    %eax,%eax
  6d2a0a:	mov    %eax,0x10(%rsp)
  6d2a0e:	lea    0x10(%rsp),%rsi
  6d2a13:	mov    %r15,%rdi
  6d2a16:	call   6db280 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE11pointer_hitBW_>
  6d2a1b:	mov    %rax,0xa0(%rsp)
  6d2a23:	mov    %rdx,0x8(%rsp)
  6d2a28:	mov    0x58(%rsp),%ecx
  6d2a2c:	mov    0x638(%r15),%rax
  6d2a33:	test   %rax,%rax
  6d2a36:	je     6d2b37 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x777>
  6d2a3c:	mov    0xd8(%rax),%rax
  6d2a43:	test   %rax,%rax
  6d2a46:	je     6d2b37 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x777>
  6d2a4c:	movzbl 0x12(%rax),%eax
  6d2a50:	jmp    6d2b39 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x779>
  6d2a55:	mov    0x690(%r15),%rcx
  6d2a5c:	cmp    $0xffffffffffffffff,%rcx
  6d2a60:	je     6d293a <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x57a>
  6d2a66:	inc    %rcx
  6d2a69:	mov    0x688(%r15),%rdx
  6d2a70:	cmp    %rdx,%rcx
  6d2a73:	jne    6d293a <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x57a>
  6d2a79:	cmp    %rdx,0x6b8(%r15)
  6d2a80:	jne    6d293a <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x57a>
  6d2a86:	test   %rax,%rax
  6d2a89:	je     6d293a <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x57a>
  6d2a8f:	cmpq   $0x0,0x6a8(%r15)
  6d2a97:	je     6d293a <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x57a>
  6d2a9d:	cmp    %rax,0x6b0(%r15)
  6d2aa4:	jne    6d293a <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x57a>
  6d2aaa:	cmp    0x5d8(%r15),%r12
  6d2ab1:	jne    6d293a <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x57a>
  6d2ab7:	lea    0x60(%rsp),%rsi
  6d2abc:	mov    %r15,%rdi
  6d2abf:	call   6db280 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE11pointer_hitBW_>
  6d2ac4:	mov    %rax,0xa0(%rsp)
  6d2acc:	mov    %rdx,0x8(%rsp)
  6d2ad1:	mov    0x638(%r15),%rax
  6d2ad8:	test   %rax,%rax
  6d2adb:	je     6d2b1b <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x75b>
  6d2add:	cmpq   $0x0,0xd8(%rax)
  6d2ae5:	je     6d2b1b <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x75b>
  6d2ae7:	cmp    %r12,0xa0(%rsp)
  6d2aef:	jne    6d293a <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x57a>
  6d2af5:	cmp    %r13,0x8(%rsp)
  6d2afa:	jne    6d293a <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x57a>
  6d2b00:	lea    0x60(%rsp),%rcx
  6d2b05:	mov    %r15,%rdi
  6d2b08:	mov    %r12,%rsi
  6d2b0b:	mov    %r13,%rdx
  6d2b0e:	call   6db7a0 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19inspector_focus_hitBW_>
  6d2b13:	test   %al,%al
  6d2b15:	je     6d293a <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x57a>
  6d2b1b:	lea    0x10(%rsp),%rdi
  6d2b20:	call   6be370 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueNtNtCs6ZNK6sH19NW_4gpui7runtime5ErrorECs4gijoeCAvqI_25inspector_pointer_control>
  6d2b25:	xor    %ecx,%ecx
  6d2b27:	mov    0x638(%r15),%rax
  6d2b2e:	test   %rax,%rax
  6d2b31:	jne    6d2a3c <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x67c>
  6d2b37:	xor    %eax,%eax
  6d2b39:	cmp    $0x2,%ebp
  6d2b3c:	jne    6d2c1e <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x85e>
  6d2b42:	mov    0x610(%r15),%rdx
  6d2b49:	mov    0x618(%r15),%rcx
  6d2b50:	mov    0xa0(%rsp),%rbp
  6d2b58:	test   %rbp,%rbp
  6d2b5b:	sete   %sil
  6d2b5f:	or     %al,%sil
  6d2b62:	test   $0x1,%sil
  6d2b66:	je     6d2c69 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x8a9>
  6d2b6c:	movq   $0x0,0x610(%r15)
  6d2b77:	lea    0x10(%rsp),%rdi
  6d2b7c:	mov    %r15,%rsi
  6d2b7f:	call   6dc5c0 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime7editingINtB7_10RuntimeMutNtCs4gijoeCAvqI_25inspector_pointer_control5ModeluE20publish_focus_changeB12_>
  6d2b84:	mov    0x10(%rsp),%rax
  6d2b89:	movups 0x18(%rsp),%xmm0
  6d2b8e:	movaps %xmm0,0x60(%rsp)
  6d2b93:	movups 0x28(%rsp),%xmm0
  6d2b98:	movaps %xmm0,0x70(%rsp)
  6d2b9d:	movups 0x38(%rsp),%xmm0
  6d2ba2:	movaps %xmm0,0x80(%rsp)
  6d2baa:	cmp    $0xfffffffffffffffe,%rax
  6d2bae:	jne    6d2d57 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x997>
  6d2bb4:	movaps 0x60(%rsp),%xmm0
  6d2bb9:	movaps 0x70(%rsp),%xmm1
  6d2bbe:	movaps 0x80(%rsp),%xmm2
  6d2bc6:	movaps %xmm2,0x30(%rsp)
  6d2bcb:	movaps %xmm1,0x20(%rsp)
  6d2bd0:	movaps %xmm0,0x10(%rsp)
  6d2bd5:	cmpq   $0xffffffffffffffff,0x5b0(%r15)
  6d2bdd:	je     6d2da9 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x9e9>
  6d2be3:	mov    0x690(%r15),%rax
  6d2bea:	cmp    $0xffffffffffffffff,%rax
  6d2bee:	je     6d2da9 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x9e9>
  6d2bf4:	inc    %rax
  6d2bf7:	cmp    0x688(%r15),%rax
  6d2bfe:	jne    6d2da9 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x9e9>
  6d2c04:	cmpq   $0x0,0x6a8(%r15)
  6d2c0c:	je     6d2da9 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x9e9>
  6d2c12:	mov    0x6b0(%r15),%rax
  6d2c19:	jmp    6d2dab <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x9eb>
  6d2c1e:	test   %cl,%cl
  6d2c20:	mov    0xa0(%rsp),%rcx
  6d2c28:	jne    6d2991 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x5d1>
  6d2c2e:	test   %rcx,%rcx
  6d2c31:	je     6d2991 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x5d1>
  6d2c37:	cmp    %rcx,%r12
  6d2c3a:	jne    6d2991 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x5d1>
  6d2c40:	cmp    0x8(%rsp),%r13
  6d2c45:	jne    6d2991 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x5d1>
  6d2c4b:	test   %al,%al
  6d2c4d:	je     6d2dde <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xa1e>
  6d2c53:	mov    %rbx,%rdi
  6d2c56:	mov    %r15,%rsi
  6d2c59:	mov    %r12,%rdx
  6d2c5c:	mov    %r13,%rcx
  6d2c5f:	call   6dfdb0 <_RNvMs4_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_10RuntimeMutNtCs4gijoeCAvqI_25inspector_pointer_control5ModeluE16inspector_selectB14_>
  6d2c64:	jmp    6d29ea <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x62a>
  6d2c69:	cmp    0x5d8(%r15),%rbp
  6d2c70:	jne    6d2d7d <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x9bd>
  6d2c76:	mov    %rcx,%r12
  6d2c79:	mov    %rdx,%r13
  6d2c7c:	lea    0x10(%rsp),%rdi
  6d2c81:	mov    %r15,%rsi
  6d2c84:	mov    0x8(%rsp),%rdx
  6d2c89:	call   6f8be0 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE16resolve_identityBO_>
  6d2c8e:	mov    0x10(%rsp),%rax
  6d2c93:	mov    0x18(%rsp),%rdi
  6d2c98:	cmp    $0xfffffffffffffffe,%rax
  6d2c9c:	jne    6d2d82 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x9c2>
  6d2ca2:	mov    0x2c8(%r15),%rsi
  6d2ca9:	cmp    %rsi,%rdi
  6d2cac:	jae    6d3000 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xc40>
  6d2cb2:	mov    0x2c0(%r15),%rax
  6d2cb9:	lea    (%rdi,%rdi,4),%rcx
  6d2cbd:	mov    0x20(%rax,%rcx,8),%edi
  6d2cc1:	call   6e2670 <_RNvMsh_NtCs6ZNK6sH19NW_4gpui7runtimeNtB5_4Node4kind>
  6d2cc6:	cmp    $0x4,%al
  6d2cc8:	jne    6d2eda <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xb1a>
  6d2cce:	mov    0x50(%rsp),%rax
  6d2cd3:	cmp    $0xffffffff,%eax
  6d2cd6:	je     6d300d <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xc4d>
  6d2cdc:	movss  0x4(%r14),%xmm1
  6d2ce2:	dec    %eax
  6d2ce4:	movd   %eax,%xmm0
  6d2ce8:	lea    0x10(%rsp),%rdi
  6d2ced:	mov    %r15,%rsi
  6d2cf0:	mov    %rbp,%rdx
  6d2cf3:	mov    0x8(%rsp),%r15
  6d2cf8:	mov    %r15,%rcx
  6d2cfb:	xor    %r8d,%r8d
  6d2cfe:	call   6dbfa0 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime7editingINtB7_10RuntimeMutNtCs4gijoeCAvqI_25inspector_pointer_control5ModeluE14select_pointerB12_>
  6d2d03:	mov    0x10(%rsp),%rax
  6d2d08:	movups 0x38(%rsp),%xmm0
  6d2d0d:	movaps %xmm0,0x80(%rsp)
  6d2d15:	movdqu 0x28(%rsp),%xmm1
  6d2d1b:	movdqa %xmm1,0x70(%rsp)
  6d2d21:	movups 0x18(%rsp),%xmm2
  6d2d26:	movaps %xmm2,0x60(%rsp)
  6d2d2b:	movups %xmm0,0x28(%rbx)
  6d2d2f:	movdqu %xmm1,0x18(%rbx)
  6d2d34:	movups %xmm2,0x8(%rbx)
  6d2d38:	cmp    $0xfffffffffffffffe,%rax
  6d2d3c:	jne    6d2f3e <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xb7e>
  6d2d42:	mov    %rbp,0x8(%r14)
  6d2d46:	mov    %r15,0x10(%r14)
  6d2d4a:	movq   $0x0,0x18(%r14)
  6d2d52:	jmp    6d29e3 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x623>
  6d2d57:	movaps 0x60(%rsp),%xmm0
  6d2d5c:	movaps 0x70(%rsp),%xmm1
  6d2d61:	movaps 0x80(%rsp),%xmm2
  6d2d69:	movups %xmm2,0x28(%rbx)
  6d2d6d:	movups %xmm1,0x18(%rbx)
  6d2d71:	movups %xmm0,0x8(%rbx)
  6d2d75:	mov    %rax,(%rbx)
  6d2d78:	jmp    6d29ea <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x62a>
  6d2d7d:	mov    $0x11,%eax
  6d2d82:	mov    0x40(%rsp),%rcx
  6d2d87:	mov    %rcx,0x30(%rbx)
  6d2d8b:	movups 0x20(%rsp),%xmm0
  6d2d90:	movups 0x30(%rsp),%xmm1
  6d2d95:	movups %xmm1,0x20(%rbx)
  6d2d99:	movups %xmm0,0x10(%rbx)
  6d2d9d:	mov    %rax,(%rbx)
  6d2da0:	mov    %rdi,0x8(%rbx)
  6d2da4:	jmp    6d29ea <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x62a>
  6d2da9:	xor    %eax,%eax
  6d2dab:	mov    %rbp,0x8(%r14)
  6d2daf:	mov    0x8(%rsp),%rcx
  6d2db4:	mov    %rcx,0x10(%r14)
  6d2db8:	mov    %rax,0x18(%r14)
  6d2dbc:	movaps 0x10(%rsp),%xmm0
  6d2dc1:	movdqa 0x20(%rsp),%xmm1
  6d2dc7:	movaps 0x30(%rsp),%xmm2
  6d2dcc:	movups %xmm2,0x28(%rbx)
  6d2dd0:	movdqu %xmm1,0x18(%rbx)
  6d2dd5:	movups %xmm0,0x8(%rbx)
  6d2dd9:	jmp    6d29e3 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x623>
  6d2dde:	movq   $0x0,0x10(%rsp)
  6d2de7:	lea    0xb8(%rsp),%rsi
  6d2def:	lea    0x10(%rsp),%r8
  6d2df4:	mov    %rbx,%rdi
  6d2df7:	mov    %r12,%rdx
  6d2dfa:	mov    %r13,%rcx
  6d2dfd:	call   6d6510 <_RNvMNtNtCs6ZNK6sH19NW_4gpui7runtime4turnINtB4_10RuntimeMutNtCs4gijoeCAvqI_25inspector_pointer_control5ModeluE21activate_with_editingBW_>
  6d2e02:	jmp    6d29ea <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x62a>
  6d2e07:	movq   $0x4,0x60(%rsp)
  6d2e10:	pxor   %xmm0,%xmm0
  6d2e14:	movdqu %xmm0,0x68(%rsp)
  6d2e1a:	mov    0x5a8(%r14),%rax
  6d2e21:	mov    %rax,0x58(%rsp)
  6d2e26:	test   %rax,%rax
  6d2e29:	je     6d2fbd <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xbfd>
  6d2e2f:	mov    0x5a0(%r14),%rbp
  6d2e36:	mov    0x58(%rsp),%rax
  6d2e3b:	mov    %rax,%r15
  6d2e3e:	shl    $0x6,%r15
  6d2e42:	lea    -0x1(%rax),%r12
  6d2e46:	jmp    6d2ea9 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xae9>
  6d2e48:	mov    0x70(%rsp),%rax
  6d2e4d:	mov    %rax,0x20(%rsp)
  6d2e52:	movups 0x60(%rsp),%xmm0
  6d2e57:	movaps %xmm0,0x10(%rsp)
  6d2e5c:	mov    0x638(%r14),%rax
  6d2e63:	test   %rax,%rax
  6d2e66:	je     6d2ed6 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xb16>
  6d2e68:	cmpq   $0x0,(%rax)
  6d2e6c:	setne  %al
  6d2e6f:	movzbl %al,%ecx
  6d2e72:	mov    %rbp,%rdi
  6d2e75:	mov    0x58(%rsp),%rsi
  6d2e7a:	lea    0x10(%rsp),%rdx
  6d2e7f:	mov    %r12,%r8
  6d2e82:	movd   0x8(%rsp),%xmm0
  6d2e88:	movss  0x50(%rsp),%xmm1
  6d2e8e:	call   *0x34706c(%rip)        # a19f00 <_DYNAMIC+0x4f0>
  6d2e94:	test   %al,%al
  6d2e96:	jne    6d2f46 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xb86>
  6d2e9c:	dec    %r12
  6d2e9f:	add    $0xffffffffffffffc0,%r15
  6d2ea3:	je     6d2fbd <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xbfd>
  6d2ea9:	cmpb   $0x0,-0x2(%rbp,%r15,1)
  6d2eaf:	jne    6d2e48 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xa88>
  6d2eb1:	movzbl -0x3(%rbp,%r15,1),%eax
  6d2eb7:	sub    $0x2,%al
  6d2eb9:	movzbl %al,%eax
  6d2ebc:	mov    $0x8,%ecx
  6d2ec1:	cmovb  %ecx,%eax
  6d2ec4:	cmp    $0x7,%al
  6d2ec6:	je     6d2e48 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xa88>
  6d2ec8:	movzbl %al,%eax
  6d2ecb:	cmp    $0x4,%eax
  6d2ece:	je     6d2e48 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xa88>
  6d2ed4:	jmp    6d2e9c <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xadc>
  6d2ed6:	xor    %eax,%eax
  6d2ed8:	jmp    6d2e6f <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xaaf>
  6d2eda:	lea    0x10(%rsp),%rdi
  6d2edf:	mov    %r15,%rsi
  6d2ee2:	mov    %rbp,%rdx
  6d2ee5:	mov    0x8(%rsp),%rcx
  6d2eea:	call   6dbc20 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE5focusBW_>
  6d2eef:	mov    0x10(%rsp),%rax
  6d2ef4:	cmp    $0xfffffffffffffffe,%rax
  6d2ef8:	jne    6d2f05 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xb45>
  6d2efa:	mov    %r13,%rdx
  6d2efd:	mov    %r12,%rcx
  6d2f00:	jmp    6d2b77 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x7b7>
  6d2f05:	mov    0x38(%rsp),%rcx
  6d2f0a:	movzbl 0x40(%rsp),%edx
  6d2f0f:	mov    0x44(%rsp),%esi
  6d2f13:	mov    %esi,0x34(%rbx)
  6d2f16:	mov    0x41(%rsp),%esi
  6d2f1a:	mov    %esi,0x31(%rbx)
  6d2f1d:	movups 0x18(%rsp),%xmm0
  6d2f22:	movups 0x28(%rsp),%xmm1
  6d2f27:	mov    %rax,(%rbx)
  6d2f2a:	movups %xmm0,0x8(%rbx)
  6d2f2e:	movups %xmm1,0x18(%rbx)
  6d2f32:	mov    %rcx,0x28(%rbx)
  6d2f36:	mov    %dl,0x30(%rbx)
  6d2f39:	jmp    6d29ea <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x62a>
  6d2f3e:	mov    %rax,(%rbx)
  6d2f41:	jmp    6d29ea <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x62a>
  6d2f46:	movq   $0x19,0x10(%rsp)
  6d2f4f:	lea    0x10(%rsp),%rdi
  6d2f54:	call   6be370 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueNtNtCs6ZNK6sH19NW_4gpui7runtime5ErrorECs4gijoeCAvqI_25inspector_pointer_control>
  6d2f59:	mov    %r12,0xc0(%rsp)
  6d2f61:	movq   $0x1,0xb8(%rsp)
  6d2f6d:	lea    0xb8(%rsp),%rdi
  6d2f75:	mov    %r14,%rsi
  6d2f78:	mov    %r14,%rdx
  6d2f7b:	call   6ce050 <_RINvYINtNtNtNtCs4NRVxsYgnAr_4core4iter7sources7from_fn6FromFnNCNvMs6_NtNtCs6ZNK6sH19NW_4gpui7runtime6scrollINtB17_3WinNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE12scroll_at_2ds0_0ENtNtNtBa_6traits8iterator8Iterator8try_folduNCINvNvB2Z_3any5checkjNCBZ_s1_0E0INtNtNtBc_3ops12control_flow11ControlFlowuEEB1U_>
  6d2f80:	test   %al,%al
  6d2f82:	je     6d2fbd <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xbfd>
  6d2f84:	movq   $0x1,0x18(%rsp)
  6d2f8d:	mov    %r12,0x20(%rsp)
  6d2f92:	movaps 0xa0(%rsp),%xmm0
  6d2f9a:	movups %xmm0,0x28(%rsp)
  6d2f9f:	movq   $0x3,0x10(%rsp)
  6d2fa8:	lea    0x10(%rsp),%rdx
  6d2fad:	mov    %rbx,%rdi
  6d2fb0:	mov    %r13,%rsi
  6d2fb3:	call   6e16d0 <_RNvMs6_NtNtCs6ZNK6sH19NW_4gpui7runtime6scrollINtB7_3WinNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE17apply_scroll_planBT_>
  6d2fb8:	jmp    6d29ea <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x62a>
  6d2fbd:	movq   $0x19,(%rbx)
  6d2fc4:	jmp    6d29ea <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x62a>
  6d2fc9:	lea    -0x685e17(%rip),%rdi        # 4d1b9 <GCC_except_table0+0xfa6d>
  6d2fd0:	lea    0x328101(%rip),%rdx        # 9fb0d8 <__frame_dummy_init_array_entry+0xe98>
  6d2fd7:	mov    $0x22,%esi
  6d2fdc:	call   *0x346e16(%rip)        # a19df8 <_DYNAMIC+0x3e8>
  6d2fe2:	lea    0x328107(%rip),%rdx        # 9fb0f0 <__frame_dummy_init_array_entry+0xeb0>
  6d2fe9:	call   *0x346c91(%rip)        # a19c80 <_DYNAMIC+0x270>
  6d2fef:	jmp    6d2ffe <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xc3e>
  6d2ff1:	lea    0x328110(%rip),%rdi        # 9fb108 <__frame_dummy_init_array_entry+0xec8>
  6d2ff8:	call   *0x346cea(%rip)        # a19ce8 <_DYNAMIC+0x2d8>
  6d2ffe:	ud2
  6d3000:	lea    0x328119(%rip),%rdx        # 9fb120 <__frame_dummy_init_array_entry+0xee0>
  6d3007:	call   *0x346c73(%rip)        # a19c80 <_DYNAMIC+0x270>
  6d300d:	lea    0x328124(%rip),%rdi        # 9fb138 <__frame_dummy_init_array_entry+0xef8>
  6d3014:	call   *0x346cce(%rip)        # a19ce8 <_DYNAMIC+0x2d8>
  6d301a:	mov    %rax,%rbx
  6d301d:	lea    0x10(%rsp),%rdi
  6d3022:	call   6be370 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueNtNtCs6ZNK6sH19NW_4gpui7runtime5ErrorECs4gijoeCAvqI_25inspector_pointer_control>
  6d3027:	mov    %rbx,%rdi
  6d302a:	call   9f8e90 <_Unwind_Resume@plt>
  6d302f:	mov    %rax,%rbx
  6d3032:	lea    0x60(%rsp),%rdi
  6d3037:	call   6b91f0 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtB4_6result6ResultNtNtCs6ZNK6sH19NW_4gpui7runtime6CommitNtBZ_5ErrorEECs4gijoeCAvqI_25inspector_pointer_control>
  6d303c:	mov    %rbx,%rdi
  6d303f:	call   9f8e90 <_Unwind_Resume@plt>

/tmp/gpui-inspector-pointer-codegen-split/candidate-frozen:     file format elf64-x86-64


Disassembly of section .text:

00000000006d3050 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8hit_only>:
  6d3050:	push   %rbp
  6d3051:	push   %r15
  6d3053:	push   %r14
  6d3055:	push   %r13
  6d3057:	push   %r12
  6d3059:	push   %rbx
  6d305a:	sub    $0x78,%rsp
  6d305e:	test   %rsi,%rsi
  6d3061:	je     6d3078 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8hit_only+0x28>
  6d3063:	cmpb   $0x0,0x746(%rsi)
  6d306a:	je     6d308c <_RNvCs4gijoeCAvqI_25inspector_pointer_control8hit_only+0x3c>
  6d306c:	movq   $0xe,(%rdi)
  6d3073:	jmp    6d3153 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8hit_only+0x103>
  6d3078:	movq   $0xd,(%rdi)
  6d307f:	movq   $0x0,0x8(%rdi)
  6d3087:	jmp    6d3153 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8hit_only+0x103>
  6d308c:	cmpb   $0x1,0x742(%rsi)
  6d3093:	jne    6d314c <_RNvCs4gijoeCAvqI_25inspector_pointer_control8hit_only+0xfc>
  6d3099:	cmpb   $0x0,0x743(%rsi)
  6d30a0:	jne    6d314c <_RNvCs4gijoeCAvqI_25inspector_pointer_control8hit_only+0xfc>
  6d30a6:	cmpb   $0x0,0x744(%rsi)
  6d30ad:	je     6d314c <_RNvCs4gijoeCAvqI_25inspector_pointer_control8hit_only+0xfc>
  6d30b3:	cmpq   $0xffffffffffffffff,0x5b0(%rsi)
  6d30bb:	jne    6d314c <_RNvCs4gijoeCAvqI_25inspector_pointer_control8hit_only+0xfc>
  6d30c1:	mov    0x688(%rsi),%rax
  6d30c8:	cmp    0x690(%rsi),%rax
  6d30cf:	jne    6d314c <_RNvCs4gijoeCAvqI_25inspector_pointer_control8hit_only+0xfc>
  6d30d1:	mov    0x6a0(%rsi),%rbx
  6d30d8:	cmp    0x698(%rsi),%rbx
  6d30df:	jne    6d314c <_RNvCs4gijoeCAvqI_25inspector_pointer_control8hit_only+0xfc>
  6d30e1:	movss  0x738(%rsi),%xmm2
  6d30e9:	ucomiss 0x73c(%rsi),%xmm2
  6d30f0:	jne    6d314c <_RNvCs4gijoeCAvqI_25inspector_pointer_control8hit_only+0xfc>
  6d30f2:	jp     6d314c <_RNvCs4gijoeCAvqI_25inspector_pointer_control8hit_only+0xfc>
  6d30f4:	mov    0x5a0(%rsi),%r14
  6d30fb:	mov    0x5a8(%rsi),%rax
  6d3102:	mov    %rax,0x8(%rsp)
  6d3107:	mov    0x638(%rsi),%r15
  6d310e:	test   %r15,%r15
  6d3111:	mov    %rdi,0x18(%rsp)
  6d3116:	mov    %rsi,%r13
  6d3119:	movss  %xmm1,0x14(%rsp)
  6d311f:	movss  %xmm0,0x10(%rsp)
  6d3125:	je     6d3162 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8hit_only+0x112>
  6d3127:	mov    0x100(%r15),%rsi
  6d312e:	test   %rsi,%rsi
  6d3131:	je     6d3177 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8hit_only+0x127>
  6d3133:	lea    0x20(%rsp),%rdi
  6d3138:	call   *0x346d32(%rip)        # a19e70 <_DYNAMIC+0x460>
  6d313e:	movss  0x10(%rsp),%xmm0
  6d3144:	movss  0x14(%rsp),%xmm1
  6d314a:	jmp    6d3188 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8hit_only+0x138>
  6d314c:	movq   $0x12,(%rdi)
  6d3153:	add    $0x78,%rsp
  6d3157:	pop    %rbx
  6d3158:	pop    %r12
  6d315a:	pop    %r13
  6d315c:	pop    %r14
  6d315e:	pop    %r15
  6d3160:	pop    %rbp
  6d3161:	ret
  6d3162:	movq   $0x4,0x20(%rsp)
  6d316b:	xorps  %xmm2,%xmm2
  6d316e:	movups %xmm2,0x28(%rsp)
  6d3173:	xor    %ebp,%ebp
  6d3175:	jmp    6d3190 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8hit_only+0x140>
  6d3177:	movq   $0x4,0x20(%rsp)
  6d3180:	xorps  %xmm2,%xmm2
  6d3183:	movups %xmm2,0x28(%rsp)
  6d3188:	cmpq   $0x0,(%r15)
  6d318c:	setne  %bpl
  6d3190:	mov    %r14,0x40(%rsp)
  6d3195:	mov    0x8(%rsp),%r15
  6d319a:	mov    %r15,0x48(%rsp)
  6d319f:	mov    0x20(%rsp),%rax
  6d31a4:	mov    %rax,0x50(%rsp)
  6d31a9:	mov    0x28(%rsp),%rax
  6d31ae:	mov    %rax,0x58(%rsp)
  6d31b3:	mov    0x30(%rsp),%rax
  6d31b8:	mov    %rax,0x60(%rsp)
  6d31bd:	mov    %rbx,0x68(%rsp)
  6d31c2:	mov    %bpl,0x70(%rsp)
  6d31c7:	lea    0x40(%rsp),%rdi
  6d31cc:	call   *0x346d36(%rip)        # a19f08 <_DYNAMIC+0x4f8>
  6d31d2:	test   %r15,%r15
  6d31d5:	mov    0x18(%rsp),%r8
  6d31da:	je     6d3433 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8hit_only+0x3e3>
  6d31e0:	test   %al,%al
  6d31e2:	je     6d3433 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8hit_only+0x3e3>
  6d31e8:	lea    0x50(%rsp),%r15
  6d31ed:	mov    0x8(%rsp),%rax
  6d31f2:	shl    $0x6,%rax
  6d31f6:	add    %r14,%rax
  6d31f9:	movzbl %bpl,%ebp
  6d31fd:	jmp    6d3254 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8hit_only+0x204>
  6d31ff:	mov    %rbx,%r12
  6d3202:	sub    %r14,%r12
  6d3205:	shr    $0x6,%r12
  6d3209:	mov    0x10(%r15),%rax
  6d320d:	mov    %rax,0x30(%rsp)
  6d3212:	movups (%r15),%xmm0
  6d3216:	movaps %xmm0,0x20(%rsp)
  6d321b:	mov    %r14,%rdi
  6d321e:	mov    0x8(%rsp),%rsi
  6d3223:	lea    0x20(%rsp),%rdx
  6d3228:	mov    %ebp,%ecx
  6d322a:	mov    %r12,%r8
  6d322d:	movss  0x10(%rsp),%xmm0
  6d3233:	movss  0x14(%rsp),%xmm1
  6d3239:	call   *0x346cc1(%rip)        # a19f00 <_DYNAMIC+0x4f0>
  6d323f:	mov    0x18(%rsp),%r8
  6d3244:	test   %al,%al
  6d3246:	jne    6d3294 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8hit_only+0x244>
  6d3248:	mov    %rbx,%rax
  6d324b:	cmp    %rbx,%r14
  6d324e:	je     6d3433 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8hit_only+0x3e3>
  6d3254:	lea    -0x40(%rax),%rbx
  6d3258:	cmpb   $0x0,-0x2(%rax)
  6d325c:	jne    6d31ff <_RNvCs4gijoeCAvqI_25inspector_pointer_control8hit_only+0x1af>
  6d325e:	mov    -0x8(%rax),%eax
  6d3261:	cmp    $0x3ffff,%rax
  6d3267:	jbe    6d3248 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8hit_only+0x1f8>
  6d3269:	shr    $0x11,%eax
  6d326c:	mov    %rbx,%rcx
  6d326f:	sub    %r14,%rcx
  6d3272:	shr    $0x6,%rcx
  6d3276:	mov    $0x2,%edx
  6d327b:	sub    %rax,%rdx
  6d327e:	add    $0xfffffffffffffffe,%rax
  6d3282:	shl    $0x6,%rdx
  6d3286:	cmp    %rcx,%rax
  6d3289:	lea    -0x40(%rbx,%rdx,1),%rbx
  6d328e:	cmovae %r14,%rbx
  6d3292:	jmp    6d3248 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8hit_only+0x1f8>
  6d3294:	mov    %r13,%rdi
  6d3297:	jmp    6d32b1 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8hit_only+0x261>
  6d3299:	mov    0x38(%rdx),%r12d
  6d329d:	and    $0x1ffff,%r12d
  6d32a4:	cmp    $0x1ffff,%r12
  6d32ab:	je     6d3433 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8hit_only+0x3e3>
  6d32b1:	cmp    0x8(%rsp),%r12
  6d32b6:	jae    6d3449 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8hit_only+0x3f9>
  6d32bc:	shl    $0x6,%r12
  6d32c0:	lea    (%r14,%r12,1),%rdx
  6d32c4:	mov    0x20(%r14,%r12,1),%rsi
  6d32c9:	mov    0x1e8(%rdi),%rax
  6d32d0:	test   %rax,%rax
  6d32d3:	je     6d3367 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8hit_only+0x317>
  6d32d9:	cmp    $0x1,%eax
  6d32dc:	jne    6d3386 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8hit_only+0x336>
  6d32e2:	mov    0x1f8(%rdi),%rax
  6d32e9:	test   %rax,%rax
  6d32ec:	je     6d3299 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8hit_only+0x249>
  6d32ee:	mov    0x1f0(%rdi),%rcx
  6d32f5:	xor    %r9d,%r9d
  6d32f8:	cmp    $0x1,%rax
  6d32fc:	je     6d3324 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8hit_only+0x2d4>
  6d32fe:	xchg   %ax,%ax
  6d3300:	mov    %r9,%r10
  6d3303:	mov    %rax,%r11
  6d3306:	shr    $1,%r11
  6d3309:	add    %r11,%r9
  6d330c:	mov    %r9,%rbx
  6d330f:	shl    $0x4,%rbx
  6d3313:	cmp    %rsi,(%rcx,%rbx,1)
  6d3317:	cmova  %r10,%r9
  6d331b:	sub    %r11,%rax
  6d331e:	cmp    $0x1,%rax
  6d3322:	ja     6d3300 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8hit_only+0x2b0>
  6d3324:	mov    %r9,%rax
  6d3327:	shl    $0x4,%rax
  6d332b:	xor    %r10d,%r10d
  6d332e:	cmp    %rsi,(%rcx,%rax,1)
  6d3332:	setbe  %r10b
  6d3336:	add    %r9,%r10
  6d3339:	je     6d3299 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8hit_only+0x249>
  6d333f:	shl    $0x4,%r10
  6d3343:	mov    %rsi,%rax
  6d3346:	sub    -0x10(%rcx,%r10,1),%rax
  6d334b:	mov    -0x4(%rcx,%r10,1),%r9d
  6d3350:	cmp    %r9,%rax
  6d3353:	jae    6d3299 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8hit_only+0x249>
  6d3359:	add    %r10,%rcx
  6d335c:	mov    -0x8(%rcx),%ecx
  6d335f:	add    %rcx,%rax
  6d3362:	jmp    6d33f6 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8hit_only+0x3a6>
  6d3367:	mov    %rsi,%rax
  6d336a:	sub    0x1f0(%rdi),%rax
  6d3371:	jb     6d3299 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8hit_only+0x249>
  6d3377:	cmp    0x1f8(%rdi),%rax
  6d337e:	jae    6d3299 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8hit_only+0x249>
  6d3384:	jmp    6d33f6 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8hit_only+0x3a6>
  6d3386:	mov    0x1f8(%rdi),%rcx
  6d338d:	test   %rcx,%rcx
  6d3390:	je     6d3299 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8hit_only+0x249>
  6d3396:	mov    0x1f0(%rdi),%rax
  6d339d:	cmp    $0x1,%rcx
  6d33a1:	jne    6d33ae <_RNvCs4gijoeCAvqI_25inspector_pointer_control8hit_only+0x35e>
  6d33a3:	cmp    %rsi,(%rax)
  6d33a6:	jne    6d3299 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8hit_only+0x249>
  6d33ac:	jmp    6d33f3 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8hit_only+0x3a3>
  6d33ae:	xor    %r9d,%r9d
  6d33b1:	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  6d33c0:	mov    %r9,%r10
  6d33c3:	mov    %rcx,%r11
  6d33c6:	shr    $1,%r11
  6d33c9:	add    %r11,%r9
  6d33cc:	lea    (%r9,%r9,2),%rbx
  6d33d0:	cmp    %rsi,(%rax,%rbx,4)
  6d33d4:	cmova  %r10,%r9
  6d33d8:	sub    %r11,%rcx
  6d33db:	cmp    $0x1,%rcx
  6d33df:	ja     6d33c0 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8hit_only+0x370>
  6d33e1:	lea    (%r9,%r9,2),%rcx
  6d33e5:	cmp    %rsi,(%rax,%rcx,4)
  6d33e9:	jne    6d3299 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8hit_only+0x249>
  6d33ef:	lea    (%rax,%rcx,4),%rax
  6d33f3:	mov    0x8(%rax),%eax
  6d33f6:	mov    0x2c8(%rdi),%rcx
  6d33fd:	cmp    %rcx,%rax
  6d3400:	jae    6d345e <_RNvCs4gijoeCAvqI_25inspector_pointer_control8hit_only+0x40e>
  6d3402:	mov    0x2c0(%rdi),%rcx
  6d3409:	lea    (%rax,%rax,4),%rax
  6d340d:	cmpq   $0x0,0x8(%rcx,%rax,8)
  6d3413:	jne    6d341f <_RNvCs4gijoeCAvqI_25inspector_pointer_control8hit_only+0x3cf>
  6d3415:	cmpb   $0x4,0x3d(%rdx)
  6d3419:	jne    6d3299 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8hit_only+0x249>
  6d341f:	add    $0x5d8,%rdi
  6d3426:	call   *0x346a4c(%rip)        # a19e78 <_DYNAMIC+0x468>
  6d342c:	mov    0x18(%rsp),%r8
  6d3431:	jmp    6d3435 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8hit_only+0x3e5>
  6d3433:	xor    %eax,%eax
  6d3435:	mov    %rax,0x8(%r8)
  6d3439:	mov    %rdx,0x10(%r8)
  6d343d:	movq   $0xfffffffffffffffe,(%r8)
  6d3444:	jmp    6d3153 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8hit_only+0x103>
  6d3449:	lea    0x328018(%rip),%rdx        # 9fb468 <__frame_dummy_init_array_entry+0x1228>
  6d3450:	mov    %r12,%rdi
  6d3453:	mov    0x8(%rsp),%rsi
  6d3458:	call   *0x346822(%rip)        # a19c80 <_DYNAMIC+0x270>
  6d345e:	lea    0x32801b(%rip),%rdx        # 9fb480 <__frame_dummy_init_array_entry+0x1240>
  6d3465:	mov    %rax,%rdi
  6d3468:	mov    %rcx,%rsi
  6d346b:	call   *0x34680f(%rip)        # a19c80 <_DYNAMIC+0x270>

/tmp/gpui-inspector-pointer-codegen-split/candidate-frozen:     file format elf64-x86-64


Disassembly of section .text:

00000000006db280 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE11pointer_hitBW_>:
  6db280:	push   %rbp
  6db281:	push   %r15
  6db283:	push   %r14
  6db285:	push   %r13
  6db287:	push   %r12
  6db289:	push   %rbx
  6db28a:	sub    $0x68,%rsp
  6db28e:	cmpl   $0x1,(%rsi)
  6db291:	jne    6db62d <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE11pointer_hitBW_+0x3ad>
  6db297:	movss  0x4(%rsi),%xmm0
  6db29c:	movss  %xmm0,0xc(%rsp)
  6db2a2:	movss  0x8(%rsi),%xmm0
  6db2a7:	movss  %xmm0,0x8(%rsp)
  6db2ad:	mov    0x638(%rdi),%rbx
  6db2b4:	test   %rbx,%rbx
  6db2b7:	je     6db32c <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE11pointer_hitBW_+0xac>
  6db2b9:	mov    0xd8(%rbx),%rax
  6db2c0:	test   %rax,%rax
  6db2c3:	je     6db2ff <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE11pointer_hitBW_+0x7f>
  6db2c5:	cmpb   $0x0,0x12(%rax)
  6db2c9:	je     6db2ff <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE11pointer_hitBW_+0x7f>
  6db2cb:	mov    0x5a0(%rdi),%r14
  6db2d2:	mov    0x5a8(%rdi),%r15
  6db2d9:	mov    0x100(%rbx),%rsi
  6db2e0:	test   %rsi,%rsi
  6db2e3:	je     6db63e <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE11pointer_hitBW_+0x3be>
  6db2e9:	mov    %rdi,%r12
  6db2ec:	lea    0x10(%rsp),%rdi
  6db2f1:	call   *0x33eb79(%rip)        # a19e70 <_DYNAMIC+0x460>
  6db2f7:	mov    %r12,%rdi
  6db2fa:	jmp    6db64f <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE11pointer_hitBW_+0x3cf>
  6db2ff:	mov    0x5a0(%rdi),%r15
  6db306:	mov    0x5a8(%rdi),%r14
  6db30d:	mov    0x100(%rbx),%rsi
  6db314:	test   %rsi,%rsi
  6db317:	je     6db34f <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE11pointer_hitBW_+0xcf>
  6db319:	mov    %rdi,%r12
  6db31c:	lea    0x10(%rsp),%rdi
  6db321:	call   *0x33eb49(%rip)        # a19e70 <_DYNAMIC+0x460>
  6db327:	mov    %r12,%rdi
  6db32a:	jmp    6db360 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE11pointer_hitBW_+0xe0>
  6db32c:	mov    0x5a0(%rdi),%r15
  6db333:	mov    0x5a8(%rdi),%r14
  6db33a:	movq   $0x4,0x10(%rsp)
  6db343:	xorps  %xmm0,%xmm0
  6db346:	movups %xmm0,0x18(%rsp)
  6db34b:	xor    %ebp,%ebp
  6db34d:	jmp    6db368 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE11pointer_hitBW_+0xe8>
  6db34f:	movq   $0x4,0x10(%rsp)
  6db358:	xorps  %xmm0,%xmm0
  6db35b:	movups %xmm0,0x18(%rsp)
  6db360:	cmpq   $0x0,(%rbx)
  6db364:	setne  %bpl
  6db368:	mov    %rdi,0x28(%rsp)
  6db36d:	mov    0x698(%rdi),%rax
  6db374:	mov    %r15,0x30(%rsp)
  6db379:	mov    %r14,0x38(%rsp)
  6db37e:	mov    0x10(%rsp),%rcx
  6db383:	mov    %rcx,0x40(%rsp)
  6db388:	mov    0x18(%rsp),%rcx
  6db38d:	mov    %rcx,0x48(%rsp)
  6db392:	mov    0x20(%rsp),%rcx
  6db397:	mov    %rcx,0x50(%rsp)
  6db39c:	mov    %rax,0x58(%rsp)
  6db3a1:	mov    %bpl,0x60(%rsp)
  6db3a6:	lea    0x30(%rsp),%rdi
  6db3ab:	movss  0xc(%rsp),%xmm0
  6db3b1:	movss  0x8(%rsp),%xmm1
  6db3b7:	call   *0x33eb4b(%rip)        # a19f08 <_DYNAMIC+0x4f8>
  6db3bd:	test   %r14,%r14
  6db3c0:	je     6db62d <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE11pointer_hitBW_+0x3ad>
  6db3c6:	test   %al,%al
  6db3c8:	je     6db62d <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE11pointer_hitBW_+0x3ad>
  6db3ce:	lea    0x40(%rsp),%rbx
  6db3d3:	mov    %r14,%rax
  6db3d6:	shl    $0x6,%rax
  6db3da:	add    %r15,%rax
  6db3dd:	movzbl %bpl,%ebp
  6db3e1:	jmp    6db43d <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE11pointer_hitBW_+0x1bd>
  6db3e3:	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  6db3f0:	mov    %r12,%r13
  6db3f3:	sub    %r15,%r13
  6db3f6:	shr    $0x6,%r13
  6db3fa:	mov    0x10(%rbx),%rax
  6db3fe:	mov    %rax,0x20(%rsp)
  6db403:	movups (%rbx),%xmm0
  6db406:	movaps %xmm0,0x10(%rsp)
  6db40b:	mov    %r15,%rdi
  6db40e:	mov    %r14,%rsi
  6db411:	lea    0x10(%rsp),%rdx
  6db416:	mov    %ebp,%ecx
  6db418:	mov    %r13,%r8
  6db41b:	movss  0xc(%rsp),%xmm0
  6db421:	movss  0x8(%rsp),%xmm1
  6db427:	call   *0x33ead3(%rip)        # a19f00 <_DYNAMIC+0x4f0>
  6db42d:	test   %al,%al
  6db42f:	jne    6db47d <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE11pointer_hitBW_+0x1fd>
  6db431:	mov    %r12,%rax
  6db434:	cmp    %r12,%r15
  6db437:	je     6db62d <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE11pointer_hitBW_+0x3ad>
  6db43d:	lea    -0x40(%rax),%r12
  6db441:	cmpb   $0x0,-0x2(%rax)
  6db445:	jne    6db3f0 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE11pointer_hitBW_+0x170>
  6db447:	mov    -0x8(%rax),%eax
  6db44a:	cmp    $0x3ffff,%rax
  6db450:	jbe    6db431 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE11pointer_hitBW_+0x1b1>
  6db452:	shr    $0x11,%eax
  6db455:	mov    %r12,%rcx
  6db458:	sub    %r15,%rcx
  6db45b:	shr    $0x6,%rcx
  6db45f:	mov    $0x2,%edx
  6db464:	sub    %rax,%rdx
  6db467:	add    $0xfffffffffffffffe,%rax
  6db46b:	shl    $0x6,%rdx
  6db46f:	cmp    %rcx,%rax
  6db472:	lea    -0x40(%r12,%rdx,1),%r12
  6db477:	cmovae %r15,%r12
  6db47b:	jmp    6db431 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE11pointer_hitBW_+0x1b1>
  6db47d:	mov    0x28(%rsp),%rax
  6db482:	mov    0x1e8(%rax),%rcx
  6db489:	mov    0x1f0(%rax),%rdx
  6db490:	mov    0x1f8(%rax),%r8
  6db497:	mov    0x2c8(%rax),%rsi
  6db49e:	mov    0x2c0(%rax),%r9
  6db4a5:	jmp    6db4c8 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE11pointer_hitBW_+0x248>
  6db4a7:	nopw   0x0(%rax,%rax,1)
  6db4b0:	mov    0x38(%r10),%r13d
  6db4b4:	and    $0x1ffff,%r13d
  6db4bb:	cmp    $0x1ffff,%r13
  6db4c2:	je     6db62d <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE11pointer_hitBW_+0x3ad>
  6db4c8:	cmp    %r14,%r13
  6db4cb:	jae    6db6a4 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE11pointer_hitBW_+0x424>
  6db4d1:	shl    $0x6,%r13
  6db4d5:	lea    (%r15,%r13,1),%r10
  6db4d9:	mov    0x20(%r15,%r13,1),%rax
  6db4de:	test   %rcx,%rcx
  6db4e1:	je     6db500 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE11pointer_hitBW_+0x280>
  6db4e3:	cmp    $0x1,%ecx
  6db4e6:	jne    6db520 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE11pointer_hitBW_+0x2a0>
  6db4e8:	test   %r8,%r8
  6db4eb:	je     6db4b0 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE11pointer_hitBW_+0x230>
  6db4ed:	cmp    $0x1,%r8
  6db4f1:	jne    6db540 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE11pointer_hitBW_+0x2c0>
  6db4f3:	xor    %edi,%edi
  6db4f5:	jmp    6db574 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE11pointer_hitBW_+0x2f4>
  6db4f7:	nopw   0x0(%rax,%rax,1)
  6db500:	mov    %rax,%rdi
  6db503:	sub    %rdx,%rdi
  6db506:	setae  %r11b
  6db50a:	cmp    %r8,%rdi
  6db50d:	setb   %bl
  6db510:	test   %bl,%r11b
  6db513:	je     6db4b0 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE11pointer_hitBW_+0x230>
  6db515:	jmp    6db5f6 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE11pointer_hitBW_+0x376>
  6db51a:	nopw   0x0(%rax,%rax,1)
  6db520:	test   %r8,%r8
  6db523:	je     6db4b0 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE11pointer_hitBW_+0x230>
  6db525:	cmp    $0x1,%r8
  6db529:	jne    6db5b5 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE11pointer_hitBW_+0x335>
  6db52f:	mov    %rdx,%rdi
  6db532:	cmp    %rax,(%rdx)
  6db535:	jne    6db4b0 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE11pointer_hitBW_+0x230>
  6db53b:	jmp    6db5f3 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE11pointer_hitBW_+0x373>
  6db540:	mov    %r8,%r11
  6db543:	xor    %edi,%edi
  6db545:	data16 cs nopw 0x0(%rax,%rax,1)
  6db550:	mov    %rdi,%rbx
  6db553:	mov    %r11,%r12
  6db556:	shr    $1,%r12
  6db559:	add    %r12,%rdi
  6db55c:	mov    %rdi,%r13
  6db55f:	shl    $0x4,%r13
  6db563:	cmp    %rax,(%rdx,%r13,1)
  6db567:	cmova  %rbx,%rdi
  6db56b:	sub    %r12,%r11
  6db56e:	cmp    $0x1,%r11
  6db572:	ja     6db550 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE11pointer_hitBW_+0x2d0>
  6db574:	mov    %rdi,%rbx
  6db577:	shl    $0x4,%rbx
  6db57b:	xor    %r11d,%r11d
  6db57e:	cmp    %rax,(%rdx,%rbx,1)
  6db582:	setbe  %r11b
  6db586:	add    %rdi,%r11
  6db589:	je     6db4b0 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE11pointer_hitBW_+0x230>
  6db58f:	shl    $0x4,%r11
  6db593:	mov    %rax,%rdi
  6db596:	sub    -0x10(%rdx,%r11,1),%rdi
  6db59b:	mov    -0x4(%rdx,%r11,1),%ebx
  6db5a0:	cmp    %rbx,%rdi
  6db5a3:	jae    6db4b0 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE11pointer_hitBW_+0x230>
  6db5a9:	add    %rdx,%r11
  6db5ac:	mov    -0x8(%r11),%r11d
  6db5b0:	add    %r11,%rdi
  6db5b3:	jmp    6db5f6 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE11pointer_hitBW_+0x376>
  6db5b5:	mov    %r8,%rdi
  6db5b8:	xor    %r11d,%r11d
  6db5bb:	nopl   0x0(%rax,%rax,1)
  6db5c0:	mov    %r11,%rbx
  6db5c3:	mov    %rdi,%r12
  6db5c6:	shr    $1,%r12
  6db5c9:	add    %r12,%r11
  6db5cc:	lea    (%r11,%r11,2),%r13
  6db5d0:	cmp    %rax,(%rdx,%r13,4)
  6db5d4:	cmova  %rbx,%r11
  6db5d8:	sub    %r12,%rdi
  6db5db:	cmp    $0x1,%rdi
  6db5df:	ja     6db5c0 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE11pointer_hitBW_+0x340>
  6db5e1:	lea    (%r11,%r11,2),%rdi
  6db5e5:	cmp    %rax,(%rdx,%rdi,4)
  6db5e9:	jne    6db4b0 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE11pointer_hitBW_+0x230>
  6db5ef:	lea    (%rdx,%rdi,4),%rdi
  6db5f3:	mov    0x8(%rdi),%edi
  6db5f6:	cmp    %rsi,%rdi
  6db5f9:	jae    6db6b7 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE11pointer_hitBW_+0x437>
  6db5ff:	lea    (%rdi,%rdi,4),%rdi
  6db603:	cmpq   $0x0,0x8(%r9,%rdi,8)
  6db609:	jne    6db616 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE11pointer_hitBW_+0x396>
  6db60b:	cmpb   $0x4,0x3d(%r10)
  6db610:	jne    6db4b0 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE11pointer_hitBW_+0x230>
  6db616:	mov    0x28(%rsp),%rdi
  6db61b:	add    $0x5d8,%rdi
  6db622:	mov    %rax,%rsi
  6db625:	call   *0x33e84d(%rip)        # a19e78 <_DYNAMIC+0x468>
  6db62b:	jmp    6db62f <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE11pointer_hitBW_+0x3af>
  6db62d:	xor    %eax,%eax
  6db62f:	add    $0x68,%rsp
  6db633:	pop    %rbx
  6db634:	pop    %r12
  6db636:	pop    %r13
  6db638:	pop    %r14
  6db63a:	pop    %r15
  6db63c:	pop    %rbp
  6db63d:	ret
  6db63e:	movq   $0x4,0x10(%rsp)
  6db647:	xorps  %xmm0,%xmm0
  6db64a:	movups %xmm0,0x18(%rsp)
  6db64f:	cmpq   $0x0,(%rbx)
  6db653:	mov    0x698(%rdi),%rax
  6db65a:	mov    %r14,0x30(%rsp)
  6db65f:	mov    %r15,0x38(%rsp)
  6db664:	mov    0x10(%rsp),%rcx
  6db669:	mov    %rcx,0x40(%rsp)
  6db66e:	mov    0x18(%rsp),%rcx
  6db673:	mov    %rcx,0x48(%rsp)
  6db678:	mov    0x20(%rsp),%rcx
  6db67d:	mov    %rcx,0x50(%rsp)
  6db682:	mov    %rax,0x58(%rsp)
  6db687:	setne  0x60(%rsp)
  6db68c:	lea    0x30(%rsp),%rsi
  6db691:	movss  0xc(%rsp),%xmm0
  6db697:	movss  0x8(%rsp),%xmm1
  6db69d:	call   6ddcf0 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE23inspector_pick_in_sheetB10_>
  6db6a2:	jmp    6db62f <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE11pointer_hitBW_+0x3af>
  6db6a4:	lea    0x31fdbd(%rip),%rdx        # 9fb468 <__frame_dummy_init_array_entry+0x1228>
  6db6ab:	mov    %r13,%rdi
  6db6ae:	mov    %r14,%rsi
  6db6b1:	call   *0x33e5c9(%rip)        # a19c80 <_DYNAMIC+0x270>
  6db6b7:	lea    0x31fdc2(%rip),%rdx        # 9fb480 <__frame_dummy_init_array_entry+0x1240>
  6db6be:	call   *0x33e5bc(%rip)        # a19c80 <_DYNAMIC+0x270>

/tmp/gpui-inspector-pointer-codegen-split/candidate-frozen:     file format elf64-x86-64


Disassembly of section .text:

00000000006db7a0 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19inspector_focus_hitBW_>:
  6db7a0:	push   %rbp
  6db7a1:	push   %r15
  6db7a3:	push   %r14
  6db7a5:	push   %r13
  6db7a7:	push   %r12
  6db7a9:	push   %rbx
  6db7aa:	sub    $0xa8,%rsp
  6db7b1:	cmpl   $0x1,(%rcx)
  6db7b4:	jne    6dbbda <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19inspector_focus_hitBW_+0x43a>
  6db7ba:	mov    %rdi,%rbx
  6db7bd:	mov    %rsi,%r14
  6db7c0:	mov    %rdx,%r12
  6db7c3:	movss  0x4(%rcx),%xmm0
  6db7c8:	movss  0x8(%rcx),%xmm1
  6db7cd:	movq   $0x0,0x20(%rsp)
  6db7d6:	movsd  0x698(%rdi),%xmm2
  6db7de:	xorpd  %xmm3,%xmm3
  6db7e2:	unpcklps %xmm3,%xmm2
  6db7e5:	movapd -0x69cf7d(%rip),%xmm3        # 3e870 <GCC_except_table0+0x1124>
  6db7ed:	orpd   %xmm3,%xmm2
  6db7f1:	subpd  %xmm3,%xmm2
  6db7f5:	cvtpd2ps %xmm2,%xmm2
  6db7f9:	movlpd %xmm2,0x28(%rsp)
  6db7ff:	lea    0x20(%rsp),%rdi
  6db804:	movss  %xmm0,0x8(%rsp)
  6db80a:	movss  %xmm1,0x4(%rsp)
  6db810:	call   *0x33e6a2(%rip)        # a19eb8 <_DYNAMIC+0x4a8>
  6db816:	test   %al,%al
  6db818:	je     6dbbda <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19inspector_focus_hitBW_+0x43a>
  6db81e:	cmpq   $0xffffffffffffffff,0x5b0(%rbx)
  6db826:	setne  %al
  6db829:	movzwl 0x5d0(%rbx),%ebp
  6db830:	test   %bp,%bp
  6db833:	setns  %cl
  6db836:	and    %al,%cl
  6db838:	cmp    $0x1,%cl
  6db83b:	jne    6dbbda <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19inspector_focus_hitBW_+0x43a>
  6db841:	mov    0x638(%rbx),%r15
  6db848:	test   %r15,%r15
  6db84b:	je     6dbbda <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19inspector_focus_hitBW_+0x43a>
  6db851:	mov    0x60(%r15),%rax
  6db855:	cmp    $0xffffffffffffffff,%rax
  6db859:	je     6dbbda <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19inspector_focus_hitBW_+0x43a>
  6db85f:	mov    0x100(%r15),%rsi
  6db866:	test   %rsi,%rsi
  6db869:	je     6db88f <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19inspector_focus_hitBW_+0xef>
  6db86b:	lea    0x20(%rsp),%rdi
  6db870:	call   *0x33e7b2(%rip)        # a1a028 <_DYNAMIC+0x618>
  6db876:	mov    0x20(%rsp),%rcx
  6db87b:	test   %rcx,%rcx
  6db87e:	je     6dbbda <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19inspector_focus_hitBW_+0x43a>
  6db884:	movups 0x28(%rsp),%xmm0
  6db889:	mov    0x60(%r15),%rax
  6db88d:	jmp    6db897 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19inspector_focus_hitBW_+0xf7>
  6db88f:	xorps  %xmm0,%xmm0
  6db892:	mov    $0x4,%ecx
  6db897:	movzwl %bp,%edx
  6db89a:	movups 0x5b8(%rbx),%xmm1
  6db8a1:	movzwl 0x5d2(%rbx),%esi
  6db8a8:	shl    $0x20,%rsi
  6db8ac:	or     %rdx,%rsi
  6db8af:	test   %rax,%rax
  6db8b2:	movups %xmm1,0x58(%rsp)
  6db8b7:	mov    %rcx,0x68(%rsp)
  6db8bc:	movups %xmm0,0x70(%rsp)
  6db8c1:	mov    %rsi,0x80(%rsp)
  6db8c9:	setne  0x88(%rsp)
  6db8d1:	lea    0x58(%rsp),%rdi
  6db8d6:	movss  0x8(%rsp),%xmm0
  6db8dc:	movss  0x4(%rsp),%xmm1
  6db8e2:	call   *0x33e620(%rip)        # a19f08 <_DYNAMIC+0x4f8>
  6db8e8:	test   %al,%al
  6db8ea:	je     6dbbda <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19inspector_focus_hitBW_+0x43a>
  6db8f0:	mov    0xd8(%r15),%rax
  6db8f7:	test   %rax,%rax
  6db8fa:	je     6db938 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19inspector_focus_hitBW_+0x198>
  6db8fc:	cmpb   $0x0,0x12(%rax)
  6db900:	je     6db938 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19inspector_focus_hitBW_+0x198>
  6db902:	lea    0x58(%rsp),%rsi
  6db907:	mov    %rbx,%rdi
  6db90a:	movss  0x8(%rsp),%xmm0
  6db910:	movss  0x4(%rsp),%xmm1
  6db916:	call   6ddcf0 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE23inspector_pick_in_sheetB10_>
  6db91b:	test   %rax,%rax
  6db91e:	je     6dbbda <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19inspector_focus_hitBW_+0x43a>
  6db924:	cmp    %r14,%rax
  6db927:	jne    6dbbda <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19inspector_focus_hitBW_+0x43a>
  6db92d:	cmp    %r12,%rdx
  6db930:	sete   %al
  6db933:	jmp    6dbbdc <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19inspector_focus_hitBW_+0x43c>
  6db938:	mov    0x88(%rsp),%rax
  6db940:	mov    %rax,0x50(%rsp)
  6db945:	movups 0x58(%rsp),%xmm0
  6db94a:	movups 0x68(%rsp),%xmm1
  6db94f:	movupd 0x78(%rsp),%xmm2
  6db955:	movapd %xmm2,0x40(%rsp)
  6db95b:	movaps %xmm1,0x30(%rsp)
  6db960:	movaps %xmm0,0x20(%rsp)
  6db965:	lea    0x20(%rsp),%rdi
  6db96a:	movss  0x8(%rsp),%xmm0
  6db970:	movss  0x4(%rsp),%xmm1
  6db976:	call   *0x33e58c(%rip)        # a19f08 <_DYNAMIC+0x4f8>
  6db97c:	test   %al,%al
  6db97e:	je     6dbbda <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19inspector_focus_hitBW_+0x43a>
  6db984:	mov    0x28(%rsp),%rax
  6db989:	mov    %rax,0x10(%rsp)
  6db98e:	test   %rax,%rax
  6db991:	je     6dbbda <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19inspector_focus_hitBW_+0x43a>
  6db997:	mov    0x20(%rsp),%r15
  6db99c:	mov    0x10(%rsp),%rax
  6db9a1:	shl    $0x6,%rax
  6db9a5:	add    %r15,%rax
  6db9a8:	movzbl 0x50(%rsp),%ecx
  6db9ad:	mov    %ecx,0x1c(%rsp)
  6db9b1:	jmp    6dba12 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19inspector_focus_hitBW_+0x272>
  6db9b3:	mov    %rbp,%r13
  6db9b6:	sub    %r15,%r13
  6db9b9:	shr    $0x6,%r13
  6db9bd:	lea    0x68(%rsp),%rcx
  6db9c2:	mov    0x10(%rcx),%rax
  6db9c6:	mov    %rax,0xa0(%rsp)
  6db9ce:	movups (%rcx),%xmm0
  6db9d1:	movaps %xmm0,0x90(%rsp)
  6db9d9:	mov    %r15,%rdi
  6db9dc:	mov    0x10(%rsp),%rsi
  6db9e1:	lea    0x90(%rsp),%rdx
  6db9e9:	mov    0x1c(%rsp),%ecx
  6db9ed:	mov    %r13,%r8
  6db9f0:	movss  0x8(%rsp),%xmm0
  6db9f6:	movss  0x4(%rsp),%xmm1
  6db9fc:	call   *0x33e4fe(%rip)        # a19f00 <_DYNAMIC+0x4f0>
  6dba02:	test   %al,%al
  6dba04:	jne    6dba52 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19inspector_focus_hitBW_+0x2b2>
  6dba06:	mov    %rbp,%rax
  6dba09:	cmp    %rbp,%r15
  6dba0c:	je     6dbbda <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19inspector_focus_hitBW_+0x43a>
  6dba12:	lea    -0x40(%rax),%rbp
  6dba16:	cmpb   $0x0,-0x2(%rax)
  6dba1a:	jne    6db9b3 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19inspector_focus_hitBW_+0x213>
  6dba1c:	mov    -0x8(%rax),%eax
  6dba1f:	cmp    $0x3ffff,%rax
  6dba25:	jbe    6dba06 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19inspector_focus_hitBW_+0x266>
  6dba27:	shr    $0x11,%eax
  6dba2a:	mov    %rbp,%rcx
  6dba2d:	sub    %r15,%rcx
  6dba30:	shr    $0x6,%rcx
  6dba34:	mov    $0x2,%edx
  6dba39:	sub    %rax,%rdx
  6dba3c:	add    $0xfffffffffffffffe,%rax
  6dba40:	shl    $0x6,%rdx
  6dba44:	cmp    %rcx,%rax
  6dba47:	lea    -0x40(%rbp,%rdx,1),%rbp
  6dba4c:	cmovae %r15,%rbp
  6dba50:	jmp    6dba06 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19inspector_focus_hitBW_+0x266>
  6dba52:	mov    0x1e8(%rbx),%rcx
  6dba59:	mov    0x1f0(%rbx),%rdx
  6dba60:	mov    0x1f8(%rbx),%r8
  6dba67:	mov    0x2c8(%rbx),%rax
  6dba6e:	mov    %rax,0x8(%rsp)
  6dba73:	mov    0x2c0(%rbx),%rsi
  6dba7a:	jmp    6dba94 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19inspector_focus_hitBW_+0x2f4>
  6dba7c:	mov    0x38(%r10),%r13d
  6dba80:	and    $0x1ffff,%r13d
  6dba87:	cmp    $0x1ffff,%r13
  6dba8e:	je     6dbbda <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19inspector_focus_hitBW_+0x43a>
  6dba94:	cmp    0x10(%rsp),%r13
  6dba99:	jae    6dbbee <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19inspector_focus_hitBW_+0x44e>
  6dba9f:	shl    $0x6,%r13
  6dbaa3:	lea    (%r15,%r13,1),%r10
  6dbaa7:	mov    0x20(%r15,%r13,1),%rax
  6dbaac:	test   %rcx,%rcx
  6dbaaf:	je     6dbac6 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19inspector_focus_hitBW_+0x326>
  6dbab1:	cmp    $0x1,%ecx
  6dbab4:	jne    6dbae1 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19inspector_focus_hitBW_+0x341>
  6dbab6:	test   %r8,%r8
  6dbab9:	je     6dba7c <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19inspector_focus_hitBW_+0x2dc>
  6dbabb:	cmp    $0x1,%r8
  6dbabf:	jne    6dbaf9 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19inspector_focus_hitBW_+0x359>
  6dbac1:	xor    %r13d,%r13d
  6dbac4:	jmp    6dbb23 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19inspector_focus_hitBW_+0x383>
  6dbac6:	mov    %rax,%rdi
  6dbac9:	sub    %rdx,%rdi
  6dbacc:	setae  %r11b
  6dbad0:	cmp    %r8,%rdi
  6dbad3:	setb   %bpl
  6dbad7:	test   %bpl,%r11b
  6dbada:	je     6dba7c <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19inspector_focus_hitBW_+0x2dc>
  6dbadc:	jmp    6dbba0 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19inspector_focus_hitBW_+0x400>
  6dbae1:	test   %r8,%r8
  6dbae4:	je     6dba7c <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19inspector_focus_hitBW_+0x2dc>
  6dbae6:	cmp    $0x1,%r8
  6dbaea:	jne    6dbb64 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19inspector_focus_hitBW_+0x3c4>
  6dbaec:	mov    %rdx,%rdi
  6dbaef:	cmp    %rax,(%rdx)
  6dbaf2:	jne    6dba7c <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19inspector_focus_hitBW_+0x2dc>
  6dbaf4:	jmp    6dbb9d <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19inspector_focus_hitBW_+0x3fd>
  6dbaf9:	mov    %r8,%r11
  6dbafc:	xor    %r13d,%r13d
  6dbaff:	mov    %r13,%r9
  6dbb02:	mov    %r11,%rbp
  6dbb05:	shr    $1,%rbp
  6dbb08:	add    %rbp,%r13
  6dbb0b:	mov    %r13,%rdi
  6dbb0e:	shl    $0x4,%rdi
  6dbb12:	cmp    %rax,(%rdx,%rdi,1)
  6dbb16:	cmova  %r9,%r13
  6dbb1a:	sub    %rbp,%r11
  6dbb1d:	cmp    $0x1,%r11
  6dbb21:	ja     6dbaff <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19inspector_focus_hitBW_+0x35f>
  6dbb23:	mov    %r13,%rdi
  6dbb26:	shl    $0x4,%rdi
  6dbb2a:	xor    %r11d,%r11d
  6dbb2d:	cmp    %rax,(%rdx,%rdi,1)
  6dbb31:	setbe  %r11b
  6dbb35:	add    %r13,%r11
  6dbb38:	je     6dba7c <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19inspector_focus_hitBW_+0x2dc>
  6dbb3e:	shl    $0x4,%r11
  6dbb42:	mov    %rax,%rdi
  6dbb45:	sub    -0x10(%rdx,%r11,1),%rdi
  6dbb4a:	mov    -0x4(%rdx,%r11,1),%r9d
  6dbb4f:	cmp    %r9,%rdi
  6dbb52:	jae    6dba7c <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19inspector_focus_hitBW_+0x2dc>
  6dbb58:	add    %rdx,%r11
  6dbb5b:	mov    -0x8(%r11),%r9d
  6dbb5f:	add    %r9,%rdi
  6dbb62:	jmp    6dbba0 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19inspector_focus_hitBW_+0x400>
  6dbb64:	mov    %r8,%rdi
  6dbb67:	xor    %r11d,%r11d
  6dbb6a:	mov    %r11,%r9
  6dbb6d:	mov    %rdi,%r13
  6dbb70:	shr    $1,%r13
  6dbb73:	add    %r13,%r11
  6dbb76:	lea    (%r11,%r11,2),%rbp
  6dbb7a:	cmp    %rax,(%rdx,%rbp,4)
  6dbb7e:	cmova  %r9,%r11
  6dbb82:	sub    %r13,%rdi
  6dbb85:	cmp    $0x1,%rdi
  6dbb89:	ja     6dbb6a <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19inspector_focus_hitBW_+0x3ca>
  6dbb8b:	lea    (%r11,%r11,2),%rdi
  6dbb8f:	cmp    %rax,(%rdx,%rdi,4)
  6dbb93:	jne    6dba7c <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19inspector_focus_hitBW_+0x2dc>
  6dbb99:	lea    (%rdx,%rdi,4),%rdi
  6dbb9d:	mov    0x8(%rdi),%edi
  6dbba0:	cmp    0x8(%rsp),%rdi
  6dbba5:	jae    6dbc03 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19inspector_focus_hitBW_+0x463>
  6dbba7:	lea    (%rdi,%rdi,4),%rdi
  6dbbab:	cmpq   $0x0,0x8(%rsi,%rdi,8)
  6dbbb1:	jne    6dbbbe <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19inspector_focus_hitBW_+0x41e>
  6dbbb3:	cmpb   $0x4,0x3d(%r10)
  6dbbb8:	jne    6dba7c <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19inspector_focus_hitBW_+0x2dc>
  6dbbbe:	add    $0x5d8,%rbx
  6dbbc5:	mov    %rbx,%rdi
  6dbbc8:	mov    %rax,%rsi
  6dbbcb:	call   *0x33e2a7(%rip)        # a19e78 <_DYNAMIC+0x468>
  6dbbd1:	cmp    %r14,%rax
  6dbbd4:	je     6db92d <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19inspector_focus_hitBW_+0x18d>
  6dbbda:	xor    %eax,%eax
  6dbbdc:	add    $0xa8,%rsp
  6dbbe3:	pop    %rbx
  6dbbe4:	pop    %r12
  6dbbe6:	pop    %r13
  6dbbe8:	pop    %r14
  6dbbea:	pop    %r15
  6dbbec:	pop    %rbp
  6dbbed:	ret
  6dbbee:	lea    0x31f873(%rip),%rdx        # 9fb468 <__frame_dummy_init_array_entry+0x1228>
  6dbbf5:	mov    %r13,%rdi
  6dbbf8:	mov    0x10(%rsp),%rsi
  6dbbfd:	call   *0x33e07d(%rip)        # a19c80 <_DYNAMIC+0x270>
  6dbc03:	lea    0x31f876(%rip),%rdx        # 9fb480 <__frame_dummy_init_array_entry+0x1240>
  6dbc0a:	mov    0x8(%rsp),%rsi
  6dbc0f:	call   *0x33e06b(%rip)        # a19c80 <_DYNAMIC+0x270>

/tmp/gpui-inspector-pointer-codegen-split/candidate-frozen:     file format elf64-x86-64


Disassembly of section .text:

00000000006ddcf0 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE23inspector_pick_in_sheetB10_>:
  6ddcf0:	push   %rbp
  6ddcf1:	push   %r15
  6ddcf3:	push   %r14
  6ddcf5:	push   %r13
  6ddcf7:	push   %r12
  6ddcf9:	push   %rbx
  6ddcfa:	sub    $0x68,%rsp
  6ddcfe:	movss  %xmm1,0x14(%rsp)
  6ddd04:	movss  %xmm0,0x10(%rsp)
  6ddd0a:	mov    0x638(%rdi),%rcx
  6ddd11:	test   %rcx,%rcx
  6ddd14:	je     6dde0f <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE23inspector_pick_in_sheetB10_+0x11f>
  6ddd1a:	cmpq   $0x0,0xd8(%rcx)
  6ddd22:	je     6dde0f <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE23inspector_pick_in_sheetB10_+0x11f>
  6ddd28:	mov    0x2c8(%rdi),%rax
  6ddd2f:	cmp    $0x1c,%rax
  6ddd33:	jb     6dde0f <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE23inspector_pick_in_sheetB10_+0x11f>
  6ddd39:	mov    %rsi,%r14
  6ddd3c:	mov    0x8(%rsi),%r15
  6ddd40:	test   %r15,%r15
  6ddd43:	je     6dde0f <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE23inspector_pick_in_sheetB10_+0x11f>
  6ddd49:	mov    %rdi,0x28(%rsp)
  6ddd4e:	mov    %rcx,0x20(%rsp)
  6ddd53:	mov    %rax,0x18(%rsp)
  6ddd58:	mov    (%r14),%r13
  6ddd5b:	mov    %r15,%rax
  6ddd5e:	shl    $0x6,%rax
  6ddd62:	add    %r13,%rax
  6ddd65:	movzbl 0x30(%r14),%ecx
  6ddd6a:	mov    %ecx,0xc(%rsp)
  6ddd6e:	add    $0x10,%r14
  6ddd72:	jmp    6dddcf <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE23inspector_pick_in_sheetB10_+0xdf>
  6ddd74:	data16 data16 cs nopw 0x0(%rax,%rax,1)
  6ddd80:	mov    %rbp,%r12
  6ddd83:	sub    %r13,%r12
  6ddd86:	mov    %r12,%rbx
  6ddd89:	shr    $0x6,%rbx
  6ddd8d:	mov    0x10(%r14),%rax
  6ddd91:	mov    %rax,0x40(%rsp)
  6ddd96:	movups (%r14),%xmm0
  6ddd9a:	movaps %xmm0,0x30(%rsp)
  6ddd9f:	mov    %r13,%rdi
  6ddda2:	mov    %r15,%rsi
  6ddda5:	lea    0x30(%rsp),%rdx
  6dddaa:	mov    0xc(%rsp),%ecx
  6dddae:	mov    %rbx,%r8
  6dddb1:	movss  0x10(%rsp),%xmm0
  6dddb7:	movss  0x14(%rsp),%xmm1
  6dddbd:	call   *0x33c13d(%rip)        # a19f00 <_DYNAMIC+0x4f0>
  6dddc3:	test   %al,%al
  6dddc5:	jne    6dde28 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE23inspector_pick_in_sheetB10_+0x138>
  6dddc7:	mov    %rbp,%rax
  6dddca:	cmp    %rbp,%r13
  6dddcd:	je     6dde23 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE23inspector_pick_in_sheetB10_+0x133>
  6dddcf:	lea    -0x40(%rax),%rbp
  6dddd3:	cmpb   $0x0,-0x2(%rax)
  6dddd7:	jne    6ddd80 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE23inspector_pick_in_sheetB10_+0x90>
  6dddd9:	mov    -0x8(%rax),%eax
  6ddddc:	cmp    $0x3ffff,%rax
  6ddde2:	jbe    6dddc7 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE23inspector_pick_in_sheetB10_+0xd7>
  6ddde4:	shr    $0x11,%eax
  6ddde7:	mov    %rbp,%rcx
  6dddea:	sub    %r13,%rcx
  6ddded:	shr    $0x6,%rcx
  6dddf1:	mov    $0x2,%edx
  6dddf6:	sub    %rax,%rdx
  6dddf9:	add    $0xfffffffffffffffe,%rax
  6dddfd:	shl    $0x6,%rdx
  6dde01:	cmp    %rcx,%rax
  6dde04:	lea    -0x40(%rbp,%rdx,1),%rbp
  6dde09:	cmovae %r13,%rbp
  6dde0d:	jmp    6dddc7 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE23inspector_pick_in_sheetB10_+0xd7>
  6dde0f:	xor    %eax,%eax
  6dde11:	mov    %r14,%rdx
  6dde14:	add    $0x68,%rsp
  6dde18:	pop    %rbx
  6dde19:	pop    %r12
  6dde1b:	pop    %r13
  6dde1d:	pop    %r14
  6dde1f:	pop    %r15
  6dde21:	pop    %rbp
  6dde22:	ret
  6dde23:	jmp    6ddee7 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE23inspector_pick_in_sheetB10_+0x1f7>
  6dde28:	cmp    %r15,%rbx
  6dde2b:	jae    6ddeee <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE23inspector_pick_in_sheetB10_+0x1fe>
  6dde31:	mov    0x28(%rsp),%r15
  6dde36:	lea    0x5d8(%r15),%rdi
  6dde3d:	mov    0x20(%r13,%r12,1),%rsi
  6dde42:	call   *0x33c030(%rip)        # a19e78 <_DYNAMIC+0x468>
  6dde48:	mov    %rdx,%r14
  6dde4b:	cmp    0x5d8(%r15),%rax
  6dde52:	jne    6ddee7 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE23inspector_pick_in_sheetB10_+0x1f7>
  6dde58:	mov    %rax,%rbx
  6dde5b:	lea    0x30(%rsp),%rdi
  6dde60:	mov    %r15,%rsi
  6dde63:	mov    %r14,%rdx
  6dde66:	call   6f8be0 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE16resolve_identityBO_>
  6dde6b:	mov    0x30(%rsp),%rcx
  6dde70:	mov    0x38(%rsp),%rax
  6dde75:	cmp    $0xfffffffffffffffe,%rcx
  6dde79:	jne    6ddeac <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE23inspector_pick_in_sheetB10_+0x1bc>
  6dde7b:	mov    0x20(%rsp),%rcx
  6dde80:	cmpq   $0x0,0xd8(%rcx)
  6dde88:	je     6ddee7 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE23inspector_pick_in_sheetB10_+0x1f7>
  6dde8a:	mov    0x18(%rsp),%rdx
  6dde8f:	add    $0xffffffffffffffe4,%rdx
  6dde93:	cmp    $0x2,%rax
  6dde97:	setae  %cl
  6dde9a:	cmp    %rdx,%rax
  6dde9d:	setb   %al
  6ddea0:	test   %al,%cl
  6ddea2:	je     6ddee7 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE23inspector_pick_in_sheetB10_+0x1f7>
  6ddea4:	mov    %rbx,%rax
  6ddea7:	jmp    6dde11 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE23inspector_pick_in_sheetB10_+0x121>
  6ddeac:	mov    0x48(%rsp),%rsi
  6ddeb1:	mov    0x50(%rsp),%rdi
  6ddeb6:	cmp    $0xc,%rcx
  6ddeba:	jle    6dded7 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE23inspector_pick_in_sheetB10_+0x1e7>
  6ddebc:	cmp    $0x21,%rcx
  6ddec0:	je     6dded7 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE23inspector_pick_in_sheetB10_+0x1e7>
  6ddec2:	cmp    $0x26,%rcx
  6ddec6:	jne    6ddee7 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE23inspector_pick_in_sheetB10_+0x1f7>
  6ddec8:	test   %rax,%rax
  6ddecb:	je     6ddee7 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE23inspector_pick_in_sheetB10_+0x1f7>
  6ddecd:	mov    0x40(%rsp),%rdi
  6dded2:	mov    %rax,%rsi
  6dded5:	jmp    6ddedc <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE23inspector_pick_in_sheetB10_+0x1ec>
  6dded7:	test   %rsi,%rsi
  6ddeda:	je     6ddee7 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE23inspector_pick_in_sheetB10_+0x1f7>
  6ddedc:	mov    $0x1,%edx
  6ddee1:	call   *0x33bd69(%rip)        # a19c50 <_DYNAMIC+0x240>
  6ddee7:	xor    %eax,%eax
  6ddee9:	jmp    6dde11 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE23inspector_pick_in_sheetB10_+0x121>
  6ddeee:	lea    0x31d393(%rip),%rdx        # 9fb288 <__frame_dummy_init_array_entry+0x1048>
  6ddef5:	mov    %rbx,%rdi
  6ddef8:	mov    %r15,%rsi
  6ddefb:	call   *0x33bd7f(%rip)        # a19c80 <_DYNAMIC+0x270>

/tmp/gpui-inspector-pointer-codegen-split/candidate-frozen:     file format elf64-x86-64


Disassembly of section .text:

00000000006f8ec0 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_>:
  6f8ec0:	push   %rbp
  6f8ec1:	push   %r15
  6f8ec3:	push   %r14
  6f8ec5:	push   %r13
  6f8ec7:	push   %r12
  6f8ec9:	push   %rbx
  6f8eca:	sub    $0x68,%rsp
  6f8ece:	movss  %xmm1,0xc(%rsp)
  6f8ed4:	movss  %xmm0,0x8(%rsp)
  6f8eda:	mov    %rdi,%r13
  6f8edd:	mov    0x5a0(%rdi),%r14
  6f8ee4:	mov    0x5a8(%rdi),%rax
  6f8eeb:	mov    %rax,(%rsp)
  6f8eef:	mov    0x638(%rdi),%rbx
  6f8ef6:	test   %rbx,%rbx
  6f8ef9:	je     6f8f14 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x54>
  6f8efb:	mov    0x100(%rbx),%rsi
  6f8f02:	test   %rsi,%rsi
  6f8f05:	je     6f8f29 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x69>
  6f8f07:	lea    0x10(%rsp),%rdi
  6f8f0c:	call   *0x320f5e(%rip)        # a19e70 <_DYNAMIC+0x460>
  6f8f12:	jmp    6f8f3a <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x7a>
  6f8f14:	movq   $0x4,0x10(%rsp)
  6f8f1d:	xorps  %xmm0,%xmm0
  6f8f20:	movups %xmm0,0x18(%rsp)
  6f8f25:	xor    %ebx,%ebx
  6f8f27:	jmp    6f8f41 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x81>
  6f8f29:	movq   $0x4,0x10(%rsp)
  6f8f32:	xorps  %xmm0,%xmm0
  6f8f35:	movups %xmm0,0x18(%rsp)
  6f8f3a:	cmpq   $0x0,(%rbx)
  6f8f3e:	setne  %bl
  6f8f41:	mov    0x698(%r13),%rax
  6f8f48:	mov    %r14,0x30(%rsp)
  6f8f4d:	mov    (%rsp),%r15
  6f8f51:	mov    %r15,0x38(%rsp)
  6f8f56:	mov    0x10(%rsp),%rcx
  6f8f5b:	mov    %rcx,0x40(%rsp)
  6f8f60:	mov    0x18(%rsp),%rcx
  6f8f65:	mov    %rcx,0x48(%rsp)
  6f8f6a:	mov    0x20(%rsp),%rcx
  6f8f6f:	mov    %rcx,0x50(%rsp)
  6f8f74:	mov    %rax,0x58(%rsp)
  6f8f79:	mov    %bl,0x60(%rsp)
  6f8f7d:	lea    0x30(%rsp),%rdi
  6f8f82:	movss  0x8(%rsp),%xmm0
  6f8f88:	movss  0xc(%rsp),%xmm1
  6f8f8e:	call   *0x320f74(%rip)        # a19f08 <_DYNAMIC+0x4f8>
  6f8f94:	xor    %r12d,%r12d
  6f8f97:	test   %r15,%r15
  6f8f9a:	je     6f91fd <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x33d>
  6f8fa0:	test   %al,%al
  6f8fa2:	je     6f91fd <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x33d>
  6f8fa8:	mov    %r13,0x28(%rsp)
  6f8fad:	lea    0x40(%rsp),%r15
  6f8fb2:	mov    (%rsp),%rax
  6f8fb6:	shl    $0x6,%rax
  6f8fba:	add    %r14,%rax
  6f8fbd:	movzbl %bl,%ebp
  6f8fc0:	xor    %r12d,%r12d
  6f8fc3:	jmp    6f901b <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x15b>
  6f8fc5:	data16 cs nopw 0x0(%rax,%rax,1)
  6f8fd0:	mov    %rbx,%r13
  6f8fd3:	sub    %r14,%r13
  6f8fd6:	shr    $0x6,%r13
  6f8fda:	mov    0x10(%r15),%rax
  6f8fde:	mov    %rax,0x20(%rsp)
  6f8fe3:	movups (%r15),%xmm0
  6f8fe7:	movaps %xmm0,0x10(%rsp)
  6f8fec:	mov    %r14,%rdi
  6f8fef:	mov    (%rsp),%rsi
  6f8ff3:	lea    0x10(%rsp),%rdx
  6f8ff8:	mov    %ebp,%ecx
  6f8ffa:	mov    %r13,%r8
  6f8ffd:	movss  0x8(%rsp),%xmm0
  6f9003:	movss  0xc(%rsp),%xmm1
  6f9009:	call   *0x320ef1(%rip)        # a19f00 <_DYNAMIC+0x4f0>
  6f900f:	test   %al,%al
  6f9011:	jne    6f9060 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x1a0>
  6f9013:	mov    %rbx,%rax
  6f9016:	cmp    %rbx,%r14
  6f9019:	je     6f905b <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x19b>
  6f901b:	lea    -0x40(%rax),%rbx
  6f901f:	cmpb   $0x0,-0x2(%rax)
  6f9023:	jne    6f8fd0 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x110>
  6f9025:	mov    -0x8(%rax),%eax
  6f9028:	cmp    $0x3ffff,%rax
  6f902e:	jbe    6f9013 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x153>
  6f9030:	shr    $0x11,%eax
  6f9033:	mov    %rbx,%rcx
  6f9036:	sub    %r14,%rcx
  6f9039:	shr    $0x6,%rcx
  6f903d:	mov    $0x2,%edx
  6f9042:	sub    %rax,%rdx
  6f9045:	add    $0xfffffffffffffffe,%rax
  6f9049:	shl    $0x6,%rdx
  6f904d:	cmp    %rcx,%rax
  6f9050:	lea    -0x40(%rbx,%rdx,1),%rbx
  6f9055:	cmovae %r14,%rbx
  6f9059:	jmp    6f9013 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x153>
  6f905b:	jmp    6f91fd <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x33d>
  6f9060:	mov    0x28(%rsp),%rdx
  6f9065:	mov    0x1e8(%rdx),%rax
  6f906c:	mov    0x1f0(%rdx),%rcx
  6f9073:	mov    0x1f8(%rdx),%r8
  6f907a:	mov    0x2c8(%rdx),%rsi
  6f9081:	mov    0x2c0(%rdx),%r9
  6f9088:	jmp    6f90a8 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x1e8>
  6f908a:	nopw   0x0(%rax,%rax,1)
  6f9090:	mov    0x38(%r10),%r13d
  6f9094:	and    $0x1ffff,%r13d
  6f909b:	cmp    $0x1ffff,%r13
  6f90a2:	je     6f91fa <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x33a>
  6f90a8:	cmp    (%rsp),%r13
  6f90ac:	jae    6f920f <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x34f>
  6f90b2:	shl    $0x6,%r13
  6f90b6:	lea    (%r14,%r13,1),%r10
  6f90ba:	mov    0x20(%r14,%r13,1),%rdx
  6f90bf:	test   %rax,%rax
  6f90c2:	je     6f90e0 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x220>
  6f90c4:	cmp    $0x1,%eax
  6f90c7:	jne    6f9100 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x240>
  6f90c9:	test   %r8,%r8
  6f90cc:	je     6f9090 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x1d0>
  6f90ce:	cmp    $0x1,%r8
  6f90d2:	jne    6f9120 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x260>
  6f90d4:	xor    %edi,%edi
  6f90d6:	jmp    6f9154 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x294>
  6f90d8:	nopl   0x0(%rax,%rax,1)
  6f90e0:	mov    %rdx,%rdi
  6f90e3:	sub    %rcx,%rdi
  6f90e6:	setae  %r11b
  6f90ea:	cmp    %r8,%rdi
  6f90ed:	setb   %bl
  6f90f0:	test   %bl,%r11b
  6f90f3:	je     6f9090 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x1d0>
  6f90f5:	jmp    6f91d6 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x316>
  6f90fa:	nopw   0x0(%rax,%rax,1)
  6f9100:	test   %r8,%r8
  6f9103:	je     6f9090 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x1d0>
  6f9105:	cmp    $0x1,%r8
  6f9109:	jne    6f9195 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x2d5>
  6f910f:	mov    %rcx,%rdi
  6f9112:	cmp    %rdx,(%rcx)
  6f9115:	jne    6f9090 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x1d0>
  6f911b:	jmp    6f91d3 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x313>
  6f9120:	mov    %r8,%r11
  6f9123:	xor    %edi,%edi
  6f9125:	data16 cs nopw 0x0(%rax,%rax,1)
  6f9130:	mov    %rdi,%rbx
  6f9133:	mov    %r11,%r15
  6f9136:	shr    $1,%r15
  6f9139:	add    %r15,%rdi
  6f913c:	mov    %rdi,%r12
  6f913f:	shl    $0x4,%r12
  6f9143:	cmp    %rdx,(%rcx,%r12,1)
  6f9147:	cmova  %rbx,%rdi
  6f914b:	sub    %r15,%r11
  6f914e:	cmp    $0x1,%r11
  6f9152:	ja     6f9130 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x270>
  6f9154:	mov    %rdi,%rbx
  6f9157:	shl    $0x4,%rbx
  6f915b:	xor    %r11d,%r11d
  6f915e:	cmp    %rdx,(%rcx,%rbx,1)
  6f9162:	setbe  %r11b
  6f9166:	add    %rdi,%r11
  6f9169:	je     6f9090 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x1d0>
  6f916f:	shl    $0x4,%r11
  6f9173:	mov    %rdx,%rdi
  6f9176:	sub    -0x10(%rcx,%r11,1),%rdi
  6f917b:	mov    -0x4(%rcx,%r11,1),%ebx
  6f9180:	cmp    %rbx,%rdi
  6f9183:	jae    6f9090 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x1d0>
  6f9189:	add    %rcx,%r11
  6f918c:	mov    -0x8(%r11),%r11d
  6f9190:	add    %r11,%rdi
  6f9193:	jmp    6f91d6 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x316>
  6f9195:	mov    %r8,%rdi
  6f9198:	xor    %r11d,%r11d
  6f919b:	nopl   0x0(%rax,%rax,1)
  6f91a0:	mov    %r11,%rbx
  6f91a3:	mov    %rdi,%r15
  6f91a6:	shr    $1,%r15
  6f91a9:	add    %r15,%r11
  6f91ac:	lea    (%r11,%r11,2),%r12
  6f91b0:	cmp    %rdx,(%rcx,%r12,4)
  6f91b4:	cmova  %rbx,%r11
  6f91b8:	sub    %r15,%rdi
  6f91bb:	cmp    $0x1,%rdi
  6f91bf:	ja     6f91a0 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x2e0>
  6f91c1:	lea    (%r11,%r11,2),%rdi
  6f91c5:	cmp    %rdx,(%rcx,%rdi,4)
  6f91c9:	jne    6f9090 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x1d0>
  6f91cf:	lea    (%rcx,%rdi,4),%rdi
  6f91d3:	mov    0x8(%rdi),%edi
  6f91d6:	cmp    %rsi,%rdi
  6f91d9:	jae    6f9223 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x363>
  6f91db:	lea    (%rdi,%rdi,4),%rdi
  6f91df:	mov    $0x1,%r12d
  6f91e5:	cmpq   $0x0,0x8(%r9,%rdi,8)
  6f91eb:	jne    6f91fd <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x33d>
  6f91ed:	cmpb   $0x4,0x3d(%r10)
  6f91f2:	jne    6f9090 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x1d0>
  6f91f8:	jmp    6f91fd <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x33d>
  6f91fa:	xor    %r12d,%r12d
  6f91fd:	mov    %r12,%rax
  6f9200:	add    $0x68,%rsp
  6f9204:	pop    %rbx
  6f9205:	pop    %r12
  6f9207:	pop    %r13
  6f9209:	pop    %r14
  6f920b:	pop    %r15
  6f920d:	pop    %rbp
  6f920e:	ret
  6f920f:	lea    0x302252(%rip),%rdx        # 9fb468 <__frame_dummy_init_array_entry+0x1228>
  6f9216:	mov    %r13,%rdi
  6f9219:	mov    (%rsp),%rsi
  6f921d:	call   *0x320a5d(%rip)        # a19c80 <_DYNAMIC+0x270>
  6f9223:	lea    0x302256(%rip),%rdx        # 9fb480 <__frame_dummy_init_array_entry+0x1240>
  6f922a:	call   *0x320a50(%rip)        # a19c80 <_DYNAMIC+0x270>

inspector_pointer_control::click_only bytes=879 stack=152

inspector_pointer_control::ack bytes=241 stack=136

inspector_pointer_control::main bytes=7119 stack=3368

inspector_pointer_control::dispatch bytes=3204 stack=248

inspector_pointer_control::hit_only bytes=1057 stack=168

<gpui::runtime::Runtime<inspector_pointer_control::Model>>::pointer_hit bytes=1092 stack=152

<gpui::runtime::Runtime<inspector_pointer_control::Model>>::inspector_focus_hit bytes=1141 stack=216

<gpui::runtime::Runtime<inspector_pointer_control::Model>>::inspector_pick_in_sheet bytes=529 stack=152

<gpui::runtime::Runtime<inspector_pointer_control::Model>>::hit bytes=880 stack=152
