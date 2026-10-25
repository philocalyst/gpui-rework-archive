
/tmp/gpui-contained-owner-spike-target/release/deps/unit_action_cost_two-c899ee77dd9a9ab3:     file format elf64-x86-64


Disassembly of section .text:

00000000006fd9d0 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::describe_with>:
  6fd9d0:	55                   	push   %rbp
  6fd9d1:	41 57                	push   %r15
  6fd9d3:	41 56                	push   %r14
  6fd9d5:	41 54                	push   %r12
  6fd9d7:	53                   	push   %rbx
  6fd9d8:	48 81 ec 90 00 00 00 	sub    $0x90,%rsp
  6fd9df:	89 cd                	mov    %ecx,%ebp
  6fd9e1:	49 89 d7             	mov    %rdx,%r15
  6fd9e4:	49 89 f6             	mov    %rsi,%r14
  6fd9e7:	48 89 fb             	mov    %rdi,%rbx
  6fd9ea:	48 81 c6 28 02 00 00 	add    $0x228,%rsi
  6fd9f1:	49 8d 96 10 07 00 00 	lea    0x710(%r14),%rdx
  6fd9f8:	48 8d 7c 24 78       	lea    0x78(%rsp),%rdi
  6fd9fd:	e8 7e 7f 05 00       	call   755980 <<gpui::source::Sources<unit_action_cost_two::Model>>::validate>
  6fda02:	83 7c 24 78 ff       	cmpl   $0xffffffff,0x78(%rsp)
  6fda07:	74 1e                	je     6fda27 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::describe_with+0x57>
  6fda09:	48 8b 84 24 88 00 00 	mov    0x88(%rsp),%rax
  6fda10:	00 
  6fda11:	48 89 44 24 58       	mov    %rax,0x58(%rsp)
  6fda16:	0f 10 44 24 78       	movups 0x78(%rsp),%xmm0
  6fda1b:	0f 11 44 24 48       	movups %xmm0,0x48(%rsp)
  6fda20:	b8 20 00 00 00       	mov    $0x20,%eax
  6fda25:	eb 1e                	jmp    6fda45 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::describe_with+0x75>
  6fda27:	40 0f b6 d5          	movzbl %bpl,%edx
  6fda2b:	48 8d 7c 24 40       	lea    0x40(%rsp),%rdi
  6fda30:	4c 89 f6             	mov    %r14,%rsi
  6fda33:	4c 89 f9             	mov    %r15,%rcx
  6fda36:	e8 a5 34 02 00       	call   720ee0 <<gpui::runtime::Runtime<unit_action_cost_two::Model>>::describe_inner>
  6fda3b:	48 8b 44 24 40       	mov    0x40(%rsp),%rax
  6fda40:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  6fda45:	4c 8b 7c 24 48       	mov    0x48(%rsp),%r15
  6fda4a:	4c 8b 64 24 50       	mov    0x50(%rsp),%r12
  6fda4f:	0f 10 44 24 68       	movups 0x68(%rsp),%xmm0
  6fda54:	0f 11 44 24 30       	movups %xmm0,0x30(%rsp)
  6fda59:	48 8b 54 24 50       	mov    0x50(%rsp),%rdx
  6fda5e:	48 8b 74 24 58       	mov    0x58(%rsp),%rsi
  6fda63:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  6fda68:	4c 89 7c 24 10       	mov    %r15,0x10(%rsp)
  6fda6d:	48 89 54 24 18       	mov    %rdx,0x18(%rsp)
  6fda72:	48 89 74 24 20       	mov    %rsi,0x20(%rsp)
  6fda77:	48 89 4c 24 28       	mov    %rcx,0x28(%rsp)
  6fda7c:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  6fda80:	74 3d                	je     6fdabf <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::describe_with+0xef>
  6fda82:	48 83 f8 fd          	cmp    $0xfffffffffffffffd,%rax
  6fda86:	75 40                	jne    6fdac8 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::describe_with+0xf8>
  6fda88:	4c 89 f7             	mov    %r14,%rdi
  6fda8b:	e8 b0 b8 02 00       	call   729340 <<gpui::runtime::Runtime<unit_action_cost_two::Model>>::poison>
  6fda90:	48 c7 03 0f 00 00 00 	movq   $0xf,(%rbx)
  6fda97:	49 8b 04 24          	mov    (%r12),%rax
  6fda9b:	48 85 c0             	test   %rax,%rax
  6fda9e:	74 05                	je     6fdaa5 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::describe_with+0xd5>
  6fdaa0:	4c 89 ff             	mov    %r15,%rdi
  6fdaa3:	ff d0                	call   *%rax
  6fdaa5:	49 8b 74 24 08       	mov    0x8(%r12),%rsi
  6fdaaa:	48 85 f6             	test   %rsi,%rsi
  6fdaad:	74 4f                	je     6fdafe <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::describe_with+0x12e>
  6fdaaf:	49 8b 54 24 10       	mov    0x10(%r12),%rdx
  6fdab4:	4c 89 ff             	mov    %r15,%rdi
  6fdab7:	ff 15 8b b8 42 00    	call   *0x42b88b(%rip)        # b29348 <_DYNAMIC+0x248>
  6fdabd:	eb 3f                	jmp    6fdafe <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::describe_with+0x12e>
  6fdabf:	48 c7 03 fe ff ff ff 	movq   $0xfffffffffffffffe,(%rbx)
  6fdac6:	eb 36                	jmp    6fdafe <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::describe_with+0x12e>
  6fdac8:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
  6fdacd:	48 89 43 30          	mov    %rax,0x30(%rbx)
  6fdad1:	0f 10 44 24 08       	movups 0x8(%rsp),%xmm0
  6fdad6:	0f 10 4c 24 18       	movups 0x18(%rsp),%xmm1
  6fdadb:	0f 10 54 24 28       	movups 0x28(%rsp),%xmm2
  6fdae0:	0f 11 53 20          	movups %xmm2,0x20(%rbx)
  6fdae4:	0f 11 4b 10          	movups %xmm1,0x10(%rbx)
  6fdae8:	0f 11 03             	movups %xmm0,(%rbx)
  6fdaeb:	41 c6 86 1e 07 00 00 	movb   $0x0,0x71e(%r14)
  6fdaf2:	00 
  6fdaf3:	49 c7 86 e8 05 00 00 	movq   $0x0,0x5e8(%r14)
  6fdafa:	00 00 00 00 
  6fdafe:	48 81 c4 90 00 00 00 	add    $0x90,%rsp
  6fdb05:	5b                   	pop    %rbx
  6fdb06:	41 5c                	pop    %r12
  6fdb08:	41 5e                	pop    %r14
  6fdb0a:	41 5f                	pop    %r15
  6fdb0c:	5d                   	pop    %rbp
  6fdb0d:	c3                   	ret
  6fdb0e:	48 89 c3             	mov    %rax,%rbx
  6fdb11:	49 8b 74 24 08       	mov    0x8(%r12),%rsi
  6fdb16:	48 85 f6             	test   %rsi,%rsi
  6fdb19:	74 23                	je     6fdb3e <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::describe_with+0x16e>
  6fdb1b:	49 8b 54 24 10       	mov    0x10(%r12),%rdx
  6fdb20:	4c 89 ff             	mov    %r15,%rdi
  6fdb23:	ff 15 1f b8 42 00    	call   *0x42b81f(%rip)        # b29348 <_DYNAMIC+0x248>
  6fdb29:	48 89 df             	mov    %rbx,%rdi
  6fdb2c:	e8 af b9 3f 00       	call   af94e0 <_Unwind_Resume@plt>
  6fdb31:	48 89 c3             	mov    %rax,%rbx
  6fdb34:	48 8d 7c 24 08       	lea    0x8(%rsp),%rdi
  6fdb39:	e8 c2 72 ff ff       	call   6f4e00 <core::ptr::drop_glue::<core::result::Result<core::result::Result<gpui::runtime::paint::PatchOutcome, gpui::runtime::Error>, alloc::boxed::Box<dyn core::any::Any + core::marker::Send>>>>
  6fdb3e:	48 89 df             	mov    %rbx,%rdi
  6fdb41:	e8 9a b9 3f 00       	call   af94e0 <_Unwind_Resume@plt>
  6fdb46:	ff 15 2c b8 42 00    	call   *0x42b82c(%rip)        # b29378 <_DYNAMIC+0x278>
  6fdb4c:	48 89 c7             	mov    %rax,%rdi
  6fdb4f:	ff 15 13 b9 42 00    	call   *0x42b913(%rip)        # b29468 <_DYNAMIC+0x368>
  6fdb55:	49 89 c7             	mov    %rax,%r15
  6fdb58:	49 89 d4             	mov    %rdx,%r12
  6fdb5b:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  6fdb60:	48 89 54 24 18       	mov    %rdx,0x18(%rsp)
  6fdb65:	48 c7 44 24 08 fd ff 	movq   $0xfffffffffffffffd,0x8(%rsp)
  6fdb6c:	ff ff 
  6fdb6e:	e9 15 ff ff ff       	jmp    6fda88 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::describe_with+0xb8>
  6fdb73:	ff 15 f7 b8 42 00    	call   *0x42b8f7(%rip)        # b29470 <_DYNAMIC+0x370>
