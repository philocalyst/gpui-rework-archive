
/tmp/gpui-contained-owner-unit-baseline-target/release/deps/unit_action_cost-bcf457ce7db1ee75:     file format elf64-x86-64


Disassembly of section .text:

000000000070b750 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_input>:
  70b750:	41 57                	push   %r15
  70b752:	41 56                	push   %r14
  70b754:	41 55                	push   %r13
  70b756:	41 54                	push   %r12
  70b758:	53                   	push   %rbx
  70b759:	48 83 ec 40          	sub    $0x40,%rsp
  70b75d:	48 89 fb             	mov    %rdi,%rbx
  70b760:	80 be 22 07 00 00 00 	cmpb   $0x0,0x722(%rsi)
  70b767:	74 0c                	je     70b775 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_input+0x25>
  70b769:	48 c7 03 0e 00 00 00 	movq   $0xe,(%rbx)
  70b770:	e9 8c 01 00 00       	jmp    70b901 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_input+0x1b1>
  70b775:	4d 89 c7             	mov    %r8,%r15
  70b778:	49 89 f6             	mov    %rsi,%r14
  70b77b:	48 8d 7c 24 08       	lea    0x8(%rsp),%rdi
  70b780:	e8 eb e4 ff ff       	call   709c70 <<gpui::runtime::Runtime<unit_action_cost::Model>>::input_index>
  70b785:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  70b78a:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  70b78f:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  70b793:	0f 85 e2 00 00 00    	jne    70b87b <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_input+0x12b>
  70b799:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  70b7a0:	49 39 f4             	cmp    %rsi,%r12
  70b7a3:	0f 83 89 01 00 00    	jae    70b932 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_input+0x1e2>
  70b7a9:	4b 8d 04 a4          	lea    (%r12,%r12,4),%rax
  70b7ad:	49 8b 8e 98 02 00 00 	mov    0x298(%r14),%rcx
  70b7b4:	8b 7c c1 20          	mov    0x20(%rcx,%rax,8),%edi
  70b7b8:	89 f8                	mov    %edi,%eax
  70b7ba:	83 e0 07             	and    $0x7,%eax
  70b7bd:	83 f8 06             	cmp    $0x6,%eax
  70b7c0:	0f 84 49 01 00 00    	je     70b90f <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_input+0x1bf>
  70b7c6:	c1 ef 03             	shr    $0x3,%edi
  70b7c9:	0f 84 40 01 00 00    	je     70b90f <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_input+0x1bf>
  70b7cf:	49 8b b6 b8 02 00 00 	mov    0x2b8(%r14),%rsi
  70b7d6:	ff cf                	dec    %edi
  70b7d8:	48 39 fe             	cmp    %rdi,%rsi
  70b7db:	0f 86 61 01 00 00    	jbe    70b942 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_input+0x1f2>
  70b7e1:	49 8b 86 b0 02 00 00 	mov    0x2b0(%r14),%rax
  70b7e8:	48 8d 0c bf          	lea    (%rdi,%rdi,4),%rcx
  70b7ec:	48 c1 e1 04          	shl    $0x4,%rcx
  70b7f0:	48 83 3c 08 fe       	cmpq   $0xfffffffffffffffe,(%rax,%rcx,1)
  70b7f5:	0f 84 21 01 00 00    	je     70b91c <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_input+0x1cc>
  70b7fb:	48 01 c8             	add    %rcx,%rax
  70b7fe:	48 8b 78 40          	mov    0x40(%rax),%rdi
  70b802:	48 8b 37             	mov    (%rdi),%rsi
  70b805:	48 d1 ee             	shr    $1,%rsi
  70b808:	48 83 c7 10          	add    $0x10,%rdi
  70b80c:	4c 89 fa             	mov    %r15,%rdx
  70b80f:	ff 15 83 5d 3f 00    	call   *0x3f5d83(%rip)        # b01598 <_DYNAMIC+0x4a8>
  70b815:	84 c0                	test   %al,%al
  70b817:	0f 84 82 00 00 00    	je     70b89f <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_input+0x14f>
  70b81d:	4d 8b ae 60 06 00 00 	mov    0x660(%r14),%r13
  70b824:	49 ff c5             	inc    %r13
  70b827:	0f 84 fc 00 00 00    	je     70b929 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_input+0x1d9>
  70b82d:	49 c7 86 08 07 00 00 	movq   $0x0,0x708(%r14)
  70b834:	00 00 00 00 
  70b838:	4c 89 f7             	mov    %r14,%rdi
  70b83b:	4c 89 e6             	mov    %r12,%rsi
  70b83e:	4c 89 fa             	mov    %r15,%rdx
  70b841:	e8 4a e5 ff ff       	call   709d90 <<gpui::runtime::Runtime<unit_action_cost::Model>>::set_selection>
  70b846:	84 c0                	test   %al,%al
  70b848:	74 5e                	je     70b8a8 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_input+0x158>
  70b84a:	4d 89 ae 60 06 00 00 	mov    %r13,0x660(%r14)
  70b851:	49 ff 86 b0 06 00 00 	incq   0x6b0(%r14)
  70b858:	49 c7 86 08 07 00 00 	movq   $0x1,0x708(%r14)
  70b85f:	01 00 00 00 
  70b863:	48 89 df             	mov    %rbx,%rdi
  70b866:	4c 89 f6             	mov    %r14,%rsi
  70b869:	48 83 c4 40          	add    $0x40,%rsp
  70b86d:	5b                   	pop    %rbx
  70b86e:	41 5c                	pop    %r12
  70b870:	41 5d                	pop    %r13
  70b872:	41 5e                	pop    %r14
  70b874:	41 5f                	pop    %r15
  70b876:	e9 75 22 01 00       	jmp    71daf0 <<gpui::runtime::Runtime<unit_action_cost::Model>>::present>
  70b87b:	48 8b 4c 24 38       	mov    0x38(%rsp),%rcx
  70b880:	48 89 4b 30          	mov    %rcx,0x30(%rbx)
  70b884:	0f 10 44 24 18       	movups 0x18(%rsp),%xmm0
  70b889:	0f 10 4c 24 28       	movups 0x28(%rsp),%xmm1
  70b88e:	0f 11 4b 20          	movups %xmm1,0x20(%rbx)
  70b892:	0f 11 43 10          	movups %xmm0,0x10(%rbx)
  70b896:	48 89 03             	mov    %rax,(%rbx)
  70b899:	4c 89 63 08          	mov    %r12,0x8(%rbx)
  70b89d:	eb 62                	jmp    70b901 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_input+0x1b1>
  70b89f:	48 c7 03 18 00 00 00 	movq   $0x18,(%rbx)
  70b8a6:	eb 59                	jmp    70b901 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_input+0x1b1>
  70b8a8:	41 0f 10 86 60 06 00 	movups 0x660(%r14),%xmm0
  70b8af:	00 
  70b8b0:	41 0f b6 86 20 07 00 	movzbl 0x720(%r14),%eax
  70b8b7:	00 
  70b8b8:	49 83 be 80 06 00 00 	cmpq   $0x0,0x680(%r14)
  70b8bf:	00 
  70b8c0:	74 1c                	je     70b8de <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_input+0x18e>
  70b8c2:	84 c0                	test   %al,%al
  70b8c4:	74 0a                	je     70b8d0 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_input+0x180>
  70b8c6:	49 83 be 88 05 00 00 	cmpq   $0xffffffffffffffff,0x588(%r14)
  70b8cd:	ff 
  70b8ce:	74 0e                	je     70b8de <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_input+0x18e>
  70b8d0:	49 8b 96 90 06 00 00 	mov    0x690(%r14),%rdx
  70b8d7:	b9 01 00 00 00       	mov    $0x1,%ecx
  70b8dc:	eb 02                	jmp    70b8e0 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_input+0x190>
  70b8de:	31 c9                	xor    %ecx,%ecx
  70b8e0:	49 8b b6 08 07 00 00 	mov    0x708(%r14),%rsi
  70b8e7:	48 89 4b 08          	mov    %rcx,0x8(%rbx)
  70b8eb:	48 89 53 10          	mov    %rdx,0x10(%rbx)
  70b8ef:	0f 11 43 18          	movups %xmm0,0x18(%rbx)
  70b8f3:	48 89 73 28          	mov    %rsi,0x28(%rbx)
  70b8f7:	88 43 30             	mov    %al,0x30(%rbx)
  70b8fa:	48 c7 03 fe ff ff ff 	movq   $0xfffffffffffffffe,(%rbx)
  70b901:	48 83 c4 40          	add    $0x40,%rsp
  70b905:	5b                   	pop    %rbx
  70b906:	41 5c                	pop    %r12
  70b908:	41 5d                	pop    %r13
  70b90a:	41 5e                	pop    %r14
  70b90c:	41 5f                	pop    %r15
  70b90e:	c3                   	ret
  70b90f:	48 8d 3d 12 7b 3c 00 	lea    0x3c7b12(%rip),%rdi        # ad3428 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.15092672030101349239+0x810>
  70b916:	ff 15 5c 5a 3f 00    	call   *0x3f5a5c(%rip)        # b01378 <_DYNAMIC+0x288>
  70b91c:	48 8d 3d 65 75 3c 00 	lea    0x3c7565(%rip),%rdi        # ad2e88 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.15092672030101349239+0x270>
  70b923:	ff 15 4f 5a 3f 00    	call   *0x3f5a4f(%rip)        # b01378 <_DYNAMIC+0x288>
  70b929:	48 c7 03 1f 00 00 00 	movq   $0x1f,(%rbx)
  70b930:	eb cf                	jmp    70b901 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::select_input+0x1b1>
  70b932:	48 8d 15 d7 7a 3c 00 	lea    0x3c7ad7(%rip),%rdx        # ad3410 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.15092672030101349239+0x7f8>
  70b939:	4c 89 e7             	mov    %r12,%rdi
  70b93c:	ff 15 26 5b 3f 00    	call   *0x3f5b26(%rip)        # b01468 <_DYNAMIC+0x378>
  70b942:	48 8d 15 27 75 3c 00 	lea    0x3c7527(%rip),%rdx        # ad2e70 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.15092672030101349239+0x258>
  70b949:	ff 15 19 5b 3f 00    	call   *0x3f5b19(%rip)        # b01468 <_DYNAMIC+0x378>
