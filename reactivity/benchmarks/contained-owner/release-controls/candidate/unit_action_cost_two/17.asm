
/tmp/gpui-contained-owner-spike-target/release/deps/unit_action_cost_two-c899ee77dd9a9ab3:     file format elf64-x86-64


Disassembly of section .text:

00000000006fda10 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::describe_with>:
  6fda10:	55                   	push   %rbp
  6fda11:	41 57                	push   %r15
  6fda13:	41 56                	push   %r14
  6fda15:	41 54                	push   %r12
  6fda17:	53                   	push   %rbx
  6fda18:	48 81 ec 90 00 00 00 	sub    $0x90,%rsp
  6fda1f:	89 cd                	mov    %ecx,%ebp
  6fda21:	49 89 d7             	mov    %rdx,%r15
  6fda24:	49 89 f6             	mov    %rsi,%r14
  6fda27:	48 89 fb             	mov    %rdi,%rbx
  6fda2a:	48 81 c6 28 02 00 00 	add    $0x228,%rsi
  6fda31:	49 8d 96 10 07 00 00 	lea    0x710(%r14),%rdx
  6fda38:	48 8d 7c 24 78       	lea    0x78(%rsp),%rdi
  6fda3d:	e8 ae 7f 05 00       	call   7559f0 <<gpui::source::Sources<unit_action_cost_two::Model>>::validate>
  6fda42:	83 7c 24 78 ff       	cmpl   $0xffffffff,0x78(%rsp)
  6fda47:	74 1e                	je     6fda67 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::describe_with+0x57>
  6fda49:	48 8b 84 24 88 00 00 	mov    0x88(%rsp),%rax
  6fda50:	00 
  6fda51:	48 89 44 24 58       	mov    %rax,0x58(%rsp)
  6fda56:	0f 10 44 24 78       	movups 0x78(%rsp),%xmm0
  6fda5b:	0f 11 44 24 48       	movups %xmm0,0x48(%rsp)
  6fda60:	b8 20 00 00 00       	mov    $0x20,%eax
  6fda65:	eb 1e                	jmp    6fda85 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::describe_with+0x75>
  6fda67:	40 0f b6 d5          	movzbl %bpl,%edx
  6fda6b:	48 8d 7c 24 40       	lea    0x40(%rsp),%rdi
  6fda70:	4c 89 f6             	mov    %r14,%rsi
  6fda73:	4c 89 f9             	mov    %r15,%rcx
  6fda76:	e8 d5 34 02 00       	call   720f50 <<gpui::runtime::Runtime<unit_action_cost_two::Model>>::describe_inner>
  6fda7b:	48 8b 44 24 40       	mov    0x40(%rsp),%rax
  6fda80:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  6fda85:	4c 8b 7c 24 48       	mov    0x48(%rsp),%r15
  6fda8a:	4c 8b 64 24 50       	mov    0x50(%rsp),%r12
  6fda8f:	0f 10 44 24 68       	movups 0x68(%rsp),%xmm0
  6fda94:	0f 11 44 24 30       	movups %xmm0,0x30(%rsp)
  6fda99:	48 8b 54 24 50       	mov    0x50(%rsp),%rdx
  6fda9e:	48 8b 74 24 58       	mov    0x58(%rsp),%rsi
  6fdaa3:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  6fdaa8:	4c 89 7c 24 10       	mov    %r15,0x10(%rsp)
  6fdaad:	48 89 54 24 18       	mov    %rdx,0x18(%rsp)
  6fdab2:	48 89 74 24 20       	mov    %rsi,0x20(%rsp)
  6fdab7:	48 89 4c 24 28       	mov    %rcx,0x28(%rsp)
  6fdabc:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  6fdac0:	74 3d                	je     6fdaff <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::describe_with+0xef>
  6fdac2:	48 83 f8 fd          	cmp    $0xfffffffffffffffd,%rax
  6fdac6:	75 40                	jne    6fdb08 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::describe_with+0xf8>
  6fdac8:	4c 89 f7             	mov    %r14,%rdi
  6fdacb:	e8 e0 b8 02 00       	call   7293b0 <<gpui::runtime::Runtime<unit_action_cost_two::Model>>::poison>
  6fdad0:	48 c7 03 0f 00 00 00 	movq   $0xf,(%rbx)
  6fdad7:	49 8b 04 24          	mov    (%r12),%rax
  6fdadb:	48 85 c0             	test   %rax,%rax
  6fdade:	74 05                	je     6fdae5 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::describe_with+0xd5>
  6fdae0:	4c 89 ff             	mov    %r15,%rdi
  6fdae3:	ff d0                	call   *%rax
  6fdae5:	49 8b 74 24 08       	mov    0x8(%r12),%rsi
  6fdaea:	48 85 f6             	test   %rsi,%rsi
  6fdaed:	74 4f                	je     6fdb3e <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::describe_with+0x12e>
  6fdaef:	49 8b 54 24 10       	mov    0x10(%r12),%rdx
  6fdaf4:	4c 89 ff             	mov    %r15,%rdi
  6fdaf7:	ff 15 bb b8 42 00    	call   *0x42b8bb(%rip)        # b293b8 <_DYNAMIC+0x248>
  6fdafd:	eb 3f                	jmp    6fdb3e <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::describe_with+0x12e>
  6fdaff:	48 c7 03 fe ff ff ff 	movq   $0xfffffffffffffffe,(%rbx)
  6fdb06:	eb 36                	jmp    6fdb3e <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::describe_with+0x12e>
  6fdb08:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
  6fdb0d:	48 89 43 30          	mov    %rax,0x30(%rbx)
  6fdb11:	0f 10 44 24 08       	movups 0x8(%rsp),%xmm0
  6fdb16:	0f 10 4c 24 18       	movups 0x18(%rsp),%xmm1
  6fdb1b:	0f 10 54 24 28       	movups 0x28(%rsp),%xmm2
  6fdb20:	0f 11 53 20          	movups %xmm2,0x20(%rbx)
  6fdb24:	0f 11 4b 10          	movups %xmm1,0x10(%rbx)
  6fdb28:	0f 11 03             	movups %xmm0,(%rbx)
  6fdb2b:	41 c6 86 1e 07 00 00 	movb   $0x0,0x71e(%r14)
  6fdb32:	00 
  6fdb33:	49 c7 86 e8 05 00 00 	movq   $0x0,0x5e8(%r14)
  6fdb3a:	00 00 00 00 
  6fdb3e:	48 81 c4 90 00 00 00 	add    $0x90,%rsp
  6fdb45:	5b                   	pop    %rbx
  6fdb46:	41 5c                	pop    %r12
  6fdb48:	41 5e                	pop    %r14
  6fdb4a:	41 5f                	pop    %r15
  6fdb4c:	5d                   	pop    %rbp
  6fdb4d:	c3                   	ret
  6fdb4e:	48 89 c3             	mov    %rax,%rbx
  6fdb51:	49 8b 74 24 08       	mov    0x8(%r12),%rsi
  6fdb56:	48 85 f6             	test   %rsi,%rsi
  6fdb59:	74 23                	je     6fdb7e <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::describe_with+0x16e>
  6fdb5b:	49 8b 54 24 10       	mov    0x10(%r12),%rdx
  6fdb60:	4c 89 ff             	mov    %r15,%rdi
  6fdb63:	ff 15 4f b8 42 00    	call   *0x42b84f(%rip)        # b293b8 <_DYNAMIC+0x248>
  6fdb69:	48 89 df             	mov    %rbx,%rdi
  6fdb6c:	e8 df b9 3f 00       	call   af9550 <_Unwind_Resume@plt>
  6fdb71:	48 89 c3             	mov    %rax,%rbx
  6fdb74:	48 8d 7c 24 08       	lea    0x8(%rsp),%rdi
  6fdb79:	e8 92 72 ff ff       	call   6f4e10 <core::ptr::drop_glue::<core::result::Result<core::result::Result<gpui::runtime::paint::PatchOutcome, gpui::runtime::Error>, alloc::boxed::Box<dyn core::any::Any + core::marker::Send>>>>
  6fdb7e:	48 89 df             	mov    %rbx,%rdi
  6fdb81:	e8 ca b9 3f 00       	call   af9550 <_Unwind_Resume@plt>
  6fdb86:	ff 15 5c b8 42 00    	call   *0x42b85c(%rip)        # b293e8 <_DYNAMIC+0x278>
  6fdb8c:	48 89 c7             	mov    %rax,%rdi
  6fdb8f:	ff 15 43 b9 42 00    	call   *0x42b943(%rip)        # b294d8 <_DYNAMIC+0x368>
  6fdb95:	49 89 c7             	mov    %rax,%r15
  6fdb98:	49 89 d4             	mov    %rdx,%r12
  6fdb9b:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  6fdba0:	48 89 54 24 18       	mov    %rdx,0x18(%rsp)
  6fdba5:	48 c7 44 24 08 fd ff 	movq   $0xfffffffffffffffd,0x8(%rsp)
  6fdbac:	ff ff 
  6fdbae:	e9 15 ff ff ff       	jmp    6fdac8 <<gpui::runtime::RuntimeMut<unit_action_cost_two::Model, ()>>::describe_with+0xb8>
  6fdbb3:	ff 15 27 b9 42 00    	call   *0x42b927(%rip)        # b294e0 <_DYNAMIC+0x370>
