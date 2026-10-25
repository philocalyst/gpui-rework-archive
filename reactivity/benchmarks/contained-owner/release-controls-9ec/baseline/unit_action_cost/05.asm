
/tmp/gpui-contained-owner-unit-baseline-target/release/deps/unit_action_cost-bcf457ce7db1ee75:     file format elf64-x86-64


Disassembly of section .text:

0000000000706d90 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::describe_with>:
  706d90:	55                   	push   %rbp
  706d91:	41 57                	push   %r15
  706d93:	41 56                	push   %r14
  706d95:	41 54                	push   %r12
  706d97:	53                   	push   %rbx
  706d98:	48 81 ec 90 00 00 00 	sub    $0x90,%rsp
  706d9f:	89 cd                	mov    %ecx,%ebp
  706da1:	49 89 d7             	mov    %rdx,%r15
  706da4:	49 89 f6             	mov    %rsi,%r14
  706da7:	48 89 fb             	mov    %rdi,%rbx
  706daa:	48 81 c6 28 02 00 00 	add    $0x228,%rsi
  706db1:	49 8d 96 10 07 00 00 	lea    0x710(%r14),%rdx
  706db8:	48 8d 7c 24 78       	lea    0x78(%rsp),%rdi
  706dbd:	e8 ae b6 03 00       	call   742470 <<gpui::source::Sources<unit_action_cost::Model>>::validate>
  706dc2:	83 7c 24 78 ff       	cmpl   $0xffffffff,0x78(%rsp)
  706dc7:	74 1e                	je     706de7 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::describe_with+0x57>
  706dc9:	48 8b 84 24 88 00 00 	mov    0x88(%rsp),%rax
  706dd0:	00 
  706dd1:	48 89 44 24 58       	mov    %rax,0x58(%rsp)
  706dd6:	0f 10 44 24 78       	movups 0x78(%rsp),%xmm0
  706ddb:	0f 11 44 24 48       	movups %xmm0,0x48(%rsp)
  706de0:	b8 20 00 00 00       	mov    $0x20,%eax
  706de5:	eb 1e                	jmp    706e05 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::describe_with+0x75>
  706de7:	40 0f b6 d5          	movzbl %bpl,%edx
  706deb:	48 8d 7c 24 40       	lea    0x40(%rsp),%rdi
  706df0:	4c 89 f6             	mov    %r14,%rsi
  706df3:	4c 89 f9             	mov    %r15,%rcx
  706df6:	e8 b5 e6 00 00       	call   7154b0 <<gpui::runtime::Runtime<unit_action_cost::Model>>::describe_inner>
  706dfb:	48 8b 44 24 40       	mov    0x40(%rsp),%rax
  706e00:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  706e05:	4c 8b 7c 24 48       	mov    0x48(%rsp),%r15
  706e0a:	4c 8b 64 24 50       	mov    0x50(%rsp),%r12
  706e0f:	0f 10 44 24 68       	movups 0x68(%rsp),%xmm0
  706e14:	0f 11 44 24 30       	movups %xmm0,0x30(%rsp)
  706e19:	48 8b 54 24 50       	mov    0x50(%rsp),%rdx
  706e1e:	48 8b 74 24 58       	mov    0x58(%rsp),%rsi
  706e23:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  706e28:	4c 89 7c 24 10       	mov    %r15,0x10(%rsp)
  706e2d:	48 89 54 24 18       	mov    %rdx,0x18(%rsp)
  706e32:	48 89 74 24 20       	mov    %rsi,0x20(%rsp)
  706e37:	48 89 4c 24 28       	mov    %rcx,0x28(%rsp)
  706e3c:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  706e40:	74 3d                	je     706e7f <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::describe_with+0xef>
  706e42:	48 83 f8 fd          	cmp    $0xfffffffffffffffd,%rax
  706e46:	75 40                	jne    706e88 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::describe_with+0xf8>
  706e48:	4c 89 f7             	mov    %r14,%rdi
  706e4b:	e8 c0 6a 01 00       	call   71d910 <<gpui::runtime::Runtime<unit_action_cost::Model>>::poison>
  706e50:	48 c7 03 0f 00 00 00 	movq   $0xf,(%rbx)
  706e57:	49 8b 04 24          	mov    (%r12),%rax
  706e5b:	48 85 c0             	test   %rax,%rax
  706e5e:	74 05                	je     706e65 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::describe_with+0xd5>
  706e60:	4c 89 ff             	mov    %r15,%rdi
  706e63:	ff d0                	call   *%rax
  706e65:	49 8b 74 24 08       	mov    0x8(%r12),%rsi
  706e6a:	48 85 f6             	test   %rsi,%rsi
  706e6d:	74 4f                	je     706ebe <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::describe_with+0x12e>
  706e6f:	49 8b 54 24 10       	mov    0x10(%r12),%rdx
  706e74:	4c 89 ff             	mov    %r15,%rdi
  706e77:	ff 15 bb a4 3f 00    	call   *0x3fa4bb(%rip)        # b01338 <_DYNAMIC+0x248>
  706e7d:	eb 3f                	jmp    706ebe <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::describe_with+0x12e>
  706e7f:	48 c7 03 fe ff ff ff 	movq   $0xfffffffffffffffe,(%rbx)
  706e86:	eb 36                	jmp    706ebe <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::describe_with+0x12e>
  706e88:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
  706e8d:	48 89 43 30          	mov    %rax,0x30(%rbx)
  706e91:	0f 10 44 24 08       	movups 0x8(%rsp),%xmm0
  706e96:	0f 10 4c 24 18       	movups 0x18(%rsp),%xmm1
  706e9b:	0f 10 54 24 28       	movups 0x28(%rsp),%xmm2
  706ea0:	0f 11 53 20          	movups %xmm2,0x20(%rbx)
  706ea4:	0f 11 4b 10          	movups %xmm1,0x10(%rbx)
  706ea8:	0f 11 03             	movups %xmm0,(%rbx)
  706eab:	41 c6 86 1e 07 00 00 	movb   $0x0,0x71e(%r14)
  706eb2:	00 
  706eb3:	49 c7 86 e8 05 00 00 	movq   $0x0,0x5e8(%r14)
  706eba:	00 00 00 00 
  706ebe:	48 81 c4 90 00 00 00 	add    $0x90,%rsp
  706ec5:	5b                   	pop    %rbx
  706ec6:	41 5c                	pop    %r12
  706ec8:	41 5e                	pop    %r14
  706eca:	41 5f                	pop    %r15
  706ecc:	5d                   	pop    %rbp
  706ecd:	c3                   	ret
  706ece:	48 89 c3             	mov    %rax,%rbx
  706ed1:	49 8b 74 24 08       	mov    0x8(%r12),%rsi
  706ed6:	48 85 f6             	test   %rsi,%rsi
  706ed9:	74 23                	je     706efe <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::describe_with+0x16e>
  706edb:	49 8b 54 24 10       	mov    0x10(%r12),%rdx
  706ee0:	4c 89 ff             	mov    %r15,%rdi
  706ee3:	ff 15 4f a4 3f 00    	call   *0x3fa44f(%rip)        # b01338 <_DYNAMIC+0x248>
  706ee9:	48 89 df             	mov    %rbx,%rdi
  706eec:	e8 ef a8 3c 00       	call   ad17e0 <_Unwind_Resume@plt>
  706ef1:	48 89 c3             	mov    %rax,%rbx
  706ef4:	48 8d 7c 24 08       	lea    0x8(%rsp),%rdi
  706ef9:	e8 d2 a9 ff ff       	call   7018d0 <core::ptr::drop_glue::<core::result::Result<core::result::Result<gpui::runtime::paint::PatchOutcome, gpui::runtime::Error>, alloc::boxed::Box<dyn core::any::Any + core::marker::Send>>>>
  706efe:	48 89 df             	mov    %rbx,%rdi
  706f01:	e8 da a8 3c 00       	call   ad17e0 <_Unwind_Resume@plt>
  706f06:	ff 15 7c a4 3f 00    	call   *0x3fa47c(%rip)        # b01388 <_DYNAMIC+0x298>
  706f0c:	48 89 c7             	mov    %rax,%rdi
  706f0f:	ff 15 63 a5 3f 00    	call   *0x3fa563(%rip)        # b01478 <_DYNAMIC+0x388>
  706f15:	49 89 c7             	mov    %rax,%r15
  706f18:	49 89 d4             	mov    %rdx,%r12
  706f1b:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  706f20:	48 89 54 24 18       	mov    %rdx,0x18(%rsp)
  706f25:	48 c7 44 24 08 fd ff 	movq   $0xfffffffffffffffd,0x8(%rsp)
  706f2c:	ff ff 
  706f2e:	e9 15 ff ff ff       	jmp    706e48 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::describe_with+0xb8>
  706f33:	ff 15 47 a5 3f 00    	call   *0x3fa547(%rip)        # b01480 <_DYNAMIC+0x390>
