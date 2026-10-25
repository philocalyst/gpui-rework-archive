
/tmp/gpui-contained-owner-spike-target/release/deps/unit_action_cost_two-c899ee77dd9a9ab3:     file format elf64-x86-64


Disassembly of section .text:

00000000007099a0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::inspector_select>:
  7099a0:	41 57                	push   %r15
  7099a2:	41 56                	push   %r14
  7099a4:	41 55                	push   %r13
  7099a6:	41 54                	push   %r12
  7099a8:	53                   	push   %rbx
  7099a9:	48 83 ec 60          	sub    $0x60,%rsp
  7099ad:	80 be 22 08 00 00 00 	cmpb   $0x0,0x822(%rsi)
  7099b4:	74 0c                	je     7099c2 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::inspector_select+0x22>
  7099b6:	48 c7 07 0e 00 00 00 	movq   $0xe,(%rdi)
  7099bd:	e9 69 01 00 00       	jmp    709b2b <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::inspector_select+0x18b>
  7099c2:	48 3b 96 b0 05 00 00 	cmp    0x5b0(%rsi),%rdx
  7099c9:	0f 85 14 01 00 00    	jne    709ae3 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::inspector_select+0x143>
  7099cf:	49 89 d6             	mov    %rdx,%r14
  7099d2:	48 89 fb             	mov    %rdi,%rbx
  7099d5:	48 8d 7c 24 28       	lea    0x28(%rsp),%rdi
  7099da:	49 89 f4             	mov    %rsi,%r12
  7099dd:	49 89 cf             	mov    %rcx,%r15
  7099e0:	48 89 ca             	mov    %rcx,%rdx
  7099e3:	e8 98 0a 01 00       	call   71a480 <<gpui::runtime::Runtime<unit_action_cost_two::SecondModel>>::resolve_identity>
  7099e8:	48 8b 4c 24 28       	mov    0x28(%rsp),%rcx
  7099ed:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
  7099f2:	48 83 f9 fe          	cmp    $0xfffffffffffffffe,%rcx
  7099f6:	0f 85 ee 00 00 00    	jne    709aea <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::inspector_select+0x14a>
  7099fc:	49 8b b4 24 10 06 00 	mov    0x610(%r12),%rsi
  709a03:	00 
  709a04:	b9 1a 00 00 00       	mov    $0x1a,%ecx
  709a09:	48 85 f6             	test   %rsi,%rsi
  709a0c:	48 89 df             	mov    %rbx,%rdi
  709a0f:	0f 84 29 01 00 00    	je     709b3e <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::inspector_select+0x19e>
  709a15:	48 83 be d8 00 00 00 	cmpq   $0x0,0xd8(%rsi)
  709a1c:	00 
  709a1d:	0f 84 1b 01 00 00    	je     709b3e <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::inspector_select+0x19e>
  709a23:	4c 89 e2             	mov    %r12,%rdx
  709a26:	49 8b b4 24 a0 02 00 	mov    0x2a0(%r12),%rsi
  709a2d:	00 
  709a2e:	48 83 fe 1c          	cmp    $0x1c,%rsi
  709a32:	0f 82 d2 00 00 00    	jb     709b0a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::inspector_select+0x16a>
  709a38:	48 83 c6 e4          	add    $0xffffffffffffffe4,%rsi
  709a3c:	48 83 f8 02          	cmp    $0x2,%rax
  709a40:	0f 93 c1             	setae  %cl
  709a43:	48 39 f0             	cmp    %rsi,%rax
  709a46:	0f 92 c0             	setb   %al
  709a49:	84 c1                	test   %al,%cl
  709a4b:	0f 84 e8 00 00 00    	je     709b39 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::inspector_select+0x199>
  709a51:	4c 8b aa 60 06 00 00 	mov    0x660(%rdx),%r13
  709a58:	49 83 fd ff          	cmp    $0xffffffffffffffff,%r13
  709a5c:	0f 84 f7 00 00 00    	je     709b59 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::inspector_select+0x1b9>
  709a62:	48 c7 44 24 28 1f 00 	movq   $0x1f,0x28(%rsp)
  709a69:	00 00 
  709a6b:	48 8d 7c 24 28       	lea    0x28(%rsp),%rdi
  709a70:	e8 7b e5 fe ff       	call   6f7ff0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  709a75:	49 8b 84 24 10 06 00 	mov    0x610(%r12),%rax
  709a7c:	00 
  709a7d:	48 85 c0             	test   %rax,%rax
  709a80:	0f 84 ba 00 00 00    	je     709b40 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::inspector_select+0x1a0>
  709a86:	48 8b 80 d8 00 00 00 	mov    0xd8(%rax),%rax
  709a8d:	48 85 c0             	test   %rax,%rax
  709a90:	0f 84 aa 00 00 00    	je     709b40 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::inspector_select+0x1a0>
  709a96:	4c 89 e6             	mov    %r12,%rsi
  709a99:	49 ff c5             	inc    %r13
  709a9c:	4c 89 30             	mov    %r14,(%rax)
  709a9f:	4c 89 78 08          	mov    %r15,0x8(%rax)
  709aa3:	66 c7 40 12 00 ff    	movw   $0xff00,0x12(%rax)
  709aa9:	4d 89 ac 24 60 06 00 	mov    %r13,0x660(%r12)
  709ab0:	00 
  709ab1:	49 ff 84 24 b0 06 00 	incq   0x6b0(%r12)
  709ab8:	00 
  709ab9:	49 c7 84 24 08 07 00 	movq   $0x0,0x708(%r12)
  709ac0:	00 00 00 00 00 
  709ac5:	41 c6 84 24 1f 08 00 	movb   $0x1,0x81f(%r12)
  709acc:	00 01 
  709ace:	48 89 df             	mov    %rbx,%rdi
  709ad1:	48 83 c4 60          	add    $0x60,%rsp
  709ad5:	5b                   	pop    %rbx
  709ad6:	41 5c                	pop    %r12
  709ad8:	41 5d                	pop    %r13
  709ada:	41 5e                	pop    %r14
  709adc:	41 5f                	pop    %r15
  709ade:	e9 0d 12 01 00       	jmp    71acf0 <<gpui::runtime::Runtime<unit_action_cost_two::SecondModel>>::present>
  709ae3:	b9 11 00 00 00       	mov    $0x11,%ecx
  709ae8:	eb 03                	jmp    709aed <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::inspector_select+0x14d>
  709aea:	48 89 df             	mov    %rbx,%rdi
  709aed:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  709af2:	48 89 54 24 20       	mov    %rdx,0x20(%rsp)
  709af7:	0f 10 44 24 38       	movups 0x38(%rsp),%xmm0
  709afc:	0f 10 4c 24 48       	movups 0x48(%rsp),%xmm1
  709b01:	0f 29 4c 24 10       	movaps %xmm1,0x10(%rsp)
  709b06:	0f 29 04 24          	movaps %xmm0,(%rsp)
  709b0a:	48 89 0f             	mov    %rcx,(%rdi)
  709b0d:	48 89 47 08          	mov    %rax,0x8(%rdi)
  709b11:	0f 28 04 24          	movaps (%rsp),%xmm0
  709b15:	0f 28 4c 24 10       	movaps 0x10(%rsp),%xmm1
  709b1a:	0f 11 47 10          	movups %xmm0,0x10(%rdi)
  709b1e:	0f 11 4f 20          	movups %xmm1,0x20(%rdi)
  709b22:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  709b27:	48 89 47 30          	mov    %rax,0x30(%rdi)
  709b2b:	48 83 c4 60          	add    $0x60,%rsp
  709b2f:	5b                   	pop    %rbx
  709b30:	41 5c                	pop    %r12
  709b32:	41 5d                	pop    %r13
  709b34:	41 5e                	pop    %r14
  709b36:	41 5f                	pop    %r15
  709b38:	c3                   	ret
  709b39:	b9 11 00 00 00       	mov    $0x11,%ecx
  709b3e:	eb ca                	jmp    709b0a <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::inspector_select+0x16a>
  709b40:	48 8d 3d 8e 0a 96 ff 	lea    -0x69f572(%rip),%rdi        # 6a5d5 <anon.c45b175f03bc4a8e35c2fa0979443901.27.llvm.11789694239044747101+0x32e8>
  709b47:	48 8d 15 6a 15 3f 00 	lea    0x3f156a(%rip),%rdx        # afb0b8 <__frame_dummy_init_array_entry+0x7b0>
  709b4e:	be 11 00 00 00       	mov    $0x11,%esi
  709b53:	ff 15 5f f9 41 00    	call   *0x41f95f(%rip)        # b294b8 <_DYNAMIC+0x348>
  709b59:	48 c7 03 1f 00 00 00 	movq   $0x1f,(%rbx)
  709b60:	eb c9                	jmp    709b2b <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::inspector_select+0x18b>
