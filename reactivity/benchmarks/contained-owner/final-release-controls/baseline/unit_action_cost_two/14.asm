
/tmp/gpui-contained-owner-unit-baseline-target/release/deps/unit_action_cost_two-c899ee77dd9a9ab3:     file format elf64-x86-64


Disassembly of section .text:

0000000000703810 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_input>:
  703810:	41 57                	push   %r15
  703812:	41 56                	push   %r14
  703814:	41 55                	push   %r13
  703816:	41 54                	push   %r12
  703818:	53                   	push   %rbx
  703819:	48 83 ec 40          	sub    $0x40,%rsp
  70381d:	48 89 fb             	mov    %rdi,%rbx
  703820:	80 be 22 08 00 00 00 	cmpb   $0x0,0x822(%rsi)
  703827:	74 0c                	je     703835 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_input+0x25>
  703829:	48 c7 03 0e 00 00 00 	movq   $0xe,(%rbx)
  703830:	e9 8c 01 00 00       	jmp    7039c1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_input+0x1b1>
  703835:	4d 89 c7             	mov    %r8,%r15
  703838:	49 89 f6             	mov    %rsi,%r14
  70383b:	48 8d 7c 24 08       	lea    0x8(%rsp),%rdi
  703840:	e8 1b c9 ff ff       	call   700160 <<gpui::runtime::Runtime<unit_action_cost_two::SecondModel>>::input_index>
  703845:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  70384a:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  70384f:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  703853:	0f 85 e2 00 00 00    	jne    70393b <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_input+0x12b>
  703859:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  703860:	49 39 f4             	cmp    %rsi,%r12
  703863:	0f 83 89 01 00 00    	jae    7039f2 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_input+0x1e2>
  703869:	4b 8d 04 a4          	lea    (%r12,%r12,4),%rax
  70386d:	49 8b 8e 98 02 00 00 	mov    0x298(%r14),%rcx
  703874:	8b 7c c1 20          	mov    0x20(%rcx,%rax,8),%edi
  703878:	89 f8                	mov    %edi,%eax
  70387a:	83 e0 07             	and    $0x7,%eax
  70387d:	83 f8 06             	cmp    $0x6,%eax
  703880:	0f 84 49 01 00 00    	je     7039cf <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_input+0x1bf>
  703886:	c1 ef 03             	shr    $0x3,%edi
  703889:	0f 84 40 01 00 00    	je     7039cf <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_input+0x1bf>
  70388f:	49 8b b6 b8 02 00 00 	mov    0x2b8(%r14),%rsi
  703896:	ff cf                	dec    %edi
  703898:	48 39 fe             	cmp    %rdi,%rsi
  70389b:	0f 86 61 01 00 00    	jbe    703a02 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_input+0x1f2>
  7038a1:	49 8b 86 b0 02 00 00 	mov    0x2b0(%r14),%rax
  7038a8:	48 8d 0c bf          	lea    (%rdi,%rdi,4),%rcx
  7038ac:	48 c1 e1 04          	shl    $0x4,%rcx
  7038b0:	48 83 3c 08 fe       	cmpq   $0xfffffffffffffffe,(%rax,%rcx,1)
  7038b5:	0f 84 21 01 00 00    	je     7039dc <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_input+0x1cc>
  7038bb:	48 01 c8             	add    %rcx,%rax
  7038be:	48 8b 78 40          	mov    0x40(%rax),%rdi
  7038c2:	48 8b 37             	mov    (%rdi),%rsi
  7038c5:	48 d1 ee             	shr    $1,%rsi
  7038c8:	48 83 c7 10          	add    $0x10,%rdi
  7038cc:	4c 89 fa             	mov    %r15,%rdx
  7038cf:	ff 15 73 48 42 00    	call   *0x424873(%rip)        # b28148 <_DYNAMIC+0x490>
  7038d5:	84 c0                	test   %al,%al
  7038d7:	0f 84 82 00 00 00    	je     70395f <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_input+0x14f>
  7038dd:	4d 8b ae 60 06 00 00 	mov    0x660(%r14),%r13
  7038e4:	49 ff c5             	inc    %r13
  7038e7:	0f 84 fc 00 00 00    	je     7039e9 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_input+0x1d9>
  7038ed:	49 c7 86 08 07 00 00 	movq   $0x0,0x708(%r14)
  7038f4:	00 00 00 00 
  7038f8:	4c 89 f7             	mov    %r14,%rdi
  7038fb:	4c 89 e6             	mov    %r12,%rsi
  7038fe:	4c 89 fa             	mov    %r15,%rdx
  703901:	e8 7a c9 ff ff       	call   700280 <<gpui::runtime::Runtime<unit_action_cost_two::SecondModel>>::set_selection>
  703906:	84 c0                	test   %al,%al
  703908:	74 5e                	je     703968 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_input+0x158>
  70390a:	4d 89 ae 60 06 00 00 	mov    %r13,0x660(%r14)
  703911:	49 ff 86 b0 06 00 00 	incq   0x6b0(%r14)
  703918:	49 c7 86 08 07 00 00 	movq   $0x1,0x708(%r14)
  70391f:	01 00 00 00 
  703923:	48 89 df             	mov    %rbx,%rdi
  703926:	4c 89 f6             	mov    %r14,%rsi
  703929:	48 83 c4 40          	add    $0x40,%rsp
  70392d:	5b                   	pop    %rbx
  70392e:	41 5c                	pop    %r12
  703930:	41 5d                	pop    %r13
  703932:	41 5e                	pop    %r14
  703934:	41 5f                	pop    %r15
  703936:	e9 e5 5f 01 00       	jmp    719920 <<gpui::runtime::Runtime<unit_action_cost_two::SecondModel>>::present>
  70393b:	48 8b 4c 24 38       	mov    0x38(%rsp),%rcx
  703940:	48 89 4b 30          	mov    %rcx,0x30(%rbx)
  703944:	0f 10 44 24 18       	movups 0x18(%rsp),%xmm0
  703949:	0f 10 4c 24 28       	movups 0x28(%rsp),%xmm1
  70394e:	0f 11 4b 20          	movups %xmm1,0x20(%rbx)
  703952:	0f 11 43 10          	movups %xmm0,0x10(%rbx)
  703956:	48 89 03             	mov    %rax,(%rbx)
  703959:	4c 89 63 08          	mov    %r12,0x8(%rbx)
  70395d:	eb 62                	jmp    7039c1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_input+0x1b1>
  70395f:	48 c7 03 18 00 00 00 	movq   $0x18,(%rbx)
  703966:	eb 59                	jmp    7039c1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_input+0x1b1>
  703968:	41 0f 10 86 60 06 00 	movups 0x660(%r14),%xmm0
  70396f:	00 
  703970:	41 0f b6 86 20 08 00 	movzbl 0x820(%r14),%eax
  703977:	00 
  703978:	49 83 be 80 06 00 00 	cmpq   $0x0,0x680(%r14)
  70397f:	00 
  703980:	74 1c                	je     70399e <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_input+0x18e>
  703982:	84 c0                	test   %al,%al
  703984:	74 0a                	je     703990 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_input+0x180>
  703986:	49 83 be 88 05 00 00 	cmpq   $0xffffffffffffffff,0x588(%r14)
  70398d:	ff 
  70398e:	74 0e                	je     70399e <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_input+0x18e>
  703990:	49 8b 96 90 06 00 00 	mov    0x690(%r14),%rdx
  703997:	b9 01 00 00 00       	mov    $0x1,%ecx
  70399c:	eb 02                	jmp    7039a0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_input+0x190>
  70399e:	31 c9                	xor    %ecx,%ecx
  7039a0:	49 8b b6 08 07 00 00 	mov    0x708(%r14),%rsi
  7039a7:	48 89 4b 08          	mov    %rcx,0x8(%rbx)
  7039ab:	48 89 53 10          	mov    %rdx,0x10(%rbx)
  7039af:	0f 11 43 18          	movups %xmm0,0x18(%rbx)
  7039b3:	48 89 73 28          	mov    %rsi,0x28(%rbx)
  7039b7:	88 43 30             	mov    %al,0x30(%rbx)
  7039ba:	48 c7 03 fe ff ff ff 	movq   $0xfffffffffffffffe,(%rbx)
  7039c1:	48 83 c4 40          	add    $0x40,%rsp
  7039c5:	5b                   	pop    %rbx
  7039c6:	41 5c                	pop    %r12
  7039c8:	41 5d                	pop    %r13
  7039ca:	41 5e                	pop    %r14
  7039cc:	41 5f                	pop    %r15
  7039ce:	c3                   	ret
  7039cf:	48 8d 3d 42 62 3f 00 	lea    0x3f6242(%rip),%rdi        # af9c18 <__frame_dummy_init_array_entry+0x6f0>
  7039d6:	ff 15 e4 45 42 00    	call   *0x4245e4(%rip)        # b27fc0 <_DYNAMIC+0x308>
  7039dc:	48 8d 3d 95 5c 3f 00 	lea    0x3f5c95(%rip),%rdi        # af9678 <__frame_dummy_init_array_entry+0x150>
  7039e3:	ff 15 d7 45 42 00    	call   *0x4245d7(%rip)        # b27fc0 <_DYNAMIC+0x308>
  7039e9:	48 c7 03 1f 00 00 00 	movq   $0x1f,(%rbx)
  7039f0:	eb cf                	jmp    7039c1 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_input+0x1b1>
  7039f2:	48 8d 15 07 62 3f 00 	lea    0x3f6207(%rip),%rdx        # af9c00 <__frame_dummy_init_array_entry+0x6d8>
  7039f9:	4c 89 e7             	mov    %r12,%rdi
  7039fc:	ff 15 0e 46 42 00    	call   *0x42460e(%rip)        # b28010 <_DYNAMIC+0x358>
  703a02:	48 8d 15 57 5c 3f 00 	lea    0x3f5c57(%rip),%rdx        # af9660 <__frame_dummy_init_array_entry+0x138>
  703a09:	ff 15 01 46 42 00    	call   *0x424601(%rip)        # b28010 <_DYNAMIC+0x358>
