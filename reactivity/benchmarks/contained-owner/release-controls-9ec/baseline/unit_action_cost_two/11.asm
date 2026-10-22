
/tmp/gpui-contained-owner-unit-baseline-target/release/deps/unit_action_cost_two-c899ee77dd9a9ab3:     file format elf64-x86-64


Disassembly of section .text:

00000000006fcd70 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::describe_with>:
  6fcd70:	55                   	push   %rbp
  6fcd71:	41 57                	push   %r15
  6fcd73:	41 56                	push   %r14
  6fcd75:	41 54                	push   %r12
  6fcd77:	53                   	push   %rbx
  6fcd78:	48 81 ec 90 00 00 00 	sub    $0x90,%rsp
  6fcd7f:	89 cd                	mov    %ecx,%ebp
  6fcd81:	49 89 d7             	mov    %rdx,%r15
  6fcd84:	49 89 f6             	mov    %rsi,%r14
  6fcd87:	48 89 fb             	mov    %rdi,%rbx
  6fcd8a:	48 81 c6 28 02 00 00 	add    $0x228,%rsi
  6fcd91:	49 8d 96 10 07 00 00 	lea    0x710(%r14),%rdx
  6fcd98:	48 8d 7c 24 78       	lea    0x78(%rsp),%rdi
  6fcd9d:	e8 9e 76 05 00       	call   754440 <<gpui::source::Sources<unit_action_cost_two::Model>>::validate>
  6fcda2:	83 7c 24 78 ff       	cmpl   $0xffffffff,0x78(%rsp)
  6fcda7:	74 1e                	je     6fcdc7 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::describe_with+0x57>
  6fcda9:	48 8b 84 24 88 00 00 	mov    0x88(%rsp),%rax
  6fcdb0:	00 
  6fcdb1:	48 89 44 24 58       	mov    %rax,0x58(%rsp)
  6fcdb6:	0f 10 44 24 78       	movups 0x78(%rsp),%xmm0
  6fcdbb:	0f 11 44 24 48       	movups %xmm0,0x48(%rsp)
  6fcdc0:	b8 20 00 00 00       	mov    $0x20,%eax
  6fcdc5:	eb 1e                	jmp    6fcde5 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::describe_with+0x75>
  6fcdc7:	40 0f b6 d5          	movzbl %bpl,%edx
  6fcdcb:	48 8d 7c 24 40       	lea    0x40(%rsp),%rdi
  6fcdd0:	4c 89 f6             	mov    %r14,%rsi
  6fcdd3:	4c 89 f9             	mov    %r15,%rcx
  6fcdd6:	e8 a5 2d 02 00       	call   71fb80 <<gpui::runtime::Runtime<unit_action_cost_two::Model>>::describe_inner>
  6fcddb:	48 8b 44 24 40       	mov    0x40(%rsp),%rax
  6fcde0:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  6fcde5:	4c 8b 7c 24 48       	mov    0x48(%rsp),%r15
  6fcdea:	4c 8b 64 24 50       	mov    0x50(%rsp),%r12
  6fcdef:	0f 10 44 24 68       	movups 0x68(%rsp),%xmm0
  6fcdf4:	0f 11 44 24 30       	movups %xmm0,0x30(%rsp)
  6fcdf9:	48 8b 54 24 50       	mov    0x50(%rsp),%rdx
  6fcdfe:	48 8b 74 24 58       	mov    0x58(%rsp),%rsi
  6fce03:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  6fce08:	4c 89 7c 24 10       	mov    %r15,0x10(%rsp)
  6fce0d:	48 89 54 24 18       	mov    %rdx,0x18(%rsp)
  6fce12:	48 89 74 24 20       	mov    %rsi,0x20(%rsp)
  6fce17:	48 89 4c 24 28       	mov    %rcx,0x28(%rsp)
  6fce1c:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  6fce20:	74 3d                	je     6fce5f <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::describe_with+0xef>
  6fce22:	48 83 f8 fd          	cmp    $0xfffffffffffffffd,%rax
  6fce26:	75 40                	jne    6fce68 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::describe_with+0xf8>
  6fce28:	4c 89 f7             	mov    %r14,%rdi
  6fce2b:	e8 b0 b1 02 00       	call   727fe0 <<gpui::runtime::Runtime<unit_action_cost_two::Model>>::poison>
  6fce30:	48 c7 03 0f 00 00 00 	movq   $0xf,(%rbx)
  6fce37:	49 8b 04 24          	mov    (%r12),%rax
  6fce3b:	48 85 c0             	test   %rax,%rax
  6fce3e:	74 05                	je     6fce45 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::describe_with+0xd5>
  6fce40:	4c 89 ff             	mov    %r15,%rdi
  6fce43:	ff d0                	call   *%rax
  6fce45:	49 8b 74 24 08       	mov    0x8(%r12),%rsi
  6fce4a:	48 85 f6             	test   %rsi,%rsi
  6fce4d:	74 4f                	je     6fce9e <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::describe_with+0x12e>
  6fce4f:	49 8b 54 24 10       	mov    0x10(%r12),%rdx
  6fce54:	4c 89 ff             	mov    %r15,%rdi
  6fce57:	ff 15 a3 b0 42 00    	call   *0x42b0a3(%rip)        # b27f00 <_DYNAMIC+0x248>
  6fce5d:	eb 3f                	jmp    6fce9e <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::describe_with+0x12e>
  6fce5f:	48 c7 03 fe ff ff ff 	movq   $0xfffffffffffffffe,(%rbx)
  6fce66:	eb 36                	jmp    6fce9e <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::describe_with+0x12e>
  6fce68:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
  6fce6d:	48 89 43 30          	mov    %rax,0x30(%rbx)
  6fce71:	0f 10 44 24 08       	movups 0x8(%rsp),%xmm0
  6fce76:	0f 10 4c 24 18       	movups 0x18(%rsp),%xmm1
  6fce7b:	0f 10 54 24 28       	movups 0x28(%rsp),%xmm2
  6fce80:	0f 11 53 20          	movups %xmm2,0x20(%rbx)
  6fce84:	0f 11 4b 10          	movups %xmm1,0x10(%rbx)
  6fce88:	0f 11 03             	movups %xmm0,(%rbx)
  6fce8b:	41 c6 86 1e 07 00 00 	movb   $0x0,0x71e(%r14)
  6fce92:	00 
  6fce93:	49 c7 86 e8 05 00 00 	movq   $0x0,0x5e8(%r14)
  6fce9a:	00 00 00 00 
  6fce9e:	48 81 c4 90 00 00 00 	add    $0x90,%rsp
  6fcea5:	5b                   	pop    %rbx
  6fcea6:	41 5c                	pop    %r12
  6fcea8:	41 5e                	pop    %r14
  6fceaa:	41 5f                	pop    %r15
  6fceac:	5d                   	pop    %rbp
  6fcead:	c3                   	ret
  6fceae:	48 89 c3             	mov    %rax,%rbx
  6fceb1:	49 8b 74 24 08       	mov    0x8(%r12),%rsi
  6fceb6:	48 85 f6             	test   %rsi,%rsi
  6fceb9:	74 23                	je     6fcede <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::describe_with+0x16e>
  6fcebb:	49 8b 54 24 10       	mov    0x10(%r12),%rdx
  6fcec0:	4c 89 ff             	mov    %r15,%rdi
  6fcec3:	ff 15 37 b0 42 00    	call   *0x42b037(%rip)        # b27f00 <_DYNAMIC+0x248>
  6fcec9:	48 89 df             	mov    %rbx,%rdi
  6fcecc:	e8 9f b2 3f 00       	call   af8170 <_Unwind_Resume@plt>
  6fced1:	48 89 c3             	mov    %rax,%rbx
  6fced4:	48 8d 7c 24 08       	lea    0x8(%rsp),%rdi
  6fced9:	e8 c2 79 ff ff       	call   6f48a0 <core::ptr::drop_glue::<core::result::Result<core::result::Result<gpui::runtime::paint::PatchOutcome, gpui::runtime::Error>, alloc::boxed::Box<dyn core::any::Any + core::marker::Send>>>>
  6fcede:	48 89 df             	mov    %rbx,%rdi
  6fcee1:	e8 8a b2 3f 00       	call   af8170 <_Unwind_Resume@plt>
  6fcee6:	ff 15 44 b0 42 00    	call   *0x42b044(%rip)        # b27f30 <_DYNAMIC+0x278>
  6fceec:	48 89 c7             	mov    %rax,%rdi
  6fceef:	ff 15 2b b1 42 00    	call   *0x42b12b(%rip)        # b28020 <_DYNAMIC+0x368>
  6fcef5:	49 89 c7             	mov    %rax,%r15
  6fcef8:	49 89 d4             	mov    %rdx,%r12
  6fcefb:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  6fcf00:	48 89 54 24 18       	mov    %rdx,0x18(%rsp)
  6fcf05:	48 c7 44 24 08 fd ff 	movq   $0xfffffffffffffffd,0x8(%rsp)
  6fcf0c:	ff ff 
  6fcf0e:	e9 15 ff ff ff       	jmp    6fce28 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::describe_with+0xb8>
  6fcf13:	ff 15 0f b1 42 00    	call   *0x42b10f(%rip)        # b28028 <_DYNAMIC+0x370>
