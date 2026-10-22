
/tmp/gpui-contained-property-exchange-target/release/deps/unit_action_cost-bcf457ce7db1ee75:     file format elf64-x86-64


Disassembly of section .text:

0000000000707cb0 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_with_editing>:
  707cb0:	55                   	push   %rbp
  707cb1:	41 57                	push   %r15
  707cb3:	41 56                	push   %r14
  707cb5:	41 55                	push   %r13
  707cb7:	41 54                	push   %r12
  707cb9:	53                   	push   %rbx
  707cba:	48 83 ec 78          	sub    $0x78,%rsp
  707cbe:	48 89 fb             	mov    %rdi,%rbx
  707cc1:	80 be 22 07 00 00 01 	cmpb   $0x1,0x722(%rsi)
  707cc8:	75 0c                	jne    707cd6 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_with_editing+0x26>
  707cca:	48 c7 03 0e 00 00 00 	movq   $0xe,(%rbx)
  707cd1:	e9 c4 00 00 00       	jmp    707d9a <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_with_editing+0xea>
  707cd6:	48 3b 8e b0 05 00 00 	cmp    0x5b0(%rsi),%rcx
  707cdd:	0f 85 90 00 00 00    	jne    707d73 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_with_editing+0xc3>
  707ce3:	4d 89 cc             	mov    %r9,%r12
  707ce6:	49 89 d5             	mov    %rdx,%r13
  707ce9:	48 8d 7c 24 30       	lea    0x30(%rsp),%rdi
  707cee:	49 89 f6             	mov    %rsi,%r14
  707cf1:	4c 89 c2             	mov    %r8,%rdx
  707cf4:	e8 17 60 01 00       	call   71dd10 <<gpui::runtime::Runtime<unit_action_cost::Model>>::resolve_identity>
  707cf9:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
  707cfe:	4c 8b 7c 24 38       	mov    0x38(%rsp),%r15
  707d03:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  707d07:	75 6f                	jne    707d78 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_with_editing+0xc8>
  707d09:	49 8b b6 a0 02 00 00 	mov    0x2a0(%r14),%rsi
  707d10:	49 39 f7             	cmp    %rsi,%r15
  707d13:	0f 83 7d 02 00 00    	jae    707f96 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_with_editing+0x2e6>
  707d19:	4c 89 f0             	mov    %r14,%rax
  707d1c:	49 8b 8e 98 02 00 00 	mov    0x298(%r14),%rcx
  707d23:	4b 8d 14 bf          	lea    (%r15,%r15,4),%rdx
  707d27:	8b 74 d1 20          	mov    0x20(%rcx,%rdx,8),%esi
  707d2b:	83 e6 07             	and    $0x7,%esi
  707d2e:	83 fe 02             	cmp    $0x2,%esi
  707d31:	75 76                	jne    707da9 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_with_editing+0xf9>
  707d33:	48 c7 80 08 07 00 00 	movq   $0x0,0x708(%rax)
  707d3a:	00 00 00 00 
  707d3e:	0f 10 80 60 06 00 00 	movups 0x660(%rax),%xmm0
  707d45:	0f b6 88 20 07 00 00 	movzbl 0x720(%rax),%ecx
  707d4c:	48 83 b8 80 06 00 00 	cmpq   $0x0,0x680(%rax)
  707d53:	00 
  707d54:	74 16                	je     707d6c <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_with_editing+0xbc>
  707d56:	84 c9                	test   %cl,%cl
  707d58:	0f 84 06 01 00 00    	je     707e64 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_with_editing+0x1b4>
  707d5e:	48 83 b8 88 05 00 00 	cmpq   $0xffffffffffffffff,0x588(%rax)
  707d65:	ff 
  707d66:	0f 85 f8 00 00 00    	jne    707e64 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_with_editing+0x1b4>
  707d6c:	31 c0                	xor    %eax,%eax
  707d6e:	e9 fd 00 00 00       	jmp    707e70 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_with_editing+0x1c0>
  707d73:	b8 11 00 00 00       	mov    $0x11,%eax
  707d78:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  707d7d:	48 89 4b 30          	mov    %rcx,0x30(%rbx)
  707d81:	0f 10 44 24 40       	movups 0x40(%rsp),%xmm0
  707d86:	0f 10 4c 24 50       	movups 0x50(%rsp),%xmm1
  707d8b:	0f 11 4b 20          	movups %xmm1,0x20(%rbx)
  707d8f:	0f 11 43 10          	movups %xmm0,0x10(%rbx)
  707d93:	48 89 03             	mov    %rax,(%rbx)
  707d96:	4c 89 7b 08          	mov    %r15,0x8(%rbx)
  707d9a:	48 83 c4 78          	add    $0x78,%rsp
  707d9e:	5b                   	pop    %rbx
  707d9f:	41 5c                	pop    %r12
  707da1:	41 5d                	pop    %r13
  707da3:	41 5e                	pop    %r14
  707da5:	41 5f                	pop    %r15
  707da7:	5d                   	pop    %rbp
  707da8:	c3                   	ret
  707da9:	48 8d 2c d1          	lea    (%rcx,%rdx,8),%rbp
  707dad:	48 83 7d 08 00       	cmpq   $0x0,0x8(%rbp)
  707db2:	0f 84 a0 00 00 00    	je     707e58 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_with_editing+0x1a8>
  707db8:	48 83 c5 08          	add    $0x8,%rbp
  707dbc:	48 8d 90 10 07 00 00 	lea    0x710(%rax),%rdx
  707dc3:	4c 8d 80 28 02 00 00 	lea    0x228(%rax),%r8
  707dca:	48 8d 0d e7 bb 3c 00 	lea    0x3cbbe7(%rip),%rcx        # ad39b8 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0x1d0>
  707dd1:	4c 8d 0d 00 bc 3c 00 	lea    0x3cbc00(%rip),%r9        # ad39d8 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0x1f0>
  707dd8:	48 8d 7c 24 30       	lea    0x30(%rsp),%rdi
  707ddd:	48 89 ee             	mov    %rbp,%rsi
  707de0:	48 89 54 24 70       	mov    %rdx,0x70(%rsp)
  707de5:	ff 15 05 a3 3f 00    	call   *0x3fa305(%rip)        # b020f0 <_DYNAMIC+0x3a8>
  707deb:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
  707df0:	48 8b 54 24 38       	mov    0x38(%rsp),%rdx
  707df5:	48 8b 4c 24 40       	mov    0x40(%rsp),%rcx
  707dfa:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  707dff:	48 89 14 24          	mov    %rdx,(%rsp)
  707e03:	48 89 54 24 18       	mov    %rdx,0x18(%rsp)
  707e08:	48 89 4c 24 08       	mov    %rcx,0x8(%rsp)
  707e0d:	48 89 4c 24 20       	mov    %rcx,0x20(%rsp)
  707e12:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  707e16:	0f 84 0a 02 00 00    	je     708026 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_with_editing+0x376>
  707e1c:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  707e20:	75 71                	jne    707e93 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_with_editing+0x1e3>
  707e22:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  707e27:	e8 94 9d ff ff       	call   701bc0 <core::ptr::drop_glue::<core::result::Result<core::result::Result<gpui::element::Admission, gpui::source::BindError>, alloc::boxed::Box<dyn core::any::Any + core::marker::Send>>>>
  707e2c:	48 8b 0c 24          	mov    (%rsp),%rcx
  707e30:	66 85 c9             	test   %cx,%cx
  707e33:	74 7f                	je     707eb4 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_with_editing+0x204>
  707e35:	0f b7 c1             	movzwl %cx,%eax
  707e38:	83 f8 01             	cmp    $0x1,%eax
  707e3b:	0f 85 17 01 00 00    	jne    707f58 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_with_editing+0x2a8>
  707e41:	48 c1 e9 10          	shr    $0x10,%rcx
  707e45:	48 89 df             	mov    %rbx,%rdi
  707e48:	4c 89 f6             	mov    %r14,%rsi
  707e4b:	4c 89 ea             	mov    %r13,%rdx
  707e4e:	e8 1d 65 00 00       	call   70e370 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::window_action>
  707e53:	e9 42 ff ff ff       	jmp    707d9a <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_with_editing+0xea>
  707e58:	48 c7 03 16 00 00 00 	movq   $0x16,(%rbx)
  707e5f:	e9 36 ff ff ff       	jmp    707d9a <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_with_editing+0xea>
  707e64:	48 8b 90 90 06 00 00 	mov    0x690(%rax),%rdx
  707e6b:	b8 01 00 00 00       	mov    $0x1,%eax
  707e70:	48 89 43 08          	mov    %rax,0x8(%rbx)
  707e74:	48 89 53 10          	mov    %rdx,0x10(%rbx)
  707e78:	0f 11 43 18          	movups %xmm0,0x18(%rbx)
  707e7c:	48 c7 43 28 00 00 00 	movq   $0x0,0x28(%rbx)
  707e83:	00 
  707e84:	88 4b 30             	mov    %cl,0x30(%rbx)
  707e87:	48 c7 03 fe ff ff ff 	movq   $0xfffffffffffffffe,(%rbx)
  707e8e:	e9 07 ff ff ff       	jmp    707d9a <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_with_editing+0xea>
  707e93:	48 c7 03 20 00 00 00 	movq   $0x20,(%rbx)
  707e9a:	48 89 43 08          	mov    %rax,0x8(%rbx)
  707e9e:	48 8b 04 24          	mov    (%rsp),%rax
  707ea2:	48 89 43 10          	mov    %rax,0x10(%rbx)
  707ea6:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  707eab:	48 89 43 18          	mov    %rax,0x18(%rbx)
  707eaf:	e9 e6 fe ff ff       	jmp    707d9a <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_with_editing+0xea>
  707eb4:	4d 8b be 60 06 00 00 	mov    0x660(%r14),%r15
  707ebb:	49 ff c7             	inc    %r15
  707ebe:	0f 84 c6 00 00 00    	je     707f8a <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_with_editing+0x2da>
  707ec4:	48 c7 44 24 30 1f 00 	movq   $0x1f,0x30(%rsp)
  707ecb:	00 00 
  707ecd:	48 8d 7c 24 30       	lea    0x30(%rsp),%rdi
  707ed2:	e8 f9 c7 ff ff       	call   7046d0 <core::ptr::drop_glue::<gpui::runtime::Error>>
  707ed7:	48 8d 0d da ba 3c 00 	lea    0x3cbada(%rip),%rcx        # ad39b8 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0x1d0>
  707ede:	48 8d 7c 24 30       	lea    0x30(%rsp),%rdi
  707ee3:	48 89 ee             	mov    %rbp,%rsi
  707ee6:	48 8b 54 24 70       	mov    0x70(%rsp),%rdx
  707eeb:	ff 15 07 a2 3f 00    	call   *0x3fa207(%rip)        # b020f8 <_DYNAMIC+0x3b0>
  707ef1:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
  707ef6:	48 8b 4c 24 40       	mov    0x40(%rsp),%rcx
  707efb:	0f 28 44 24 30       	movaps 0x30(%rsp),%xmm0
  707f00:	0f 29 44 24 10       	movaps %xmm0,0x10(%rsp)
  707f05:	48 89 4c 24 20       	mov    %rcx,0x20(%rsp)
  707f0a:	48 83 f8 fe          	cmp    $0xfffffffffffffffe,%rax
  707f0e:	0f 84 ae 00 00 00    	je     707fc2 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_with_editing+0x312>
  707f14:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  707f18:	75 57                	jne    707f71 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_with_editing+0x2c1>
  707f1a:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  707f1f:	e8 9c 9c ff ff       	call   701bc0 <core::ptr::drop_glue::<core::result::Result<core::result::Result<gpui::element::Admission, gpui::source::BindError>, alloc::boxed::Box<dyn core::any::Any + core::marker::Send>>>>
  707f24:	4d 89 be 60 06 00 00 	mov    %r15,0x660(%r14)
  707f2b:	49 ff 86 b0 06 00 00 	incq   0x6b0(%r14)
  707f32:	49 c7 86 08 07 00 00 	movq   $0x0,0x708(%r14)
  707f39:	00 00 00 00 
  707f3d:	48 89 df             	mov    %rbx,%rdi
  707f40:	4c 89 f6             	mov    %r14,%rsi
  707f43:	4c 89 ea             	mov    %r13,%rdx
  707f46:	48 8b 4c 24 08       	mov    0x8(%rsp),%rcx
  707f4b:	4d 89 e0             	mov    %r12,%r8
  707f4e:	e8 5d 01 00 00       	call   7080b0 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::after_source_with_editing>
  707f53:	e9 42 fe ff ff       	jmp    707d9a <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_with_editing+0xea>
  707f58:	48 89 df             	mov    %rbx,%rdi
  707f5b:	4c 89 f6             	mov    %r14,%rsi
  707f5e:	4c 89 ea             	mov    %r13,%rdx
  707f61:	4c 89 f9             	mov    %r15,%rcx
  707f64:	4d 89 e0             	mov    %r12,%r8
  707f67:	e8 44 f6 ff ff       	call   7075b0 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_property>
  707f6c:	e9 29 fe ff ff       	jmp    707d9a <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_with_editing+0xea>
  707f71:	0f 10 44 24 18       	movups 0x18(%rsp),%xmm0
  707f76:	0f 11 43 10          	movups %xmm0,0x10(%rbx)
  707f7a:	48 c7 03 20 00 00 00 	movq   $0x20,(%rbx)
  707f81:	48 89 43 08          	mov    %rax,0x8(%rbx)
  707f85:	e9 10 fe ff ff       	jmp    707d9a <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_with_editing+0xea>
  707f8a:	48 c7 03 1f 00 00 00 	movq   $0x1f,(%rbx)
  707f91:	e9 04 fe ff ff       	jmp    707d9a <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_with_editing+0xea>
  707f96:	48 8d 15 13 be 3c 00 	lea    0x3cbe13(%rip),%rdx        # ad3db0 <anon.7419d443038b38ead8e05c5c7cad633c.10.llvm.406672830778731742+0x5c8>
  707f9d:	4c 89 ff             	mov    %r15,%rdi
  707fa0:	ff 15 1a a1 3f 00    	call   *0x3fa11a(%rip)        # b020c0 <_DYNAMIC+0x378>
  707fa6:	48 89 c7             	mov    %rax,%rdi
  707fa9:	ff 15 21 a1 3f 00    	call   *0x3fa121(%rip)        # b020d0 <_DYNAMIC+0x388>
  707faf:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
  707fb4:	48 89 54 24 20       	mov    %rdx,0x20(%rsp)
  707fb9:	48 c7 44 24 10 fe ff 	movq   $0xfffffffffffffffe,0x10(%rsp)
  707fc0:	ff ff 
  707fc2:	4c 89 f7             	mov    %r14,%rdi
  707fc5:	e8 d6 63 01 00       	call   71e3a0 <<gpui::runtime::Runtime<unit_action_cost::Model>>::poison>
  707fca:	48 c7 03 0f 00 00 00 	movq   $0xf,(%rbx)
  707fd1:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  707fd6:	e8 e5 9b ff ff       	call   701bc0 <core::ptr::drop_glue::<core::result::Result<core::result::Result<gpui::element::Admission, gpui::source::BindError>, alloc::boxed::Box<dyn core::any::Any + core::marker::Send>>>>
  707fdb:	e9 ba fd ff ff       	jmp    707d9a <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_with_editing+0xea>
  707fe0:	ff 15 f2 a0 3f 00    	call   *0x3fa0f2(%rip)        # b020d8 <_DYNAMIC+0x390>
  707fe6:	48 89 c3             	mov    %rax,%rbx
  707fe9:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  707fee:	e8 cd 9b ff ff       	call   701bc0 <core::ptr::drop_glue::<core::result::Result<core::result::Result<gpui::element::Admission, gpui::source::BindError>, alloc::boxed::Box<dyn core::any::Any + core::marker::Send>>>>
  707ff3:	e9 aa 00 00 00       	jmp    7080a2 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_with_editing+0x3f2>
  707ff8:	48 89 c7             	mov    %rax,%rdi
  707ffb:	ff 15 cf a0 3f 00    	call   *0x3fa0cf(%rip)        # b020d0 <_DYNAMIC+0x388>
  708001:	48 89 04 24          	mov    %rax,(%rsp)
  708005:	48 89 54 24 08       	mov    %rdx,0x8(%rsp)
  70800a:	48 8b 04 24          	mov    (%rsp),%rax
  70800e:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
  708013:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  708018:	48 89 44 24 20       	mov    %rax,0x20(%rsp)
  70801d:	48 c7 44 24 10 fe ff 	movq   $0xfffffffffffffffe,0x10(%rsp)
  708024:	ff ff 
  708026:	4c 89 f7             	mov    %r14,%rdi
  708029:	e8 72 63 01 00       	call   71e3a0 <<gpui::runtime::Runtime<unit_action_cost::Model>>::poison>
  70802e:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  708033:	48 c7 03 0f 00 00 00 	movq   $0xf,(%rbx)
  70803a:	49 8b 06             	mov    (%r14),%rax
  70803d:	48 85 c0             	test   %rax,%rax
  708040:	74 06                	je     708048 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_with_editing+0x398>
  708042:	48 8b 3c 24          	mov    (%rsp),%rdi
  708046:	ff d0                	call   *%rax
  708048:	49 8b 76 08          	mov    0x8(%r14),%rsi
  70804c:	48 85 f6             	test   %rsi,%rsi
  70804f:	0f 84 45 fd ff ff    	je     707d9a <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_with_editing+0xea>
  708055:	49 8b 56 10          	mov    0x10(%r14),%rdx
  708059:	48 8b 3c 24          	mov    (%rsp),%rdi
  70805d:	ff 15 2d 9f 3f 00    	call   *0x3f9f2d(%rip)        # b01f90 <_DYNAMIC+0x248>
  708063:	e9 32 fd ff ff       	jmp    707d9a <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_with_editing+0xea>
  708068:	ff 15 6a a0 3f 00    	call   *0x3fa06a(%rip)        # b020d8 <_DYNAMIC+0x390>
  70806e:	48 89 c3             	mov    %rax,%rbx
  708071:	49 8b 76 08          	mov    0x8(%r14),%rsi
  708075:	48 85 f6             	test   %rsi,%rsi
  708078:	74 28                	je     7080a2 <<gpui::runtime::RuntimeMut<unit_action_cost::Model, ()>>::activate_with_editing+0x3f2>
  70807a:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  70807f:	48 8b 50 10          	mov    0x10(%rax),%rdx
  708083:	48 8b 3c 24          	mov    (%rsp),%rdi
  708087:	ff 15 03 9f 3f 00    	call   *0x3f9f03(%rip)        # b01f90 <_DYNAMIC+0x248>
  70808d:	48 89 df             	mov    %rbx,%rdi
  708090:	e8 1b a3 3c 00       	call   ad23b0 <_Unwind_Resume@plt>
  708095:	48 89 c3             	mov    %rax,%rbx
  708098:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  70809d:	e8 1e 9b ff ff       	call   701bc0 <core::ptr::drop_glue::<core::result::Result<core::result::Result<gpui::element::Admission, gpui::source::BindError>, alloc::boxed::Box<dyn core::any::Any + core::marker::Send>>>>
  7080a2:	48 89 df             	mov    %rbx,%rdi
  7080a5:	e8 06 a3 3c 00       	call   ad23b0 <_Unwind_Resume@plt>
  7080aa:	ff 15 30 9f 3f 00    	call   *0x3f9f30(%rip)        # b01fe0 <_DYNAMIC+0x298>
