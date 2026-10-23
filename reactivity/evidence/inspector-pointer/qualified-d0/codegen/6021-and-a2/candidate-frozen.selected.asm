
/tmp/gpui-inspector-pointer-codegen/candidate-frozen:     file format elf64-x86-64


Disassembly of section .text:

00000000006ce900 <_RNCNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB9_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19pointer_release_hits0_0BY_>:
  6ce900:	push   %r15
  6ce902:	push   %r14
  6ce904:	push   %r12
  6ce906:	push   %rbx
  6ce907:	sub    $0x48,%rsp
  6ce90b:	mov    (%rdi),%rax
  6ce90e:	mov    $0x1,%bl
  6ce910:	cmpl   $0x1,(%rax)
  6ce913:	jne    6ce9f3 <_RNCNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB9_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19pointer_release_hits0_0BY_+0xf3>
  6ce919:	mov    %rsi,%r12
  6ce91c:	mov    %rdi,%r14
  6ce91f:	movss  0x4(%rax),%xmm0
  6ce924:	movss  0x8(%rax),%xmm1
  6ce929:	mov    %rsi,%rdi
  6ce92c:	movss  %xmm0,0x8(%rsp)
  6ce932:	movss  %xmm1,0xc(%rsp)
  6ce938:	call   *0x34b0ca(%rip)        # a19a08 <_DYNAMIC+0x438>
  6ce93e:	test   %al,%al
  6ce940:	je     6ce9f3 <_RNCNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB9_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19pointer_release_hits0_0BY_+0xf3>
  6ce946:	mov    0x8(%r14),%r15
  6ce94a:	mov    0x30(%r12),%rax
  6ce94f:	mov    %rax,0x40(%rsp)
  6ce954:	movups (%r12),%xmm0
  6ce959:	movups 0x10(%r12),%xmm1
  6ce95f:	movups 0x20(%r12),%xmm2
  6ce965:	movaps %xmm2,0x30(%rsp)
  6ce96a:	movaps %xmm1,0x20(%rsp)
  6ce96f:	movaps %xmm0,0x10(%rsp)
  6ce974:	mov    0x638(%r15),%rax
  6ce97b:	test   %rax,%rax
  6ce97e:	je     6ce9ad <_RNCNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB9_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19pointer_release_hits0_0BY_+0xad>
  6ce980:	mov    0xd8(%rax),%rax
  6ce987:	test   %rax,%rax
  6ce98a:	je     6ce9ad <_RNCNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB9_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19pointer_release_hits0_0BY_+0xad>
  6ce98c:	cmpb   $0x0,0x12(%rax)
  6ce990:	je     6ce9ad <_RNCNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB9_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19pointer_release_hits0_0BY_+0xad>
  6ce992:	lea    0x10(%rsp),%rsi
  6ce997:	mov    %r15,%rdi
  6ce99a:	movss  0x8(%rsp),%xmm0
  6ce9a0:	movss  0xc(%rsp),%xmm1
  6ce9a6:	call   6dd7a0 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE23inspector_pick_in_sheetB10_>
  6ce9ab:	jmp    6ce9dd <_RNCNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB9_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19pointer_release_hits0_0BY_+0xdd>
  6ce9ad:	lea    0x10(%rsp),%rsi
  6ce9b2:	mov    %r15,%rdi
  6ce9b5:	movss  0x8(%rsp),%xmm0
  6ce9bb:	movss  0xc(%rsp),%xmm1
  6ce9c1:	call   6e7a60 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE12hit_in_sheetBO_>
  6ce9c6:	test   $0x1,%al
  6ce9c8:	je     6ce9f3 <_RNCNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB9_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19pointer_release_hits0_0BY_+0xf3>
  6ce9ca:	add    $0x5d8,%r15
  6ce9d1:	mov    %r15,%rdi
  6ce9d4:	mov    %rdx,%rsi
  6ce9d7:	call   *0x34b033(%rip)        # a19a10 <_DYNAMIC+0x440>
  6ce9dd:	test   %rax,%rax
  6ce9e0:	je     6ce9f3 <_RNCNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB9_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19pointer_release_hits0_0BY_+0xf3>
  6ce9e2:	mov    0x10(%r14),%rcx
  6ce9e6:	xor    (%rcx),%rax
  6ce9e9:	xor    0x8(%rcx),%rdx
  6ce9ed:	or     %rax,%rdx
  6ce9f0:	setne  %bl
  6ce9f3:	mov    %ebx,%eax
  6ce9f5:	add    $0x48,%rsp
  6ce9f9:	pop    %rbx
  6ce9fa:	pop    %r12
  6ce9fc:	pop    %r14
  6ce9fe:	pop    %r15
  6cea00:	ret

/tmp/gpui-inspector-pointer-codegen/candidate-frozen:     file format elf64-x86-64


Disassembly of section .text:

00000000006d0590 <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only>:
  6d0590:	push   %rbp
  6d0591:	push   %r15
  6d0593:	push   %r14
  6d0595:	push   %r13
  6d0597:	push   %r12
  6d0599:	push   %rbx
  6d059a:	sub    $0x68,%rsp
  6d059e:	mov    (%rsi),%rbx
  6d05a1:	test   %rbx,%rbx
  6d05a4:	je     6d05c9 <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x39>
  6d05a6:	add    $0x8,%rsi
  6d05aa:	mov    %rbx,0x58(%rsp)
  6d05af:	mov    %rsi,0x60(%rsp)
  6d05b4:	cmpb   $0x1,0x746(%rbx)
  6d05bb:	jne    6d05dd <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x4d>
  6d05bd:	movq   $0xe,(%rdi)
  6d05c4:	jmp    6d06c4 <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x134>
  6d05c9:	movq   $0xd,(%rdi)
  6d05d0:	movq   $0x0,0x8(%rdi)
  6d05d8:	jmp    6d06c4 <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x134>
  6d05dd:	cmpb   $0x1,0x742(%rbx)
  6d05e4:	jne    6d06bd <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x12d>
  6d05ea:	cmpb   $0x0,0x743(%rbx)
  6d05f1:	jne    6d06bd <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x12d>
  6d05f7:	cmpb   $0x0,0x744(%rbx)
  6d05fe:	je     6d06bd <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x12d>
  6d0604:	cmpq   $0xffffffffffffffff,0x5b0(%rbx)
  6d060c:	jne    6d06bd <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x12d>
  6d0612:	mov    0x688(%rbx),%rax
  6d0619:	cmp    0x690(%rbx),%rax
  6d0620:	jne    6d06bd <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x12d>
  6d0626:	mov    0x6a0(%rbx),%rax
  6d062d:	cmp    0x698(%rbx),%rax
  6d0634:	jne    6d06bd <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x12d>
  6d063a:	movss  0x738(%rbx),%xmm2
  6d0642:	ucomiss 0x73c(%rbx),%xmm2
  6d0649:	jne    6d06bd <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x12d>
  6d064b:	jp     6d06bd <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x12d>
  6d064d:	mov    0x638(%rbx),%r15
  6d0654:	test   %r15,%r15
  6d0657:	movss  %xmm1,0x4(%rsp)
  6d065d:	movss  %xmm0,(%rsp)
  6d0662:	je     6d070f <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x17f>
  6d0668:	mov    0xd8(%r15),%rcx
  6d066f:	test   %rcx,%rcx
  6d0672:	je     6d06d3 <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x143>
  6d0674:	cmpb   $0x0,0x12(%rcx)
  6d0678:	je     6d06d3 <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x143>
  6d067a:	mov    %rdi,%r14
  6d067d:	mov    0x5a0(%rbx),%r12
  6d0684:	mov    0x5a8(%rbx),%r13
  6d068b:	mov    0x100(%r15),%rsi
  6d0692:	test   %rsi,%rsi
  6d0695:	je     6d08d5 <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x345>
  6d069b:	lea    0x40(%rsp),%rdi
  6d06a0:	call   *0x34939a(%rip)        # a19a40 <_DYNAMIC+0x470>
  6d06a6:	movss  (%rsp),%xmm0
  6d06ab:	movss  0x4(%rsp),%xmm1
  6d06b1:	mov    0x698(%rbx),%rax
  6d06b8:	jmp    6d08e6 <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x356>
  6d06bd:	movq   $0x12,(%rdi)
  6d06c4:	add    $0x68,%rsp
  6d06c8:	pop    %rbx
  6d06c9:	pop    %r12
  6d06cb:	pop    %r13
  6d06cd:	pop    %r14
  6d06cf:	pop    %r15
  6d06d1:	pop    %rbp
  6d06d2:	ret
  6d06d3:	mov    0x5a0(%rbx),%r12
  6d06da:	mov    0x5a8(%rbx),%r13
  6d06e1:	mov    %rdi,%r14
  6d06e4:	mov    0x100(%r15),%rsi
  6d06eb:	test   %rsi,%rsi
  6d06ee:	je     6d0735 <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x1a5>
  6d06f0:	lea    0x40(%rsp),%rdi
  6d06f5:	call   *0x349345(%rip)        # a19a40 <_DYNAMIC+0x470>
  6d06fb:	movss  (%rsp),%xmm0
  6d0700:	movss  0x4(%rsp),%xmm1
  6d0706:	mov    0x698(%rbx),%rax
  6d070d:	jmp    6d0746 <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x1b6>
  6d070f:	mov    %rdi,%r14
  6d0712:	mov    0x5a0(%rbx),%r12
  6d0719:	mov    0x5a8(%rbx),%r13
  6d0720:	movq   $0x4,0x40(%rsp)
  6d0729:	xorps  %xmm2,%xmm2
  6d072c:	movups %xmm2,0x48(%rsp)
  6d0731:	xor    %ecx,%ecx
  6d0733:	jmp    6d074d <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x1bd>
  6d0735:	movq   $0x4,0x40(%rsp)
  6d073e:	xorps  %xmm2,%xmm2
  6d0741:	movups %xmm2,0x48(%rsp)
  6d0746:	cmpq   $0x0,(%r15)
  6d074a:	setne  %cl
  6d074d:	mov    %r12,0x8(%rsp)
  6d0752:	mov    %r13,0x10(%rsp)
  6d0757:	mov    0x40(%rsp),%rdx
  6d075c:	mov    %rdx,0x18(%rsp)
  6d0761:	mov    0x48(%rsp),%rdx
  6d0766:	mov    %rdx,0x20(%rsp)
  6d076b:	mov    0x50(%rsp),%rdx
  6d0770:	mov    %rdx,0x28(%rsp)
  6d0775:	mov    %rax,0x30(%rsp)
  6d077a:	mov    %cl,0x38(%rsp)
  6d077e:	lea    0x8(%rsp),%rsi
  6d0783:	mov    %rbx,%rdi
  6d0786:	call   6e7a60 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE12hit_in_sheetBO_>
  6d078b:	cmp    $0x1,%rax
  6d078f:	jne    6d0829 <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x299>
  6d0795:	lea    0x5d8(%rbx),%rdi
  6d079c:	mov    %rdx,%rsi
  6d079f:	call   *0x34926b(%rip)        # a19a10 <_DYNAMIC+0x440>
  6d07a5:	cmp    0x5d8(%rbx),%rax
  6d07ac:	jne    6d08a7 <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x317>
  6d07b2:	mov    %rax,%r12
  6d07b5:	mov    %rdx,%r15
  6d07b8:	lea    0x8(%rsp),%rdi
  6d07bd:	mov    %rbx,%rsi
  6d07c0:	call   6f8950 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE16resolve_identityBO_>
  6d07c5:	mov    0x8(%rsp),%rax
  6d07ca:	mov    0x10(%rsp),%rdi
  6d07cf:	cmp    $0xfffffffffffffffe,%rax
  6d07d3:	jne    6d08ac <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x31c>
  6d07d9:	mov    0x2c8(%rbx),%rsi
  6d07e0:	cmp    %rsi,%rdi
  6d07e3:	jae    6d099e <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x40e>
  6d07e9:	mov    0x2c0(%rbx),%rax
  6d07f0:	lea    (%rdi,%rdi,4),%rcx
  6d07f4:	mov    0x20(%rax,%rcx,8),%edi
  6d07f8:	call   6e2030 <_RNvMsh_NtCs6ZNK6sH19NW_4gpui7runtimeNtB5_4Node4kind>
  6d07fd:	cmp    $0x4,%al
  6d07ff:	jne    6d0950 <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x3c0>
  6d0805:	mov    %r14,%rdi
  6d0808:	mov    %rbx,%rsi
  6d080b:	mov    %r12,%rdx
  6d080e:	mov    %r15,%rcx
  6d0811:	movss  (%rsp),%xmm0
  6d0816:	movss  0x4(%rsp),%xmm1
  6d081c:	xor    %r8d,%r8d
  6d081f:	call   6dba50 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime7editingINtB7_10RuntimeMutNtCs4gijoeCAvqI_25inspector_pointer_control5ModeluE14select_pointerB12_>
  6d0824:	jmp    6d06c4 <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x134>
  6d0829:	mov    0x610(%rbx),%rdx
  6d0830:	mov    0x618(%rbx),%rcx
  6d0837:	movq   $0x0,0x610(%rbx)
  6d0842:	movq   $0x0,0x730(%rbx)
  6d084d:	lea    0x8(%rsp),%rdi
  6d0852:	mov    %rbx,%rsi
  6d0855:	call   6dc070 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime7editingINtB7_10RuntimeMutNtCs4gijoeCAvqI_25inspector_pointer_control5ModeluE20publish_focus_changeB12_>
  6d085a:	mov    0x8(%rsp),%rax
  6d085f:	cmp    $0xfffffffffffffffe,%rax
  6d0863:	je     6d0944 <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x3b4>
  6d0869:	mov    0x30(%rsp),%rcx
  6d086e:	movzbl 0x38(%rsp),%edx
  6d0873:	mov    0x3c(%rsp),%esi
  6d0877:	mov    %esi,0x34(%r14)
  6d087b:	mov    0x39(%rsp),%esi
  6d087f:	mov    %esi,0x31(%r14)
  6d0883:	movups 0x10(%rsp),%xmm0
  6d0888:	movups 0x20(%rsp),%xmm1
  6d088d:	mov    %rax,(%r14)
  6d0890:	movups %xmm0,0x8(%r14)
  6d0895:	movups %xmm1,0x18(%r14)
  6d089a:	mov    %rcx,0x28(%r14)
  6d089e:	mov    %dl,0x30(%r14)
  6d08a2:	jmp    6d06c4 <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x134>
  6d08a7:	mov    $0x11,%eax
  6d08ac:	mov    0x38(%rsp),%rcx
  6d08b1:	mov    %rcx,0x30(%r14)
  6d08b5:	movups 0x18(%rsp),%xmm0
  6d08ba:	movups 0x28(%rsp),%xmm1
  6d08bf:	movups %xmm1,0x20(%r14)
  6d08c4:	movups %xmm0,0x10(%r14)
  6d08c9:	mov    %rax,(%r14)
  6d08cc:	mov    %rdi,0x8(%r14)
  6d08d0:	jmp    6d06c4 <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x134>
  6d08d5:	movq   $0x4,0x40(%rsp)
  6d08de:	xorps  %xmm2,%xmm2
  6d08e1:	movups %xmm2,0x48(%rsp)
  6d08e6:	cmpq   $0x0,(%r15)
  6d08ea:	mov    %r12,0x8(%rsp)
  6d08ef:	mov    %r13,0x10(%rsp)
  6d08f4:	mov    0x40(%rsp),%rcx
  6d08f9:	mov    %rcx,0x18(%rsp)
  6d08fe:	mov    0x48(%rsp),%rcx
  6d0903:	mov    %rcx,0x20(%rsp)
  6d0908:	mov    0x50(%rsp),%rcx
  6d090d:	mov    %rcx,0x28(%rsp)
  6d0912:	mov    %rax,0x30(%rsp)
  6d0917:	setne  0x38(%rsp)
  6d091c:	lea    0x8(%rsp),%rsi
  6d0921:	mov    %rbx,%rdi
  6d0924:	call   6dd7a0 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE23inspector_pick_in_sheetB10_>
  6d0929:	test   %rax,%rax
  6d092c:	je     6d0944 <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x3b4>
  6d092e:	mov    %rdx,%rcx
  6d0931:	mov    %r14,%rdi
  6d0934:	mov    %rbx,%rsi
  6d0937:	mov    %rax,%rdx
  6d093a:	call   6df770 <_RNvMs4_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_10RuntimeMutNtCs4gijoeCAvqI_25inspector_pointer_control5ModeluE16inspector_selectB14_>
  6d093f:	jmp    6d06c4 <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x134>
  6d0944:	movq   $0x19,(%r14)
  6d094b:	jmp    6d06c4 <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x134>
  6d0950:	mov    0x610(%rbx),%r13
  6d0957:	mov    0x618(%rbx),%rbp
  6d095e:	lea    0x8(%rsp),%rdi
  6d0963:	mov    %rbx,%rsi
  6d0966:	mov    %r12,%rdx
  6d0969:	mov    %r15,%rcx
  6d096c:	call   6db6d0 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE5focusBW_>
  6d0971:	mov    0x8(%rsp),%rax
  6d0976:	cmp    $0xfffffffffffffffe,%rax
  6d097a:	jne    6d0869 <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x2d9>
  6d0980:	lea    0x58(%rsp),%rsi
  6d0985:	mov    %r14,%rdi
  6d0988:	mov    %r12,%rdx
  6d098b:	mov    %r15,%rcx
  6d098e:	mov    %r13,%r8
  6d0991:	mov    %rbp,%r9
  6d0994:	call   6d37a0 <_RNvMNtNtCs6ZNK6sH19NW_4gpui7runtime4turnINtB4_10RuntimeMutNtCs4gijoeCAvqI_25inspector_pointer_control5ModeluE16activate_focusedBW_>
  6d0999:	jmp    6d06c4 <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only+0x134>
  6d099e:	lea    0x32a653(%rip),%rdx        # 9faff8 <__frame_dummy_init_array_entry+0x11f8>
  6d09a5:	call   *0x348e95(%rip)        # a19840 <_DYNAMIC+0x270>

/tmp/gpui-inspector-pointer-codegen/candidate-frozen:     file format elf64-x86-64


Disassembly of section .text:

00000000006d09b0 <_RNvCs4gijoeCAvqI_25inspector_pointer_control3ack>:
  6d09b0:	push   %r14
  6d09b2:	push   %rbx
  6d09b3:	sub    $0x78,%rsp
  6d09b7:	test   %rdi,%rdi
  6d09ba:	je     6d09f5 <_RNvCs4gijoeCAvqI_25inspector_pointer_control3ack+0x45>
  6d09bc:	mov    %rdi,%rsi
  6d09bf:	cmpb   $0x0,0x746(%rdi)
  6d09c6:	jne    6d09fc <_RNvCs4gijoeCAvqI_25inspector_pointer_control3ack+0x4c>
  6d09c8:	mov    0x6a8(%rsi),%rdx
  6d09cf:	test   %rdx,%rdx
  6d09d2:	je     6d0a03 <_RNvCs4gijoeCAvqI_25inspector_pointer_control3ack+0x53>
  6d09d4:	mov    0x6b0(%rsi),%rcx
  6d09db:	lea    0x40(%rsp),%rdi
  6d09e0:	call   6e74b0 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE11acknowledgeBO_>
  6d09e5:	cmpq   $0xfffffffffffffffe,0x40(%rsp)
  6d09eb:	jne    6d0a3d <_RNvCs4gijoeCAvqI_25inspector_pointer_control3ack+0x8d>
  6d09ed:	add    $0x78,%rsp
  6d09f1:	pop    %rbx
  6d09f2:	pop    %r14
  6d09f4:	ret
  6d09f5:	mov    $0xd,%eax
  6d09fa:	jmp    6d0a08 <_RNvCs4gijoeCAvqI_25inspector_pointer_control3ack+0x58>
  6d09fc:	mov    $0xe,%eax
  6d0a01:	jmp    6d0a08 <_RNvCs4gijoeCAvqI_25inspector_pointer_control3ack+0x58>
  6d0a03:	mov    $0x14,%eax
  6d0a08:	mov    %rax,(%rsp)
  6d0a0c:	movq   $0x0,0x8(%rsp)
  6d0a15:	lea    -0x686282(%rip),%rdi        # 4a79a <GCC_except_table0+0xd022>
  6d0a1c:	lea    0x329ec5(%rip),%rcx        # 9fa8e8 <__frame_dummy_init_array_entry+0xae8>
  6d0a23:	lea    0x329cde(%rip),%r8        # 9fa708 <__frame_dummy_init_array_entry+0x908>
  6d0a2a:	mov    %rsp,%rbx
  6d0a2d:	mov    $0x2b,%esi
  6d0a32:	mov    %rbx,%rdx
  6d0a35:	call   *0x348e85(%rip)        # a198c0 <_DYNAMIC+0x2f0>
  6d0a3b:	jmp    6d0a8a <_RNvCs4gijoeCAvqI_25inspector_pointer_control3ack+0xda>
  6d0a3d:	mov    0x70(%rsp),%rax
  6d0a42:	mov    %rax,0x30(%rsp)
  6d0a47:	movups 0x40(%rsp),%xmm0
  6d0a4c:	movups 0x50(%rsp),%xmm1
  6d0a51:	movups 0x60(%rsp),%xmm2
  6d0a56:	movaps %xmm2,0x20(%rsp)
  6d0a5b:	movaps %xmm1,0x10(%rsp)
  6d0a60:	movaps %xmm0,(%rsp)
  6d0a64:	lea    -0x6862d1(%rip),%rdi        # 4a79a <GCC_except_table0+0xd022>
  6d0a6b:	lea    0x329e76(%rip),%rcx        # 9fa8e8 <__frame_dummy_init_array_entry+0xae8>
  6d0a72:	lea    0x329ca7(%rip),%r8        # 9fa720 <__frame_dummy_init_array_entry+0x920>
  6d0a79:	mov    %rsp,%rbx
  6d0a7c:	mov    $0x2b,%esi
  6d0a81:	mov    %rbx,%rdx
  6d0a84:	call   *0x348e36(%rip)        # a198c0 <_DYNAMIC+0x2f0>
  6d0a8a:	ud2
  6d0a8c:	jmp    6d0a8e <_RNvCs4gijoeCAvqI_25inspector_pointer_control3ack+0xde>
  6d0a8e:	mov    %rax,%r14
  6d0a91:	mov    %rbx,%rdi
  6d0a94:	call   6be470 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueNtNtCs6ZNK6sH19NW_4gpui7runtime5ErrorECs4gijoeCAvqI_25inspector_pointer_control>
  6d0a99:	mov    %r14,%rdi
  6d0a9c:	call   9f8a50 <_Unwind_Resume@plt>

/tmp/gpui-inspector-pointer-codegen/candidate-frozen:     file format elf64-x86-64


Disassembly of section .text:

00000000006d0ab0 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main>:
  6d0ab0:	push   %rbp
  6d0ab1:	push   %r15
  6d0ab3:	push   %r14
  6d0ab5:	push   %r13
  6d0ab7:	push   %r12
  6d0ab9:	push   %rbx
  6d0aba:	sub    $0xcf8,%rsp
  6d0ac1:	call   *0x348d51(%rip)        # a19818 <_DYNAMIC+0x248>
  6d0ac7:	mov    $0x6,%edi
  6d0acc:	mov    $0x1,%esi
  6d0ad1:	call   *0x348d49(%rip)        # a19820 <_DYNAMIC+0x250>
  6d0ad7:	test   %rax,%rax
  6d0ada:	je     6d21c6 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1716>
  6d0ae0:	mov    %rax,%rbx
  6d0ae3:	movw   $0x6863,0x4(%rax)
  6d0ae9:	movl   $0x72616573,(%rax)
  6d0aef:	lea    0x3c0(%rsp),%rdi
  6d0af7:	movabs $0x384000002d0,%r14
  6d0b01:	movss  -0x693359(%rip),%xmm0        # 3d7b0 <GCC_except_table0+0x38>
  6d0b09:	mov    %r14,%rsi
  6d0b0c:	call   *0x348f36(%rip)        # a19a48 <_DYNAMIC+0x478>
  6d0b12:	mov    0x3c0(%rsp),%r13
  6d0b1a:	cmp    $0xfffffffffffffffe,%r13
  6d0b1e:	jne    6d21d6 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1726>
  6d0b24:	movq   $0x0,0x3d8(%rsp)
  6d0b30:	movq   $0x8,0x3e0(%rsp)
  6d0b3c:	xorps  %xmm0,%xmm0
  6d0b3f:	movups %xmm0,0x3e8(%rsp)
  6d0b47:	movq   $0xffffffffffffffff,0x3c0(%rsp)
  6d0b53:	movq   $0x8,0x3f8(%rsp)
  6d0b5f:	movups %xmm0,0x400(%rsp)
  6d0b67:	movq   $0x8,0x410(%rsp)
  6d0b73:	movq   $0x0,0x418(%rsp)
  6d0b7f:	movq   $0x1,0x420(%rsp)
  6d0b8b:	mov    $0x1,%edi
  6d0b90:	call   *0x348eba(%rip)        # a19a50 <_DYNAMIC+0x480>
  6d0b96:	mov    %rax,%r13
  6d0b99:	cmp    $0x1,%r13d
  6d0b9d:	je     6d0bb3 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x103>
  6d0b9f:	movq   $0x0,0x3c0(%rsp)
  6d0bab:	mov    %r13,0x3c8(%rsp)
  6d0bb3:	call   *0x348c5f(%rip)        # a19818 <_DYNAMIC+0x248>
  6d0bb9:	mov    $0x28,%edi
  6d0bbe:	mov    $0x8,%esi
  6d0bc3:	call   *0x348c57(%rip)        # a19820 <_DYNAMIC+0x250>
  6d0bc9:	test   %rax,%rax
  6d0bcc:	je     6d1dd4 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1324>
  6d0bd2:	mov    %rax,%r15
  6d0bd5:	lea    0x3d8(%rsp),%r12
  6d0bdd:	mov    %r13,(%rax)
  6d0be0:	lea    -0x693373(%rip),%rax        # 3d874 <GCC_except_table0+0xfc>
  6d0be7:	mov    %rax,0x8(%r15)
  6d0beb:	movq   $0x4,0x10(%r15)
  6d0bf3:	lea    0x32c36(%rip),%rax        # 703830 <_RNvYNCNvXCs4gijoeCAvqI_25inspector_pointer_controlNtB7_5ModelNtCs6ZNK6sH19NW_4gpui4View7sources0INtNtNtCs4NRVxsYgnAr_4core3ops8function6FnOnceTRBM_EE9call_onceB7_>
  6d0bfa:	mov    %rax,0x18(%r15)
  6d0bfe:	lea    0x32c3b(%rip),%rax        # 703840 <_RNvYNCNvXCs4gijoeCAvqI_25inspector_pointer_controlNtB7_5ModelNtCs6ZNK6sH19NW_4gpui4View7sourcess_0INtNtNtCs4NRVxsYgnAr_4core3ops8function6FnOnceTQBM_EE9call_onceB7_>
  6d0c05:	mov    %rax,0x20(%r15)
  6d0c09:	mov    %r12,%rdi
  6d0c0c:	call   6dd8d0 <_RNvMs3_NtCscdodAO9FK5_5alloc7raw_vecINtB5_6RawVecAINtNtCs4NRVxsYgnAr_4core6option6OptionNtNtCs6ZNK6sH19NW_4gpui6source7FieldIdEj2_E8grow_oneCs4gijoeCAvqI_25inspector_pointer_control>
  6d0c11:	mov    0x3e0(%rsp),%rax
  6d0c19:	mov    %r15,(%rax)
  6d0c1c:	lea    0x3293e5(%rip),%rcx        # 9fa008 <__frame_dummy_init_array_entry+0x208>
  6d0c23:	mov    %rcx,0x8(%rax)
  6d0c27:	movq   $0x1,0x3e8(%rsp)
  6d0c33:	mov    0x3c0(%rsp),%rax
  6d0c3b:	movups 0x40(%r12),%xmm0
  6d0c41:	movaps %xmm0,0x160(%rsp)
  6d0c49:	movups (%r12),%xmm0
  6d0c4e:	movups 0x10(%r12),%xmm1
  6d0c54:	movups 0x20(%r12),%xmm2
  6d0c5a:	movups 0x30(%r12),%xmm3
  6d0c60:	movaps %xmm3,0x150(%rsp)
  6d0c68:	movaps %xmm2,0x140(%rsp)
  6d0c70:	movaps %xmm1,0x130(%rsp)
  6d0c78:	movups 0x3c8(%rsp),%xmm2
  6d0c80:	movups %xmm0,0xb8(%rsp)
  6d0c88:	movups %xmm1,0xc8(%rsp)
  6d0c90:	mov    0x140(%rsp),%rcx
  6d0c98:	mov    %rcx,0xd8(%rsp)
  6d0ca0:	movups 0x148(%rsp),%xmm0
  6d0ca8:	movups %xmm0,0xe0(%rsp)
  6d0cb0:	movups 0x158(%rsp),%xmm0
  6d0cb8:	movups %xmm0,0xf0(%rsp)
  6d0cc0:	mov    0x168(%rsp),%rcx
  6d0cc8:	mov    %rcx,0x100(%rsp)
  6d0cd0:	mov    %rax,0xa0(%rsp)
  6d0cd8:	movups %xmm2,0xa8(%rsp)
  6d0ce0:	movl   $0x0,0x120(%rsp)
  6d0ceb:	movl   $0x434b0000,0x128(%rsp)
  6d0cf6:	movw   $0x0,0x12c(%rsp)
  6d0d00:	lea    0x3c0(%rsp),%rdi
  6d0d08:	lea    0x120(%rsp),%rcx
  6d0d10:	mov    $0x2d0,%esi
  6d0d15:	mov    $0x384,%edx
  6d0d1a:	call   *0x348d38(%rip)        # a19a58 <_DYNAMIC+0x488>
  6d0d20:	mov    0x3c0(%rsp),%r13
  6d0d28:	mov    0x3c8(%rsp),%r15d
  6d0d30:	mov    0x3cc(%rsp),%r12d
  6d0d38:	cmp    $0x2,%r13
  6d0d3c:	je     6d221f <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x176f>
  6d0d42:	lea    0x3d0(%rsp),%rsi
  6d0d4a:	lea    0xb20(%rsp),%rdi
  6d0d52:	mov    $0x1d8,%edx
  6d0d57:	call   *0x348ad3(%rip)        # a19830 <memcpy@GLIBC_2.14>
  6d0d5d:	mov    %r13,0xb10(%rsp)
  6d0d65:	mov    %r15d,0xb18(%rsp)
  6d0d6d:	mov    %r12d,0xb1c(%rsp)
  6d0d75:	call   *0x348ce5(%rip)        # a19a60 <_DYNAMIC+0x490>
  6d0d7b:	mov    %rax,%r15
  6d0d7e:	lea    0x120(%rsp),%rdi
  6d0d86:	call   *0x348cdc(%rip)        # a19a68 <_DYNAMIC+0x498>
  6d0d8c:	movq   $0x6,0x660(%rsp)
  6d0d98:	movl   $0x0,0x668(%rsp)
  6d0da3:	movq   $0x0,0x670(%rsp)
  6d0daf:	movups 0xa0(%rsp),%xmm0
  6d0db7:	movups 0xb0(%rsp),%xmm1
  6d0dbf:	movups 0xc0(%rsp),%xmm2
  6d0dc7:	movups 0xd0(%rsp),%xmm3
  6d0dcf:	movups %xmm0,0x5e8(%rsp)
  6d0dd7:	movups %xmm1,0x5f8(%rsp)
  6d0ddf:	movups %xmm2,0x608(%rsp)
  6d0de7:	movups %xmm3,0x618(%rsp)
  6d0def:	movups 0xe0(%rsp),%xmm0
  6d0df7:	movups %xmm0,0x628(%rsp)
  6d0dff:	movups 0xf0(%rsp),%xmm0
  6d0e07:	movups %xmm0,0x638(%rsp)
  6d0e0f:	mov    0x100(%rsp),%rax
  6d0e17:	mov    %rax,0x648(%rsp)
  6d0e1f:	lea    0x6a8(%rsp),%rdi
  6d0e27:	lea    0x120(%rsp),%rsi
  6d0e2f:	mov    0x3489fa(%rip),%r12        # a19830 <memcpy@GLIBC_2.14>
  6d0e36:	mov    $0x298,%edx
  6d0e3b:	call   *%r12
  6d0e3e:	lea    0x3c0(%rsp),%rdi
  6d0e46:	lea    0xb10(%rsp),%rsi
  6d0e4e:	mov    $0x1e8,%edx
  6d0e53:	call   *%r12
  6d0e56:	movq   $0x6,0x650(%rsp)
  6d0e62:	mov    %rbx,0x658(%rsp)
  6d0e6a:	movq   $0x0,0x678(%rsp)
  6d0e76:	movq   $0x8,0x680(%rsp)
  6d0e82:	xorps  %xmm0,%xmm0
  6d0e85:	movups %xmm0,0x688(%rsp)
  6d0e8d:	movq   $0x8,0x698(%rsp)
  6d0e99:	movq   $0x0,0x6a0(%rsp)
  6d0ea5:	movq   $0x0,0x9c0(%rsp)
  6d0eb1:	movups %xmm0,0x5a8(%rsp)
  6d0eb9:	movups %xmm0,0x5b8(%rsp)
  6d0ec1:	movups %xmm0,0x9a8(%rsp)
  6d0ec9:	movq   $0x1,0x9c8(%rsp)
  6d0ed5:	movq   $0x0,0x9d0(%rsp)
  6d0ee1:	mov    %r15,0x998(%rsp)
  6d0ee9:	movq   $0x0,0x9e0(%rsp)
  6d0ef5:	movq   $0x0,0xa28(%rsp)
  6d0f01:	movups %xmm0,0x9f0(%rsp)
  6d0f09:	movq   $0x0,0xa00(%rsp)
  6d0f15:	movups %xmm0,0xa10(%rsp)
  6d0f1d:	movq   $0x0,0x940(%rsp)
  6d0f29:	movq   $0x8,0x948(%rsp)
  6d0f35:	movups %xmm0,0x950(%rsp)
  6d0f3d:	movq   $0x0,0xa30(%rsp)
  6d0f49:	movq   $0x0,0xa40(%rsp)
  6d0f55:	movl   $0x1000101,0xb00(%rsp)
  6d0f60:	movw   $0x0,0xb04(%rsp)
  6d0f6a:	movups %xmm0,0xa48(%rsp)
  6d0f72:	movq   $0x0,0xa58(%rsp)
  6d0f7e:	mov    %r14,0xa60(%rsp)
  6d0f86:	movsd  -0x692c7e(%rip),%xmm1        # 3e310 <GCC_except_table0+0xb98>
  6d0f8e:	movsd  %xmm1,0xaf8(%rsp)
  6d0f97:	movq   $0x1,0x9a0(%rsp)
  6d0fa3:	movq   $0xffffffffffffffff,0x970(%rsp)
  6d0faf:	movq   $0x0,0xa68(%rsp)
  6d0fbb:	movq   $0x0,0xa78(%rsp)
  6d0fc7:	movq   $0x8,0x960(%rsp)
  6d0fd3:	movq   $0x0,0x968(%rsp)
  6d0fdf:	movb   $0x0,0xb06(%rsp)
  6d0fe7:	movups %xmm0,0xae0(%rsp)
  6d0fef:	movups %xmm0,0xad0(%rsp)
  6d0ff7:	movups %xmm0,0xac0(%rsp)
  6d0fff:	movups %xmm0,0xab0(%rsp)
  6d1007:	movups %xmm0,0xaa0(%rsp)
  6d100f:	movups %xmm0,0xa90(%rsp)
  6d1017:	movups %xmm0,0xa80(%rsp)
  6d101f:	movq   $0x0,0xaf0(%rsp)
  6d102b:	call   *0x3487e7(%rip)        # a19818 <_DYNAMIC+0x248>
  6d1031:	mov    $0x748,%edi
  6d1036:	mov    $0x8,%esi
  6d103b:	call   *0x3487df(%rip)        # a19820 <_DYNAMIC+0x250>
  6d1041:	test   %rax,%rax
  6d1044:	je     6d1de9 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1339>
  6d104a:	mov    %rax,%rbx
  6d104d:	lea    0x3c0(%rsp),%rsi
  6d1055:	mov    $0x748,%edx
  6d105a:	mov    %rax,%rdi
  6d105d:	call   *0x3487cd(%rip)        # a19830 <memcpy@GLIBC_2.14>
  6d1063:	mov    %rbx,0x8(%rsp)
  6d1068:	lea    0x10(%rsp),%rdx
  6d106d:	movq   $0x0,(%rsp)
  6d1075:	lea    0x68(%rsp),%rdi
  6d107a:	mov    $0x8,%r8d
  6d1080:	mov    %rbx,%rsi
  6d1083:	mov    $0x1,%ecx
  6d1088:	xor    %r9d,%r9d
  6d108b:	call   6d6c60 <_RNvMNtNtCs6ZNK6sH19NW_4gpui7runtime4turnINtB4_10RuntimeMutNtCs4gijoeCAvqI_25inspector_pointer_control5ModeluE21describe_with_changedBW_>
  6d1090:	mov    0x68(%rsp),%r13
  6d1095:	cmp    $0xfffffffffffffffe,%r13
  6d1099:	jne    6d2143 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1693>
  6d109f:	lea    0x68(%rsp),%rdi
  6d10a4:	mov    %rbx,%rsi
  6d10a7:	call   6f8e20 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE7presentBO_>
  6d10ac:	mov    0x68(%rsp),%r13
  6d10b1:	cmp    $0xfffffffffffffffe,%r13
  6d10b5:	jne    6d2143 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1693>
  6d10bb:	mov    0x8(%rsp),%rdi
  6d10c0:	mov    %rdi,0x8(%rsp)
  6d10c5:	call   6d09b0 <_RNvCs4gijoeCAvqI_25inspector_pointer_control3ack>
  6d10ca:	mov    0x8(%rsp),%rbx
  6d10cf:	test   %rbx,%rbx
  6d10d2:	je     6d2254 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x17a4>
  6d10d8:	cmpb   $0x0,0x746(%rbx)
  6d10df:	jne    6d225b <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x17ab>
  6d10e5:	cmpb   $0x1,0x742(%rbx)
  6d10ec:	jne    6d2262 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x17b2>
  6d10f2:	mov    0x5a8(%rbx),%r13
  6d10f9:	mov    $0x1a,%eax
  6d10fe:	mov    %rax,0x10(%rsp)
  6d1103:	test   %r13,%r13
  6d1106:	je     6d226c <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x17bc>
  6d110c:	mov    0x5a0(%rbx),%rbp
  6d1113:	shl    $0x6,%r13
  6d1117:	lea    0x1e8(%rbx),%r14
  6d111e:	xor    %r12d,%r12d
  6d1121:	mov    0x348778(%rip),%r15        # a198a0 <_DYNAMIC+0x2d0>
  6d1128:	jmp    6d113d <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x68d>
  6d112a:	nopw   0x0(%rax,%rax,1)
  6d1130:	add    $0x40,%r12
  6d1134:	cmp    %r12,%r13
  6d1137:	je     6d226c <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x17bc>
  6d113d:	cmpb   $0x4,0x3d(%rbp,%r12,1)
  6d1143:	jne    6d1130 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x680>
  6d1145:	mov    0x20(%rbp,%r12,1),%rsi
  6d114a:	mov    %r14,%rdi
  6d114d:	call   *%r15
  6d1150:	test   %al,%al
  6d1152:	je     6d1130 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x680>
  6d1154:	mov    0x20(%rbp,%r12,1),%rsi
  6d1159:	add    $0x5d8,%rbx
  6d1160:	mov    %rbx,%rdi
  6d1163:	call   *0x3488a7(%rip)        # a19a10 <_DYNAMIC+0x440>
  6d1169:	mov    %rax,%r14
  6d116c:	lea    0x10(%rsp),%rax
  6d1171:	mov    0x8(%rsp),%r15
  6d1176:	test   %r15,%r15
  6d1179:	je     6d22b2 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1802>
  6d117f:	mov    %r15,0xa0(%rsp)
  6d1187:	mov    %rax,0xa8(%rsp)
  6d118f:	cmpb   $0x1,0x746(%r15)
  6d1197:	je     6d22cf <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x181f>
  6d119d:	cmp    0x5d8(%r15),%r14
  6d11a4:	jne    6d22e0 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1830>
  6d11aa:	mov    %rdx,%rbx
  6d11ad:	lea    0x3c0(%rsp),%rdi
  6d11b5:	mov    %r15,%rsi
  6d11b8:	call   6f8950 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE16resolve_identityBO_>
  6d11bd:	mov    0x3c0(%rsp),%rax
  6d11c5:	cmp    $0xfffffffffffffffe,%rax
  6d11c9:	jne    6d22e7 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1837>
  6d11cf:	cmpb   $0x1,0x742(%r15)
  6d11d7:	jne    6d2121 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1671>
  6d11dd:	cmpb   $0x0,0x743(%r15)
  6d11e5:	jne    6d2121 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1671>
  6d11eb:	cmpb   $0x0,0x744(%r15)
  6d11f3:	je     6d2121 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1671>
  6d11f9:	cmpq   $0xffffffffffffffff,0x5b0(%r15)
  6d1201:	jne    6d2121 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1671>
  6d1207:	mov    0x688(%r15),%rax
  6d120e:	cmp    0x690(%r15),%rax
  6d1215:	jne    6d2121 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1671>
  6d121b:	mov    0x6a0(%r15),%rax
  6d1222:	cmp    0x698(%r15),%rax
  6d1229:	jne    6d2121 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1671>
  6d122f:	movss  0x738(%r15),%xmm0
  6d1238:	ucomiss 0x73c(%r15),%xmm0
  6d1240:	jne    6d2121 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1671>
  6d1246:	jp     6d2121 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1671>
  6d124c:	mov    0x5a0(%r15),%r12
  6d1253:	mov    0x5a8(%r15),%rax
  6d125a:	lea    -0x38(%r12),%rcx
  6d125f:	shl    $0x6,%rax
  6d1263:	neg    %rax
  6d1266:	xor    %ebp,%ebp
  6d1268:	nopl   0x0(%rax,%rax,1)
  6d1270:	cmp    %rbp,%rax
  6d1273:	je     6d2098 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x15e8>
  6d1279:	add    $0xffffffffffffffc0,%rbp
  6d127d:	lea    0x40(%rcx),%r13
  6d1281:	cmp    %rbx,0x58(%rcx)
  6d1285:	mov    %r13,%rcx
  6d1288:	jne    6d1270 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x7c0>
  6d128a:	mov    0x638(%r15),%rax
  6d1291:	test   %rax,%rax
  6d1294:	je     6d12b2 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x802>
  6d1296:	mov    0x100(%rax),%rsi
  6d129d:	test   %rsi,%rsi
  6d12a0:	je     6d12b2 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x802>
  6d12a2:	lea    0x120(%rsp),%rdi
  6d12aa:	call   *0x348790(%rip)        # a19a40 <_DYNAMIC+0x470>
  6d12b0:	jmp    6d12c9 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x819>
  6d12b2:	movq   $0x4,0x120(%rsp)
  6d12be:	xorps  %xmm0,%xmm0
  6d12c1:	movups %xmm0,0x128(%rsp)
  6d12c9:	lea    0x120(%rsp),%rdi
  6d12d1:	call   *0x348799(%rip)        # a19a70 <_DYNAMIC+0x4a0>
  6d12d7:	mov    %rdx,%rcx
  6d12da:	sub    %rbp,%r12
  6d12dd:	lea    -0x40(%r12),%rsi
  6d12e2:	lea    0x3c0(%rsp),%rdi
  6d12ea:	mov    %rax,%rdx
  6d12ed:	call   *0x348785(%rip)        # a19a78 <_DYNAMIC+0x4a8>
  6d12f3:	cmpb   $0x0,0x3c0(%rsp)
  6d12fb:	je     6d1345 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x895>
  6d12fd:	lea    0x3c4(%rsp),%rsi
  6d1305:	movss  0x0(%r13),%xmm0
  6d130b:	movss  0x4(%r13),%xmm1
  6d1311:	lea    0x68(%rsp),%rdi
  6d1316:	call   6cea10 <_RNCNvMss_NtCs6ZNK6sH19NW_4gpui7runtimeINtB7_3WinNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE5clicks_0BM_>
  6d131b:	cmpl   $0x1,0x68(%rsp)
  6d1320:	jne    6d1345 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x895>
  6d1322:	movsd  0x6c(%rsp),%xmm0
  6d1328:	movaps %xmm0,%xmm1
  6d132b:	shufps $0x55,%xmm0,%xmm1
  6d132f:	add    $0xffffffffffffffd0,%r12
  6d1333:	mov    %r12,%rdi
  6d1336:	movaps %xmm0,0x10(%rsp)
  6d133b:	call   *0x34873f(%rip)        # a19a80 <_DYNAMIC+0x4b0>
  6d1341:	test   %al,%al
  6d1343:	jne    6d1382 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x8d2>
  6d1345:	movss  0x10(%r13),%xmm0
  6d134b:	xorps  %xmm2,%xmm2
  6d134e:	ucomiss %xmm2,%xmm0
  6d1351:	jne    6d1359 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x8a9>
  6d1353:	jnp    6d2132 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1682>
  6d1359:	movss  0x14(%r13),%xmm1
  6d135f:	ucomiss %xmm2,%xmm1
  6d1362:	jne    6d136a <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x8ba>
  6d1364:	jnp    6d2132 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1682>
  6d136a:	unpcklps %xmm1,%xmm0
  6d136d:	mulps  -0x692714(%rip),%xmm0        # 3ec60 <GCC_except_table0+0x14e8>
  6d1374:	movsd  0x8(%r13),%xmm1
  6d137a:	addps  %xmm0,%xmm1
  6d137d:	movaps %xmm1,0x10(%rsp)
  6d1382:	movq   $0x19,0x3c0(%rsp)
  6d138e:	lea    0x3c0(%rsp),%rdi
  6d1396:	call   6be470 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueNtNtCs6ZNK6sH19NW_4gpui7runtime5ErrorECs4gijoeCAvqI_25inspector_pointer_control>
  6d139b:	movaps 0x10(%rsp),%xmm0
  6d13a0:	movaps %xmm0,%xmm1
  6d13a3:	shufps $0x55,%xmm0,%xmm1
  6d13a7:	mov    %r15,%rdi
  6d13aa:	movaps %xmm1,0x30(%rsp)
  6d13af:	call   6f8c30 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_>
  6d13b4:	movq   $0x19,0x3c0(%rsp)
  6d13c0:	test   $0x1,%al
  6d13c2:	je     6d2132 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1682>
  6d13c8:	mov    %rdx,%r12
  6d13cb:	lea    0x3c0(%rsp),%rdi
  6d13d3:	call   6be470 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueNtNtCs6ZNK6sH19NW_4gpui7runtime5ErrorECs4gijoeCAvqI_25inspector_pointer_control>
  6d13d8:	cmp    %rbx,%r12
  6d13db:	jne    6d2132 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1682>
  6d13e1:	cmp    0x5d8(%r15),%r14
  6d13e8:	jne    6d2364 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x18b4>
  6d13ee:	lea    0x3c0(%rsp),%rdi
  6d13f6:	mov    %r15,%rsi
  6d13f9:	mov    %rbx,%rdx
  6d13fc:	call   6f8950 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE16resolve_identityBO_>
  6d1401:	mov    0x3c0(%rsp),%rax
  6d1409:	mov    0x3c8(%rsp),%r12
  6d1411:	cmp    $0xfffffffffffffffe,%rax
  6d1415:	jne    6d2369 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x18b9>
  6d141b:	mov    0x2c8(%r15),%rsi
  6d1422:	cmp    %rsi,%r12
  6d1425:	jae    6d23ae <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x18fe>
  6d142b:	mov    0x2c0(%r15),%rax
  6d1432:	lea    (%r12,%r12,4),%rcx
  6d1436:	mov    0x20(%rax,%rcx,8),%edi
  6d143a:	call   6e2030 <_RNvMsh_NtCs6ZNK6sH19NW_4gpui7runtimeNtB5_4Node4kind>
  6d143f:	cmp    $0x4,%al
  6d1441:	jne    6d1468 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x9b8>
  6d1443:	lea    0x120(%rsp),%rdi
  6d144b:	mov    %r15,%rsi
  6d144e:	mov    %r14,%rdx
  6d1451:	mov    %rbx,%rcx
  6d1454:	movaps 0x10(%rsp),%xmm0
  6d1459:	movaps 0x30(%rsp),%xmm1
  6d145e:	xor    %r8d,%r8d
  6d1461:	call   6dba50 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime7editingINtB7_10RuntimeMutNtCs4gijoeCAvqI_25inspector_pointer_control5ModeluE14select_pointerB12_>
  6d1466:	jmp    6d14bb <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0xa0b>
  6d1468:	mov    0x610(%r15),%r12
  6d146f:	mov    0x618(%r15),%r13
  6d1476:	lea    0x3c0(%rsp),%rdi
  6d147e:	mov    %r15,%rsi
  6d1481:	mov    %r14,%rdx
  6d1484:	mov    %rbx,%rcx
  6d1487:	call   6db6d0 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE5focusBW_>
  6d148c:	mov    0x3c0(%rsp),%rax
  6d1494:	cmp    $0xfffffffffffffffe,%rax
  6d1498:	jne    6d14cb <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0xa1b>
  6d149a:	lea    0x120(%rsp),%rdi
  6d14a2:	lea    0xa0(%rsp),%rsi
  6d14aa:	mov    %r14,%rdx
  6d14ad:	mov    %rbx,%rcx
  6d14b0:	mov    %r12,%r8
  6d14b3:	mov    %r13,%r9
  6d14b6:	call   6d37a0 <_RNvMNtNtCs6ZNK6sH19NW_4gpui7runtime4turnINtB4_10RuntimeMutNtCs4gijoeCAvqI_25inspector_pointer_control5ModeluE16activate_focusedBW_>
  6d14bb:	cmpq   $0xfffffffffffffffe,0x120(%rsp)
  6d14c4:	je     6d153d <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0xa8d>
  6d14c6:	jmp    6d20a4 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x15f4>
  6d14cb:	mov    0x3e8(%rsp),%rcx
  6d14d3:	movzbl 0x3f0(%rsp),%edx
  6d14db:	mov    0x3f1(%rsp),%esi
  6d14e2:	mov    %esi,0x151(%rsp)
  6d14e9:	mov    0x3f4(%rsp),%esi
  6d14f0:	mov    %esi,0x154(%rsp)
  6d14f7:	movups 0x3c8(%rsp),%xmm0
  6d14ff:	movups 0x3d8(%rsp),%xmm1
  6d1507:	mov    %rax,0x120(%rsp)
  6d150f:	movups %xmm0,0x128(%rsp)
  6d1517:	movups %xmm1,0x138(%rsp)
  6d151f:	mov    %rcx,0x148(%rsp)
  6d1527:	mov    %dl,0x150(%rsp)
  6d152e:	cmpq   $0xfffffffffffffffe,0x120(%rsp)
  6d1537:	jne    6d20a4 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x15f4>
  6d153d:	mov    0x8(%rsp),%rdi
  6d1542:	call   6d09b0 <_RNvCs4gijoeCAvqI_25inspector_pointer_control3ack>
  6d1547:	movsd  -0x69313f(%rip),%xmm0        # 3e410 <GCC_except_table0+0xc98>
  6d154f:	movsd  %xmm0,0x3c0(%rsp)
  6d1558:	lea    0x3c0(%rsp),%rax
  6d1560:	mov    0x8(%rsp),%rbp
  6d1565:	test   %rbp,%rbp
  6d1568:	je     6d23bf <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x190f>
  6d156e:	cmpb   $0x0,0x746(%rbp)
  6d1575:	jne    6d23c6 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1916>
  6d157b:	mov    $0x12,%eax
  6d1580:	cmpb   $0x1,0x742(%rbp)
  6d1587:	jne    6d23cb <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x191b>
  6d158d:	cmpb   $0x0,0x743(%rbp)
  6d1594:	jne    6d23cb <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x191b>
  6d159a:	cmpb   $0x0,0x744(%rbp)
  6d15a1:	je     6d23cb <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x191b>
  6d15a7:	cmpq   $0xffffffffffffffff,0x5b0(%rbp)
  6d15af:	jne    6d23cb <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x191b>
  6d15b5:	mov    0x688(%rbp),%rcx
  6d15bc:	cmp    0x690(%rbp),%rcx
  6d15c3:	jne    6d23cb <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x191b>
  6d15c9:	mov    0x6a0(%rbp),%rbx
  6d15d0:	cmp    0x698(%rbp),%rbx
  6d15d7:	jne    6d23cb <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x191b>
  6d15dd:	movss  0x738(%rbp),%xmm0
  6d15e5:	ucomiss 0x73c(%rbp),%xmm0
  6d15ec:	jne    6d23cb <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x191b>
  6d15f2:	jp     6d23cb <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x191b>
  6d15f8:	movsd  0x3c0(%rsp),%xmm0
  6d1601:	movaps %xmm0,0x40(%rsp)
  6d1606:	mov    0x6c0(%rbp),%rax
  6d160d:	mov    %rax,0x50(%rsp)
  6d1612:	mov    0x5a0(%rbp),%rax
  6d1619:	mov    %rax,0x10(%rsp)
  6d161e:	mov    0x5a8(%rbp),%r12
  6d1625:	movups 0x610(%rbp),%xmm0
  6d162c:	movaps %xmm0,0x30(%rsp)
  6d1631:	mov    0x638(%rbp),%r13
  6d1638:	test   %r13,%r13
  6d163b:	je     6d1689 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0xbd9>
  6d163d:	mov    0xe0(%r13),%rax
  6d1644:	test   %rax,%rax
  6d1647:	je     6d16a8 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0xbf8>
  6d1649:	mov    0x38(%rax),%ecx
  6d164c:	mov    %ecx,0xb20(%rsp)
  6d1653:	movups 0x28(%rax),%xmm0
  6d1657:	movaps %xmm0,0xb10(%rsp)
  6d165f:	movzbl 0x3c(%rax),%r15d
  6d1664:	movzbl 0x3f(%rax),%ecx
  6d1668:	mov    %cl,0xa2(%rsp)
  6d166f:	movzwl 0x3d(%rax),%eax
  6d1673:	mov    %ax,0xa0(%rsp)
  6d167b:	mov    0x100(%r13),%rsi
  6d1682:	test   %rsi,%rsi
  6d1685:	jne    6d16b7 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0xc07>
  6d1687:	jmp    6d168c <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0xbdc>
  6d1689:	mov    $0x2,%r15b
  6d168c:	movq   $0x4,0x120(%rsp)
  6d1698:	xorps  %xmm0,%xmm0
  6d169b:	movups %xmm0,0x128(%rsp)
  6d16a3:	mov    %r12,%r14
  6d16a6:	jmp    6d16cc <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0xc1c>
  6d16a8:	mov    $0x2,%r15b
  6d16ab:	mov    0x100(%r13),%rsi
  6d16b2:	test   %rsi,%rsi
  6d16b5:	je     6d168c <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0xbdc>
  6d16b7:	lea    0x120(%rsp),%rdi
  6d16bf:	call   *0x34837b(%rip)        # a19a40 <_DYNAMIC+0x470>
  6d16c5:	mov    0x5a8(%rbp),%r14
  6d16cc:	lea    0x5d8(%rbp),%rax
  6d16d3:	mov    %rax,0x108(%rsp)
  6d16db:	mov    %rax,0x410(%rsp)
  6d16e3:	mov    0x50(%rsp),%rax
  6d16e8:	mov    %rax,0x3e0(%rsp)
  6d16f0:	mov    %rbx,0x3e8(%rsp)
  6d16f8:	mov    0x10(%rsp),%rax
  6d16fd:	mov    %rax,0x3d0(%rsp)
  6d1705:	mov    %r12,0x3d8(%rsp)
  6d170d:	movaps 0x30(%rsp),%xmm0
  6d1712:	movaps %xmm0,0x3c0(%rsp)
  6d171a:	mov    %r13,0x3f0(%rsp)
  6d1722:	mov    0x120(%rsp),%rax
  6d172a:	mov    %rax,0x3f8(%rsp)
  6d1732:	mov    0x128(%rsp),%rax
  6d173a:	mov    %rax,0x400(%rsp)
  6d1742:	mov    0x130(%rsp),%rax
  6d174a:	mov    %rax,0x408(%rsp)
  6d1752:	movaps 0xb10(%rsp),%xmm0
  6d175a:	movups %xmm0,0x418(%rsp)
  6d1762:	mov    0xb20(%rsp),%eax
  6d1769:	mov    %eax,0x428(%rsp)
  6d1770:	mov    %r15b,0x42c(%rsp)
  6d1778:	movzwl 0xa0(%rsp),%eax
  6d1780:	mov    %ax,0x42d(%rsp)
  6d1788:	movzbl 0xa2(%rsp),%eax
  6d1790:	mov    %al,0x42f(%rsp)
  6d1797:	test   %r14,%r14
  6d179a:	je     6d21bc <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x170c>
  6d17a0:	movaps 0x40(%rsp),%xmm0
  6d17a5:	shufps $0x55,%xmm0,%xmm0
  6d17a9:	movaps %xmm0,0x50(%rsp)
  6d17ae:	mov    $0x20,%r13d
  6d17b4:	xor    %r12d,%r12d
  6d17b7:	lea    0x3c0(%rsp),%r15
  6d17bf:	mov    0x3482c2(%rip),%rbx        # a19a88 <_DYNAMIC+0x4b8>
  6d17c6:	lea    0x32920b(%rip),%rax        # 9fa9d8 <__frame_dummy_init_array_entry+0xbd8>
  6d17cd:	mov    %rax,0x60(%rsp)
  6d17d2:	movq   $0x0,0x30(%rsp)
  6d17db:	movq   $0x0,0x10(%rsp)
  6d17e4:	jmp    6d180c <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0xd5c>
  6d17e6:	mov    0x5a0(%rbp),%rax
  6d17ed:	incq   0x10(%rsp)
  6d17f2:	mov    (%rax,%r13,1),%rax
  6d17f6:	mov    %rax,0x30(%rsp)
  6d17fb:	nopl   0x0(%rax,%rax,1)
  6d1800:	inc    %r12
  6d1803:	add    $0x40,%r13
  6d1807:	cmp    %r12,%r14
  6d180a:	je     6d185b <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0xdab>
  6d180c:	mov    %r15,%rdi
  6d180f:	mov    %r12,%rsi
  6d1812:	call   *%rbx
  6d1814:	test   %rax,%rax
  6d1817:	setne  %cl
  6d181a:	cmp    $0x5,%rdx
  6d181e:	sete   %dl
  6d1821:	and    %cl,%dl
  6d1823:	cmp    $0x1,%dl
  6d1826:	jne    6d1800 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0xd50>
  6d1828:	mov    (%rax),%ecx
  6d182a:	mov    $0x63656863,%edx
  6d182f:	xor    %edx,%ecx
  6d1831:	movzbl 0x4(%rax),%eax
  6d1835:	xor    $0x6b,%eax
  6d1838:	or     %ecx,%eax
  6d183a:	jne    6d1800 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0xd50>
  6d183c:	mov    0x5a8(%rbp),%rsi
  6d1843:	cmp    %rsi,%r12
  6d1846:	jb     6d17e6 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0xd36>
  6d1848:	mov    %r12,%rdi
  6d184b:	mov    0x60(%rsp),%rdx
  6d1850:	call   *0x347fea(%rip)        # a19840 <_DYNAMIC+0x270>
  6d1856:	jmp    6d25c0 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b10>
  6d185b:	mov    0x10(%rsp),%rcx
  6d1860:	cmp    $0x1,%rcx
  6d1864:	jne    6d21ae <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x16fe>
  6d186a:	mov    0x108(%rsp),%rdi
  6d1872:	mov    0x30(%rsp),%rsi
  6d1877:	call   *0x348193(%rip)        # a19a10 <_DYNAMIC+0x440>
  6d187d:	mov    %rax,%r14
  6d1880:	mov    %rdx,%rbx
  6d1883:	lea    0x8(%rsp),%rax
  6d1888:	mov    %rax,0x3c0(%rsp)
  6d1890:	lea    0x3c0(%rsp),%r12
  6d1898:	mov    0x3c0(%rsp),%rax
  6d18a0:	mov    (%rax),%rsi
  6d18a3:	lea    0x120(%rsp),%rdi
  6d18ab:	movaps 0x40(%rsp),%xmm0
  6d18b0:	movaps 0x50(%rsp),%xmm1
  6d18b5:	call   6d35f0 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8hit_only>
  6d18ba:	cmpl   $0xfffffffe,0x120(%rsp)
  6d18c2:	jne    6d1dfe <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x134e>
  6d18c8:	mov    0x128(%rsp),%rdx
  6d18d0:	mov    0x130(%rsp),%rax
  6d18d8:	mov    %rdx,0x3c0(%rsp)
  6d18e0:	mov    %rax,0x3c8(%rsp)
  6d18e8:	mov    %r14,0x110(%rsp)
  6d18f0:	mov    %rbx,0x118(%rsp)
  6d18f8:	cmp    %r14,%rdx
  6d18fb:	sete   %cl
  6d18fe:	test   %rdx,%rdx
  6d1901:	je     6d1d74 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x12c4>
  6d1907:	lea    0x328ea2(%rip),%rdx        # 9fa7b0 <__frame_dummy_init_array_entry+0x9b0>
  6d190e:	lea    0x110(%rsp),%r15
  6d1916:	test   %cl,%cl
  6d1918:	je     6d1ee6 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1436>
  6d191e:	cmp    %rbx,%rax
  6d1921:	jne    6d1ee6 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1436>
  6d1927:	movsd  -0x692f2f(%rip),%xmm0        # 3ea00 <GCC_except_table0+0x1288>
  6d192f:	movsd  %xmm0,0x3c0(%rsp)
  6d1938:	lea    0x3c0(%rsp),%r12
  6d1940:	movss  0x3c0(%rsp),%xmm0
  6d1949:	movss  0x3c4(%rsp),%xmm1
  6d1952:	mov    0x8(%rsp),%rsi
  6d1957:	lea    0x120(%rsp),%rdi
  6d195f:	call   6d35f0 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8hit_only>
  6d1964:	cmpl   $0xfffffffe,0x120(%rsp)
  6d196c:	jne    6d1e6b <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x13bb>
  6d1972:	movups 0x128(%rsp),%xmm0
  6d197a:	movaps %xmm0,0x3c0(%rsp)
  6d1982:	cmpq   $0x0,0x128(%rsp)
  6d198b:	jne    6d1ed8 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1428>
  6d1991:	mov    $0xffffffff,%eax
  6d1996:	mov    %rax,0xb10(%rsp)
  6d199e:	movq   $0x0,0xb18(%rsp)
  6d19aa:	movaps 0x40(%rsp),%xmm0
  6d19af:	movlps %xmm0,0x3c4(%rsp)
  6d19b7:	movl   $0x0,0x3c0(%rsp)
  6d19c2:	lea    0x3c0(%rsp),%rcx
  6d19ca:	lea    0x120(%rsp),%rdi
  6d19d2:	lea    0x8(%rsp),%rsi
  6d19d7:	lea    0xb10(%rsp),%rdx
  6d19df:	call   6d2680 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch>
  6d19e4:	cmpl   $0xfffffffe,0x120(%rsp)
  6d19ec:	jne    6d1d07 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1257>
  6d19f2:	movl   $0x2,0x3c0(%rsp)
  6d19fd:	lea    0x3c0(%rsp),%rcx
  6d1a05:	lea    0x120(%rsp),%rdi
  6d1a0d:	lea    0x8(%rsp),%rsi
  6d1a12:	lea    0xb10(%rsp),%rdx
  6d1a1a:	call   6d2680 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch>
  6d1a1f:	cmpl   $0xfffffffe,0x120(%rsp)
  6d1a27:	jne    6d1d07 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1257>
  6d1a2d:	movl   $0x3,0x3c0(%rsp)
  6d1a38:	lea    0x3c0(%rsp),%r15
  6d1a40:	lea    0x120(%rsp),%rdi
  6d1a48:	lea    0x8(%rsp),%rsi
  6d1a4d:	lea    0xb10(%rsp),%rdx
  6d1a55:	mov    %r15,%rcx
  6d1a58:	call   6d2680 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch>
  6d1a5d:	cmpl   $0xfffffffe,0x120(%rsp)
  6d1a65:	jne    6d1d07 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1257>
  6d1a6b:	mov    0x8(%rsp),%rsi
  6d1a70:	test   %rsi,%rsi
  6d1a73:	je     6d1ef6 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1446>
  6d1a79:	cmpq   $0x1,0x2b0(%rsi)
  6d1a81:	jne    6d1f3b <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x148b>
  6d1a87:	mov    %rsi,%rdi
  6d1a8a:	call   6d09b0 <_RNvCs4gijoeCAvqI_25inspector_pointer_control3ack>
  6d1a8f:	mov    0x8(%rsp),%rsi
  6d1a94:	lea    0x120(%rsp),%rdi
  6d1a9c:	movaps 0x40(%rsp),%xmm0
  6d1aa1:	movaps 0x50(%rsp),%xmm1
  6d1aa6:	call   6d35f0 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8hit_only>
  6d1aab:	cmpl   $0xfffffffe,0x120(%rsp)
  6d1ab3:	jne    6d1f55 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x14a5>
  6d1ab9:	mov    0x128(%rsp),%rdx
  6d1ac1:	mov    0x130(%rsp),%rax
  6d1ac9:	mov    %rdx,0xa0(%rsp)
  6d1ad1:	mov    %rax,0xa8(%rsp)
  6d1ad9:	mov    %r14,0x3c0(%rsp)
  6d1ae1:	mov    %rbx,0x3c8(%rsp)
  6d1ae9:	cmp    %r14,%rdx
  6d1aec:	sete   %cl
  6d1aef:	test   %rdx,%rdx
  6d1af2:	je     6d1d92 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x12e2>
  6d1af8:	lea    0x328d11(%rip),%rdx        # 9fa810 <__frame_dummy_init_array_entry+0xa10>
  6d1aff:	lea    0xa0(%rsp),%r12
  6d1b07:	test   %cl,%cl
  6d1b09:	je     6d1ee6 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1436>
  6d1b0f:	cmp    %rbx,%rax
  6d1b12:	jne    6d1ee6 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1436>
  6d1b18:	movaps 0x40(%rsp),%xmm0
  6d1b1d:	movlps %xmm0,0x3c0(%rsp)
  6d1b25:	lea    0x3c0(%rsp),%rax
  6d1b2d:	movss  0x3c0(%rsp),%xmm0
  6d1b36:	movss  0x3c4(%rsp),%xmm1
  6d1b3f:	lea    0x120(%rsp),%rbx
  6d1b47:	lea    0x8(%rsp),%rsi
  6d1b4c:	mov    %rbx,%rdi
  6d1b4f:	call   6d0590 <_RNvCs4gijoeCAvqI_25inspector_pointer_control10click_only>
  6d1b54:	cmpl   $0xfffffffe,0x120(%rsp)
  6d1b5c:	jne    6d1fc2 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1512>
  6d1b62:	mov    0x8(%rsp),%rdi
  6d1b67:	call   6d09b0 <_RNvCs4gijoeCAvqI_25inspector_pointer_control3ack>
  6d1b6c:	mov    0x8(%rsp),%rsi
  6d1b71:	test   %rsi,%rsi
  6d1b74:	je     6d202f <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x157f>
  6d1b7a:	cmpq   $0x2,0x2b0(%rsi)
  6d1b82:	jne    6d2074 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x15c4>
  6d1b88:	mov    0xb10(%rsp),%eax
  6d1b8f:	cmp    $0xffffffff,%eax
  6d1b92:	je     6d1bb2 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1102>
  6d1b94:	dec    %eax
  6d1b96:	mov    0xb14(%rsp),%ecx
  6d1b9d:	mov    %eax,0x124(%rsp)
  6d1ba4:	mov    %ecx,0x128(%rsp)
  6d1bab:	mov    $0x1,%eax
  6d1bb0:	jmp    6d1bb4 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1104>
  6d1bb2:	xor    %eax,%eax
  6d1bb4:	mov    %eax,0x120(%rsp)
  6d1bbb:	movl   $0x42500000,0x3c8(%rsp)
  6d1bc6:	movabs $0x4140000000000001,%rcx
  6d1bd0:	mov    %rcx,0x3c0(%rsp)
  6d1bd8:	movabs $0x4250000041400000,%rcx
  6d1be2:	cmp    %rcx,0x124(%rsp)
  6d1bea:	sete   %cl
  6d1bed:	test   %eax,%eax
  6d1bef:	je     6d1db0 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1300>
  6d1bf5:	test   %cl,%cl
  6d1bf7:	je     6d1dba <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x130a>
  6d1bfd:	movaps 0x40(%rsp),%xmm0
  6d1c02:	movss  %xmm0,0xa0(%rsp)
  6d1c0b:	movaps 0x50(%rsp),%xmm0
  6d1c10:	movss  %xmm0,0x120(%rsp)
  6d1c19:	lea    0xa0(%rsp),%rax
  6d1c21:	mov    %rax,0x3c0(%rsp)
  6d1c29:	mov    0x347e60(%rip),%rax        # a19a90 <_DYNAMIC+0x4c0>
  6d1c30:	mov    %rax,0x3c8(%rsp)
  6d1c38:	mov    %rbx,0x3d0(%rsp)
  6d1c40:	mov    %rax,0x3d8(%rsp)
  6d1c48:	lea    -0x692b3f(%rip),%rax        # 3f110 <GCC_except_table0+0x1998>
  6d1c4f:	mov    %rax,0x3e0(%rsp)
  6d1c57:	mov    0x347e3a(%rip),%rcx        # a19a98 <_DYNAMIC+0x4c8>
  6d1c5e:	mov    %rcx,0x3e8(%rsp)
  6d1c66:	mov    %rax,0x3f0(%rsp)
  6d1c6e:	mov    %rcx,0x3f8(%rsp)
  6d1c76:	lea    -0x692aa5(%rip),%rax        # 3f1d8 <GCC_except_table0+0x1a60>
  6d1c7d:	mov    %rax,0x400(%rsp)
  6d1c85:	mov    %rcx,0x408(%rsp)
  6d1c8d:	lea    -0x692cdc(%rip),%rax        # 3efb8 <GCC_except_table0+0x1840>
  6d1c94:	mov    %rax,0x410(%rsp)
  6d1c9c:	mov    %rcx,0x418(%rsp)
  6d1ca4:	lea    -0x6929e3(%rip),%rax        # 3f2c8 <GCC_except_table0+0x1b50>
  6d1cab:	mov    %rax,0x420(%rsp)
  6d1cb3:	mov    %rcx,0x428(%rsp)
  6d1cbb:	lea    -0x68989a(%rip),%rdi        # 48428 <GCC_except_table0+0xacb0>
  6d1cc2:	lea    0x3c0(%rsp),%rsi
  6d1cca:	call   *0x347dd0(%rip)        # a19aa0 <_DYNAMIC+0x4d0>
  6d1cd0:	mov    0x8(%rsp),%rbx
  6d1cd5:	test   %rbx,%rbx
  6d1cd8:	je     6d1cf5 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1245>
  6d1cda:	mov    %rbx,%rdi
  6d1cdd:	call   6b9860 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtCs6ZNK6sH19NW_4gpui7runtime7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelEEB1h_>
  6d1ce2:	mov    $0x748,%esi
  6d1ce7:	mov    $0x8,%edx
  6d1cec:	mov    %rbx,%rdi
  6d1cef:	call   *0x347b1b(%rip)        # a19810 <_DYNAMIC+0x240>
  6d1cf5:	add    $0xcf8,%rsp
  6d1cfc:	pop    %rbx
  6d1cfd:	pop    %r12
  6d1cff:	pop    %r13
  6d1d01:	pop    %r14
  6d1d03:	pop    %r15
  6d1d05:	pop    %rbp
  6d1d06:	ret
  6d1d07:	mov    0x150(%rsp),%rax
  6d1d0f:	mov    %rax,0x3f0(%rsp)
  6d1d17:	movups 0x120(%rsp),%xmm0
  6d1d1f:	movups 0x130(%rsp),%xmm1
  6d1d27:	movups 0x140(%rsp),%xmm2
  6d1d2f:	movaps %xmm2,0x3e0(%rsp)
  6d1d37:	movaps %xmm1,0x3d0(%rsp)
  6d1d3f:	movaps %xmm0,0x3c0(%rsp)
  6d1d47:	lea    -0x6875b4(%rip),%rdi        # 4a79a <GCC_except_table0+0xd022>
  6d1d4e:	lea    0x328b93(%rip),%rcx        # 9fa8e8 <__frame_dummy_init_array_entry+0xae8>
  6d1d55:	lea    0x328b44(%rip),%r8        # 9fa8a0 <__frame_dummy_init_array_entry+0xaa0>
  6d1d5c:	lea    0x3c0(%rsp),%rdx
  6d1d64:	mov    $0x2b,%esi
  6d1d69:	call   *0x347b51(%rip)        # a198c0 <_DYNAMIC+0x2f0>
  6d1d6f:	jmp    6d25c0 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b10>
  6d1d74:	xor    %ecx,%ecx
  6d1d76:	lea    0x328a33(%rip),%rdx        # 9fa7b0 <__frame_dummy_init_array_entry+0x9b0>
  6d1d7d:	lea    0x110(%rsp),%r15
  6d1d85:	test   %cl,%cl
  6d1d87:	jne    6d191e <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0xe6e>
  6d1d8d:	jmp    6d1ee6 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1436>
  6d1d92:	xor    %ecx,%ecx
  6d1d94:	lea    0x328a75(%rip),%rdx        # 9fa810 <__frame_dummy_init_array_entry+0xa10>
  6d1d9b:	lea    0xa0(%rsp),%r12
  6d1da3:	test   %cl,%cl
  6d1da5:	jne    6d1b0f <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x105f>
  6d1dab:	jmp    6d1ee6 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1436>
  6d1db0:	xor    %ecx,%ecx
  6d1db2:	test   %cl,%cl
  6d1db4:	jne    6d1bfd <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x114d>
  6d1dba:	lea    0x120(%rsp),%rdi
  6d1dc2:	lea    0x3c0(%rsp),%rsi
  6d1dca:	call   6c163b <_RINvNtCs4NRVxsYgnAr_4core9panicking13assert_failedINtNtB4_6option6OptionAmj2_EBM_ECs4gijoeCAvqI_25inspector_pointer_control>
  6d1dcf:	jmp    6d25c0 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b10>
  6d1dd4:	mov    $0x8,%edi
  6d1dd9:	mov    $0x28,%esi
  6d1dde:	call   *0x347a44(%rip)        # a19828 <_DYNAMIC+0x258>
  6d1de4:	jmp    6d25c0 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b10>
  6d1de9:	mov    $0x8,%edi
  6d1dee:	mov    $0x748,%esi
  6d1df3:	call   *0x347a2f(%rip)        # a19828 <_DYNAMIC+0x258>
  6d1df9:	jmp    6d25c0 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b10>
  6d1dfe:	mov    0x150(%rsp),%rax
  6d1e06:	mov    %rax,0x3f0(%rsp)
  6d1e0e:	movups 0x120(%rsp),%xmm0
  6d1e16:	movups 0x130(%rsp),%xmm1
  6d1e1e:	movups 0x140(%rsp),%xmm2
  6d1e26:	movaps %xmm2,0x3e0(%rsp)
  6d1e2e:	movaps %xmm1,0x3d0(%rsp)
  6d1e36:	movaps %xmm0,0x3c0(%rsp)
  6d1e3e:	lea    -0x6876ab(%rip),%rdi        # 4a79a <GCC_except_table0+0xd022>
  6d1e45:	lea    0x328a9c(%rip),%rcx        # 9fa8e8 <__frame_dummy_init_array_entry+0xae8>
  6d1e4c:	lea    0x328945(%rip),%r8        # 9fa798 <__frame_dummy_init_array_entry+0x998>
  6d1e53:	lea    0x3c0(%rsp),%rdx
  6d1e5b:	mov    $0x2b,%esi
  6d1e60:	call   *0x347a5a(%rip)        # a198c0 <_DYNAMIC+0x2f0>
  6d1e66:	jmp    6d25c0 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b10>
  6d1e6b:	mov    0x150(%rsp),%rax
  6d1e73:	mov    %rax,0x3f0(%rsp)
  6d1e7b:	movups 0x120(%rsp),%xmm0
  6d1e83:	movups 0x130(%rsp),%xmm1
  6d1e8b:	movups 0x140(%rsp),%xmm2
  6d1e93:	movaps %xmm2,0x3e0(%rsp)
  6d1e9b:	movaps %xmm1,0x3d0(%rsp)
  6d1ea3:	movaps %xmm0,0x3c0(%rsp)
  6d1eab:	lea    -0x687718(%rip),%rdi        # 4a79a <GCC_except_table0+0xd022>
  6d1eb2:	lea    0x328a2f(%rip),%rcx        # 9fa8e8 <__frame_dummy_init_array_entry+0xae8>
  6d1eb9:	lea    0x328908(%rip),%r8        # 9fa7c8 <__frame_dummy_init_array_entry+0x9c8>
  6d1ec0:	lea    0x3c0(%rsp),%rdx
  6d1ec8:	mov    $0x2b,%esi
  6d1ecd:	call   *0x3479ed(%rip)        # a198c0 <_DYNAMIC+0x2f0>
  6d1ed3:	jmp    6d25c0 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b10>
  6d1ed8:	lea    0x3289d9(%rip),%rdx        # 9fa8b8 <__frame_dummy_init_array_entry+0xab8>
  6d1edf:	lea    -0x6934c6(%rip),%r15        # 3ea20 <GCC_except_table0+0x12a8>
  6d1ee6:	mov    %r12,%rdi
  6d1ee9:	mov    %r15,%rsi
  6d1eec:	call   6c1673 <_RINvNtCs4NRVxsYgnAr_4core9panicking13assert_failedINtNtB4_6option6OptionNtNtCs6ZNK6sH19NW_4gpui8identity6TargetEBM_ECs4gijoeCAvqI_25inspector_pointer_control>
  6d1ef1:	jmp    6d25c0 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b10>
  6d1ef6:	movq   $0xd,0x3c0(%rsp)
  6d1f02:	movq   $0x0,0x3c8(%rsp)
  6d1f0e:	lea    -0x68777b(%rip),%rdi        # 4a79a <GCC_except_table0+0xd022>
  6d1f15:	lea    0x3289cc(%rip),%rcx        # 9fa8e8 <__frame_dummy_init_array_entry+0xae8>
  6d1f1c:	lea    0x3288bd(%rip),%r8        # 9fa7e0 <__frame_dummy_init_array_entry+0x9e0>
  6d1f23:	lea    0x3c0(%rsp),%rdx
  6d1f2b:	mov    $0x2b,%esi
  6d1f30:	call   *0x34798a(%rip)        # a198c0 <_DYNAMIC+0x2f0>
  6d1f36:	jmp    6d25c0 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b10>
  6d1f3b:	add    $0x2b0,%rsi
  6d1f42:	lea    0x32893f(%rip),%r9        # 9fa888 <__frame_dummy_init_array_entry+0xa88>
  6d1f49:	lea    -0x692e60(%rip),%rdx        # 3f0f0 <GCC_except_table0+0x1978>
  6d1f50:	jmp    6d2089 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x15d9>
  6d1f55:	mov    0x150(%rsp),%rax
  6d1f5d:	mov    %rax,0x3f0(%rsp)
  6d1f65:	movups 0x120(%rsp),%xmm0
  6d1f6d:	movups 0x130(%rsp),%xmm1
  6d1f75:	movups 0x140(%rsp),%xmm2
  6d1f7d:	movaps %xmm2,0x3e0(%rsp)
  6d1f85:	movaps %xmm1,0x3d0(%rsp)
  6d1f8d:	movaps %xmm0,0x3c0(%rsp)
  6d1f95:	lea    -0x687802(%rip),%rdi        # 4a79a <GCC_except_table0+0xd022>
  6d1f9c:	lea    0x328945(%rip),%rcx        # 9fa8e8 <__frame_dummy_init_array_entry+0xae8>
  6d1fa3:	lea    0x32884e(%rip),%r8        # 9fa7f8 <__frame_dummy_init_array_entry+0x9f8>
  6d1faa:	lea    0x3c0(%rsp),%rdx
  6d1fb2:	mov    $0x2b,%esi
  6d1fb7:	call   *0x347903(%rip)        # a198c0 <_DYNAMIC+0x2f0>
  6d1fbd:	jmp    6d25c0 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b10>
  6d1fc2:	mov    0x150(%rsp),%rax
  6d1fca:	mov    %rax,0x3f0(%rsp)
  6d1fd2:	movups 0x120(%rsp),%xmm0
  6d1fda:	movups 0x130(%rsp),%xmm1
  6d1fe2:	movups 0x140(%rsp),%xmm2
  6d1fea:	movaps %xmm2,0x3e0(%rsp)
  6d1ff2:	movaps %xmm1,0x3d0(%rsp)
  6d1ffa:	movaps %xmm0,0x3c0(%rsp)
  6d2002:	lea    -0x68786f(%rip),%rdi        # 4a79a <GCC_except_table0+0xd022>
  6d2009:	lea    0x3288d8(%rip),%rcx        # 9fa8e8 <__frame_dummy_init_array_entry+0xae8>
  6d2010:	lea    0x328811(%rip),%r8        # 9fa828 <__frame_dummy_init_array_entry+0xa28>
  6d2017:	lea    0x3c0(%rsp),%rdx
  6d201f:	mov    $0x2b,%esi
  6d2024:	call   *0x347896(%rip)        # a198c0 <_DYNAMIC+0x2f0>
  6d202a:	jmp    6d25c0 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b10>
  6d202f:	movq   $0xd,0x3c0(%rsp)
  6d203b:	movq   $0x0,0x3c8(%rsp)
  6d2047:	lea    -0x6878b4(%rip),%rdi        # 4a79a <GCC_except_table0+0xd022>
  6d204e:	lea    0x328893(%rip),%rcx        # 9fa8e8 <__frame_dummy_init_array_entry+0xae8>
  6d2055:	lea    0x3287e4(%rip),%r8        # 9fa840 <__frame_dummy_init_array_entry+0xa40>
  6d205c:	lea    0x3c0(%rsp),%rdx
  6d2064:	mov    $0x2b,%esi
  6d2069:	call   *0x347851(%rip)        # a198c0 <_DYNAMIC+0x2f0>
  6d206f:	jmp    6d25c0 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b10>
  6d2074:	add    $0x2b0,%rsi
  6d207b:	lea    0x3287ee(%rip),%r9        # 9fa870 <__frame_dummy_init_array_entry+0xa70>
  6d2082:	lea    -0x692ee9(%rip),%rdx        # 3f1a0 <GCC_except_table0+0x1a28>
  6d2089:	xor    %edi,%edi
  6d208b:	xor    %ecx,%ecx
  6d208d:	call   *0x347a15(%rip)        # a19aa8 <_DYNAMIC+0x4d8>
  6d2093:	jmp    6d25c0 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b10>
  6d2098:	movq   $0x11,0x120(%rsp)
  6d20a4:	mov    0x150(%rsp),%rax
  6d20ac:	mov    %rax,0x3f0(%rsp)
  6d20b4:	mov    0x120(%rsp),%rax
  6d20bc:	mov    0x128(%rsp),%rcx
  6d20c4:	movups 0x130(%rsp),%xmm0
  6d20cc:	movups 0x140(%rsp),%xmm1
  6d20d4:	movaps %xmm1,0x3e0(%rsp)
  6d20dc:	movaps %xmm0,0x3d0(%rsp)
  6d20e4:	mov    %rax,0x3c0(%rsp)
  6d20ec:	mov    %rcx,0x3c8(%rsp)
  6d20f4:	lea    -0x687961(%rip),%rdi        # 4a79a <GCC_except_table0+0xd022>
  6d20fb:	lea    0x3287e6(%rip),%rcx        # 9fa8e8 <__frame_dummy_init_array_entry+0xae8>
  6d2102:	lea    0x32865f(%rip),%r8        # 9fa768 <__frame_dummy_init_array_entry+0x968>
  6d2109:	lea    0x3c0(%rsp),%rdx
  6d2111:	mov    $0x2b,%esi
  6d2116:	call   *0x3477a4(%rip)        # a198c0 <_DYNAMIC+0x2f0>
  6d211c:	jmp    6d25c0 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b10>
  6d2121:	movq   $0x12,0x120(%rsp)
  6d212d:	jmp    6d20a4 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x15f4>
  6d2132:	movq   $0x19,0x120(%rsp)
  6d213e:	jmp    6d20a4 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x15f4>
  6d2143:	mov    0x70(%rsp),%r15
  6d2148:	movups 0x78(%rsp),%xmm0
  6d214d:	movaps %xmm0,0x10(%rsp)
  6d2152:	movups 0x88(%rsp),%xmm0
  6d215a:	movaps %xmm0,0x30(%rsp)
  6d215f:	movzbl 0x98(%rsp),%ebp
  6d2167:	mov    0x99(%rsp),%eax
  6d216e:	mov    %eax,0x28(%rsp)
  6d2172:	mov    0x9c(%rsp),%eax
  6d2179:	mov    %eax,0x2b(%rsp)
  6d217d:	mov    0x8(%rsp),%rbx
  6d2182:	test   %rbx,%rbx
  6d2185:	je     6d21a2 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x16f2>
  6d2187:	mov    %rbx,%rdi
  6d218a:	call   6b9860 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtCs6ZNK6sH19NW_4gpui7runtime7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelEEB1h_>
  6d218f:	mov    $0x748,%esi
  6d2194:	mov    $0x8,%edx
  6d2199:	mov    %rbx,%rdi
  6d219c:	call   *0x34766e(%rip)        # a19810 <_DYNAMIC+0x240>
  6d21a2:	mov    %r15,%r12
  6d21a5:	shr    $0x20,%r12
  6d21a9:	jmp    6d2245 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1795>
  6d21ae:	mov    $0x1b,%eax
  6d21b3:	test   %rcx,%rcx
  6d21b6:	jne    6d23cb <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x191b>
  6d21bc:	mov    $0x1a,%eax
  6d21c1:	jmp    6d23cb <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x191b>
  6d21c6:	mov    $0x1,%edi
  6d21cb:	mov    $0x6,%esi
  6d21d0:	call   *0x3476c2(%rip)        # a19898 <_DYNAMIC+0x2c8>
  6d21d6:	mov    0x3c8(%rsp),%r15
  6d21de:	mov    %r15,%r12
  6d21e1:	shr    $0x20,%r12
  6d21e5:	movups 0x3d0(%rsp),%xmm0
  6d21ed:	movaps %xmm0,0x10(%rsp)
  6d21f2:	movups 0x3e0(%rsp),%xmm0
  6d21fa:	movaps %xmm0,0x30(%rsp)
  6d21ff:	movzbl 0x3f0(%rsp),%ebp
  6d2207:	mov    0x3f1(%rsp),%eax
  6d220e:	mov    %eax,0x28(%rsp)
  6d2212:	mov    0x3f4(%rsp),%eax
  6d2219:	mov    %eax,0x2b(%rsp)
  6d221d:	jmp    6d2232 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1782>
  6d221f:	lea    0xa0(%rsp),%rdi
  6d2227:	call   6b96b0 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtCs6ZNK6sH19NW_4gpui6source7SourcesNtCs4gijoeCAvqI_25inspector_pointer_control5ModelEEB1g_>
  6d222c:	mov    $0x23,%r13d
  6d2232:	mov    $0x6,%esi
  6d2237:	mov    $0x1,%edx
  6d223c:	mov    %rbx,%rdi
  6d223f:	call   *0x3475cb(%rip)        # a19810 <_DYNAMIC+0x240>
  6d2245:	movaps 0x10(%rsp),%xmm0
  6d224a:	movaps 0x30(%rsp),%xmm1
  6d224f:	jmp    6d2550 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1aa0>
  6d2254:	mov    $0xd,%eax
  6d2259:	jmp    6d2267 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x17b7>
  6d225b:	mov    $0xe,%eax
  6d2260:	jmp    6d2267 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x17b7>
  6d2262:	mov    $0x12,%eax
  6d2267:	mov    %rax,0x10(%rsp)
  6d226c:	mov    0x10(%rsp),%rax
  6d2271:	mov    %rax,0x3c0(%rsp)
  6d2279:	movq   $0x0,0x3c8(%rsp)
  6d2285:	lea    -0x687b2a(%rip),%rdi        # 4a762 <GCC_except_table0+0xcfea>
  6d228c:	lea    0x328655(%rip),%rcx        # 9fa8e8 <__frame_dummy_init_array_entry+0xae8>
  6d2293:	lea    0x3284b6(%rip),%r8        # 9fa750 <__frame_dummy_init_array_entry+0x950>
  6d229a:	lea    0x3c0(%rsp),%rdx
  6d22a2:	mov    $0x2a,%esi
  6d22a7:	call   *0x347613(%rip)        # a198c0 <_DYNAMIC+0x2f0>
  6d22ad:	jmp    6d25c0 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b10>
  6d22b2:	movq   $0xd,0x120(%rsp)
  6d22be:	movq   $0x0,0x128(%rsp)
  6d22ca:	jmp    6d20a4 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x15f4>
  6d22cf:	movq   $0xe,0x120(%rsp)
  6d22db:	jmp    6d20a4 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x15f4>
  6d22e0:	mov    $0x11,%eax
  6d22e5:	jmp    6d231f <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x186f>
  6d22e7:	mov    0x3c8(%rsp),%rcx
  6d22ef:	movups 0x3d0(%rsp),%xmm0
  6d22f7:	movaps %xmm0,0xb10(%rsp)
  6d22ff:	movups 0x3e0(%rsp),%xmm0
  6d2307:	movaps %xmm0,0xb20(%rsp)
  6d230f:	mov    0x3f0(%rsp),%rdx
  6d2317:	mov    %rdx,0xb30(%rsp)
  6d231f:	mov    %rax,0x120(%rsp)
  6d2327:	mov    %rcx,0x128(%rsp)
  6d232f:	movaps 0xb10(%rsp),%xmm0
  6d2337:	movaps 0xb20(%rsp),%xmm1
  6d233f:	movups %xmm0,0x130(%rsp)
  6d2347:	movups %xmm1,0x140(%rsp)
  6d234f:	mov    0xb30(%rsp),%rax
  6d2357:	mov    %rax,0x150(%rsp)
  6d235f:	jmp    6d20a4 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x15f4>
  6d2364:	mov    $0x11,%eax
  6d2369:	mov    0x3f0(%rsp),%rcx
  6d2371:	mov    %rcx,0x150(%rsp)
  6d2379:	movups 0x3d0(%rsp),%xmm0
  6d2381:	movups 0x3e0(%rsp),%xmm1
  6d2389:	movups %xmm1,0x140(%rsp)
  6d2391:	movups %xmm0,0x130(%rsp)
  6d2399:	mov    %rax,0x120(%rsp)
  6d23a1:	mov    %r12,0x128(%rsp)
  6d23a9:	jmp    6d20a4 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x15f4>
  6d23ae:	lea    0x328c2b(%rip),%rax        # 9fafe0 <__frame_dummy_init_array_entry+0x11e0>
  6d23b5:	mov    %rax,0x60(%rsp)
  6d23ba:	jmp    6d1848 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0xd98>
  6d23bf:	mov    $0xd,%eax
  6d23c4:	jmp    6d23cb <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x191b>
  6d23c6:	mov    $0xe,%eax
  6d23cb:	mov    %rax,0x3c0(%rsp)
  6d23d3:	mov    0x10(%rsp),%rax
  6d23d8:	mov    %rax,0x3c8(%rsp)
  6d23e0:	lea    -0x687c4d(%rip),%rdi        # 4a79a <GCC_except_table0+0xd022>
  6d23e7:	lea    0x3284fa(%rip),%rcx        # 9fa8e8 <__frame_dummy_init_array_entry+0xae8>
  6d23ee:	lea    0x32838b(%rip),%r8        # 9fa780 <__frame_dummy_init_array_entry+0x980>
  6d23f5:	lea    0x3c0(%rsp),%rdx
  6d23fd:	mov    $0x2b,%esi
  6d2402:	call   *0x3474b8(%rip)        # a198c0 <_DYNAMIC+0x2f0>
  6d2408:	jmp    6d25c0 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b10>
  6d240d:	mov    %rax,%r14
  6d2410:	jmp    6d264b <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b9b>
  6d2415:	mov    %rax,%r14
  6d2418:	jmp    6d264b <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b9b>
  6d241d:	mov    %rax,%r14
  6d2420:	jmp    6d2484 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x19d4>
  6d2422:	mov    %rax,%r14
  6d2425:	lea    0x327bdc(%rip),%rsi        # 9fa008 <__frame_dummy_init_array_entry+0x208>
  6d242c:	mov    %r15,%rdi
  6d242f:	call   6baf40 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtCscdodAO9FK5_5alloc5boxed3BoxDG0_INtNtNtB4_3ops8function2FnTQL1_INtNtCs6ZNK6sH19NW_4gpui7element2ElL0_EEEp6OutputuEL_EECs4gijoeCAvqI_25inspector_pointer_control>
  6d2434:	jmp    6d24f6 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1a46>
  6d2439:	call   *0x3473f9(%rip)        # a19838 <_DYNAMIC+0x268>
  6d243f:	mov    %rax,%r14
  6d2442:	lea    0x3c0(%rsp),%rdi
  6d244a:	call   6b96b0 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtCs6ZNK6sH19NW_4gpui6source7SourcesNtCs4gijoeCAvqI_25inspector_pointer_control5ModelEEB1g_>
  6d244f:	jmp    6d2503 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1a53>
  6d2454:	call   *0x3473de(%rip)        # a19838 <_DYNAMIC+0x268>
  6d245a:	mov    %rax,%r14
  6d245d:	jmp    6d25dd <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b2d>
  6d2462:	mov    %rax,%r14
  6d2465:	mov    0x8(%rsp),%rdi
  6d246a:	call   6b9800 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtCs6ZNK6sH19NW_4gpui7runtime3WinNtCs4gijoeCAvqI_25inspector_pointer_control5ModelEEB1d_>
  6d246f:	jmp    6d263b <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b8b>
  6d2474:	mov    %rax,%r14
  6d2477:	lea    0xb10(%rsp),%rdi
  6d247f:	call   6bf0c0 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueNtNtCshdpBObOiWw8_11gpui_canvas6canvas6CanvasECs4gijoeCAvqI_25inspector_pointer_control>
  6d2484:	lea    0xa0(%rsp),%rdi
  6d248c:	call   6b96b0 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtCs6ZNK6sH19NW_4gpui6source7SourcesNtCs4gijoeCAvqI_25inspector_pointer_control5ModelEEB1g_>
  6d2491:	jmp    6d25dd <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b2d>
  6d2496:	jmp    6d262e <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b7e>
  6d249b:	call   *0x347397(%rip)        # a19838 <_DYNAMIC+0x268>
  6d24a1:	jmp    6d261c <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b6c>
  6d24a6:	jmp    6d262e <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b7e>
  6d24ab:	jmp    6d262e <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b7e>
  6d24b0:	jmp    6d261c <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b6c>
  6d24b5:	jmp    6d261c <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b6c>
  6d24ba:	jmp    6d261c <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b6c>
  6d24bf:	jmp    6d261c <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b6c>
  6d24c4:	jmp    6d261c <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b6c>
  6d24c9:	jmp    6d261c <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b6c>
  6d24ce:	jmp    6d261c <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b6c>
  6d24d3:	jmp    6d261c <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b6c>
  6d24d8:	mov    %rax,%r14
  6d24db:	lea    0x3c0(%rsp),%rdi
  6d24e3:	call   6b9860 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtCs6ZNK6sH19NW_4gpui7runtime7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelEEB1h_>
  6d24e8:	jmp    6d263b <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b8b>
  6d24ed:	call   *0x347345(%rip)        # a19838 <_DYNAMIC+0x268>
  6d24f3:	mov    %rax,%r14
  6d24f6:	lea    0x3c0(%rsp),%rdi
  6d24fe:	call   6b96b0 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtCs6ZNK6sH19NW_4gpui6source7SourcesNtCs4gijoeCAvqI_25inspector_pointer_control5ModelEEB1g_>
  6d2503:	mov    %r14,%rdi
  6d2506:	call   *0x3475a4(%rip)        # a19ab0 <_DYNAMIC+0x4e0>
  6d250c:	mov    %rax,%r15
  6d250f:	mov    %rdx,%r12
  6d2512:	mov    (%rdx),%rax
  6d2515:	test   %rax,%rax
  6d2518:	je     6d251f <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1a6f>
  6d251a:	mov    %r15,%rdi
  6d251d:	call   *%rax
  6d251f:	mov    0x8(%r12),%rsi
  6d2524:	test   %rsi,%rsi
  6d2527:	je     6d2537 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1a87>
  6d2529:	mov    0x10(%r12),%rdx
  6d252e:	mov    %r15,%rdi
  6d2531:	call   *0x3472d9(%rip)        # a19810 <_DYNAMIC+0x240>
  6d2537:	mov    $0x6,%esi
  6d253c:	mov    $0x1,%edx
  6d2541:	mov    %rbx,%rdi
  6d2544:	call   *0x3472c6(%rip)        # a19810 <_DYNAMIC+0x240>
  6d254a:	mov    $0xf,%r13d
  6d2550:	mov    %r13,0x120(%rsp)
  6d2558:	shl    $0x20,%r12
  6d255c:	mov    %r15d,%eax
  6d255f:	or     %r12,%rax
  6d2562:	mov    %rax,0x128(%rsp)
  6d256a:	movups %xmm0,0x130(%rsp)
  6d2572:	movups %xmm1,0x140(%rsp)
  6d257a:	mov    %bpl,0x150(%rsp)
  6d2582:	mov    0x28(%rsp),%eax
  6d2586:	mov    0x2b(%rsp),%ecx
  6d258a:	mov    %eax,0x151(%rsp)
  6d2591:	mov    %ecx,0x154(%rsp)
  6d2598:	lea    -0x687e05(%rip),%rdi        # 4a79a <GCC_except_table0+0xd022>
  6d259f:	lea    0x328342(%rip),%rcx        # 9fa8e8 <__frame_dummy_init_array_entry+0xae8>
  6d25a6:	lea    0x32818b(%rip),%r8        # 9fa738 <__frame_dummy_init_array_entry+0x938>
  6d25ad:	lea    0x120(%rsp),%rdx
  6d25b5:	mov    $0x2b,%esi
  6d25ba:	call   *0x347300(%rip)        # a198c0 <_DYNAMIC+0x2f0>
  6d25c0:	ud2
  6d25c2:	mov    %rax,%r14
  6d25c5:	mov    0x8(%r12),%rsi
  6d25ca:	test   %rsi,%rsi
  6d25cd:	je     6d25dd <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b2d>
  6d25cf:	mov    0x10(%r12),%rdx
  6d25d4:	mov    %r15,%rdi
  6d25d7:	call   *0x347233(%rip)        # a19810 <_DYNAMIC+0x240>
  6d25dd:	mov    $0x6,%esi
  6d25e2:	mov    $0x1,%edx
  6d25e7:	mov    %rbx,%rdi
  6d25ea:	call   *0x347220(%rip)        # a19810 <_DYNAMIC+0x240>
  6d25f0:	mov    %r14,%rdi
  6d25f3:	call   9f8a50 <_Unwind_Resume@plt>
  6d25f8:	mov    %rax,%r14
  6d25fb:	lea    0x120(%rsp),%rdi
  6d2603:	call   6be470 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueNtNtCs6ZNK6sH19NW_4gpui7runtime5ErrorECs4gijoeCAvqI_25inspector_pointer_control>
  6d2608:	mov    %r14,%rdi
  6d260b:	call   9f8a50 <_Unwind_Resume@plt>
  6d2610:	call   *0x3474a2(%rip)        # a19ab8 <_DYNAMIC+0x4e8>
  6d2616:	call   *0x34721c(%rip)        # a19838 <_DYNAMIC+0x268>
  6d261c:	mov    %rax,%r14
  6d261f:	lea    0x3c0(%rsp),%rdi
  6d2627:	call   6be470 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueNtNtCs6ZNK6sH19NW_4gpui7runtime5ErrorECs4gijoeCAvqI_25inspector_pointer_control>
  6d262c:	jmp    6d2631 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b81>
  6d262e:	mov    %rax,%r14
  6d2631:	mov    0x8(%rsp),%rbx
  6d2636:	test   %rbx,%rbx
  6d2639:	jne    6d2643 <_RNvCs4gijoeCAvqI_25inspector_pointer_control4main+0x1b93>
  6d263b:	mov    %r14,%rdi
  6d263e:	call   9f8a50 <_Unwind_Resume@plt>
  6d2643:	mov    %rbx,%rdi
  6d2646:	call   6b9860 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtCs6ZNK6sH19NW_4gpui7runtime7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelEEB1h_>
  6d264b:	mov    $0x748,%esi
  6d2650:	mov    $0x8,%edx
  6d2655:	mov    %rbx,%rdi
  6d2658:	call   *0x3471b2(%rip)        # a19810 <_DYNAMIC+0x240>
  6d265e:	mov    %r14,%rdi
  6d2661:	call   9f8a50 <_Unwind_Resume@plt>
  6d2666:	mov    $0x748,%esi
  6d266b:	mov    $0x8,%edx
  6d2670:	mov    %rbx,%rdi
  6d2673:	call   *0x347197(%rip)        # a19810 <_DYNAMIC+0x240>
  6d2679:	call   *0x3471b9(%rip)        # a19838 <_DYNAMIC+0x268>

/tmp/gpui-inspector-pointer-codegen/candidate-frozen:     file format elf64-x86-64


Disassembly of section .text:

00000000006d2680 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch>:
  6d2680:	push   %rbp
  6d2681:	push   %r15
  6d2683:	push   %r14
  6d2685:	push   %r13
  6d2687:	push   %r12
  6d2689:	push   %rbx
  6d268a:	sub    $0x178,%rsp
  6d2691:	mov    %rdx,%r14
  6d2694:	mov    %rdi,%rbx
  6d2697:	mov    (%rcx),%ebp
  6d2699:	test   %ebp,%ebp
  6d269b:	je     6d26d0 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x50>
  6d269d:	mov    0x8(%r14),%r12
  6d26a1:	mov    0x10(%r14),%r13
  6d26a5:	mov    0x18(%r14),%rax
  6d26a9:	movq   $0x0,0x8(%r14)
  6d26b1:	lea    -0x1(%rbp),%edx
  6d26b4:	lea    -0x69332b(%rip),%rdi        # 3f390 <GCC_except_table0+0x1c18>
  6d26bb:	movslq (%rdi,%rdx,4),%rdx
  6d26bf:	add    %rdi,%rdx
  6d26c2:	jmp    *%rdx
  6d26c4:	movl   $0xffffffff,(%r14)
  6d26cb:	jmp    6d2891 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x211>
  6d26d0:	movd   0x4(%rcx),%xmm1
  6d26d5:	movd   0x8(%rcx),%xmm0
  6d26da:	movd   %xmm1,%eax
  6d26de:	movd   %xmm0,%ecx
  6d26e2:	mov    %eax,%edx
  6d26e4:	and    $0x7fffffff,%edx
  6d26ea:	cmp    $0x7f800000,%edx
  6d26f0:	setge  %dl
  6d26f3:	and    $0x7fffffff,%ecx
  6d26f9:	cmp    $0x7f800000,%ecx
  6d26ff:	setge  %cl
  6d2702:	or     %dl,%cl
  6d2704:	je     6d271d <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x9d>
  6d2706:	movl   $0xffffffff,(%r14)
  6d270d:	movq   $0x0,0x8(%r14)
  6d2715:	xor    %r12d,%r12d
  6d2718:	jmp    6d2891 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x211>
  6d271d:	inc    %eax
  6d271f:	je     6d3182 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xb02>
  6d2725:	mov    %eax,(%r14)
  6d2728:	movd   %xmm0,0x4(%r14)
  6d272e:	xor    %r12d,%r12d
  6d2731:	jmp    6d2891 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x211>
  6d2736:	mov    (%r14),%r15d
  6d2739:	cmp    $0xffffffff,%r15d
  6d273d:	je     6d2891 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x211>
  6d2743:	mov    %rsi,%r13
  6d2746:	movups 0x8(%rcx),%xmm0
  6d274a:	movss  0x4(%r14),%xmm1
  6d2750:	movss  %xmm1,0xb0(%rsp)
  6d2759:	movaps %xmm0,%xmm1
  6d275c:	unpckhpd %xmm0,%xmm1
  6d2760:	mov    %rsp,%rdi
  6d2763:	movaps %xmm0,0x40(%rsp)
  6d2768:	call   *0x347352(%rip)        # a19ac0 <_DYNAMIC+0x4f0>
  6d276e:	cmpl   $0xfffffffe,(%rsp)
  6d2772:	jne    6d2b19 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x499>
  6d2778:	mov    0x0(%r13),%r14
  6d277c:	test   %r14,%r14
  6d277f:	je     6d28c3 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x243>
  6d2785:	cmpb   $0x1,0x746(%r14)
  6d278d:	je     6d28b7 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x237>
  6d2793:	cmpb   $0x1,0x742(%r14)
  6d279b:	jne    6d2c81 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x601>
  6d27a1:	cmpb   $0x0,0x743(%r14)
  6d27a9:	jne    6d2c81 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x601>
  6d27af:	cmpb   $0x0,0x744(%r14)
  6d27b7:	je     6d2c81 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x601>
  6d27bd:	cmpq   $0xffffffffffffffff,0x5b0(%r14)
  6d27c5:	jne    6d2c81 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x601>
  6d27cb:	mov    0x688(%r14),%rax
  6d27d2:	cmp    0x690(%r14),%rax
  6d27d9:	jne    6d2c81 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x601>
  6d27df:	mov    0x698(%r14),%rax
  6d27e6:	cmp    %rax,0x6a0(%r14)
  6d27ed:	jne    6d2c81 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x601>
  6d27f3:	movss  0x738(%r14),%xmm0
  6d27fc:	ucomiss 0x73c(%r14),%xmm0
  6d2804:	jne    6d2c81 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x601>
  6d280a:	jp     6d2c81 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x601>
  6d2810:	mov    %eax,%ecx
  6d2812:	cvtsi2ss %rcx,%xmm2
  6d2817:	dec    %r15d
  6d281a:	shr    $0x20,%rax
  6d281e:	mov    %eax,%eax
  6d2820:	xorps  %xmm1,%xmm1
  6d2823:	cvtsi2ss %rax,%xmm1
  6d2828:	movd   %r15d,%xmm0
  6d282d:	movq   $0x0,(%rsp)
  6d2835:	movss  %xmm2,0x8(%rsp)
  6d283b:	movss  %xmm1,0xc(%rsp)
  6d2841:	mov    %rsp,%rdi
  6d2844:	movd   %xmm0,0x38(%rsp)
  6d284a:	movss  0xb0(%rsp),%xmm1
  6d2853:	call   *0x347227(%rip)        # a19a80 <_DYNAMIC+0x4b0>
  6d2859:	test   %al,%al
  6d285b:	je     6d3176 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xaf6>
  6d2861:	mov    0x638(%r14),%rax
  6d2868:	test   %rax,%rax
  6d286b:	je     6d3036 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x9b6>
  6d2871:	mov    0x100(%rax),%rsi
  6d2878:	test   %rsi,%rsi
  6d287b:	je     6d3036 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x9b6>
  6d2881:	lea    0x70(%rsp),%rdi
  6d2886:	call   *0x3471b4(%rip)        # a19a40 <_DYNAMIC+0x470>
  6d288c:	jmp    6d3049 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x9c9>
  6d2891:	mov    (%rsi),%r15
  6d2894:	test   %r15,%r15
  6d2897:	je     6d28c3 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x243>
  6d2899:	add    $0x8,%rsi
  6d289d:	mov    %r15,0x100(%rsp)
  6d28a5:	mov    %rsi,0x108(%rsp)
  6d28ad:	cmpb   $0x1,0x746(%r15)
  6d28b5:	jne    6d28d7 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x257>
  6d28b7:	movq   $0xe,(%rbx)
  6d28be:	jmp    6d2d37 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x6b7>
  6d28c3:	movq   $0xd,(%rbx)
  6d28ca:	movq   $0x0,0x8(%rbx)
  6d28d2:	jmp    6d2d37 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x6b7>
  6d28d7:	movq   $0x0,0x730(%r15)
  6d28e2:	cmp    $0x3,%ebp
  6d28e5:	je     6d2ac5 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x445>
  6d28eb:	cmp    $0x2,%ebp
  6d28ee:	je     6d2a03 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x383>
  6d28f4:	test   %ebp,%ebp
  6d28f6:	jne    6d2cde <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x65e>
  6d28fc:	mov    0x638(%r15),%rax
  6d2903:	test   %rax,%rax
  6d2906:	je     6d291e <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x29e>
  6d2908:	mov    0xd8(%rax),%rax
  6d290f:	test   %rax,%rax
  6d2912:	je     6d291e <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x29e>
  6d2914:	cmpb   $0x0,0x12(%rax)
  6d2918:	jne    6d2cde <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x65e>
  6d291e:	mov    0x8(%r14),%r12
  6d2922:	test   %r12,%r12
  6d2925:	je     6d2cde <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x65e>
  6d292b:	cmp    0x5d8(%r15),%r12
  6d2932:	jne    6d2cd6 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x656>
  6d2938:	mov    0x10(%r14),%r13
  6d293c:	lea    0x70(%rsp),%rdi
  6d2941:	mov    %r15,%rsi
  6d2944:	mov    %r13,%rdx
  6d2947:	call   6f8950 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE16resolve_identityBO_>
  6d294c:	mov    0x70(%rsp),%rax
  6d2951:	cmp    $0xfffffffffffffffe,%rax
  6d2955:	jne    6d2c8d <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x60d>
  6d295b:	mov    0x78(%rsp),%rdi
  6d2960:	mov    0x2c8(%r15),%rsi
  6d2967:	cmp    %rsi,%rdi
  6d296a:	jae    6d3588 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xf08>
  6d2970:	mov    0x2c0(%r15),%rax
  6d2977:	lea    (%rdi,%rdi,4),%rcx
  6d297b:	mov    0x20(%rax,%rcx,8),%edi
  6d297f:	call   6e2030 <_RNvMsh_NtCs6ZNK6sH19NW_4gpui7runtimeNtB5_4Node4kind>
  6d2984:	cmp    $0x4,%al
  6d2986:	jne    6d2d49 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x6c9>
  6d298c:	mov    (%r14),%eax
  6d298f:	cmp    $0xffffffff,%eax
  6d2992:	je     6d3597 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xf17>
  6d2998:	movd   0x4(%r14),%xmm1
  6d299e:	dec    %eax
  6d29a0:	movd   %eax,%xmm0
  6d29a4:	mov    %rsp,%rdi
  6d29a7:	mov    %r15,%rsi
  6d29aa:	mov    %r12,%rdx
  6d29ad:	mov    %r13,%rcx
  6d29b0:	mov    $0x1,%r8d
  6d29b6:	call   6dba50 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime7editingINtB7_10RuntimeMutNtCs4gijoeCAvqI_25inspector_pointer_control5ModeluE14select_pointerB12_>
  6d29bb:	mov    (%rsp),%rax
  6d29bf:	cmp    $0xfffffffffffffffe,%rax
  6d29c3:	je     6d29d2 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x352>
  6d29c5:	cmp    $0x11,%eax
  6d29c8:	jne    6d29d2 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x352>
  6d29ca:	movq   $0x0,0x8(%r14)
  6d29d2:	mov    0x30(%rsp),%rax
  6d29d7:	mov    %rax,0x30(%rbx)
  6d29db:	movups (%rsp),%xmm0
  6d29df:	movups 0x10(%rsp),%xmm1
  6d29e4:	movups 0x20(%rsp),%xmm2
  6d29e9:	movups %xmm2,0x20(%rbx)
  6d29ed:	movups %xmm1,0x10(%rbx)
  6d29f1:	movups %xmm0,(%rbx)
  6d29f4:	lea    0x70(%rsp),%rdi
  6d29f9:	call   6b92f0 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtB4_6result6ResultNtNtCs6ZNK6sH19NW_4gpui7runtime6CommitNtBZ_5ErrorEECs4gijoeCAvqI_25inspector_pointer_control>
  6d29fe:	jmp    6d2d37 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x6b7>
  6d2a03:	test   %r12,%r12
  6d2a06:	sete   %cl
  6d2a09:	cmpb   $0x1,0x742(%r15)
  6d2a11:	jne    6d2c81 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x601>
  6d2a17:	cmpb   $0x0,0x743(%r15)
  6d2a1f:	jne    6d2c81 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x601>
  6d2a25:	cmpb   $0x0,0x744(%r15)
  6d2a2d:	je     6d2c81 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x601>
  6d2a33:	cmpq   $0xffffffffffffffff,0x5b0(%r15)
  6d2a3b:	jne    6d2c81 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x601>
  6d2a41:	mov    0x688(%r15),%rax
  6d2a48:	cmp    0x690(%r15),%rax
  6d2a4f:	jne    6d2c81 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x601>
  6d2a55:	mov    0x6a0(%r15),%rax
  6d2a5c:	cmp    0x698(%r15),%rax
  6d2a63:	jne    6d2c81 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x601>
  6d2a69:	movss  0x738(%r15),%xmm0
  6d2a72:	ucomiss 0x73c(%r15),%xmm0
  6d2a7a:	jne    6d2c81 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x601>
  6d2a80:	jp     6d2c81 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x601>
  6d2a86:	mov    %ecx,0x40(%rsp)
  6d2a8a:	mov    %rsp,%rdi
  6d2a8d:	mov    %r15,%rsi
  6d2a90:	call   6e7120 <_RNvMsm_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19presented_hit_sheetBO_>
  6d2a95:	mov    (%r14),%eax
  6d2a98:	cmp    $0xffffffff,%eax
  6d2a9b:	mov    %rax,0xb0(%rsp)
  6d2aa3:	je     6d2d55 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x6d5>
  6d2aa9:	movss  0x4(%r14),%xmm0
  6d2aaf:	dec    %eax
  6d2ab1:	mov    %eax,0x74(%rsp)
  6d2ab5:	movss  %xmm0,0x78(%rsp)
  6d2abb:	mov    $0x1,%eax
  6d2ac0:	jmp    6d2d57 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x6d7>
  6d2ac5:	test   %r12,%r12
  6d2ac8:	je     6d2cde <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x65e>
  6d2ace:	mov    %r12,0x110(%rsp)
  6d2ad6:	mov    %r13,0x118(%rsp)
  6d2ade:	mov    %rax,0x120(%rsp)
  6d2ae6:	mov    (%r14),%ecx
  6d2ae9:	cmp    $0xffffffff,%ecx
  6d2aec:	mov    %rcx,0xb0(%rsp)
  6d2af4:	je     6d2b40 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x4c0>
  6d2af6:	movss  0x4(%r14),%xmm0
  6d2afc:	dec    %ecx
  6d2afe:	mov    %ecx,0x68(%rsp)
  6d2b02:	movss  %xmm0,0x38(%rsp)
  6d2b08:	movss  %xmm0,0x6c(%rsp)
  6d2b0e:	mov    %ecx,0x58(%rsp)
  6d2b12:	mov    $0x1,%ecx
  6d2b17:	jmp    6d2b42 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x4c2>
  6d2b19:	mov    0x30(%rsp),%rax
  6d2b1e:	mov    %rax,0x30(%rbx)
  6d2b22:	movups (%rsp),%xmm0
  6d2b26:	movups 0x10(%rsp),%xmm1
  6d2b2b:	movups 0x20(%rsp),%xmm2
  6d2b30:	movups %xmm2,0x20(%rbx)
  6d2b34:	movups %xmm1,0x10(%rbx)
  6d2b38:	movups %xmm0,(%rbx)
  6d2b3b:	jmp    6d2d37 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x6b7>
  6d2b40:	xor    %ecx,%ecx
  6d2b42:	mov    %ecx,0x40(%rsp)
  6d2b46:	mov    %ecx,0x64(%rsp)
  6d2b4a:	movzbl 0x743(%r15),%ecx
  6d2b52:	xor    $0x1,%cl
  6d2b55:	and    0x742(%r15),%cl
  6d2b5c:	and    0x744(%r15),%cl
  6d2b63:	mov    0x5b0(%r15),%rdx
  6d2b6a:	cmp    $0xffffffffffffffff,%rdx
  6d2b6e:	sete   %sil
  6d2b72:	and    %cl,%sil
  6d2b75:	cmp    $0x1,%sil
  6d2b79:	jne    6d2c3e <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x5be>
  6d2b7f:	mov    0x688(%r15),%rax
  6d2b86:	cmp    0x690(%r15),%rax
  6d2b8d:	jne    6d2c81 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x601>
  6d2b93:	mov    0x6a0(%r15),%rdx
  6d2b9a:	cmp    0x698(%r15),%rdx
  6d2ba1:	jne    6d2c81 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x601>
  6d2ba7:	movss  0x738(%r15),%xmm0
  6d2bb0:	ucomiss 0x73c(%r15),%xmm0
  6d2bb8:	jne    6d2c81 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x601>
  6d2bbe:	jp     6d2c81 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x601>
  6d2bc4:	mov    0x5a0(%r15),%rcx
  6d2bcb:	mov    0x5a8(%r15),%r8
  6d2bd2:	mov    0x638(%r15),%rdi
  6d2bd9:	test   %rdi,%rdi
  6d2bdc:	je     6d2f3d <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x8bd>
  6d2be2:	mov    0x100(%rdi),%rsi
  6d2be9:	test   %rsi,%rsi
  6d2bec:	je     6d2f52 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x8d2>
  6d2bf2:	mov    %rdi,0x58(%rsp)
  6d2bf7:	lea    0x70(%rsp),%rdi
  6d2bfc:	mov    %rdx,0x38(%rsp)
  6d2c01:	mov    %rcx,0xf8(%rsp)
  6d2c09:	mov    %r8,0xf0(%rsp)
  6d2c11:	call   *0x346e29(%rip)        # a19a40 <_DYNAMIC+0x470>
  6d2c17:	mov    0xf0(%rsp),%r8
  6d2c1f:	mov    0xf8(%rsp),%rcx
  6d2c27:	mov    0x58(%rsp),%rdi
  6d2c2c:	mov    0x38(%rsp),%rdx
  6d2c31:	mov    0x64(%rsp),%eax
  6d2c35:	mov    %eax,0x40(%rsp)
  6d2c39:	jmp    6d2f63 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x8e3>
  6d2c3e:	cmp    $0xffffffffffffffff,%rdx
  6d2c42:	sete   %dl
  6d2c45:	movq   $0x12,0x140(%rsp)
  6d2c51:	xor    $0x1,%cl
  6d2c54:	or     %dl,%cl
  6d2c56:	jne    6d2c81 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x601>
  6d2c58:	mov    0x6a0(%r15),%rcx
  6d2c5f:	cmp    0x698(%r15),%rcx
  6d2c66:	jne    6d2c81 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x601>
  6d2c68:	movss  0x738(%r15),%xmm0
  6d2c71:	ucomiss 0x73c(%r15),%xmm0
  6d2c79:	jne    6d2c81 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x601>
  6d2c7b:	jnp    6d2d87 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x707>
  6d2c81:	movq   $0x12,(%rbx)
  6d2c88:	jmp    6d2d37 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x6b7>
  6d2c8d:	cmp    $0xd,%rax
  6d2c91:	jl     6d2cb3 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x633>
  6d2c93:	cmp    $0x21,%rax
  6d2c97:	je     6d2cb3 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x633>
  6d2c99:	cmp    $0x26,%rax
  6d2c9d:	jne    6d2cd6 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x656>
  6d2c9f:	mov    0x78(%rsp),%rsi
  6d2ca4:	test   %rsi,%rsi
  6d2ca7:	je     6d2cd6 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x656>
  6d2ca9:	lea    0x80(%rsp),%rax
  6d2cb1:	jmp    6d2cc8 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x648>
  6d2cb3:	mov    0x88(%rsp),%rsi
  6d2cbb:	test   %rsi,%rsi
  6d2cbe:	je     6d2cd6 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x656>
  6d2cc0:	lea    0x90(%rsp),%rax
  6d2cc8:	mov    (%rax),%rdi
  6d2ccb:	mov    $0x1,%edx
  6d2cd0:	call   *0x346b3a(%rip)        # a19810 <_DYNAMIC+0x240>
  6d2cd6:	movq   $0x0,0x8(%r14)
  6d2cde:	movups 0x688(%r15),%xmm0
  6d2ce6:	movzbl 0x744(%r15),%eax
  6d2cee:	cmpq   $0x0,0x6a8(%r15)
  6d2cf6:	je     6d2d06 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x686>
  6d2cf8:	test   %al,%al
  6d2cfa:	je     6d2d0a <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x68a>
  6d2cfc:	cmpq   $0xffffffffffffffff,0x5b0(%r15)
  6d2d04:	jne    6d2d0a <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x68a>
  6d2d06:	xor    %ecx,%ecx
  6d2d08:	jmp    6d2d16 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x696>
  6d2d0a:	mov    0x6b8(%r15),%rdx
  6d2d11:	mov    $0x1,%ecx
  6d2d16:	mov    0x730(%r15),%rsi
  6d2d1d:	mov    %rcx,0x8(%rbx)
  6d2d21:	mov    %rdx,0x10(%rbx)
  6d2d25:	movups %xmm0,0x18(%rbx)
  6d2d29:	mov    %rsi,0x28(%rbx)
  6d2d2d:	mov    %al,0x30(%rbx)
  6d2d30:	movq   $0xfffffffffffffffe,(%rbx)
  6d2d37:	add    $0x178,%rsp
  6d2d3e:	pop    %rbx
  6d2d3f:	pop    %r12
  6d2d41:	pop    %r13
  6d2d43:	pop    %r14
  6d2d45:	pop    %r15
  6d2d47:	pop    %rbp
  6d2d48:	ret
  6d2d49:	lea    0x70(%rsp),%rdi
  6d2d4e:	call   6b92f0 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtB4_6result6ResultNtNtCs6ZNK6sH19NW_4gpui7runtime6CommitNtBZ_5ErrorEECs4gijoeCAvqI_25inspector_pointer_control>
  6d2d53:	jmp    6d2cde <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x65e>
  6d2d55:	xor    %eax,%eax
  6d2d57:	mov    %eax,0x70(%rsp)
  6d2d5b:	mov    %rsp,%rsi
  6d2d5e:	lea    0x70(%rsp),%rdx
  6d2d63:	mov    %r15,%rdi
  6d2d66:	call   6db5a0 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE11pointer_hitBW_>
  6d2d6b:	mov    %rdx,%r8
  6d2d6e:	mov    0x40(%rsp),%edx
  6d2d72:	mov    0x638(%r15),%rcx
  6d2d79:	test   %rcx,%rcx
  6d2d7c:	jne    6d301d <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x99d>
  6d2d82:	jmp    6d3213 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xb93>
  6d2d87:	mov    0x690(%r15),%rcx
  6d2d8e:	cmp    $0xffffffffffffffff,%rcx
  6d2d92:	je     6d2c81 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x601>
  6d2d98:	inc    %rcx
  6d2d9b:	mov    0x688(%r15),%rdx
  6d2da2:	cmp    %rdx,%rcx
  6d2da5:	jne    6d2c81 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x601>
  6d2dab:	cmp    %rdx,0x6b8(%r15)
  6d2db2:	jne    6d2c81 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x601>
  6d2db8:	test   %rax,%rax
  6d2dbb:	je     6d2c81 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x601>
  6d2dc1:	cmpq   $0x0,0x6a8(%r15)
  6d2dc9:	je     6d2c81 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x601>
  6d2dcf:	cmp    %rax,0x6b0(%r15)
  6d2dd6:	jne    6d2c81 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x601>
  6d2ddc:	cmp    0x5d8(%r15),%r12
  6d2de3:	jne    6d2c81 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x601>
  6d2de9:	lea    0xb8(%rsp),%rdi
  6d2df1:	mov    %r15,%rsi
  6d2df4:	call   6e7120 <_RNvMsm_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19presented_hit_sheetBO_>
  6d2df9:	mov    0x638(%r15),%rax
  6d2e00:	test   %rax,%rax
  6d2e03:	je     6d319b <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xb1b>
  6d2e09:	cmpq   $0x0,0xd8(%rax)
  6d2e11:	je     6d319b <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xb1b>
  6d2e17:	cmpl   $0x0,0x40(%rsp)
  6d2e1c:	je     6d353e <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xebe>
  6d2e22:	lea    0xb8(%rsp),%rdi
  6d2e2a:	movss  0x58(%rsp),%xmm0
  6d2e30:	movd   0x38(%rsp),%xmm1
  6d2e36:	call   *0x346bcc(%rip)        # a19a08 <_DYNAMIC+0x438>
  6d2e3c:	mov    %al,0x40(%rsp)
  6d2e40:	mov    0xe8(%rsp),%rax
  6d2e48:	mov    %rax,0x30(%rsp)
  6d2e4d:	movups 0xb8(%rsp),%xmm0
  6d2e55:	movdqu 0xc8(%rsp),%xmm1
  6d2e5e:	movups 0xd8(%rsp),%xmm2
  6d2e66:	movaps %xmm2,0x20(%rsp)
  6d2e6b:	movdqa %xmm1,0x10(%rsp)
  6d2e71:	movaps %xmm0,(%rsp)
  6d2e75:	mov    %rsp,%rsi
  6d2e78:	lea    0x64(%rsp),%rdx
  6d2e7d:	mov    %r15,%rdi
  6d2e80:	call   6db5a0 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE11pointer_hitBW_>
  6d2e85:	cmp    %r12,%rax
  6d2e88:	sete   %al
  6d2e8b:	movzbl 0x40(%rsp),%ecx
  6d2e90:	and    %al,%cl
  6d2e92:	cmp    $0x1,%cl
  6d2e95:	jne    6d2c81 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x601>
  6d2e9b:	cmp    %r13,%rdx
  6d2e9e:	jne    6d2c81 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x601>
  6d2ea4:	lea    0x70(%rsp),%rdi
  6d2ea9:	mov    %r15,%rsi
  6d2eac:	call   6e7050 <_RNvMsm_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19candidate_hit_sheetBO_>
  6d2eb1:	lea    0x64(%rsp),%rax
  6d2eb6:	mov    %rax,0x128(%rsp)
  6d2ebe:	mov    %r15,0x130(%rsp)
  6d2ec6:	lea    0x110(%rsp),%rax
  6d2ece:	mov    %rax,0x138(%rsp)
  6d2ed6:	cmpb   $0x2,0xa0(%rsp)
  6d2ede:	je     6d2c81 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x601>
  6d2ee4:	mov    0xa0(%rsp),%rax
  6d2eec:	mov    %rax,0x30(%rsp)
  6d2ef1:	movups 0x70(%rsp),%xmm0
  6d2ef6:	movdqu 0x80(%rsp),%xmm1
  6d2eff:	movups 0x90(%rsp),%xmm2
  6d2f07:	movaps %xmm2,0x20(%rsp)
  6d2f0c:	movdqa %xmm1,0x10(%rsp)
  6d2f12:	movaps %xmm0,(%rsp)
  6d2f16:	lea    0x128(%rsp),%rdi
  6d2f1e:	mov    %rsp,%rsi
  6d2f21:	call   6ce900 <_RNCNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB9_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE19pointer_release_hits0_0BY_>
  6d2f26:	test   %al,%al
  6d2f28:	jne    6d2c81 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x601>
  6d2f2e:	mov    %r12,0x40(%rsp)
  6d2f33:	mov    %r13,0x38(%rsp)
  6d2f38:	jmp    6d31ea <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xb6a>
  6d2f3d:	movq   $0x4,0x70(%rsp)
  6d2f46:	xorps  %xmm0,%xmm0
  6d2f49:	movups %xmm0,0x78(%rsp)
  6d2f4e:	xor    %eax,%eax
  6d2f50:	jmp    6d2f6a <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x8ea>
  6d2f52:	movq   $0x4,0x70(%rsp)
  6d2f5b:	xorps  %xmm0,%xmm0
  6d2f5e:	movups %xmm0,0x78(%rsp)
  6d2f63:	cmpq   $0x0,(%rdi)
  6d2f67:	setne  %al
  6d2f6a:	mov    %rcx,(%rsp)
  6d2f6e:	mov    %r8,0x8(%rsp)
  6d2f73:	mov    0x70(%rsp),%rcx
  6d2f78:	mov    %rcx,0x10(%rsp)
  6d2f7d:	mov    0x78(%rsp),%rcx
  6d2f82:	mov    %rcx,0x18(%rsp)
  6d2f87:	mov    0x80(%rsp),%rcx
  6d2f8f:	mov    %rcx,0x20(%rsp)
  6d2f94:	mov    %rdx,0x28(%rsp)
  6d2f99:	mov    %al,0x30(%rsp)
  6d2f9d:	cmpl   $0x0,0x40(%rsp)
  6d2fa2:	je     6d3009 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x989>
  6d2fa4:	movss  0x68(%rsp),%xmm0
  6d2faa:	movd   0x6c(%rsp),%xmm1
  6d2fb0:	test   %rdi,%rdi
  6d2fb3:	je     6d2fd4 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x954>
  6d2fb5:	mov    0xd8(%rdi),%rax
  6d2fbc:	test   %rax,%rax
  6d2fbf:	je     6d2fd4 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x954>
  6d2fc1:	cmpb   $0x0,0x12(%rax)
  6d2fc5:	je     6d2fd4 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x954>
  6d2fc7:	mov    %rsp,%rsi
  6d2fca:	mov    %r15,%rdi
  6d2fcd:	call   6dd7a0 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE23inspector_pick_in_sheetB10_>
  6d2fd2:	jmp    6d2ff3 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x973>
  6d2fd4:	mov    %rsp,%rsi
  6d2fd7:	mov    %r15,%rdi
  6d2fda:	call   6e7a60 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE12hit_in_sheetBO_>
  6d2fdf:	test   $0x1,%al
  6d2fe1:	je     6d3009 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x989>
  6d2fe3:	lea    0x5d8(%r15),%rdi
  6d2fea:	mov    %rdx,%rsi
  6d2fed:	call   *0x346a1d(%rip)        # a19a10 <_DYNAMIC+0x440>
  6d2ff3:	mov    %rdx,%r8
  6d2ff6:	xor    %edx,%edx
  6d2ff8:	mov    0x638(%r15),%rcx
  6d2fff:	test   %rcx,%rcx
  6d3002:	jne    6d301d <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x99d>
  6d3004:	jmp    6d3213 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xb93>
  6d3009:	xor    %eax,%eax
  6d300b:	xor    %edx,%edx
  6d300d:	mov    0x638(%r15),%rcx
  6d3014:	test   %rcx,%rcx
  6d3017:	je     6d3213 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xb93>
  6d301d:	mov    0xd8(%rcx),%rcx
  6d3024:	test   %rcx,%rcx
  6d3027:	je     6d3213 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xb93>
  6d302d:	movzbl 0x12(%rcx),%edi
  6d3031:	jmp    6d3215 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xb95>
  6d3036:	movq   $0x4,0x70(%rsp)
  6d303f:	pxor   %xmm0,%xmm0
  6d3043:	movdqu %xmm0,0x78(%rsp)
  6d3049:	mov    0x5a8(%r14),%rax
  6d3050:	mov    %rax,0x58(%rsp)
  6d3055:	test   %rax,%rax
  6d3058:	je     6d3176 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xaf6>
  6d305e:	mov    0x5a0(%r14),%rbp
  6d3065:	mov    0x58(%rsp),%rax
  6d306a:	mov    %rax,%r15
  6d306d:	shl    $0x6,%r15
  6d3071:	lea    -0x1(%rax),%r12
  6d3075:	jmp    6d30d7 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xa57>
  6d3077:	mov    0x80(%rsp),%rax
  6d307f:	mov    %rax,0x10(%rsp)
  6d3084:	movups 0x70(%rsp),%xmm0
  6d3089:	movaps %xmm0,(%rsp)
  6d308d:	mov    0x638(%r14),%rax
  6d3094:	test   %rax,%rax
  6d3097:	je     6d3104 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xa84>
  6d3099:	cmpq   $0x0,(%rax)
  6d309d:	setne  %al
  6d30a0:	movzbl %al,%ecx
  6d30a3:	mov    %rbp,%rdi
  6d30a6:	mov    0x58(%rsp),%rsi
  6d30ab:	mov    %rsp,%rdx
  6d30ae:	mov    %r12,%r8
  6d30b1:	movd   0x38(%rsp),%xmm0
  6d30b7:	movss  0xb0(%rsp),%xmm1
  6d30c0:	call   *0x346a02(%rip)        # a19ac8 <_DYNAMIC+0x4f8>
  6d30c6:	test   %al,%al
  6d30c8:	jne    6d3108 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xa88>
  6d30ca:	dec    %r12
  6d30cd:	add    $0xffffffffffffffc0,%r15
  6d30d1:	je     6d3176 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xaf6>
  6d30d7:	cmpb   $0x0,-0x2(%rbp,%r15,1)
  6d30dd:	jne    6d3077 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x9f7>
  6d30df:	movzbl -0x3(%rbp,%r15,1),%eax
  6d30e5:	sub    $0x2,%al
  6d30e7:	movzbl %al,%eax
  6d30ea:	mov    $0x8,%ecx
  6d30ef:	cmovb  %ecx,%eax
  6d30f2:	cmp    $0x7,%al
  6d30f4:	je     6d3077 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x9f7>
  6d30f6:	movzbl %al,%eax
  6d30f9:	cmp    $0x4,%eax
  6d30fc:	je     6d3077 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x9f7>
  6d3102:	jmp    6d30ca <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xa4a>
  6d3104:	xor    %eax,%eax
  6d3106:	jmp    6d30a0 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xa20>
  6d3108:	movq   $0x19,(%rsp)
  6d3110:	mov    %rsp,%rdi
  6d3113:	call   6be470 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueNtNtCs6ZNK6sH19NW_4gpui7runtime5ErrorECs4gijoeCAvqI_25inspector_pointer_control>
  6d3118:	mov    %r12,0xc0(%rsp)
  6d3120:	movq   $0x1,0xb8(%rsp)
  6d312c:	lea    0xb8(%rsp),%rdi
  6d3134:	mov    %r14,%rsi
  6d3137:	mov    %r14,%rdx
  6d313a:	call   6ce150 <_RINvYINtNtNtNtCs4NRVxsYgnAr_4core4iter7sources7from_fn6FromFnNCNvMs6_NtNtCs6ZNK6sH19NW_4gpui7runtime6scrollINtB17_3WinNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE12scroll_at_2ds0_0ENtNtNtBa_6traits8iterator8Iterator8try_folduNCINvNvB2Z_3any5checkjNCBZ_s1_0E0INtNtNtBc_3ops12control_flow11ControlFlowuEEB1U_>
  6d313f:	test   %al,%al
  6d3141:	je     6d3176 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xaf6>
  6d3143:	movq   $0x1,0x8(%rsp)
  6d314c:	mov    %r12,0x10(%rsp)
  6d3151:	movaps 0x40(%rsp),%xmm0
  6d3156:	movups %xmm0,0x18(%rsp)
  6d315b:	movq   $0x3,(%rsp)
  6d3163:	mov    %rsp,%rdx
  6d3166:	mov    %rbx,%rdi
  6d3169:	mov    %r13,%rsi
  6d316c:	call   6e1090 <_RNvMs6_NtNtCs6ZNK6sH19NW_4gpui7runtime6scrollINtB7_3WinNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE17apply_scroll_planBT_>
  6d3171:	jmp    6d2d37 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x6b7>
  6d3176:	movq   $0x19,(%rbx)
  6d317d:	jmp    6d2d37 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x6b7>
  6d3182:	lea    -0x685fa0(%rip),%rdi        # 4d1e9 <GCC_except_table0+0xfa71>
  6d3189:	lea    0x327b08(%rip),%rdx        # 9fac98 <__frame_dummy_init_array_entry+0xe98>
  6d3190:	mov    $0x22,%esi
  6d3195:	call   *0x34681d(%rip)        # a199b8 <_DYNAMIC+0x3e8>
  6d319b:	mov    0xe8(%rsp),%rax
  6d31a3:	mov    %rax,0x30(%rsp)
  6d31a8:	movups 0xb8(%rsp),%xmm0
  6d31b0:	movdqu 0xc8(%rsp),%xmm1
  6d31b9:	movups 0xd8(%rsp),%xmm2
  6d31c1:	movaps %xmm2,0x20(%rsp)
  6d31c6:	movdqa %xmm1,0x10(%rsp)
  6d31cc:	movaps %xmm0,(%rsp)
  6d31d0:	mov    %rsp,%rsi
  6d31d3:	lea    0x64(%rsp),%rdx
  6d31d8:	mov    %r15,%rdi
  6d31db:	call   6db5a0 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE11pointer_hitBW_>
  6d31e0:	mov    %rax,0x40(%rsp)
  6d31e5:	mov    %rdx,0x38(%rsp)
  6d31ea:	lea    0x140(%rsp),%rdi
  6d31f2:	call   6be470 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueNtNtCs6ZNK6sH19NW_4gpui7runtime5ErrorECs4gijoeCAvqI_25inspector_pointer_control>
  6d31f7:	mov    0x40(%rsp),%rax
  6d31fc:	mov    0x38(%rsp),%r8
  6d3201:	xor    %edx,%edx
  6d3203:	mov    0x638(%r15),%rcx
  6d320a:	test   %rcx,%rcx
  6d320d:	jne    6d301d <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x99d>
  6d3213:	xor    %edi,%edi
  6d3215:	cmp    $0x2,%ebp
  6d3218:	jne    6d32fa <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xc7a>
  6d321e:	mov    0x610(%r15),%rdx
  6d3225:	mov    0x618(%r15),%rcx
  6d322c:	test   %rax,%rax
  6d322f:	sete   %sil
  6d3233:	or     %dil,%sil
  6d3236:	test   $0x1,%sil
  6d323a:	je     6d333c <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xcbc>
  6d3240:	mov    %r8,%r12
  6d3243:	mov    %rax,%rbp
  6d3246:	movq   $0x0,0x610(%r15)
  6d3251:	mov    %rsp,%rdi
  6d3254:	mov    %r15,%rsi
  6d3257:	call   6dc070 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime7editingINtB7_10RuntimeMutNtCs4gijoeCAvqI_25inspector_pointer_control5ModeluE20publish_focus_changeB12_>
  6d325c:	mov    (%rsp),%rax
  6d3260:	movups 0x8(%rsp),%xmm0
  6d3265:	movaps %xmm0,0x70(%rsp)
  6d326a:	movups 0x18(%rsp),%xmm0
  6d326f:	movaps %xmm0,0x80(%rsp)
  6d3277:	movups 0x28(%rsp),%xmm0
  6d327c:	movaps %xmm0,0x90(%rsp)
  6d3284:	cmp    $0xfffffffffffffffe,%rax
  6d3288:	jne    6d342b <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xdab>
  6d328e:	movaps 0x70(%rsp),%xmm0
  6d3293:	movaps 0x80(%rsp),%xmm1
  6d329b:	movaps 0x90(%rsp),%xmm2
  6d32a3:	movaps %xmm2,0x20(%rsp)
  6d32a8:	movaps %xmm1,0x10(%rsp)
  6d32ad:	movaps %xmm0,(%rsp)
  6d32b1:	cmpq   $0xffffffffffffffff,0x5b0(%r15)
  6d32b9:	je     6d3480 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xe00>
  6d32bf:	mov    0x690(%r15),%rax
  6d32c6:	cmp    $0xffffffffffffffff,%rax
  6d32ca:	je     6d3480 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xe00>
  6d32d0:	inc    %rax
  6d32d3:	cmp    0x688(%r15),%rax
  6d32da:	jne    6d3480 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xe00>
  6d32e0:	cmpq   $0x0,0x6a8(%r15)
  6d32e8:	je     6d3480 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xe00>
  6d32ee:	mov    0x6b0(%r15),%rax
  6d32f5:	jmp    6d3482 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xe02>
  6d32fa:	test   %dl,%dl
  6d32fc:	jne    6d2cde <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x65e>
  6d3302:	test   %rax,%rax
  6d3305:	je     6d2cde <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x65e>
  6d330b:	cmp    %rax,%r12
  6d330e:	jne    6d2cde <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x65e>
  6d3314:	cmp    %r8,%r13
  6d3317:	jne    6d2cde <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x65e>
  6d331d:	test   %dil,%dil
  6d3320:	je     6d34af <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xe2f>
  6d3326:	mov    %rbx,%rdi
  6d3329:	mov    %r15,%rsi
  6d332c:	mov    %r12,%rdx
  6d332f:	mov    %r13,%rcx
  6d3332:	call   6df770 <_RNvMs4_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_10RuntimeMutNtCs4gijoeCAvqI_25inspector_pointer_control5ModeluE16inspector_selectB14_>
  6d3337:	jmp    6d2d37 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x6b7>
  6d333c:	cmp    0x5d8(%r15),%rax
  6d3343:	jne    6d3454 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xdd4>
  6d3349:	mov    %rax,%rbp
  6d334c:	mov    %rcx,0x40(%rsp)
  6d3351:	mov    %rdx,%r13
  6d3354:	mov    %rsp,%rdi
  6d3357:	mov    %r15,%rsi
  6d335a:	mov    %r8,%r12
  6d335d:	mov    %r8,%rdx
  6d3360:	call   6f8950 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE16resolve_identityBO_>
  6d3365:	mov    (%rsp),%rax
  6d3369:	mov    0x8(%rsp),%rdi
  6d336e:	cmp    $0xfffffffffffffffe,%rax
  6d3372:	jne    6d3459 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xdd9>
  6d3378:	mov    0x2c8(%r15),%rsi
  6d337f:	cmp    %rsi,%rdi
  6d3382:	jae    6d35a6 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xf26>
  6d3388:	mov    0x2c0(%r15),%rax
  6d338f:	lea    (%rdi,%rdi,4),%rcx
  6d3393:	mov    0x20(%rax,%rcx,8),%edi
  6d3397:	call   6e2030 <_RNvMsh_NtCs6ZNK6sH19NW_4gpui7runtimeNtB5_4Node4kind>
  6d339c:	cmp    $0x4,%al
  6d339e:	jne    6d34d5 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xe55>
  6d33a4:	mov    0xb0(%rsp),%rax
  6d33ac:	cmp    $0xffffffff,%eax
  6d33af:	je     6d35b3 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xf33>
  6d33b5:	movss  0x4(%r14),%xmm1
  6d33bb:	dec    %eax
  6d33bd:	movd   %eax,%xmm0
  6d33c1:	mov    %rsp,%rdi
  6d33c4:	mov    %r15,%rsi
  6d33c7:	mov    %rbp,%rdx
  6d33ca:	mov    %r12,%rcx
  6d33cd:	xor    %r8d,%r8d
  6d33d0:	call   6dba50 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime7editingINtB7_10RuntimeMutNtCs4gijoeCAvqI_25inspector_pointer_control5ModeluE14select_pointerB12_>
  6d33d5:	mov    (%rsp),%rax
  6d33d9:	movups 0x28(%rsp),%xmm0
  6d33de:	movaps %xmm0,0x90(%rsp)
  6d33e6:	movdqu 0x18(%rsp),%xmm1
  6d33ec:	movdqa %xmm1,0x80(%rsp)
  6d33f5:	movups 0x8(%rsp),%xmm2
  6d33fa:	movaps %xmm2,0x70(%rsp)
  6d33ff:	movups %xmm0,0x28(%rbx)
  6d3403:	movdqu %xmm1,0x18(%rbx)
  6d3408:	movups %xmm2,0x8(%rbx)
  6d340c:	cmp    $0xfffffffffffffffe,%rax
  6d3410:	jne    6d3536 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xeb6>
  6d3416:	mov    %rbp,0x8(%r14)
  6d341a:	mov    %r12,0x10(%r14)
  6d341e:	movq   $0x0,0x18(%r14)
  6d3426:	jmp    6d2d30 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x6b0>
  6d342b:	movaps 0x70(%rsp),%xmm0
  6d3430:	movaps 0x80(%rsp),%xmm1
  6d3438:	movaps 0x90(%rsp),%xmm2
  6d3440:	movups %xmm2,0x28(%rbx)
  6d3444:	movups %xmm1,0x18(%rbx)
  6d3448:	movups %xmm0,0x8(%rbx)
  6d344c:	mov    %rax,(%rbx)
  6d344f:	jmp    6d2d37 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x6b7>
  6d3454:	mov    $0x11,%eax
  6d3459:	mov    0x30(%rsp),%rcx
  6d345e:	mov    %rcx,0x30(%rbx)
  6d3462:	movups 0x10(%rsp),%xmm0
  6d3467:	movups 0x20(%rsp),%xmm1
  6d346c:	movups %xmm1,0x20(%rbx)
  6d3470:	movups %xmm0,0x10(%rbx)
  6d3474:	mov    %rax,(%rbx)
  6d3477:	mov    %rdi,0x8(%rbx)
  6d347b:	jmp    6d2d37 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x6b7>
  6d3480:	xor    %eax,%eax
  6d3482:	mov    %rbp,0x8(%r14)
  6d3486:	mov    %r12,0x10(%r14)
  6d348a:	mov    %rax,0x18(%r14)
  6d348e:	movaps (%rsp),%xmm0
  6d3492:	movdqa 0x10(%rsp),%xmm1
  6d3498:	movaps 0x20(%rsp),%xmm2
  6d349d:	movups %xmm2,0x28(%rbx)
  6d34a1:	movdqu %xmm1,0x18(%rbx)
  6d34a6:	movups %xmm0,0x8(%rbx)
  6d34aa:	jmp    6d2d30 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x6b0>
  6d34af:	movq   $0x0,(%rsp)
  6d34b7:	lea    0x100(%rsp),%rsi
  6d34bf:	mov    %rsp,%r8
  6d34c2:	mov    %rbx,%rdi
  6d34c5:	mov    %r12,%rdx
  6d34c8:	mov    %r13,%rcx
  6d34cb:	call   6d6830 <_RNvMNtNtCs6ZNK6sH19NW_4gpui7runtime4turnINtB4_10RuntimeMutNtCs4gijoeCAvqI_25inspector_pointer_control5ModeluE21activate_with_editingBW_>
  6d34d0:	jmp    6d2d37 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x6b7>
  6d34d5:	mov    %rsp,%rdi
  6d34d8:	mov    %r15,%rsi
  6d34db:	mov    %rbp,%rdx
  6d34de:	mov    %r12,%rcx
  6d34e1:	call   6db6d0 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE5focusBW_>
  6d34e6:	mov    (%rsp),%rax
  6d34ea:	cmp    $0xfffffffffffffffe,%rax
  6d34ee:	jne    6d34fd <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xe7d>
  6d34f0:	mov    %r13,%rdx
  6d34f3:	mov    0x40(%rsp),%rcx
  6d34f8:	jmp    6d3251 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xbd1>
  6d34fd:	mov    0x28(%rsp),%rcx
  6d3502:	movzbl 0x30(%rsp),%edx
  6d3507:	mov    0x34(%rsp),%esi
  6d350b:	mov    %esi,0x34(%rbx)
  6d350e:	mov    0x31(%rsp),%esi
  6d3512:	mov    %esi,0x31(%rbx)
  6d3515:	movups 0x8(%rsp),%xmm0
  6d351a:	movups 0x18(%rsp),%xmm1
  6d351f:	mov    %rax,(%rbx)
  6d3522:	movups %xmm0,0x8(%rbx)
  6d3526:	movups %xmm1,0x18(%rbx)
  6d352a:	mov    %rcx,0x28(%rbx)
  6d352e:	mov    %dl,0x30(%rbx)
  6d3531:	jmp    6d2d37 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x6b7>
  6d3536:	mov    %rax,(%rbx)
  6d3539:	jmp    6d2d37 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x6b7>
  6d353e:	mov    0xe8(%rsp),%rax
  6d3546:	mov    %rax,0x30(%rsp)
  6d354b:	movups 0xb8(%rsp),%xmm0
  6d3553:	movdqu 0xc8(%rsp),%xmm1
  6d355c:	movups 0xd8(%rsp),%xmm2
  6d3564:	movaps %xmm2,0x20(%rsp)
  6d3569:	movdqa %xmm1,0x10(%rsp)
  6d356f:	movaps %xmm0,(%rsp)
  6d3573:	mov    %rsp,%rsi
  6d3576:	lea    0x64(%rsp),%rdx
  6d357b:	mov    %r15,%rdi
  6d357e:	call   6db5a0 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE11pointer_hitBW_>
  6d3583:	jmp    6d2c81 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0x601>
  6d3588:	lea    0x327721(%rip),%rdx        # 9facb0 <__frame_dummy_init_array_entry+0xeb0>
  6d358f:	call   *0x3462ab(%rip)        # a19840 <_DYNAMIC+0x270>
  6d3595:	jmp    6d35a4 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8dispatch+0xf24>
  6d3597:	lea    0x32772a(%rip),%rdi        # 9facc8 <__frame_dummy_init_array_entry+0xec8>
  6d359e:	call   *0x346304(%rip)        # a198a8 <_DYNAMIC+0x2d8>
  6d35a4:	ud2
  6d35a6:	lea    0x327733(%rip),%rdx        # 9face0 <__frame_dummy_init_array_entry+0xee0>
  6d35ad:	call   *0x34628d(%rip)        # a19840 <_DYNAMIC+0x270>
  6d35b3:	lea    0x32773e(%rip),%rdi        # 9facf8 <__frame_dummy_init_array_entry+0xef8>
  6d35ba:	call   *0x3462e8(%rip)        # a198a8 <_DYNAMIC+0x2d8>
  6d35c0:	mov    %rax,%rbx
  6d35c3:	lea    0x140(%rsp),%rdi
  6d35cb:	call   6be470 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueNtNtCs6ZNK6sH19NW_4gpui7runtime5ErrorECs4gijoeCAvqI_25inspector_pointer_control>
  6d35d0:	mov    %rbx,%rdi
  6d35d3:	call   9f8a50 <_Unwind_Resume@plt>
  6d35d8:	mov    %rax,%rbx
  6d35db:	lea    0x70(%rsp),%rdi
  6d35e0:	call   6b92f0 <_RINvNtCs4NRVxsYgnAr_4core3ptr9drop_glueINtNtB4_6result6ResultNtNtCs6ZNK6sH19NW_4gpui7runtime6CommitNtBZ_5ErrorEECs4gijoeCAvqI_25inspector_pointer_control>
  6d35e5:	mov    %rbx,%rdi
  6d35e8:	call   9f8a50 <_Unwind_Resume@plt>

/tmp/gpui-inspector-pointer-codegen/candidate-frozen:     file format elf64-x86-64


Disassembly of section .text:

00000000006d35f0 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8hit_only>:
  6d35f0:	test   %rsi,%rsi
  6d35f3:	je     6d3606 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8hit_only+0x16>
  6d35f5:	cmpb   $0x0,0x746(%rsi)
  6d35fc:	je     6d3616 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8hit_only+0x26>
  6d35fe:	movq   $0xe,(%rdi)
  6d3605:	ret
  6d3606:	movq   $0xd,(%rdi)
  6d360d:	movq   $0x0,0x8(%rdi)
  6d3615:	ret
  6d3616:	push   %rbp
  6d3617:	push   %r15
  6d3619:	push   %r14
  6d361b:	push   %r13
  6d361d:	push   %r12
  6d361f:	push   %rbx
  6d3620:	sub    $0x58,%rsp
  6d3624:	cmpb   $0x1,0x742(%rsi)
  6d362b:	jne    6d36e1 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8hit_only+0xf1>
  6d3631:	cmpb   $0x0,0x743(%rsi)
  6d3638:	jne    6d36e1 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8hit_only+0xf1>
  6d363e:	cmpb   $0x0,0x744(%rsi)
  6d3645:	je     6d36e1 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8hit_only+0xf1>
  6d364b:	cmpq   $0xffffffffffffffff,0x5b0(%rsi)
  6d3653:	jne    6d36e1 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8hit_only+0xf1>
  6d3659:	mov    0x688(%rsi),%rax
  6d3660:	cmp    0x690(%rsi),%rax
  6d3667:	jne    6d36e1 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8hit_only+0xf1>
  6d3669:	mov    0x6a0(%rsi),%r14
  6d3670:	cmp    0x698(%rsi),%r14
  6d3677:	jne    6d36e1 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8hit_only+0xf1>
  6d3679:	movss  0x738(%rsi),%xmm2
  6d3681:	ucomiss 0x73c(%rsi),%xmm2
  6d3688:	jne    6d36e1 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8hit_only+0xf1>
  6d368a:	jp     6d36e1 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8hit_only+0xf1>
  6d368c:	mov    0x5a0(%rsi),%r15
  6d3693:	mov    0x5a8(%rsi),%r12
  6d369a:	mov    0x638(%rsi),%r13
  6d36a1:	mov    %rdi,%rbx
  6d36a4:	test   %r13,%r13
  6d36a7:	je     6d36f7 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8hit_only+0x107>
  6d36a9:	mov    0x100(%r13),%rax
  6d36b0:	test   %rax,%rax
  6d36b3:	je     6d370c <_RNvCs4gijoeCAvqI_25inspector_pointer_control8hit_only+0x11c>
  6d36b5:	lea    0x8(%rsp),%rdi
  6d36ba:	mov    %rsi,%rbp
  6d36bd:	mov    %rax,%rsi
  6d36c0:	movss  %xmm1,0x4(%rsp)
  6d36c6:	movss  %xmm0,(%rsp)
  6d36cb:	call   *0x34636f(%rip)        # a19a40 <_DYNAMIC+0x470>
  6d36d1:	movss  (%rsp),%xmm0
  6d36d6:	movss  0x4(%rsp),%xmm1
  6d36dc:	mov    %rbp,%rsi
  6d36df:	jmp    6d371d <_RNvCs4gijoeCAvqI_25inspector_pointer_control8hit_only+0x12d>
  6d36e1:	movq   $0x12,(%rdi)
  6d36e8:	add    $0x58,%rsp
  6d36ec:	pop    %rbx
  6d36ed:	pop    %r12
  6d36ef:	pop    %r13
  6d36f1:	pop    %r14
  6d36f3:	pop    %r15
  6d36f5:	pop    %rbp
  6d36f6:	ret
  6d36f7:	movq   $0x4,0x8(%rsp)
  6d3700:	xorps  %xmm2,%xmm2
  6d3703:	movups %xmm2,0x10(%rsp)
  6d3708:	xor    %eax,%eax
  6d370a:	jmp    6d3725 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8hit_only+0x135>
  6d370c:	movq   $0x4,0x8(%rsp)
  6d3715:	xorps  %xmm2,%xmm2
  6d3718:	movups %xmm2,0x10(%rsp)
  6d371d:	cmpq   $0x0,0x0(%r13)
  6d3722:	setne  %al
  6d3725:	mov    %r15,0x20(%rsp)
  6d372a:	mov    %r12,0x28(%rsp)
  6d372f:	mov    0x8(%rsp),%rcx
  6d3734:	mov    %rcx,0x30(%rsp)
  6d3739:	mov    0x10(%rsp),%rcx
  6d373e:	mov    %rcx,0x38(%rsp)
  6d3743:	mov    0x18(%rsp),%rcx
  6d3748:	mov    %rcx,0x40(%rsp)
  6d374d:	mov    %r14,0x48(%rsp)
  6d3752:	mov    %al,0x50(%rsp)
  6d3756:	lea    0x20(%rsp),%rax
  6d375b:	mov    %rsi,%r14
  6d375e:	mov    %rsi,%rdi
  6d3761:	mov    %rax,%rsi
  6d3764:	call   6e7a60 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE12hit_in_sheetBO_>
  6d3769:	cmp    $0x1,%rax
  6d376d:	jne    6d3784 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8hit_only+0x194>
  6d376f:	mov    %r14,%rdi
  6d3772:	add    $0x5d8,%rdi
  6d3779:	mov    %rdx,%rsi
  6d377c:	call   *0x34628e(%rip)        # a19a10 <_DYNAMIC+0x440>
  6d3782:	jmp    6d3786 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8hit_only+0x196>
  6d3784:	xor    %eax,%eax
  6d3786:	mov    %rax,0x8(%rbx)
  6d378a:	mov    %rdx,0x10(%rbx)
  6d378e:	movq   $0xfffffffffffffffe,(%rbx)
  6d3795:	jmp    6d36e8 <_RNvCs4gijoeCAvqI_25inspector_pointer_control8hit_only+0xf8>

/tmp/gpui-inspector-pointer-codegen/candidate-frozen:     file format elf64-x86-64


Disassembly of section .text:

00000000006db5a0 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE11pointer_hitBW_>:
  6db5a0:	cmpl   $0x1,(%rdx)
  6db5a3:	jne    6db5d5 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE11pointer_hitBW_+0x35>
  6db5a5:	push   %rbx
  6db5a6:	movss  0x4(%rdx),%xmm0
  6db5ab:	movss  0x8(%rdx),%xmm1
  6db5b0:	mov    0x638(%rdi),%rax
  6db5b7:	test   %rax,%rax
  6db5ba:	je     6db5d8 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE11pointer_hitBW_+0x38>
  6db5bc:	mov    0xd8(%rax),%rax
  6db5c3:	test   %rax,%rax
  6db5c6:	je     6db5d8 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE11pointer_hitBW_+0x38>
  6db5c8:	cmpb   $0x0,0x12(%rax)
  6db5cc:	je     6db5d8 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE11pointer_hitBW_+0x38>
  6db5ce:	call   6dd7a0 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE23inspector_pick_in_sheetB10_>
  6db5d3:	pop    %rbx
  6db5d4:	ret
  6db5d5:	xor    %eax,%eax
  6db5d7:	ret
  6db5d8:	mov    %rdi,%rbx
  6db5db:	call   6e7a60 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE12hit_in_sheetBO_>
  6db5e0:	test   $0x1,%al
  6db5e2:	je     6db5f9 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5inputINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE11pointer_hitBW_+0x59>
  6db5e4:	mov    %rbx,%rdi
  6db5e7:	add    $0x5d8,%rdi
  6db5ee:	mov    %rdx,%rsi
  6db5f1:	call   *0x33e419(%rip)        # a19a10 <_DYNAMIC+0x440>
  6db5f7:	pop    %rbx
  6db5f8:	ret
  6db5f9:	xor    %eax,%eax
  6db5fb:	pop    %rbx
  6db5fc:	ret

/tmp/gpui-inspector-pointer-codegen/candidate-frozen:     file format elf64-x86-64


Disassembly of section .text:

00000000006dd7a0 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE23inspector_pick_in_sheetB10_>:
  6dd7a0:	push   %r15
  6dd7a2:	push   %r14
  6dd7a4:	push   %r12
  6dd7a6:	push   %rbx
  6dd7a7:	sub    $0x38,%rsp
  6dd7ab:	mov    0x638(%rdi),%r15
  6dd7b2:	test   %r15,%r15
  6dd7b5:	je     6dd869 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE23inspector_pick_in_sheetB10_+0xc9>
  6dd7bb:	cmpq   $0x0,0xd8(%r15)
  6dd7c3:	je     6dd869 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE23inspector_pick_in_sheetB10_+0xc9>
  6dd7c9:	mov    0x2c8(%rdi),%r14
  6dd7d0:	cmp    $0x1c,%r14
  6dd7d4:	jb     6dd869 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE23inspector_pick_in_sheetB10_+0xc9>
  6dd7da:	mov    %rdi,%rbx
  6dd7dd:	mov    %rsi,%r12
  6dd7e0:	mov    %rsi,%rdi
  6dd7e3:	call   *0x33c447(%rip)        # a19c30 <_DYNAMIC+0x660>
  6dd7e9:	test   $0x1,%al
  6dd7eb:	je     6dd869 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE23inspector_pick_in_sheetB10_+0xc9>
  6dd7ed:	mov    0x8(%r12),%rsi
  6dd7f2:	cmp    %rsi,%rdx
  6dd7f5:	jae    6dd8b9 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE23inspector_pick_in_sheetB10_+0x119>
  6dd7fb:	mov    (%r12),%rax
  6dd7ff:	shl    $0x6,%rdx
  6dd803:	lea    0x5d8(%rbx),%rdi
  6dd80a:	mov    0x20(%rax,%rdx,1),%rsi
  6dd80f:	call   *0x33c1fb(%rip)        # a19a10 <_DYNAMIC+0x440>
  6dd815:	mov    %rbx,%rsi
  6dd818:	mov    %rdx,%rbx
  6dd81b:	cmp    0x5d8(%rsi),%rax
  6dd822:	jne    6dd8b5 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE23inspector_pick_in_sheetB10_+0x115>
  6dd828:	mov    %rax,%r12
  6dd82b:	mov    %rsp,%rdi
  6dd82e:	mov    %rbx,%rdx
  6dd831:	call   6f8950 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE16resolve_identityBO_>
  6dd836:	mov    (%rsp),%rcx
  6dd83a:	mov    0x8(%rsp),%rax
  6dd83f:	cmp    $0xfffffffffffffffe,%rcx
  6dd843:	jne    6dd87a <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE23inspector_pick_in_sheetB10_+0xda>
  6dd845:	cmpq   $0x0,0xd8(%r15)
  6dd84d:	je     6dd8b5 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE23inspector_pick_in_sheetB10_+0x115>
  6dd84f:	add    $0xffffffffffffffe4,%r14
  6dd853:	cmp    $0x2,%rax
  6dd857:	setae  %cl
  6dd85a:	cmp    %r14,%rax
  6dd85d:	setb   %al
  6dd860:	test   %al,%cl
  6dd862:	je     6dd8b5 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE23inspector_pick_in_sheetB10_+0x115>
  6dd864:	mov    %r12,%rax
  6dd867:	jmp    6dd86b <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE23inspector_pick_in_sheetB10_+0xcb>
  6dd869:	xor    %eax,%eax
  6dd86b:	mov    %rbx,%rdx
  6dd86e:	add    $0x38,%rsp
  6dd872:	pop    %rbx
  6dd873:	pop    %r12
  6dd875:	pop    %r14
  6dd877:	pop    %r15
  6dd879:	ret
  6dd87a:	mov    0x18(%rsp),%rsi
  6dd87f:	mov    0x20(%rsp),%rdi
  6dd884:	cmp    $0xc,%rcx
  6dd888:	jle    6dd8a5 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE23inspector_pick_in_sheetB10_+0x105>
  6dd88a:	cmp    $0x21,%rcx
  6dd88e:	je     6dd8a5 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE23inspector_pick_in_sheetB10_+0x105>
  6dd890:	cmp    $0x26,%rcx
  6dd894:	jne    6dd8b5 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE23inspector_pick_in_sheetB10_+0x115>
  6dd896:	test   %rax,%rax
  6dd899:	je     6dd8b5 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE23inspector_pick_in_sheetB10_+0x115>
  6dd89b:	mov    0x10(%rsp),%rdi
  6dd8a0:	mov    %rax,%rsi
  6dd8a3:	jmp    6dd8aa <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE23inspector_pick_in_sheetB10_+0x10a>
  6dd8a5:	test   %rsi,%rsi
  6dd8a8:	je     6dd8b5 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE23inspector_pick_in_sheetB10_+0x115>
  6dd8aa:	mov    $0x1,%edx
  6dd8af:	call   *0x33bf5b(%rip)        # a19810 <_DYNAMIC+0x240>
  6dd8b5:	xor    %eax,%eax
  6dd8b7:	jmp    6dd86b <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime9inspectorINtB7_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE23inspector_pick_in_sheetB10_+0xcb>
  6dd8b9:	lea    0x31d588(%rip),%rax        # 9fae48 <__frame_dummy_init_array_entry+0x1048>
  6dd8c0:	mov    %rdx,%rdi
  6dd8c3:	mov    %rax,%rdx
  6dd8c6:	call   *0x33bf74(%rip)        # a19840 <_DYNAMIC+0x270>

/tmp/gpui-inspector-pointer-codegen/candidate-frozen:     file format elf64-x86-64


Disassembly of section .text:

00000000006e7a60 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE12hit_in_sheetBO_>:
  6e7a60:	push   %rbp
  6e7a61:	push   %r15
  6e7a63:	push   %r14
  6e7a65:	push   %r13
  6e7a67:	push   %r12
  6e7a69:	push   %rbx
  6e7a6a:	push   %rax
  6e7a6b:	mov    %rsi,%r14
  6e7a6e:	mov    %rdi,%rbx
  6e7a71:	mov    %rsi,%rdi
  6e7a74:	movss  %xmm0,(%rsp)
  6e7a79:	movss  %xmm1,0x4(%rsp)
  6e7a7f:	call   *0x331f83(%rip)        # a19a08 <_DYNAMIC+0x438>
  6e7a85:	test   %al,%al
  6e7a87:	je     6e7c49 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE12hit_in_sheetBO_+0x1e9>
  6e7a8d:	mov    %r14,%rdi
  6e7a90:	movss  (%rsp),%xmm0
  6e7a95:	movss  0x4(%rsp),%xmm1
  6e7a9b:	call   *0x33218f(%rip)        # a19c30 <_DYNAMIC+0x660>
  6e7aa1:	test   $0x1,%al
  6e7aa3:	je     6e7c49 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE12hit_in_sheetBO_+0x1e9>
  6e7aa9:	mov    %rdx,%rdi
  6e7aac:	mov    (%r14),%r8
  6e7aaf:	mov    0x8(%r14),%rsi
  6e7ab3:	mov    0x1e8(%rbx),%r9
  6e7aba:	mov    0x1f0(%rbx),%r10
  6e7ac1:	mov    0x1f8(%rbx),%r11
  6e7ac8:	mov    0x2c8(%rbx),%rcx
  6e7acf:	mov    0x2c0(%rbx),%rbx
  6e7ad6:	jmp    6e7af7 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE12hit_in_sheetBO_+0x97>
  6e7ad8:	nopl   0x0(%rax,%rax,1)
  6e7ae0:	mov    0x38(%r14),%edi
  6e7ae4:	and    $0x1ffff,%edi
  6e7aea:	cmp    $0x1ffff,%rdi
  6e7af1:	je     6e7c5a <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE12hit_in_sheetBO_+0x1fa>
  6e7af7:	cmp    %rsi,%rdi
  6e7afa:	jae    6e7c5e <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE12hit_in_sheetBO_+0x1fe>
  6e7b00:	shl    $0x6,%rdi
  6e7b04:	lea    (%r8,%rdi,1),%r14
  6e7b08:	mov    0x20(%r8,%rdi,1),%rdx
  6e7b0d:	test   %r9,%r9
  6e7b10:	je     6e7b30 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE12hit_in_sheetBO_+0xd0>
  6e7b12:	cmp    $0x1,%r9d
  6e7b16:	jne    6e7b50 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE12hit_in_sheetBO_+0xf0>
  6e7b18:	test   %r11,%r11
  6e7b1b:	je     6e7ae0 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE12hit_in_sheetBO_+0x80>
  6e7b1d:	cmp    $0x1,%r11
  6e7b21:	jne    6e7b70 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE12hit_in_sheetBO_+0x110>
  6e7b23:	xor    %eax,%eax
  6e7b25:	jmp    6e7ba4 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE12hit_in_sheetBO_+0x144>
  6e7b27:	nopw   0x0(%rax,%rax,1)
  6e7b30:	mov    %rdx,%rdi
  6e7b33:	sub    %r10,%rdi
  6e7b36:	setae  %al
  6e7b39:	cmp    %r11,%rdi
  6e7b3c:	setb   %bpl
  6e7b40:	test   %bpl,%al
  6e7b43:	je     6e7ae0 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE12hit_in_sheetBO_+0x80>
  6e7b45:	jmp    6e7c26 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE12hit_in_sheetBO_+0x1c6>
  6e7b4a:	nopw   0x0(%rax,%rax,1)
  6e7b50:	test   %r11,%r11
  6e7b53:	je     6e7ae0 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE12hit_in_sheetBO_+0x80>
  6e7b55:	cmp    $0x1,%r11
  6e7b59:	jne    6e7be5 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE12hit_in_sheetBO_+0x185>
  6e7b5f:	mov    %r10,%rax
  6e7b62:	cmp    %rdx,(%r10)
  6e7b65:	jne    6e7ae0 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE12hit_in_sheetBO_+0x80>
  6e7b6b:	jmp    6e7c23 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE12hit_in_sheetBO_+0x1c3>
  6e7b70:	mov    %r11,%rdi
  6e7b73:	xor    %eax,%eax
  6e7b75:	data16 cs nopw 0x0(%rax,%rax,1)
  6e7b80:	mov    %rax,%r15
  6e7b83:	mov    %rdi,%r12
  6e7b86:	shr    $1,%r12
  6e7b89:	add    %r12,%rax
  6e7b8c:	mov    %rax,%r13
  6e7b8f:	shl    $0x4,%r13
  6e7b93:	cmp    %rdx,(%r10,%r13,1)
  6e7b97:	cmova  %r15,%rax
  6e7b9b:	sub    %r12,%rdi
  6e7b9e:	cmp    $0x1,%rdi
  6e7ba2:	ja     6e7b80 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE12hit_in_sheetBO_+0x120>
  6e7ba4:	mov    %rax,%rdi
  6e7ba7:	shl    $0x4,%rdi
  6e7bab:	xor    %r15d,%r15d
  6e7bae:	cmp    %rdx,(%r10,%rdi,1)
  6e7bb2:	setbe  %r15b
  6e7bb6:	add    %rax,%r15
  6e7bb9:	je     6e7ae0 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE12hit_in_sheetBO_+0x80>
  6e7bbf:	shl    $0x4,%r15
  6e7bc3:	mov    %rdx,%rdi
  6e7bc6:	sub    -0x10(%r10,%r15,1),%rdi
  6e7bcb:	mov    -0x4(%r10,%r15,1),%eax
  6e7bd0:	cmp    %rax,%rdi
  6e7bd3:	jae    6e7ae0 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE12hit_in_sheetBO_+0x80>
  6e7bd9:	add    %r10,%r15
  6e7bdc:	mov    -0x8(%r15),%eax
  6e7be0:	add    %rax,%rdi
  6e7be3:	jmp    6e7c26 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE12hit_in_sheetBO_+0x1c6>
  6e7be5:	mov    %r11,%rax
  6e7be8:	xor    %edi,%edi
  6e7bea:	nopw   0x0(%rax,%rax,1)
  6e7bf0:	mov    %rdi,%r15
  6e7bf3:	mov    %rax,%r12
  6e7bf6:	shr    $1,%r12
  6e7bf9:	add    %r12,%rdi
  6e7bfc:	lea    (%rdi,%rdi,2),%r13
  6e7c00:	cmp    %rdx,(%r10,%r13,4)
  6e7c04:	cmova  %r15,%rdi
  6e7c08:	sub    %r12,%rax
  6e7c0b:	cmp    $0x1,%rax
  6e7c0f:	ja     6e7bf0 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE12hit_in_sheetBO_+0x190>
  6e7c11:	lea    (%rdi,%rdi,2),%rax
  6e7c15:	cmp    %rdx,(%r10,%rax,4)
  6e7c19:	jne    6e7ae0 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE12hit_in_sheetBO_+0x80>
  6e7c1f:	lea    (%r10,%rax,4),%rax
  6e7c23:	mov    0x8(%rax),%edi
  6e7c26:	cmp    %rcx,%rdi
  6e7c29:	jae    6e7c6b <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE12hit_in_sheetBO_+0x20b>
  6e7c2b:	lea    (%rdi,%rdi,4),%rdi
  6e7c2f:	mov    $0x1,%eax
  6e7c34:	cmpq   $0x0,0x8(%rbx,%rdi,8)
  6e7c3a:	jne    6e7c4b <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE12hit_in_sheetBO_+0x1eb>
  6e7c3c:	cmpb   $0x4,0x3d(%r14)
  6e7c41:	jne    6e7ae0 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE12hit_in_sheetBO_+0x80>
  6e7c47:	jmp    6e7c4b <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE12hit_in_sheetBO_+0x1eb>
  6e7c49:	xor    %eax,%eax
  6e7c4b:	add    $0x8,%rsp
  6e7c4f:	pop    %rbx
  6e7c50:	pop    %r12
  6e7c52:	pop    %r13
  6e7c54:	pop    %r14
  6e7c56:	pop    %r15
  6e7c58:	pop    %rbp
  6e7c59:	ret
  6e7c5a:	xor    %eax,%eax
  6e7c5c:	jmp    6e7c4b <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE12hit_in_sheetBO_+0x1eb>
  6e7c5e:	lea    0x3133c3(%rip),%rdx        # 9fb028 <__frame_dummy_init_array_entry+0x1228>
  6e7c65:	call   *0x331bd5(%rip)        # a19840 <_DYNAMIC+0x270>
  6e7c6b:	lea    0x3133ce(%rip),%rdx        # 9fb040 <__frame_dummy_init_array_entry+0x1240>
  6e7c72:	mov    %rcx,%rsi
  6e7c75:	call   *0x331bc5(%rip)        # a19840 <_DYNAMIC+0x270>

/tmp/gpui-inspector-pointer-codegen/candidate-frozen:     file format elf64-x86-64


Disassembly of section .text:

00000000006f8c30 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_>:
  6f8c30:	push   %r15
  6f8c32:	push   %r14
  6f8c34:	push   %r12
  6f8c36:	push   %rbx
  6f8c37:	sub    $0x58,%rsp
  6f8c3b:	mov    0x5a0(%rdi),%rbx
  6f8c42:	mov    0x5a8(%rdi),%r14
  6f8c49:	mov    0x638(%rdi),%r15
  6f8c50:	test   %r15,%r15
  6f8c53:	je     6f8c8d <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x5d>
  6f8c55:	mov    0x100(%r15),%rsi
  6f8c5c:	test   %rsi,%rsi
  6f8c5f:	je     6f8ca2 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x72>
  6f8c61:	lea    0x8(%rsp),%rax
  6f8c66:	mov    %rdi,%r12
  6f8c69:	mov    %rax,%rdi
  6f8c6c:	movss  %xmm1,0x4(%rsp)
  6f8c72:	movss  %xmm0,(%rsp)
  6f8c77:	call   *0x320dc3(%rip)        # a19a40 <_DYNAMIC+0x470>
  6f8c7d:	movss  (%rsp),%xmm0
  6f8c82:	movss  0x4(%rsp),%xmm1
  6f8c88:	mov    %r12,%rdi
  6f8c8b:	jmp    6f8cb3 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x83>
  6f8c8d:	movq   $0x4,0x8(%rsp)
  6f8c96:	xorps  %xmm2,%xmm2
  6f8c99:	movups %xmm2,0x10(%rsp)
  6f8c9e:	xor    %eax,%eax
  6f8ca0:	jmp    6f8cba <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE3hitBO_+0x8a>
  6f8ca2:	movq   $0x4,0x8(%rsp)
  6f8cab:	xorps  %xmm2,%xmm2
  6f8cae:	movups %xmm2,0x10(%rsp)
  6f8cb3:	cmpq   $0x0,(%r15)
  6f8cb7:	setne  %al
  6f8cba:	mov    0x698(%rdi),%rcx
  6f8cc1:	mov    %rbx,0x20(%rsp)
  6f8cc6:	mov    %r14,0x28(%rsp)
  6f8ccb:	mov    0x8(%rsp),%rdx
  6f8cd0:	mov    %rdx,0x30(%rsp)
  6f8cd5:	mov    0x10(%rsp),%rdx
  6f8cda:	mov    %rdx,0x38(%rsp)
  6f8cdf:	mov    0x18(%rsp),%rdx
  6f8ce4:	mov    %rdx,0x40(%rsp)
  6f8ce9:	mov    %rcx,0x48(%rsp)
  6f8cee:	mov    %al,0x50(%rsp)
  6f8cf2:	lea    0x20(%rsp),%rsi
  6f8cf7:	call   6e7a60 <_RNvMst_NtCs6ZNK6sH19NW_4gpui7runtimeINtB5_7RuntimeNtCs4gijoeCAvqI_25inspector_pointer_control5ModelE12hit_in_sheetBO_>
  6f8cfc:	add    $0x58,%rsp
  6f8d00:	pop    %rbx
  6f8d01:	pop    %r12
  6f8d03:	pop    %r14
  6f8d05:	pop    %r15
  6f8d07:	ret

/tmp/gpui-inspector-pointer-codegen/candidate-frozen:     file format elf64-x86-64


Disassembly of section .text:

000000000070ab80 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5queryNtB5_8HitSheet3hit>:
  70ab80:	push   %rbp
  70ab81:	push   %r15
  70ab83:	push   %r14
  70ab85:	push   %r13
  70ab87:	push   %r12
  70ab89:	push   %rbx
  70ab8a:	push   %rax
  70ab8b:	movss  %xmm1,0x4(%rsp)
  70ab91:	movss  %xmm0,(%rsp)
  70ab96:	mov    0x8(%rdi),%r15
  70ab9a:	test   %r15,%r15
  70ab9d:	je     70ac39 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5queryNtB5_8HitSheet3hit+0xb9>
  70aba3:	mov    %rdi,%r14
  70aba6:	mov    (%rdi),%r12
  70aba9:	mov    %r15,%rax
  70abac:	shl    $0x6,%rax
  70abb0:	add    %r12,%rax
  70abb3:	movzbl 0x30(%rdi),%ebp
  70abb7:	add    $0x10,%r14
  70abbb:	jmp    70abf5 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5queryNtB5_8HitSheet3hit+0x75>
  70abbd:	nopl   (%rax)
  70abc0:	mov    %rbx,%r13
  70abc3:	sub    %r12,%r13
  70abc6:	shr    $0x6,%r13
  70abca:	mov    %r12,%rdi
  70abcd:	mov    %r15,%rsi
  70abd0:	mov    %r14,%rdx
  70abd3:	mov    %ebp,%ecx
  70abd5:	mov    %r13,%r8
  70abd8:	movss  (%rsp),%xmm0
  70abdd:	movss  0x4(%rsp),%xmm1
  70abe3:	call   *0x30eedf(%rip)        # a19ac8 <_DYNAMIC+0x4f8>
  70abe9:	test   %al,%al
  70abeb:	jne    70ac3d <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5queryNtB5_8HitSheet3hit+0xbd>
  70abed:	mov    %rbx,%rax
  70abf0:	cmp    %rbx,%r12
  70abf3:	je     70ac35 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5queryNtB5_8HitSheet3hit+0xb5>
  70abf5:	lea    -0x40(%rax),%rbx
  70abf9:	cmpb   $0x0,-0x2(%rax)
  70abfd:	jne    70abc0 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5queryNtB5_8HitSheet3hit+0x40>
  70abff:	mov    -0x8(%rax),%eax
  70ac02:	cmp    $0x3ffff,%rax
  70ac08:	jbe    70abed <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5queryNtB5_8HitSheet3hit+0x6d>
  70ac0a:	shr    $0x11,%eax
  70ac0d:	mov    %rbx,%rcx
  70ac10:	sub    %r12,%rcx
  70ac13:	shr    $0x6,%rcx
  70ac17:	mov    $0x2,%edx
  70ac1c:	sub    %rax,%rdx
  70ac1f:	add    $0xfffffffffffffffe,%rax
  70ac23:	shl    $0x6,%rdx
  70ac27:	cmp    %rcx,%rax
  70ac2a:	lea    -0x40(%rbx,%rdx,1),%rbx
  70ac2f:	cmovae %r12,%rbx
  70ac33:	jmp    70abed <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5queryNtB5_8HitSheet3hit+0x6d>
  70ac35:	xor    %eax,%eax
  70ac37:	jmp    70ac42 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5queryNtB5_8HitSheet3hit+0xc2>
  70ac39:	xor    %eax,%eax
  70ac3b:	jmp    70ac42 <_RNvMs2_NtNtCs6ZNK6sH19NW_4gpui7runtime5queryNtB5_8HitSheet3hit+0xc2>
  70ac3d:	mov    $0x1,%eax
  70ac42:	mov    %r13,%rdx
  70ac45:	add    $0x8,%rsp
  70ac49:	pop    %rbx
  70ac4a:	pop    %r12
  70ac4c:	pop    %r13
  70ac4e:	pop    %r14
  70ac50:	pop    %r15
  70ac52:	pop    %rbp
  70ac53:	ret

<gpui::runtime::Runtime<inspector_pointer_control::Model>>::pointer_release_hit::{closure#2} bytes=257 stack=104

inspector_pointer_control::click_only bytes=1051 stack=152

inspector_pointer_control::ack bytes=241 stack=136

inspector_pointer_control::main bytes=7119 stack=3368

inspector_pointer_control::dispatch bytes=3949 stack=424

inspector_pointer_control::hit_only bytes=426 stack=136

<gpui::runtime::Runtime<inspector_pointer_control::Model>>::pointer_hit bytes=93 stack=8

<gpui::runtime::Runtime<inspector_pointer_control::Model>>::inspector_pick_in_sheet bytes=300 stack=88

<gpui::runtime::Runtime<inspector_pointer_control::Model>>::hit_in_sheet bytes=539 stack=56

<gpui::runtime::Runtime<inspector_pointer_control::Model>>::hit bytes=216 stack=120

<gpui::runtime::query::HitSheet>::hit bytes=212 stack=56
