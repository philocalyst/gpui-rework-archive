
/tmp/gpui-inspector-pointer-codegen-inline/candidate-frozen:     file format elf64-x86-64


Disassembly of section .text:

00000000006ce8a0 <_RNCNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB9_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19pointer_release_hits0_0BY_>:
  6ce8a0:	push   %r15
  6ce8a2:	push   %r14
  6ce8a4:	push   %r12
  6ce8a6:	push   %rbx
  6ce8a7:	sub    $0x48,%rsp
  6ce8ab:	mov    (%rdi),%rax
  6ce8ae:	mov    $0x1,%bl
  6ce8b0:	cmpl   $0x1,(%rax)
  6ce8b3:	jne    6ce991 <_RNCNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB9_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19pointer_release_hits0_0BY_+0xf1>
  6ce8b9:	mov    %rdi,%r14
  6ce8bc:	movss  0x4(%rax),%xmm0
  6ce8c1:	movss  0x8(%rax),%xmm1
  6ce8c6:	mov    %rsi,%r12
  6ce8c9:	mov    %rsi,%rdi
  6ce8cc:	movss  %xmm0,0x8(%rsp)
  6ce8d2:	movss  %xmm1,0xc(%rsp)
  6ce8d8:	call   *0x34b17a(%rip)        # a19a58 <_DYNAMIC+0x438>
  6ce8de:	test   %al,%al
  6ce8e0:	je     6ce991 <_RNCNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB9_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19pointer_release_hits0_0BY_+0xf1>
  6ce8e6:	mov    0x8(%r14),%r15
  6ce8ea:	mov    0x30(%r12),%rax
  6ce8ef:	mov    %rax,0x40(%rsp)
  6ce8f4:	movups (%r12),%xmm0
  6ce8f9:	movups 0x10(%r12),%xmm1
  6ce8ff:	movups 0x20(%r12),%xmm2
  6ce905:	movaps %xmm2,0x30(%rsp)
  6ce90a:	movaps %xmm1,0x20(%rsp)
  6ce90f:	movaps %xmm0,0x10(%rsp)
  6ce914:	mov    0x638(%r15),%rax
  6ce91b:	test   %rax,%rax
  6ce91e:	je     6ce94b <_RNCNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB9_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19pointer_release_hits0_0BY_+0xab>
  6ce920:	mov    0xd8(%rax),%rax
  6ce927:	test   %rax,%rax
  6ce92a:	je     6ce94b <_RNCNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB9_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19pointer_release_hits0_0BY_+0xab>
  6ce92c:	cmpb   $0x0,0x12(%rax)
  6ce930:	je     6ce94b <_RNCNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB9_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19pointer_release_hits0_0BY_+0xab>
  6ce932:	mov    %r12,%rsi
  6ce935:	mov    %r15,%rdi
  6ce938:	movss  0x8(%rsp),%xmm0
  6ce93e:	movss  0xc(%rsp),%xmm1
  6ce944:	call   6dd730 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE23inspector_pick_in_sheetB10_>
  6ce949:	jmp    6ce97b <_RNCNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB9_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19pointer_release_hits0_0BY_+0xdb>
  6ce94b:	lea    0x10(%rsp),%rsi
  6ce950:	mov    %r15,%rdi
  6ce953:	movss  0x8(%rsp),%xmm0
  6ce959:	movss  0xc(%rsp),%xmm1
  6ce95f:	call   6e7ae0 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE12hit_in_sheetBO_>
  6ce964:	test   $0x1,%al
  6ce966:	je     6ce991 <_RNCNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB9_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19pointer_release_hits0_0BY_+0xf1>
  6ce968:	add    $0x5d8,%r15
  6ce96f:	mov    %r15,%rdi
  6ce972:	mov    %rdx,%rsi
  6ce975:	call   *0x34b0e5(%rip)        # a19a60 <_DYNAMIC+0x440>
  6ce97b:	test   %rax,%rax
  6ce97e:	je     6ce991 <_RNCNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB9_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19pointer_release_hits0_0BY_+0xf1>
  6ce980:	mov    0x10(%r14),%rcx
  6ce984:	xor    (%rcx),%rax
  6ce987:	xor    0x8(%rcx),%rdx
  6ce98b:	or     %rax,%rdx
  6ce98e:	setne  %bl
  6ce991:	mov    %ebx,%eax
  6ce993:	add    $0x48,%rsp
  6ce997:	pop    %rbx
  6ce998:	pop    %r12
  6ce99a:	pop    %r14
  6ce99c:	pop    %r15
  6ce99e:	ret

/tmp/gpui-inspector-pointer-codegen-inline/candidate-frozen:     file format elf64-x86-64


Disassembly of section .text:

00000000006d0520 <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only>:
  6d0520:	push   %rbp
  6d0521:	push   %r15
  6d0523:	push   %r14
  6d0525:	push   %r13
  6d0527:	push   %r12
  6d0529:	push   %rbx
  6d052a:	sub    $0x68,%rsp
  6d052e:	mov    (%rsi),%rbx
  6d0531:	test   %rbx,%rbx
  6d0534:	je     6d0559 <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x39>
  6d0536:	add    $0x8,%rsi
  6d053a:	mov    %rbx,0x58(%rsp)
  6d053f:	mov    %rsi,0x60(%rsp)
  6d0544:	cmpb   $0x1,0x746(%rbx)
  6d054b:	jne    6d056d <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x4d>
  6d054d:	movq   $0xe,(%rdi)
  6d0554:	jmp    6d0654 <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x134>
  6d0559:	movq   $0xd,(%rdi)
  6d0560:	movq   $0x0,0x8(%rdi)
  6d0568:	jmp    6d0654 <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x134>
  6d056d:	cmpb   $0x1,0x742(%rbx)
  6d0574:	jne    6d064d <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x12d>
  6d057a:	cmpb   $0x0,0x743(%rbx)
  6d0581:	jne    6d064d <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x12d>
  6d0587:	cmpb   $0x0,0x744(%rbx)
  6d058e:	je     6d064d <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x12d>
  6d0594:	cmpq   $0xffffffffffffffff,0x5b0(%rbx)
  6d059c:	jne    6d064d <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x12d>
  6d05a2:	mov    0x688(%rbx),%rax
  6d05a9:	cmp    0x690(%rbx),%rax
  6d05b0:	jne    6d064d <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x12d>
  6d05b6:	mov    0x6a0(%rbx),%rax
  6d05bd:	cmp    0x698(%rbx),%rax
  6d05c4:	jne    6d064d <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x12d>
  6d05ca:	movss  0x738(%rbx),%xmm2
  6d05d2:	ucomiss 0x73c(%rbx),%xmm2
  6d05d9:	jne    6d064d <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x12d>
  6d05db:	jp     6d064d <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x12d>
  6d05dd:	mov    0x638(%rbx),%r15
  6d05e4:	test   %r15,%r15
  6d05e7:	movss  %xmm1,0x4(%rsp)
  6d05ed:	movss  %xmm0,(%rsp)
  6d05f2:	je     6d069f <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x17f>
  6d05f8:	mov    0xd8(%r15),%rcx
  6d05ff:	test   %rcx,%rcx
  6d0602:	je     6d0663 <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x143>
  6d0604:	cmpb   $0x0,0x12(%rcx)
  6d0608:	je     6d0663 <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x143>
  6d060a:	mov    %rdi,%r14
  6d060d:	mov    0x5a0(%rbx),%r12
  6d0614:	mov    0x5a8(%rbx),%r13
  6d061b:	mov    0x100(%r15),%rsi
  6d0622:	test   %rsi,%rsi
  6d0625:	je     6d0865 <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x345>
  6d062b:	lea    0x40(%rsp),%rdi
  6d0630:	call   *0x34945a(%rip)        # a19a90 <_DYNAMIC+0x470>
  6d0636:	movss  (%rsp),%xmm0
  6d063b:	movss  0x4(%rsp),%xmm1
  6d0641:	mov    0x698(%rbx),%rax
  6d0648:	jmp    6d0876 <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x356>
  6d064d:	movq   $0x12,(%rdi)
  6d0654:	add    $0x68,%rsp
  6d0658:	pop    %rbx
  6d0659:	pop    %r12
  6d065b:	pop    %r13
  6d065d:	pop    %r14
  6d065f:	pop    %r15
  6d0661:	pop    %rbp
  6d0662:	ret
  6d0663:	mov    0x5a0(%rbx),%r12
  6d066a:	mov    0x5a8(%rbx),%r13
  6d0671:	mov    %rdi,%r14
  6d0674:	mov    0x100(%r15),%rsi
  6d067b:	test   %rsi,%rsi
  6d067e:	je     6d06c5 <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x1a5>
  6d0680:	lea    0x40(%rsp),%rdi
  6d0685:	call   *0x349405(%rip)        # a19a90 <_DYNAMIC+0x470>
  6d068b:	movss  (%rsp),%xmm0
  6d0690:	movss  0x4(%rsp),%xmm1
  6d0696:	mov    0x698(%rbx),%rax
  6d069d:	jmp    6d06d6 <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x1b6>
  6d069f:	mov    %rdi,%r14
  6d06a2:	mov    0x5a0(%rbx),%r12
  6d06a9:	mov    0x5a8(%rbx),%r13
  6d06b0:	movq   $0x4,0x40(%rsp)
  6d06b9:	xorps  %xmm2,%xmm2
  6d06bc:	movups %xmm2,0x48(%rsp)
  6d06c1:	xor    %ecx,%ecx
  6d06c3:	jmp    6d06dd <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x1bd>
  6d06c5:	movq   $0x4,0x40(%rsp)
  6d06ce:	xorps  %xmm2,%xmm2
  6d06d1:	movups %xmm2,0x48(%rsp)
  6d06d6:	cmpq   $0x0,(%r15)
  6d06da:	setne  %cl
  6d06dd:	mov    %r12,0x8(%rsp)
  6d06e2:	mov    %r13,0x10(%rsp)
  6d06e7:	mov    0x40(%rsp),%rdx
  6d06ec:	mov    %rdx,0x18(%rsp)
  6d06f1:	mov    0x48(%rsp),%rdx
  6d06f6:	mov    %rdx,0x20(%rsp)
  6d06fb:	mov    0x50(%rsp),%rdx
  6d0700:	mov    %rdx,0x28(%rsp)
  6d0705:	mov    %rax,0x30(%rsp)
  6d070a:	mov    %cl,0x38(%rsp)
  6d070e:	lea    0x8(%rsp),%rsi
  6d0713:	mov    %rbx,%rdi
  6d0716:	call   6e7ae0 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE12hit_in_sheetBO_>
  6d071b:	cmp    $0x1,%rax
  6d071f:	jne    6d07b9 <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x299>
  6d0725:	lea    0x5d8(%rbx),%rdi
  6d072c:	mov    %rdx,%rsi
  6d072f:	call   *0x34932b(%rip)        # a19a60 <_DYNAMIC+0x440>
  6d0735:	cmp    0x5d8(%rbx),%rax
  6d073c:	jne    6d0837 <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x317>
  6d0742:	mov    %rax,%r12
  6d0745:	mov    %rdx,%r15
  6d0748:	lea    0x8(%rsp),%rdi
  6d074d:	mov    %rbx,%rsi
  6d0750:	call   6f8a80 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE16resolve_identityBO_>
  6d0755:	mov    0x8(%rsp),%rax
  6d075a:	mov    0x10(%rsp),%rdi
  6d075f:	cmp    $0xfffffffffffffffe,%rax
  6d0763:	jne    6d083c <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x31c>
  6d0769:	mov    0x2c8(%rbx),%rsi
  6d0770:	cmp    %rsi,%rdi
  6d0773:	jae    6d092e <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x40e>
  6d0779:	mov    0x2c0(%rbx),%rax
  6d0780:	lea    (%rdi,%rdi,4),%rcx
  6d0784:	mov    0x20(%rax,%rcx,8),%edi
  6d0788:	call   6e20b0 <_RNvMsh_NtCs6ZNK6sH19NW_4gpui7runtimeNtB5_4Node4kind>
  6d078d:	cmp    $0x4,%al
  6d078f:	jne    6d08e0 <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x3c0>
  6d0795:	mov    %r14,%rdi
  6d0798:	mov    %rbx,%rsi
  6d079b:	mov    %r12,%rdx
  6d079e:	mov    %r15,%rcx
  6d07a1:	movss  (%rsp),%xmm0
  6d07a6:	movss  0x4(%rsp),%xmm1
  6d07ac:	xor    %r8d,%r8d
  6d07af:	call   6db9e0 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime7editingINtB7_10RuntimeMutNtCs4gijoeCAvqI_25inspector_pointer_control5ModeluE14select_pointerB12_>
  6d07b4:	jmp    6d0654 <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x134>
  6d07b9:	mov    0x610(%rbx),%rdx
  6d07c0:	mov    0x618(%rbx),%rcx
  6d07c7:	movq   $0x0,0x610(%rbx)
  6d07d2:	movq   $0x0,0x730(%rbx)
  6d07dd:	lea    0x8(%rsp),%rdi
  6d07e2:	mov    %rbx,%rsi
  6d07e5:	call   6dc000 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime7editingINtB7_10RuntimeMutNtCs4gijoeCAvqI_25inspector_pointer_control5ModeluE20publish_focus_changeB12_>
  6d07ea:	mov    0x8(%rsp),%rax
  6d07ef:	cmp    $0xfffffffffffffffe,%rax
  6d07f3:	je     6d08d4 <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x3b4>
  6d07f9:	mov    0x30(%rsp),%rcx
  6d07fe:	movzbl 0x38(%rsp),%edx
  6d0803:	mov    0x3c(%rsp),%esi
  6d0807:	mov    %esi,0x34(%r14)
  6d080b:	mov    0x39(%rsp),%esi
  6d080f:	mov    %esi,0x31(%r14)
  6d0813:	movups 0x10(%rsp),%xmm0
  6d0818:	movups 0x20(%rsp),%xmm1
  6d081d:	mov    %rax,(%r14)
  6d0820:	movups %xmm0,0x8(%r14)
  6d0825:	movups %xmm1,0x18(%r14)
  6d082a:	mov    %rcx,0x28(%r14)
  6d082e:	mov    %dl,0x30(%r14)
  6d0832:	jmp    6d0654 <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x134>
  6d0837:	mov    $0x11,%eax
  6d083c:	mov    0x38(%rsp),%rcx
  6d0841:	mov    %rcx,0x30(%r14)
  6d0845:	movups 0x18(%rsp),%xmm0
  6d084a:	movups 0x28(%rsp),%xmm1
  6d084f:	movups %xmm1,0x20(%r14)
  6d0854:	movups %xmm0,0x10(%r14)
  6d0859:	mov    %rax,(%r14)
  6d085c:	mov    %rdi,0x8(%r14)
  6d0860:	jmp    6d0654 <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x134>
  6d0865:	movq   $0x4,0x40(%rsp)
  6d086e:	xorps  %xmm2,%xmm2
  6d0871:	movups %xmm2,0x48(%rsp)
  6d0876:	cmpq   $0x0,(%r15)
  6d087a:	mov    %r12,0x8(%rsp)
  6d087f:	mov    %r13,0x10(%rsp)
  6d0884:	mov    0x40(%rsp),%rcx
  6d0889:	mov    %rcx,0x18(%rsp)
  6d088e:	mov    0x48(%rsp),%rcx
  6d0893:	mov    %rcx,0x20(%rsp)
  6d0898:	mov    0x50(%rsp),%rcx
  6d089d:	mov    %rcx,0x28(%rsp)
  6d08a2:	mov    %rax,0x30(%rsp)
  6d08a7:	setne  0x38(%rsp)
  6d08ac:	lea    0x8(%rsp),%rsi
  6d08b1:	mov    %rbx,%rdi
  6d08b4:	call   6dd730 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE23inspector_pick_in_sheetB10_>
  6d08b9:	test   %rax,%rax
  6d08bc:	je     6d08d4 <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x3b4>
  6d08be:	mov    %rdx,%rcx
  6d08c1:	mov    %r14,%rdi
  6d08c4:	mov    %rbx,%rsi
  6d08c7:	mov    %rax,%rdx
  6d08ca:	call   6df7f0 <_RNvMs4_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_10RuntimeMutNtCs4gijoeCAvqI_25inspector_pointer_control5ModeluE16inspector_selectB14_>
  6d08cf:	jmp    6d0654 <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x134>
  6d08d4:	movq   $0x19,(%r14)
  6d08db:	jmp    6d0654 <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x134>
  6d08e0:	mov    0x610(%rbx),%r13
  6d08e7:	mov    0x618(%rbx),%rbp
  6d08ee:	lea    0x8(%rsp),%rdi
  6d08f3:	mov    %rbx,%rsi
  6d08f6:	mov    %r12,%rdx
  6d08f9:	mov    %r15,%rcx
  6d08fc:	call   6db660 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE5focusBW_>
  6d0901:	mov    0x8(%rsp),%rax
  6d0906:	cmp    $0xfffffffffffffffe,%rax
  6d090a:	jne    6d07f9 <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x2d9>
  6d0910:	lea    0x58(%rsp),%rsi
  6d0915:	mov    %r14,%rdi
  6d0918:	mov    %r12,%rdx
  6d091b:	mov    %r15,%rcx
  6d091e:	mov    %r13,%r8
  6d0921:	mov    %rbp,%r9
  6d0924:	call   6d3730 <_RNvMNtNtCs6ZNK6sH19NW_4gpui7runtime4turnINtB4_10RuntimeMutNtCs4gijoeCAvqI_25inspector_pointer_control5ModeluE16activate_focusedBW_>
  6d0929:	jmp    6d0654 <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x134>
  6d092e:	lea    0x32a713(%rip),%rdx        # 9fb048 <__frame_dummy_init_array_entry+0x11f8>
  6d0935:	call   *0x348f55(%rip)        # a19890 <_DYNAMIC+0x270>

/tmp/gpui-inspector-pointer-codegen-inline/candidate-frozen:     file format elf64-x86-64


Disassembly of section .text:

00000000006d0940 <_RNvCs4gijoeCAvqI_25inspector_pointer_control3ack>:
  6d0940:	push   %r14
  6d0942:	push   %rbx
  6d0943:	sub    $0x78,%rsp
  6d0947:	test   %rdi,%rdi
  6d094a:	je     6d0985 <_RNvCs4gijoeCAvqI_25inspector_pointer_control3ack+0x45>
  6d094c:	mov    %rdi,%rsi
  6d094f:	cmpb   $0x0,0x746(%rdi)
  6d0956:	jne    6d098c <_RNvCs4gijoeCAvqI_25inspector_pointer_control3ack+0x4c>
  6d0958:	mov    0x6a8(%rsi),%rdx
  6d095f:	test   %rdx,%rdx
  6d0962:	je     6d0993 <_RNvCs4gijoeCAvqI_25inspector_pointer_control3ack+0x53>
  6d0964:	mov    0x6b0(%rsi),%rcx
  6d096b:	lea    0x40(%rsp),%rdi
  6d0970:	call   6e7530 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE11acknowledgeBO_>
  6d0975:	cmpq   $0xfffffffffffffffe,0x40(%rsp)
  6d097b:	jne    6d09cd <_RNvCs4gijoeCAvqI_25inspector_pointer_control3ack+0x8d>
  6d097d:	add    $0x78,%rsp
  6d0981:	pop    %rbx
  6d0982:	pop    %r14
  6d0984:	ret
  6d0985:	mov    $0xd,%eax
  6d098a:	jmp    6d0998 <_RNvCs4gijoeCAvqI_25inspector_pointer_control3ack+0x58>
  6d098c:	mov    $0xe,%eax
  6d0991:	jmp    6d0998 <_RNvCs4gijoeCAvqI_25inspector_pointer_control3ack+0x58>
  6d0993:	mov    $0x14,%eax
  6d0998:	mov    %rax,(%rsp)
  6d099c:	movq   $0x0,0x8(%rsp)
  6d09a5:	lea    -0x686232(%rip),%rdi        # 4a77a <GCC_except_table0+0xd01a>
  6d09ac:	lea    0x329f85(%rip),%rcx        # 9fa938 <__frame_dummy_init_array_entry+0xae8>
  6d09b3:	lea    0x329d9e(%rip),%r8        # 9fa758 <__frame_dummy_init_array_entry+0x908>
  6d09ba:	mov    %rsp,%rbx
  6d09bd:	mov    $0x2b,%esi
  6d09c2:	mov    %rbx,%rdx
  6d09c5:	call   *0x348f45(%rip)        # a19910 <_DYNAMIC+0x2f0>
  6d09cb:	jmp    6d0a1a <_RNvCs4gijoeCAvqI_25inspector_pointer_control3ack+0xda>
  6d09cd:	mov    0x70(%rsp),%rax
  6d09d2:	mov    %rax,0x30(%rsp)
  6d09d7:	movups 0x40(%rsp),%xmm0
  6d09dc:	movups 0x50(%rsp),%xmm1
  6d09e1:	movups 0x60(%rsp),%xmm2
  6d09e6:	movaps %xmm2,0x20(%rsp)
  6d09eb:	movaps %xmm1,0x10(%rsp)
  6d09f0:	movaps %xmm0,(%rsp)
  6d09f4:	lea    -0x686281(%rip),%rdi        # 4a77a <GCC_except_table0+0xd01a>
  6d09fb:	lea    0x329f36(%rip),%rcx        # 9fa938 <__frame_dummy_init_array_entry+0xae8>
  6d0a02:	lea    0x329d67(%rip),%r8        # 9fa770 <__frame_dummy_init_array_entry+0x920>
  6d0a09:	mov    %rsp,%rbx
  6d0a0c:	mov    $0x2b,%esi
  6d0a11:	mov    %rbx,%rdx
  6d0a14:	call   *0x348ef6(%rip)        # a19910 <_DYNAMIC+0x2f0>
  6d0a1a:	ud2
  6d0a1c:	jmp    6d0a1e <_RNvCs4gijoeCAvqI_25inspector_pointer_control3ack+0xde>
  6d0a1e:	mov    %rax,%r14
  6d0a21:	mov    %rbx,%rdi
  6d0a24:	call   6be410 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueNtNtCs6ZNK6sH19NW_4gpui7runtime5ErrorECs4gijoeCAvqI_25inspector_pointer_control>
  6d0a29:	mov    %r14,%rdi
  6d0a2c:	call   9f8aa0 <_Unwind_Resume@plt>

/tmp/gpui-inspector-pointer-codegen-inline/candidate-frozen:     file format elf64-x86-64


Disassembly of section .text:

00000000006d0a40 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main>:
  6d0a40:	push   %rbp
  6d0a41:	push   %r15
  6d0a43:	push   %r14
  6d0a45:	push   %r13
  6d0a47:	push   %r12
  6d0a49:	push   %rbx
  6d0a4a:	sub    $0xcf8,%rsp
  6d0a51:	call   *0x348e11(%rip)        # a19868 <_DYNAMIC+0x248>
  6d0a57:	mov    $0x6,%edi
  6d0a5c:	mov    $0x1,%esi
  6d0a61:	call   *0x348e09(%rip)        # a19870 <_DYNAMIC+0x250>
  6d0a67:	test   %rax,%rax
  6d0a6a:	je     6d2156 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1716>
  6d0a70:	mov    %rax,%rbx
  6d0a73:	movw   $0x6863,0x4(%rax)
  6d0a79:	movl   $0x72616573,(%rax)
  6d0a7f:	lea    0x3c0(%rsp),%rdi
  6d0a87:	movabs $0x384000002d0,%r14
  6d0a91:	movss  -0x693309(%rip),%xmm0        # 3d790 <GCC_except_table0+0x30>
  6d0a99:	mov    %r14,%rsi
  6d0a9c:	call   *0x348ff6(%rip)        # a19a98 <_DYNAMIC+0x478>
  6d0aa2:	mov    0x3c0(%rsp),%r13
  6d0aaa:	cmp    $0xfffffffffffffffe,%r13
  6d0aae:	jne    6d2166 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1726>
  6d0ab4:	movq   $0x0,0x3d8(%rsp)
  6d0ac0:	movq   $0x8,0x3e0(%rsp)
  6d0acc:	xorps  %xmm0,%xmm0
  6d0acf:	movups %xmm0,0x3e8(%rsp)
  6d0ad7:	movq   $0xffffffffffffffff,0x3c0(%rsp)
  6d0ae3:	movq   $0x8,0x3f8(%rsp)
  6d0aef:	movups %xmm0,0x400(%rsp)
  6d0af7:	movq   $0x8,0x410(%rsp)
  6d0b03:	movq   $0x0,0x418(%rsp)
  6d0b0f:	movq   $0x1,0x420(%rsp)
  6d0b1b:	mov    $0x1,%edi
  6d0b20:	call   *0x348f7a(%rip)        # a19aa0 <_DYNAMIC+0x480>
  6d0b26:	mov    %rax,%r13
  6d0b29:	cmp    $0x1,%r13d
  6d0b2d:	je     6d0b43 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x103>
  6d0b2f:	movq   $0x0,0x3c0(%rsp)
  6d0b3b:	mov    %r13,0x3c8(%rsp)
  6d0b43:	call   *0x348d1f(%rip)        # a19868 <_DYNAMIC+0x248>
  6d0b49:	mov    $0x28,%edi
  6d0b4e:	mov    $0x8,%esi
  6d0b53:	call   *0x348d17(%rip)        # a19870 <_DYNAMIC+0x250>
  6d0b59:	test   %rax,%rax
  6d0b5c:	je     6d1d64 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1324>
  6d0b62:	mov    %rax,%r15
  6d0b65:	lea    0x3d8(%rsp),%r12
  6d0b6d:	mov    %r13,(%rax)
  6d0b70:	lea    -0x693323(%rip),%rax        # 3d854 <GCC_except_table0+0xf4>
  6d0b77:	mov    %rax,0x8(%r15)
  6d0b7b:	movq   $0x4,0x10(%r15)
  6d0b83:	lea    0x32dd6(%rip),%rax        # 703960 <_RNvYNCNvXCs4gijoeCAvqI_25inspector_pointer_controlNtB7_5ModelNtCs6ZNK6sH19NW_4gpui4View7sources0INtNtNtCs4NRVxsYgnAr_4core3ops8function6FnOnceTRBM_EE9call_onceB7_>
  6d0b8a:	mov    %rax,0x18(%r15)
  6d0b8e:	lea    0x32ddb(%rip),%rax        # 703970 <_RNvYNCNvXCs4gijoeCAvqI_25inspector_pointer_controlNtB7_5ModelNtCs6ZNK6sH19NW_4gpui4View7sourcess_0INtNtNtCs4NRVxsYgnAr_4core3ops8function6FnOnceTQBM_EE9call_onceB7_>
  6d0b95:	mov    %rax,0x20(%r15)
  6d0b99:	mov    %r12,%rdi
  6d0b9c:	call   6dd950 <_RNvMs3_NtCscdodAO9FK5_5alloc7raw_vecINtB5_6RawVecAINtNtCs4NRVxsYgnAr_4core6option6OptionNtNtCs6ZNK6sH19NW_4gpui6source7FieldIdEj2_E8grow_oneCs4gijoeCAvqI_25inspector_pointer_control>
  6d0ba1:	mov    0x3e0(%rsp),%rax
  6d0ba9:	mov    %r15,(%rax)
  6d0bac:	lea    0x3294a5(%rip),%rcx        # 9fa058 <__frame_dummy_init_array_entry+0x208>
  6d0bb3:	mov    %rcx,0x8(%rax)
  6d0bb7:	movq   $0x1,0x3e8(%rsp)
  6d0bc3:	mov    0x3c0(%rsp),%rax
  6d0bcb:	movups 0x40(%r12),%xmm0
  6d0bd1:	movaps %xmm0,0x160(%rsp)
  6d0bd9:	movups (%r12),%xmm0
  6d0bde:	movups 0x10(%r12),%xmm1
  6d0be4:	movups 0x20(%r12),%xmm2
  6d0bea:	movups 0x30(%r12),%xmm3
  6d0bf0:	movaps %xmm3,0x150(%rsp)
  6d0bf8:	movaps %xmm2,0x140(%rsp)
  6d0c00:	movaps %xmm1,0x130(%rsp)
  6d0c08:	movups 0x3c8(%rsp),%xmm2
  6d0c10:	movups %xmm0,0xb8(%rsp)
  6d0c18:	movups %xmm1,0xc8(%rsp)
  6d0c20:	mov    0x140(%rsp),%rcx
  6d0c28:	mov    %rcx,0xd8(%rsp)
  6d0c30:	movups 0x148(%rsp),%xmm0
  6d0c38:	movups %xmm0,0xe0(%rsp)
  6d0c40:	movups 0x158(%rsp),%xmm0
  6d0c48:	movups %xmm0,0xf0(%rsp)
  6d0c50:	mov    0x168(%rsp),%rcx
  6d0c58:	mov    %rcx,0x100(%rsp)
  6d0c60:	mov    %rax,0xa0(%rsp)
  6d0c68:	movups %xmm2,0xa8(%rsp)
  6d0c70:	movl   $0x0,0x120(%rsp)
  6d0c7b:	movl   $0x434b0000,0x128(%rsp)
  6d0c86:	movw   $0x0,0x12c(%rsp)
  6d0c90:	lea    0x3c0(%rsp),%rdi
  6d0c98:	lea    0x120(%rsp),%rcx
  6d0ca0:	mov    $0x2d0,%esi
  6d0ca5:	mov    $0x384,%edx
  6d0caa:	call   *0x348df8(%rip)        # a19aa8 <_DYNAMIC+0x488>
  6d0cb0:	mov    0x3c0(%rsp),%r13
  6d0cb8:	mov    0x3c8(%rsp),%r15d
  6d0cc0:	mov    0x3cc(%rsp),%r12d
  6d0cc8:	cmp    $0x2,%r13
  6d0ccc:	je     6d21af <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x176f>
  6d0cd2:	lea    0x3d0(%rsp),%rsi
  6d0cda:	lea    0xb20(%rsp),%rdi
  6d0ce2:	mov    $0x1d8,%edx
  6d0ce7:	call   *0x348b93(%rip)        # a19880 <memcpy@GLIBC_2.14>
  6d0ced:	mov    %r13,0xb10(%rsp)
  6d0cf5:	mov    %r15d,0xb18(%rsp)
  6d0cfd:	mov    %r12d,0xb1c(%rsp)
  6d0d05:	call   *0x348da5(%rip)        # a19ab0 <_DYNAMIC+0x490>
  6d0d0b:	mov    %rax,%r15
  6d0d0e:	lea    0x120(%rsp),%rdi
  6d0d16:	call   *0x348d9c(%rip)        # a19ab8 <_DYNAMIC+0x498>
  6d0d1c:	movq   $0x6,0x660(%rsp)
  6d0d28:	movl   $0x0,0x668(%rsp)
  6d0d33:	movq   $0x0,0x670(%rsp)
  6d0d3f:	movups 0xa0(%rsp),%xmm0
  6d0d47:	movups 0xb0(%rsp),%xmm1
  6d0d4f:	movups 0xc0(%rsp),%xmm2
  6d0d57:	movups 0xd0(%rsp),%xmm3
  6d0d5f:	movups %xmm0,0x5e8(%rsp)
  6d0d67:	movups %xmm1,0x5f8(%rsp)
  6d0d6f:	movups %xmm2,0x608(%rsp)
  6d0d77:	movups %xmm3,0x618(%rsp)
  6d0d7f:	movups 0xe0(%rsp),%xmm0
  6d0d87:	movups %xmm0,0x628(%rsp)
  6d0d8f:	movups 0xf0(%rsp),%xmm0
  6d0d97:	movups %xmm0,0x638(%rsp)
  6d0d9f:	mov    0x100(%rsp),%rax
  6d0da7:	mov    %rax,0x648(%rsp)
  6d0daf:	lea    0x6a8(%rsp),%rdi
  6d0db7:	lea    0x120(%rsp),%rsi
  6d0dbf:	mov    0x348aba(%rip),%r12        # a19880 <memcpy@GLIBC_2.14>
  6d0dc6:	mov    $0x298,%edx
  6d0dcb:	call   *%r12
  6d0dce:	lea    0x3c0(%rsp),%rdi
  6d0dd6:	lea    0xb10(%rsp),%rsi
  6d0dde:	mov    $0x1e8,%edx
  6d0de3:	call   *%r12
  6d0de6:	movq   $0x6,0x650(%rsp)
  6d0df2:	mov    %rbx,0x658(%rsp)
  6d0dfa:	movq   $0x0,0x678(%rsp)
  6d0e06:	movq   $0x8,0x680(%rsp)
  6d0e12:	xorps  %xmm0,%xmm0
  6d0e15:	movups %xmm0,0x688(%rsp)
  6d0e1d:	movq   $0x8,0x698(%rsp)
  6d0e29:	movq   $0x0,0x6a0(%rsp)
  6d0e35:	movq   $0x0,0x9c0(%rsp)
  6d0e41:	movups %xmm0,0x5a8(%rsp)
  6d0e49:	movups %xmm0,0x5b8(%rsp)
  6d0e51:	movups %xmm0,0x9a8(%rsp)
  6d0e59:	movq   $0x1,0x9c8(%rsp)
  6d0e65:	movq   $0x0,0x9d0(%rsp)
  6d0e71:	mov    %r15,0x998(%rsp)
  6d0e79:	movq   $0x0,0x9e0(%rsp)
  6d0e85:	movq   $0x0,0xa28(%rsp)
  6d0e91:	movups %xmm0,0x9f0(%rsp)
  6d0e99:	movq   $0x0,0xa00(%rsp)
  6d0ea5:	movups %xmm0,0xa10(%rsp)
  6d0ead:	movq   $0x0,0x940(%rsp)
  6d0eb9:	movq   $0x8,0x948(%rsp)
  6d0ec5:	movups %xmm0,0x950(%rsp)
  6d0ecd:	movq   $0x0,0xa30(%rsp)
  6d0ed9:	movq   $0x0,0xa40(%rsp)
  6d0ee5:	movl   $0x1000101,0xb00(%rsp)
  6d0ef0:	movw   $0x0,0xb04(%rsp)
  6d0efa:	movups %xmm0,0xa48(%rsp)
  6d0f02:	movq   $0x0,0xa58(%rsp)
  6d0f0e:	mov    %r14,0xa60(%rsp)
  6d0f16:	movsd  -0x692c2e(%rip),%xmm1        # 3e2f0 <GCC_except_table0+0xb90>
  6d0f1e:	movsd  %xmm1,0xaf8(%rsp)
  6d0f27:	movq   $0x1,0x9a0(%rsp)
  6d0f33:	movq   $0xffffffffffffffff,0x970(%rsp)
  6d0f3f:	movq   $0x0,0xa68(%rsp)
  6d0f4b:	movq   $0x0,0xa78(%rsp)
  6d0f57:	movq   $0x8,0x960(%rsp)
  6d0f63:	movq   $0x0,0x968(%rsp)
  6d0f6f:	movb   $0x0,0xb06(%rsp)
  6d0f77:	movups %xmm0,0xae0(%rsp)
  6d0f7f:	movups %xmm0,0xad0(%rsp)
  6d0f87:	movups %xmm0,0xac0(%rsp)
  6d0f8f:	movups %xmm0,0xab0(%rsp)
  6d0f97:	movups %xmm0,0xaa0(%rsp)
  6d0f9f:	movups %xmm0,0xa90(%rsp)
  6d0fa7:	movups %xmm0,0xa80(%rsp)
  6d0faf:	movq   $0x0,0xaf0(%rsp)
  6d0fbb:	call   *0x3488a7(%rip)        # a19868 <_DYNAMIC+0x248>
  6d0fc1:	mov    $0x748,%edi
  6d0fc6:	mov    $0x8,%esi
  6d0fcb:	call   *0x34889f(%rip)        # a19870 <_DYNAMIC+0x250>
  6d0fd1:	test   %rax,%rax
  6d0fd4:	je     6d1d79 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1339>
  6d0fda:	mov    %rax,%rbx
  6d0fdd:	lea    0x3c0(%rsp),%rsi
  6d0fe5:	mov    $0x748,%edx
  6d0fea:	mov    %rax,%rdi
  6d0fed:	call   *0x34888d(%rip)        # a19880 <memcpy@GLIBC_2.14>
  6d0ff3:	mov    %rbx,0x8(%rsp)
  6d0ff8:	lea    0x10(%rsp),%rdx
  6d0ffd:	movq   $0x0,(%rsp)
  6d1005:	lea    0x68(%rsp),%rdi
  6d100a:	mov    $0x8,%r8d
  6d1010:	mov    %rbx,%rsi
  6d1013:	mov    $0x1,%ecx
  6d1018:	xor    %r9d,%r9d
  6d101b:	call   6d6bf0 <_RNvMNtNtCs6ZNK6sH19NW_4gpui7runtime4turnINtB4_10RuntimeMutNtCs4gijoeCAvqI_25inspector_pointer_control5ModeluE21describe_with_changedBW_>
  6d1020:	mov    0x68(%rsp),%r13
  6d1025:	cmp    $0xfffffffffffffffe,%r13
  6d1029:	jne    6d20d3 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1693>
  6d102f:	lea    0x68(%rsp),%rdi
  6d1034:	mov    %rbx,%rsi
  6d1037:	call   6f8f50 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE7presentBO_>
  6d103c:	mov    0x68(%rsp),%r13
  6d1041:	cmp    $0xfffffffffffffffe,%r13
  6d1045:	jne    6d20d3 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1693>
  6d104b:	mov    0x8(%rsp),%rdi
  6d1050:	mov    %rdi,0x8(%rsp)
  6d1055:	call   6d0940 <_RNvCs4gijoeCAvqI_25inspector_pointer_control3ack>
  6d105a:	mov    0x8(%rsp),%rbx
  6d105f:	test   %rbx,%rbx
  6d1062:	je     6d21e4 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x17a4>
  6d1068:	cmpb   $0x0,0x746(%rbx)
  6d106f:	jne    6d21eb <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x17ab>
  6d1075:	cmpb   $0x1,0x742(%rbx)
  6d107c:	jne    6d21f2 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x17b2>
  6d1082:	mov    0x5a8(%rbx),%r13
  6d1089:	mov    $0x1a,%eax
  6d108e:	mov    %rax,0x10(%rsp)
  6d1093:	test   %r13,%r13
  6d1096:	je     6d21fc <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x17bc>
  6d109c:	mov    0x5a0(%rbx),%rbp
  6d10a3:	shl    $0x6,%r13
  6d10a7:	lea    0x1e8(%rbx),%r14
  6d10ae:	xor    %r12d,%r12d
  6d10b1:	mov    0x348838(%rip),%r15        # a198f0 <_DYNAMIC+0x2d0>
  6d10b8:	jmp    6d10cd <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x68d>
  6d10ba:	nopw   0x0(%rax,%rax,1)
  6d10c0:	add    $0x40,%r12
  6d10c4:	cmp    %r12,%r13
  6d10c7:	je     6d21fc <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x17bc>
  6d10cd:	cmpb   $0x4,0x3d(%rbp,%r12,1)
  6d10d3:	jne    6d10c0 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x680>
  6d10d5:	mov    0x20(%rbp,%r12,1),%rsi
  6d10da:	mov    %r14,%rdi
  6d10dd:	call   *%r15
  6d10e0:	test   %al,%al
  6d10e2:	je     6d10c0 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x680>
  6d10e4:	mov    0x20(%rbp,%r12,1),%rsi
  6d10e9:	add    $0x5d8,%rbx
  6d10f0:	mov    %rbx,%rdi
  6d10f3:	call   *0x348967(%rip)        # a19a60 <_DYNAMIC+0x440>
  6d10f9:	mov    %rax,%r14
  6d10fc:	lea    0x10(%rsp),%rax
  6d1101:	mov    0x8(%rsp),%r15
  6d1106:	test   %r15,%r15
  6d1109:	je     6d2242 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1802>
  6d110f:	mov    %r15,0xa0(%rsp)
  6d1117:	mov    %rax,0xa8(%rsp)
  6d111f:	cmpb   $0x1,0x746(%r15)
  6d1127:	je     6d225f <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x181f>
  6d112d:	cmp    0x5d8(%r15),%r14
  6d1134:	jne    6d2270 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1830>
  6d113a:	mov    %rdx,%rbx
  6d113d:	lea    0x3c0(%rsp),%rdi
  6d1145:	mov    %r15,%rsi
  6d1148:	call   6f8a80 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE16resolve_identityBO_>
  6d114d:	mov    0x3c0(%rsp),%rax
  6d1155:	cmp    $0xfffffffffffffffe,%rax
  6d1159:	jne    6d2277 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1837>
  6d115f:	cmpb   $0x1,0x742(%r15)
  6d1167:	jne    6d20b1 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1671>
  6d116d:	cmpb   $0x0,0x743(%r15)
  6d1175:	jne    6d20b1 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1671>
  6d117b:	cmpb   $0x0,0x744(%r15)
  6d1183:	je     6d20b1 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1671>
  6d1189:	cmpq   $0xffffffffffffffff,0x5b0(%r15)
  6d1191:	jne    6d20b1 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1671>
  6d1197:	mov    0x688(%r15),%rax
  6d119e:	cmp    0x690(%r15),%rax
  6d11a5:	jne    6d20b1 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1671>
  6d11ab:	mov    0x6a0(%r15),%rax
  6d11b2:	cmp    0x698(%r15),%rax
  6d11b9:	jne    6d20b1 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1671>
  6d11bf:	movss  0x738(%r15),%xmm0
  6d11c8:	ucomiss 0x73c(%r15),%xmm0
  6d11d0:	jne    6d20b1 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1671>
  6d11d6:	jp     6d20b1 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1671>
  6d11dc:	mov    0x5a0(%r15),%r12
  6d11e3:	mov    0x5a8(%r15),%rax
  6d11ea:	lea    -0x38(%r12),%rcx
  6d11ef:	shl    $0x6,%rax
  6d11f3:	neg    %rax
  6d11f6:	xor    %ebp,%ebp
  6d11f8:	nopl   0x0(%rax,%rax,1)
  6d1200:	cmp    %rbp,%rax
  6d1203:	je     6d2028 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x15e8>
  6d1209:	add    $0xffffffffffffffc0,%rbp
  6d120d:	lea    0x40(%rcx),%r13
  6d1211:	cmp    %rbx,0x58(%rcx)
  6d1215:	mov    %r13,%rcx
  6d1218:	jne    6d1200 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x7c0>
  6d121a:	mov    0x638(%r15),%rax
  6d1221:	test   %rax,%rax
  6d1224:	je     6d1242 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x802>
  6d1226:	mov    0x100(%rax),%rsi
  6d122d:	test   %rsi,%rsi
  6d1230:	je     6d1242 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x802>
  6d1232:	lea    0x120(%rsp),%rdi
  6d123a:	call   *0x348850(%rip)        # a19a90 <_DYNAMIC+0x470>
  6d1240:	jmp    6d1259 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x819>
  6d1242:	movq   $0x4,0x120(%rsp)
  6d124e:	xorps  %xmm0,%xmm0
  6d1251:	movups %xmm0,0x128(%rsp)
  6d1259:	lea    0x120(%rsp),%rdi
  6d1261:	call   *0x348859(%rip)        # a19ac0 <_DYNAMIC+0x4a0>
  6d1267:	mov    %rdx,%rcx
  6d126a:	sub    %rbp,%r12
  6d126d:	lea    -0x40(%r12),%rsi
  6d1272:	lea    0x3c0(%rsp),%rdi
  6d127a:	mov    %rax,%rdx
  6d127d:	call   *0x348845(%rip)        # a19ac8 <_DYNAMIC+0x4a8>
  6d1283:	cmpb   $0x0,0x3c0(%rsp)
  6d128b:	je     6d12d5 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x895>
  6d128d:	lea    0x3c4(%rsp),%rsi
  6d1295:	movss  0x0(%r13),%xmm0
  6d129b:	movss  0x4(%r13),%xmm1
  6d12a1:	lea    0x68(%rsp),%rdi
  6d12a6:	call   6ce9a0 <_RNCNvMss_NtCs6ZNK6sH19NW_4gpui7runtimeINtB7_3WinNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE5clicks_0BM_>
  6d12ab:	cmpl   $0x1,0x68(%rsp)
  6d12b0:	jne    6d12d5 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x895>
  6d12b2:	movsd  0x6c(%rsp),%xmm0
  6d12b8:	movaps %xmm0,%xmm1
  6d12bb:	shufps $0x55,%xmm0,%xmm1
  6d12bf:	add    $0xffffffffffffffd0,%r12
  6d12c3:	mov    %r12,%rdi
  6d12c6:	movaps %xmm0,0x10(%rsp)
  6d12cb:	call   *0x3487ff(%rip)        # a19ad0 <_DYNAMIC+0x4b0>
  6d12d1:	test   %al,%al
  6d12d3:	jne    6d1312 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x8d2>
  6d12d5:	movss  0x10(%r13),%xmm0
  6d12db:	xorps  %xmm2,%xmm2
  6d12de:	ucomiss %xmm2,%xmm0
  6d12e1:	jne    6d12e9 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x8a9>
  6d12e3:	jnp    6d20c2 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1682>
  6d12e9:	movss  0x14(%r13),%xmm1
  6d12ef:	ucomiss %xmm2,%xmm1
  6d12f2:	jne    6d12fa <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x8ba>
  6d12f4:	jnp    6d20c2 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1682>
  6d12fa:	unpcklps %xmm1,%xmm0
  6d12fd:	mulps  -0x6926c4(%rip),%xmm0        # 3ec40 <GCC_except_table0+0x14e0>
  6d1304:	movsd  0x8(%r13),%xmm1
  6d130a:	addps  %xmm0,%xmm1
  6d130d:	movaps %xmm1,0x10(%rsp)
  6d1312:	movq   $0x19,0x3c0(%rsp)
  6d131e:	lea    0x3c0(%rsp),%rdi
  6d1326:	call   6be410 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueNtNtCs6ZNK6sH19NW_4gpui7runtime5ErrorECs4gijoeCAvqI_25inspector_pointer_control>
  6d132b:	movaps 0x10(%rsp),%xmm0
  6d1330:	movaps %xmm0,%xmm1
  6d1333:	shufps $0x55,%xmm0,%xmm1
  6d1337:	mov    %r15,%rdi
  6d133a:	movaps %xmm1,0x30(%rsp)
  6d133f:	call   6f8d60 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_>
  6d1344:	movq   $0x19,0x3c0(%rsp)
  6d1350:	test   $0x1,%al
  6d1352:	je     6d20c2 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1682>
  6d1358:	mov    %rdx,%r12
  6d135b:	lea    0x3c0(%rsp),%rdi
  6d1363:	call   6be410 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueNtNtCs6ZNK6sH19NW_4gpui7runtime5ErrorECs4gijoeCAvqI_25inspector_pointer_control>
  6d1368:	cmp    %rbx,%r12
  6d136b:	jne    6d20c2 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1682>
  6d1371:	cmp    0x5d8(%r15),%r14
  6d1378:	jne    6d22f4 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x18b4>
  6d137e:	lea    0x3c0(%rsp),%rdi
  6d1386:	mov    %r15,%rsi
  6d1389:	mov    %rbx,%rdx
  6d138c:	call   6f8a80 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE16resolve_identityBO_>
  6d1391:	mov    0x3c0(%rsp),%rax
  6d1399:	mov    0x3c8(%rsp),%r12
  6d13a1:	cmp    $0xfffffffffffffffe,%rax
  6d13a5:	jne    6d22f9 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x18b9>
  6d13ab:	mov    0x2c8(%r15),%rsi
  6d13b2:	cmp    %rsi,%r12
  6d13b5:	jae    6d233e <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x18fe>
  6d13bb:	mov    0x2c0(%r15),%rax
  6d13c2:	lea    (%r12,%r12,4),%rcx
  6d13c6:	mov    0x20(%rax,%rcx,8),%edi
  6d13ca:	call   6e20b0 <_RNvMsh_NtCs6ZNK6sH19NW_4gpui7runtimeNtB5_4Node4kind>
  6d13cf:	cmp    $0x4,%al
  6d13d1:	jne    6d13f8 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x9b8>
  6d13d3:	lea    0x120(%rsp),%rdi
  6d13db:	mov    %r15,%rsi
  6d13de:	mov    %r14,%rdx
  6d13e1:	mov    %rbx,%rcx
  6d13e4:	movaps 0x10(%rsp),%xmm0
  6d13e9:	movaps 0x30(%rsp),%xmm1
  6d13ee:	xor    %r8d,%r8d
  6d13f1:	call   6db9e0 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime7editingINtB7_10RuntimeMutNtCs4gijoeCAvqI_25inspector_pointer_control5ModeluE14select_pointerB12_>
  6d13f6:	jmp    6d144b <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0xa0b>
  6d13f8:	mov    0x610(%r15),%r12
  6d13ff:	mov    0x618(%r15),%r13
  6d1406:	lea    0x3c0(%rsp),%rdi
  6d140e:	mov    %r15,%rsi
  6d1411:	mov    %r14,%rdx
  6d1414:	mov    %rbx,%rcx
  6d1417:	call   6db660 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE5focusBW_>
  6d141c:	mov    0x3c0(%rsp),%rax
  6d1424:	cmp    $0xfffffffffffffffe,%rax
  6d1428:	jne    6d145b <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0xa1b>
  6d142a:	lea    0x120(%rsp),%rdi
  6d1432:	lea    0xa0(%rsp),%rsi
  6d143a:	mov    %r14,%rdx
  6d143d:	mov    %rbx,%rcx
  6d1440:	mov    %r12,%r8
  6d1443:	mov    %r13,%r9
  6d1446:	call   6d3730 <_RNvMNtNtCs6ZNK6sH19NW_4gpui7runtime4turnINtB4_10RuntimeMutNtCs4gijoeCAvqI_25inspector_pointer_control5ModeluE16activate_focusedBW_>
  6d144b:	cmpq   $0xfffffffffffffffe,0x120(%rsp)
  6d1454:	je     6d14cd <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0xa8d>
  6d1456:	jmp    6d2034 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x15f4>
  6d145b:	mov    0x3e8(%rsp),%rcx
  6d1463:	movzbl 0x3f0(%rsp),%edx
  6d146b:	mov    0x3f1(%rsp),%esi
  6d1472:	mov    %esi,0x151(%rsp)
  6d1479:	mov    0x3f4(%rsp),%esi
  6d1480:	mov    %esi,0x154(%rsp)
  6d1487:	movups 0x3c8(%rsp),%xmm0
  6d148f:	movups 0x3d8(%rsp),%xmm1
  6d1497:	mov    %rax,0x120(%rsp)
  6d149f:	movups %xmm0,0x128(%rsp)
  6d14a7:	movups %xmm1,0x138(%rsp)
  6d14af:	mov    %rcx,0x148(%rsp)
  6d14b7:	mov    %dl,0x150(%rsp)
  6d14be:	cmpq   $0xfffffffffffffffe,0x120(%rsp)
  6d14c7:	jne    6d2034 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x15f4>
  6d14cd:	mov    0x8(%rsp),%rdi
  6d14d2:	call   6d0940 <_RNvCs4gijoeCAvqI_25inspector_pointer_control3ack>
  6d14d7:	movsd  -0x6930ef(%rip),%xmm0        # 3e3f0 <GCC_except_table0+0xc90>
  6d14df:	movsd  %xmm0,0x3c0(%rsp)
  6d14e8:	lea    0x3c0(%rsp),%rax
  6d14f0:	mov    0x8(%rsp),%rbp
  6d14f5:	test   %rbp,%rbp
  6d14f8:	je     6d234f <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x190f>
  6d14fe:	cmpb   $0x0,0x746(%rbp)
  6d1505:	jne    6d2356 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1916>
  6d150b:	mov    $0x12,%eax
  6d1510:	cmpb   $0x1,0x742(%rbp)
  6d1517:	jne    6d235b <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x191b>
  6d151d:	cmpb   $0x0,0x743(%rbp)
  6d1524:	jne    6d235b <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x191b>
  6d152a:	cmpb   $0x0,0x744(%rbp)
  6d1531:	je     6d235b <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x191b>
  6d1537:	cmpq   $0xffffffffffffffff,0x5b0(%rbp)
  6d153f:	jne    6d235b <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x191b>
  6d1545:	mov    0x688(%rbp),%rcx
  6d154c:	cmp    0x690(%rbp),%rcx
  6d1553:	jne    6d235b <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x191b>
  6d1559:	mov    0x6a0(%rbp),%rbx
  6d1560:	cmp    0x698(%rbp),%rbx
  6d1567:	jne    6d235b <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x191b>
  6d156d:	movss  0x738(%rbp),%xmm0
  6d1575:	ucomiss 0x73c(%rbp),%xmm0
  6d157c:	jne    6d235b <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x191b>
  6d1582:	jp     6d235b <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x191b>
  6d1588:	movsd  0x3c0(%rsp),%xmm0
  6d1591:	movaps %xmm0,0x40(%rsp)
  6d1596:	mov    0x6c0(%rbp),%rax
  6d159d:	mov    %rax,0x50(%rsp)
  6d15a2:	mov    0x5a0(%rbp),%rax
  6d15a9:	mov    %rax,0x10(%rsp)
  6d15ae:	mov    0x5a8(%rbp),%r12
  6d15b5:	movups 0x610(%rbp),%xmm0
  6d15bc:	movaps %xmm0,0x30(%rsp)
  6d15c1:	mov    0x638(%rbp),%r13
  6d15c8:	test   %r13,%r13
  6d15cb:	je     6d1619 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0xbd9>
  6d15cd:	mov    0xe0(%r13),%rax
  6d15d4:	test   %rax,%rax
  6d15d7:	je     6d1638 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0xbf8>
  6d15d9:	mov    0x38(%rax),%ecx
  6d15dc:	mov    %ecx,0xb20(%rsp)
  6d15e3:	movups 0x28(%rax),%xmm0
  6d15e7:	movaps %xmm0,0xb10(%rsp)
  6d15ef:	movzbl 0x3c(%rax),%r15d
  6d15f4:	movzbl 0x3f(%rax),%ecx
  6d15f8:	mov    %cl,0xa2(%rsp)
  6d15ff:	movzwl 0x3d(%rax),%eax
  6d1603:	mov    %ax,0xa0(%rsp)
  6d160b:	mov    0x100(%r13),%rsi
  6d1612:	test   %rsi,%rsi
  6d1615:	jne    6d1647 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0xc07>
  6d1617:	jmp    6d161c <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0xbdc>
  6d1619:	mov    $0x2,%r15b
  6d161c:	movq   $0x4,0x120(%rsp)
  6d1628:	xorps  %xmm0,%xmm0
  6d162b:	movups %xmm0,0x128(%rsp)
  6d1633:	mov    %r12,%r14
  6d1636:	jmp    6d165c <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0xc1c>
  6d1638:	mov    $0x2,%r15b
  6d163b:	mov    0x100(%r13),%rsi
  6d1642:	test   %rsi,%rsi
  6d1645:	je     6d161c <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0xbdc>
  6d1647:	lea    0x120(%rsp),%rdi
  6d164f:	call   *0x34843b(%rip)        # a19a90 <_DYNAMIC+0x470>
  6d1655:	mov    0x5a8(%rbp),%r14
  6d165c:	lea    0x5d8(%rbp),%rax
  6d1663:	mov    %rax,0x108(%rsp)
  6d166b:	mov    %rax,0x410(%rsp)
  6d1673:	mov    0x50(%rsp),%rax
  6d1678:	mov    %rax,0x3e0(%rsp)
  6d1680:	mov    %rbx,0x3e8(%rsp)
  6d1688:	mov    0x10(%rsp),%rax
  6d168d:	mov    %rax,0x3d0(%rsp)
  6d1695:	mov    %r12,0x3d8(%rsp)
  6d169d:	movaps 0x30(%rsp),%xmm0
  6d16a2:	movaps %xmm0,0x3c0(%rsp)
  6d16aa:	mov    %r13,0x3f0(%rsp)
  6d16b2:	mov    0x120(%rsp),%rax
  6d16ba:	mov    %rax,0x3f8(%rsp)
  6d16c2:	mov    0x128(%rsp),%rax
  6d16ca:	mov    %rax,0x400(%rsp)
  6d16d2:	mov    0x130(%rsp),%rax
  6d16da:	mov    %rax,0x408(%rsp)
  6d16e2:	movaps 0xb10(%rsp),%xmm0
  6d16ea:	movups %xmm0,0x418(%rsp)
  6d16f2:	mov    0xb20(%rsp),%eax
  6d16f9:	mov    %eax,0x428(%rsp)
  6d1700:	mov    %r15b,0x42c(%rsp)
  6d1708:	movzwl 0xa0(%rsp),%eax
  6d1710:	mov    %ax,0x42d(%rsp)
  6d1718:	movzbl 0xa2(%rsp),%eax
  6d1720:	mov    %al,0x42f(%rsp)
  6d1727:	test   %r14,%r14
  6d172a:	je     6d214c <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x170c>
  6d1730:	movaps 0x40(%rsp),%xmm0
  6d1735:	shufps $0x55,%xmm0,%xmm0
  6d1739:	movaps %xmm0,0x50(%rsp)
  6d173e:	mov    $0x20,%r13d
  6d1744:	xor    %r12d,%r12d
  6d1747:	lea    0x3c0(%rsp),%r15
  6d174f:	mov    0x348382(%rip),%rbx        # a19ad8 <_DYNAMIC+0x4b8>
  6d1756:	lea    0x3292cb(%rip),%rax        # 9faa28 <__frame_dummy_init_array_entry+0xbd8>
  6d175d:	mov    %rax,0x60(%rsp)
  6d1762:	movq   $0x0,0x30(%rsp)
  6d176b:	movq   $0x0,0x10(%rsp)
  6d1774:	jmp    6d179c <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0xd5c>
  6d1776:	mov    0x5a0(%rbp),%rax
  6d177d:	incq   0x10(%rsp)
  6d1782:	mov    (%rax,%r13,1),%rax
  6d1786:	mov    %rax,0x30(%rsp)
  6d178b:	nopl   0x0(%rax,%rax,1)
  6d1790:	inc    %r12
  6d1793:	add    $0x40,%r13
  6d1797:	cmp    %r12,%r14
  6d179a:	je     6d17eb <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0xdab>
  6d179c:	mov    %r15,%rdi
  6d179f:	mov    %r12,%rsi
  6d17a2:	call   *%rbx
  6d17a4:	test   %rax,%rax
  6d17a7:	setne  %cl
  6d17aa:	cmp    $0x5,%rdx
  6d17ae:	sete   %dl
  6d17b1:	and    %cl,%dl
  6d17b3:	cmp    $0x1,%dl
  6d17b6:	jne    6d1790 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0xd50>
  6d17b8:	mov    (%rax),%ecx
  6d17ba:	mov    $0x63656863,%edx
  6d17bf:	xor    %edx,%ecx
  6d17c1:	movzbl 0x4(%rax),%eax
  6d17c5:	xor    $0x6b,%eax
  6d17c8:	or     %ecx,%eax
  6d17ca:	jne    6d1790 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0xd50>
  6d17cc:	mov    0x5a8(%rbp),%rsi
  6d17d3:	cmp    %rsi,%r12
  6d17d6:	jb     6d1776 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0xd36>
  6d17d8:	mov    %r12,%rdi
  6d17db:	mov    0x60(%rsp),%rdx
  6d17e0:	call   *0x3480aa(%rip)        # a19890 <_DYNAMIC+0x270>
  6d17e6:	jmp    6d2550 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b10>
  6d17eb:	mov    0x10(%rsp),%rcx
  6d17f0:	cmp    $0x1,%rcx
  6d17f4:	jne    6d213e <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x16fe>
  6d17fa:	mov    0x108(%rsp),%rdi
  6d1802:	mov    0x30(%rsp),%rsi
  6d1807:	call   *0x348253(%rip)        # a19a60 <_DYNAMIC+0x440>
  6d180d:	mov    %rax,%r14
  6d1810:	mov    %rdx,%rbx
  6d1813:	lea    0x8(%rsp),%rax
  6d1818:	mov    %rax,0x3c0(%rsp)
  6d1820:	lea    0x3c0(%rsp),%r12
  6d1828:	mov    0x3c0(%rsp),%rax
  6d1830:	mov    (%rax),%rsi
  6d1833:	lea    0x120(%rsp),%rdi
  6d183b:	movaps 0x40(%rsp),%xmm0
  6d1840:	movaps 0x50(%rsp),%xmm1
  6d1845:	call   6d3580 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8hit_only>
  6d184a:	cmpl   $0xfffffffe,0x120(%rsp)
  6d1852:	jne    6d1d8e <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x134e>
  6d1858:	mov    0x128(%rsp),%rdx
  6d1860:	mov    0x130(%rsp),%rax
  6d1868:	mov    %rdx,0x3c0(%rsp)
  6d1870:	mov    %rax,0x3c8(%rsp)
  6d1878:	mov    %r14,0x110(%rsp)
  6d1880:	mov    %rbx,0x118(%rsp)
  6d1888:	cmp    %r14,%rdx
  6d188b:	sete   %cl
  6d188e:	test   %rdx,%rdx
  6d1891:	je     6d1d04 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x12c4>
  6d1897:	lea    0x328f62(%rip),%rdx        # 9fa800 <__frame_dummy_init_array_entry+0x9b0>
  6d189e:	lea    0x110(%rsp),%r15
  6d18a6:	test   %cl,%cl
  6d18a8:	je     6d1e76 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1436>
  6d18ae:	cmp    %rbx,%rax
  6d18b1:	jne    6d1e76 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1436>
  6d18b7:	movsd  -0x692edf(%rip),%xmm0        # 3e9e0 <GCC_except_table0+0x1280>
  6d18bf:	movsd  %xmm0,0x3c0(%rsp)
  6d18c8:	lea    0x3c0(%rsp),%r12
  6d18d0:	movss  0x3c0(%rsp),%xmm0
  6d18d9:	movss  0x3c4(%rsp),%xmm1
  6d18e2:	mov    0x8(%rsp),%rsi
  6d18e7:	lea    0x120(%rsp),%rdi
  6d18ef:	call   6d3580 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8hit_only>
  6d18f4:	cmpl   $0xfffffffe,0x120(%rsp)
  6d18fc:	jne    6d1dfb <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x13bb>
  6d1902:	movups 0x128(%rsp),%xmm0
  6d190a:	movaps %xmm0,0x3c0(%rsp)
  6d1912:	cmpq   $0x0,0x128(%rsp)
  6d191b:	jne    6d1e68 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1428>
  6d1921:	mov    $0xffffffff,%eax
  6d1926:	mov    %rax,0xb10(%rsp)
  6d192e:	movq   $0x0,0xb18(%rsp)
  6d193a:	movaps 0x40(%rsp),%xmm0
  6d193f:	movlps %xmm0,0x3c4(%rsp)
  6d1947:	movl   $0x0,0x3c0(%rsp)
  6d1952:	lea    0x3c0(%rsp),%rcx
  6d195a:	lea    0x120(%rsp),%rdi
  6d1962:	lea    0x8(%rsp),%rsi
  6d1967:	lea    0xb10(%rsp),%rdx
  6d196f:	call   6d2610 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch>
  6d1974:	cmpl   $0xfffffffe,0x120(%rsp)
  6d197c:	jne    6d1c97 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1257>
  6d1982:	movl   $0x2,0x3c0(%rsp)
  6d198d:	lea    0x3c0(%rsp),%rcx
  6d1995:	lea    0x120(%rsp),%rdi
  6d199d:	lea    0x8(%rsp),%rsi
  6d19a2:	lea    0xb10(%rsp),%rdx
  6d19aa:	call   6d2610 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch>
  6d19af:	cmpl   $0xfffffffe,0x120(%rsp)
  6d19b7:	jne    6d1c97 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1257>
  6d19bd:	movl   $0x3,0x3c0(%rsp)
  6d19c8:	lea    0x3c0(%rsp),%r15
  6d19d0:	lea    0x120(%rsp),%rdi
  6d19d8:	lea    0x8(%rsp),%rsi
  6d19dd:	lea    0xb10(%rsp),%rdx
  6d19e5:	mov    %r15,%rcx
  6d19e8:	call   6d2610 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch>
  6d19ed:	cmpl   $0xfffffffe,0x120(%rsp)
  6d19f5:	jne    6d1c97 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1257>
  6d19fb:	mov    0x8(%rsp),%rsi
  6d1a00:	test   %rsi,%rsi
  6d1a03:	je     6d1e86 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1446>
  6d1a09:	cmpq   $0x1,0x2b0(%rsi)
  6d1a11:	jne    6d1ecb <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x148b>
  6d1a17:	mov    %rsi,%rdi
  6d1a1a:	call   6d0940 <_RNvCs4gijoeCAvqI_25inspector_pointer_control3ack>
  6d1a1f:	mov    0x8(%rsp),%rsi
  6d1a24:	lea    0x120(%rsp),%rdi
  6d1a2c:	movaps 0x40(%rsp),%xmm0
  6d1a31:	movaps 0x50(%rsp),%xmm1
  6d1a36:	call   6d3580 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8hit_only>
  6d1a3b:	cmpl   $0xfffffffe,0x120(%rsp)
  6d1a43:	jne    6d1ee5 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x14a5>
  6d1a49:	mov    0x128(%rsp),%rdx
  6d1a51:	mov    0x130(%rsp),%rax
  6d1a59:	mov    %rdx,0xa0(%rsp)
  6d1a61:	mov    %rax,0xa8(%rsp)
  6d1a69:	mov    %r14,0x3c0(%rsp)
  6d1a71:	mov    %rbx,0x3c8(%rsp)
  6d1a79:	cmp    %r14,%rdx
  6d1a7c:	sete   %cl
  6d1a7f:	test   %rdx,%rdx
  6d1a82:	je     6d1d22 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x12e2>
  6d1a88:	lea    0x328dd1(%rip),%rdx        # 9fa860 <__frame_dummy_init_array_entry+0xa10>
  6d1a8f:	lea    0xa0(%rsp),%r12
  6d1a97:	test   %cl,%cl
  6d1a99:	je     6d1e76 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1436>
  6d1a9f:	cmp    %rbx,%rax
  6d1aa2:	jne    6d1e76 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1436>
  6d1aa8:	movaps 0x40(%rsp),%xmm0
  6d1aad:	movlps %xmm0,0x3c0(%rsp)
  6d1ab5:	lea    0x3c0(%rsp),%rax
  6d1abd:	movss  0x3c0(%rsp),%xmm0
  6d1ac6:	movss  0x3c4(%rsp),%xmm1
  6d1acf:	lea    0x120(%rsp),%rbx
  6d1ad7:	lea    0x8(%rsp),%rsi
  6d1adc:	mov    %rbx,%rdi
  6d1adf:	call   6d0520 <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only>
  6d1ae4:	cmpl   $0xfffffffe,0x120(%rsp)
  6d1aec:	jne    6d1f52 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1512>
  6d1af2:	mov    0x8(%rsp),%rdi
  6d1af7:	call   6d0940 <_RNvCs4gijoeCAvqI_25inspector_pointer_control3ack>
  6d1afc:	mov    0x8(%rsp),%rsi
  6d1b01:	test   %rsi,%rsi
  6d1b04:	je     6d1fbf <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x157f>
  6d1b0a:	cmpq   $0x2,0x2b0(%rsi)
  6d1b12:	jne    6d2004 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x15c4>
  6d1b18:	mov    0xb10(%rsp),%eax
  6d1b1f:	cmp    $0xffffffff,%eax
  6d1b22:	je     6d1b42 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1102>
  6d1b24:	dec    %eax
  6d1b26:	mov    0xb14(%rsp),%ecx
  6d1b2d:	mov    %eax,0x124(%rsp)
  6d1b34:	mov    %ecx,0x128(%rsp)
  6d1b3b:	mov    $0x1,%eax
  6d1b40:	jmp    6d1b44 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1104>
  6d1b42:	xor    %eax,%eax
  6d1b44:	mov    %eax,0x120(%rsp)
  6d1b4b:	movl   $0x42500000,0x3c8(%rsp)
  6d1b56:	movabs $0x4140000000000001,%rcx
  6d1b60:	mov    %rcx,0x3c0(%rsp)
  6d1b68:	movabs $0x4250000041400000,%rcx
  6d1b72:	cmp    %rcx,0x124(%rsp)
  6d1b7a:	sete   %cl
  6d1b7d:	test   %eax,%eax
  6d1b7f:	je     6d1d40 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1300>
  6d1b85:	test   %cl,%cl
  6d1b87:	je     6d1d4a <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x130a>
  6d1b8d:	movaps 0x40(%rsp),%xmm0
  6d1b92:	movss  %xmm0,0xa0(%rsp)
  6d1b9b:	movaps 0x50(%rsp),%xmm0
  6d1ba0:	movss  %xmm0,0x120(%rsp)
  6d1ba9:	lea    0xa0(%rsp),%rax
  6d1bb1:	mov    %rax,0x3c0(%rsp)
  6d1bb9:	mov    0x347f20(%rip),%rax        # a19ae0 <_DYNAMIC+0x4c0>
  6d1bc0:	mov    %rax,0x3c8(%rsp)
  6d1bc8:	mov    %rbx,0x3d0(%rsp)
  6d1bd0:	mov    %rax,0x3d8(%rsp)
  6d1bd8:	lea    -0x692aef(%rip),%rax        # 3f0f0 <GCC_except_table0+0x1990>
  6d1bdf:	mov    %rax,0x3e0(%rsp)
  6d1be7:	mov    0x347efa(%rip),%rcx        # a19ae8 <_DYNAMIC+0x4c8>
  6d1bee:	mov    %rcx,0x3e8(%rsp)
  6d1bf6:	mov    %rax,0x3f0(%rsp)
  6d1bfe:	mov    %rcx,0x3f8(%rsp)
  6d1c06:	lea    -0x692a55(%rip),%rax        # 3f1b8 <GCC_except_table0+0x1a58>
  6d1c0d:	mov    %rax,0x400(%rsp)
  6d1c15:	mov    %rcx,0x408(%rsp)
  6d1c1d:	lea    -0x692c8c(%rip),%rax        # 3ef98 <GCC_except_table0+0x1838>
  6d1c24:	mov    %rax,0x410(%rsp)
  6d1c2c:	mov    %rcx,0x418(%rsp)
  6d1c34:	lea    -0x692993(%rip),%rax        # 3f2a8 <GCC_except_table0+0x1b48>
  6d1c3b:	mov    %rax,0x420(%rsp)
  6d1c43:	mov    %rcx,0x428(%rsp)
  6d1c4b:	lea    -0x68984a(%rip),%rdi        # 48408 <GCC_except_table0+0xaca8>
  6d1c52:	lea    0x3c0(%rsp),%rsi
  6d1c5a:	call   *0x347e90(%rip)        # a19af0 <_DYNAMIC+0x4d0>
  6d1c60:	mov    0x8(%rsp),%rbx
  6d1c65:	test   %rbx,%rbx
  6d1c68:	je     6d1c85 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1245>
  6d1c6a:	mov    %rbx,%rdi
  6d1c6d:	call   6b9800 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtCs6ZNK6sH19NW_4gpui7runtime7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelEEB1h_>
  6d1c72:	mov    $0x748,%esi
  6d1c77:	mov    $0x8,%edx
  6d1c7c:	mov    %rbx,%rdi
  6d1c7f:	call   *0x347bdb(%rip)        # a19860 <_DYNAMIC+0x240>
  6d1c85:	add    $0xcf8,%rsp
  6d1c8c:	pop    %rbx
  6d1c8d:	pop    %r12
  6d1c8f:	pop    %r13
  6d1c91:	pop    %r14
  6d1c93:	pop    %r15
  6d1c95:	pop    %rbp
  6d1c96:	ret
  6d1c97:	mov    0x150(%rsp),%rax
  6d1c9f:	mov    %rax,0x3f0(%rsp)
  6d1ca7:	movups 0x120(%rsp),%xmm0
  6d1caf:	movups 0x130(%rsp),%xmm1
  6d1cb7:	movups 0x140(%rsp),%xmm2
  6d1cbf:	movaps %xmm2,0x3e0(%rsp)
  6d1cc7:	movaps %xmm1,0x3d0(%rsp)
  6d1ccf:	movaps %xmm0,0x3c0(%rsp)
  6d1cd7:	lea    -0x687564(%rip),%rdi        # 4a77a <GCC_except_table0+0xd01a>
  6d1cde:	lea    0x328c53(%rip),%rcx        # 9fa938 <__frame_dummy_init_array_entry+0xae8>
  6d1ce5:	lea    0x328c04(%rip),%r8        # 9fa8f0 <__frame_dummy_init_array_entry+0xaa0>
  6d1cec:	lea    0x3c0(%rsp),%rdx
  6d1cf4:	mov    $0x2b,%esi
  6d1cf9:	call   *0x347c11(%rip)        # a19910 <_DYNAMIC+0x2f0>
  6d1cff:	jmp    6d2550 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b10>
  6d1d04:	xor    %ecx,%ecx
  6d1d06:	lea    0x328af3(%rip),%rdx        # 9fa800 <__frame_dummy_init_array_entry+0x9b0>
  6d1d0d:	lea    0x110(%rsp),%r15
  6d1d15:	test   %cl,%cl
  6d1d17:	jne    6d18ae <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0xe6e>
  6d1d1d:	jmp    6d1e76 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1436>
  6d1d22:	xor    %ecx,%ecx
  6d1d24:	lea    0x328b35(%rip),%rdx        # 9fa860 <__frame_dummy_init_array_entry+0xa10>
  6d1d2b:	lea    0xa0(%rsp),%r12
  6d1d33:	test   %cl,%cl
  6d1d35:	jne    6d1a9f <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x105f>
  6d1d3b:	jmp    6d1e76 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1436>
  6d1d40:	xor    %ecx,%ecx
  6d1d42:	test   %cl,%cl
  6d1d44:	jne    6d1b8d <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x114d>
  6d1d4a:	lea    0x120(%rsp),%rdi
  6d1d52:	lea    0x3c0(%rsp),%rsi
  6d1d5a:	call   6c15db <_RINvNtCs4NRVxsYgnAr_4core9panicking13assert_failedINtNtB4_6option6OptionAmj2_EBM_ECs4gijoeCAvqI_25inspector_pointer_control>
  6d1d5f:	jmp    6d2550 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b10>
  6d1d64:	mov    $0x8,%edi
  6d1d69:	mov    $0x28,%esi
  6d1d6e:	call   *0x347b04(%rip)        # a19878 <_DYNAMIC+0x258>
  6d1d74:	jmp    6d2550 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b10>
  6d1d79:	mov    $0x8,%edi
  6d1d7e:	mov    $0x748,%esi
  6d1d83:	call   *0x347aef(%rip)        # a19878 <_DYNAMIC+0x258>
  6d1d89:	jmp    6d2550 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b10>
  6d1d8e:	mov    0x150(%rsp),%rax
  6d1d96:	mov    %rax,0x3f0(%rsp)
  6d1d9e:	movups 0x120(%rsp),%xmm0
  6d1da6:	movups 0x130(%rsp),%xmm1
  6d1dae:	movups 0x140(%rsp),%xmm2
  6d1db6:	movaps %xmm2,0x3e0(%rsp)
  6d1dbe:	movaps %xmm1,0x3d0(%rsp)
  6d1dc6:	movaps %xmm0,0x3c0(%rsp)
  6d1dce:	lea    -0x68765b(%rip),%rdi        # 4a77a <GCC_except_table0+0xd01a>
  6d1dd5:	lea    0x328b5c(%rip),%rcx        # 9fa938 <__frame_dummy_init_array_entry+0xae8>
  6d1ddc:	lea    0x328a05(%rip),%r8        # 9fa7e8 <__frame_dummy_init_array_entry+0x998>
  6d1de3:	lea    0x3c0(%rsp),%rdx
  6d1deb:	mov    $0x2b,%esi
  6d1df0:	call   *0x347b1a(%rip)        # a19910 <_DYNAMIC+0x2f0>
  6d1df6:	jmp    6d2550 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b10>
  6d1dfb:	mov    0x150(%rsp),%rax
  6d1e03:	mov    %rax,0x3f0(%rsp)
  6d1e0b:	movups 0x120(%rsp),%xmm0
  6d1e13:	movups 0x130(%rsp),%xmm1
  6d1e1b:	movups 0x140(%rsp),%xmm2
  6d1e23:	movaps %xmm2,0x3e0(%rsp)
  6d1e2b:	movaps %xmm1,0x3d0(%rsp)
  6d1e33:	movaps %xmm0,0x3c0(%rsp)
  6d1e3b:	lea    -0x6876c8(%rip),%rdi        # 4a77a <GCC_except_table0+0xd01a>
  6d1e42:	lea    0x328aef(%rip),%rcx        # 9fa938 <__frame_dummy_init_array_entry+0xae8>
  6d1e49:	lea    0x3289c8(%rip),%r8        # 9fa818 <__frame_dummy_init_array_entry+0x9c8>
  6d1e50:	lea    0x3c0(%rsp),%rdx
  6d1e58:	mov    $0x2b,%esi
  6d1e5d:	call   *0x347aad(%rip)        # a19910 <_DYNAMIC+0x2f0>
  6d1e63:	jmp    6d2550 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b10>
  6d1e68:	lea    0x328a99(%rip),%rdx        # 9fa908 <__frame_dummy_init_array_entry+0xab8>
  6d1e6f:	lea    -0x693476(%rip),%r15        # 3ea00 <GCC_except_table0+0x12a0>
  6d1e76:	mov    %r12,%rdi
  6d1e79:	mov    %r15,%rsi
  6d1e7c:	call   6c1613 <_RINvNtCs4NRVxsYgnAr_4core9panicking13assert_failedINtNtB4_6option6OptionNtNtCs6ZNK6sH19NW_4gpui8identity6TargetEBM_ECs4gijoeCAvqI_25inspector_pointer_control>
  6d1e81:	jmp    6d2550 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b10>
  6d1e86:	movq   $0xd,0x3c0(%rsp)
  6d1e92:	movq   $0x0,0x3c8(%rsp)
  6d1e9e:	lea    -0x68772b(%rip),%rdi        # 4a77a <GCC_except_table0+0xd01a>
  6d1ea5:	lea    0x328a8c(%rip),%rcx        # 9fa938 <__frame_dummy_init_array_entry+0xae8>
  6d1eac:	lea    0x32897d(%rip),%r8        # 9fa830 <__frame_dummy_init_array_entry+0x9e0>
  6d1eb3:	lea    0x3c0(%rsp),%rdx
  6d1ebb:	mov    $0x2b,%esi
  6d1ec0:	call   *0x347a4a(%rip)        # a19910 <_DYNAMIC+0x2f0>
  6d1ec6:	jmp    6d2550 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b10>
  6d1ecb:	add    $0x2b0,%rsi
  6d1ed2:	lea    0x3289ff(%rip),%r9        # 9fa8d8 <__frame_dummy_init_array_entry+0xa88>
  6d1ed9:	lea    -0x692e10(%rip),%rdx        # 3f0d0 <GCC_except_table0+0x1970>
  6d1ee0:	jmp    6d2019 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x15d9>
  6d1ee5:	mov    0x150(%rsp),%rax
  6d1eed:	mov    %rax,0x3f0(%rsp)
  6d1ef5:	movups 0x120(%rsp),%xmm0
  6d1efd:	movups 0x130(%rsp),%xmm1
  6d1f05:	movups 0x140(%rsp),%xmm2
  6d1f0d:	movaps %xmm2,0x3e0(%rsp)
  6d1f15:	movaps %xmm1,0x3d0(%rsp)
  6d1f1d:	movaps %xmm0,0x3c0(%rsp)
  6d1f25:	lea    -0x6877b2(%rip),%rdi        # 4a77a <GCC_except_table0+0xd01a>
  6d1f2c:	lea    0x328a05(%rip),%rcx        # 9fa938 <__frame_dummy_init_array_entry+0xae8>
  6d1f33:	lea    0x32890e(%rip),%r8        # 9fa848 <__frame_dummy_init_array_entry+0x9f8>
  6d1f3a:	lea    0x3c0(%rsp),%rdx
  6d1f42:	mov    $0x2b,%esi
  6d1f47:	call   *0x3479c3(%rip)        # a19910 <_DYNAMIC+0x2f0>
  6d1f4d:	jmp    6d2550 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b10>
  6d1f52:	mov    0x150(%rsp),%rax
  6d1f5a:	mov    %rax,0x3f0(%rsp)
  6d1f62:	movups 0x120(%rsp),%xmm0
  6d1f6a:	movups 0x130(%rsp),%xmm1
  6d1f72:	movups 0x140(%rsp),%xmm2
  6d1f7a:	movaps %xmm2,0x3e0(%rsp)
  6d1f82:	movaps %xmm1,0x3d0(%rsp)
  6d1f8a:	movaps %xmm0,0x3c0(%rsp)
  6d1f92:	lea    -0x68781f(%rip),%rdi        # 4a77a <GCC_except_table0+0xd01a>
  6d1f99:	lea    0x328998(%rip),%rcx        # 9fa938 <__frame_dummy_init_array_entry+0xae8>
  6d1fa0:	lea    0x3288d1(%rip),%r8        # 9fa878 <__frame_dummy_init_array_entry+0xa28>
  6d1fa7:	lea    0x3c0(%rsp),%rdx
  6d1faf:	mov    $0x2b,%esi
  6d1fb4:	call   *0x347956(%rip)        # a19910 <_DYNAMIC+0x2f0>
  6d1fba:	jmp    6d2550 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b10>
  6d1fbf:	movq   $0xd,0x3c0(%rsp)
  6d1fcb:	movq   $0x0,0x3c8(%rsp)
  6d1fd7:	lea    -0x687864(%rip),%rdi        # 4a77a <GCC_except_table0+0xd01a>
  6d1fde:	lea    0x328953(%rip),%rcx        # 9fa938 <__frame_dummy_init_array_entry+0xae8>
  6d1fe5:	lea    0x3288a4(%rip),%r8        # 9fa890 <__frame_dummy_init_array_entry+0xa40>
  6d1fec:	lea    0x3c0(%rsp),%rdx
  6d1ff4:	mov    $0x2b,%esi
  6d1ff9:	call   *0x347911(%rip)        # a19910 <_DYNAMIC+0x2f0>
  6d1fff:	jmp    6d2550 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b10>
  6d2004:	add    $0x2b0,%rsi
  6d200b:	lea    0x3288ae(%rip),%r9        # 9fa8c0 <__frame_dummy_init_array_entry+0xa70>
  6d2012:	lea    -0x692e99(%rip),%rdx        # 3f180 <GCC_except_table0+0x1a20>
  6d2019:	xor    %edi,%edi
  6d201b:	xor    %ecx,%ecx
  6d201d:	call   *0x347ad5(%rip)        # a19af8 <_DYNAMIC+0x4d8>
  6d2023:	jmp    6d2550 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b10>
  6d2028:	movq   $0x11,0x120(%rsp)
  6d2034:	mov    0x150(%rsp),%rax
  6d203c:	mov    %rax,0x3f0(%rsp)
  6d2044:	mov    0x120(%rsp),%rax
  6d204c:	mov    0x128(%rsp),%rcx
  6d2054:	movups 0x130(%rsp),%xmm0
  6d205c:	movups 0x140(%rsp),%xmm1
  6d2064:	movaps %xmm1,0x3e0(%rsp)
  6d206c:	movaps %xmm0,0x3d0(%rsp)
  6d2074:	mov    %rax,0x3c0(%rsp)
  6d207c:	mov    %rcx,0x3c8(%rsp)
  6d2084:	lea    -0x687911(%rip),%rdi        # 4a77a <GCC_except_table0+0xd01a>
  6d208b:	lea    0x3288a6(%rip),%rcx        # 9fa938 <__frame_dummy_init_array_entry+0xae8>
  6d2092:	lea    0x32871f(%rip),%r8        # 9fa7b8 <__frame_dummy_init_array_entry+0x968>
  6d2099:	lea    0x3c0(%rsp),%rdx
  6d20a1:	mov    $0x2b,%esi
  6d20a6:	call   *0x347864(%rip)        # a19910 <_DYNAMIC+0x2f0>
  6d20ac:	jmp    6d2550 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b10>
  6d20b1:	movq   $0x12,0x120(%rsp)
  6d20bd:	jmp    6d2034 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x15f4>
  6d20c2:	movq   $0x19,0x120(%rsp)
  6d20ce:	jmp    6d2034 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x15f4>
  6d20d3:	mov    0x70(%rsp),%r15
  6d20d8:	movups 0x78(%rsp),%xmm0
  6d20dd:	movaps %xmm0,0x10(%rsp)
  6d20e2:	movups 0x88(%rsp),%xmm0
  6d20ea:	movaps %xmm0,0x30(%rsp)
  6d20ef:	movzbl 0x98(%rsp),%ebp
  6d20f7:	mov    0x99(%rsp),%eax
  6d20fe:	mov    %eax,0x28(%rsp)
  6d2102:	mov    0x9c(%rsp),%eax
  6d2109:	mov    %eax,0x2b(%rsp)
  6d210d:	mov    0x8(%rsp),%rbx
  6d2112:	test   %rbx,%rbx
  6d2115:	je     6d2132 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x16f2>
  6d2117:	mov    %rbx,%rdi
  6d211a:	call   6b9800 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtCs6ZNK6sH19NW_4gpui7runtime7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelEEB1h_>
  6d211f:	mov    $0x748,%esi
  6d2124:	mov    $0x8,%edx
  6d2129:	mov    %rbx,%rdi
  6d212c:	call   *0x34772e(%rip)        # a19860 <_DYNAMIC+0x240>
  6d2132:	mov    %r15,%r12
  6d2135:	shr    $0x20,%r12
  6d2139:	jmp    6d21d5 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1795>
  6d213e:	mov    $0x1b,%eax
  6d2143:	test   %rcx,%rcx
  6d2146:	jne    6d235b <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x191b>
  6d214c:	mov    $0x1a,%eax
  6d2151:	jmp    6d235b <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x191b>
  6d2156:	mov    $0x1,%edi
  6d215b:	mov    $0x6,%esi
  6d2160:	call   *0x347782(%rip)        # a198e8 <_DYNAMIC+0x2c8>
  6d2166:	mov    0x3c8(%rsp),%r15
  6d216e:	mov    %r15,%r12
  6d2171:	shr    $0x20,%r12
  6d2175:	movups 0x3d0(%rsp),%xmm0
  6d217d:	movaps %xmm0,0x10(%rsp)
  6d2182:	movups 0x3e0(%rsp),%xmm0
  6d218a:	movaps %xmm0,0x30(%rsp)
  6d218f:	movzbl 0x3f0(%rsp),%ebp
  6d2197:	mov    0x3f1(%rsp),%eax
  6d219e:	mov    %eax,0x28(%rsp)
  6d21a2:	mov    0x3f4(%rsp),%eax
  6d21a9:	mov    %eax,0x2b(%rsp)
  6d21ad:	jmp    6d21c2 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1782>
  6d21af:	lea    0xa0(%rsp),%rdi
  6d21b7:	call   6b9650 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtCs6ZNK6sH19NW_4gpui6source7SourcesNtCs4gijoeCAvqI_25inspector_pointer_control5ModelEEB1g_>
  6d21bc:	mov    $0x23,%r13d
  6d21c2:	mov    $0x6,%esi
  6d21c7:	mov    $0x1,%edx
  6d21cc:	mov    %rbx,%rdi
  6d21cf:	call   *0x34768b(%rip)        # a19860 <_DYNAMIC+0x240>
  6d21d5:	movaps 0x10(%rsp),%xmm0
  6d21da:	movaps 0x30(%rsp),%xmm1
  6d21df:	jmp    6d24e0 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1aa0>
  6d21e4:	mov    $0xd,%eax
  6d21e9:	jmp    6d21f7 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x17b7>
  6d21eb:	mov    $0xe,%eax
  6d21f0:	jmp    6d21f7 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x17b7>
  6d21f2:	mov    $0x12,%eax
  6d21f7:	mov    %rax,0x10(%rsp)
  6d21fc:	mov    0x10(%rsp),%rax
  6d2201:	mov    %rax,0x3c0(%rsp)
  6d2209:	movq   $0x0,0x3c8(%rsp)
  6d2215:	lea    -0x687ada(%rip),%rdi        # 4a742 <GCC_except_table0+0xcfe2>
  6d221c:	lea    0x328715(%rip),%rcx        # 9fa938 <__frame_dummy_init_array_entry+0xae8>
  6d2223:	lea    0x328576(%rip),%r8        # 9fa7a0 <__frame_dummy_init_array_entry+0x950>
  6d222a:	lea    0x3c0(%rsp),%rdx
  6d2232:	mov    $0x2a,%esi
  6d2237:	call   *0x3476d3(%rip)        # a19910 <_DYNAMIC+0x2f0>
  6d223d:	jmp    6d2550 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b10>
  6d2242:	movq   $0xd,0x120(%rsp)
  6d224e:	movq   $0x0,0x128(%rsp)
  6d225a:	jmp    6d2034 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x15f4>
  6d225f:	movq   $0xe,0x120(%rsp)
  6d226b:	jmp    6d2034 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x15f4>
  6d2270:	mov    $0x11,%eax
  6d2275:	jmp    6d22af <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x186f>
  6d2277:	mov    0x3c8(%rsp),%rcx
  6d227f:	movups 0x3d0(%rsp),%xmm0
  6d2287:	movaps %xmm0,0xb10(%rsp)
  6d228f:	movups 0x3e0(%rsp),%xmm0
  6d2297:	movaps %xmm0,0xb20(%rsp)
  6d229f:	mov    0x3f0(%rsp),%rdx
  6d22a7:	mov    %rdx,0xb30(%rsp)
  6d22af:	mov    %rax,0x120(%rsp)
  6d22b7:	mov    %rcx,0x128(%rsp)
  6d22bf:	movaps 0xb10(%rsp),%xmm0
  6d22c7:	movaps 0xb20(%rsp),%xmm1
  6d22cf:	movups %xmm0,0x130(%rsp)
  6d22d7:	movups %xmm1,0x140(%rsp)
  6d22df:	mov    0xb30(%rsp),%rax
  6d22e7:	mov    %rax,0x150(%rsp)
  6d22ef:	jmp    6d2034 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x15f4>
  6d22f4:	mov    $0x11,%eax
  6d22f9:	mov    0x3f0(%rsp),%rcx
  6d2301:	mov    %rcx,0x150(%rsp)
  6d2309:	movups 0x3d0(%rsp),%xmm0
  6d2311:	movups 0x3e0(%rsp),%xmm1
  6d2319:	movups %xmm1,0x140(%rsp)
  6d2321:	movups %xmm0,0x130(%rsp)
  6d2329:	mov    %rax,0x120(%rsp)
  6d2331:	mov    %r12,0x128(%rsp)
  6d2339:	jmp    6d2034 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x15f4>
  6d233e:	lea    0x328ceb(%rip),%rax        # 9fb030 <__frame_dummy_init_array_entry+0x11e0>
  6d2345:	mov    %rax,0x60(%rsp)
  6d234a:	jmp    6d17d8 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0xd98>
  6d234f:	mov    $0xd,%eax
  6d2354:	jmp    6d235b <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x191b>
  6d2356:	mov    $0xe,%eax
  6d235b:	mov    %rax,0x3c0(%rsp)
  6d2363:	mov    0x10(%rsp),%rax
  6d2368:	mov    %rax,0x3c8(%rsp)
  6d2370:	lea    -0x687bfd(%rip),%rdi        # 4a77a <GCC_except_table0+0xd01a>
  6d2377:	lea    0x3285ba(%rip),%rcx        # 9fa938 <__frame_dummy_init_array_entry+0xae8>
  6d237e:	lea    0x32844b(%rip),%r8        # 9fa7d0 <__frame_dummy_init_array_entry+0x980>
  6d2385:	lea    0x3c0(%rsp),%rdx
  6d238d:	mov    $0x2b,%esi
  6d2392:	call   *0x347578(%rip)        # a19910 <_DYNAMIC+0x2f0>
  6d2398:	jmp    6d2550 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b10>
  6d239d:	mov    %rax,%r14
  6d23a0:	jmp    6d25db <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b9b>
  6d23a5:	mov    %rax,%r14
  6d23a8:	jmp    6d25db <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b9b>
  6d23ad:	mov    %rax,%r14
  6d23b0:	jmp    6d2414 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x19d4>
  6d23b2:	mov    %rax,%r14
  6d23b5:	lea    0x327c9c(%rip),%rsi        # 9fa058 <__frame_dummy_init_array_entry+0x208>
  6d23bc:	mov    %r15,%rdi
  6d23bf:	call   6baee0 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtCscdodAO9FK5_5alloc5boxed3BoxDG0_INtNtNtB4_3ops8function2FnTQL1_INtNtCs6ZNK6sH19NW_4gpui7element2ElL0_EEEp6OutputuEL_EECs4gijoeCAvqI_25inspector_pointer_control>
  6d23c4:	jmp    6d2486 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1a46>
  6d23c9:	call   *0x3474b9(%rip)        # a19888 <_DYNAMIC+0x268>
  6d23cf:	mov    %rax,%r14
  6d23d2:	lea    0x3c0(%rsp),%rdi
  6d23da:	call   6b9650 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtCs6ZNK6sH19NW_4gpui6source7SourcesNtCs4gijoeCAvqI_25inspector_pointer_control5ModelEEB1g_>
  6d23df:	jmp    6d2493 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1a53>
  6d23e4:	call   *0x34749e(%rip)        # a19888 <_DYNAMIC+0x268>
  6d23ea:	mov    %rax,%r14
  6d23ed:	jmp    6d256d <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b2d>
  6d23f2:	mov    %rax,%r14
  6d23f5:	mov    0x8(%rsp),%rdi
  6d23fa:	call   6b97a0 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtCs6ZNK6sH19NW_4gpui7runtime3WinNtCs4gijoeCAvqI_25inspector_pointer_control5ModelEEB1d_>
  6d23ff:	jmp    6d25cb <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b8b>
  6d2404:	mov    %rax,%r14
  6d2407:	lea    0xb10(%rsp),%rdi
  6d240f:	call   6bf060 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueNtNtCshdpBObOiWw8_11gpui_canvas6canvas6CanvasECs4gijoeCAvqI_25inspector_pointer_control>
  6d2414:	lea    0xa0(%rsp),%rdi
  6d241c:	call   6b9650 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtCs6ZNK6sH19NW_4gpui6source7SourcesNtCs4gijoeCAvqI_25inspector_pointer_control5ModelEEB1g_>
  6d2421:	jmp    6d256d <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b2d>
  6d2426:	jmp    6d25be <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b7e>
  6d242b:	call   *0x347457(%rip)        # a19888 <_DYNAMIC+0x268>
  6d2431:	jmp    6d25ac <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b6c>
  6d2436:	jmp    6d25be <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b7e>
  6d243b:	jmp    6d25be <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b7e>
  6d2440:	jmp    6d25ac <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b6c>
  6d2445:	jmp    6d25ac <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b6c>
  6d244a:	jmp    6d25ac <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b6c>
  6d244f:	jmp    6d25ac <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b6c>
  6d2454:	jmp    6d25ac <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b6c>
  6d2459:	jmp    6d25ac <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b6c>
  6d245e:	jmp    6d25ac <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b6c>
  6d2463:	jmp    6d25ac <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b6c>
  6d2468:	mov    %rax,%r14
  6d246b:	lea    0x3c0(%rsp),%rdi
  6d2473:	call   6b9800 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtCs6ZNK6sH19NW_4gpui7runtime7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelEEB1h_>
  6d2478:	jmp    6d25cb <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b8b>
  6d247d:	call   *0x347405(%rip)        # a19888 <_DYNAMIC+0x268>
  6d2483:	mov    %rax,%r14
  6d2486:	lea    0x3c0(%rsp),%rdi
  6d248e:	call   6b9650 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtCs6ZNK6sH19NW_4gpui6source7SourcesNtCs4gijoeCAvqI_25inspector_pointer_control5ModelEEB1g_>
  6d2493:	mov    %r14,%rdi
  6d2496:	call   *0x347664(%rip)        # a19b00 <_DYNAMIC+0x4e0>
  6d249c:	mov    %rax,%r15
  6d249f:	mov    %rdx,%r12
  6d24a2:	mov    (%rdx),%rax
  6d24a5:	test   %rax,%rax
  6d24a8:	je     6d24af <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1a6f>
  6d24aa:	mov    %r15,%rdi
  6d24ad:	call   *%rax
  6d24af:	mov    0x8(%r12),%rsi
  6d24b4:	test   %rsi,%rsi
  6d24b7:	je     6d24c7 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1a87>
  6d24b9:	mov    0x10(%r12),%rdx
  6d24be:	mov    %r15,%rdi
  6d24c1:	call   *0x347399(%rip)        # a19860 <_DYNAMIC+0x240>
  6d24c7:	mov    $0x6,%esi
  6d24cc:	mov    $0x1,%edx
  6d24d1:	mov    %rbx,%rdi
  6d24d4:	call   *0x347386(%rip)        # a19860 <_DYNAMIC+0x240>
  6d24da:	mov    $0xf,%r13d
  6d24e0:	mov    %r13,0x120(%rsp)
  6d24e8:	shl    $0x20,%r12
  6d24ec:	mov    %r15d,%eax
  6d24ef:	or     %r12,%rax
  6d24f2:	mov    %rax,0x128(%rsp)
  6d24fa:	movups %xmm0,0x130(%rsp)
  6d2502:	movups %xmm1,0x140(%rsp)
  6d250a:	mov    %bpl,0x150(%rsp)
  6d2512:	mov    0x28(%rsp),%eax
  6d2516:	mov    0x2b(%rsp),%ecx
  6d251a:	mov    %eax,0x151(%rsp)
  6d2521:	mov    %ecx,0x154(%rsp)
  6d2528:	lea    -0x687db5(%rip),%rdi        # 4a77a <GCC_except_table0+0xd01a>
  6d252f:	lea    0x328402(%rip),%rcx        # 9fa938 <__frame_dummy_init_array_entry+0xae8>
  6d2536:	lea    0x32824b(%rip),%r8        # 9fa788 <__frame_dummy_init_array_entry+0x938>
  6d253d:	lea    0x120(%rsp),%rdx
  6d2545:	mov    $0x2b,%esi
  6d254a:	call   *0x3473c0(%rip)        # a19910 <_DYNAMIC+0x2f0>
  6d2550:	ud2
  6d2552:	mov    %rax,%r14
  6d2555:	mov    0x8(%r12),%rsi
  6d255a:	test   %rsi,%rsi
  6d255d:	je     6d256d <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b2d>
  6d255f:	mov    0x10(%r12),%rdx
  6d2564:	mov    %r15,%rdi
  6d2567:	call   *0x3472f3(%rip)        # a19860 <_DYNAMIC+0x240>
  6d256d:	mov    $0x6,%esi
  6d2572:	mov    $0x1,%edx
  6d2577:	mov    %rbx,%rdi
  6d257a:	call   *0x3472e0(%rip)        # a19860 <_DYNAMIC+0x240>
  6d2580:	mov    %r14,%rdi
  6d2583:	call   9f8aa0 <_Unwind_Resume@plt>
  6d2588:	mov    %rax,%r14
  6d258b:	lea    0x120(%rsp),%rdi
  6d2593:	call   6be410 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueNtNtCs6ZNK6sH19NW_4gpui7runtime5ErrorECs4gijoeCAvqI_25inspector_pointer_control>
  6d2598:	mov    %r14,%rdi
  6d259b:	call   9f8aa0 <_Unwind_Resume@plt>
  6d25a0:	call   *0x347562(%rip)        # a19b08 <_DYNAMIC+0x4e8>
  6d25a6:	call   *0x3472dc(%rip)        # a19888 <_DYNAMIC+0x268>
  6d25ac:	mov    %rax,%r14
  6d25af:	lea    0x3c0(%rsp),%rdi
  6d25b7:	call   6be410 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueNtNtCs6ZNK6sH19NW_4gpui7runtime5ErrorECs4gijoeCAvqI_25inspector_pointer_control>
  6d25bc:	jmp    6d25c1 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b81>
  6d25be:	mov    %rax,%r14
  6d25c1:	mov    0x8(%rsp),%rbx
  6d25c6:	test   %rbx,%rbx
  6d25c9:	jne    6d25d3 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b93>
  6d25cb:	mov    %r14,%rdi
  6d25ce:	call   9f8aa0 <_Unwind_Resume@plt>
  6d25d3:	mov    %rbx,%rdi
  6d25d6:	call   6b9800 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtCs6ZNK6sH19NW_4gpui7runtime7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelEEB1h_>
  6d25db:	mov    $0x748,%esi
  6d25e0:	mov    $0x8,%edx
  6d25e5:	mov    %rbx,%rdi
  6d25e8:	call   *0x347272(%rip)        # a19860 <_DYNAMIC+0x240>
  6d25ee:	mov    %r14,%rdi
  6d25f1:	call   9f8aa0 <_Unwind_Resume@plt>
  6d25f6:	mov    $0x748,%esi
  6d25fb:	mov    $0x8,%edx
  6d2600:	mov    %rbx,%rdi
  6d2603:	call   *0x347257(%rip)        # a19860 <_DYNAMIC+0x240>
  6d2609:	call   *0x347279(%rip)        # a19888 <_DYNAMIC+0x268>

/tmp/gpui-inspector-pointer-codegen-inline/candidate-frozen:     file format elf64-x86-64


Disassembly of section .text:

00000000006d2610 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch>:
  6d2610:	push   %rbp
  6d2611:	push   %r15
  6d2613:	push   %r14
  6d2615:	push   %r13
  6d2617:	push   %r12
  6d2619:	push   %rbx
  6d261a:	sub    $0x178,%rsp
  6d2621:	mov    %rdx,%r14
  6d2624:	mov    %rdi,%rbx
  6d2627:	mov    (%rcx),%ebp
  6d2629:	test   %ebp,%ebp
  6d262b:	je     6d2660 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x50>
  6d262d:	mov    0x8(%r14),%r12
  6d2631:	mov    0x10(%r14),%r13
  6d2635:	mov    0x18(%r14),%rax
  6d2639:	movq   $0x0,0x8(%r14)
  6d2641:	lea    -0x1(%rbp),%edx
  6d2644:	lea    -0x6932db(%rip),%rdi        # 3f370 <GCC_except_table0+0x1c10>
  6d264b:	movslq (%rdi,%rdx,4),%rdx
  6d264f:	add    %rdi,%rdx
  6d2652:	jmp    *%rdx
  6d2654:	movl   $0xffffffff,(%r14)
  6d265b:	jmp    6d2821 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x211>
  6d2660:	movd   0x4(%rcx),%xmm1
  6d2665:	movd   0x8(%rcx),%xmm0
  6d266a:	movd   %xmm1,%eax
  6d266e:	movd   %xmm0,%ecx
  6d2672:	mov    %eax,%edx
  6d2674:	and    $0x7fffffff,%edx
  6d267a:	cmp    $0x7f800000,%edx
  6d2680:	setge  %dl
  6d2683:	and    $0x7fffffff,%ecx
  6d2689:	cmp    $0x7f800000,%ecx
  6d268f:	setge  %cl
  6d2692:	or     %dl,%cl
  6d2694:	je     6d26ad <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x9d>
  6d2696:	movl   $0xffffffff,(%r14)
  6d269d:	movq   $0x0,0x8(%r14)
  6d26a5:	xor    %r12d,%r12d
  6d26a8:	jmp    6d2821 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x211>
  6d26ad:	inc    %eax
  6d26af:	je     6d3112 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xb02>
  6d26b5:	mov    %eax,(%r14)
  6d26b8:	movd   %xmm0,0x4(%r14)
  6d26be:	xor    %r12d,%r12d
  6d26c1:	jmp    6d2821 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x211>
  6d26c6:	mov    (%r14),%r15d
  6d26c9:	cmp    $0xffffffff,%r15d
  6d26cd:	je     6d2821 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x211>
  6d26d3:	mov    %rsi,%r13
  6d26d6:	movups 0x8(%rcx),%xmm0
  6d26da:	movss  0x4(%r14),%xmm1
  6d26e0:	movss  %xmm1,0xb0(%rsp)
  6d26e9:	movaps %xmm0,%xmm1
  6d26ec:	unpckhpd %xmm0,%xmm1
  6d26f0:	mov    %rsp,%rdi
  6d26f3:	movaps %xmm0,0x40(%rsp)
  6d26f8:	call   *0x347412(%rip)        # a19b10 <_DYNAMIC+0x4f0>
  6d26fe:	cmpl   $0xfffffffe,(%rsp)
  6d2702:	jne    6d2aa9 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x499>
  6d2708:	mov    0x0(%r13),%r14
  6d270c:	test   %r14,%r14
  6d270f:	je     6d2853 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x243>
  6d2715:	cmpb   $0x1,0x746(%r14)
  6d271d:	je     6d2847 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x237>
  6d2723:	cmpb   $0x1,0x742(%r14)
  6d272b:	jne    6d2c11 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x601>
  6d2731:	cmpb   $0x0,0x743(%r14)
  6d2739:	jne    6d2c11 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x601>
  6d273f:	cmpb   $0x0,0x744(%r14)
  6d2747:	je     6d2c11 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x601>
  6d274d:	cmpq   $0xffffffffffffffff,0x5b0(%r14)
  6d2755:	jne    6d2c11 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x601>
  6d275b:	mov    0x688(%r14),%rax
  6d2762:	cmp    0x690(%r14),%rax
  6d2769:	jne    6d2c11 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x601>
  6d276f:	mov    0x698(%r14),%rax
  6d2776:	cmp    %rax,0x6a0(%r14)
  6d277d:	jne    6d2c11 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x601>
  6d2783:	movss  0x738(%r14),%xmm0
  6d278c:	ucomiss 0x73c(%r14),%xmm0
  6d2794:	jne    6d2c11 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x601>
  6d279a:	jp     6d2c11 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x601>
  6d27a0:	mov    %eax,%ecx
  6d27a2:	cvtsi2ss %rcx,%xmm2
  6d27a7:	dec    %r15d
  6d27aa:	shr    $0x20,%rax
  6d27ae:	mov    %eax,%eax
  6d27b0:	xorps  %xmm1,%xmm1
  6d27b3:	cvtsi2ss %rax,%xmm1
  6d27b8:	movd   %r15d,%xmm0
  6d27bd:	movq   $0x0,(%rsp)
  6d27c5:	movss  %xmm2,0x8(%rsp)
  6d27cb:	movss  %xmm1,0xc(%rsp)
  6d27d1:	mov    %rsp,%rdi
  6d27d4:	movd   %xmm0,0x38(%rsp)
  6d27da:	movss  0xb0(%rsp),%xmm1
  6d27e3:	call   *0x3472e7(%rip)        # a19ad0 <_DYNAMIC+0x4b0>
  6d27e9:	test   %al,%al
  6d27eb:	je     6d3106 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xaf6>
  6d27f1:	mov    0x638(%r14),%rax
  6d27f8:	test   %rax,%rax
  6d27fb:	je     6d2fc6 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x9b6>
  6d2801:	mov    0x100(%rax),%rsi
  6d2808:	test   %rsi,%rsi
  6d280b:	je     6d2fc6 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x9b6>
  6d2811:	lea    0x70(%rsp),%rdi
  6d2816:	call   *0x347274(%rip)        # a19a90 <_DYNAMIC+0x470>
  6d281c:	jmp    6d2fd9 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x9c9>
  6d2821:	mov    (%rsi),%r15
  6d2824:	test   %r15,%r15
  6d2827:	je     6d2853 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x243>
  6d2829:	add    $0x8,%rsi
  6d282d:	mov    %r15,0x100(%rsp)
  6d2835:	mov    %rsi,0x108(%rsp)
  6d283d:	cmpb   $0x1,0x746(%r15)
  6d2845:	jne    6d2867 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x257>
  6d2847:	movq   $0xe,(%rbx)
  6d284e:	jmp    6d2cc7 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x6b7>
  6d2853:	movq   $0xd,(%rbx)
  6d285a:	movq   $0x0,0x8(%rbx)
  6d2862:	jmp    6d2cc7 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x6b7>
  6d2867:	movq   $0x0,0x730(%r15)
  6d2872:	cmp    $0x3,%ebp
  6d2875:	je     6d2a55 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x445>
  6d287b:	cmp    $0x2,%ebp
  6d287e:	je     6d2993 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x383>
  6d2884:	test   %ebp,%ebp
  6d2886:	jne    6d2c6e <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x65e>
  6d288c:	mov    0x638(%r15),%rax
  6d2893:	test   %rax,%rax
  6d2896:	je     6d28ae <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x29e>
  6d2898:	mov    0xd8(%rax),%rax
  6d289f:	test   %rax,%rax
  6d28a2:	je     6d28ae <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x29e>
  6d28a4:	cmpb   $0x0,0x12(%rax)
  6d28a8:	jne    6d2c6e <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x65e>
  6d28ae:	mov    0x8(%r14),%r12
  6d28b2:	test   %r12,%r12
  6d28b5:	je     6d2c6e <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x65e>
  6d28bb:	cmp    0x5d8(%r15),%r12
  6d28c2:	jne    6d2c66 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x656>
  6d28c8:	mov    0x10(%r14),%r13
  6d28cc:	lea    0x70(%rsp),%rdi
  6d28d1:	mov    %r15,%rsi
  6d28d4:	mov    %r13,%rdx
  6d28d7:	call   6f8a80 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE16resolve_identityBO_>
  6d28dc:	mov    0x70(%rsp),%rax
  6d28e1:	cmp    $0xfffffffffffffffe,%rax
  6d28e5:	jne    6d2c1d <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x60d>
  6d28eb:	mov    0x78(%rsp),%rdi
  6d28f0:	mov    0x2c8(%r15),%rsi
  6d28f7:	cmp    %rsi,%rdi
  6d28fa:	jae    6d3518 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xf08>
  6d2900:	mov    0x2c0(%r15),%rax
  6d2907:	lea    (%rdi,%rdi,4),%rcx
  6d290b:	mov    0x20(%rax,%rcx,8),%edi
  6d290f:	call   6e20b0 <_RNvMsh_NtCs6ZNK6sH19NW_4gpui7runtimeNtB5_4Node4kind>
  6d2914:	cmp    $0x4,%al
  6d2916:	jne    6d2cd9 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x6c9>
  6d291c:	mov    (%r14),%eax
  6d291f:	cmp    $0xffffffff,%eax
  6d2922:	je     6d3527 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xf17>
  6d2928:	movd   0x4(%r14),%xmm1
  6d292e:	dec    %eax
  6d2930:	movd   %eax,%xmm0
  6d2934:	mov    %rsp,%rdi
  6d2937:	mov    %r15,%rsi
  6d293a:	mov    %r12,%rdx
  6d293d:	mov    %r13,%rcx
  6d2940:	mov    $0x1,%r8d
  6d2946:	call   6db9e0 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime7editingINtB7_10RuntimeMutNtCs4gijoeCAvqI_25inspector_pointer_control5ModeluE14select_pointerB12_>
  6d294b:	mov    (%rsp),%rax
  6d294f:	cmp    $0xfffffffffffffffe,%rax
  6d2953:	je     6d2962 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x352>
  6d2955:	cmp    $0x11,%eax
  6d2958:	jne    6d2962 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x352>
  6d295a:	movq   $0x0,0x8(%r14)
  6d2962:	mov    0x30(%rsp),%rax
  6d2967:	mov    %rax,0x30(%rbx)
  6d296b:	movups (%rsp),%xmm0
  6d296f:	movups 0x10(%rsp),%xmm1
  6d2974:	movups 0x20(%rsp),%xmm2
  6d2979:	movups %xmm2,0x20(%rbx)
  6d297d:	movups %xmm1,0x10(%rbx)
  6d2981:	movups %xmm0,(%rbx)
  6d2984:	lea    0x70(%rsp),%rdi
  6d2989:	call   6b9290 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtB4_6result6ResultNtNtCs6ZNK6sH19NW_4gpui7runtime6CommitNtBZ_5ErrorEECs4gijoeCAvqI_25inspector_pointer_control>
  6d298e:	jmp    6d2cc7 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x6b7>
  6d2993:	test   %r12,%r12
  6d2996:	sete   %cl
  6d2999:	cmpb   $0x1,0x742(%r15)
  6d29a1:	jne    6d2c11 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x601>
  6d29a7:	cmpb   $0x0,0x743(%r15)
  6d29af:	jne    6d2c11 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x601>
  6d29b5:	cmpb   $0x0,0x744(%r15)
  6d29bd:	je     6d2c11 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x601>
  6d29c3:	cmpq   $0xffffffffffffffff,0x5b0(%r15)
  6d29cb:	jne    6d2c11 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x601>
  6d29d1:	mov    0x688(%r15),%rax
  6d29d8:	cmp    0x690(%r15),%rax
  6d29df:	jne    6d2c11 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x601>
  6d29e5:	mov    0x6a0(%r15),%rax
  6d29ec:	cmp    0x698(%r15),%rax
  6d29f3:	jne    6d2c11 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x601>
  6d29f9:	movss  0x738(%r15),%xmm0
  6d2a02:	ucomiss 0x73c(%r15),%xmm0
  6d2a0a:	jne    6d2c11 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x601>
  6d2a10:	jp     6d2c11 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x601>
  6d2a16:	mov    %ecx,0x40(%rsp)
  6d2a1a:	mov    %rsp,%rdi
  6d2a1d:	mov    %r15,%rsi
  6d2a20:	call   6e71a0 <_RNvMsm_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19presented_hit_sheetBO_>
  6d2a25:	mov    (%r14),%eax
  6d2a28:	cmp    $0xffffffff,%eax
  6d2a2b:	mov    %rax,0xb0(%rsp)
  6d2a33:	je     6d2ce5 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x6d5>
  6d2a39:	movss  0x4(%r14),%xmm0
  6d2a3f:	dec    %eax
  6d2a41:	mov    %eax,0x74(%rsp)
  6d2a45:	movss  %xmm0,0x78(%rsp)
  6d2a4b:	mov    $0x1,%eax
  6d2a50:	jmp    6d2ce7 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x6d7>
  6d2a55:	test   %r12,%r12
  6d2a58:	je     6d2c6e <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x65e>
  6d2a5e:	mov    %r12,0x110(%rsp)
  6d2a66:	mov    %r13,0x118(%rsp)
  6d2a6e:	mov    %rax,0x120(%rsp)
  6d2a76:	mov    (%r14),%ecx
  6d2a79:	cmp    $0xffffffff,%ecx
  6d2a7c:	mov    %rcx,0xb0(%rsp)
  6d2a84:	je     6d2ad0 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x4c0>
  6d2a86:	movss  0x4(%r14),%xmm0
  6d2a8c:	dec    %ecx
  6d2a8e:	mov    %ecx,0x68(%rsp)
  6d2a92:	movss  %xmm0,0x38(%rsp)
  6d2a98:	movss  %xmm0,0x6c(%rsp)
  6d2a9e:	mov    %ecx,0x58(%rsp)
  6d2aa2:	mov    $0x1,%ecx
  6d2aa7:	jmp    6d2ad2 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x4c2>
  6d2aa9:	mov    0x30(%rsp),%rax
  6d2aae:	mov    %rax,0x30(%rbx)
  6d2ab2:	movups (%rsp),%xmm0
  6d2ab6:	movups 0x10(%rsp),%xmm1
  6d2abb:	movups 0x20(%rsp),%xmm2
  6d2ac0:	movups %xmm2,0x20(%rbx)
  6d2ac4:	movups %xmm1,0x10(%rbx)
  6d2ac8:	movups %xmm0,(%rbx)
  6d2acb:	jmp    6d2cc7 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x6b7>
  6d2ad0:	xor    %ecx,%ecx
  6d2ad2:	mov    %ecx,0x40(%rsp)
  6d2ad6:	mov    %ecx,0x64(%rsp)
  6d2ada:	movzbl 0x743(%r15),%ecx
  6d2ae2:	xor    $0x1,%cl
  6d2ae5:	and    0x742(%r15),%cl
  6d2aec:	and    0x744(%r15),%cl
  6d2af3:	mov    0x5b0(%r15),%rdx
  6d2afa:	cmp    $0xffffffffffffffff,%rdx
  6d2afe:	sete   %sil
  6d2b02:	and    %cl,%sil
  6d2b05:	cmp    $0x1,%sil
  6d2b09:	jne    6d2bce <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x5be>
  6d2b0f:	mov    0x688(%r15),%rax
  6d2b16:	cmp    0x690(%r15),%rax
  6d2b1d:	jne    6d2c11 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x601>
  6d2b23:	mov    0x6a0(%r15),%rdx
  6d2b2a:	cmp    0x698(%r15),%rdx
  6d2b31:	jne    6d2c11 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x601>
  6d2b37:	movss  0x738(%r15),%xmm0
  6d2b40:	ucomiss 0x73c(%r15),%xmm0
  6d2b48:	jne    6d2c11 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x601>
  6d2b4e:	jp     6d2c11 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x601>
  6d2b54:	mov    0x5a0(%r15),%rcx
  6d2b5b:	mov    0x5a8(%r15),%r8
  6d2b62:	mov    0x638(%r15),%rdi
  6d2b69:	test   %rdi,%rdi
  6d2b6c:	je     6d2ecd <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x8bd>
  6d2b72:	mov    0x100(%rdi),%rsi
  6d2b79:	test   %rsi,%rsi
  6d2b7c:	je     6d2ee2 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x8d2>
  6d2b82:	mov    %rdi,0x58(%rsp)
  6d2b87:	lea    0x70(%rsp),%rdi
  6d2b8c:	mov    %rdx,0x38(%rsp)
  6d2b91:	mov    %rcx,0xf8(%rsp)
  6d2b99:	mov    %r8,0xf0(%rsp)
  6d2ba1:	call   *0x346ee9(%rip)        # a19a90 <_DYNAMIC+0x470>
  6d2ba7:	mov    0xf0(%rsp),%r8
  6d2baf:	mov    0xf8(%rsp),%rcx
  6d2bb7:	mov    0x58(%rsp),%rdi
  6d2bbc:	mov    0x38(%rsp),%rdx
  6d2bc1:	mov    0x64(%rsp),%eax
  6d2bc5:	mov    %eax,0x40(%rsp)
  6d2bc9:	jmp    6d2ef3 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x8e3>
  6d2bce:	cmp    $0xffffffffffffffff,%rdx
  6d2bd2:	sete   %dl
  6d2bd5:	movq   $0x12,0x140(%rsp)
  6d2be1:	xor    $0x1,%cl
  6d2be4:	or     %dl,%cl
  6d2be6:	jne    6d2c11 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x601>
  6d2be8:	mov    0x6a0(%r15),%rcx
  6d2bef:	cmp    0x698(%r15),%rcx
  6d2bf6:	jne    6d2c11 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x601>
  6d2bf8:	movss  0x738(%r15),%xmm0
  6d2c01:	ucomiss 0x73c(%r15),%xmm0
  6d2c09:	jne    6d2c11 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x601>
  6d2c0b:	jnp    6d2d17 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x707>
  6d2c11:	movq   $0x12,(%rbx)
  6d2c18:	jmp    6d2cc7 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x6b7>
  6d2c1d:	cmp    $0xd,%rax
  6d2c21:	jl     6d2c43 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x633>
  6d2c23:	cmp    $0x21,%rax
  6d2c27:	je     6d2c43 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x633>
  6d2c29:	cmp    $0x26,%rax
  6d2c2d:	jne    6d2c66 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x656>
  6d2c2f:	mov    0x78(%rsp),%rsi
  6d2c34:	test   %rsi,%rsi
  6d2c37:	je     6d2c66 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x656>
  6d2c39:	lea    0x80(%rsp),%rax
  6d2c41:	jmp    6d2c58 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x648>
  6d2c43:	mov    0x88(%rsp),%rsi
  6d2c4b:	test   %rsi,%rsi
  6d2c4e:	je     6d2c66 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x656>
  6d2c50:	lea    0x90(%rsp),%rax
  6d2c58:	mov    (%rax),%rdi
  6d2c5b:	mov    $0x1,%edx
  6d2c60:	call   *0x346bfa(%rip)        # a19860 <_DYNAMIC+0x240>
  6d2c66:	movq   $0x0,0x8(%r14)
  6d2c6e:	movups 0x688(%r15),%xmm0
  6d2c76:	movzbl 0x744(%r15),%eax
  6d2c7e:	cmpq   $0x0,0x6a8(%r15)
  6d2c86:	je     6d2c96 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x686>
  6d2c88:	test   %al,%al
  6d2c8a:	je     6d2c9a <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x68a>
  6d2c8c:	cmpq   $0xffffffffffffffff,0x5b0(%r15)
  6d2c94:	jne    6d2c9a <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x68a>
  6d2c96:	xor    %ecx,%ecx
  6d2c98:	jmp    6d2ca6 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x696>
  6d2c9a:	mov    0x6b8(%r15),%rdx
  6d2ca1:	mov    $0x1,%ecx
  6d2ca6:	mov    0x730(%r15),%rsi
  6d2cad:	mov    %rcx,0x8(%rbx)
  6d2cb1:	mov    %rdx,0x10(%rbx)
  6d2cb5:	movups %xmm0,0x18(%rbx)
  6d2cb9:	mov    %rsi,0x28(%rbx)
  6d2cbd:	mov    %al,0x30(%rbx)
  6d2cc0:	movq   $0xfffffffffffffffe,(%rbx)
  6d2cc7:	add    $0x178,%rsp
  6d2cce:	pop    %rbx
  6d2ccf:	pop    %r12
  6d2cd1:	pop    %r13
  6d2cd3:	pop    %r14
  6d2cd5:	pop    %r15
  6d2cd7:	pop    %rbp
  6d2cd8:	ret
  6d2cd9:	lea    0x70(%rsp),%rdi
  6d2cde:	call   6b9290 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtB4_6result6ResultNtNtCs6ZNK6sH19NW_4gpui7runtime6CommitNtBZ_5ErrorEECs4gijoeCAvqI_25inspector_pointer_control>
  6d2ce3:	jmp    6d2c6e <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x65e>
  6d2ce5:	xor    %eax,%eax
  6d2ce7:	mov    %eax,0x70(%rsp)
  6d2ceb:	mov    %rsp,%rsi
  6d2cee:	lea    0x70(%rsp),%rdx
  6d2cf3:	mov    %r15,%rdi
  6d2cf6:	call   6db530 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE11pointer_hitBW_>
  6d2cfb:	mov    %rdx,%r8
  6d2cfe:	mov    0x40(%rsp),%edx
  6d2d02:	mov    0x638(%r15),%rcx
  6d2d09:	test   %rcx,%rcx
  6d2d0c:	jne    6d2fad <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x99d>
  6d2d12:	jmp    6d31a3 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xb93>
  6d2d17:	mov    0x690(%r15),%rcx
  6d2d1e:	cmp    $0xffffffffffffffff,%rcx
  6d2d22:	je     6d2c11 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x601>
  6d2d28:	inc    %rcx
  6d2d2b:	mov    0x688(%r15),%rdx
  6d2d32:	cmp    %rdx,%rcx
  6d2d35:	jne    6d2c11 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x601>
  6d2d3b:	cmp    %rdx,0x6b8(%r15)
  6d2d42:	jne    6d2c11 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x601>
  6d2d48:	test   %rax,%rax
  6d2d4b:	je     6d2c11 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x601>
  6d2d51:	cmpq   $0x0,0x6a8(%r15)
  6d2d59:	je     6d2c11 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x601>
  6d2d5f:	cmp    %rax,0x6b0(%r15)
  6d2d66:	jne    6d2c11 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x601>
  6d2d6c:	cmp    0x5d8(%r15),%r12
  6d2d73:	jne    6d2c11 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x601>
  6d2d79:	lea    0xb8(%rsp),%rdi
  6d2d81:	mov    %r15,%rsi
  6d2d84:	call   6e71a0 <_RNvMsm_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19presented_hit_sheetBO_>
  6d2d89:	mov    0x638(%r15),%rax
  6d2d90:	test   %rax,%rax
  6d2d93:	je     6d312b <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xb1b>
  6d2d99:	cmpq   $0x0,0xd8(%rax)
  6d2da1:	je     6d312b <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xb1b>
  6d2da7:	cmpl   $0x0,0x40(%rsp)
  6d2dac:	je     6d34ce <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xebe>
  6d2db2:	lea    0xb8(%rsp),%rdi
  6d2dba:	movss  0x58(%rsp),%xmm0
  6d2dc0:	movd   0x38(%rsp),%xmm1
  6d2dc6:	call   *0x346c8c(%rip)        # a19a58 <_DYNAMIC+0x438>
  6d2dcc:	mov    %al,0x40(%rsp)
  6d2dd0:	mov    0xe8(%rsp),%rax
  6d2dd8:	mov    %rax,0x30(%rsp)
  6d2ddd:	movups 0xb8(%rsp),%xmm0
  6d2de5:	movdqu 0xc8(%rsp),%xmm1
  6d2dee:	movups 0xd8(%rsp),%xmm2
  6d2df6:	movaps %xmm2,0x20(%rsp)
  6d2dfb:	movdqa %xmm1,0x10(%rsp)
  6d2e01:	movaps %xmm0,(%rsp)
  6d2e05:	mov    %rsp,%rsi
  6d2e08:	lea    0x64(%rsp),%rdx
  6d2e0d:	mov    %r15,%rdi
  6d2e10:	call   6db530 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE11pointer_hitBW_>
  6d2e15:	cmp    %r12,%rax
  6d2e18:	sete   %al
  6d2e1b:	movzbl 0x40(%rsp),%ecx
  6d2e20:	and    %al,%cl
  6d2e22:	cmp    $0x1,%cl
  6d2e25:	jne    6d2c11 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x601>
  6d2e2b:	cmp    %r13,%rdx
  6d2e2e:	jne    6d2c11 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x601>
  6d2e34:	lea    0x70(%rsp),%rdi
  6d2e39:	mov    %r15,%rsi
  6d2e3c:	call   6e70d0 <_RNvMsm_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19candidate_hit_sheetBO_>
  6d2e41:	lea    0x64(%rsp),%rax
  6d2e46:	mov    %rax,0x128(%rsp)
  6d2e4e:	mov    %r15,0x130(%rsp)
  6d2e56:	lea    0x110(%rsp),%rax
  6d2e5e:	mov    %rax,0x138(%rsp)
  6d2e66:	cmpb   $0x2,0xa0(%rsp)
  6d2e6e:	je     6d2c11 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x601>
  6d2e74:	mov    0xa0(%rsp),%rax
  6d2e7c:	mov    %rax,0x30(%rsp)
  6d2e81:	movups 0x70(%rsp),%xmm0
  6d2e86:	movdqu 0x80(%rsp),%xmm1
  6d2e8f:	movups 0x90(%rsp),%xmm2
  6d2e97:	movaps %xmm2,0x20(%rsp)
  6d2e9c:	movdqa %xmm1,0x10(%rsp)
  6d2ea2:	movaps %xmm0,(%rsp)
  6d2ea6:	lea    0x128(%rsp),%rdi
  6d2eae:	mov    %rsp,%rsi
  6d2eb1:	call   6ce8a0 <_RNCNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB9_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19pointer_release_hits0_0BY_>
  6d2eb6:	test   %al,%al
  6d2eb8:	jne    6d2c11 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x601>
  6d2ebe:	mov    %r12,0x40(%rsp)
  6d2ec3:	mov    %r13,0x38(%rsp)
  6d2ec8:	jmp    6d317a <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xb6a>
  6d2ecd:	movq   $0x4,0x70(%rsp)
  6d2ed6:	xorps  %xmm0,%xmm0
  6d2ed9:	movups %xmm0,0x78(%rsp)
  6d2ede:	xor    %eax,%eax
  6d2ee0:	jmp    6d2efa <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x8ea>
  6d2ee2:	movq   $0x4,0x70(%rsp)
  6d2eeb:	xorps  %xmm0,%xmm0
  6d2eee:	movups %xmm0,0x78(%rsp)
  6d2ef3:	cmpq   $0x0,(%rdi)
  6d2ef7:	setne  %al
  6d2efa:	mov    %rcx,(%rsp)
  6d2efe:	mov    %r8,0x8(%rsp)
  6d2f03:	mov    0x70(%rsp),%rcx
  6d2f08:	mov    %rcx,0x10(%rsp)
  6d2f0d:	mov    0x78(%rsp),%rcx
  6d2f12:	mov    %rcx,0x18(%rsp)
  6d2f17:	mov    0x80(%rsp),%rcx
  6d2f1f:	mov    %rcx,0x20(%rsp)
  6d2f24:	mov    %rdx,0x28(%rsp)
  6d2f29:	mov    %al,0x30(%rsp)
  6d2f2d:	cmpl   $0x0,0x40(%rsp)
  6d2f32:	je     6d2f99 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x989>
  6d2f34:	movss  0x68(%rsp),%xmm0
  6d2f3a:	movd   0x6c(%rsp),%xmm1
  6d2f40:	test   %rdi,%rdi
  6d2f43:	je     6d2f64 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x954>
  6d2f45:	mov    0xd8(%rdi),%rax
  6d2f4c:	test   %rax,%rax
  6d2f4f:	je     6d2f64 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x954>
  6d2f51:	cmpb   $0x0,0x12(%rax)
  6d2f55:	je     6d2f64 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x954>
  6d2f57:	mov    %rsp,%rsi
  6d2f5a:	mov    %r15,%rdi
  6d2f5d:	call   6dd730 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE23inspector_pick_in_sheetB10_>
  6d2f62:	jmp    6d2f83 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x973>
  6d2f64:	mov    %rsp,%rsi
  6d2f67:	mov    %r15,%rdi
  6d2f6a:	call   6e7ae0 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE12hit_in_sheetBO_>
  6d2f6f:	test   $0x1,%al
  6d2f71:	je     6d2f99 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x989>
  6d2f73:	lea    0x5d8(%r15),%rdi
  6d2f7a:	mov    %rdx,%rsi
  6d2f7d:	call   *0x346add(%rip)        # a19a60 <_DYNAMIC+0x440>
  6d2f83:	mov    %rdx,%r8
  6d2f86:	xor    %edx,%edx
  6d2f88:	mov    0x638(%r15),%rcx
  6d2f8f:	test   %rcx,%rcx
  6d2f92:	jne    6d2fad <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x99d>
  6d2f94:	jmp    6d31a3 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xb93>
  6d2f99:	xor    %eax,%eax
  6d2f9b:	xor    %edx,%edx
  6d2f9d:	mov    0x638(%r15),%rcx
  6d2fa4:	test   %rcx,%rcx
  6d2fa7:	je     6d31a3 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xb93>
  6d2fad:	mov    0xd8(%rcx),%rcx
  6d2fb4:	test   %rcx,%rcx
  6d2fb7:	je     6d31a3 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xb93>
  6d2fbd:	movzbl 0x12(%rcx),%edi
  6d2fc1:	jmp    6d31a5 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xb95>
  6d2fc6:	movq   $0x4,0x70(%rsp)
  6d2fcf:	pxor   %xmm0,%xmm0
  6d2fd3:	movdqu %xmm0,0x78(%rsp)
  6d2fd9:	mov    0x5a8(%r14),%rax
  6d2fe0:	mov    %rax,0x58(%rsp)
  6d2fe5:	test   %rax,%rax
  6d2fe8:	je     6d3106 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xaf6>
  6d2fee:	mov    0x5a0(%r14),%rbp
  6d2ff5:	mov    0x58(%rsp),%rax
  6d2ffa:	mov    %rax,%r15
  6d2ffd:	shl    $0x6,%r15
  6d3001:	lea    -0x1(%rax),%r12
  6d3005:	jmp    6d3067 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xa57>
  6d3007:	mov    0x80(%rsp),%rax
  6d300f:	mov    %rax,0x10(%rsp)
  6d3014:	movups 0x70(%rsp),%xmm0
  6d3019:	movaps %xmm0,(%rsp)
  6d301d:	mov    0x638(%r14),%rax
  6d3024:	test   %rax,%rax
  6d3027:	je     6d3094 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xa84>
  6d3029:	cmpq   $0x0,(%rax)
  6d302d:	setne  %al
  6d3030:	movzbl %al,%ecx
  6d3033:	mov    %rbp,%rdi
  6d3036:	mov    0x58(%rsp),%rsi
  6d303b:	mov    %rsp,%rdx
  6d303e:	mov    %r12,%r8
  6d3041:	movd   0x38(%rsp),%xmm0
  6d3047:	movss  0xb0(%rsp),%xmm1
  6d3050:	call   *0x346ac2(%rip)        # a19b18 <_DYNAMIC+0x4f8>
  6d3056:	test   %al,%al
  6d3058:	jne    6d3098 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xa88>
  6d305a:	dec    %r12
  6d305d:	add    $0xffffffffffffffc0,%r15
  6d3061:	je     6d3106 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xaf6>
  6d3067:	cmpb   $0x0,-0x2(%rbp,%r15,1)
  6d306d:	jne    6d3007 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x9f7>
  6d306f:	movzbl -0x3(%rbp,%r15,1),%eax
  6d3075:	sub    $0x2,%al
  6d3077:	movzbl %al,%eax
  6d307a:	mov    $0x8,%ecx
  6d307f:	cmovb  %ecx,%eax
  6d3082:	cmp    $0x7,%al
  6d3084:	je     6d3007 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x9f7>
  6d3086:	movzbl %al,%eax
  6d3089:	cmp    $0x4,%eax
  6d308c:	je     6d3007 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x9f7>
  6d3092:	jmp    6d305a <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xa4a>
  6d3094:	xor    %eax,%eax
  6d3096:	jmp    6d3030 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xa20>
  6d3098:	movq   $0x19,(%rsp)
  6d30a0:	mov    %rsp,%rdi
  6d30a3:	call   6be410 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueNtNtCs6ZNK6sH19NW_4gpui7runtime5ErrorECs4gijoeCAvqI_25inspector_pointer_control>
  6d30a8:	mov    %r12,0xc0(%rsp)
  6d30b0:	movq   $0x1,0xb8(%rsp)
  6d30bc:	lea    0xb8(%rsp),%rdi
  6d30c4:	mov    %r14,%rsi
  6d30c7:	mov    %r14,%rdx
  6d30ca:	call   6ce0f0 <_RINvYINtNtNtNtCs4NRVxsYgnAr_4core4iter7sources7from_fn6FromFnNCNvMs6_NtNtCs6ZNK6sH19NW_4gpui7runtime6scrollINtB17_3WinNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE12scroll_at_2ds0_0ENtNtNtBa_6traits8iterator8Iterator8try_folduNCINvNvB2Z_3any5checkjNCBZ_s1_0E0INtNtNtBc_3ops12control_flow11ControlFlowuEEB1U_>
  6d30cf:	test   %al,%al
  6d30d1:	je     6d3106 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xaf6>
  6d30d3:	movq   $0x1,0x8(%rsp)
  6d30dc:	mov    %r12,0x10(%rsp)
  6d30e1:	movaps 0x40(%rsp),%xmm0
  6d30e6:	movups %xmm0,0x18(%rsp)
  6d30eb:	movq   $0x3,(%rsp)
  6d30f3:	mov    %rsp,%rdx
  6d30f6:	mov    %rbx,%rdi
  6d30f9:	mov    %r13,%rsi
  6d30fc:	call   6e1110 <_RNvMs6_NtNtCs6ZNK6sH19NW_4gpui7runtime6scrollINtB7_3WinNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE17apply_scroll_planBT_>
  6d3101:	jmp    6d2cc7 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x6b7>
  6d3106:	movq   $0x19,(%rbx)
  6d310d:	jmp    6d2cc7 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x6b7>
  6d3112:	lea    -0x685f50(%rip),%rdi        # 4d1c9 <GCC_except_table0+0xfa69>
  6d3119:	lea    0x327bc8(%rip),%rdx        # 9face8 <__frame_dummy_init_array_entry+0xe98>
  6d3120:	mov    $0x22,%esi
  6d3125:	call   *0x3468dd(%rip)        # a19a08 <_DYNAMIC+0x3e8>
  6d312b:	mov    0xe8(%rsp),%rax
  6d3133:	mov    %rax,0x30(%rsp)
  6d3138:	movups 0xb8(%rsp),%xmm0
  6d3140:	movdqu 0xc8(%rsp),%xmm1
  6d3149:	movups 0xd8(%rsp),%xmm2
  6d3151:	movaps %xmm2,0x20(%rsp)
  6d3156:	movdqa %xmm1,0x10(%rsp)
  6d315c:	movaps %xmm0,(%rsp)
  6d3160:	mov    %rsp,%rsi
  6d3163:	lea    0x64(%rsp),%rdx
  6d3168:	mov    %r15,%rdi
  6d316b:	call   6db530 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE11pointer_hitBW_>
  6d3170:	mov    %rax,0x40(%rsp)
  6d3175:	mov    %rdx,0x38(%rsp)
  6d317a:	lea    0x140(%rsp),%rdi
  6d3182:	call   6be410 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueNtNtCs6ZNK6sH19NW_4gpui7runtime5ErrorECs4gijoeCAvqI_25inspector_pointer_control>
  6d3187:	mov    0x40(%rsp),%rax
  6d318c:	mov    0x38(%rsp),%r8
  6d3191:	xor    %edx,%edx
  6d3193:	mov    0x638(%r15),%rcx
  6d319a:	test   %rcx,%rcx
  6d319d:	jne    6d2fad <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x99d>
  6d31a3:	xor    %edi,%edi
  6d31a5:	cmp    $0x2,%ebp
  6d31a8:	jne    6d328a <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xc7a>
  6d31ae:	mov    0x610(%r15),%rdx
  6d31b5:	mov    0x618(%r15),%rcx
  6d31bc:	test   %rax,%rax
  6d31bf:	sete   %sil
  6d31c3:	or     %dil,%sil
  6d31c6:	test   $0x1,%sil
  6d31ca:	je     6d32cc <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xcbc>
  6d31d0:	mov    %r8,%r12
  6d31d3:	mov    %rax,%rbp
  6d31d6:	movq   $0x0,0x610(%r15)
  6d31e1:	mov    %rsp,%rdi
  6d31e4:	mov    %r15,%rsi
  6d31e7:	call   6dc000 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime7editingINtB7_10RuntimeMutNtCs4gijoeCAvqI_25inspector_pointer_control5ModeluE20publish_focus_changeB12_>
  6d31ec:	mov    (%rsp),%rax
  6d31f0:	movups 0x8(%rsp),%xmm0
  6d31f5:	movaps %xmm0,0x70(%rsp)
  6d31fa:	movups 0x18(%rsp),%xmm0
  6d31ff:	movaps %xmm0,0x80(%rsp)
  6d3207:	movups 0x28(%rsp),%xmm0
  6d320c:	movaps %xmm0,0x90(%rsp)
  6d3214:	cmp    $0xfffffffffffffffe,%rax
  6d3218:	jne    6d33bb <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xdab>
  6d321e:	movaps 0x70(%rsp),%xmm0
  6d3223:	movaps 0x80(%rsp),%xmm1
  6d322b:	movaps 0x90(%rsp),%xmm2
  6d3233:	movaps %xmm2,0x20(%rsp)
  6d3238:	movaps %xmm1,0x10(%rsp)
  6d323d:	movaps %xmm0,(%rsp)
  6d3241:	cmpq   $0xffffffffffffffff,0x5b0(%r15)
  6d3249:	je     6d3410 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xe00>
  6d324f:	mov    0x690(%r15),%rax
  6d3256:	cmp    $0xffffffffffffffff,%rax
  6d325a:	je     6d3410 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xe00>
  6d3260:	inc    %rax
  6d3263:	cmp    0x688(%r15),%rax
  6d326a:	jne    6d3410 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xe00>
  6d3270:	cmpq   $0x0,0x6a8(%r15)
  6d3278:	je     6d3410 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xe00>
  6d327e:	mov    0x6b0(%r15),%rax
  6d3285:	jmp    6d3412 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xe02>
  6d328a:	test   %dl,%dl
  6d328c:	jne    6d2c6e <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x65e>
  6d3292:	test   %rax,%rax
  6d3295:	je     6d2c6e <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x65e>
  6d329b:	cmp    %rax,%r12
  6d329e:	jne    6d2c6e <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x65e>
  6d32a4:	cmp    %r8,%r13
  6d32a7:	jne    6d2c6e <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x65e>
  6d32ad:	test   %dil,%dil
  6d32b0:	je     6d343f <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xe2f>
  6d32b6:	mov    %rbx,%rdi
  6d32b9:	mov    %r15,%rsi
  6d32bc:	mov    %r12,%rdx
  6d32bf:	mov    %r13,%rcx
  6d32c2:	call   6df7f0 <_RNvMs4_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_10RuntimeMutNtCs4gijoeCAvqI_25inspector_pointer_control5ModeluE16inspector_selectB14_>
  6d32c7:	jmp    6d2cc7 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x6b7>
  6d32cc:	cmp    0x5d8(%r15),%rax
  6d32d3:	jne    6d33e4 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xdd4>
  6d32d9:	mov    %rax,%rbp
  6d32dc:	mov    %rcx,0x40(%rsp)
  6d32e1:	mov    %rdx,%r13
  6d32e4:	mov    %rsp,%rdi
  6d32e7:	mov    %r15,%rsi
  6d32ea:	mov    %r8,%r12
  6d32ed:	mov    %r8,%rdx
  6d32f0:	call   6f8a80 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE16resolve_identityBO_>
  6d32f5:	mov    (%rsp),%rax
  6d32f9:	mov    0x8(%rsp),%rdi
  6d32fe:	cmp    $0xfffffffffffffffe,%rax
  6d3302:	jne    6d33e9 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xdd9>
  6d3308:	mov    0x2c8(%r15),%rsi
  6d330f:	cmp    %rsi,%rdi
  6d3312:	jae    6d3536 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xf26>
  6d3318:	mov    0x2c0(%r15),%rax
  6d331f:	lea    (%rdi,%rdi,4),%rcx
  6d3323:	mov    0x20(%rax,%rcx,8),%edi
  6d3327:	call   6e20b0 <_RNvMsh_NtCs6ZNK6sH19NW_4gpui7runtimeNtB5_4Node4kind>
  6d332c:	cmp    $0x4,%al
  6d332e:	jne    6d3465 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xe55>
  6d3334:	mov    0xb0(%rsp),%rax
  6d333c:	cmp    $0xffffffff,%eax
  6d333f:	je     6d3543 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xf33>
  6d3345:	movss  0x4(%r14),%xmm1
  6d334b:	dec    %eax
  6d334d:	movd   %eax,%xmm0
  6d3351:	mov    %rsp,%rdi
  6d3354:	mov    %r15,%rsi
  6d3357:	mov    %rbp,%rdx
  6d335a:	mov    %r12,%rcx
  6d335d:	xor    %r8d,%r8d
  6d3360:	call   6db9e0 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime7editingINtB7_10RuntimeMutNtCs4gijoeCAvqI_25inspector_pointer_control5ModeluE14select_pointerB12_>
  6d3365:	mov    (%rsp),%rax
  6d3369:	movups 0x28(%rsp),%xmm0
  6d336e:	movaps %xmm0,0x90(%rsp)
  6d3376:	movdqu 0x18(%rsp),%xmm1
  6d337c:	movdqa %xmm1,0x80(%rsp)
  6d3385:	movups 0x8(%rsp),%xmm2
  6d338a:	movaps %xmm2,0x70(%rsp)
  6d338f:	movups %xmm0,0x28(%rbx)
  6d3393:	movdqu %xmm1,0x18(%rbx)
  6d3398:	movups %xmm2,0x8(%rbx)
  6d339c:	cmp    $0xfffffffffffffffe,%rax
  6d33a0:	jne    6d34c6 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xeb6>
  6d33a6:	mov    %rbp,0x8(%r14)
  6d33aa:	mov    %r12,0x10(%r14)
  6d33ae:	movq   $0x0,0x18(%r14)
  6d33b6:	jmp    6d2cc0 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x6b0>
  6d33bb:	movaps 0x70(%rsp),%xmm0
  6d33c0:	movaps 0x80(%rsp),%xmm1
  6d33c8:	movaps 0x90(%rsp),%xmm2
  6d33d0:	movups %xmm2,0x28(%rbx)
  6d33d4:	movups %xmm1,0x18(%rbx)
  6d33d8:	movups %xmm0,0x8(%rbx)
  6d33dc:	mov    %rax,(%rbx)
  6d33df:	jmp    6d2cc7 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x6b7>
  6d33e4:	mov    $0x11,%eax
  6d33e9:	mov    0x30(%rsp),%rcx
  6d33ee:	mov    %rcx,0x30(%rbx)
  6d33f2:	movups 0x10(%rsp),%xmm0
  6d33f7:	movups 0x20(%rsp),%xmm1
  6d33fc:	movups %xmm1,0x20(%rbx)
  6d3400:	movups %xmm0,0x10(%rbx)
  6d3404:	mov    %rax,(%rbx)
  6d3407:	mov    %rdi,0x8(%rbx)
  6d340b:	jmp    6d2cc7 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x6b7>
  6d3410:	xor    %eax,%eax
  6d3412:	mov    %rbp,0x8(%r14)
  6d3416:	mov    %r12,0x10(%r14)
  6d341a:	mov    %rax,0x18(%r14)
  6d341e:	movaps (%rsp),%xmm0
  6d3422:	movdqa 0x10(%rsp),%xmm1
  6d3428:	movaps 0x20(%rsp),%xmm2
  6d342d:	movups %xmm2,0x28(%rbx)
  6d3431:	movdqu %xmm1,0x18(%rbx)
  6d3436:	movups %xmm0,0x8(%rbx)
  6d343a:	jmp    6d2cc0 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x6b0>
  6d343f:	movq   $0x0,(%rsp)
  6d3447:	lea    0x100(%rsp),%rsi
  6d344f:	mov    %rsp,%r8
  6d3452:	mov    %rbx,%rdi
  6d3455:	mov    %r12,%rdx
  6d3458:	mov    %r13,%rcx
  6d345b:	call   6d67c0 <_RNvMNtNtCs6ZNK6sH19NW_4gpui7runtime4turnINtB4_10RuntimeMutNtCs4gijoeCAvqI_25inspector_pointer_control5ModeluE21activate_with_editingBW_>
  6d3460:	jmp    6d2cc7 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x6b7>
  6d3465:	mov    %rsp,%rdi
  6d3468:	mov    %r15,%rsi
  6d346b:	mov    %rbp,%rdx
  6d346e:	mov    %r12,%rcx
  6d3471:	call   6db660 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE5focusBW_>
  6d3476:	mov    (%rsp),%rax
  6d347a:	cmp    $0xfffffffffffffffe,%rax
  6d347e:	jne    6d348d <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xe7d>
  6d3480:	mov    %r13,%rdx
  6d3483:	mov    0x40(%rsp),%rcx
  6d3488:	jmp    6d31e1 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xbd1>
  6d348d:	mov    0x28(%rsp),%rcx
  6d3492:	movzbl 0x30(%rsp),%edx
  6d3497:	mov    0x34(%rsp),%esi
  6d349b:	mov    %esi,0x34(%rbx)
  6d349e:	mov    0x31(%rsp),%esi
  6d34a2:	mov    %esi,0x31(%rbx)
  6d34a5:	movups 0x8(%rsp),%xmm0
  6d34aa:	movups 0x18(%rsp),%xmm1
  6d34af:	mov    %rax,(%rbx)
  6d34b2:	movups %xmm0,0x8(%rbx)
  6d34b6:	movups %xmm1,0x18(%rbx)
  6d34ba:	mov    %rcx,0x28(%rbx)
  6d34be:	mov    %dl,0x30(%rbx)
  6d34c1:	jmp    6d2cc7 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x6b7>
  6d34c6:	mov    %rax,(%rbx)
  6d34c9:	jmp    6d2cc7 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x6b7>
  6d34ce:	mov    0xe8(%rsp),%rax
  6d34d6:	mov    %rax,0x30(%rsp)
  6d34db:	movups 0xb8(%rsp),%xmm0
  6d34e3:	movdqu 0xc8(%rsp),%xmm1
  6d34ec:	movups 0xd8(%rsp),%xmm2
  6d34f4:	movaps %xmm2,0x20(%rsp)
  6d34f9:	movdqa %xmm1,0x10(%rsp)
  6d34ff:	movaps %xmm0,(%rsp)
  6d3503:	mov    %rsp,%rsi
  6d3506:	lea    0x64(%rsp),%rdx
  6d350b:	mov    %r15,%rdi
  6d350e:	call   6db530 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE11pointer_hitBW_>
  6d3513:	jmp    6d2c11 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x601>
  6d3518:	lea    0x3277e1(%rip),%rdx        # 9fad00 <__frame_dummy_init_array_entry+0xeb0>
  6d351f:	call   *0x34636b(%rip)        # a19890 <_DYNAMIC+0x270>
  6d3525:	jmp    6d3534 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xf24>
  6d3527:	lea    0x3277ea(%rip),%rdi        # 9fad18 <__frame_dummy_init_array_entry+0xec8>
  6d352e:	call   *0x3463c4(%rip)        # a198f8 <_DYNAMIC+0x2d8>
  6d3534:	ud2
  6d3536:	lea    0x3277f3(%rip),%rdx        # 9fad30 <__frame_dummy_init_array_entry+0xee0>
  6d353d:	call   *0x34634d(%rip)        # a19890 <_DYNAMIC+0x270>
  6d3543:	lea    0x3277fe(%rip),%rdi        # 9fad48 <__frame_dummy_init_array_entry+0xef8>
  6d354a:	call   *0x3463a8(%rip)        # a198f8 <_DYNAMIC+0x2d8>
  6d3550:	mov    %rax,%rbx
  6d3553:	lea    0x140(%rsp),%rdi
  6d355b:	call   6be410 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueNtNtCs6ZNK6sH19NW_4gpui7runtime5ErrorECs4gijoeCAvqI_25inspector_pointer_control>
  6d3560:	mov    %rbx,%rdi
  6d3563:	call   9f8aa0 <_Unwind_Resume@plt>
  6d3568:	mov    %rax,%rbx
  6d356b:	lea    0x70(%rsp),%rdi
  6d3570:	call   6b9290 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtB4_6result6ResultNtNtCs6ZNK6sH19NW_4gpui7runtime6CommitNtBZ_5ErrorEECs4gijoeCAvqI_25inspector_pointer_control>
  6d3575:	mov    %rbx,%rdi
  6d3578:	call   9f8aa0 <_Unwind_Resume@plt>

/tmp/gpui-inspector-pointer-codegen-inline/candidate-frozen:     file format elf64-x86-64


Disassembly of section .text:

00000000006d3580 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8hit_only>:
  6d3580:	test   %rsi,%rsi
  6d3583:	je     6d3596 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8hit_only+0x16>
  6d3585:	cmpb   $0x0,0x746(%rsi)
  6d358c:	je     6d35a6 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8hit_only+0x26>
  6d358e:	movq   $0xe,(%rdi)
  6d3595:	ret
  6d3596:	movq   $0xd,(%rdi)
  6d359d:	movq   $0x0,0x8(%rdi)
  6d35a5:	ret
  6d35a6:	push   %rbp
  6d35a7:	push   %r15
  6d35a9:	push   %r14
  6d35ab:	push   %r13
  6d35ad:	push   %r12
  6d35af:	push   %rbx
  6d35b0:	sub    $0x58,%rsp
  6d35b4:	cmpb   $0x1,0x742(%rsi)
  6d35bb:	jne    6d3671 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8hit_only+0xf1>
  6d35c1:	cmpb   $0x0,0x743(%rsi)
  6d35c8:	jne    6d3671 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8hit_only+0xf1>
  6d35ce:	cmpb   $0x0,0x744(%rsi)
  6d35d5:	je     6d3671 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8hit_only+0xf1>
  6d35db:	cmpq   $0xffffffffffffffff,0x5b0(%rsi)
  6d35e3:	jne    6d3671 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8hit_only+0xf1>
  6d35e9:	mov    0x688(%rsi),%rax
  6d35f0:	cmp    0x690(%rsi),%rax
  6d35f7:	jne    6d3671 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8hit_only+0xf1>
  6d35f9:	mov    0x6a0(%rsi),%r14
  6d3600:	cmp    0x698(%rsi),%r14
  6d3607:	jne    6d3671 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8hit_only+0xf1>
  6d3609:	movss  0x738(%rsi),%xmm2
  6d3611:	ucomiss 0x73c(%rsi),%xmm2
  6d3618:	jne    6d3671 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8hit_only+0xf1>
  6d361a:	jp     6d3671 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8hit_only+0xf1>
  6d361c:	mov    0x5a0(%rsi),%r15
  6d3623:	mov    0x5a8(%rsi),%r12
  6d362a:	mov    0x638(%rsi),%r13
  6d3631:	mov    %rdi,%rbx
  6d3634:	test   %r13,%r13
  6d3637:	je     6d3687 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8hit_only+0x107>
  6d3639:	mov    0x100(%r13),%rax
  6d3640:	test   %rax,%rax
  6d3643:	je     6d369c <_RNvCs4gijoeCAvqI_25inspector_pointer_control8hit_only+0x11c>
  6d3645:	lea    0x8(%rsp),%rdi
  6d364a:	mov    %rsi,%rbp
  6d364d:	mov    %rax,%rsi
  6d3650:	movss  %xmm1,0x4(%rsp)
  6d3656:	movss  %xmm0,(%rsp)
  6d365b:	call   *0x34642f(%rip)        # a19a90 <_DYNAMIC+0x470>
  6d3661:	movss  (%rsp),%xmm0
  6d3666:	movss  0x4(%rsp),%xmm1
  6d366c:	mov    %rbp,%rsi
  6d366f:	jmp    6d36ad <_RNvCs4gijoeCAvqI_25inspector_pointer_control8hit_only+0x12d>
  6d3671:	movq   $0x12,(%rdi)
  6d3678:	add    $0x58,%rsp
  6d367c:	pop    %rbx
  6d367d:	pop    %r12
  6d367f:	pop    %r13
  6d3681:	pop    %r14
  6d3683:	pop    %r15
  6d3685:	pop    %rbp
  6d3686:	ret
  6d3687:	movq   $0x4,0x8(%rsp)
  6d3690:	xorps  %xmm2,%xmm2
  6d3693:	movups %xmm2,0x10(%rsp)
  6d3698:	xor    %eax,%eax
  6d369a:	jmp    6d36b5 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8hit_only+0x135>
  6d369c:	movq   $0x4,0x8(%rsp)
  6d36a5:	xorps  %xmm2,%xmm2
  6d36a8:	movups %xmm2,0x10(%rsp)
  6d36ad:	cmpq   $0x0,0x0(%r13)
  6d36b2:	setne  %al
  6d36b5:	mov    %r15,0x20(%rsp)
  6d36ba:	mov    %r12,0x28(%rsp)
  6d36bf:	mov    0x8(%rsp),%rcx
  6d36c4:	mov    %rcx,0x30(%rsp)
  6d36c9:	mov    0x10(%rsp),%rcx
  6d36ce:	mov    %rcx,0x38(%rsp)
  6d36d3:	mov    0x18(%rsp),%rcx
  6d36d8:	mov    %rcx,0x40(%rsp)
  6d36dd:	mov    %r14,0x48(%rsp)
  6d36e2:	mov    %al,0x50(%rsp)
  6d36e6:	lea    0x20(%rsp),%rax
  6d36eb:	mov    %rsi,%r14
  6d36ee:	mov    %rsi,%rdi
  6d36f1:	mov    %rax,%rsi
  6d36f4:	call   6e7ae0 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE12hit_in_sheetBO_>
  6d36f9:	cmp    $0x1,%rax
  6d36fd:	jne    6d3714 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8hit_only+0x194>
  6d36ff:	mov    %r14,%rdi
  6d3702:	add    $0x5d8,%rdi
  6d3709:	mov    %rdx,%rsi
  6d370c:	call   *0x34634e(%rip)        # a19a60 <_DYNAMIC+0x440>
  6d3712:	jmp    6d3716 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8hit_only+0x196>
  6d3714:	xor    %eax,%eax
  6d3716:	mov    %rax,0x8(%rbx)
  6d371a:	mov    %rdx,0x10(%rbx)
  6d371e:	movq   $0xfffffffffffffffe,(%rbx)
  6d3725:	jmp    6d3678 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8hit_only+0xf8>

/tmp/gpui-inspector-pointer-codegen-inline/candidate-frozen:     file format elf64-x86-64


Disassembly of section .text:

00000000006db530 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE11pointer_hitBW_>:
  6db530:	cmpl   $0x1,(%rdx)
  6db533:	jne    6db565 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE11pointer_hitBW_+0x35>
  6db535:	push   %rbx
  6db536:	movss  0x4(%rdx),%xmm0
  6db53b:	movss  0x8(%rdx),%xmm1
  6db540:	mov    0x638(%rdi),%rax
  6db547:	test   %rax,%rax
  6db54a:	je     6db568 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE11pointer_hitBW_+0x38>
  6db54c:	mov    0xd8(%rax),%rax
  6db553:	test   %rax,%rax
  6db556:	je     6db568 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE11pointer_hitBW_+0x38>
  6db558:	cmpb   $0x0,0x12(%rax)
  6db55c:	je     6db568 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE11pointer_hitBW_+0x38>
  6db55e:	call   6dd730 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE23inspector_pick_in_sheetB10_>
  6db563:	pop    %rbx
  6db564:	ret
  6db565:	xor    %eax,%eax
  6db567:	ret
  6db568:	mov    %rdi,%rbx
  6db56b:	call   6e7ae0 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE12hit_in_sheetBO_>
  6db570:	test   $0x1,%al
  6db572:	je     6db589 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE11pointer_hitBW_+0x59>
  6db574:	mov    %rbx,%rdi
  6db577:	add    $0x5d8,%rdi
  6db57e:	mov    %rdx,%rsi
  6db581:	call   *0x33e4d9(%rip)        # a19a60 <_DYNAMIC+0x440>
  6db587:	pop    %rbx
  6db588:	ret
  6db589:	xor    %eax,%eax
  6db58b:	pop    %rbx
  6db58c:	ret

/tmp/gpui-inspector-pointer-codegen-inline/candidate-frozen:     file format elf64-x86-64


Disassembly of section .text:

00000000006dd730 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE23inspector_pick_in_sheetB10_>:
  6dd730:	push   %rbp
  6dd731:	push   %r15
  6dd733:	push   %r14
  6dd735:	push   %r13
  6dd737:	push   %r12
  6dd739:	push   %rbx
  6dd73a:	sub    $0x68,%rsp
  6dd73e:	movss  %xmm1,0x14(%rsp)
  6dd744:	movss  %xmm0,0x10(%rsp)
  6dd74a:	mov    0x638(%rdi),%rcx
  6dd751:	test   %rcx,%rcx
  6dd754:	je     6dd84f <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE23inspector_pick_in_sheetB10_+0x11f>
  6dd75a:	cmpq   $0x0,0xd8(%rcx)
  6dd762:	je     6dd84f <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE23inspector_pick_in_sheetB10_+0x11f>
  6dd768:	mov    0x2c8(%rdi),%rax
  6dd76f:	cmp    $0x1c,%rax
  6dd773:	jb     6dd84f <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE23inspector_pick_in_sheetB10_+0x11f>
  6dd779:	mov    %rsi,%r14
  6dd77c:	mov    0x8(%rsi),%r15
  6dd780:	test   %r15,%r15
  6dd783:	je     6dd84f <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE23inspector_pick_in_sheetB10_+0x11f>
  6dd789:	mov    %rdi,0x28(%rsp)
  6dd78e:	mov    %rcx,0x20(%rsp)
  6dd793:	mov    %rax,0x18(%rsp)
  6dd798:	mov    (%r14),%r13
  6dd79b:	mov    %r15,%rax
  6dd79e:	shl    $0x6,%rax
  6dd7a2:	add    %r13,%rax
  6dd7a5:	movzbl 0x30(%r14),%ecx
  6dd7aa:	mov    %ecx,0xc(%rsp)
  6dd7ae:	add    $0x10,%r14
  6dd7b2:	jmp    6dd80f <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE23inspector_pick_in_sheetB10_+0xdf>
  6dd7b4:	data16 data16 cs nopw 0x0(%rax,%rax,1)
  6dd7c0:	mov    %rbp,%r12
  6dd7c3:	sub    %r13,%r12
  6dd7c6:	mov    %r12,%rbx
  6dd7c9:	shr    $0x6,%rbx
  6dd7cd:	mov    0x10(%r14),%rax
  6dd7d1:	mov    %rax,0x40(%rsp)
  6dd7d6:	movups (%r14),%xmm0
  6dd7da:	movaps %xmm0,0x30(%rsp)
  6dd7df:	mov    %r13,%rdi
  6dd7e2:	mov    %r15,%rsi
  6dd7e5:	lea    0x30(%rsp),%rdx
  6dd7ea:	mov    0xc(%rsp),%ecx
  6dd7ee:	mov    %rbx,%r8
  6dd7f1:	movss  0x10(%rsp),%xmm0
  6dd7f7:	movss  0x14(%rsp),%xmm1
  6dd7fd:	call   *0x33c315(%rip)        # a19b18 <_DYNAMIC+0x4f8>
  6dd803:	test   %al,%al
  6dd805:	jne    6dd868 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE23inspector_pick_in_sheetB10_+0x138>
  6dd807:	mov    %rbp,%rax
  6dd80a:	cmp    %rbp,%r13
  6dd80d:	je     6dd863 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE23inspector_pick_in_sheetB10_+0x133>
  6dd80f:	lea    -0x40(%rax),%rbp
  6dd813:	cmpb   $0x0,-0x2(%rax)
  6dd817:	jne    6dd7c0 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE23inspector_pick_in_sheetB10_+0x90>
  6dd819:	mov    -0x8(%rax),%eax
  6dd81c:	cmp    $0x3ffff,%rax
  6dd822:	jbe    6dd807 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE23inspector_pick_in_sheetB10_+0xd7>
  6dd824:	shr    $0x11,%eax
  6dd827:	mov    %rbp,%rcx
  6dd82a:	sub    %r13,%rcx
  6dd82d:	shr    $0x6,%rcx
  6dd831:	mov    $0x2,%edx
  6dd836:	sub    %rax,%rdx
  6dd839:	add    $0xfffffffffffffffe,%rax
  6dd83d:	shl    $0x6,%rdx
  6dd841:	cmp    %rcx,%rax
  6dd844:	lea    -0x40(%rbp,%rdx,1),%rbp
  6dd849:	cmovae %r13,%rbp
  6dd84d:	jmp    6dd807 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE23inspector_pick_in_sheetB10_+0xd7>
  6dd84f:	xor    %eax,%eax
  6dd851:	mov    %r14,%rdx
  6dd854:	add    $0x68,%rsp
  6dd858:	pop    %rbx
  6dd859:	pop    %r12
  6dd85b:	pop    %r13
  6dd85d:	pop    %r14
  6dd85f:	pop    %r15
  6dd861:	pop    %rbp
  6dd862:	ret
  6dd863:	jmp    6dd927 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE23inspector_pick_in_sheetB10_+0x1f7>
  6dd868:	cmp    %r15,%rbx
  6dd86b:	jae    6dd92e <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE23inspector_pick_in_sheetB10_+0x1fe>
  6dd871:	mov    0x28(%rsp),%r15
  6dd876:	lea    0x5d8(%r15),%rdi
  6dd87d:	mov    0x20(%r13,%r12,1),%rsi
  6dd882:	call   *0x33c1d8(%rip)        # a19a60 <_DYNAMIC+0x440>
  6dd888:	mov    %rdx,%r14
  6dd88b:	cmp    0x5d8(%r15),%rax
  6dd892:	jne    6dd927 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE23inspector_pick_in_sheetB10_+0x1f7>
  6dd898:	mov    %rax,%rbx
  6dd89b:	lea    0x30(%rsp),%rdi
  6dd8a0:	mov    %r15,%rsi
  6dd8a3:	mov    %r14,%rdx
  6dd8a6:	call   6f8a80 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE16resolve_identityBO_>
  6dd8ab:	mov    0x30(%rsp),%rcx
  6dd8b0:	mov    0x38(%rsp),%rax
  6dd8b5:	cmp    $0xfffffffffffffffe,%rcx
  6dd8b9:	jne    6dd8ec <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE23inspector_pick_in_sheetB10_+0x1bc>
  6dd8bb:	mov    0x20(%rsp),%rcx
  6dd8c0:	cmpq   $0x0,0xd8(%rcx)
  6dd8c8:	je     6dd927 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE23inspector_pick_in_sheetB10_+0x1f7>
  6dd8ca:	mov    0x18(%rsp),%rdx
  6dd8cf:	add    $0xffffffffffffffe4,%rdx
  6dd8d3:	cmp    $0x2,%rax
  6dd8d7:	setae  %cl
  6dd8da:	cmp    %rdx,%rax
  6dd8dd:	setb   %al
  6dd8e0:	test   %al,%cl
  6dd8e2:	je     6dd927 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE23inspector_pick_in_sheetB10_+0x1f7>
  6dd8e4:	mov    %rbx,%rax
  6dd8e7:	jmp    6dd851 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE23inspector_pick_in_sheetB10_+0x121>
  6dd8ec:	mov    0x48(%rsp),%rsi
  6dd8f1:	mov    0x50(%rsp),%rdi
  6dd8f6:	cmp    $0xc,%rcx
  6dd8fa:	jle    6dd917 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE23inspector_pick_in_sheetB10_+0x1e7>
  6dd8fc:	cmp    $0x21,%rcx
  6dd900:	je     6dd917 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE23inspector_pick_in_sheetB10_+0x1e7>
  6dd902:	cmp    $0x26,%rcx
  6dd906:	jne    6dd927 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE23inspector_pick_in_sheetB10_+0x1f7>
  6dd908:	test   %rax,%rax
  6dd90b:	je     6dd927 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE23inspector_pick_in_sheetB10_+0x1f7>
  6dd90d:	mov    0x40(%rsp),%rdi
  6dd912:	mov    %rax,%rsi
  6dd915:	jmp    6dd91c <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE23inspector_pick_in_sheetB10_+0x1ec>
  6dd917:	test   %rsi,%rsi
  6dd91a:	je     6dd927 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE23inspector_pick_in_sheetB10_+0x1f7>
  6dd91c:	mov    $0x1,%edx
  6dd921:	call   *0x33bf39(%rip)        # a19860 <_DYNAMIC+0x240>
  6dd927:	xor    %eax,%eax
  6dd929:	jmp    6dd851 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE23inspector_pick_in_sheetB10_+0x121>
  6dd92e:	lea    0x31d563(%rip),%rdx        # 9fae98 <__frame_dummy_init_array_entry+0x1048>
  6dd935:	mov    %rbx,%rdi
  6dd938:	mov    %r15,%rsi
  6dd93b:	call   *0x33bf4f(%rip)        # a19890 <_DYNAMIC+0x270>

/tmp/gpui-inspector-pointer-codegen-inline/candidate-frozen:     file format elf64-x86-64


Disassembly of section .text:

00000000006e7ae0 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE12hit_in_sheetBO_>:
  6e7ae0:	push   %rbp
  6e7ae1:	push   %r15
  6e7ae3:	push   %r14
  6e7ae5:	push   %r13
  6e7ae7:	push   %r12
  6e7ae9:	push   %rbx
  6e7aea:	sub    $0x28,%rsp
  6e7aee:	mov    %rsi,%r13
  6e7af1:	mov    %rdi,%rbx
  6e7af4:	mov    %rsi,%rdi
  6e7af7:	movss  %xmm0,(%rsp)
  6e7afc:	movss  %xmm1,0x4(%rsp)
  6e7b02:	call   *0x331f50(%rip)        # a19a58 <_DYNAMIC+0x438>
  6e7b08:	test   %al,%al
  6e7b0a:	je     6e7bca <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE12hit_in_sheetBO_+0xea>
  6e7b10:	mov    0x8(%r13),%rax
  6e7b14:	test   %rax,%rax
  6e7b17:	je     6e7bca <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE12hit_in_sheetBO_+0xea>
  6e7b1d:	mov    %rbx,0x8(%rsp)
  6e7b22:	mov    0x0(%r13),%r14
  6e7b26:	mov    %rax,%r15
  6e7b29:	shl    $0x6,%rax
  6e7b2d:	add    %r14,%rax
  6e7b30:	movzbl 0x30(%r13),%ebp
  6e7b35:	add    $0x10,%r13
  6e7b39:	jmp    6e7b8a <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE12hit_in_sheetBO_+0xaa>
  6e7b3b:	nopl   0x0(%rax,%rax,1)
  6e7b40:	mov    %rbx,%r12
  6e7b43:	sub    %r14,%r12
  6e7b46:	shr    $0x6,%r12
  6e7b4a:	mov    0x10(%r13),%rax
  6e7b4e:	mov    %rax,0x20(%rsp)
  6e7b53:	movups 0x0(%r13),%xmm0
  6e7b58:	movaps %xmm0,0x10(%rsp)
  6e7b5d:	mov    %r14,%rdi
  6e7b60:	mov    %r15,%rsi
  6e7b63:	lea    0x10(%rsp),%rdx
  6e7b68:	mov    %ebp,%ecx
  6e7b6a:	mov    %r12,%r8
  6e7b6d:	movss  (%rsp),%xmm0
  6e7b72:	movss  0x4(%rsp),%xmm1
  6e7b78:	call   *0x331f9a(%rip)        # a19b18 <_DYNAMIC+0x4f8>
  6e7b7e:	test   %al,%al
  6e7b80:	jne    6e7bdf <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE12hit_in_sheetBO_+0xff>
  6e7b82:	mov    %rbx,%rax
  6e7b85:	cmp    %rbx,%r14
  6e7b88:	je     6e7bce <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE12hit_in_sheetBO_+0xee>
  6e7b8a:	lea    -0x40(%rax),%rbx
  6e7b8e:	cmpb   $0x0,-0x2(%rax)
  6e7b92:	jne    6e7b40 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE12hit_in_sheetBO_+0x60>
  6e7b94:	mov    -0x8(%rax),%eax
  6e7b97:	cmp    $0x3ffff,%rax
  6e7b9d:	jbe    6e7b82 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE12hit_in_sheetBO_+0xa2>
  6e7b9f:	shr    $0x11,%eax
  6e7ba2:	mov    %rbx,%rcx
  6e7ba5:	sub    %r14,%rcx
  6e7ba8:	shr    $0x6,%rcx
  6e7bac:	mov    $0x2,%edx
  6e7bb1:	sub    %rax,%rdx
  6e7bb4:	add    $0xfffffffffffffffe,%rax
  6e7bb8:	shl    $0x6,%rdx
  6e7bbc:	cmp    %rcx,%rax
  6e7bbf:	lea    -0x40(%rbx,%rdx,1),%rbx
  6e7bc4:	cmovae %r14,%rbx
  6e7bc8:	jmp    6e7b82 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE12hit_in_sheetBO_+0xa2>
  6e7bca:	xor    %eax,%eax
  6e7bcc:	jmp    6e7bd0 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE12hit_in_sheetBO_+0xf0>
  6e7bce:	xor    %eax,%eax
  6e7bd0:	add    $0x28,%rsp
  6e7bd4:	pop    %rbx
  6e7bd5:	pop    %r12
  6e7bd7:	pop    %r13
  6e7bd9:	pop    %r14
  6e7bdb:	pop    %r15
  6e7bdd:	pop    %rbp
  6e7bde:	ret
  6e7bdf:	mov    0x8(%rsp),%rax
  6e7be4:	mov    0x1e8(%rax),%rbp
  6e7beb:	mov    0x1f0(%rax),%rcx
  6e7bf2:	mov    0x1f8(%rax),%r8
  6e7bf9:	mov    0x2c8(%rax),%rsi
  6e7c00:	mov    0x2c0(%rax),%r9
  6e7c07:	mov    %r15,%r13
  6e7c0a:	mov    $0x1,%eax
  6e7c0f:	jmp    6e7c34 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE12hit_in_sheetBO_+0x154>
  6e7c11:	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
  6e7c20:	mov    0x38(%r10),%r12d
  6e7c24:	and    $0x1ffff,%r12d
  6e7c2b:	cmp    $0x1ffff,%r12
  6e7c32:	je     6e7bce <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE12hit_in_sheetBO_+0xee>
  6e7c34:	cmp    %r13,%r12
  6e7c37:	jae    6e7d8b <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE12hit_in_sheetBO_+0x2ab>
  6e7c3d:	shl    $0x6,%r12
  6e7c41:	lea    (%r14,%r12,1),%r10
  6e7c45:	mov    0x20(%r14,%r12,1),%rdx
  6e7c4a:	test   %rbp,%rbp
  6e7c4d:	je     6e7c70 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE12hit_in_sheetBO_+0x190>
  6e7c4f:	cmp    $0x1,%ebp
  6e7c52:	jne    6e7c90 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE12hit_in_sheetBO_+0x1b0>
  6e7c54:	test   %r8,%r8
  6e7c57:	je     6e7c20 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE12hit_in_sheetBO_+0x140>
  6e7c59:	cmp    $0x1,%r8
  6e7c5d:	jne    6e7cb0 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE12hit_in_sheetBO_+0x1d0>
  6e7c5f:	xor    %edi,%edi
  6e7c61:	jmp    6e7ce4 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE12hit_in_sheetBO_+0x204>
  6e7c66:	cs nopw 0x0(%rax,%rax,1)
  6e7c70:	mov    %rdx,%rdi
  6e7c73:	sub    %rcx,%rdi
  6e7c76:	setae  %r11b
  6e7c7a:	cmp    %r8,%rdi
  6e7c7d:	setb   %bl
  6e7c80:	test   %bl,%r11b
  6e7c83:	je     6e7c20 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE12hit_in_sheetBO_+0x140>
  6e7c85:	jmp    6e7d66 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE12hit_in_sheetBO_+0x286>
  6e7c8a:	nopw   0x0(%rax,%rax,1)
  6e7c90:	test   %r8,%r8
  6e7c93:	je     6e7c20 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE12hit_in_sheetBO_+0x140>
  6e7c95:	cmp    $0x1,%r8
  6e7c99:	jne    6e7d25 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE12hit_in_sheetBO_+0x245>
  6e7c9f:	mov    %rcx,%rdi
  6e7ca2:	cmp    %rdx,(%rcx)
  6e7ca5:	jne    6e7c20 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE12hit_in_sheetBO_+0x140>
  6e7cab:	jmp    6e7d63 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE12hit_in_sheetBO_+0x283>
  6e7cb0:	mov    %r8,%r11
  6e7cb3:	xor    %edi,%edi
  6e7cb5:	data16 cs nopw 0x0(%rax,%rax,1)
  6e7cc0:	mov    %rdi,%rbx
  6e7cc3:	mov    %r11,%r15
  6e7cc6:	shr    $1,%r15
  6e7cc9:	add    %r15,%rdi
  6e7ccc:	mov    %rdi,%r12
  6e7ccf:	shl    $0x4,%r12
  6e7cd3:	cmp    %rdx,(%rcx,%r12,1)
  6e7cd7:	cmova  %rbx,%rdi
  6e7cdb:	sub    %r15,%r11
  6e7cde:	cmp    $0x1,%r11
  6e7ce2:	ja     6e7cc0 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE12hit_in_sheetBO_+0x1e0>
  6e7ce4:	mov    %rdi,%rbx
  6e7ce7:	shl    $0x4,%rbx
  6e7ceb:	xor    %r11d,%r11d
  6e7cee:	cmp    %rdx,(%rcx,%rbx,1)
  6e7cf2:	setbe  %r11b
  6e7cf6:	add    %rdi,%r11
  6e7cf9:	je     6e7c20 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE12hit_in_sheetBO_+0x140>
  6e7cff:	shl    $0x4,%r11
  6e7d03:	mov    %rdx,%rdi
  6e7d06:	sub    -0x10(%rcx,%r11,1),%rdi
  6e7d0b:	mov    -0x4(%rcx,%r11,1),%ebx
  6e7d10:	cmp    %rbx,%rdi
  6e7d13:	jae    6e7c20 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE12hit_in_sheetBO_+0x140>
  6e7d19:	add    %rcx,%r11
  6e7d1c:	mov    -0x8(%r11),%r11d
  6e7d20:	add    %r11,%rdi
  6e7d23:	jmp    6e7d66 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE12hit_in_sheetBO_+0x286>
  6e7d25:	mov    %r8,%rdi
  6e7d28:	xor    %r11d,%r11d
  6e7d2b:	nopl   0x0(%rax,%rax,1)
  6e7d30:	mov    %r11,%rbx
  6e7d33:	mov    %rdi,%r15
  6e7d36:	shr    $1,%r15
  6e7d39:	add    %r15,%r11
  6e7d3c:	lea    (%r11,%r11,2),%r12
  6e7d40:	cmp    %rdx,(%rcx,%r12,4)
  6e7d44:	cmova  %rbx,%r11
  6e7d48:	sub    %r15,%rdi
  6e7d4b:	cmp    $0x1,%rdi
  6e7d4f:	ja     6e7d30 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE12hit_in_sheetBO_+0x250>
  6e7d51:	lea    (%r11,%r11,2),%rdi
  6e7d55:	cmp    %rdx,(%rcx,%rdi,4)
  6e7d59:	jne    6e7c20 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE12hit_in_sheetBO_+0x140>
  6e7d5f:	lea    (%rcx,%rdi,4),%rdi
  6e7d63:	mov    0x8(%rdi),%edi
  6e7d66:	cmp    %rsi,%rdi
  6e7d69:	jae    6e7d9e <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE12hit_in_sheetBO_+0x2be>
  6e7d6b:	lea    (%rdi,%rdi,4),%rdi
  6e7d6f:	cmpq   $0x0,0x8(%r9,%rdi,8)
  6e7d75:	jne    6e7bd0 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE12hit_in_sheetBO_+0xf0>
  6e7d7b:	cmpb   $0x4,0x3d(%r10)
  6e7d80:	jne    6e7c20 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE12hit_in_sheetBO_+0x140>
  6e7d86:	jmp    6e7bd0 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE12hit_in_sheetBO_+0xf0>
  6e7d8b:	lea    0x3132e6(%rip),%rdx        # 9fb078 <__frame_dummy_init_array_entry+0x1228>
  6e7d92:	mov    %r12,%rdi
  6e7d95:	mov    %r13,%rsi
  6e7d98:	call   *0x331af2(%rip)        # a19890 <_DYNAMIC+0x270>
  6e7d9e:	lea    0x3132eb(%rip),%rdx        # 9fb090 <__frame_dummy_init_array_entry+0x1240>
  6e7da5:	call   *0x331ae5(%rip)        # a19890 <_DYNAMIC+0x270>

/tmp/gpui-inspector-pointer-codegen-inline/candidate-frozen:     file format elf64-x86-64


Disassembly of section .text:

00000000006f8d60 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_>:
  6f8d60:	push   %r15
  6f8d62:	push   %r14
  6f8d64:	push   %r12
  6f8d66:	push   %rbx
  6f8d67:	sub    $0x58,%rsp
  6f8d6b:	mov    0x5a0(%rdi),%rbx
  6f8d72:	mov    0x5a8(%rdi),%r14
  6f8d79:	mov    0x638(%rdi),%r15
  6f8d80:	test   %r15,%r15
  6f8d83:	je     6f8dbd <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x5d>
  6f8d85:	mov    0x100(%r15),%rsi
  6f8d8c:	test   %rsi,%rsi
  6f8d8f:	je     6f8dd2 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x72>
  6f8d91:	lea    0x8(%rsp),%rax
  6f8d96:	mov    %rdi,%r12
  6f8d99:	mov    %rax,%rdi
  6f8d9c:	movss  %xmm1,0x4(%rsp)
  6f8da2:	movss  %xmm0,(%rsp)
  6f8da7:	call   *0x320ce3(%rip)        # a19a90 <_DYNAMIC+0x470>
  6f8dad:	movss  (%rsp),%xmm0
  6f8db2:	movss  0x4(%rsp),%xmm1
  6f8db8:	mov    %r12,%rdi
  6f8dbb:	jmp    6f8de3 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x83>
  6f8dbd:	movq   $0x4,0x8(%rsp)
  6f8dc6:	xorps  %xmm2,%xmm2
  6f8dc9:	movups %xmm2,0x10(%rsp)
  6f8dce:	xor    %eax,%eax
  6f8dd0:	jmp    6f8dea <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x8a>
  6f8dd2:	movq   $0x4,0x8(%rsp)
  6f8ddb:	xorps  %xmm2,%xmm2
  6f8dde:	movups %xmm2,0x10(%rsp)
  6f8de3:	cmpq   $0x0,(%r15)
  6f8de7:	setne  %al
  6f8dea:	mov    0x698(%rdi),%rcx
  6f8df1:	mov    %rbx,0x20(%rsp)
  6f8df6:	mov    %r14,0x28(%rsp)
  6f8dfb:	mov    0x8(%rsp),%rdx
  6f8e00:	mov    %rdx,0x30(%rsp)
  6f8e05:	mov    0x10(%rsp),%rdx
  6f8e0a:	mov    %rdx,0x38(%rsp)
  6f8e0f:	mov    0x18(%rsp),%rdx
  6f8e14:	mov    %rdx,0x40(%rsp)
  6f8e19:	mov    %rcx,0x48(%rsp)
  6f8e1e:	mov    %al,0x50(%rsp)
  6f8e22:	lea    0x20(%rsp),%rsi
  6f8e27:	call   6e7ae0 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE12hit_in_sheetBO_>
  6f8e2c:	add    $0x58,%rsp
  6f8e30:	pop    %rbx
  6f8e31:	pop    %r12
  6f8e33:	pop    %r14
  6f8e35:	pop    %r15
  6f8e37:	ret

<gpui::runtime::Runtime<inspector_pointer_control::Model>>::pointer_release_hit::{closure#2} bytes=255 stack=104

inspector_pointer_control::click_only bytes=1051 stack=152

inspector_pointer_control::ack bytes=241 stack=136

inspector_pointer_control::main bytes=7119 stack=3368

inspector_pointer_control::dispatch bytes=3949 stack=424

inspector_pointer_control::hit_only bytes=426 stack=136

<gpui::runtime::Runtime<inspector_pointer_control::Model>>::pointer_hit bytes=93 stack=8

<gpui::runtime::Runtime<inspector_pointer_control::Model>>::inspector_pick_in_sheet bytes=529 stack=152

<gpui::runtime::Runtime<inspector_pointer_control::Model>>::hit_in_sheet bytes=715 stack=88

<gpui::runtime::Runtime<inspector_pointer_control::Model>>::hit bytes=216 stack=120
