
/tmp/gpui-contained-owner-spike-target/release/deps/unit_action_cost_two-c899ee77dd9a9ab3:     file format elf64-x86-64


Disassembly of section .text:

00000000006faa10 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::describe_with>:
  6faa10:	55                   	push   %rbp
  6faa11:	41 57                	push   %r15
  6faa13:	41 56                	push   %r14
  6faa15:	41 54                	push   %r12
  6faa17:	53                   	push   %rbx
  6faa18:	48 81 ec 90 00 00 00 	sub    $0x90,%rsp
  6faa1f:	89 cd                	mov    %ecx,%ebp
  6faa21:	49 89 d7             	mov    %rdx,%r15
  6faa24:	49 89 f6             	mov    %rsi,%r14
  6faa27:	48 89 fb             	mov    %rdi,%rbx
  6faa2a:	48 81 c6 28 02 00 00 	add    $0x228,%rsi
  6faa31:	49 8d 96 10 07 00 00 	lea    0x710(%r14),%rdx
  6faa38:	48 8d 7c 24 78       	lea    0x78(%rsp),%rdi
  6faa3d:	e8 ee a8 05 00       	call   755330 <<gpui::source::Sources<unit_action_cost_two::SecondModel>>::validate>
  6faa42:	83 7c 24 78 ff       	cmpl   $0xffffffff,0x78(%rsp)
  6faa47:	74 1e                	je     6faa67 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::describe_with+0x57>
  6faa49:	48 8b 84 24 88 00 00 	mov    0x88(%rsp),%rax
  6faa50:	00 
  6faa51:	48 89 44 24 58       	mov    %rax,0x58(%rsp)
  6faa56:	0f 10 44 24 78       	movups 0x78(%rsp),%xmm0
  6faa5b:	0f 11 44 24 48       	movups %xmm0,0x48(%rsp)
  6faa60:	b8 20 00 00 00       	mov    $0x20,%eax
  6faa65:	eb 1e                	jmp    6faa85 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::describe_with+0x75>
  6faa67:	40 0f b6 d5          	movzbl %bpl,%edx
  6faa6b:	48 8d 7c 24 40       	lea    0x40(%rsp),%rdi
  6faa70:	4c 89 f6             	mov    %r14,%rsi
  6faa73:	4c 89 f9             	mov    %r15,%rcx
  6faa76:	e8 35 7c 01 00       	call   7126b0 <<gpui::runtime::Runtime<unit_action_cost_two::SecondModel>>::describe_inner>
  6faa7b:	48 8b 44 24 40       	mov    0x40(%rsp),%rax
  6faa80:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  6faa85:	4c 8b 7c 24 48       	mov    0x48(%rsp),%r15
  6faa8a:	4c 8b 64 24 50       	mov    0x50(%rsp),%r12
  6faa8f:	0f 10 44 24 68       	movups 0x68(%rsp),%xmm0
  6faa94:	0f 11 44 24 30       	movups %xmm0,0x30(%rsp)
  6faa99:	48 8b 54 24 50       	mov    0x50(%rsp),%rdx
  6faa9e:	48 8b 74 24 58       	mov    0x58(%rsp),%rsi
  6faaa3:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  6faaa8:	4c 89 7c 24 10       	mov    %r15,0x10(%rsp)
  6faaad:	48 89 54 24 18       	mov    %rdx,0x18(%rsp)
  6faab2:	48 89 74 24 20       	mov    %rsi,0x20(%rsp)
  6faab7:	48 89 4c 24 28       	mov    %rcx,0x28(%rsp)
  6faabc:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  6faac0:	74 3d                	je     6faaff <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::describe_with+0xef>
  6faac2:	48 83 f8 fd          	cmp    $0xfffffffffffffffd,%rax
  6faac6:	75 40                	jne    6fab08 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::describe_with+0xf8>
  6faac8:	4c 89 f7             	mov    %r14,%rdi
  6faacb:	e8 40 00 02 00       	call   71ab10 <<gpui::runtime::Runtime<unit_action_cost_two::SecondModel>>::poison>
  6faad0:	48 c7 03 0f 00 00 00 	movq   $0xf,(%rbx)
  6faad7:	49 8b 04 24          	mov    (%r12),%rax
  6faadb:	48 85 c0             	test   %rax,%rax
  6faade:	74 05                	je     6faae5 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::describe_with+0xd5>
  6faae0:	4c 89 ff             	mov    %r15,%rdi
  6faae3:	ff d0                	call   *%rax
  6faae5:	49 8b 74 24 08       	mov    0x8(%r12),%rsi
  6faaea:	48 85 f6             	test   %rsi,%rsi
  6faaed:	74 4f                	je     6fab3e <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::describe_with+0x12e>
  6faaef:	49 8b 54 24 10       	mov    0x10(%r12),%rdx
  6faaf4:	4c 89 ff             	mov    %r15,%rdi
  6faaf7:	ff 15 bb e8 42 00    	call   *0x42e8bb(%rip)        # b293b8 <_DYNAMIC+0x248>
  6faafd:	eb 3f                	jmp    6fab3e <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::describe_with+0x12e>
  6faaff:	48 c7 03 fe ff ff ff 	movq   $0xfffffffffffffffe,(%rbx)
  6fab06:	eb 36                	jmp    6fab3e <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::describe_with+0x12e>
  6fab08:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
  6fab0d:	48 89 43 30          	mov    %rax,0x30(%rbx)
  6fab11:	0f 10 44 24 08       	movups 0x8(%rsp),%xmm0
  6fab16:	0f 10 4c 24 18       	movups 0x18(%rsp),%xmm1
  6fab1b:	0f 10 54 24 28       	movups 0x28(%rsp),%xmm2
  6fab20:	0f 11 53 20          	movups %xmm2,0x20(%rbx)
  6fab24:	0f 11 4b 10          	movups %xmm1,0x10(%rbx)
  6fab28:	0f 11 03             	movups %xmm0,(%rbx)
  6fab2b:	41 c6 86 1e 08 00 00 	movb   $0x0,0x81e(%r14)
  6fab32:	00 
  6fab33:	49 c7 86 e8 05 00 00 	movq   $0x0,0x5e8(%r14)
  6fab3a:	00 00 00 00 
  6fab3e:	48 81 c4 90 00 00 00 	add    $0x90,%rsp
  6fab45:	5b                   	pop    %rbx
  6fab46:	41 5c                	pop    %r12
  6fab48:	41 5e                	pop    %r14
  6fab4a:	41 5f                	pop    %r15
  6fab4c:	5d                   	pop    %rbp
  6fab4d:	c3                   	ret
  6fab4e:	48 89 c3             	mov    %rax,%rbx
  6fab51:	49 8b 74 24 08       	mov    0x8(%r12),%rsi
  6fab56:	48 85 f6             	test   %rsi,%rsi
  6fab59:	74 23                	je     6fab7e <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::describe_with+0x16e>
  6fab5b:	49 8b 54 24 10       	mov    0x10(%r12),%rdx
  6fab60:	4c 89 ff             	mov    %r15,%rdi
  6fab63:	ff 15 4f e8 42 00    	call   *0x42e84f(%rip)        # b293b8 <_DYNAMIC+0x248>
  6fab69:	48 89 df             	mov    %rbx,%rdi
  6fab6c:	e8 df e9 3f 00       	call   af9550 <_Unwind_Resume@plt>
  6fab71:	48 89 c3             	mov    %rax,%rbx
  6fab74:	48 8d 7c 24 08       	lea    0x8(%rsp),%rdi
  6fab79:	e8 92 a2 ff ff       	call   6f4e10 <core::ptr::drop_glue::<core::result::Result<core::result::Result<gpui::runtime::paint::PatchOutcome, gpui::runtime::Error>, alloc::boxed::Box<dyn core::any::Any + core::marker::Send>>>>
  6fab7e:	48 89 df             	mov    %rbx,%rdi
  6fab81:	e8 ca e9 3f 00       	call   af9550 <_Unwind_Resume@plt>
  6fab86:	ff 15 5c e8 42 00    	call   *0x42e85c(%rip)        # b293e8 <_DYNAMIC+0x278>
  6fab8c:	48 89 c7             	mov    %rax,%rdi
  6fab8f:	ff 15 43 e9 42 00    	call   *0x42e943(%rip)        # b294d8 <_DYNAMIC+0x368>
  6fab95:	49 89 c7             	mov    %rax,%r15
  6fab98:	49 89 d4             	mov    %rdx,%r12
  6fab9b:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  6faba0:	48 89 54 24 18       	mov    %rdx,0x18(%rsp)
  6faba5:	48 c7 44 24 08 fd ff 	movq   $0xfffffffffffffffd,0x8(%rsp)
  6fabac:	ff ff 
  6fabae:	e9 15 ff ff ff       	jmp    6faac8 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::describe_with+0xb8>
  6fabb3:	ff 15 27 e9 42 00    	call   *0x42e927(%rip)        # b294e0 <_DYNAMIC+0x370>
