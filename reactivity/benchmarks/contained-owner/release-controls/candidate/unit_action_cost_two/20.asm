
/tmp/gpui-contained-owner-spike-target/release/deps/unit_action_cost_two-c899ee77dd9a9ab3:     file format elf64-x86-64


Disassembly of section .text:

0000000000704be0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_input>:
  704be0:	41 57                	push   %r15
  704be2:	41 56                	push   %r14
  704be4:	41 55                	push   %r13
  704be6:	41 54                	push   %r12
  704be8:	53                   	push   %rbx
  704be9:	48 83 ec 40          	sub    $0x40,%rsp
  704bed:	48 89 fb             	mov    %rdi,%rbx
  704bf0:	80 be 22 08 00 00 00 	cmpb   $0x0,0x822(%rsi)
  704bf7:	74 0c                	je     704c05 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_input+0x25>
  704bf9:	48 c7 03 0e 00 00 00 	movq   $0xe,(%rbx)
  704c00:	e9 8c 01 00 00       	jmp    704d91 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_input+0x1b1>
  704c05:	4d 89 c7             	mov    %r8,%r15
  704c08:	49 89 f6             	mov    %rsi,%r14
  704c0b:	48 8d 7c 24 08       	lea    0x8(%rsp),%rdi
  704c10:	e8 1b c9 ff ff       	call   701530 <<gpui::runtime::Runtime<unit_action_cost_two::SecondModel>>::input_index>
  704c15:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  704c1a:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  704c1f:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  704c23:	0f 85 e2 00 00 00    	jne    704d0b <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_input+0x12b>
  704c29:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  704c30:	49 39 f4             	cmp    %rsi,%r12
  704c33:	0f 83 89 01 00 00    	jae    704dc2 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_input+0x1e2>
  704c39:	4b 8d 04 a4          	lea    (%r12,%r12,4),%rax
  704c3d:	49 8b 8e 98 02 00 00 	mov    0x298(%r14),%rcx
  704c44:	8b 7c c1 20          	mov    0x20(%rcx,%rax,8),%edi
  704c48:	89 f8                	mov    %edi,%eax
  704c4a:	83 e0 07             	and    $0x7,%eax
  704c4d:	83 f8 06             	cmp    $0x6,%eax
  704c50:	0f 84 49 01 00 00    	je     704d9f <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_input+0x1bf>
  704c56:	c1 ef 03             	shr    $0x3,%edi
  704c59:	0f 84 40 01 00 00    	je     704d9f <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_input+0x1bf>
  704c5f:	49 8b b6 b8 02 00 00 	mov    0x2b8(%r14),%rsi
  704c66:	ff cf                	dec    %edi
  704c68:	48 39 fe             	cmp    %rdi,%rsi
  704c6b:	0f 86 61 01 00 00    	jbe    704dd2 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_input+0x1f2>
  704c71:	49 8b 86 b0 02 00 00 	mov    0x2b0(%r14),%rax
  704c78:	48 8d 0c bf          	lea    (%rdi,%rdi,4),%rcx
  704c7c:	48 c1 e1 04          	shl    $0x4,%rcx
  704c80:	48 83 3c 08 fe       	cmpq   $0xfffffffffffffffe,(%rax,%rcx,1)
  704c85:	0f 84 21 01 00 00    	je     704dac <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_input+0x1cc>
  704c8b:	48 01 c8             	add    %rcx,%rax
  704c8e:	48 8b 78 40          	mov    0x40(%rax),%rdi
  704c92:	48 8b 37             	mov    (%rdi),%rsi
  704c95:	48 d1 ee             	shr    $1,%rsi
  704c98:	48 83 c7 10          	add    $0x10,%rdi
  704c9c:	4c 89 fa             	mov    %r15,%rdx
  704c9f:	ff 15 6b 49 42 00    	call   *0x42496b(%rip)        # b29610 <_DYNAMIC+0x4a0>
  704ca5:	84 c0                	test   %al,%al
  704ca7:	0f 84 82 00 00 00    	je     704d2f <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_input+0x14f>
  704cad:	4d 8b ae 60 06 00 00 	mov    0x660(%r14),%r13
  704cb4:	49 ff c5             	inc    %r13
  704cb7:	0f 84 fc 00 00 00    	je     704db9 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_input+0x1d9>
  704cbd:	49 c7 86 08 07 00 00 	movq   $0x0,0x708(%r14)
  704cc4:	00 00 00 00 
  704cc8:	4c 89 f7             	mov    %r14,%rdi
  704ccb:	4c 89 e6             	mov    %r12,%rsi
  704cce:	4c 89 fa             	mov    %r15,%rdx
  704cd1:	e8 7a c9 ff ff       	call   701650 <<gpui::runtime::Runtime<unit_action_cost_two::SecondModel>>::set_selection>
  704cd6:	84 c0                	test   %al,%al
  704cd8:	74 5e                	je     704d38 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_input+0x158>
  704cda:	4d 89 ae 60 06 00 00 	mov    %r13,0x660(%r14)
  704ce1:	49 ff 86 b0 06 00 00 	incq   0x6b0(%r14)
  704ce8:	49 c7 86 08 07 00 00 	movq   $0x1,0x708(%r14)
  704cef:	01 00 00 00 
  704cf3:	48 89 df             	mov    %rbx,%rdi
  704cf6:	4c 89 f6             	mov    %r14,%rsi
  704cf9:	48 83 c4 40          	add    $0x40,%rsp
  704cfd:	5b                   	pop    %rbx
  704cfe:	41 5c                	pop    %r12
  704d00:	41 5d                	pop    %r13
  704d02:	41 5e                	pop    %r14
  704d04:	41 5f                	pop    %r15
  704d06:	e9 e5 5f 01 00       	jmp    71acf0 <<gpui::runtime::Runtime<unit_action_cost_two::SecondModel>>::present>
  704d0b:	48 8b 4c 24 38       	mov    0x38(%rsp),%rcx
  704d10:	48 89 4b 30          	mov    %rcx,0x30(%rbx)
  704d14:	0f 10 44 24 18       	movups 0x18(%rsp),%xmm0
  704d19:	0f 10 4c 24 28       	movups 0x28(%rsp),%xmm1
  704d1e:	0f 11 4b 20          	movups %xmm1,0x20(%rbx)
  704d22:	0f 11 43 10          	movups %xmm0,0x10(%rbx)
  704d26:	48 89 03             	mov    %rax,(%rbx)
  704d29:	4c 89 63 08          	mov    %r12,0x8(%rbx)
  704d2d:	eb 62                	jmp    704d91 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_input+0x1b1>
  704d2f:	48 c7 03 18 00 00 00 	movq   $0x18,(%rbx)
  704d36:	eb 59                	jmp    704d91 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_input+0x1b1>
  704d38:	41 0f 10 86 60 06 00 	movups 0x660(%r14),%xmm0
  704d3f:	00 
  704d40:	41 0f b6 86 20 08 00 	movzbl 0x820(%r14),%eax
  704d47:	00 
  704d48:	49 83 be 80 06 00 00 	cmpq   $0x0,0x680(%r14)
  704d4f:	00 
  704d50:	74 1c                	je     704d6e <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_input+0x18e>
  704d52:	84 c0                	test   %al,%al
  704d54:	74 0a                	je     704d60 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_input+0x180>
  704d56:	49 83 be 88 05 00 00 	cmpq   $0xffffffffffffffff,0x588(%r14)
  704d5d:	ff 
  704d5e:	74 0e                	je     704d6e <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_input+0x18e>
  704d60:	49 8b 96 90 06 00 00 	mov    0x690(%r14),%rdx
  704d67:	b9 01 00 00 00       	mov    $0x1,%ecx
  704d6c:	eb 02                	jmp    704d70 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_input+0x190>
  704d6e:	31 c9                	xor    %ecx,%ecx
  704d70:	49 8b b6 08 07 00 00 	mov    0x708(%r14),%rsi
  704d77:	48 89 4b 08          	mov    %rcx,0x8(%rbx)
  704d7b:	48 89 53 10          	mov    %rdx,0x10(%rbx)
  704d7f:	0f 11 43 18          	movups %xmm0,0x18(%rbx)
  704d83:	48 89 73 28          	mov    %rsi,0x28(%rbx)
  704d87:	88 43 30             	mov    %al,0x30(%rbx)
  704d8a:	48 c7 03 fe ff ff ff 	movq   $0xfffffffffffffffe,(%rbx)
  704d91:	48 83 c4 40          	add    $0x40,%rsp
  704d95:	5b                   	pop    %rbx
  704d96:	41 5c                	pop    %r12
  704d98:	41 5d                	pop    %r13
  704d9a:	41 5e                	pop    %r14
  704d9c:	41 5f                	pop    %r15
  704d9e:	c3                   	ret
  704d9f:	48 8d 3d 9a 62 3f 00 	lea    0x3f629a(%rip),%rdi        # afb040 <__frame_dummy_init_array_entry+0x738>
  704da6:	ff 15 cc 46 42 00    	call   *0x4246cc(%rip)        # b29478 <_DYNAMIC+0x308>
  704dac:	48 8d 3d a5 5c 3f 00 	lea    0x3f5ca5(%rip),%rdi        # afaa58 <__frame_dummy_init_array_entry+0x150>
  704db3:	ff 15 bf 46 42 00    	call   *0x4246bf(%rip)        # b29478 <_DYNAMIC+0x308>
  704db9:	48 c7 03 1f 00 00 00 	movq   $0x1f,(%rbx)
  704dc0:	eb cf                	jmp    704d91 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_input+0x1b1>
  704dc2:	48 8d 15 5f 62 3f 00 	lea    0x3f625f(%rip),%rdx        # afb028 <__frame_dummy_init_array_entry+0x720>
  704dc9:	4c 89 e7             	mov    %r12,%rdi
  704dcc:	ff 15 f6 46 42 00    	call   *0x4246f6(%rip)        # b294c8 <_DYNAMIC+0x358>
  704dd2:	48 8d 15 67 5c 3f 00 	lea    0x3f5c67(%rip),%rdx        # afaa40 <__frame_dummy_init_array_entry+0x138>
  704dd9:	ff 15 e9 46 42 00    	call   *0x4246e9(%rip)        # b294c8 <_DYNAMIC+0x358>
