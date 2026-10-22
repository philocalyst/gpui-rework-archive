
/tmp/gpui-contained-owner-spike-target/release/deps/unit_action_cost_two-c899ee77dd9a9ab3:     file format elf64-x86-64


Disassembly of section .text:

000000000070a850 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::inspector_select>:
  70a850:	41 57                	push   %r15
  70a852:	41 56                	push   %r14
  70a854:	41 55                	push   %r13
  70a856:	41 54                	push   %r12
  70a858:	53                   	push   %rbx
  70a859:	48 83 ec 60          	sub    $0x60,%rsp
  70a85d:	80 be 22 07 00 00 00 	cmpb   $0x0,0x722(%rsi)
  70a864:	74 0c                	je     70a872 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::inspector_select+0x22>
  70a866:	48 c7 07 0e 00 00 00 	movq   $0xe,(%rdi)
  70a86d:	e9 69 01 00 00       	jmp    70a9db <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::inspector_select+0x18b>
  70a872:	48 3b 96 b0 05 00 00 	cmp    0x5b0(%rsi),%rdx
  70a879:	0f 85 14 01 00 00    	jne    70a993 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::inspector_select+0x143>
  70a87f:	49 89 d6             	mov    %rdx,%r14
  70a882:	48 89 fb             	mov    %rdi,%rbx
  70a885:	48 8d 7c 24 28       	lea    0x28(%rsp),%rdi
  70a88a:	49 89 f4             	mov    %rsi,%r12
  70a88d:	49 89 cf             	mov    %rcx,%r15
  70a890:	48 89 ca             	mov    %rcx,%rdx
  70a893:	e8 88 e4 01 00       	call   728d20 <<gpui::runtime::Runtime<unit_action_cost_two::Model>>::resolve_identity>
  70a898:	48 8b 4c 24 28       	mov    0x28(%rsp),%rcx
  70a89d:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
  70a8a2:	48 83 f9 fe          	cmp    $0xfffffffffffffffe,%rcx
  70a8a6:	0f 85 ee 00 00 00    	jne    70a99a <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::inspector_select+0x14a>
  70a8ac:	49 8b b4 24 10 06 00 	mov    0x610(%r12),%rsi
  70a8b3:	00 
  70a8b4:	b9 1a 00 00 00       	mov    $0x1a,%ecx
  70a8b9:	48 85 f6             	test   %rsi,%rsi
  70a8bc:	48 89 df             	mov    %rbx,%rdi
  70a8bf:	0f 84 29 01 00 00    	je     70a9ee <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::inspector_select+0x19e>
  70a8c5:	48 83 be d8 00 00 00 	cmpq   $0x0,0xd8(%rsi)
  70a8cc:	00 
  70a8cd:	0f 84 1b 01 00 00    	je     70a9ee <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::inspector_select+0x19e>
  70a8d3:	4c 89 e2             	mov    %r12,%rdx
  70a8d6:	49 8b b4 24 a0 02 00 	mov    0x2a0(%r12),%rsi
  70a8dd:	00 
  70a8de:	48 83 fe 1c          	cmp    $0x1c,%rsi
  70a8e2:	0f 82 d2 00 00 00    	jb     70a9ba <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::inspector_select+0x16a>
  70a8e8:	48 83 c6 e4          	add    $0xffffffffffffffe4,%rsi
  70a8ec:	48 83 f8 02          	cmp    $0x2,%rax
  70a8f0:	0f 93 c1             	setae  %cl
  70a8f3:	48 39 f0             	cmp    %rsi,%rax
  70a8f6:	0f 92 c0             	setb   %al
  70a8f9:	84 c1                	test   %al,%cl
  70a8fb:	0f 84 e8 00 00 00    	je     70a9e9 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::inspector_select+0x199>
  70a901:	4c 8b aa 60 06 00 00 	mov    0x660(%rdx),%r13
  70a908:	49 83 fd ff          	cmp    $0xffffffffffffffff,%r13
  70a90c:	0f 84 f7 00 00 00    	je     70aa09 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::inspector_select+0x1b9>
  70a912:	48 c7 44 24 28 1f 00 	movq   $0x1f,0x28(%rsp)
  70a919:	00 00 
  70a91b:	48 8d 7c 24 28       	lea    0x28(%rsp),%rdi
  70a920:	e8 cb d6 fe ff       	call   6f7ff0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  70a925:	49 8b 84 24 10 06 00 	mov    0x610(%r12),%rax
  70a92c:	00 
  70a92d:	48 85 c0             	test   %rax,%rax
  70a930:	0f 84 ba 00 00 00    	je     70a9f0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::inspector_select+0x1a0>
  70a936:	48 8b 80 d8 00 00 00 	mov    0xd8(%rax),%rax
  70a93d:	48 85 c0             	test   %rax,%rax
  70a940:	0f 84 aa 00 00 00    	je     70a9f0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::inspector_select+0x1a0>
  70a946:	4c 89 e6             	mov    %r12,%rsi
  70a949:	49 ff c5             	inc    %r13
  70a94c:	4c 89 30             	mov    %r14,(%rax)
  70a94f:	4c 89 78 08          	mov    %r15,0x8(%rax)
  70a953:	66 c7 40 12 00 ff    	movw   $0xff00,0x12(%rax)
  70a959:	4d 89 ac 24 60 06 00 	mov    %r13,0x660(%r12)
  70a960:	00 
  70a961:	49 ff 84 24 b0 06 00 	incq   0x6b0(%r12)
  70a968:	00 
  70a969:	49 c7 84 24 08 07 00 	movq   $0x0,0x708(%r12)
  70a970:	00 00 00 00 00 
  70a975:	41 c6 84 24 1f 07 00 	movb   $0x1,0x71f(%r12)
  70a97c:	00 01 
  70a97e:	48 89 df             	mov    %rbx,%rdi
  70a981:	48 83 c4 60          	add    $0x60,%rsp
  70a985:	5b                   	pop    %rbx
  70a986:	41 5c                	pop    %r12
  70a988:	41 5d                	pop    %r13
  70a98a:	41 5e                	pop    %r14
  70a98c:	41 5f                	pop    %r15
  70a98e:	e9 fd eb 01 00       	jmp    729590 <<gpui::runtime::Runtime<unit_action_cost_two::Model>>::present>
  70a993:	b9 11 00 00 00       	mov    $0x11,%ecx
  70a998:	eb 03                	jmp    70a99d <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::inspector_select+0x14d>
  70a99a:	48 89 df             	mov    %rbx,%rdi
  70a99d:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  70a9a2:	48 89 54 24 20       	mov    %rdx,0x20(%rsp)
  70a9a7:	0f 10 44 24 38       	movups 0x38(%rsp),%xmm0
  70a9ac:	0f 10 4c 24 48       	movups 0x48(%rsp),%xmm1
  70a9b1:	0f 29 4c 24 10       	movaps %xmm1,0x10(%rsp)
  70a9b6:	0f 29 04 24          	movaps %xmm0,(%rsp)
  70a9ba:	48 89 0f             	mov    %rcx,(%rdi)
  70a9bd:	48 89 47 08          	mov    %rax,0x8(%rdi)
  70a9c1:	0f 28 04 24          	movaps (%rsp),%xmm0
  70a9c5:	0f 28 4c 24 10       	movaps 0x10(%rsp),%xmm1
  70a9ca:	0f 11 47 10          	movups %xmm0,0x10(%rdi)
  70a9ce:	0f 11 4f 20          	movups %xmm1,0x20(%rdi)
  70a9d2:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  70a9d7:	48 89 47 30          	mov    %rax,0x30(%rdi)
  70a9db:	48 83 c4 60          	add    $0x60,%rsp
  70a9df:	5b                   	pop    %rbx
  70a9e0:	41 5c                	pop    %r12
  70a9e2:	41 5d                	pop    %r13
  70a9e4:	41 5e                	pop    %r14
  70a9e6:	41 5f                	pop    %r15
  70a9e8:	c3                   	ret
  70a9e9:	b9 11 00 00 00       	mov    $0x11,%ecx
  70a9ee:	eb ca                	jmp    70a9ba <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::inspector_select+0x16a>
  70a9f0:	48 8d 3d de fb 95 ff 	lea    -0x6a0422(%rip),%rdi        # 6a5d5 <anon.c45b175f03bc4a8e35c2fa0979443901.27.llvm.11789694239044747101+0x32e8>
  70a9f7:	48 8d 15 ba 06 3f 00 	lea    0x3f06ba(%rip),%rdx        # afb0b8 <__frame_dummy_init_array_entry+0x7b0>
  70a9fe:	be 11 00 00 00       	mov    $0x11,%esi
  70aa03:	ff 15 af ea 41 00    	call   *0x41eaaf(%rip)        # b294b8 <_DYNAMIC+0x348>
  70aa09:	48 c7 03 1f 00 00 00 	movq   $0x1f,(%rbx)
  70aa10:	eb c9                	jmp    70a9db <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::inspector_select+0x18b>
