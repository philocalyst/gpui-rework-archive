
/tmp/gpui-contained-owner-spike-target/release/deps/unit_action_cost_two-c899ee77dd9a9ab3:     file format elf64-x86-64


Disassembly of section .text:

00000000006faa00 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::describe_with>:
  6faa00:	55                   	push   %rbp
  6faa01:	41 57                	push   %r15
  6faa03:	41 56                	push   %r14
  6faa05:	41 54                	push   %r12
  6faa07:	53                   	push   %rbx
  6faa08:	48 81 ec 90 00 00 00 	sub    $0x90,%rsp
  6faa0f:	89 cd                	mov    %ecx,%ebp
  6faa11:	49 89 d7             	mov    %rdx,%r15
  6faa14:	49 89 f6             	mov    %rsi,%r14
  6faa17:	48 89 fb             	mov    %rdi,%rbx
  6faa1a:	48 81 c6 28 02 00 00 	add    $0x228,%rsi
  6faa21:	49 8d 96 10 07 00 00 	lea    0x710(%r14),%rdx
  6faa28:	48 8d 7c 24 78       	lea    0x78(%rsp),%rdi
  6faa2d:	e8 8e a8 05 00       	call   7552c0 <<gpui::source::Sources<unit_action_cost_two::SecondModel>>::validate>
  6faa32:	83 7c 24 78 ff       	cmpl   $0xffffffff,0x78(%rsp)
  6faa37:	74 1e                	je     6faa57 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::describe_with+0x57>
  6faa39:	48 8b 84 24 88 00 00 	mov    0x88(%rsp),%rax
  6faa40:	00 
  6faa41:	48 89 44 24 58       	mov    %rax,0x58(%rsp)
  6faa46:	0f 10 44 24 78       	movups 0x78(%rsp),%xmm0
  6faa4b:	0f 11 44 24 48       	movups %xmm0,0x48(%rsp)
  6faa50:	b8 20 00 00 00       	mov    $0x20,%eax
  6faa55:	eb 1e                	jmp    6faa75 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::describe_with+0x75>
  6faa57:	40 0f b6 d5          	movzbl %bpl,%edx
  6faa5b:	48 8d 7c 24 40       	lea    0x40(%rsp),%rdi
  6faa60:	4c 89 f6             	mov    %r14,%rsi
  6faa63:	4c 89 f9             	mov    %r15,%rcx
  6faa66:	e8 d5 7b 01 00       	call   712640 <<gpui::runtime::Runtime<unit_action_cost_two::SecondModel>>::describe_inner>
  6faa6b:	48 8b 44 24 40       	mov    0x40(%rsp),%rax
  6faa70:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  6faa75:	4c 8b 7c 24 48       	mov    0x48(%rsp),%r15
  6faa7a:	4c 8b 64 24 50       	mov    0x50(%rsp),%r12
  6faa7f:	0f 10 44 24 68       	movups 0x68(%rsp),%xmm0
  6faa84:	0f 11 44 24 30       	movups %xmm0,0x30(%rsp)
  6faa89:	48 8b 54 24 50       	mov    0x50(%rsp),%rdx
  6faa8e:	48 8b 74 24 58       	mov    0x58(%rsp),%rsi
  6faa93:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  6faa98:	4c 89 7c 24 10       	mov    %r15,0x10(%rsp)
  6faa9d:	48 89 54 24 18       	mov    %rdx,0x18(%rsp)
  6faaa2:	48 89 74 24 20       	mov    %rsi,0x20(%rsp)
  6faaa7:	48 89 4c 24 28       	mov    %rcx,0x28(%rsp)
  6faaac:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  6faab0:	74 3d                	je     6faaef <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::describe_with+0xef>
  6faab2:	48 83 f8 fd          	cmp    $0xfffffffffffffffd,%rax
  6faab6:	75 40                	jne    6faaf8 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::describe_with+0xf8>
  6faab8:	4c 89 f7             	mov    %r14,%rdi
  6faabb:	e8 e0 ff 01 00       	call   71aaa0 <<gpui::runtime::Runtime<unit_action_cost_two::SecondModel>>::poison>
  6faac0:	48 c7 03 0f 00 00 00 	movq   $0xf,(%rbx)
  6faac7:	49 8b 04 24          	mov    (%r12),%rax
  6faacb:	48 85 c0             	test   %rax,%rax
  6faace:	74 05                	je     6faad5 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::describe_with+0xd5>
  6faad0:	4c 89 ff             	mov    %r15,%rdi
  6faad3:	ff d0                	call   *%rax
  6faad5:	49 8b 74 24 08       	mov    0x8(%r12),%rsi
  6faada:	48 85 f6             	test   %rsi,%rsi
  6faadd:	74 4f                	je     6fab2e <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::describe_with+0x12e>
  6faadf:	49 8b 54 24 10       	mov    0x10(%r12),%rdx
  6faae4:	4c 89 ff             	mov    %r15,%rdi
  6faae7:	ff 15 5b e8 42 00    	call   *0x42e85b(%rip)        # b29348 <_DYNAMIC+0x248>
  6faaed:	eb 3f                	jmp    6fab2e <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::describe_with+0x12e>
  6faaef:	48 c7 03 fe ff ff ff 	movq   $0xfffffffffffffffe,(%rbx)
  6faaf6:	eb 36                	jmp    6fab2e <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::describe_with+0x12e>
  6faaf8:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
  6faafd:	48 89 43 30          	mov    %rax,0x30(%rbx)
  6fab01:	0f 10 44 24 08       	movups 0x8(%rsp),%xmm0
  6fab06:	0f 10 4c 24 18       	movups 0x18(%rsp),%xmm1
  6fab0b:	0f 10 54 24 28       	movups 0x28(%rsp),%xmm2
  6fab10:	0f 11 53 20          	movups %xmm2,0x20(%rbx)
  6fab14:	0f 11 4b 10          	movups %xmm1,0x10(%rbx)
  6fab18:	0f 11 03             	movups %xmm0,(%rbx)
  6fab1b:	41 c6 86 1e 08 00 00 	movb   $0x0,0x81e(%r14)
  6fab22:	00 
  6fab23:	49 c7 86 e8 05 00 00 	movq   $0x0,0x5e8(%r14)
  6fab2a:	00 00 00 00 
  6fab2e:	48 81 c4 90 00 00 00 	add    $0x90,%rsp
  6fab35:	5b                   	pop    %rbx
  6fab36:	41 5c                	pop    %r12
  6fab38:	41 5e                	pop    %r14
  6fab3a:	41 5f                	pop    %r15
  6fab3c:	5d                   	pop    %rbp
  6fab3d:	c3                   	ret
  6fab3e:	48 89 c3             	mov    %rax,%rbx
  6fab41:	49 8b 74 24 08       	mov    0x8(%r12),%rsi
  6fab46:	48 85 f6             	test   %rsi,%rsi
  6fab49:	74 23                	je     6fab6e <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::describe_with+0x16e>
  6fab4b:	49 8b 54 24 10       	mov    0x10(%r12),%rdx
  6fab50:	4c 89 ff             	mov    %r15,%rdi
  6fab53:	ff 15 ef e7 42 00    	call   *0x42e7ef(%rip)        # b29348 <_DYNAMIC+0x248>
  6fab59:	48 89 df             	mov    %rbx,%rdi
  6fab5c:	e8 7f e9 3f 00       	call   af94e0 <_Unwind_Resume@plt>
  6fab61:	48 89 c3             	mov    %rax,%rbx
  6fab64:	48 8d 7c 24 08       	lea    0x8(%rsp),%rdi
  6fab69:	e8 92 a2 ff ff       	call   6f4e00 <core::ptr::drop_glue::<core::result::Result<core::result::Result<gpui::runtime::paint::PatchOutcome, gpui::runtime::Error>, alloc::boxed::Box<dyn core::any::Any + core::marker::Send>>>>
  6fab6e:	48 89 df             	mov    %rbx,%rdi
  6fab71:	e8 6a e9 3f 00       	call   af94e0 <_Unwind_Resume@plt>
  6fab76:	ff 15 fc e7 42 00    	call   *0x42e7fc(%rip)        # b29378 <_DYNAMIC+0x278>
  6fab7c:	48 89 c7             	mov    %rax,%rdi
  6fab7f:	ff 15 e3 e8 42 00    	call   *0x42e8e3(%rip)        # b29468 <_DYNAMIC+0x368>
  6fab85:	49 89 c7             	mov    %rax,%r15
  6fab88:	49 89 d4             	mov    %rdx,%r12
  6fab8b:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  6fab90:	48 89 54 24 18       	mov    %rdx,0x18(%rsp)
  6fab95:	48 c7 44 24 08 fd ff 	movq   $0xfffffffffffffffd,0x8(%rsp)
  6fab9c:	ff ff 
  6fab9e:	e9 15 ff ff ff       	jmp    6faab8 <<gpui::runtime::RuntimeMut<unit_action_cost_two::SecondModel, ()>>::describe_with+0xb8>
  6faba3:	ff 15 c7 e8 42 00    	call   *0x42e8c7(%rip)        # b29470 <_DYNAMIC+0x370>
