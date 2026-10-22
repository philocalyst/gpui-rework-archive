
/tmp/gpui-contained-property-exchange-target/release/deps/unit_action_cost_two-c899ee77dd9a9ab3:     file format elf64-x86-64


Disassembly of section .text:

00000000007098a0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::inspector_select>:
  7098a0:	41 57                	push   %r15
  7098a2:	41 56                	push   %r14
  7098a4:	41 55                	push   %r13
  7098a6:	41 54                	push   %r12
  7098a8:	53                   	push   %rbx
  7098a9:	48 83 ec 60          	sub    $0x60,%rsp
  7098ad:	80 be 22 08 00 00 00 	cmpb   $0x0,0x822(%rsi)
  7098b4:	74 0c                	je     7098c2 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::inspector_select+0x22>
  7098b6:	48 c7 07 0e 00 00 00 	movq   $0xe,(%rdi)
  7098bd:	e9 69 01 00 00       	jmp    709a2b <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::inspector_select+0x18b>
  7098c2:	48 3b 96 b0 05 00 00 	cmp    0x5b0(%rsi),%rdx
  7098c9:	0f 85 14 01 00 00    	jne    7099e3 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::inspector_select+0x143>
  7098cf:	49 89 d6             	mov    %rdx,%r14
  7098d2:	48 89 fb             	mov    %rdi,%rbx
  7098d5:	48 8d 7c 24 28       	lea    0x28(%rsp),%rdi
  7098da:	49 89 f4             	mov    %rsi,%r12
  7098dd:	49 89 cf             	mov    %rcx,%r15
  7098e0:	48 89 ca             	mov    %rcx,%rdx
  7098e3:	e8 98 0a 01 00       	call   71a380 <<gpui::runtime::Runtime<unit_action_cost_two::SecondModel>>::resolve_identity>
  7098e8:	48 8b 4c 24 28       	mov    0x28(%rsp),%rcx
  7098ed:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
  7098f2:	48 83 f9 fe          	cmp    $0xfffffffffffffffe,%rcx
  7098f6:	0f 85 ee 00 00 00    	jne    7099ea <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::inspector_select+0x14a>
  7098fc:	49 8b b4 24 10 06 00 	mov    0x610(%r12),%rsi
  709903:	00 
  709904:	b9 1a 00 00 00       	mov    $0x1a,%ecx
  709909:	48 85 f6             	test   %rsi,%rsi
  70990c:	48 89 df             	mov    %rbx,%rdi
  70990f:	0f 84 29 01 00 00    	je     709a3e <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::inspector_select+0x19e>
  709915:	48 83 be d8 00 00 00 	cmpq   $0x0,0xd8(%rsi)
  70991c:	00 
  70991d:	0f 84 1b 01 00 00    	je     709a3e <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::inspector_select+0x19e>
  709923:	4c 89 e2             	mov    %r12,%rdx
  709926:	49 8b b4 24 a0 02 00 	mov    0x2a0(%r12),%rsi
  70992d:	00 
  70992e:	48 83 fe 1c          	cmp    $0x1c,%rsi
  709932:	0f 82 d2 00 00 00    	jb     709a0a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::inspector_select+0x16a>
  709938:	48 83 c6 e4          	add    $0xffffffffffffffe4,%rsi
  70993c:	48 83 f8 02          	cmp    $0x2,%rax
  709940:	0f 93 c1             	setae  %cl
  709943:	48 39 f0             	cmp    %rsi,%rax
  709946:	0f 92 c0             	setb   %al
  709949:	84 c1                	test   %al,%cl
  70994b:	0f 84 e8 00 00 00    	je     709a39 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::inspector_select+0x199>
  709951:	4c 8b aa 60 06 00 00 	mov    0x660(%rdx),%r13
  709958:	49 83 fd ff          	cmp    $0xffffffffffffffff,%r13
  70995c:	0f 84 f7 00 00 00    	je     709a59 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::inspector_select+0x1b9>
  709962:	48 c7 44 24 28 1f 00 	movq   $0x1f,0x28(%rsp)
  709969:	00 00 
  70996b:	48 8d 7c 24 28       	lea    0x28(%rsp),%rdi
  709970:	e8 7b e5 fe ff       	call   6f7ef0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  709975:	49 8b 84 24 10 06 00 	mov    0x610(%r12),%rax
  70997c:	00 
  70997d:	48 85 c0             	test   %rax,%rax
  709980:	0f 84 ba 00 00 00    	je     709a40 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::inspector_select+0x1a0>
  709986:	48 8b 80 d8 00 00 00 	mov    0xd8(%rax),%rax
  70998d:	48 85 c0             	test   %rax,%rax
  709990:	0f 84 aa 00 00 00    	je     709a40 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::inspector_select+0x1a0>
  709996:	4c 89 e6             	mov    %r12,%rsi
  709999:	49 ff c5             	inc    %r13
  70999c:	4c 89 30             	mov    %r14,(%rax)
  70999f:	4c 89 78 08          	mov    %r15,0x8(%rax)
  7099a3:	66 c7 40 12 00 ff    	movw   $0xff00,0x12(%rax)
  7099a9:	4d 89 ac 24 60 06 00 	mov    %r13,0x660(%r12)
  7099b0:	00 
  7099b1:	49 ff 84 24 b0 06 00 	incq   0x6b0(%r12)
  7099b8:	00 
  7099b9:	49 c7 84 24 08 07 00 	movq   $0x0,0x708(%r12)
  7099c0:	00 00 00 00 00 
  7099c5:	41 c6 84 24 1f 08 00 	movb   $0x1,0x81f(%r12)
  7099cc:	00 01 
  7099ce:	48 89 df             	mov    %rbx,%rdi
  7099d1:	48 83 c4 60          	add    $0x60,%rsp
  7099d5:	5b                   	pop    %rbx
  7099d6:	41 5c                	pop    %r12
  7099d8:	41 5d                	pop    %r13
  7099da:	41 5e                	pop    %r14
  7099dc:	41 5f                	pop    %r15
  7099de:	e9 0d 12 01 00       	jmp    71abf0 <<gpui::runtime::Runtime<unit_action_cost_two::SecondModel>>::present>
  7099e3:	b9 11 00 00 00       	mov    $0x11,%ecx
  7099e8:	eb 03                	jmp    7099ed <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::inspector_select+0x14d>
  7099ea:	48 89 df             	mov    %rbx,%rdi
  7099ed:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  7099f2:	48 89 54 24 20       	mov    %rdx,0x20(%rsp)
  7099f7:	0f 10 44 24 38       	movups 0x38(%rsp),%xmm0
  7099fc:	0f 10 4c 24 48       	movups 0x48(%rsp),%xmm1
  709a01:	0f 29 4c 24 10       	movaps %xmm1,0x10(%rsp)
  709a06:	0f 29 04 24          	movaps %xmm0,(%rsp)
  709a0a:	48 89 0f             	mov    %rcx,(%rdi)
  709a0d:	48 89 47 08          	mov    %rax,0x8(%rdi)
  709a11:	0f 28 04 24          	movaps (%rsp),%xmm0
  709a15:	0f 28 4c 24 10       	movaps 0x10(%rsp),%xmm1
  709a1a:	0f 11 47 10          	movups %xmm0,0x10(%rdi)
  709a1e:	0f 11 4f 20          	movups %xmm1,0x20(%rdi)
  709a22:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  709a27:	48 89 47 30          	mov    %rax,0x30(%rdi)
  709a2b:	48 83 c4 60          	add    $0x60,%rsp
  709a2f:	5b                   	pop    %rbx
  709a30:	41 5c                	pop    %r12
  709a32:	41 5d                	pop    %r13
  709a34:	41 5e                	pop    %r14
  709a36:	41 5f                	pop    %r15
  709a38:	c3                   	ret
  709a39:	b9 11 00 00 00       	mov    $0x11,%ecx
  709a3e:	eb ca                	jmp    709a0a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::inspector_select+0x16a>
  709a40:	48 8d 3d 1e 0b 96 ff 	lea    -0x69f4e2(%rip),%rdi        # 6a565 <anon.c45b175f03bc4a8e35c2fa0979443901.27.llvm.11789694239044747101+0x32e8>
  709a47:	48 8d 15 ca 15 3f 00 	lea    0x3f15ca(%rip),%rdx        # afb018 <__frame_dummy_init_array_entry+0x7b0>
  709a4e:	be 11 00 00 00       	mov    $0x11,%esi
  709a53:	ff 15 77 f9 41 00    	call   *0x41f977(%rip)        # b293d0 <_DYNAMIC+0x348>
  709a59:	48 c7 03 1f 00 00 00 	movq   $0x1f,(%rbx)
  709a60:	eb c9                	jmp    709a2b <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::inspector_select+0x18b>
