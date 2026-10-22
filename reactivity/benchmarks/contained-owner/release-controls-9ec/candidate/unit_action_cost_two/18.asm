
/tmp/gpui-contained-owner-spike-target/release/deps/unit_action_cost_two-c899ee77dd9a9ab3:     file format elf64-x86-64


Disassembly of section .text:

0000000000709930 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::inspector_select>:
  709930:	41 57                	push   %r15
  709932:	41 56                	push   %r14
  709934:	41 55                	push   %r13
  709936:	41 54                	push   %r12
  709938:	53                   	push   %rbx
  709939:	48 83 ec 60          	sub    $0x60,%rsp
  70993d:	80 be 22 08 00 00 00 	cmpb   $0x0,0x822(%rsi)
  709944:	74 0c                	je     709952 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::inspector_select+0x22>
  709946:	48 c7 07 0e 00 00 00 	movq   $0xe,(%rdi)
  70994d:	e9 69 01 00 00       	jmp    709abb <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::inspector_select+0x18b>
  709952:	48 3b 96 b0 05 00 00 	cmp    0x5b0(%rsi),%rdx
  709959:	0f 85 14 01 00 00    	jne    709a73 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::inspector_select+0x143>
  70995f:	49 89 d6             	mov    %rdx,%r14
  709962:	48 89 fb             	mov    %rdi,%rbx
  709965:	48 8d 7c 24 28       	lea    0x28(%rsp),%rdi
  70996a:	49 89 f4             	mov    %rsi,%r12
  70996d:	49 89 cf             	mov    %rcx,%r15
  709970:	48 89 ca             	mov    %rcx,%rdx
  709973:	e8 98 0a 01 00       	call   71a410 <<gpui::runtime::Runtime<unit_action_cost_two::SecondModel>>::resolve_identity>
  709978:	48 8b 4c 24 28       	mov    0x28(%rsp),%rcx
  70997d:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
  709982:	48 83 f9 fe          	cmp    $0xfffffffffffffffe,%rcx
  709986:	0f 85 ee 00 00 00    	jne    709a7a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::inspector_select+0x14a>
  70998c:	49 8b b4 24 10 06 00 	mov    0x610(%r12),%rsi
  709993:	00 
  709994:	b9 1a 00 00 00       	mov    $0x1a,%ecx
  709999:	48 85 f6             	test   %rsi,%rsi
  70999c:	48 89 df             	mov    %rbx,%rdi
  70999f:	0f 84 29 01 00 00    	je     709ace <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::inspector_select+0x19e>
  7099a5:	48 83 be d8 00 00 00 	cmpq   $0x0,0xd8(%rsi)
  7099ac:	00 
  7099ad:	0f 84 1b 01 00 00    	je     709ace <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::inspector_select+0x19e>
  7099b3:	4c 89 e2             	mov    %r12,%rdx
  7099b6:	49 8b b4 24 a0 02 00 	mov    0x2a0(%r12),%rsi
  7099bd:	00 
  7099be:	48 83 fe 1c          	cmp    $0x1c,%rsi
  7099c2:	0f 82 d2 00 00 00    	jb     709a9a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::inspector_select+0x16a>
  7099c8:	48 83 c6 e4          	add    $0xffffffffffffffe4,%rsi
  7099cc:	48 83 f8 02          	cmp    $0x2,%rax
  7099d0:	0f 93 c1             	setae  %cl
  7099d3:	48 39 f0             	cmp    %rsi,%rax
  7099d6:	0f 92 c0             	setb   %al
  7099d9:	84 c1                	test   %al,%cl
  7099db:	0f 84 e8 00 00 00    	je     709ac9 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::inspector_select+0x199>
  7099e1:	4c 8b aa 60 06 00 00 	mov    0x660(%rdx),%r13
  7099e8:	49 83 fd ff          	cmp    $0xffffffffffffffff,%r13
  7099ec:	0f 84 f7 00 00 00    	je     709ae9 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::inspector_select+0x1b9>
  7099f2:	48 c7 44 24 28 1f 00 	movq   $0x1f,0x28(%rsp)
  7099f9:	00 00 
  7099fb:	48 8d 7c 24 28       	lea    0x28(%rsp),%rdi
  709a00:	e8 db e5 fe ff       	call   6f7fe0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  709a05:	49 8b 84 24 10 06 00 	mov    0x610(%r12),%rax
  709a0c:	00 
  709a0d:	48 85 c0             	test   %rax,%rax
  709a10:	0f 84 ba 00 00 00    	je     709ad0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::inspector_select+0x1a0>
  709a16:	48 8b 80 d8 00 00 00 	mov    0xd8(%rax),%rax
  709a1d:	48 85 c0             	test   %rax,%rax
  709a20:	0f 84 aa 00 00 00    	je     709ad0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::inspector_select+0x1a0>
  709a26:	4c 89 e6             	mov    %r12,%rsi
  709a29:	49 ff c5             	inc    %r13
  709a2c:	4c 89 30             	mov    %r14,(%rax)
  709a2f:	4c 89 78 08          	mov    %r15,0x8(%rax)
  709a33:	66 c7 40 12 00 ff    	movw   $0xff00,0x12(%rax)
  709a39:	4d 89 ac 24 60 06 00 	mov    %r13,0x660(%r12)
  709a40:	00 
  709a41:	49 ff 84 24 b0 06 00 	incq   0x6b0(%r12)
  709a48:	00 
  709a49:	49 c7 84 24 08 07 00 	movq   $0x0,0x708(%r12)
  709a50:	00 00 00 00 00 
  709a55:	41 c6 84 24 1f 08 00 	movb   $0x1,0x81f(%r12)
  709a5c:	00 01 
  709a5e:	48 89 df             	mov    %rbx,%rdi
  709a61:	48 83 c4 60          	add    $0x60,%rsp
  709a65:	5b                   	pop    %rbx
  709a66:	41 5c                	pop    %r12
  709a68:	41 5d                	pop    %r13
  709a6a:	41 5e                	pop    %r14
  709a6c:	41 5f                	pop    %r15
  709a6e:	e9 0d 12 01 00       	jmp    71ac80 <<gpui::runtime::Runtime<unit_action_cost_two::SecondModel>>::present>
  709a73:	b9 11 00 00 00       	mov    $0x11,%ecx
  709a78:	eb 03                	jmp    709a7d <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::inspector_select+0x14d>
  709a7a:	48 89 df             	mov    %rbx,%rdi
  709a7d:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  709a82:	48 89 54 24 20       	mov    %rdx,0x20(%rsp)
  709a87:	0f 10 44 24 38       	movups 0x38(%rsp),%xmm0
  709a8c:	0f 10 4c 24 48       	movups 0x48(%rsp),%xmm1
  709a91:	0f 29 4c 24 10       	movaps %xmm1,0x10(%rsp)
  709a96:	0f 29 04 24          	movaps %xmm0,(%rsp)
  709a9a:	48 89 0f             	mov    %rcx,(%rdi)
  709a9d:	48 89 47 08          	mov    %rax,0x8(%rdi)
  709aa1:	0f 28 04 24          	movaps (%rsp),%xmm0
  709aa5:	0f 28 4c 24 10       	movaps 0x10(%rsp),%xmm1
  709aaa:	0f 11 47 10          	movups %xmm0,0x10(%rdi)
  709aae:	0f 11 4f 20          	movups %xmm1,0x20(%rdi)
  709ab2:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  709ab7:	48 89 47 30          	mov    %rax,0x30(%rdi)
  709abb:	48 83 c4 60          	add    $0x60,%rsp
  709abf:	5b                   	pop    %rbx
  709ac0:	41 5c                	pop    %r12
  709ac2:	41 5d                	pop    %r13
  709ac4:	41 5e                	pop    %r14
  709ac6:	41 5f                	pop    %r15
  709ac8:	c3                   	ret
  709ac9:	b9 11 00 00 00       	mov    $0x11,%ecx
  709ace:	eb ca                	jmp    709a9a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::inspector_select+0x16a>
  709ad0:	48 8d 3d ee 0a 96 ff 	lea    -0x69f512(%rip),%rdi        # 6a5c5 <anon.c45b175f03bc4a8e35c2fa0979443901.27.llvm.11789694239044747101+0x32e8>
  709ad7:	48 8d 15 6a 15 3f 00 	lea    0x3f156a(%rip),%rdx        # afb048 <__frame_dummy_init_array_entry+0x7b0>
  709ade:	be 11 00 00 00       	mov    $0x11,%esi
  709ae3:	ff 15 5f f9 41 00    	call   *0x41f95f(%rip)        # b29448 <_DYNAMIC+0x348>
  709ae9:	48 c7 03 1f 00 00 00 	movq   $0x1f,(%rbx)
  709af0:	eb c9                	jmp    709abb <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::inspector_select+0x18b>
