
/tmp/gpui-contained-property-exchange-target/release/deps/unit_action_cost_two-c899ee77dd9a9ab3:     file format elf64-x86-64


Disassembly of section .text:

0000000000704ae0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_input>:
  704ae0:	41 57                	push   %r15
  704ae2:	41 56                	push   %r14
  704ae4:	41 55                	push   %r13
  704ae6:	41 54                	push   %r12
  704ae8:	53                   	push   %rbx
  704ae9:	48 83 ec 40          	sub    $0x40,%rsp
  704aed:	48 89 fb             	mov    %rdi,%rbx
  704af0:	80 be 22 08 00 00 00 	cmpb   $0x0,0x822(%rsi)
  704af7:	74 0c                	je     704b05 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_input+0x25>
  704af9:	48 c7 03 0e 00 00 00 	movq   $0xe,(%rbx)
  704b00:	e9 8c 01 00 00       	jmp    704c91 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_input+0x1b1>
  704b05:	4d 89 c7             	mov    %r8,%r15
  704b08:	49 89 f6             	mov    %rsi,%r14
  704b0b:	48 8d 7c 24 08       	lea    0x8(%rsp),%rdi
  704b10:	e8 1b c9 ff ff       	call   701430 <<gpui::runtime::Runtime<unit_action_cost_two::SecondModel>>::input_index>
  704b15:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  704b1a:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
  704b1f:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  704b23:	0f 85 e2 00 00 00    	jne    704c0b <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_input+0x12b>
  704b29:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  704b30:	49 39 f4             	cmp    %rsi,%r12
  704b33:	0f 83 89 01 00 00    	jae    704cc2 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_input+0x1e2>
  704b39:	4b 8d 04 a4          	lea    (%r12,%r12,4),%rax
  704b3d:	49 8b 8e 98 02 00 00 	mov    0x298(%r14),%rcx
  704b44:	8b 7c c1 20          	mov    0x20(%rcx,%rax,8),%edi
  704b48:	89 f8                	mov    %edi,%eax
  704b4a:	83 e0 07             	and    $0x7,%eax
  704b4d:	83 f8 06             	cmp    $0x6,%eax
  704b50:	0f 84 49 01 00 00    	je     704c9f <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_input+0x1bf>
  704b56:	c1 ef 03             	shr    $0x3,%edi
  704b59:	0f 84 40 01 00 00    	je     704c9f <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_input+0x1bf>
  704b5f:	49 8b b6 b8 02 00 00 	mov    0x2b8(%r14),%rsi
  704b66:	ff cf                	dec    %edi
  704b68:	48 39 fe             	cmp    %rdi,%rsi
  704b6b:	0f 86 61 01 00 00    	jbe    704cd2 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_input+0x1f2>
  704b71:	49 8b 86 b0 02 00 00 	mov    0x2b0(%r14),%rax
  704b78:	48 8d 0c bf          	lea    (%rdi,%rdi,4),%rcx
  704b7c:	48 c1 e1 04          	shl    $0x4,%rcx
  704b80:	48 83 3c 08 fe       	cmpq   $0xfffffffffffffffe,(%rax,%rcx,1)
  704b85:	0f 84 21 01 00 00    	je     704cac <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_input+0x1cc>
  704b8b:	48 01 c8             	add    %rcx,%rax
  704b8e:	48 8b 78 40          	mov    0x40(%rax),%rdi
  704b92:	48 8b 37             	mov    (%rdi),%rsi
  704b95:	48 d1 ee             	shr    $1,%rsi
  704b98:	48 83 c7 10          	add    $0x10,%rdi
  704b9c:	4c 89 fa             	mov    %r15,%rdx
  704b9f:	ff 15 83 49 42 00    	call   *0x424983(%rip)        # b29528 <_DYNAMIC+0x4a0>
  704ba5:	84 c0                	test   %al,%al
  704ba7:	0f 84 82 00 00 00    	je     704c2f <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_input+0x14f>
  704bad:	4d 8b ae 60 06 00 00 	mov    0x660(%r14),%r13
  704bb4:	49 ff c5             	inc    %r13
  704bb7:	0f 84 fc 00 00 00    	je     704cb9 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_input+0x1d9>
  704bbd:	49 c7 86 08 07 00 00 	movq   $0x0,0x708(%r14)
  704bc4:	00 00 00 00 
  704bc8:	4c 89 f7             	mov    %r14,%rdi
  704bcb:	4c 89 e6             	mov    %r12,%rsi
  704bce:	4c 89 fa             	mov    %r15,%rdx
  704bd1:	e8 7a c9 ff ff       	call   701550 <<gpui::runtime::Runtime<unit_action_cost_two::SecondModel>>::set_selection>
  704bd6:	84 c0                	test   %al,%al
  704bd8:	74 5e                	je     704c38 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_input+0x158>
  704bda:	4d 89 ae 60 06 00 00 	mov    %r13,0x660(%r14)
  704be1:	49 ff 86 b0 06 00 00 	incq   0x6b0(%r14)
  704be8:	49 c7 86 08 07 00 00 	movq   $0x1,0x708(%r14)
  704bef:	01 00 00 00 
  704bf3:	48 89 df             	mov    %rbx,%rdi
  704bf6:	4c 89 f6             	mov    %r14,%rsi
  704bf9:	48 83 c4 40          	add    $0x40,%rsp
  704bfd:	5b                   	pop    %rbx
  704bfe:	41 5c                	pop    %r12
  704c00:	41 5d                	pop    %r13
  704c02:	41 5e                	pop    %r14
  704c04:	41 5f                	pop    %r15
  704c06:	e9 e5 5f 01 00       	jmp    71abf0 <<gpui::runtime::Runtime<unit_action_cost_two::SecondModel>>::present>
  704c0b:	48 8b 4c 24 38       	mov    0x38(%rsp),%rcx
  704c10:	48 89 4b 30          	mov    %rcx,0x30(%rbx)
  704c14:	0f 10 44 24 18       	movups 0x18(%rsp),%xmm0
  704c19:	0f 10 4c 24 28       	movups 0x28(%rsp),%xmm1
  704c1e:	0f 11 4b 20          	movups %xmm1,0x20(%rbx)
  704c22:	0f 11 43 10          	movups %xmm0,0x10(%rbx)
  704c26:	48 89 03             	mov    %rax,(%rbx)
  704c29:	4c 89 63 08          	mov    %r12,0x8(%rbx)
  704c2d:	eb 62                	jmp    704c91 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_input+0x1b1>
  704c2f:	48 c7 03 18 00 00 00 	movq   $0x18,(%rbx)
  704c36:	eb 59                	jmp    704c91 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_input+0x1b1>
  704c38:	41 0f 10 86 60 06 00 	movups 0x660(%r14),%xmm0
  704c3f:	00 
  704c40:	41 0f b6 86 20 08 00 	movzbl 0x820(%r14),%eax
  704c47:	00 
  704c48:	49 83 be 80 06 00 00 	cmpq   $0x0,0x680(%r14)
  704c4f:	00 
  704c50:	74 1c                	je     704c6e <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_input+0x18e>
  704c52:	84 c0                	test   %al,%al
  704c54:	74 0a                	je     704c60 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_input+0x180>
  704c56:	49 83 be 88 05 00 00 	cmpq   $0xffffffffffffffff,0x588(%r14)
  704c5d:	ff 
  704c5e:	74 0e                	je     704c6e <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_input+0x18e>
  704c60:	49 8b 96 90 06 00 00 	mov    0x690(%r14),%rdx
  704c67:	b9 01 00 00 00       	mov    $0x1,%ecx
  704c6c:	eb 02                	jmp    704c70 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_input+0x190>
  704c6e:	31 c9                	xor    %ecx,%ecx
  704c70:	49 8b b6 08 07 00 00 	mov    0x708(%r14),%rsi
  704c77:	48 89 4b 08          	mov    %rcx,0x8(%rbx)
  704c7b:	48 89 53 10          	mov    %rdx,0x10(%rbx)
  704c7f:	0f 11 43 18          	movups %xmm0,0x18(%rbx)
  704c83:	48 89 73 28          	mov    %rsi,0x28(%rbx)
  704c87:	88 43 30             	mov    %al,0x30(%rbx)
  704c8a:	48 c7 03 fe ff ff ff 	movq   $0xfffffffffffffffe,(%rbx)
  704c91:	48 83 c4 40          	add    $0x40,%rsp
  704c95:	5b                   	pop    %rbx
  704c96:	41 5c                	pop    %r12
  704c98:	41 5d                	pop    %r13
  704c9a:	41 5e                	pop    %r14
  704c9c:	41 5f                	pop    %r15
  704c9e:	c3                   	ret
  704c9f:	48 8d 3d fa 62 3f 00 	lea    0x3f62fa(%rip),%rdi        # afafa0 <__frame_dummy_init_array_entry+0x738>
  704ca6:	ff 15 e4 46 42 00    	call   *0x4246e4(%rip)        # b29390 <_DYNAMIC+0x308>
  704cac:	48 8d 3d 05 5d 3f 00 	lea    0x3f5d05(%rip),%rdi        # afa9b8 <__frame_dummy_init_array_entry+0x150>
  704cb3:	ff 15 d7 46 42 00    	call   *0x4246d7(%rip)        # b29390 <_DYNAMIC+0x308>
  704cb9:	48 c7 03 1f 00 00 00 	movq   $0x1f,(%rbx)
  704cc0:	eb cf                	jmp    704c91 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::select_input+0x1b1>
  704cc2:	48 8d 15 bf 62 3f 00 	lea    0x3f62bf(%rip),%rdx        # afaf88 <__frame_dummy_init_array_entry+0x720>
  704cc9:	4c 89 e7             	mov    %r12,%rdi
  704ccc:	ff 15 0e 47 42 00    	call   *0x42470e(%rip)        # b293e0 <_DYNAMIC+0x358>
  704cd2:	48 8d 15 c7 5c 3f 00 	lea    0x3f5cc7(%rip),%rdx        # afa9a0 <__frame_dummy_init_array_entry+0x138>
  704cd9:	ff 15 01 47 42 00    	call   *0x424701(%rip)        # b293e0 <_DYNAMIC+0x358>
