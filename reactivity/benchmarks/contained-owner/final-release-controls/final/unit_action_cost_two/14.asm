
/tmp/gpui-contained-property-exchange-target/release/deps/unit_action_cost_two-c899ee77dd9a9ab3:     file format elf64-x86-64


Disassembly of section .text:

00000000006fa910 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::describe_with>:
  6fa910:	55                   	push   %rbp
  6fa911:	41 57                	push   %r15
  6fa913:	41 56                	push   %r14
  6fa915:	41 54                	push   %r12
  6fa917:	53                   	push   %rbx
  6fa918:	48 81 ec 90 00 00 00 	sub    $0x90,%rsp
  6fa91f:	89 cd                	mov    %ecx,%ebp
  6fa921:	49 89 d7             	mov    %rdx,%r15
  6fa924:	49 89 f6             	mov    %rsi,%r14
  6fa927:	48 89 fb             	mov    %rdi,%rbx
  6fa92a:	48 81 c6 28 02 00 00 	add    $0x228,%rsi
  6fa931:	49 8d 96 10 07 00 00 	lea    0x710(%r14),%rdx
  6fa938:	48 8d 7c 24 78       	lea    0x78(%rsp),%rdi
  6fa93d:	e8 ee a8 05 00       	call   755230 <<gpui::source::Sources<unit_action_cost_two::SecondModel>>::validate>
  6fa942:	83 7c 24 78 ff       	cmpl   $0xffffffff,0x78(%rsp)
  6fa947:	74 1e                	je     6fa967 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::describe_with+0x57>
  6fa949:	48 8b 84 24 88 00 00 	mov    0x88(%rsp),%rax
  6fa950:	00 
  6fa951:	48 89 44 24 58       	mov    %rax,0x58(%rsp)
  6fa956:	0f 10 44 24 78       	movups 0x78(%rsp),%xmm0
  6fa95b:	0f 11 44 24 48       	movups %xmm0,0x48(%rsp)
  6fa960:	b8 20 00 00 00       	mov    $0x20,%eax
  6fa965:	eb 1e                	jmp    6fa985 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::describe_with+0x75>
  6fa967:	40 0f b6 d5          	movzbl %bpl,%edx
  6fa96b:	48 8d 7c 24 40       	lea    0x40(%rsp),%rdi
  6fa970:	4c 89 f6             	mov    %r14,%rsi
  6fa973:	4c 89 f9             	mov    %r15,%rcx
  6fa976:	e8 35 7c 01 00       	call   7125b0 <<gpui::runtime::Runtime<unit_action_cost_two::SecondModel>>::describe_inner>
  6fa97b:	48 8b 44 24 40       	mov    0x40(%rsp),%rax
  6fa980:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  6fa985:	4c 8b 7c 24 48       	mov    0x48(%rsp),%r15
  6fa98a:	4c 8b 64 24 50       	mov    0x50(%rsp),%r12
  6fa98f:	0f 10 44 24 68       	movups 0x68(%rsp),%xmm0
  6fa994:	0f 11 44 24 30       	movups %xmm0,0x30(%rsp)
  6fa999:	48 8b 54 24 50       	mov    0x50(%rsp),%rdx
  6fa99e:	48 8b 74 24 58       	mov    0x58(%rsp),%rsi
  6fa9a3:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  6fa9a8:	4c 89 7c 24 10       	mov    %r15,0x10(%rsp)
  6fa9ad:	48 89 54 24 18       	mov    %rdx,0x18(%rsp)
  6fa9b2:	48 89 74 24 20       	mov    %rsi,0x20(%rsp)
  6fa9b7:	48 89 4c 24 28       	mov    %rcx,0x28(%rsp)
  6fa9bc:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  6fa9c0:	74 3d                	je     6fa9ff <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::describe_with+0xef>
  6fa9c2:	48 83 f8 fd          	cmp    $0xfffffffffffffffd,%rax
  6fa9c6:	75 40                	jne    6faa08 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::describe_with+0xf8>
  6fa9c8:	4c 89 f7             	mov    %r14,%rdi
  6fa9cb:	e8 40 00 02 00       	call   71aa10 <<gpui::runtime::Runtime<unit_action_cost_two::SecondModel>>::poison>
  6fa9d0:	48 c7 03 0f 00 00 00 	movq   $0xf,(%rbx)
  6fa9d7:	49 8b 04 24          	mov    (%r12),%rax
  6fa9db:	48 85 c0             	test   %rax,%rax
  6fa9de:	74 05                	je     6fa9e5 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::describe_with+0xd5>
  6fa9e0:	4c 89 ff             	mov    %r15,%rdi
  6fa9e3:	ff d0                	call   *%rax
  6fa9e5:	49 8b 74 24 08       	mov    0x8(%r12),%rsi
  6fa9ea:	48 85 f6             	test   %rsi,%rsi
  6fa9ed:	74 4f                	je     6faa3e <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::describe_with+0x12e>
  6fa9ef:	49 8b 54 24 10       	mov    0x10(%r12),%rdx
  6fa9f4:	4c 89 ff             	mov    %r15,%rdi
  6fa9f7:	ff 15 d3 e8 42 00    	call   *0x42e8d3(%rip)        # b292d0 <_DYNAMIC+0x248>
  6fa9fd:	eb 3f                	jmp    6faa3e <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::describe_with+0x12e>
  6fa9ff:	48 c7 03 fe ff ff ff 	movq   $0xfffffffffffffffe,(%rbx)
  6faa06:	eb 36                	jmp    6faa3e <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::describe_with+0x12e>
  6faa08:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
  6faa0d:	48 89 43 30          	mov    %rax,0x30(%rbx)
  6faa11:	0f 10 44 24 08       	movups 0x8(%rsp),%xmm0
  6faa16:	0f 10 4c 24 18       	movups 0x18(%rsp),%xmm1
  6faa1b:	0f 10 54 24 28       	movups 0x28(%rsp),%xmm2
  6faa20:	0f 11 53 20          	movups %xmm2,0x20(%rbx)
  6faa24:	0f 11 4b 10          	movups %xmm1,0x10(%rbx)
  6faa28:	0f 11 03             	movups %xmm0,(%rbx)
  6faa2b:	41 c6 86 1e 08 00 00 	movb   $0x0,0x81e(%r14)
  6faa32:	00 
  6faa33:	49 c7 86 e8 05 00 00 	movq   $0x0,0x5e8(%r14)
  6faa3a:	00 00 00 00 
  6faa3e:	48 81 c4 90 00 00 00 	add    $0x90,%rsp
  6faa45:	5b                   	pop    %rbx
  6faa46:	41 5c                	pop    %r12
  6faa48:	41 5e                	pop    %r14
  6faa4a:	41 5f                	pop    %r15
  6faa4c:	5d                   	pop    %rbp
  6faa4d:	c3                   	ret
  6faa4e:	48 89 c3             	mov    %rax,%rbx
  6faa51:	49 8b 74 24 08       	mov    0x8(%r12),%rsi
  6faa56:	48 85 f6             	test   %rsi,%rsi
  6faa59:	74 23                	je     6faa7e <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::describe_with+0x16e>
  6faa5b:	49 8b 54 24 10       	mov    0x10(%r12),%rdx
  6faa60:	4c 89 ff             	mov    %r15,%rdi
  6faa63:	ff 15 67 e8 42 00    	call   *0x42e867(%rip)        # b292d0 <_DYNAMIC+0x248>
  6faa69:	48 89 df             	mov    %rbx,%rdi
  6faa6c:	e8 3f ea 3f 00       	call   af94b0 <_Unwind_Resume@plt>
  6faa71:	48 89 c3             	mov    %rax,%rbx
  6faa74:	48 8d 7c 24 08       	lea    0x8(%rsp),%rdi
  6faa79:	e8 92 a2 ff ff       	call   6f4d10 <core::ptr::drop_glue::<core::result::Result<core::result::Result<gpui::runtime::paint::PatchOutcome, gpui::runtime::Error>, alloc::boxed::Box<dyn core::any::Any + core::marker::Send>>>>
  6faa7e:	48 89 df             	mov    %rbx,%rdi
  6faa81:	e8 2a ea 3f 00       	call   af94b0 <_Unwind_Resume@plt>
  6faa86:	ff 15 74 e8 42 00    	call   *0x42e874(%rip)        # b29300 <_DYNAMIC+0x278>
  6faa8c:	48 89 c7             	mov    %rax,%rdi
  6faa8f:	ff 15 5b e9 42 00    	call   *0x42e95b(%rip)        # b293f0 <_DYNAMIC+0x368>
  6faa95:	49 89 c7             	mov    %rax,%r15
  6faa98:	49 89 d4             	mov    %rdx,%r12
  6faa9b:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  6faaa0:	48 89 54 24 18       	mov    %rdx,0x18(%rsp)
  6faaa5:	48 c7 44 24 08 fd ff 	movq   $0xfffffffffffffffd,0x8(%rsp)
  6faaac:	ff ff 
  6faaae:	e9 15 ff ff ff       	jmp    6fa9c8 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::describe_with+0xb8>
  6faab3:	ff 15 3f e9 42 00    	call   *0x42e93f(%rip)        # b293f8 <_DYNAMIC+0x370>
